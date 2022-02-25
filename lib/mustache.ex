defmodule Mustache do
  def render(template, data \\ %{}), do: do_render(template, data, [])

  defp do_render(template, data, context) do
    Enum.reduce(strategies(), template, fn {predicate, function}, template ->
      if predicate.(template) do
        function.(template, data, context)
      else
        template
      end
    end)
  end

  defp double_mustaches(template, data, context) do
    scans = Regex.scan(double_regex(), template) |> List.flatten()

    case scans do
      [] ->
        template

      [first_scan | _] ->
        variable = first_scan |> clean(["{{", "}}"])

        value =
          if escape?(first_scan) do
            key = variable |> String.strip()
            data |> indifferent_access(key, context) |> to_string |> escape
          else
            key = String.replace(variable, "&", "") |> String.strip()
            data |> indifferent_access(key, context) |> to_string
          end

        if value == nil do
          template
        else
          double_mustaches(String.replace(template, "{{#{variable}}}", value), data, context)
        end
    end
  end

  defp process_section(template, data, context) do
    matches = Regex.run(section_regex(), template)
    case matches do
      nil -> template
      [full, predicate, var, body] ->
        val = indifferent_access(data, var, context)

        section_val =
          case predicate do
            "#" -> process_if(body, val, [data | context])
            "^" -> process_unless(body, val, [data | context])
          end

        process_section(String.replace(template, full, section_val), data, context)
    end
  end

  defp process_if(template, val, context) do
    case val do
      nil ->
        ""

      false ->
        ""

      [] ->
        ""

      [_ | _] ->
        val
        |> Stream.map(&do_render(template, &1, context))
        |> Enum.join()

      val ->
        do_render(template, val, context)
    end
  end

  defp process_unless(template, val, context) do
    case val do
      nil -> do_render(template, val, context)
      false -> do_render(template, val, context)
      [] -> do_render(template, val, context)
      _val -> ""
    end
  end

  defp indifferent_access(map, string_key, []) do
    case Access.get(map, string_key) do
      nil -> Access.get(map, resolve_key(string_key))
      val -> val
    end
  end

  defp indifferent_access(map, string_key, [next | rest]) do
    case indifferent_access(map, string_key, []) do
      nil -> indifferent_access(next, string_key, rest)
      val -> val
    end
  end

  defp resolve_key(key) do
    try do
      String.to_existing_atom(key)
    rescue
      ArgumentError -> key
    end
  end

  defp scan_for_dot(template, data, context) do
    regex = regex("{{", "}}", "\\w+(\\.\\w+)+")
    matches = Regex.run(regex, template)
    case matches do
      nil -> template
      _  ->
        path = List.first(matches) |> clean(["{{", "}}"])
        scan_for_dot(interpolate(template, data, path, context), data, context)
    end
  end

  defp triple_mustaches(template, data, context) do
    scans = Regex.scan(triple_regex(), template) |> List.flatten()

    case scans do
      [] -> template
      _  ->
        variable = List.first(scans) |> clean(["{{{", "}}}"])
        key = variable |> String.strip()
        value = data |> indifferent_access(key, context) |> to_string

        if value == nil do
          template
        else
          triple_mustaches(String.replace(template, "{{{#{variable}}}}", value), data, context)
        end
    end
  end

  defp interpolate(template, data, path, context) do
    value = resolve(data, String.split(path, "."), context)
    String.replace(template, "{{#{path}}}", to_string(value))
  end

  def resolve(data, [key | []], context), do: indifferent_access(data, key, context)

  def resolve(data, [key | rest], context) do
    data
    |> indifferent_access(key, context)
    |> resolve(rest, context)
  end

  defp double_regex do
    regex("{{\\s*", "\\s*}}", "&?\\s*\\w+")
  end

  defp triple_regex do
    regex("{{{\\s*", "\\s*}}}")
  end

  defp section_regex do
    ~r<{{\s*(#|\^)\s*([\w.]+)\s*}}(.*?){{\s*/\s*\2\s*}}>
  end

  defp regex(otag, ctag, body \\ "\\w+") do
    Regex.compile!("#{otag}#{body}#{ctag}")
  end

  defp escape?(template) do
    !String.contains?(template, "&")
  end

  defp escape(non_escaped) do
    forbidden = [{"&", "&amp;"}, {"<","&lt;" }, {">", "&gt;"}, {"\"", "&quot;"}]
    Enum.reduce(forbidden, non_escaped, fn (x, str) ->
      String.replace(str, elem(x, 0), elem(x, 1))
    end)
  end

  defp clean(non_cleaned, patterns) do
    Enum.reduce(patterns, non_cleaned, fn(pattern, str) ->
      String.replace(str, pattern, "")
    end)
  end

  defp strategies do
    [
      {fn template -> Regex.match?(section_regex(), template) end, &process_section/3},
      {fn template -> Regex.match?(triple_regex(), template) end, &triple_mustaches/3},
      {fn template -> Regex.match?(regex("{{", "}}", "\\w+(\\.\\w+)+"), template) end,
       &scan_for_dot/3},
      {fn template -> Regex.match?(double_regex(), template) end, &double_mustaches/3}
    ]
  end
end
