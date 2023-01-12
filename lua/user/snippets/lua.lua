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

local snippets = {
	s(
		"lv",
		fmt(
			[[
            local {} = function({})
                {}
            end
            ]],
			{
				i(1, "mysVar"),
				c(2, { t(""), i(1, "myArg") }),
				i(3, "-- TODO: something"),
			}
		)
	),
	s(
		"lf",
		fmt(
			[[ 
            local function {} ({})
                {}
            end
            {}
            ]],
			{ i(1, "name"), i(2, ""), i(3, "-- TODO"), i(0, "") }
		)
	),
	s(
		{ trig = "req", name = "protected require package" },
		fmt(
			[[
            local {}_status_ok, {} = pcall(require, "{}")
            if not {}_status_ok then
                vim.notify("{} is not found!")
                return
            end
            {}
            ]],
			{ rep(1), rep(1), i(1, "modename"), rep(1), rep(1), i(0, "") }
		)
	),
	s(
		"s",
		fmt(
			[[
            s(
                {},
                {}
            ),
            ]],
			{
				c(1, {
					sn(1, { t('"'), i(1, "trigger"), t('"') }),
					fmt([[ {{ trig = "{}", name = "{}", }} ]], { i(1, "trigger"), i(2, "name") }),
					fmt([[ {{ trig = "{}", name = "{}", regTrig = true, }} ]], { i(1, "trigger"), i(2, "name") }),
				}),
				c(2, {
					fmt(
						[=[
                        fmt(
                                [[
                                    {}
                                ]],
                                {{
                                    {},
                                }}
                            )
                        ]=],
						{
							i(1, "format"),
							c(2, {
								fmt([[rep({})]], i(1, "index")),
								fmt([[i({}, {})]], { i(1, "index"), i(2, "default") }),
								fmt(
									[[
                                        c({}, {{
                                                        {}
                                                    }})
                                    ]],
									{ i(1, "index"), i(2, "node") }
								),
								fmt([[f({})]], i(1, "func")),
							}),
						}
					),
					fmt(
						[[
                            {{
                                {},
                                }}
                        ]],
						c(1, {
							fmt([[rep({})]], i(1, "index")),
							fmt([[i({}, {})]], { i(1, "index"), i(2, "default") }),
							fmt(
								[[
                                    c({}, {{
                                            {}
                                        }})
                                ]],
								{ i(1, "index"), i(2, "node") }
							),
							fmt([[f({})]], i(1, "func")),
						})
					),
				}),
			}
		),
		{
			show_condition = function()
				local buf_name = vim.api.nvim_buf_get_name(0)
				return string.find(buf_name, "snippets")
			end,
		}
	),
	s({ trig = "insertNode", name = "Create insertNode" }, fmt([[i({}, "{}")]], { i(1, "index"), i(2, "default") }), {
		show_condition = function()
			local buf_name = vim.api.nvim_buf_get_name(0)
			return string.find(buf_name, "snippets")
		end,
	}),
	s({ trig = "choiceNode", name = "Create choiceNode" }, fmt([[c({}, {{{}}})]], { i(1, "index"), i(2, "default") }), {
		show_condition = function()
			local buf_name = vim.api.nvim_buf_get_name(0)
			return string.find(buf_name, "snippets")
		end,
	}),
	s({ trig = "textNode", name = "Create textNode" }, fmt([[t("{}")]], { i(1, "default") }), {
		show_condition = function()
			local buf_name = vim.api.nvim_buf_get_name(0)
			return string.find(buf_name, "snippets")
		end,
	}),
	s({ trig = "test[%d]", name = "name", regTrig = true }, {
		t("hello"),
	}),
}
local autosnippets = {
	s({ -- github import for packer{{{
		trig = "https://github%.com/([%w-%._]+)/([%w-%._]+)[/%w-%._]*\\",
		regTrig = true,
		hidden = true,
	}, {
		t([[use("]]),
		f(function(_, snip)
			return snip.captures[1]
		end),
		t("/"),
		f(function(_, snip)
			return snip.captures[2]
		end),
		t([[")]]),
	}, {
		condition = function()
			local buf_name = vim.api.nvim_buf_get_name(0)
			return string.find(buf_name, "plugins.lua")
		end,
	}),
}
return snippets, autosnippets
