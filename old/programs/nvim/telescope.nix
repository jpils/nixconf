{ pkgs, ... }:

{
	programs.neovim = {
		plugins = with pkgs; [
			fd
			vimPlugins.telescope-nvim
			vimPlugins.telescope-ui-select-nvim
			
		];
		initLua = /* lua */ ''
			--require('telescope').setup({})
			require("telescope").setup({ extensions = { ["ui-select"] = {} } })
			require("telescope").load_extension("ui-select")
			local builtin = require('telescope.builtin')
			--vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({
					hidden = false,
					no_ignore = true,
					no_ignore_parent = true,
					follow = true,
				})
			end, { desc = "Files (ALL, incl. ignored)" })
			vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
			vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
			vim.keymap.set('n', '<leader>fs', function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)
			'';
	};
}
