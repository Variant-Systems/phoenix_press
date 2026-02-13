defmodule PhoenixPress.Sitemap.Builder do
  @moduledoc false

  def build(base_url, urls) do
    base_url = String.trim_trailing(base_url, "/")

    entries =
      Enum.map(urls, fn {path, opts} ->
        loc = base_url <> path
        parts = ["    <loc>#{PhoenixPress.XML.escape(loc)}</loc>"]

        parts =
          if lastmod = opts[:lastmod] do
            parts ++ ["    <lastmod>#{Date.to_iso8601(lastmod)}</lastmod>"]
          else
            parts
          end

        parts =
          if changefreq = opts[:changefreq] do
            parts ++ ["    <changefreq>#{changefreq}</changefreq>"]
          else
            parts
          end

        parts =
          if priority = opts[:priority] do
            parts ++ ["    <priority>#{format_priority(priority)}</priority>"]
          else
            parts
          end

        "  <url>\n" <> Enum.join(parts, "\n") <> "\n  </url>"
      end)

    """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    #{Enum.join(entries, "\n")}
    </urlset>\
    """
  end

  defp format_priority(p) when is_float(p), do: :erlang.float_to_binary(p, decimals: 1)
  defp format_priority(p) when is_integer(p), do: "#{p}.0"
end
