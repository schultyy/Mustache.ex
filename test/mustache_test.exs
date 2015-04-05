defmodule MustacheTest do
  use ExUnit.Case

  test "No Interpolation" do
    assert Mustache.render("Hello from {Mustache}!\n")  == "Hello from {Mustache}!\n"
  end

  test "Basic Interpolation" do
    assert Mustache.render("Hello, {{subject}}!\n", %{subject: "world"}) == "Hello, world!\n"
  end

  test "HTML Escaping" do
    assert Mustache.render("These characters should be HTML escaped: {{forbidden}}\n", %{forbidden: "& \" < >"}) == "These characters should be HTML escaped: &amp; &quot; &lt; &gt;\n"
  end

  test "Triple Mustache" do
    assert Mustache.render("These characters should not be HTML escaped: {{{forbidden}}}\n", %{forbidden: "& \" < >"}) == "These characters should not be HTML escaped: & \" < >\n"
  end

  @tag :pending
  test "Ampersand" do
    assert Mustache.render("These characters should not be HTML escaped: {{&forbidden}}\n", %{forbidden: "& \" < >"}) == "These characters should not be HTML escaped: & \" < >\n"
  end

  test "Integers should interpolate seamlessly." do
    assert Mustache.render("\"{{mph}} miles an hour!\"", %{mph: 85}) == "\"85 miles an hour!\""
  end

  test "Triple Mustache Integer Interpolation" do
    assert Mustache.render("\"{{{mph}}} miles an hour!\"", %{mph: 85}) == "\"85 miles an hour!\""
  end

  @tag :pending
  test "Ampersand Integer Interpolation" do
    assert Mustache.render("\"{{&mph}} miles an hour!\"", %{mph: 85}) == "\"85 miles an hour!\""
  end

  test "Basic Decimal Interpolation" do
    assert Mustache.render("\"{{power}} jiggawatts!\"", %{power: 1.21}) == "\"1.21 jiggawatts!\""
  end

  test "Triple Mustache Decimal Interpolation" do
    assert Mustache.render("\"{{{power}}} jiggawatts!\"", %{power: 1.21}) == "\"1.21 jiggawatts!\""
  end

  @tag :pending
  test "Ampersand Decimal Interpolation" do
    assert Mustache.render("\"{{&power}} jiggawatts!\"", %{power: 1.21}) == "\"1.21 jiggawatts!\""
  end

  test "Basic Context Miss Interpolation" do
    assert Mustache.render("I ({{cannot}}) be seen!", %{}) == "I () be seen!"
  end
end
