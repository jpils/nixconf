{ pkgs, ... }:

{
	plugins = with pkgs.vimPlugins; [
		render-markdown-nvim
		image-nvim
	];

	extraPackages = with pkgs; [
		luajit
		python3
		python313Packages.pylatexenc
	];

	lua = /* lua */ ''
		require("render-markdown").setup({
			file_types = { "markdown", "norg", "rmd" },
			math = {
				enabled = true,
				latex = {
					enabled = true,
				},
			},
			code = {
				sign = false,
				style = "language",
				left_pad = 2,
				right_pad = 2,
				min_width = 20,
				border = "thin",
				above = "▄",
				below = "▀",
			},
			heading = {
				sign = false,
				icons = { "󰲡 ", "󰲢 ", "󰲣 ", "󰲤 ", "󰲥 ", "󰲦 " },
				backgrounds = {},
				foregrounds = { "RenderMarkdownH1", "RenderMarkdownH2", "RenderMarkdownH3", "RenderMarkdownH4", "RenderMarkdownH5", "RenderMarkdownH6" },
				left_pad = 0,  -- Remove left padding/indentation
				right_pad = 0,  -- Remove right padding
			},
			checkbox = {
				unchecked = "󰄱 ",
				checked = "󰱒 ",
			},
		})

		-- Set heading highlight groups with distinct colors
		vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#88C0D0", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#81A1C1", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#5E81AC", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#A3BE8C", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#EBCB8B", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#B48EAD", bold = true })

		-- Auto-enable rendering when entering markdown files
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "markdown", "norg", "rmd" },
			callback = function()
				require("render-markdown").enable()
			end,
		})

		-- Toggle keybinding for manual control
		vim.keymap.set("n", "<leader>md", function()
			require("render-markdown").toggle()
		end, { noremap = true, silent = true, desc = "Toggle markdown render" })

		-- images in nvim
		require("image").setup({
			backend = "kitty",  -- Ghostty supports kitty protocol
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki" }
				},
				neorg = {
					enabled = true,
				},
			},
			max_width = 100,
			max_height = 100,
			window_overlap_clear = {
				enable = true,
				kind = "background",
			},
		})
	'';
}
