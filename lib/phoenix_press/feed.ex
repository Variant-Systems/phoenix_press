defmodule PhoenixPress.Feed do
  @moduledoc """
  Compile-time RSS 2.0 feed generation.

  ## Usage

      defmodule MyAppWeb.Feed do
        use PhoenixPress.Feed,
          title: "My Blog",
          description: "Latest posts",
          base_url: "https://example.com"

        for post <- MyApp.Blog.all_posts() do
          entry post.title,
            link: "/blog/\#{post.id}",
            description: post.description,
            pub_date: post.date,
            author: post.author
        end
      end
  """

  defmacro __using__(opts) do
    quote do
      Module.register_attribute(__MODULE__, :phoenix_press_feed_entries, accumulate: true)
      @phoenix_press_feed_opts unquote(opts)
      @before_compile PhoenixPress.Feed
      import PhoenixPress.Feed, only: [entry: 2]
    end
  end

  defmacro entry(title, opts) do
    quote do
      @phoenix_press_feed_entries {unquote(title), unquote(opts)}
    end
  end

  defmacro __before_compile__(env) do
    entries = Module.get_attribute(env.module, :phoenix_press_feed_entries) |> Enum.reverse()
    feed_opts = Module.get_attribute(env.module, :phoenix_press_feed_opts)
    xml = PhoenixPress.Feed.Builder.build(feed_opts, entries)

    quote do
      def __feed_xml__, do: unquote(xml)
    end
  end
end
