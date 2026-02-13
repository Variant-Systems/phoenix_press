defmodule PhoenixPress.Feed.Builder do
  @moduledoc false

  def build(feed_opts, entries) do
    title = Keyword.fetch!(feed_opts, :title)
    description = Keyword.fetch!(feed_opts, :description)
    base_url = Keyword.fetch!(feed_opts, :base_url) |> String.trim_trailing("/")
    language = Keyword.get(feed_opts, :language, "en")

    items =
      Enum.map(entries, fn {entry_title, opts} ->
        link = base_url <> (opts[:link] || "")

        parts = [
          "      <title>#{PhoenixPress.XML.escape(entry_title)}</title>",
          "      <link>#{PhoenixPress.XML.escape(link)}</link>"
        ]

        parts =
          if desc = opts[:description] do
            parts ++ ["      <description>#{PhoenixPress.XML.escape(desc)}</description>"]
          else
            parts
          end

        parts =
          if date = opts[:pub_date] do
            parts ++ ["      <pubDate>#{format_rfc822(date)}</pubDate>"]
          else
            parts
          end

        parts =
          if author = opts[:author] do
            parts ++ ["      <author>#{PhoenixPress.XML.escape(author)}</author>"]
          else
            parts
          end

        parts = parts ++ ["      <guid>#{PhoenixPress.XML.escape(link)}</guid>"]

        "    <item>\n" <> Enum.join(parts, "\n") <> "\n    </item>"
      end)

    """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
      <channel>
        <title>#{PhoenixPress.XML.escape(title)}</title>
        <link>#{PhoenixPress.XML.escape(base_url)}</link>
        <description>#{PhoenixPress.XML.escape(description)}</description>
        <language>#{language}</language>
        <atom:link href="#{PhoenixPress.XML.escape(base_url)}/feed.xml" rel="self" type="application/rss+xml"/>
    #{Enum.join(items, "\n")}
      </channel>
    </rss>\
    """
  end

  defp format_rfc822(%Date{} = date) do
    day_of_week =
      date
      |> Date.day_of_week()
      |> day_name()

    month = month_name(date.month)

    "#{day_of_week}, #{String.pad_leading(to_string(date.day), 2, "0")} #{month} #{date.year} 00:00:00 +0000"
  end

  defp day_name(1), do: "Mon"
  defp day_name(2), do: "Tue"
  defp day_name(3), do: "Wed"
  defp day_name(4), do: "Thu"
  defp day_name(5), do: "Fri"
  defp day_name(6), do: "Sat"
  defp day_name(7), do: "Sun"

  defp month_name(1), do: "Jan"
  defp month_name(2), do: "Feb"
  defp month_name(3), do: "Mar"
  defp month_name(4), do: "Apr"
  defp month_name(5), do: "May"
  defp month_name(6), do: "Jun"
  defp month_name(7), do: "Jul"
  defp month_name(8), do: "Aug"
  defp month_name(9), do: "Sep"
  defp month_name(10), do: "Oct"
  defp month_name(11), do: "Nov"
  defp month_name(12), do: "Dec"
end
