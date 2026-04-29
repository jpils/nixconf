{ pkgs, ... }:

{
	plugins = with pkgs.vimPlugins; [
		trouble-nvim
	];

	lua = /* lua */ ''
		vim.opt.swapfile = false
		vim.opt.backup = false
		vim.opt.writebackup = false

		require("trouble").setup({
				icons = { enabled = false },
				})

		vim.keymap.set("n", "<leader>tr", "<cmd>Trouble diagnostics toggle<cr>")

		vim.keymap.set("n", "<leader>tt", function()
				require("trouble").toggle("diagnostics")
				end)

		-- Navigation (Teleporting)
		vim.keymap.set("n", "<leader>tp", function()
				require("trouble").prev({ skip_groups = true, jump = true })
				end)

		vim.keymap.set("n", "<leader>tn", function()
				require("trouble").next({ skip_groups = true, jump = true })
				end)

		-- Telescope Integration
		local telescope = require("telescope")
		local trouble = require("trouble.sources.telescope")

		telescope.setup {
			defaults = {
				mappings = {
					i = { ["<c-t>"] = trouble.open },
					n = { ["<c-t>"] = trouble.open },
				},
			},
		}
	'';
}
