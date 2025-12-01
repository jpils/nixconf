{ pkgs, ... }:

{
	programs.neovim = {
		extraLuaConfig = /* lua */ ''

			vim.opt.nu = true
			vim.opt.relativenumber = true

			vim.opt.smartindent = true

			vim.opt.hlsearch = false
			vim.opt.incsearch = true

			vim.opt.scrolloff = 8

			vim.opt.updatetime = 50

			vim.opt.tabstop = 4
			vim.opt.softtabstop = 4
			vim.opt.shiftwidth = 0


			vim.api.nvim_create_augroup("tex_indent", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = "tex_indent",
				pattern = { "tex", "plaintex", "latex" },
				callback = function()
					vim.opt_local.shiftwidth = 2
					vim.opt_local.softtabstop = 2
					vim.opt_local.tabstop = 2
					vim.opt_local.expandtab = true
				end,
			})
		'';
	};
}
