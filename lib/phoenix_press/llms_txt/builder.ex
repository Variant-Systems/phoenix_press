defmodule PhoenixPress.LlmsTxt.Builder do
  @moduledoc false

  def build(opts, entries) do
    title = Keyword.fetch!(opts, :title)
    description = Keyword.get(opts, :description)

    lines = ["# #{title}"]

    lines =
      if description do
        lines ++ ["", "> #{description}"]
      else
        lines
      end

    lines = lines ++ build_entries(entries)

    Enum.join(lines, "\n")
  end

  defp build_entries(entries) do
    Enum.flat_map(entries, fn
      {:section, name} ->
        ["", "## #{name}", ""]

      {:link, path, title, description} ->
        ["- [#{title}](#{path}): #{description}"]
    end)
  end
end
