defmodule PhoenixPress.Plug do
  @moduledoc """
  Serves sitemap.xml, robots.txt, feed.xml, and llms.txt from compile-time modules.

  ## Usage

  Add to your endpoint before the router:

      plug PhoenixPress.Plug,
        sitemap: MyAppWeb.Press.Sitemap,
        robots: MyAppWeb.Press.Robots,
        feed: MyAppWeb.Press.Feed,
        llms_txt: MyAppWeb.Press.LlmsTxt

  Any key can be omitted if you don't need that feature.
  """

  @behaviour Plug

  @impl true
  def init(opts) do
    %{
      sitemap: Keyword.get(opts, :sitemap),
      robots: Keyword.get(opts, :robots),
      feed: Keyword.get(opts, :feed),
      llms_txt: Keyword.get(opts, :llms_txt)
    }
  end

  @impl true
  def call(%{path_info: ["sitemap.xml"]} = conn, %{sitemap: mod}) when not is_nil(mod) do
    conn
    |> Plug.Conn.put_resp_content_type("text/xml")
    |> Plug.Conn.put_resp_header("cache-control", "public, max-age=3600")
    |> Plug.Conn.send_resp(200, mod.__sitemap_xml__())
    |> Plug.Conn.halt()
  end

  def call(%{path_info: ["robots.txt"]} = conn, %{robots: mod}) when not is_nil(mod) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.put_resp_header("cache-control", "public, max-age=3600")
    |> Plug.Conn.send_resp(200, mod.__robots_txt__())
    |> Plug.Conn.halt()
  end

  def call(%{path_info: ["feed.xml"]} = conn, %{feed: mod}) when not is_nil(mod) do
    conn
    |> Plug.Conn.put_resp_content_type("application/rss+xml")
    |> Plug.Conn.put_resp_header("cache-control", "public, max-age=3600")
    |> Plug.Conn.send_resp(200, mod.__feed_xml__())
    |> Plug.Conn.halt()
  end

  def call(%{path_info: ["llms.txt"]} = conn, %{llms_txt: mod}) when not is_nil(mod) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.put_resp_header("cache-control", "public, max-age=3600")
    |> Plug.Conn.send_resp(200, mod.__llms_txt__())
    |> Plug.Conn.halt()
  end

  def call(conn, _opts), do: conn
end
