# Changelog

## 0.2.0 (2026-02-14)

- Add compile-time llms.txt generation via `PhoenixPress.LlmsTxt`
- Serve `/llms.txt` from `PhoenixPress.Plug` with `llms_txt:` option

## 0.1.0 (2026-02-13)

Initial release.

- Compile-time sitemap.xml generation via `PhoenixPress.Sitemap`
- Compile-time robots.txt generation via `PhoenixPress.Robots`
- Compile-time RSS 2.0 feed generation via `PhoenixPress.Feed`
- `PhoenixPress.Plug` to serve all three from a single plug
- XML entity escaping for all user-provided content
- Cache-Control headers on all responses
