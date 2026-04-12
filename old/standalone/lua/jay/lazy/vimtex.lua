return {
	"lervag/vimtex",
	config = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_view_general_viewer = "zathura"
		vim.g.vimtex_compiler_method = "latexmk"

		vim.keymap.set("n", "<leader>cc", "<cmd>VimtexCompile<cr>")
	end
}
