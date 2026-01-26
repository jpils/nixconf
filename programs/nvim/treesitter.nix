{ pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # 1. Removed the duplicate nvim-treesitter entry
      (nvim-treesitter.withPlugins (p: with p; [
        bash c cpp css lua python java markdown nix rust query javascript typescript
      ]))
      nvim-treesitter-textobjects
    ];

    extraLuaConfig = /* lua */ ''
	  require'nvim-treesitter'.setup {
		  auto_install = false,
		  indent = {
			  enable = true,
		  },
		  highlight = { 
			  -- false will disable the whole extension enable = true, 
			  -- Setting this to true will run :h syntax and tree-sitter at the same time. 
			  -- Set this to true if you depend on "syntax" being enabled (like for indentation). 
			  -- Using this option may slow down your editor, and you may see some duplicate highlights. 
			  -- Instead of true it can also be a list of languages 
			  additional_vim_regex_highlighting = false, 
			  disable = {
				  "latex" 
			  }, 
		  },
	  }

      require('nvim-treesitter-textobjects').setup({
        move = {
          enable = true,
          set_jumps = false,
          goto_next_start = {
            ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
          },
          goto_previous_start = {
            ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
          },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ib"] = { query = "@code_cell.inner", desc = "in block" },
            ["ab"] = { query = "@code_cell.outer", desc = "around block" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sbl"] = "@code_cell.outer",
          },
          swap_previous = {
            ["<leader>sbh"] = "@code_cell.outer",
          },
        },
      })
    '';
  };

  home.file.".config/nvim/after/queries/markdown/textobjects.scm".text = ''
    (fenced_code_block (code_fence_content) @code_cell.inner) @code_cell.outer
  '';
}
