{ pkgs, ... }:

{
	home.packages = with pkgs; [
		clang-tools
		pyright
		nil
		rust-analyzer
		texlab
		nixd
	];

	programs.neovim = {
		plugins = with pkgs.vimPlugins; [
			nvim-lspconfig
			lsp-zero-nvim
			nvim-cmp
			cmp-nvim-lsp
			cmp-buffer
			cmp-path
			cmp_luasnip
			cmp-nvim-lua
		];
		extraLuaConfig = /* lua */ ''
			local lsp_zero = require('lsp-zero')

			lsp_zero.on_attach(function(client, bufnr)
				local opts = {buffer = bufnr, remap = false}

				vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
				vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
				vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
				vim.keymap.set("n", "<leader>dd", function() vim.diagnostic.open_float() end, opts)
				vim.keymap.set("n", "<leader>dn", function() vim.diagnostic.goto_next() end, opts)
				vim.keymap.set("n", "<leader>dp", function() vim.diagnostic.goto_prev() end, opts)
				vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
				vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
				vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
				vim.keymap.set("i", "<A-k>", function() vim.lsp.buf.signature_help() end, opts)
			end)

			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			vim.lsp.config('*', {
				on_attach = on_attach,
				capabilities = capabilities,
				root_markers = { '.git' },
			})

			vim.lsp.config('clangd', {
				cmd = {
					'clangd',
					'--background-index',
					'--clang-tidy',
					'--header-insertion=never',
					'--all-scopes-completion',
					'--log=error',
					'--compile-commands-dir=build',
					'--query-driver=/nix/store/*/bin/*',
				},
				root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git', '.jj' },
				filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'hpp' },
			})

			vim.lsp.config('pyright', {
				settings = {
					python = {
						analysis = {
							diagnosticSeverityOverrides = {
								reportUnusedExpression = "none",
							},
						},
					},
				},
			})

			vim.lsp.config('texlab', {})

			vim.lsp.config('rust_analyzer', {
			  on_attach = on_attach,
			  capabilities = capabilities,
			  root_markers = { 'Cargo.toml', 'rust-project.json', 'rust-toolchain.toml', '.git', '.jj' },
			  settings = {
				["rust-analyzer"] = {
				  cargo = { allFeatures = true },
				  checkOnSave = true,
				  check = { command = "clippy" },
				  procMacro = { enable = true },
				},
			  },
			})

			vim.lsp.enable('clangd')
			vim.lsp.enable('pyright')
			vim.lsp.enable('texlab')
			vim.lsp.enable('rust_analyzer')
			vim.lsp.enable('nil')
			vim.lsp.enable('nixd')

			local cmp = require('cmp')
			local cmp_select = { behavior = cmp.SelectBehavior.Select }


			require('luasnip.loaders.from_vscode').lazy_load()

			cmp.setup({
				sources = {
					{name = 'path'},
					{name = 'nvim_lsp'},
					{name = 'nvim_lua'},
					{name = 'luasnip', keyword_length = 2},
					{name = 'buffer', keyword_length = 3},
				},
				formatting = lsp_zero.cmp_format(),
				mapping = cmp.mapping.preset.insert({
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-h>'] = cmp.mapping.confirm({ select = true }),
					['<C-Space>'] = cmp.mapping.complete(),
				}),
			})
			'';
	};
}
