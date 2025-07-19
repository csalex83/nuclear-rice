local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true })
vim.opt.number = true          
vim.opt.termguicolors = true  
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

require("lazy").setup({
  {
    "projekt0n/github-nvim-theme",
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = false,
          styles = {
            comments = "italic",
            keywords = "bold",
          },
          colors = {
            error = "#ff6f6f",
            success = "#aaaaff",
          }
        }
      })
      vim.cmd("colorscheme github_dark_colorblind")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip"
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'luasnip' },
        })
      })

      local lspconfig = require('lspconfig')

      -- Servidors LSP per llenguatges comuns

      -- Python (instal·la 'python-lsp-server' per pacman)
      lspconfig.pylsp.setup{}

      -- HTML (instal·la 'vscode-html-languageserver-bin')
      lspconfig.html.setup{}

      -- CSS (instal·la 'vscode-css-languageserver-bin')
      lspconfig.cssls.setup{}

      -- JavaScript/TypeScript (necessita 'typescript-language-server')
      lspconfig.tsserver.setup{}

      -- C i C++ (clangd)
      lspconfig.clangd.setup{}

      -- C# (OmniSharp)
      lspconfig.omnisharp.setup{}

      -- Si vols afegir més, aquí pots continuar
    end,
  }
})

