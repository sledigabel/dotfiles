-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local local_dir = os.getenv("TMUX_SESSION_DIR")
if not local_dir then
  local_dir = vim.fn.getcwd()
end

local home = os.getenv("HOME")
local jdtls_home = home .. "/dev/tools/jdtls6/"

local local_dir_name = vim.fn.fnamemodify(local_dir, ":p:h:t")
local workspace_dir = home .. "/workspaces/" .. local_dir_name

-- adding addition text support capabilities
local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local java_bundles_path = "/.config/nvim/java"
local bundle_list = vim.tbl_map(function(x)
  return require("jdtls.path").join(java_bundles_path, x)
end, {
  "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
  "/vscode-java-decompiler/server/*.jar",
  "/vscode-java-test/server/*.jar",
  "/lombok/*.jar",
})

local bundles = {}
for _, bundle_item in ipairs(bundle_list) do
  for _, bundle in ipairs(vim.split(vim.fn.glob(home .. bundle_item), "\n")) do
    table.insert(bundles, bundle)
  end
end

-- eclipse jdtls settings
local settings = {
  -- ["java.format.settings.url"] = "/Users/sebastienledigabel/dev/perso/dotfiles/nvim/.config/nvim/lua/config/google-formatter.xml",
  -- ["java.format.settings.profile"] = "GoogleStyle",
  ["java.format.enabled"] = false,
  java = {
    signatureHelp = { enabled = true },
    contentProvider = { preferred = "fernflower" },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      filteredTypes = {
        "com.sun.*",
        "io.micrometer.shaded.*",
        "java.awt.*",
        "jdk.*",
        "sun.*",
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      hashCodeEquals = {
        useJava7Objects = true,
      },
      useBlocks = true,
    },
    -- configuration = {
    -- runtimes = {
    --   {
    --     name = "JavaSE-17.0.4+101",
    --     path = "/Users/sebastienledigabel/.asdf/installs/java/temurin-17.0.4+101",
    --   },
    -- },
    -- },
    eclipse = {
      downloadSources = true,
    },
    configuration = {
      updateBuildConfiguration = "interactive",
    },
    gradle = {
      downloadSources = true,
    },
    maven = {
      downloadSources = true,
    },
    implementationsCodeLens = {
      enabled = true,
    },
    referencesCodeLens = {
      enabled = true,
    },
    references = {
      includeDecompiledSources = true,
    },
    inlayHints = {
      parameterNames = {
        enabled = "all", -- literals, all, none
      },
    },
  },
}

-- TODO: Build the jdtls path dynamically
local config = {

  -- cmd for the jdtls package
  -- cmd = {
  --   jdtls_home .. "/bin/jdtls",
  --   "--jvm-args=-Dlog.level=ALL",
  --   "--jvm-args=-Dlog.protocol=true",
  --   "-data",
  --   workspace_dir,
  -- },

  cmd = {
    "java",
    -- for debugging
    -- "-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=1044",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=" .. jdtls_home .. "/config_mac",
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. vim.fn.stdpath("config") .. "/java/lombok/lombok.jar",
    "-Xbootclasspath/a:/" .. vim.fn.stdpath("config") .. "/java/lombok/lombok.jar",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "--add-opens",
    "java.base/sun.nio.fs=ALL-UNNAMED",
    "-jar",
    jdtls_home .. "/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
    "-data",
    workspace_dir,
  },

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = settings,

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  root_dir = local_dir,

  init_options = {
    extendedClientCapabilities = extendedClientCapabilities,
    -- bundles = {},
    bundles = bundles,
    settings = settings,
  },
  --
  -- This is currently required to have the server read the settings,
  -- In a future neovim build this may no longer be required
  on_init = function(client)
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end,
}

-- DEBUG
-- vim.print(local_dir)
-- vim.print(config.cmd)
-- vim.print(bundles)
--
-- vim.lsp.set_log_level("debug")
require("jdtls.setup").add_commands()
require("jdtls").setup_dap({ hotcodereplace = "auto" })
require("jdtls").start_or_attach(config)
