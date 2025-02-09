local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end



-- Bad way
-- return {
--   -- Example: text and insert nodes quickly become hard to read.
--   s({ trig = "eq", dscr = "A LaTeX equation environment" }, {
--     t({ -- using a table of strings for multiline text
--       "\\begin{equation}",
--       "    ",
--     }),
--     i(1),
--     t({
--       "",
--       "\\end{equation}",
--     }),
--   }),
-- }

-- better way
return {
  -- The same equation snippet, using LuaSnip's fmt function.
  -- The snippet is not shorter, but it is more *human-readable*.
  s(
    { trig = "eq", dscr = "A LaTeX equation environment" },
    fmta(
      [[
        \begin{equation*}
            <>
        \end{equation*}
      ]],
      { i(1) }
    )
  ),

  s(
    { trig = "beg", snippetType = "autosnippet", dscr = "Create basic environment" },
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      {
        i(1, "equation"),
        d(2, get_visual),
        rep(1), -- this node repeats insert node i(1)
      }
    )
  ),

  s(
    { trig = "mk", snippetType="autosnippet", dscr = "Inline Math Environment"},
    fmta("$<>$", {
      d(1, get_visual)
    })
  ),

  s(
    { trig = "dm", snippetType="autosnippet", dscr = "Multiline Math Environment"},
    fmta([[
    \[ 
      <>
    .\]
    ]], {
      d(1, get_visual)
    })
  ),

  -- Example: italic font implementing visual selection
  s(
    { trig = "tii", dscr = "Expands 'tii' into LaTeX's textit{} command." },
    fmta("\\textit{<>}", {
      d(1, get_visual),
    })
  ),

	-- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
	-- \item as necessary by utilizing a choiceNode.
	s("ls", {
		t({ "\\begin{itemize}", "\t\\item " }),
		i(1),
		d(2, rec_ls, {}),
		t({ "", "\\end{itemize}" }),
	}),
}
