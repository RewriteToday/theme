<div align="center">

# Rewrite Theme for Neovim

The official Rewrite theme for Neovim.

Bring the same Rewrite palette into Neovim with an automatic colorscheme, explicit dark and light variants, and a matching `lualine` theme.

[Repository](https://github.com/RewriteToday/theme) • [Website](https://rewritetoday.com) • [Dashboard](https://dash.rewritetoday.com)

</div>

<div align="center">

## Install

This directory is documentation only. The installable Neovim runtime is exposed at the repository root on purpose, so plugin managers can install it directly from GitHub.

</div>

```lua
{
  "RewriteToday/theme",
  name = "rewrite.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("rewrite").setup({ style = "auto" })
    vim.cmd.colorscheme("rewrite")
  end,
}
```

<div align="center">

Use an explicit variant if you want to lock the editor to one mode:

</div>

```lua
vim.cmd.colorscheme("rewrite-night")
vim.cmd.colorscheme("rewrite-day")
```

<div align="center">

`rewrite` follows `vim.o.background`.  
`rewrite-night` and `rewrite-day` always force the matching palette.

</div>

```lua
require("lualine").setup({
  options = {
    theme = "rewrite",
  },
})
```

<div align="center">

## What ships in this package

</div>

```text
colors/
├─ rewrite.lua
├─ rewrite-night.lua
└─ rewrite-day.lua
lua/rewrite/
├─ init.lua
├─ base.lua
├─ night.lua
└─ day.lua
lua/lualine/themes/
└─ rewrite.lua
```

<div align="center">

Made with love by the Rewrite team. <br/>
SMS the way it should be.

</div>
