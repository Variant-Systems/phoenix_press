defmodule PhoenixPress.Robots do
  @moduledoc """
  Compile-time robots.txt generation.

  ## Usage

      defmodule MyAppWeb.Robots do
        use PhoenixPress.Robots, base_url: "https://example.com"

        sitemap "/sitemap.xml"
        allow "/"
        disallow "/dashboard"
      end
  """

  defmacro __using__(opts) do
    quote do
      Module.register_attribute(__MODULE__, :phoenix_press_robots_rules, accumulate: true)
      Module.register_attribute(__MODULE__, :phoenix_press_robots_sitemaps, accumulate: true)
      @phoenix_press_base_url Keyword.fetch!(unquote(opts), :base_url)
      @before_compile PhoenixPress.Robots
      import PhoenixPress.Robots, only: [allow: 1, disallow: 1, sitemap: 1]
    end
  end

  defmacro allow(path) do
    quote do
      @phoenix_press_robots_rules {:allow, unquote(path)}
    end
  end

  defmacro disallow(path) do
    quote do
      @phoenix_press_robots_rules {:disallow, unquote(path)}
    end
  end

  defmacro sitemap(path) do
    quote do
      @phoenix_press_robots_sitemaps unquote(path)
    end
  end

  defmacro __before_compile__(env) do
    rules = Module.get_attribute(env.module, :phoenix_press_robots_rules) |> Enum.reverse()
    sitemaps = Module.get_attribute(env.module, :phoenix_press_robots_sitemaps) |> Enum.reverse()
    base_url = Module.get_attribute(env.module, :phoenix_press_base_url)
    txt = PhoenixPress.Robots.Builder.build(base_url, rules, sitemaps)

    quote do
      def __robots_txt__, do: unquote(txt)
    end
  end
end
