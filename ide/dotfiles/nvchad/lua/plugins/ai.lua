return {
  "yetone/avante.nvim",
  lazy = true,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = "ollama",
    auto_suggestion_provider = "ollama",
    ollama = {
      -- timeout = 30000,
      temperature = 0,
      -- max_tokens = 4096,
      api_key_name = "OLLAMA_API_KEY",
    },
    vendors = {
      ["ollama"] = {
        ["local"] = true,
        endpoint = "127.0.0.1:11434/v1",
        model = "mistral",
        api_key_name = "OLLAMA_API_KEY",
        parse_curl_args = function(opts, code_opts)
          return {
            url = opts.endpoint .. "/chat/completions",
            headers = {
              ["Accept"] = "application/json",
              ["Content-Type"] = "application/json",
            },
            body = {
              model = opts.model,
              messages = require("avante.providers").copilot.parse_message(code_opts),
              -- you can make your own message, but this is very advanced
              max_tokens = 2048,
              stream = true,
            },
          }
        end,
        parse_response_data = function(data_stream, event_state, opts)
          require("avante.providers").openai.parse_response(data_stream, event_state, opts)
        end,
      },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons",
    -- or echasnovski/mini.icons
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
