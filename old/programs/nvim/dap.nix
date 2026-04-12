{ pkgs, ... }:
{
	home.packages = with pkgs; [
		vscode-extensions.vadimcn.vscode-lldb
	];

	programs.neovim = {
		plugins = with pkgs.vimPlugins; [
			nvim-dap
			nvim-dap-ui
			nvim-dap-virtual-text
		];
		initLua = /* lua */ ''
			require("telescope").setup({ extensions = { ["ui-select"] = {} } })
			require("telescope").load_extension("ui-select")

			local dap   = require("dap")
			local dapui = require("dapui")

			local function project_root()
				local cwd = vim.fn.getcwd()
				local hit = (vim.fs.find({ "CMakePresets.json", "CMakeLists.txt" }, { upward = true, path = cwd }) or {})[1]
				if hit then return vim.fs.dirname(hit) end
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients > 0 and clients[1].config and clients[1].config.root_dir then
					return clients[1].config.root_dir
				end
				return cwd
			end

			-- path is "hidden" if any segment starts with '.'
			local function is_hidden_rel(rel)
				if rel == "" then return false end
				if rel:sub(1,1) == "." then return true end
				return rel:find("/%.") ~= nil
			end

			-- Telescope-backed picker: only executables; if under build/, keep only build/src/*
			local function pick_exec_with_telescope()
				local root = project_root()
				local list = {}

				-- gather candidates (relative to root), then absolutize + filter
				local function gather(cmd)
					local lines = vim.fn.systemlist(cmd)
					for _, rel in ipairs(lines or {}) do
						if rel ~= "" and not is_hidden_rel(rel) then
							-- absolutize
							local abs = rel:match("^/") and rel or (root .. "/" .. rel)
							if vim.fn.executable(abs) == 1 then
								-- apply build/src filter
								local relp = abs:sub(#root + 2)  -- "./" removed -> relative path
								local in_build      = relp:match("^build/")
								local in_build_src  = relp:match("^build/src/")
								if (in_build and in_build_src) or (not in_build) then
									table.insert(list, abs)
								end
							end
						end
					end
				end

				if vim.fn.executable("fd") == 1 then
					-- executables only, include ignored (so build/ shows), exclude hidden by default
					local cmd = "cd " .. vim.fn.shellescape(root)
					.. " && fd --type x --follow --no-ignore --no-ignore-vcs --color=never ."
					gather(cmd)
				else
					-- find fallback: executable files; print paths relative to root
					local cmd = "cd " .. vim.fn.shellescape(root)
					.. " && find . -type f \\( -perm -u+x -o -perm -g+x -o -perm -o+x \\) -printf '%P\\n'"
					gather(cmd)
				end

				-- de-dup + sort
				local seen, uniq = {}, {}
				for _, p in ipairs(list) do
					if not seen[p] then seen[p] = true; table.insert(uniq, p) end
				end
				table.sort(uniq)

				if #uniq == 0 then
					return vim.fn.input("Path to executable: ", root .. "/", "file")
				end

				local co = coroutine.running()
				vim.ui.select(uniq, { prompt = "Select executable" }, function(choice)
					if not choice or choice == "" then
						choice = vim.fn.input("Path to executable: ", root .. "/", "file")
					end
					coroutine.resume(co, choice)
				end)
				return coroutine.yield()
			end

			dapui.setup({})
			require("nvim-dap-virtual-text").setup({})

			-- Nix paths for CodeLLDB
			local codelldb = [[${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb]]
			local liblldb  = [[${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.so]]

			dap.adapters.codelldb = {
				type = "executable",
				command = codelldb,
				args = { "--liblldb", liblldb },
			}

			dap.configurations.cpp = {
				{
					name = "Launch (pick binary)",
					type = "codelldb",
					request = "launch",
					program = function()
						return pick_exec_with_telescope()
					end,
					cwd = vim.fn.getcwd(),
					stopOnEntry = false,
					showDisassembly = "never",
					runInTerminal = true,
				},
			}

			dap.configurations.c    = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

			vim.keymap.set("n", "<space>db",  dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>dh", dap.run_to_cursor)
			vim.keymap.set("n", "<space>de",  function() require("dapui").eval(nil, { enter = true }) end)
			vim.keymap.set("n", "<space>dc", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
			vim.keymap.set('n', '<space>dB', function() require('dap').clear_breakpoints() end)

			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_back)
			vim.keymap.set("n", "<F3>", dap.restart)
			vim.keymap.set("n", "<F4>", dap.step_over)
			vim.keymap.set("n", "<F5>", dap.step_into)
			vim.keymap.set("n", "<F6>", dap.step_out)

			-- Auto open/close DAP UI
			dap.listeners.before.attach.dapui_config = function() dapui.open() end
			dap.listeners.before.launch.dapui_config = function() dapui.open() end
			dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
			dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

			vim.opt.signcolumn = "yes"
			vim.fn.sign_define("DapBreakpoint",         { text = "●" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "◌" })
			vim.fn.sign_define("DapStopped",            { text = "▶" })
			'';
	};
}
