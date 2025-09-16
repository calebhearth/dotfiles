local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.general.positionEncodings = { "utf-16" }
capabilities.textDocument.codeLens.dynamicRegistration = true

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

local function add_ruby_deps_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'RubyLSPShowDependencies', function(opts)
    local params = vim.lsp.util.make_text_document_params()
    local showAll = opts.args == 'all'

    client.request('rubyLsp/workspace/dependencies', params, function(error, result)
      if error then
        print('Error showing Ruby dependencies:')
        print(vim.inspect(error))
        return
      end

      local qf_list = {}
      for _, item in ipairs(result) do
        if showAll or item.dependency then
          table.insert(qf_list, {
            text = string.format('%s (%s) - %s', item.name, item.version, item.dependency),
            filename = item.path,
          })
        end
      end

      vim.fn.setqflist(qf_list)
      vim.cmd('copen')
    end, bufnr)
  end, {
    nargs = '?',
    desc = 'Show Ruby dependencies for current workspace',
    complete = function()
      return { 'all' }
    end,
  })
end

local function add_ruby_syntax_tree_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'RubyLSPShowSyntaxTree', function()
    local params = vim.lsp.util.make_position_params(0, 'utf-16')

    client.request('rubyLsp/textDocument/showSyntaxTree', params, function(error, result)
      if error then
        print('Error showing Syntax Tree for buffer: ')
        print(vim.inspect(error))
        return
      end

      local ast = result.ast
      local lines = {}
      for line in ast:gmatch('[^\r\n]+') do
        table.insert(lines, line)
      end

      vim.api.nvim_command('vnew')
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':quit<CR>', { noremap = true, silent = true })
    end, bufnr)
  end, {
    nargs = '?',
    desc = 'Show Ruby Syntax Tree for current buffer',
  })
end

local function add_ruby_discover_tests_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'RubyLSPDiscoverTests', function()
    local params = { textDocument = vim.lsp.util.make_text_document_params() }

    client.request('rubyLsp/discoverTests', params, function(error, result)
      if error then
        print('Error discovering tests:')
        print(vim.inspect(error))
        return
      end

      print(vim.inspect(result))

      local function extract_tests(tests, qf_list)
        for _, test in ipairs(tests) do
          table.insert(qf_list, {
            text = test.label,
            filename = vim.uri_to_fname(test.uri),
            lnum = test.range.start.line + 1,
            col = test.range.start.character + 1,
          })
          if test.children then
            extract_tests(test.children, qf_list)
          end
        end
      end

      local qf_list = {}
      extract_tests(result, qf_list)

      vim.fn.setqflist(qf_list)
      vim.cmd('copen')
    end, bufnr)
  end, {
    desc = 'Discover Ruby tests in current file',
  })
end


--- @class LSPError
--- @field code integer
--- @field message string
--- @field data? string | number | boolean | table

--- @param bufnr integer
local function add_go_to_relevant_file_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'GoToRelevantFile', function(opts)
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(bufnr)
    }

    ---@param error? LSPError The error, if any
    ---@param result? { locations: string[] }
    local function go_to_relevant_file_callback(error, result)
      if error then
        print('Error getting relevant files:')
        print(vim.inspect(error))
        return
      end
      if result then
        if #result.locations == 0 then
          print('No alternates found')
          return
        end
        ---@type vim.quickfix.entry[]
        local qf_list = {}
        for _, item in ipairs(result.locations) do
          table.insert(qf_list, {
            filename = item,
          })
        end

        vim.fn.setqflist(qf_list)
        vim.cmd('copen')
      end
    end

    client.request('experimental/goToRelevantFile', params, go_to_relevant_file_callback, bufnr)
  end, {
    desc = 'List relevant alternate files',
  })
end

vim.lsp.config('ruby_lsp', {
  init_options = {
    rubyLsp = {
      addonSettings = {
        ["Ruby LSP RSpec"] = {
          rspecCommand = "mise x -- rspec --format documentation"
        }
      },
      featuresConfiguration = {
        -- These seem to be tied to VSCode with rubyLsp.[whatever] commands
        codeLens = {
          enableAll = true
        },
        inlayHint = {
          enableAll = true,
        },
      },
      -- https://github.com/Shopify/ruby-lsp/blob/main/vscode/package.json#L540
      featureFlags = {
        all = true,
        fullTestDiscovery = true,
      },
      rubyVersionManager = {
        identifier = 'mise',
      },
    },
  },
  on_attach = function(client, bufnr)
    add_ruby_deps_command(client, bufnr)
    add_ruby_syntax_tree_command(client, bufnr)
    add_ruby_discover_tests_command(client, bufnr)
    add_go_to_relevant_file_command(client, bufnr)
  end
})

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
    Lua = {
      hint = {
        arrayIndex = "Disable",
        enable = true,
      }
    }
  }
})

vim.lsp.config("herb_ls", {
  filetypes = { "eruby", "html" }
})

vim.lsp.config("vimls", {
  init_options = {
    diagnostic = {
      enable = true
    },
    indexes = {
      runtimepath = true,
    },
    isNeovim = true,
    suggest = {
      fromVimruntime = true,
      fromRuntimepath = true,
    }
  }
})

vim.lsp.enable({
  -- 'clangd',
  'eslint',
  'gopls',
  'herb_ls',
  'jsonls',
  'lua_ls',
  'rubocop',
  'ruby_lsp',
  'rust_analyzer',
  'sourcekit',
  'ts_ls',
  'vimls',
  'yamlls',
})

require('lspconfig.ui.windows').default_options.border = 'rounded'
