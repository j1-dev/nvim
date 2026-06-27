-- General editor options
-- See `:h vim.o` and `:h option-list`

local o = vim.o

o.number = true -- Show line numbers
o.relativenumber = true -- Relative line numbers (great for motions like 5j)

-- Sync clipboard with OS (scheduled to keep startup fast). See `:h 'clipboard'`
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		o.clipboard = "unnamedplus"
	end,
})

-- Searching
o.ignorecase = true
o.smartcase = true -- case-sensitive only if search has a capital letter

-- UI
o.cursorline = true
o.scrolloff = 10 -- keep 10 lines visible above/below cursor
o.signcolumn = "yes" -- always show sign column so text doesn't jump
o.list = true -- show whitespace
o.termguicolors = true -- 24-bit colors

-- Indentation (2 spaces, typical for JS/TS)
o.expandtab = true -- spaces instead of tabs
o.shiftwidth = 2 -- size of an indent
o.tabstop = 2 -- how many spaces a <Tab> counts for
o.softtabstop = 2
o.smartindent = true

-- Splits open in a more natural direction
o.splitright = true
o.splitbelow = true

-- Files
o.undofile = true -- persistent undo across sessions
o.swapfile = false

-- Ask to save instead of failing on :q with unsaved changes
o.confirm = true

-- Faster update time (used by LSP, gitsigns, etc.)
o.updatetime = 250

-- Better completion experience
o.completeopt = "menuone,noinsert,noselect"
o.pumheight = 12 -- limit popup menu height
