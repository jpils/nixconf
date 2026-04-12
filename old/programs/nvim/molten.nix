 # home.nix or wherever you configure neovim
{ pkgs, ... }:

{
    # ... other config
    programs.neovim = {
      # whatever other neovim configuration you have
      plugins = with pkgs.vimPlugins; [
        image-nvim # for image rendering
        molten-nvim
      ];
      extraPackages = with pkgs; [
        # ... other packages
        imagemagick # for image rendering
      ];
      extraLuaPackages = ps: [
        # ... other lua packages
        pkgs.luajitPackages.magick # for image rendering
      ];
      extraPython3Packages = ps: with ps; [
        # ... other python packages
        pynvim
        jupyter-client
        cairosvg # for image rendering
        pnglatex # for image rendering
        plotly # for image rendering
        pyperclip
		nbformat
      ];
	  initLua = /* lua */ ''
		-- I find auto open annoying, keep in mind setting this option will require setting
		-- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
		vim.g.molten_auto_open_output = false

		-- this guide will be using image.nvim
		-- Don't forget to setup and install the plugin if you want to view image outputs
		vim.g.molten_image_provider = "image.nvim"

		-- optional, I like wrapping. works for virt text and the output window
		vim.g.molten_wrap_output = true

		-- Output as virtual text. Allows outputs to always be shown, works with images, but can
		-- be buggy with longer images
		vim.g.molten_virt_text_output = true

		vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { desc = "Initialize Molten", silent = true })
		-- this will make it so the output shows up below the \`\`\` cell delimiter
		vim.api.nvim_create_autocmd("User", {
			pattern = "MoltenInitPost",
			callback = function()
			  -- quarto code runner mappings
			  local r = require("quarto.runner")
			  vim.keymap.set("n", "<leader>rc", r.run_cell, { desc = "run cell", silent = true })
			  vim.keymap.set("n", "<leader>ra", r.run_above, { desc = "run cell and above", silent = true })
			  vim.keymap.set("n", "<leader>rb", r.run_below, { desc = "run cell and below", silent = true })
			  vim.keymap.set("n", "<leader>rl", r.run_line, { desc = "run line", silent = true })
			  vim.keymap.set("n", "<leader>rA", r.run_all, { desc = "run all cells", silent = true })
			  vim.keymap.set("n", "<leader>RA", function()
				r.run_all(true)
			  end, { desc = "run all cells of all languages", silent = true })

			  -- setup some molten specific keybindings
			  vim.keymap.set("n", "<leader>e", ":MoltenEvaluateOperator<CR>",
				{ desc = "evaluate operator", silent = true })
			  vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
			  vim.keymap.set("v", "<leader>rv", ":<C-u>MoltenEvaluateVisual<CR>gv",
				{ desc = "execute visual selection", silent = true })
			  vim.keymap.set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>",
				{ desc = "open output window", silent = true })
			  vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
			  vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })
			  local open = false
			  vim.keymap.set("n", "<leader>ot", function()
				open = not open
				vim.fn.MoltenUpdateOption("auto_open_output", open)
			  end)

			  -- if we're in a python file, change the configuration a little
			  if vim.bo.filetype == "python" then
				vim.fn.MoltenUpdateOption("molten_virt_lines_off_by_1", false)
				vim.fn.MoltenUpdateOption("molten_virt_text_output", false)
			  end
			end,
		  })

		  -- change the configuration when editing a python file
		  vim.api.nvim_create_autocmd("bufenter", {
		    pattern = "*.py",
		    callback = function(e)
		  	if string.match(e.file, ".otter.") then
		  	  return
		  	end
		  	if require("molten.status").initialized() == "molten" then -- this is kinda a hack...
		  	  vim.fn.moltenupdateoption("virt_lines_off_by_1", false)
		  	  vim.fn.moltenupdateoption("virt_text_output", false)
		  	else
		  	  vim.g.molten_virt_lines_off_by_1 = false
		  	  vim.g.molten_virt_text_output = false
		  	end
		    end,
		  })

		  -- undo those config changes when we go back to a markdown or quarto file
		  vim.api.nvim_create_autocmd("bufenter", {
		    pattern = { "*.qmd", "*.md", "*.ipynb" },
		    callback = function(e)
		  	if string.match(e.file, ".otter.") then
		  	  return
		  	end
		  	if require("molten.status").initialized() == "molten" then
		  	  vim.fn.moltenupdateoption("virt_lines_off_by_1", true)
		  	  vim.fn.moltenupdateoption("virt_text_output", true)
		  	else
		  	  vim.g.molten_virt_lines_off_by_1 = true
		  	  vim.g.molten_virt_text_output = true
		  	end
		    end,
		  })
	  '';
	};
}
