defmodule PhoenixPress.Robots.Builder do
  @moduledoc false

  def build(base_url, rules, sitemaps) do
    base_url = String.trim_trailing(base_url, "/")

    lines = ["User-agent: *"]

    lines =
      lines ++
        Enum.map(rules, fn
          {:allow, path} -> "Allow: #{path}"
          {:disallow, path} -> "Disallow: #{path}"
        end)

    lines =
      lines ++
        Enum.map(sitemaps, fn path ->
          "Sitemap: #{base_url}#{path}"
        end)

    Enum.join(lines, "\n")
  end
end
