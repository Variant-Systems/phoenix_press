defmodule PhoenixPress.LlmsTxtTest do
  use ExUnit.Case, async: true

  defmodule TestLlmsTxt do
    use PhoenixPress.LlmsTxt,
      title: "My App",
      description: "A platform for managing widgets."

    section "Docs"
    link "/docs/getting-started", "Getting Started", "How to set up the project"
    link "/docs/api", "API Reference", "Full API documentation"

    section "Optional"
    link "/blog", "Blog", "Latest updates"
  end

  defmodule TitleOnlyLlmsTxt do
    use PhoenixPress.LlmsTxt, title: "Minimal App"

    section "Links"
    link "/about", "About", "About us"
  end

  defmodule DynamicLlmsTxt do
    use PhoenixPress.LlmsTxt,
      title: "Dynamic App",
      description: "Generated from a list."

    section "Pages"

    for {path, title, desc} <- [
          {"/one", "Page One", "First page"},
          {"/two", "Page Two", "Second page"}
        ] do
      link path, title, desc
    end
  end

  test "generates correct title and description" do
    output = TestLlmsTxt.__llms_txt__()
    assert output =~ "# My App"
    assert output =~ "> A platform for managing widgets."
  end

  test "generates sections as h2 headings" do
    output = TestLlmsTxt.__llms_txt__()
    assert output =~ "## Docs"
    assert output =~ "## Optional"
  end

  test "generates links in correct format" do
    output = TestLlmsTxt.__llms_txt__()
    assert output =~ "- [Getting Started](/docs/getting-started): How to set up the project"
    assert output =~ "- [API Reference](/docs/api): Full API documentation"
    assert output =~ "- [Blog](/blog): Latest updates"
  end

  test "preserves section ordering" do
    output = TestLlmsTxt.__llms_txt__()
    docs_pos = :binary.match(output, "## Docs") |> elem(0)
    optional_pos = :binary.match(output, "## Optional") |> elem(0)
    assert docs_pos < optional_pos
  end

  test "works without description" do
    output = TitleOnlyLlmsTxt.__llms_txt__()
    assert output =~ "# Minimal App"
    refute output =~ ">"
    assert output =~ "- [About](/about): About us"
  end

  test "supports dynamic entries with for" do
    output = DynamicLlmsTxt.__llms_txt__()
    assert output =~ "- [Page One](/one): First page"
    assert output =~ "- [Page Two](/two): Second page"
  end

  test "full output structure" do
    expected = """
    # My App

    > A platform for managing widgets.

    ## Docs

    - [Getting Started](/docs/getting-started): How to set up the project
    - [API Reference](/docs/api): Full API documentation

    ## Optional

    - [Blog](/blog): Latest updates\
    """

    assert TestLlmsTxt.__llms_txt__() == expected
  end
end
