return {
	{
		"iamcco/markdown-preview.nvim",
		config = function()
			vim.cmd([[
            function OpenMarkdownPreview (url)
                execute "silent ! open -na 'Google Chrome' --args --new-window " . a:url
                sleep 500m
                " execute "silent ! yabai -m window  $(yabai -m query --windows --space 2 | jq '[.[].id]|max') --space 1"
                " execute "silent ! yabai -m space --focus 1"
                execute "silent ! yabai -m window --focus prev"
            endfunction
            let g:mkdp_browserfunc = 'OpenMarkdownPreview'
            ]])
		end,
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		ft = "markdown",
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview" },
		},
	},
	{ "dhruvasagar/vim-table-mode", cmd = "TableModeEnable" },
}
