defmodule MustacheTest do
  use ExUnit.Case

  test "Multiple variables" do
    data = %{subject: "world", name: "John"}
    assert Mustache.render("Hello {{subject}}, my name is {{name}}", data) == "Hello world, my name is John"
  end

  test "Multiple triple mustaches" do
    forbidden = %{set1: "& \"", set2: "< >"}
    assert Mustache.render("Not HTML escaped: {{{set1}}} These also not: {{{set2}}}\n", forbidden) == "Not HTML escaped: & \" These also not: < >\n"
  end
end
