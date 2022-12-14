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
	s({ trig = "h(%d)", name = "Title", regTrig = true, hidden = false }, {
		f(function(_, snip)
			return string.rep("#", snip.captures[1])
		end, {}),
	}),
	s(
		{ trig = "code", name = "Code Block" },
		fmt(
			[[
                ```{}
                {}
                ```
            ]],
			{
				c(1, {
					t("java"),
					t("shell"),
					t("yaml"),
					t("mysql"),
					t("bash"),
					t("dockerfile"),
					t("json"),
					t("nginx"),
					t("properties"),
				}),
				i(2, "code"),
			}
		)
	),
}
local autosnippets = {}
return snippets, autosnippets
