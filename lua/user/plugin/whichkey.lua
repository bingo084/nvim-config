local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    vim.notify('which_key is not found!')
    return
end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "center", -- align columns left, center or right
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    show_keys = true, -- show the currently pressed key and its label as a message in the command line
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
    -- disable the WhichKey popup for certain buf types and file types.
    -- Disabled by deafult for Telescope
    disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
    },
}

local m_opts = {
    mode = "n", -- NORMAL mode
    prefix = "m",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local m_mappings = {
    a = { "<cmd>silent BookmarkAnnotate<cr>", "Annotate" },
    c = { "<cmd>silent BookmarkClear<cr>", "Clear" },
    b = { "<cmd>silent BookmarkToggle<cr>", "Toggle" },
    m = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Harpoon" },
    ["."] = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', "Harpoon Next" },
    [","] = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', "Harpoon Prev" },
    l = { "<cmd>lua require('user.bfs').open()<cr>", "Buffers" },
    j = { "<cmd>silent BookmarkNext<cr>", "Next" },
    s = { "<cmd>Telescope harpoon marks<cr>", "Search Files" },
    k = { "<cmd>silent BookmarkPrev<cr>", "Prev" },
    S = { "<cmd>silent BookmarkShowAll<cr>", "Prev" },
    -- s = {
    --   "<cmd>lua require('telescope').extensions.vim_bookmarks.all({ hide_filename=false, prompt_title=\"bookmarks\", shorten_path=false })<cr>",
    --   "Show",
    -- },
    x = { "<cmd>BookmarkClearAll<cr>", "Clear All" },
    [";"] = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon UI" },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    ["a"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Action" },
    ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    ["\\"] = { "<cmd>vsplit<cr>", "Vsplit" },
    ["-"] = { "<cmd>split<cr>", "Split" },
    ["w"] = { "<cmd>w<CR>", "Write" },
    ["q"] = { '<cmd>lua require("user.functions").smart_quit()<CR>', "Quit" },
    ["/"] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', "Comment" },
    ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },

    d = {
        name = "Debug",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
        o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
        O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
        r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
        l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
        u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
        x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
    },

    f = {
        name = "Find",
        b = {
            "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal'})<cr>",
            "Buffer",
        },
        c = {
            "<cmd>lua require('telescope.builtin').colorscheme(require('telescope.themes').get_cursor{enable_preview=true})<cr>",
            "Colorscheme"
        },
        C = { "<cmd>lua require('telescope.builtin').commands()<cr>", "Commands" },
        f = {
            "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
            "File",
        },
        h = { "<cmd>lua require('telescope.builtin').help_tags(require('telescope.themes').get_ivy())<cr>", "Help" },
        k = { "<cmd>lua require('telescope.builtin').keymaps()<cr>", "Keymaps" },
        l = { "<cmd>lua require('telescope.builtin').resume()<cr>", "Last Search" },
        M = { "<cmd>lua require('telescope.builtin').man_pages()<cr>", "Man Pages" },
        p = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
        r = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Recent File" },
        R = { "<cmd>lua require('telescope.builtin').registers()<cr>", "Registers" },
        t = {
            "<cmd>lua require('telescope.builtin').live_grep(require('telescope.themes').get_ivy())<cr>",
            "Text",
        },
        w = {
            "<cmd>lua require('telescope.builtin').grep_string(require('telescope.themes').get_ivy())<cr>",
            "Word",
        },
    },

    g = {
        name = "Git",
        b = { "<cmd>lua require('telescope.builtin').git_branches(require('telescope.themes').get_ivy())<cr>",
            "List branch" },
        c = { "<cmd>lua require('telescope.builtin').git_commits(require('telescope.themes').get_ivy())<cr>",
            "List Commit" },
        C = { "<cmd>lua require('telescope.builtin').git_bcommits(require('telescope.themes').get_ivy())<cr>",
            "List Buffer Commit" },
        d = {
            "<cmd>Gitsigns diffthis HEAD<cr>",
            "Diff",
        },
        g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
        j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
        k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
        l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
        o = { "<cmd>lua require('telescope.builtin').git_status()<cr>", "Open changed file" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
        s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
        u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
    },

    l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        c = { "<cmd>lua require('user.plugin.lsp').server_capabilities()<cr>", "Get Capabilities" },
        d = { "<cmd>TroubleToggle<cr>", "Diagnostics" },
        w = { "<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<cr>", "Workspace Diagnostics" },
        f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
        F = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        h = { "<cmd>IlluminationToggle<cr>", "Toggle Doc HL" },
        I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
        j = { "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", "Next Diagnostic" },
        k = { "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Prev Diagnostic" },
        l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
        o = { "<cmd>SymbolsOutline<cr>", "Outline" },
        q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
        s = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "Document Symbols" },
        S = { "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", "Workspace Symbols", },
        t = { '<cmd>lua require("user.functions").toggle_diagnostics()<cr>', "Toggle Diagnostics" },
        u = { "<cmd>LuaSnipUnlinkCurrent<cr>", "Unlink Snippet" },
    },

    o = {
        name = "Options",
        w = { '<cmd>lua require("user.functions").toggle_option("wrap")<cr>', "Wrap" },
        r = { '<cmd>lua require("user.functions").toggle_option("relativenumber")<cr>', "Relative" },
        l = { '<cmd>lua require("user.functions").toggle_option("cursorline")<cr>', "Cursorline" },
        s = { '<cmd>lua require("user.functions").toggle_option("spell")<cr>', "Spell" },
        t = { '<cmd>lua require("user.functions").toggle_tabline()<cr>', "Tabline" },
    },

    p = {
        name = "Packer",
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        S = { "<cmd>PackerStatus<cr>", "Status" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    s = {
        name = "Session",
        s = { "<cmd>SaveSession<cr>", "Save" },
        r = { "<cmd>RestoreSession<cr>", "Restore" },
        x = { "<cmd>DeleteSession<cr>", "Delete" },
        f = { "<cmd>SearchSession<cr>", "Find" },
        d = { "<cmd>Autosession delete<cr>", "Find Delete" },
    },

    t = {
        name = "Terminal",
        ["1"] = { ":1ToggleTerm<cr>", "1" },
        ["2"] = { ":2ToggleTerm<cr>", "2" },
        ["3"] = { ":3ToggleTerm<cr>", "3" },
        ["4"] = { ":4ToggleTerm<cr>", "4" },
        b = { "<cmd>lua _BTOP_TOGGLE()<cr>", "Btop" },
        f = { "<cmd>lua _FLOAT_TERM()<cr>", "Float" },
        ["-"] = { "<cmd>lua _HORIZONTAL_TERM()<cr>", "Horizontal" },
        ["\\"] = { "<cmd>lua _VERTICAL_TERM()<cr>", "Vertical" },
    },

    T = {
        name = "Treesitter",
        h = { "<cmd>TSHighlightCapturesUnderCursor<cr>", "Highlight" },
        p = { "<cmd>TSPlaygroundToggle<cr>", "Playground" },
        r = { "<cmd>TSToggle rainbow<cr>", "Rainbow" },
    },
}

local vopts = {
    mode = "v", -- VISUAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {
    ["/"] = { '<esc><cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<cr>', "Comment" },
    s = { "<esc><cmd>'<,'>SnipRun<cr>", "Run range" },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(m_mappings, m_opts)
