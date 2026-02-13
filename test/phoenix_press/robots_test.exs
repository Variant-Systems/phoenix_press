defmodule PhoenixPress.RobotsTest do
  use ExUnit.Case, async: true

  defmodule TestRobots do
    use PhoenixPress.Robots, base_url: "https://example.com"

    sitemap("/sitemap.xml")
    allow("/")
    disallow("/dashboard")
    disallow("/admin")
  end

  test "generates valid robots.txt" do
    txt = TestRobots.__robots_txt__()

    assert txt =~ "User-agent: *"
    assert txt =~ "Allow: /"
    assert txt =~ "Disallow: /dashboard"
    assert txt =~ "Disallow: /admin"
    assert txt =~ "Sitemap: https://example.com/sitemap.xml"
  end

  test "preserves rule order" do
    txt = TestRobots.__robots_txt__()
    lines = String.split(txt, "\n")

    assert Enum.at(lines, 0) == "User-agent: *"
    assert Enum.at(lines, 1) == "Allow: /"
    assert Enum.at(lines, 2) == "Disallow: /dashboard"
    assert Enum.at(lines, 3) == "Disallow: /admin"
    assert Enum.at(lines, 4) == "Sitemap: https://example.com/sitemap.xml"
  end
end
