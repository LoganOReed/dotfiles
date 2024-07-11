# Various Notes for Snippet Stuff

## Anatomy of a LuaSnippet snippet
```lua
-- Anatomy of a LuaSnip snippet
require("luasnip").snippet(
  snip_params:table,  -- table of snippet parameters
  nodes:table,        -- table of snippet nodes
  opts:table|nil      -- *optional* table of additional snippet options
)
```

```lua
-- Alternative: using the fmt function to create the node table
require("luasnip").snippet(
  snip_params:table,
  fmt(args),          -- fmt returns the node table
  opts:table|nil
)
```


## Example Hello World Snippet
```lua
  -- Example: how to set snippet parameters
  require("luasnip").snippet(
    { -- Table 1: snippet parameters
      trig="hi",
      dscr="An autotriggering snippet that expands 'hi' into 'Hello, world!'",
      regTrig=false,
      priority=100,
      snippetType="autosnippet"
    },
    { -- Table 2: snippet nodes (don't worry about this for now---we'll cover nodes shortly)
      t("Hello, world!"), -- A single text node
    }
    -- Table 3, the advanced snippet options, is left blank.
  ),
```

# Node Types

## Text Node (t)
Inserts static text into a snippet.
To make it multiple lines seperate lines into distinct arguments.

## Insert Node (i)
Indexed with optional initial value.

## Repeated Nodes (rep)
Used to repeat insert nodes like in UltiSnips.
To repeat an insert node, use its index.

## Format Node (fmt/fmta)
Gives a way to define snippets in a more readable way (kinda like jsx).
fmt uses {} as placeholder
fmta uses <> as placeholder
To use placeholder literal just repeat them (e.g. {{}} or <<>>)
### Example
```lua
return {
-- The same equation snippet, using LuaSnip's fmt function.
-- The snippet is not shorter, but it is more *human-readable*.
s({trig="eq", dscr="A LaTeX equation environment"},
  fmt( -- The snippet code actually looks like the equation environment it produces.
    [[
      \begin{equation}
          <>
      \end{equation}
    ]],
    -- The insert node is placed in the <> angle brackets
    { i(1) },
    -- This is where I specify that angle brackets are used as node positions.
    { delimiters = "<>" }
  )
),
}
```

## Dynamic Node
For now just used for visual.

### Visual Workaround
To use this, put get_visual in a dynamic node.
```lua
-- add this to top of every snippet file
local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

```


