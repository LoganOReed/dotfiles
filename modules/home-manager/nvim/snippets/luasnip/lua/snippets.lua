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

return {
  s(
    { trig = "snipset", dscr = "setup for snip file" },
    fmt(
      [[
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

      ]],
      {},
      {}
    )
  ),

  ---------------------------------
  ---       SNIPPET NODES       ---
  ---------------------------------
  s("sp", {
    t('s("'),
    i(1, "snippet_title"),
    t({ '", {', "\t" }),
    i(0, "snippet_body"),
    t({ "", "})," }),
  }),

  s(
    { trig = "snn", dscr = "snippet snippet", snippetType = "autosnippet" },
    fmta(
      [=[
          s(
            { trig = "<>", name="<>", dscr = "<>"},
            fmta(
              [[
                <>
              ]],
              {
                <>
              }
            )
          ),

      ]=],
      {
        i(1, "Trigger"),
        i(2, "Name"),
        i(3, "Description"),
        d(4, get_visual),
        i(5, "Nodes"),
      }
    )
  ),

  s(
    { trig = "sna", dscr = "autosnippet snippet", snippetType = "autosnippet" },
    fmta(
      [=[
          s(
            { trig = "<>", name="<>", dscr = "<>", snippetType = "autosnippet" },
            fmta(
              [[
                <>
              ]],
              {
                <>
              }
            )
          ),

      ]=],
      {
        i(1, "Trigger"),
        i(2, "Name"),
        i(3, "Description"),
        d(4, get_visual),
        i(5, "Nodes"),
      }
    )
  ),

  s(
    { trig = "i", name = "i()", dscr = "i() node" },
    fmta(
      [[
        i(<>, <>),
      ]],
      {
        i(1, "1"),
        i(2, "temp"),
      }
    )
  ),

  s(
    { trig = "t", name = "t()", dscr = "text node" },
    fmt('t("{}"),', {
      i(1, "text"),
    })
  ),

  s(
    { trig = "d", name = "d()", dscr = "$VISUAL node" },
    fmta(
      [[
        d(<>, get_visual),
      ]],
      {
        i(1, "1"),
      }
    )
  ),
}
