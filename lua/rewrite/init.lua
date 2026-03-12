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
	local terminal = palette.terminal

	vim.g.terminal_color_0 = terminal.black
	vim.g.terminal_color_1 = terminal.red
	vim.g.terminal_color_2 = terminal.green
	vim.g.terminal_color_3 = terminal.yellow
	vim.g.terminal_color_4 = terminal.blue
	vim.g.terminal_color_5 = terminal.magenta
	vim.g.terminal_color_6 = terminal.cyan
	vim.g.terminal_color_7 = terminal.white
	vim.g.terminal_color_8 = terminal.bright_black
	vim.g.terminal_color_9 = terminal.bright_red
	vim.g.terminal_color_10 = terminal.bright_green
	vim.g.terminal_color_11 = terminal.bright_yellow
	vim.g.terminal_color_12 = terminal.bright_blue
	vim.g.terminal_color_13 = terminal.bright_magenta
	vim.g.terminal_color_14 = terminal.bright_cyan
	vim.g.terminal_color_15 = terminal.bright_white
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
