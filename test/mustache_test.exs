defmodule MustacheTest do
  use ExUnit.Case

  test "mustache free template should render as it is" do
    assert Mustache.render("Hello from {Mustache}!\n")  == "Hello from {Mustache}!\n"
  end
end
