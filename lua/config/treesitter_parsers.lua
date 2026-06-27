-- Treesitter parsers to install. Shared between the runtime config
-- (lua/config/plugins.lua) and the installer (install.sh) so they never drift.
return {
  'typescript', 'javascript', 'tsx', 'json',
  'lua', 'vim', 'vimdoc', 'bash', 'markdown', 'markdown_inline',
  'html', 'css', 'yaml', 'toml', 'dockerfile', 'sql', 'gitcommit',
}
