local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.general.positionEncodings = { "utf-16" }

vim.lsp.config('*', { capabilities = capabilities })

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
        features = 'all',
      },
      diagnostic = {
        styleLints = {
          enable = true,
        },
      },
    }
  },
})

vim.lsp.config('ruby_lsp', {
  init_options = {
    rubyLsp = {
      featuresConfiguration = {
        inlayHint = {
          enableAll = true,
        },
      },
      rubyVersionManager = {
        identifier = 'mise',
      },
    },
  },
})

vim.lsp.config['herb_ls'] = {
  cmd = { 'herb-language-server', '--stdio' },
  filetypes = { 'html', 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
}

local skCapabilities = capabilities
-- https://www.swift.org/documentation/articles/zero-to-swift-nvim.html#file-updating
skCapabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
vim.lsp.config('sourcekit', {
  capabilities = skCapabilities
})

vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
})

vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

vim.lsp.enable({
  'clangd',
  'eslint',
  -- 'gopls',
  'herb_ls',
  'jsonls',
  'lua_ls',
  'rubocop',
  'ruby_lsp',
  'rust_analyzer',
  'sourcekit',
  'ts_ls',
  'yamlls',
})

require('lspconfig.ui.windows').default_options.border = 'rounded'
