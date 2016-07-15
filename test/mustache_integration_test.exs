defmodule MustacheTest do
  use ExUnit.Case

  test "Multiple variables" do
    data = %{subject: "world", name: "John"}
    assert Mustache.render("Hello {{subject}}, my name is {{name}}", data) == "Hello world, my name is John"
  end

  test "String variables preferred over atoms" do
    data = %{"foo" => "string", :foo => "atom"}
    assert Mustache.render("This is a {{foo}}", data) == "This is a string"
  end

  test "Multiple triple mustaches" do
    forbidden = %{set1: "& \"", set2: "< >"}
    assert Mustache.render("Not HTML escaped: {{{set1}}} These also not: {{{set2}}}\n", forbidden) == "Not HTML escaped: & \" These also not: < >\n"
  end

  test "Renders HTML document" do
    data = %{pagetitle: "User details", content: "<strong>Foo</strong>", user: %{
        name: "Alice",
        email: "alice@example.org"
      }}
    template = """
    <html>
      <head><title>{{pagetitle}}</title></head>
      <body>
        <h1>Name: {{user.name}}</h1>
        <h2>Email: {{user.email}}</h2>
        <p>Unescaped {{{content}}}</p>
      </body>
    </html>
    """
    expected = """
    <html>
      <head><title>User details</title></head>
      <body>
        <h1>Name: Alice</h1>
        <h2>Email: alice@example.org</h2>
        <p>Unescaped <strong>Foo</strong></p>
      </body>
    </html>
    """
    actual = Mustache.render(template, data)
    assert String.strip(actual) == String.strip(expected)
  end
end
