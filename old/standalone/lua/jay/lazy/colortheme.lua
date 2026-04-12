function Colorscheme(color)
	color = color or "catppuccin-mocha"
	vim.cmd.colorscheme(color)
end

return {
	{
		"catppuccin/nvim",
		config = function()

			require("catppuccin").setup({
				color_overrides = {
					mocha = {
						base = '#13111f'
					}
				}
			})

			vim.cmd("colorscheme catppuccin-mocha")
			Colorscheme()
		end
	}
}


