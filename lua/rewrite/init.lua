local M = {
	options = {
		style = "auto",
		terminal_colors = true,
	},
}

local function resolve_variant(style)
	if style == nil or style == "auto" then
		return vim.o.background == "light" and "day" or "night"
	end

	if style == "dark" then
		return "night"
	end

	if style == "light" then
		return "day"
	end

	return style
end

local function apply_terminal_colors(palette)
	vim.g.terminal_color_0 = palette.bg
	vim.g.terminal_color_1 = palette.error
	vim.g.terminal_color_2 = palette.git_add
	vim.g.terminal_color_3 = palette.warning
	vim.g.terminal_color_4 = palette.info
	vim.g.terminal_color_5 = palette.type_ref
	vim.g.terminal_color_6 = palette.accent
	vim.g.terminal_color_7 = palette.fg_soft
	vim.g.terminal_color_8 = palette.comment
	vim.g.terminal_color_9 = palette.error
	vim.g.terminal_color_10 = palette.success
	vim.g.terminal_color_11 = palette.accent
	vim.g.terminal_color_12 = palette.info
	vim.g.terminal_color_13 = palette.type_ref
	vim.g.terminal_color_14 = palette.accent
	vim.g.terminal_color_15 = palette.fg
end

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", M.options, options or {})
end

function M.load(style, colors_name)
	local variant = resolve_variant(style or M.options.style)
	local ok, palette = pcall(require, "rewrite." .. variant)

	if not ok then
		error("rewrite.nvim: unknown style '" .. tostring(variant) .. "'")
	end

	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") == 1 then
		vim.cmd("syntax reset")
	end

	vim.o.termguicolors = true
	vim.o.background = variant == "day" and "light" or "dark"
	vim.g.colors_name = colors_name or (variant == "day" and "rewrite-day" or "rewrite-night")

	local highlights = require("rewrite.base").highlights(palette)

	for group, spec in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, spec)
	end

	if M.options.terminal_colors then
		apply_terminal_colors(palette)
	end

	return palette
end

return M
