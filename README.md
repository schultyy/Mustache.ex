Mustache
========

[![Build Status](https://travis-ci.org/schultyy/Mustache.ex.svg?branch=master)](https://travis-ci.org/schultyy/Mustache.ex)
[![Module Version](https://img.shields.io/hexpm/v/mustache.svg)](https://hex.pm/packages/mustache)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/mustache/)
[![Total Download](https://img.shields.io/hexpm/dt/mustache.svg)](https://hex.pm/packages/mustache)
[![License](https://img.shields.io/hexpm/l/mustache.svg)](https://github.com/schultyy/Mustache.ex/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/schultyy/Mustache.ex.svg)](https://github.com/schultyy/Mustache.ex/commits/master)

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

Copyright and License
=====================

Copyright (c) 2015 Jan Schulte

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
