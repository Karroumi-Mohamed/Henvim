-- ~/.config/nvim/ftplugin/java.lua
local home = os.getenv('HOME')
local workspace_dir = home .. '/.cache/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- Bundles: Enable debug/test without reload errors (Mason paths; skip if not using Mason)
local bundles = {}
local mason_debug = vim.fn.glob(home .. '/.local/share/nvim/mason/packages/java-debug/server/com.microsoft.java.debug.plugin-*.jar')
local mason_test = vim.fn.glob(home .. '/.local/share/nvim/mason/packages/java-test/server/com.microsoft.java.test.runner-*.jar')
if mason_debug ~= '' then table.insert(bundles, mason_debug) end
if mason_test ~= '' then table.insert(bundles, mason_test) end

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',  -- Set to 'WARN' after debugging
    '-Xmx2G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
    '-data', workspace_dir,
  },
  root_dir = vim.fs.dirname(vim.fs.find({'pom.xml', 'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
  init_options = {
    bundles = bundles,
  },
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-21',
            path = '/usr/lib/jvm/java-21-openjdk',
            default = true,
          },
          {
            name = 'JavaSE-17',
            path = '/usr/lib/jvm/java-17-openjdk',
          },
        },
      },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      contentProvider = { preferred = 'fernflower' },
    },
  },
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Core LSP keymaps (always safe)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- Rename symbol
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- References
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Code actions

    -- JDTLS extras: Safely check with pcall to avoid nil rhs
    local jdtls_ok, jdtls = pcall(require, 'jdtls')
    if jdtls_ok then
      pcall(vim.keymap.set, 'n', '<leader>co', jdtls.organize_imports, opts) -- Organize imports
      pcall(vim.keymap.set, 'n', '<leader>rf', jdtls.rename, opts) -- Rename file
      pcall(vim.keymap.set, 'n', '<leader>tc', jdtls.test_class, opts) -- Test class
      pcall(vim.keymap.set, 'n', '<leader>tm', jdtls.test_nearest_method, opts) -- Test method
    end
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

require('jdtls').start_or_attach(config)
