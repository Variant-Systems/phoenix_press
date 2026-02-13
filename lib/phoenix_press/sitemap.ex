defmodule PhoenixPress.Sitemap do
  @moduledoc """
  Compile-time sitemap generation.

  ## Usage

      defmodule MyAppWeb.Sitemap do
        use PhoenixPress.Sitemap, base_url: "https://example.com"

        add "/", changefreq: :weekly, priority: 1.0
        add "/blog", changefreq: :weekly, priority: 0.8

        for post <- MyApp.Blog.all_posts() do
          add "/blog/\#{post.id}", changefreq: :monthly, lastmod: post.date
        end
      end
  """

  defmacro __using__(opts) do
    quote do
      Module.register_attribute(__MODULE__, :phoenix_press_sitemap_urls, accumulate: true)
      @phoenix_press_base_url Keyword.fetch!(unquote(opts), :base_url)
      @before_compile PhoenixPress.Sitemap
      import PhoenixPress.Sitemap, only: [add: 1, add: 2]
    end
  end

  defmacro add(path, opts \\ []) do
    quote do
      @phoenix_press_sitemap_urls {unquote(path), unquote(opts)}
    end
  end

  defmacro __before_compile__(env) do
    urls = Module.get_attribute(env.module, :phoenix_press_sitemap_urls) |> Enum.reverse()
    base_url = Module.get_attribute(env.module, :phoenix_press_base_url)
    xml = PhoenixPress.Sitemap.Builder.build(base_url, urls)

    quote do
      def __sitemap_xml__, do: unquote(xml)
    end
  end
end
