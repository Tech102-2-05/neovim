return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")

    -- Detect root
    local root_dir = require("jdtls.setup").find_root({
      ".git",
      "mvnw",
      "gradlew",
      "pom.xml",
      "build.gradle",
    })
    if not root_dir then
      return
    end

    local home = os.getenv("HOME")
    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace_dir = home .. "/.local/share/eclipse/" .. project_name
    local jdtls_path = "/usr/share/java/jdtls" -- Nếu bạn dùng pacman/yay

    local jar_pattern = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
    local launcher_jar = vim.fn.glob(jar_pattern)

    local config = {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        launcher_jar,
        "-configuration",
        jdtls_path .. "/config_linux",
        "-data",
        workspace_dir,
      },

      root_dir = root_dir,

      capabilities = require("blink.cmp").get_lsp_capabilities(),

      on_attach = function(client, bufnr)
        require("jdtls").setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()

        require("plugins.lsp.on_attach")(client, bufnr) -- dùng keymap chung
      end,

      settings = {
        java = {
          format = {
            enabled = true,
          },
          contentProvider = { preferred = "fernflower" }, -- hoặc "decompiler"
          configuration = {
            runtimes = {
              {
                name = "JavaSE-17",
                path = "/usr/lib/jvm/java-17-openjdk/",
              },
              {
                name = "JavaSE-21",
                path = "/usr/lib/jvm/java-21-openjdk/",
              },
            },
          },
        },
      },
    }

    jdtls.start_or_attach(config)
  end,
}
