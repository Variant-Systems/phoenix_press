defmodule PhoenixPress do
  @moduledoc """
  SEO and discoverability essentials for Phoenix: sitemaps, robots.txt, RSS feeds, and llms.txt.

  Compile-time, declarative, and served via a single Plug.

  ## Quick Start

  ### 1. Add the dependency

  ```elixir
  # mix.exs
  def deps do
    [
      {:phoenix_press, "~> 0.1.0"}
    ]
  end
  ```

  ### 2. Define your modules

  **Sitemap** — see `PhoenixPress.Sitemap` for full options:

  ```elixir
  defmodule MyAppWeb.Press.Sitemap do
    use PhoenixPress.Sitemap, base_url: "https://example.com"

    add "/", changefreq: :weekly, priority: 1.0
    add "/blog", changefreq: :weekly, priority: 0.8

    # Dynamic entries are resolved at compile time
    for post <- MyApp.Blog.all_posts() do
      add "/blog/\#{post.slug}", changefreq: :monthly, lastmod: post.updated_at
    end
  end
  ```

  **Robots** — see `PhoenixPress.Robots` for full options:

  ```elixir
  defmodule MyAppWeb.Press.Robots do
    use PhoenixPress.Robots, base_url: "https://example.com"

    sitemap "/sitemap.xml"
    allow "/"
    disallow "/admin"
  end
  ```

  **RSS Feed** — see `PhoenixPress.Feed` for full options:

  ```elixir
  defmodule MyAppWeb.Press.Feed do
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
  ```

  **llms.txt** — see `PhoenixPress.LlmsTxt` for full options:

  ```elixir
  defmodule MyAppWeb.Press.LlmsTxt do
    use PhoenixPress.LlmsTxt,
      title: "My App",
      description: "A platform for managing widgets."

    section "Docs"
    link "/docs/getting-started", "Getting Started", "How to set up the project"
    link "/docs/api", "API Reference", "Full API documentation"

    section "Optional"
    link "/blog", "Blog", "Latest updates"
  end
  ```

  ### 3. Mount the plug

  Add `PhoenixPress.Plug` to your endpoint **before** the router:

  ```elixir
  # lib/my_app_web/endpoint.ex
  plug PhoenixPress.Plug,
    sitemap: MyAppWeb.Press.Sitemap,
    robots: MyAppWeb.Press.Robots,
    feed: MyAppWeb.Press.Feed,
    llms_txt: MyAppWeb.Press.LlmsTxt
  ```

  Any key can be omitted if you don't need that feature. See `PhoenixPress.Plug` for details.

  This serves:

  - `/sitemap.xml` — XML sitemap
  - `/robots.txt` — robots directives
  - `/feed.xml` — RSS 2.0 feed
  - `/llms.txt` — LLM-friendly documentation

  ## How It Works

  All XML and text output is generated **at compile time** and stored as module attributes.
  At runtime, `PhoenixPress.Plug` simply returns the pre-built strings — no templates,
  no database queries, no runtime overhead.
  """
end
