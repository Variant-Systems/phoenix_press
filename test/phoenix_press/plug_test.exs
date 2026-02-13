defmodule PhoenixPress.PlugTest do
  use ExUnit.Case, async: true
  import Plug.Test
  import Plug.Conn

  defmodule TestSitemap do
    use PhoenixPress.Sitemap, base_url: "https://example.com"
    add("/", changefreq: :weekly, priority: 1.0)
  end

  defmodule TestRobots do
    use PhoenixPress.Robots, base_url: "https://example.com"
    sitemap("/sitemap.xml")
    allow("/")
  end

  defmodule TestFeed do
    use PhoenixPress.Feed,
      title: "Test",
      description: "Test feed",
      base_url: "https://example.com"

    entry("Post", link: "/blog/post", description: "A post", pub_date: ~D[2026-01-01])
  end

  @opts PhoenixPress.Plug.init(
          sitemap: TestSitemap,
          robots: TestRobots,
          feed: TestFeed
        )

  test "serves sitemap.xml" do
    conn = conn(:get, "/sitemap.xml") |> PhoenixPress.Plug.call(@opts)

    assert conn.status == 200
    assert get_resp_header(conn, "content-type") |> hd() =~ "text/xml"
    assert get_resp_header(conn, "cache-control") == ["public, max-age=3600"]
    assert conn.resp_body =~ "<urlset"
    assert conn.halted
  end

  test "serves robots.txt" do
    conn = conn(:get, "/robots.txt") |> PhoenixPress.Plug.call(@opts)

    assert conn.status == 200
    assert get_resp_header(conn, "content-type") |> hd() =~ "text/plain"
    assert conn.resp_body =~ "User-agent: *"
    assert conn.halted
  end

  test "serves feed.xml" do
    conn = conn(:get, "/feed.xml") |> PhoenixPress.Plug.call(@opts)

    assert conn.status == 200
    assert get_resp_header(conn, "content-type") |> hd() =~ "application/rss+xml"
    assert conn.resp_body =~ "<rss version"
    assert conn.halted
  end

  test "passes through other paths" do
    conn = conn(:get, "/other") |> PhoenixPress.Plug.call(@opts)

    refute conn.halted
    assert conn.status == nil
  end

  test "passes through when module is nil" do
    opts = PhoenixPress.Plug.init(sitemap: nil, robots: nil, feed: nil)
    conn = conn(:get, "/sitemap.xml") |> PhoenixPress.Plug.call(opts)

    refute conn.halted
  end
end
