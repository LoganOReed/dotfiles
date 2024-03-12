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

local function isempty(s) --util 
    return s == nil or s == ''
end

local get_visual_for = function(args, parent, _, user_args) -- third argument is old_state, which we don't use
    if isempty(user_args) then
        ret = "" -- edit if needed
    else
        ret = user_args
    end
    if #parent.snippet.env.SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
    else -- If SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1, ret))
    end
end

return {
  s(
    { trig = "im", name = "import", dscr = "import as" },
    fmta(
      [[
        import <> as <>
      ]],
      {
        i(1, "numpy"),
        i(2, "np"),
      }
    )
  ),
  s(
    { trig = "main", dscr = "Main File Conditional"},
    fmta(
    [[
        if __name__ == "__main__":
            <>
    ]],
      {
        d(1, get_visual),
      }
    )
  ),
  s(
    { trig='for', dscr='For Loop'},
    fmta([[
    for <> in <>: 
        <>
    ]],
    { i(1, "i"), i(2, "range(10)"), d(3, get_visual_for, {}, {user_args = {"pass"}}) } -- leave the first table blank; that's for args which we are not using
    )
  ),
}

