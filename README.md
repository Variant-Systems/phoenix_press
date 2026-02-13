# PhoenixPress

SEO essentials for Phoenix: sitemaps, robots.txt, and RSS feeds.

Compile-time, declarative, and served via a single Plug. Zero runtime overhead per request.

## Installation

Add `phoenix_press` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_press, "~> 0.1.0"}
  ]
end
```

## Usage

### 1. Define your modules

**Sitemap**

```elixir
defmodule MyAppWeb.Press.Sitemap do
  use PhoenixPress.Sitemap, base_url: "https://example.com"

  add "/", changefreq: :weekly, priority: 1.0
  add "/blog", changefreq: :weekly, priority: 0.8

  for post <- MyApp.Blog.all_posts() do
    add "/blog/#{post.id}", changefreq: :monthly, lastmod: post.date
  end
end
```

**Robots**

```elixir
defmodule MyAppWeb.Press.Robots do
  use PhoenixPress.Robots, base_url: "https://example.com"

  sitemap "/sitemap.xml"
  allow "/"
  disallow "/dashboard"
end
```

**RSS Feed**

```elixir
defmodule MyAppWeb.Press.Feed do
  use PhoenixPress.Feed,
    title: "My Blog",
    description: "Latest posts",
    base_url: "https://example.com"

  for post <- MyApp.Blog.all_posts() do
    entry post.title,
      link: "/blog/#{post.id}",
      description: post.description,
      pub_date: post.date,
      author: post.author
  end
end
```

### 2. Add the Plug to your endpoint

Add it **before** your router:

```elixir
plug PhoenixPress.Plug,
  sitemap: MyAppWeb.Press.Sitemap,
  robots: MyAppWeb.Press.Robots,
  feed: MyAppWeb.Press.Feed
```

Any key can be omitted if you don't need that feature.

### 3. That's it

Your app now serves:
- `GET /sitemap.xml` with `Content-Type: text/xml`
- `GET /robots.txt` with `Content-Type: text/plain`
- `GET /feed.xml` with `Content-Type: application/rss+xml`

All responses include `Cache-Control: public, max-age=3600`.

## How it works

PhoenixPress generates XML/text at **compile time** using Elixir macros. When a request hits your endpoint, the Plug serves pre-built strings with zero runtime computation.

This means:
- No database queries per request
- No XML building per request
- No template rendering per request

To update content, recompile the module (or use `mix compile --force`).

## License

MIT - see [LICENSE](LICENSE) for details.
