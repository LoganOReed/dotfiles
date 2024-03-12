local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
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
}
