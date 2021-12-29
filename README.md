Mustache
========
[![Build Status](https://travis-ci.org/schultyy/Mustache.ex.svg?branch=master)](https://travis-ci.org/schultyy/Mustache.ex)

Minimal templating with {{mustaches}} in Elixir - [http://mustache.github.com/](http://mustache.github.com/)

Prerequisites
=============

- Elixir 1.0.x

Installation
============

In your `mix.exs`, add Mustache as dependency:

```elixir
defp deps do
  [{:mustache, "~> 0.4.0"}]
end
```

Example
=======

```elixir
Mustache.render("Hello, my name is {{name}}", %{name: "Alice"})
```

Tests
=====

The test folder contains tests showing the currently implemented feature set. The tests are taken from the mustache specs
project [https://github.com/mustache/spec](https://github.com/mustache/spec).

Run currently passing tests:

```bash
$ mix test --exclude pending:true
```

Run all tests:

```bash
$ mix test
```
