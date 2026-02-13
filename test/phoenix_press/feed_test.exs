defmodule PhoenixPress.FeedTest do
  use ExUnit.Case, async: true

  defmodule TestFeed do
    use PhoenixPress.Feed,
      title: "Test Blog",
      description: "A test blog feed",
      base_url: "https://example.com",
      language: "en"

    entry("First Post",
      link: "/blog/first-post",
      description: "The first post",
      pub_date: ~D[2026-02-01],
      author: "Author One"
    )

    entry("Second Post",
      link: "/blog/second-post",
      description: "The second post",
      pub_date: ~D[2026-02-05],
      author: "Author Two"
    )
  end

  test "generates valid RSS 2.0 XML" do
    xml = TestFeed.__feed_xml__()

    assert xml =~ ~s(<?xml version="1.0" encoding="UTF-8"?>)
    assert xml =~ ~s(<rss version="2.0")
    assert xml =~ "<title>Test Blog</title>"
    assert xml =~ "<description>A test blog feed</description>"
    assert xml =~ "<language>en</language>"
  end

  test "includes feed entries" do
    xml = TestFeed.__feed_xml__()

    assert xml =~ "<title>First Post</title>"
    assert xml =~ "<link>https://example.com/blog/first-post</link>"
    assert xml =~ "<description>The first post</description>"
    assert xml =~ "<author>Author One</author>"
    assert xml =~ "<title>Second Post</title>"
    assert xml =~ "<link>https://example.com/blog/second-post</link>"
  end

  test "formats pub_date as RFC 822" do
    xml = TestFeed.__feed_xml__()

    # 2026-02-01 is a Sunday
    assert xml =~ "<pubDate>Sun, 01 Feb 2026 00:00:00 +0000</pubDate>"
    # 2026-02-05 is a Thursday
    assert xml =~ "<pubDate>Thu, 05 Feb 2026 00:00:00 +0000</pubDate>"
  end

  test "includes guid for each entry" do
    xml = TestFeed.__feed_xml__()

    assert xml =~ "<guid>https://example.com/blog/first-post</guid>"
    assert xml =~ "<guid>https://example.com/blog/second-post</guid>"
  end

  test "includes atom self link" do
    xml = TestFeed.__feed_xml__()

    assert xml =~ ~s(href="https://example.com/feed.xml" rel="self" type="application/rss+xml")
  end
end
