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


return {
  s(
    { trig = "var", name="Variable Declaration", dscr = "Declares Variable"},
    fmta(
      [[
        <><>
      ]],
      {
        c(1, {t("integer"),t("real"),t("logical"),t("complex"),t("character")}),
        c(2, {
          sn(nil, {
            t(" :: "),
            i(1),
          }),
          sn(nil, {
            t(", "),
            i(1),
            c(2, {
              sn(nil, {
                t("dimension("),
                i(1, "10"),
                t(") :: "),
                i(2, "x"),
              }),
              sn(nil, {
                t("allocatable :: "),
                i(1, "x"),
                t("("),
                i(2, ":"),
                t(")"),
              }),
            }),
          }),
        }),
      }
    )
  ),
  s(
    { trig = "if", name="if", dscr = "if"},
    fmta(
      [[
        if (<>) then
          <>
        end if
        <>
      ]],
      {
        i(1),
        i(2),
        i(0)
      }
    )
  ),
  s(
    { trig = "elif", name="else if", dscr = "else if"},
    fmta(
      [[
        else if (<>) then
          <>
      ]],
      {
        i(1),
        i(2),
      }
    )
  ),
  s(
    { trig = "else", name="else", dscr = "else"},
    fmta(
      [[
        else
          <>
      ]],
      {
        i(1),
      }
    )
  ),
  s(
    { trig = "do", name="do", dscr = "do"},
    fmta(
      [[
        do <> = <>, <>
          <>
        end do
        <>
      ]],
      {
        i(1, "i"),
        i(2, "1"),
        i(3, "10"),
        i(4),
        i(0),
      }
    )
  ),
  s(
    { trig = "wh", name="while", dscr = "while"},
    fmta(
      [[
        do while (<>)
          <>
        end do
        <>
      ]],
      {
        i(1, "bool"),
        i(2),
        i(0),
      }
    )
  ),
  
  
}
