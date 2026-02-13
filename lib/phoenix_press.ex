defmodule PhoenixPress do
  @moduledoc """
  SEO essentials for Phoenix: sitemaps, robots.txt, and RSS feeds.

  Compile-time, declarative, and served via a single Plug.

  ## Usage

  1. Define your sitemap, robots, and feed modules:

      defmodule MyAppWeb.Press.Sitemap do
        use PhoenixPress.Sitemap, base_url: "https://example.com"

        add "/", changefreq: :weekly, priority: 1.0
        add "/blog", changefreq: :weekly, priority: 0.8
      end

  2. Add the plug to your endpoint (before the router):

      plug PhoenixPress.Plug,
        sitemap: MyAppWeb.Press.Sitemap,
        robots: MyAppWeb.Press.Robots,
        feed: MyAppWeb.Press.Feed
  """
end
