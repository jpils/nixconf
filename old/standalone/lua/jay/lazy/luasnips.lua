return {
	'L3MON4D3/LuaSnip',
	config = function()

		local ls = require "luasnip"
		local types = require "luasnip.util.types"

		-- Config
		ls.config.set_config {
			history = true,
			updateevents = "TextChanged, TextChangedI",
			enable_autosnippets = true,
			store_selection_keys = "<Tab>",
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { "<-", "Error" } },
					},
				},
			},
		}

		--snippet creator
		local s = ls.s
		--format node 
		--fmt(<fmt-string>, {nodes...})
		local fmt = require("luasnip.extras.fmt").fmt
		local fmta = require("luasnip.extras.fmt").fmta
		--insert node
		--i(<position>, [default_text])
		local i = ls.insert_node
		--text node
		--t{"line1", "line2"}
		local t = ls.text_node
		--reapetition node
		--rep(<position>)
		local rep = require("luasnip.extras").rep
		--choice node
		local c = ls.choice_node
		--function node
		local f = ls.function_node
		--snippet node
		local sn = ls.snippet_node
		--dynamic node
		local d = ls.dynamic_node

		--function 
		local line_begin = require("luasnip.extras.expand_conditions").line_begin
		--store visual selection after tab key press and paste into new snippet
		local get_visual = function(args, parent)
			if (#parent.snippet.env.SELECT_RAW > 0) then
				return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
			else  -- If SELECT_RAW is empty, return a blank insert node
				return sn(nil, i(1))
			end
		end
		--check if is in mathzone
		local in_mathzone = function()
			-- The `in_mathzone` function requires the VimTeX plugin
			return vim.fn['vimtex#syntax#in_mathzone']() == 1
		end

		--tex snippets
		ls.add_snippets(
			"tex", {

				--create environment
				s({trig = "env", snippetType="autosnippet"}, --snippetType = "autosnippet"},
					fmta(
						[[
					\begin{<>}
						<>
					\end{<>}
						]],
						{
							i(1),
							i(2),
							rep(1)
						}
					),
					{condition = line_begin}
				),

				--create equation environment
				s({trig = "nn", snippetType="autosnippet"},
					fmta(
						[[
					\begin{equation}
						<>
					\end{equation}
						]],
						{ i(1) }
					),
					{condition = line_begin}
				),

				--create aligned math
				s({trig = "al", snippetType="autosnippet"},
					fmta(
						[[
					\begin{aligned}
						<>
					\end{aligned}
						]],
						{ i(1) }
					),
					{condition = line_begin}
				),

				--create section
				s({trig = "h1", snippetType = "autosnippet"},
					fmta(
						[[\section{<>}
						<>
						]],
						{
							i(1),
							i(0)
						}
					),
					{condition = line_begin}
				),

				--create subsection
				s({trig = "h2", snippetType = "autosnippet"},
					fmta(
						[[\subsection{<>}
						<>
						]],
						{
							i(1),
							i(0)
						}
					),
					{condition = line_begin}
				),

				--create subsubsection
				s({trig = "h3", snippetType = "autosnippet"},
					fmta(
						[[\subsubsection{<>}
						<>
						]],
						{
							i(1),
							i(0)
						}
					),
					{condition = line_begin}
				),

				--create figure environmet
				s({trig = "fig", snippetType= "autosnippet"},
					fmta(
						[[
				\begin{figure}
					\centering
					\includegraphics[width=<>\textwidth]{<>}
					\caption{<>}
					\label{fig:<>}
				\end{figure}
						]],
						{
							i(1),
							i(2),
							i(3, "my_caption"),
							i(4, "my_label")
						}
					),
					{condition = line_begin}

				),

				--texttt 
				s({trig = "tt"},
					fmta(
						"\\texttt{<>}",
						{
							d(1, get_visual)
						}
					)
				),

				--textit
				s({trig = "tt"},
					fmta(
						"\\textit{<>}",
						{
							d(1, get_visual)
						}
					)
				),

				--textbf

				s({trig = "tt"},
					fmta(
						"\\textbf{<>}",
						{
							d(1, get_visual)
						}
					)
				),


				--fraction
				s({trig = 'ff', snippetType = "autosnippet"},
					fmta(
						[[<>\frac{<>}{<>}]],
						{
							f( function(_, snip) return snip.captures[1] end ),
							i(1),
							i(2)
						}
					),
					{condition = in_mathzone}
				),

				--exp
				s({trig = 'ee', snippetType="autosnippet"},
					fmta(
						"<>e^{<>}",
						{
							f( function(_, snip) return snip.captures[1] end ),
							i(1)
						}
					),
					{condition = in_mathzone}
				),

				--inline math
				s({trig = "([^%a])mm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
					fmta(
						"<>$<>$",
						{
							f( function(_, snip) return snip.captures[1] end ),
							d(1, get_visual)
						}
					)
				),

				--superscript
				s({trig = 'uu', snippetType="autosnippet"},
					fmta(
						"^{<>}",
						{
							i( 1 )
						}
					),
					{condition = in_mathzone}
				),

				--subscript
				s({trig = 'dd', snippetType="autosnippet"},
					fmta(
						"_{<>}",
						{
							i( 1 )
						}
					),
					{condition = in_mathzone}
				),

				--integral
				s({trig = "int", snippetType = "autosnippet"},
					fmta(
						"\\int_{<>}^{<>}",
						{
							i(1),
							i(2)
						}
					),
					{condition = in_mathzone}
				),

				--sum
				s({trig = "sum", snippetType = "autosnippet"},
					fmta(
						"\\sum_{<>}^{<>}",
						{
							i(1),
							i(2)
						}
					),
					{condition = in_mathzone}
				),

				--sqrt
				s({trig = "rt", snippetType = "autosnippet"},
					fmta(
						"\\sqrt{<>}",
						{
							i(1)
						}
					),
					{condition = in_mathzone}
				),

				--derivative
				s({trig = "df", snippetType = "autosnippet"},
					fmta(
						[[
				\frac{d}{d<>}
						]],
						{
							i(1)
						}
					),
					{condition = in_mathzone}
				),

				--partial derivative
				s({trig = "pdf", snippetType = "autosnippet"},
					fmta(
						[[
				\frac{\partial}{\partial<>}
						]],
						{
							i(1)
						}
					),
					{condition = in_mathzone}
				),

				--greek lowercase letters in mathzone
				s({trig=",a", snippetType="autosnippet"},
					{
						t("\\alpha"),
					}
				),
				s({trig=",b", snippetType="autosnippet"},
					{
						t("\\beta"),
					}
				),
				s({trig=",g", snippetType="autosnippet"},
					{
						t("\\gamma"),
					}
				),
				s({trig=",d", snippetType="autosnippet"},
					{
						t("\\delta"),
					}
				),
				s({trig=",e", snippetType="autosnippet"},
					{
						t("\\varepsilon"),
					}
				),
				s({trig=",t", snippetType="autosnippet"},
					{
						t("\\tau"),
					}
				),
				s({trig=",p", snippetType="autosnippet"},
					{
						t("\\pi"),
					}
				),
				s({trig=",x", snippetType="autosnippet"},
					{
						t("\\xi"),
					}
				),
				s({trig=",et", snippetType="autosnippet"},
					{
						t("\\eta"),
					}
				),
				s({trig=",m", snippetType="autosnippet"},
					{
						t("\\mu"),
					}
				),
				s({trig=",n", snippetType="autosnippet"},
					{
						t("\\nu"),
					}
				),

				--greek uppercase letters in mathzone
				s({trig=",A", snippetType="autosnippet"},
					{
						t("\\Alpha"),
					}
				),
				s({trig=",B", snippetType="autosnippet"},
					{
						t("\\Beta"),
					}
				),
				s({trig=",G", snippetType="autosnippet"},
					{
						t("\\Gamma"),
					}
				),
				s({trig=",D", snippetType="autosnippet"},
					{
						t("\\Delta"),
					}
				),
				s({trig=",E", snippetType="autosnippet"},
					{
						t("\\Varepsilon"),
					}
				),
				s({trig=",T", snippetType="autosnippet"},
					{
						t("\\Tau"),
					}
				),
				s({trig=",P", snippetType="autosnippet"},
					{
						t("\\Pi"),
					}
				),
				s({trig=",X", snippetType="autosnippet"},
					{
						t("\\Xi"),
					}
				),
				s({trig=",Et", snippetType="autosnippet"},
					{
						t("\\Eta"),
					}
				),
				s({trig=",M", snippetType="autosnippet"},
					{
						t("\\Mu"),
					}
				),
				s({trig=",N", snippetType="autosnippet"},
					{
						t("\\Nu"),
					}
				),
			}
		)

		-- Set Keymaps
		vim.keymap.set({ "i", "s" }, "<c-j>", function ()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<c-k>", function ()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-l>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end)

		vim.keymap.set({ "i", "s" }, "<C-h>", function()
			if ls.choice_active() then
				ls.change_choice(-1)
			end
		end)

		vim.keymap.set('n', '<leader><leader>s', '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/after/plugin/luasnip.lua"})<CR>')
	end
}
