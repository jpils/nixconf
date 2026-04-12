{ pkgs, ... }:

{
	plugins = with pkgs.vimPlugins; [
		neogen
	];

	lua = /* lua */ ''
		local neogen = require("neogen")

		neogen.setup({
			snippet_engine = "luasnip"
		})

		vim.keymap.set("n", "<leader>nf", function()
			neogen.generate({ type = "func" })
		end)

		vim.keymap.set("n", "<leader>nt", function()
			neogen.generate({ type = "type" })
		end)
	'';
}
