defmodule PhoenixPress.SitemapTest do
  use ExUnit.Case, async: true

  defmodule TestSitemap do
    use PhoenixPress.Sitemap, base_url: "https://example.com"

    add("/", changefreq: :weekly, priority: 1.0)
    add("/blog", changefreq: :weekly, priority: 0.8)
    add("/about", lastmod: ~D[2026-01-15], changefreq: :monthly, priority: 0.5)
  end

  test "generates valid sitemap XML" do
    xml = TestSitemap.__sitemap_xml__()

    assert xml =~ ~s(<?xml version="1.0" encoding="UTF-8"?>)
    assert xml =~ ~s(<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">)
    assert xml =~ "<loc>https://example.com/</loc>"
    assert xml =~ "<loc>https://example.com/blog</loc>"
    assert xml =~ "<loc>https://example.com/about</loc>"
    assert xml =~ "<changefreq>weekly</changefreq>"
    assert xml =~ "<priority>1.0</priority>"
    assert xml =~ "<priority>0.8</priority>"
    assert xml =~ "<lastmod>2026-01-15</lastmod>"
  end

  test "preserves URL order" do
    xml = TestSitemap.__sitemap_xml__()
    root_pos = :binary.match(xml, "https://example.com/</loc>") |> elem(0)
    blog_pos = :binary.match(xml, "https://example.com/blog</loc>") |> elem(0)
    about_pos = :binary.match(xml, "https://example.com/about</loc>") |> elem(0)

    assert root_pos < blog_pos
    assert blog_pos < about_pos
  end
end
