defmodule MustacheTest do
  use ExUnit.Case

  test "mustache free template should render as it is" do
    assert Mustache.render("Hello from {Mustache}!\n")  == "Hello from {Mustache}!\n"
  end

  test "Unadorned tags should interpolate content into the template." do
    assert Mustache.render("Hello, {{subject}}!\n", %{subject: "world"}) == "Hello, world!\n"
  end

  test "Basic interpolation should be HTML escaped." do
    assert Mustache.render("These characters should be HTML escaped: {{forbidden}}\n", %{forbidden: "& \" < >"}) == "These characters should be HTML escaped: &amp; &quot; &lt; &gt;\n"
  end
end
