defmodule MustacheFeatureTest do
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

  test "Ampersand" do
    assert Mustache.render("These characters should not be HTML escaped: {{&forbidden}}\n", %{forbidden: "& \" < >"}) == "These characters should not be HTML escaped: & \" < >\n"
  end

  test "Integers should interpolate seamlessly." do
    assert Mustache.render("\"{{mph}} miles an hour!\"", %{mph: 85}) == "\"85 miles an hour!\""
  end

  test "Triple Mustache Integer Interpolation" do
    assert Mustache.render("\"{{{mph}}} miles an hour!\"", %{mph: 85}) == "\"85 miles an hour!\""
  end

  test "Ampersand Integer Interpolation" do
    assert Mustache.render("\"{{&mph}} miles an hour!\"", %{mph: 85}) == "\"85 miles an hour!\""
  end

  test "Basic Decimal Interpolation" do
    assert Mustache.render("\"{{power}} jiggawatts!\"", %{power: 1.21}) == "\"1.21 jiggawatts!\""
  end

  test "Triple Mustache Decimal Interpolation" do
    assert Mustache.render("\"{{{power}}} jiggawatts!\"", %{power: 1.21}) == "\"1.21 jiggawatts!\""
  end

  test "Ampersand Decimal Interpolation" do
    assert Mustache.render("\"{{&power}} jiggawatts!\"", %{power: 1.21}) == "\"1.21 jiggawatts!\""
  end

  test "Basic Context Miss Interpolation" do
    assert Mustache.render("I ({{cannot}}) be seen!", %{}) == "I () be seen!"
  end

  test "Triple Mustache Context Miss Interpolation" do
    assert Mustache.render("I ({{{cannot}}}) be seen!", %{}) == "I () be seen!"
  end

  test "Ampersand Context Miss Interpolation" do
    assert Mustache.render("I ({{&cannot}}) be seen!", %{}) == "I () be seen!"
  end

  #Dotted Names

  test "Dotted Names" do
    assert Mustache.render("\"{{person.name}}\" == \"Joe\"",
             %{person: %{name: "Joe"}}) == "\"Joe\" == \"Joe\""
    assert Mustache.render("\"{{person.name.first}}\" == \"Joe\"",
             %{person: %{name: %{first: "Joe"}}}) == "\"Joe\" == \"Joe\""
  end

  test "Dotted Names - String Keys" do
    assert Mustache.render("\"{{person.name}}\" == \"Joe\"",
              %{"person" => %{"name" => "Joe"}}) == "\"Joe\" == \"Joe\""
  end

  test "Dotted Names - Mixed Keys" do
    assert Mustache.render("\"{{person.name}}\" == \"Joe\"",
              %{"person" => %{name: "Joe"}}) == "\"Joe\" == \"Joe\""
  end

  #Sections

  test "Section Interpolation" do
    assert Mustache.render("\"{{person.name}}\" == \"{{#person}}{{name}}{{/person}}\"",
              %{person: %{name: "Joe"}}) == "\"Joe\" == \"Joe\""
  end

  test "Section Interpolation - Inverse" do
    assert Mustache.render("\"{{person.name}}\" == \"{{^person}}{{name}}{{/person}}\"",
              %{person: %{name: "Joe"}}) == "\"Joe\" == \"\""
  end

  test "Section Interpolation - Basic and Inverse" do
    assert Mustache.render("\"{{person.name}}\" == \"{{#person_2}}{{name}}{{/person_2}}{{^person_2}}Joe{{/person_2}}\"",
              %{person: %{name: "Joe"}}) == "\"Joe\" == \"Joe\""
  end

  test "Section Interpolation - list values" do
    assert Mustache.render("\"{{#people}}{{name}} {{/people}}\"",
              %{people: [%{name: "Joe"}, %{name: "Jill"}]}) == "\"Joe Jill \""
  end

  #Whitespace sensitivity

  test "Interpolation - Surrounding Whitespace" do
    assert Mustache.render("| {{string}} |", %{string: '---'}) == "| --- |"
  end


  test "Triple Mustache - Surrounding Whitespace" do
    assert Mustache.render("| {{{string}}} |", %{ string: '---' }) == "| --- |"
  end

  test "Ampersand - Surrounding Whitespace" do
    assert Mustache.render("| {{&string}} |", %{string: '---' }) == "| --- |"
  end

  test "Interpolation - Standalone" do
    assert Mustache.render("  {{string}}\n", %{string: '---' }) == "  ---\n"
  end

  test "Triple Mustache - Standalone" do
    assert Mustache.render("  {{{string}}}\n", %{ string: '---' }) == "  ---\n"
  end

  test "Ampersand - Standalone" do
    assert Mustache.render("  {{&string}}\n", %{ string: '---' }) == "  ---\n"
  end

   # Whitespace Insensitivity

   test "Interpolation With Padding" do
     assert Mustache.render("|{{ string }}|", %{ string: "---" }) == "|---|"
   end

   test "Triple Mustache With Padding" do
     assert Mustache.render("|{{{ string }}}|", %{ string: "---" }) == "|---|"
   end

   test "Ampersand With Padding" do
     assert Mustache.render("|{{& string }}|", %{ string: "---" }) == "|---|"
   end
end
