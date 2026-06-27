-- Dark 2026 — a Neovim colorscheme recreated from VS Code Insiders' "Dark 2026"
-- theme. Colors sampled directly from the editor (incl. a real TypeScript file)
-- so the syntax mapping matches VS Code closely. Lives in colors/ so
-- `:colorscheme dark2026` works and it shows up in the <leader>ut picker.

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') == 1 then
  vim.cmd('syntax reset')
end
vim.o.background = 'dark'
vim.g.colors_name = 'dark2026'

local c = {
  bg          = '#121314', -- editor background (sampled)
  bg_sidebar  = '#191a1b', -- sidebar / non-current windows (sampled)
  bg_float    = '#0e0f10',
  cursorline  = '#242526', -- current line (sampled)
  bg_visual   = '#264f6e', -- selection
  bg_sel_soft = '#1d2733',
  fg          = '#c9d1d9', -- main text / punctuation / object keys (sampled)
  fg_dim      = '#858889', -- line numbers (sampled)
  fg_muted    = '#6e7173',
  comment     = '#8b949e', -- comments (sampled)
  purple      = '#c586c0', -- keywords: import/from/export/if/return/await (sampled)
  blue        = '#569cd6', -- async (sampled)
  lavender    = '#d2a8ff', -- functions, methods (sampled)
  teal        = '#4ec9b0', -- types, classes, async (sampled)
  light_blue  = '#79c0ff', -- variables, properties, numbers, constants (sampled)
  string      = '#a5d6ff', -- strings (sampled)
  orange      = '#ffa657', -- parameters (sampled)
  red         = '#ff7b72', -- jsdoc tags / errors / removed (sampled)
  yellow      = '#d7ba7d',
  green       = '#6a9f5b', -- added / success
  border      = '#2a2c2e',
  none        = 'NONE',
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local groups = {
  -- Editor UI
  Normal       = { fg = c.fg, bg = c.bg },
  NormalNC     = { fg = c.fg, bg = c.bg },
  NormalFloat  = { fg = c.fg, bg = c.bg_float },
  FloatBorder  = { fg = c.border, bg = c.bg_float },
  FloatTitle   = { fg = c.light_blue, bg = c.bg_float, bold = true },
  ColorColumn  = { bg = c.bg_sidebar },
  Cursor       = { fg = c.bg, bg = c.fg },
  CursorLine   = { bg = c.cursorline },
  CursorColumn = { bg = c.cursorline },
  CursorLineNr = { fg = c.fg, bold = true },
  LineNr       = { fg = c.fg_dim },
  SignColumn   = { bg = c.none },
  Folded       = { fg = c.comment, bg = c.bg_sidebar },
  FoldColumn   = { fg = c.fg_dim },
  VertSplit    = { fg = c.border },
  WinSeparator = { fg = c.border },
  Visual       = { bg = c.bg_visual },
  Search       = { fg = c.bg, bg = c.yellow },
  IncSearch    = { fg = c.bg, bg = c.orange },
  CurSearch    = { fg = c.bg, bg = c.orange },
  MatchParen   = { fg = c.orange, bold = true },
  NonText      = { fg = c.fg_muted },
  Whitespace   = { fg = '#2a2c2e' },
  SpecialKey   = { fg = c.fg_muted },
  EndOfBuffer  = { fg = c.bg },
  Directory    = { fg = c.light_blue },
  Title        = { fg = c.light_blue, bold = true },
  ErrorMsg     = { fg = c.red },
  WarningMsg   = { fg = c.orange },
  ModeMsg      = { fg = c.fg },
  MoreMsg      = { fg = c.green },
  Question     = { fg = c.green },
  StatusLine   = { fg = c.fg, bg = c.bg_sidebar },
  StatusLineNC = { fg = c.fg_dim, bg = c.bg_sidebar },
  TabLine      = { fg = c.fg_dim, bg = c.bg_sidebar },
  TabLineSel   = { fg = c.fg, bg = c.bg, bold = true },
  TabLineFill  = { bg = c.bg_sidebar },
  WildMenu     = { fg = c.bg, bg = c.light_blue },

  -- Popup menu / completion
  Pmenu        = { fg = c.fg, bg = c.bg_float },
  PmenuSel     = { fg = c.fg, bg = c.bg_visual, bold = true },
  PmenuSbar    = { bg = c.bg_float },
  PmenuThumb   = { bg = c.border },

  -- Classic syntax groups
  Comment      = { fg = c.comment, italic = true },
  Constant     = { fg = c.light_blue },
  String       = { fg = c.string },
  Character    = { fg = c.string },
  Number       = { fg = c.light_blue },
  Boolean      = { fg = c.light_blue },
  Float        = { fg = c.light_blue },
  Identifier   = { fg = c.light_blue },
  Function     = { fg = c.lavender },
  Statement    = { fg = c.purple },
  Conditional  = { fg = c.purple },
  Repeat       = { fg = c.purple },
  Label        = { fg = c.purple },
  Operator     = { fg = c.fg },
  Keyword      = { fg = c.purple },
  Exception    = { fg = c.purple },
  PreProc      = { fg = c.purple },
  Include      = { fg = c.purple },
  Define       = { fg = c.purple },
  Macro        = { fg = c.purple },
  Type         = { fg = c.teal },
  StorageClass = { fg = c.purple },
  Structure    = { fg = c.teal },
  Typedef      = { fg = c.teal },
  Special      = { fg = c.orange },
  Delimiter    = { fg = c.fg },
  Todo         = { fg = c.bg, bg = c.yellow, bold = true },
  Error        = { fg = c.red },

  -- Diagnostics
  DiagnosticError = { fg = c.red },
  DiagnosticWarn  = { fg = c.orange },
  DiagnosticInfo  = { fg = c.light_blue },
  DiagnosticHint  = { fg = c.teal },
  DiagnosticUnderlineError = { undercurl = true, sp = c.red },
  DiagnosticUnderlineWarn  = { undercurl = true, sp = c.orange },
  DiagnosticUnderlineInfo  = { undercurl = true, sp = c.light_blue },
  DiagnosticUnderlineHint  = { undercurl = true, sp = c.teal },

  -- Git / diff
  DiffAdd      = { bg = '#16261b' },
  DiffChange   = { bg = '#1a2230' },
  DiffDelete   = { bg = '#2a181a' },
  DiffText     = { bg = '#24344a' },
  diffAdded    = { fg = c.green },
  diffRemoved  = { fg = c.red },
  Added        = { fg = c.green },
  Removed      = { fg = c.red },
  Changed      = { fg = c.orange },
  GitSignsAdd    = { fg = c.green },
  GitSignsChange = { fg = c.orange },
  GitSignsDelete = { fg = c.red },

  -- Treesitter
  ['@comment']            = { fg = c.comment, italic = true },
  ['@comment.documentation'] = { fg = c.comment, italic = true },
  ['@keyword']            = { fg = c.purple },
  ['@keyword.modifier']   = { fg = c.red }, -- const/let/var and => (storage)
  ['@keyword.function']   = { fg = c.purple },
  ['@keyword.return']     = { fg = c.purple },
  ['@keyword.operator']   = { fg = c.purple },
  ['@keyword.import']     = { fg = c.purple },
  ['@keyword.repeat']     = { fg = c.purple },
  ['@keyword.conditional']= { fg = c.purple },
  ['@keyword.exception']  = { fg = c.purple },
  ['@keyword.coroutine']  = { fg = c.blue }, -- async / await (sampled blue)
  ['@conditional']        = { fg = c.purple },
  ['@repeat']             = { fg = c.purple },
  ['@exception']          = { fg = c.purple },
  ['@string']             = { fg = c.string },
  ['@string.escape']      = { fg = c.teal },
  ['@string.special']     = { fg = c.orange },
  ['@string.regexp']      = { fg = c.teal },
  ['@character']          = { fg = c.string },
  ['@number']             = { fg = c.light_blue },
  ['@boolean']            = { fg = c.light_blue },
  ['@float']              = { fg = c.light_blue },
  ['@constant']           = { fg = c.light_blue },
  ['@constant.builtin']   = { fg = c.light_blue },
  ['@constant.macro']     = { fg = c.purple },
  ['@function']           = { fg = c.lavender },
  ['@function.call']      = { fg = c.lavender },
  ['@function.builtin']   = { fg = c.lavender },
  ['@function.method']    = { fg = c.lavender },
  ['@function.method.call'] = { fg = c.lavender },
  ['@function.macro']     = { fg = c.lavender },
  ['@method']             = { fg = c.lavender },
  ['@method.call']        = { fg = c.lavender },
  ['@constructor']        = { fg = c.teal },
  ['@parameter']          = { fg = c.orange },
  ['@variable']           = { fg = c.light_blue },
  ['@variable.builtin']   = { fg = c.light_blue },
  ['@variable.parameter'] = { fg = c.orange },
  ['@variable.member']    = { fg = c.fg }, -- object property access (.Records) = gray
  ['@property']           = { fg = c.fg },
  ['@field']              = { fg = c.fg },
  ['@type']               = { fg = c.teal },
  ['@type.builtin']       = { fg = c.teal },
  ['@type.definition']    = { fg = c.teal },
  ['@namespace']          = { fg = c.teal },
  ['@module']             = { fg = c.light_blue },
  ['@operator']           = { fg = c.fg },
  ['@punctuation.delimiter'] = { fg = c.fg },
  ['@punctuation.bracket']   = { fg = c.fg },
  ['@punctuation.special']   = { fg = c.orange },
  ['@tag']                = { fg = c.teal },
  ['@tag.builtin']        = { fg = c.purple },
  ['@tag.attribute']      = { fg = c.light_blue },
  ['@tag.delimiter']      = { fg = c.fg_dim },
  ['@label']              = { fg = c.purple },

  -- Markup (markdown, etc.)
  ['@markup.heading']     = { fg = c.light_blue, bold = true },
  ['@markup.heading.1']   = { fg = c.light_blue, bold = true },
  ['@markup.heading.2']   = { fg = c.light_blue, bold = true },
  ['@markup.heading.3']   = { fg = c.purple, bold = true },
  ['@markup.link']        = { fg = c.string, underline = true },
  ['@markup.link.url']    = { fg = c.string, underline = true },
  ['@markup.raw']         = { fg = c.orange },
  ['@markup.list']        = { fg = c.orange },
  ['@markup.strong']      = { fg = c.fg, bold = true },
  ['@markup.italic']      = { fg = c.fg, italic = true },
  ['@markup.quote']       = { fg = c.comment, italic = true },

  -- LSP semantic tokens (these refine the above for active LSP buffers)
  ['@lsp.type.class']         = { fg = c.teal },
  ['@lsp.type.interface']     = { fg = c.teal },
  ['@lsp.type.enum']          = { fg = c.teal },
  ['@lsp.type.enumMember']    = { fg = c.light_blue },
  ['@lsp.type.type']          = { fg = c.teal },
  ['@lsp.type.typeParameter'] = { fg = c.teal },
  ['@lsp.type.namespace']     = { fg = c.teal },
  ['@lsp.type.function']      = { fg = c.lavender },
  ['@lsp.type.method']        = { fg = c.lavender },
  ['@lsp.type.property']      = { fg = c.fg }, -- object property access = gray
  ['@lsp.type.variable']      = { fg = c.light_blue },
  ['@lsp.type.parameter']     = { fg = c.orange },
  ['@lsp.type.keyword']       = { fg = c.purple },
  ['@lsp.type.string']        = { fg = c.string },
  ['@lsp.type.number']        = { fg = c.light_blue },
  ['@lsp.typemod.variable.readonly'] = { fg = c.light_blue },
  ['@lsp.typemod.variable.defaultLibrary'] = { fg = c.light_blue },
  ['@lsp.typemod.function.defaultLibrary'] = { fg = c.lavender },

  -- LSP references / inlay hints
  LspReferenceText  = { bg = c.bg_sel_soft },
  LspReferenceRead  = { bg = c.bg_sel_soft },
  LspReferenceWrite = { bg = c.bg_sel_soft },
  LspInlayHint      = { fg = c.fg_muted, bg = c.bg_sidebar },

  -- neo-tree
  NeoTreeNormal        = { fg = c.fg, bg = c.bg_sidebar },
  NeoTreeNormalNC      = { fg = c.fg, bg = c.bg_sidebar },
  NeoTreeDirectoryName = { fg = c.fg },
  NeoTreeDirectoryIcon = { fg = c.light_blue },
  NeoTreeRootName      = { fg = c.light_blue, bold = true },
  NeoTreeGitModified   = { fg = c.orange },
  NeoTreeGitAdded      = { fg = c.green },
  NeoTreeGitDeleted    = { fg = c.red },

  -- Rainbow brackets (VS Code bracket-pair colorization defaults)
  RainbowDelimiterYellow = { fg = '#ffd700' }, -- depth 0: gold
  RainbowDelimiterViolet = { fg = '#da70d6' }, -- depth 1: orchid
  RainbowDelimiterBlue   = { fg = '#179fff' }, -- depth 2: blue

  -- Indent guides (indent-blankline)
  IblIndent     = { fg = '#404040' },
  IblWhitespace = { fg = '#404040' },
  IblScope      = { fg = '#585858' },
}

for group, opts in pairs(groups) do
  hl(group, opts)
end

-- Built-in terminal palette
vim.g.terminal_color_0  = '#191a1b'
vim.g.terminal_color_1  = c.red
vim.g.terminal_color_2  = c.green
vim.g.terminal_color_3  = c.yellow
vim.g.terminal_color_4  = c.light_blue
vim.g.terminal_color_5  = c.purple
vim.g.terminal_color_6  = c.teal
vim.g.terminal_color_7  = c.fg
vim.g.terminal_color_8  = c.fg_dim
vim.g.terminal_color_9  = c.red
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.yellow
vim.g.terminal_color_12 = c.light_blue
vim.g.terminal_color_13 = c.purple
vim.g.terminal_color_14 = c.teal
vim.g.terminal_color_15 = '#ffffff'
