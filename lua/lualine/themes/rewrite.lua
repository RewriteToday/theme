local variant = vim.o.background == "light" and "day" or "night"
local palette = require("rewrite." .. variant)

return {
	normal = {
		a = { bg = palette.accent_strong, fg = palette.bg, gui = "bold" },
		b = { bg = palette.surface_alt, fg = palette.accent },
		c = { bg = palette.bg, fg = palette.fg },
	},
	insert = {
		a = { bg = palette.accent, fg = palette.bg, gui = "bold" },
		b = { bg = palette.surface_alt, fg = palette.accent_strong },
		c = { bg = palette.bg, fg = palette.fg },
	},
	visual = {
		a = { bg = palette.type_ref, fg = palette.bg, gui = "bold" },
		b = { bg = palette.surface_alt, fg = palette.type_ref },
		c = { bg = palette.bg, fg = palette.fg },
	},
	replace = {
		a = { bg = palette.error, fg = palette.bg, gui = "bold" },
		b = { bg = palette.surface_alt, fg = palette.error },
		c = { bg = palette.bg, fg = palette.fg },
	},
	command = {
		a = { bg = palette.comment, fg = palette.bg, gui = "bold" },
		b = { bg = palette.surface_alt, fg = palette.comment },
		c = { bg = palette.bg, fg = palette.fg },
	},
	inactive = {
		a = { bg = palette.bg, fg = palette.comment, gui = "bold" },
		b = { bg = palette.bg, fg = palette.comment },
		c = { bg = palette.bg, fg = palette.comment },
	},
}
