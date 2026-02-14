defmodule PhoenixPress.LlmsTxt do
  @moduledoc """
  Compile-time llms.txt generation.

  ## Usage

      defmodule MyAppWeb.LlmsTxt do
        use PhoenixPress.LlmsTxt,
          title: "My App",
          description: "A platform for managing widgets."

        section "Docs"
        link "/docs/getting-started", "Getting Started", "How to set up the project"
        link "/docs/api", "API Reference", "Full API documentation"

        section "Optional"
        link "/blog", "Blog", "Latest updates"
      end
  """

  defmacro __using__(opts) do
    quote do
      Module.register_attribute(__MODULE__, :phoenix_press_llms_txt_entries, accumulate: true)
      @phoenix_press_llms_txt_opts unquote(opts)
      @before_compile PhoenixPress.LlmsTxt
      import PhoenixPress.LlmsTxt, only: [section: 1, link: 3]
    end
  end

  defmacro section(name) do
    quote do
      @phoenix_press_llms_txt_entries {:section, unquote(name)}
    end
  end

  defmacro link(path, title, description) do
    quote do
      @phoenix_press_llms_txt_entries {:link, unquote(path), unquote(title), unquote(description)}
    end
  end

  defmacro __before_compile__(env) do
    entries = Module.get_attribute(env.module, :phoenix_press_llms_txt_entries) |> Enum.reverse()
    opts = Module.get_attribute(env.module, :phoenix_press_llms_txt_opts)
    txt = PhoenixPress.LlmsTxt.Builder.build(opts, entries)

    quote do
      def __llms_txt__, do: unquote(txt)
    end
  end
end
