{ pkgs, ... }: 

{
	programs.neovim = {
		plugins = with pkgs.vimPlugins; [
			quarto-nvim
			otter-nvim
		];
		initLua = /* lua */ ''
			local quarto = require("quarto")
		    quarto.setup({
		      lspFeatures = {
		        languages = { "python", "rust", "lua" },
		        chunks = "all", -- 'curly' or 'all'
		        diagnostics = {
		      	enabled = true,
		      	triggers = { "BufWritePost" },
		        },
		        completion = {
		      	enabled = true,
		        },
		      },
		      keymap = {
		        hover = "H",
		        definition = "gd",
		        rename = "<leader>rn",
		        references = "gr",
		        format = "<leader>gf",
		      },
		      codeRunner = {
		        enabled = true,
		        ft_runners = {
		      	bash = "slime",
		        },
		        default_method = "molten",
		      },
		    })

		    vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { desc = "Preview the Quarto document", silent = true, noremap = true })
		    -- to create a cell in insert mode, I have the ` snippet
		    vim.keymap.set("n", "<leader>cc", "i`<c-j>", { desc = "Create a new code cell", silent = true })
		    vim.keymap.set("n", "<leader>cs", "i```\r\r```{}<left>", { desc = "Split code cell", silent = true, noremap = true })
		'';
	};
	home.file.".config/nvim/ftplugin/markdown.lua".text = ''
		require("quarto").activate()
	'';
}
