local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    vim.notify('toggleterm is not found!')
    return
end

toggleterm.setup {
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = "curved",
    },
}

function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<cmd>exit<CR>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<c-h>", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<c-j>", [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<c-k>", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<c-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

local Terminal = require("toggleterm.terminal").Terminal
local unmap_key = function(term)
    if vim.fn.mapcheck('jk', 't') ~= '' then
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
        vim.api.nvim_buf_del_keymap(term.bufnr, 't', 'jk')
    end
end

local lazygit = Terminal:new { cmd = "lazygit", on_open = unmap_key, hidden = true }
function _LAZYGIT_TOGGLE()
    lazygit:toggle()
end

local btop = Terminal:new { cmd = "btop", on_open = unmap_key, hidden = true }
function _BTOP_TOGGLE()
    btop:toggle()
end

local float_term = Terminal:new {
    direction = "float",
    on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<c-2>", "<cmd>exit<CR><c-2>", { silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "i", "<c-2>", "<cmd>exit<CR><c-2>", { silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-2>", "<cmd>exit<CR><c-2>", { silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<c-3>", "<cmd>exit<CR><c-3>", { silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "i", "<c-3>", "<cmd>exit<CR><c-3>", { silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-3>", "<cmd>exit<CR><c-3>", { silent = true })
    end,
    count = 1,
}

function _FLOAT_TERM()
    float_term:toggle()
end

vim.api.nvim_set_keymap("n", "<c-1>", "<cmd>lua _FLOAT_TERM()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<c-1>", "<cmd>lua _FLOAT_TERM()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-1>", "<cmd>lua _FLOAT_TERM()<CR>", { noremap = true, silent = true })

local vertical_term = Terminal:new {
    direction = "vertical",
    on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<c-3>", "<cmd>exit<CR><c-3>", { silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "i", "<c-3>", "<cmd>exit<CR><c-3>", { silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-3>", "<cmd>exit<CR><c-3>", { silent = true })
    end,
    count = 2,
}

function _VERTICAL_TERM()
    vertical_term:toggle(60)
end

vim.api.nvim_set_keymap("n", "<c-2>", "<cmd>lua _VERTICAL_TERM()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<c-2>", "<cmd>lua _VERTICAL_TERM()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-2>", "<cmd>lua _VERTICAL_TERM()<CR>", { noremap = true, silent = true })

local horizontal_term = Terminal:new {
    direction = "horizontal",
    on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<c-2>", "<cmd>exit<CR><c-2>", { silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "i", "<c-2>", "<cmd>exit<CR><c-2>", { silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-2>", "<cmd>exit<CR><c-2>", { silent = true })
    end,
    count = 3,
}

function _HORIZONTAL_TERM()
    horizontal_term:toggle(10)
end

vim.api.nvim_set_keymap("n", "<c-3>", "<cmd>lua _HORIZONTAL_TERM()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<c-3>", "<cmd>lua _HORIZONTAL_TERM()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-3>", "<cmd>lua _HORIZONTAL_TERM()<CR>", { noremap = true, silent = true })
