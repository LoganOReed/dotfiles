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

return {
  -- ([^%w]) prevents expansion if ;b is typed after any alphanumeric
  -- ([^%a]) for just alpha
  -- s(
  --   { trig = "([^%w]);a", regTrig=true, wordTrig=false, name="alpha", dscr = "greek letter alpha"},
  --   fmta(
  --     [[
  --       \\alpha 
  --     ]]
  --   )
  -- ),
  -- s(
  --   { trig = "([^%w]);A", regTrig=true, wordTrig=false, name="Alpha", dscr = "greek letter Alpha"},
  --   fmta(
  --     [[
  --       \\Alpha 
  --     ]]
  --   )
  -- ),
  -- s(
  --   { trig = "([^%w]);b", regTrig=true, wordTrig=false, name="beta", dscr = "greek letter beta"},
  --   fmta(
  --     [[
  --       \\beta 
  --     ]]
  --   )
  -- ),
  -- s(
  --   { trig = "([^%w]);B", regTrig=true, wordTrig=false, name="Beta", dscr = "greek letter Beta"},
  --   fmta(
  --     [[
  --       \\Beta 
  --     ]]
  --   )
  -- ),
  -- s(
  --   { trig = "([^%w]);g", regTrig=true, wordTrig=false, name="gamma", dscr = "greek letter gamma"},
  --   fmta(
  --     [[
  --       \\gamma 
  --     ]]
  --   )
  -- ),
  -- s(
  --   { trig = "([^%w]);G", regTrig=true, wordTrig=false, name="Gamma", dscr = "greek letter Gamma"},
  --   fmta(
  --     [[
  --       \\Gamma 
  --     ]]
  --   )
  -- ),

s({trig = '([^%a])ee', regTrig = true, wordTrig = false},
  fmta(
    "<>e^{<>}",
    {
      f( function(_, snip) return snip.captures[1] end ),
      d(1, get_visual)
    }
  )
),

  postfix(
    {trig = "bb", name = "bar", dscr = "creates overline", snippetType = "autosnippet", wordTrig = false},
	    l("\\overline{" .. l.POSTFIX_MATCH .. "}"),
      {condition = in_mathzone}
    ),
  postfix(
    {trig = ";m", name = "magnitude", dscr = "Magnitude", snippetType = "autosnippet", wordTrig = false},
      l("|" .. l.POSTFIX_MATCH .. "|"),
      {condition = in_mathzone}
    ),
  postfix(
    {trig = ";n", name = "Norm", dscr = "Norm", snippetType = "autosnippet", wordTrig = false},
      l("||" .. l.POSTFIX_MATCH .. "||"),
      {condition = in_mathzone}
    ),

}
