-- enable vim options
function set (opt)
    for k, v in pairs(opt) do
        vim.opt[k] = v
    end
end

-- disable default plugins
function nop (plg)
    for _, p in pairs(plg) do
        vim.g["loaded_" .. p] = 1
    end
end

set({
    nu   = true,
    nuw  = 5,
    tgc  = true,
    bg   = "dark",
    cb   = "unnamedplus",
    et   = true,
    ts   = 4,
    sts  = 4,
    sw   = 4,
    swf  = false,
    shm  = "aIF",
    hls  = false,
    lz   =  true,
    wb   = false,
    bk   = false,
    ru   = false,
    smc  =   180,
    smd  = false,
    wrap = false,
    vif  = "NONE",
    fillchars = {eob = " "},
    ls   = 0,
    sh   = "/bin/mksh",
})
nop({
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "matchparen",
    "netrw",
    "netrwFileHandlers",
    "netrwPlugin",
    "netrwSettings",
    "rrhelper",
    "spellfile_plugin",
    "sql_completion",
    "syntax_completion",
    "tar",
    "tarPlugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "vimsyn_embed",
})

vim.cmd([[
    syn enable
    colo nord
    packadd packer.nvim

    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>
]])

return require('packer').startup(function()
      local use = use
      use 'shaunsingh/nord.nvim'
  end
)
