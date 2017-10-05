defmodule Mustache do

  def render(template, data \\%{}) do
    Enum.reduce(strategies(), template, fn(strategy, template) ->
      predicate = elem(strategy, 0)
      function = elem(strategy, 1)
      if predicate.(template) do
        function.(template, data)
      else
        template
      end
    end)
  end

  defp double_mustaches(template, data) do
    scans = Regex.scan(double_regex(), template) |> List.flatten
    case scans do
      [] -> template
      _  ->
        first_scan = List.first(scans)
        variable = first_scan |> clean(["{{", "}}"])
        value = if escape?(first_scan) do
          key = variable |> String.strip
          data |> indifferent_access(key) |> to_string |> escape
        else
          key = String.replace(variable, "&", "") |> String.strip
          data |> indifferent_access(key) |> to_string
        end
        if value == nil do
          template
        else
          double_mustaches(String.replace(template, "{{#{variable}}}", value), data)
        end
    end
  end

  defp process_section(template, data) do
    matches = Regex.run(section_regex(), template)
    case matches do
      nil -> template
      [full, predicate, var, body] ->
        val = indifferent_access(data, var)
        section_val = case predicate do
          "#" -> process_if(body, val)
          "^" -> process_unless(body, val)
        end
        process_section(String.replace(template, full, section_val), data)
    end
  end

  defp process_if(template, val) do
    case val do
      nil -> ""
      false -> ""
      [] -> ""
      [_ | _] -> val
                 |> Stream.map(&(render(template, &1)))
                 |> Enum.join()
      val -> render(template, val)
    end
  end

  defp process_unless(template, val) do
    case val do
      nil -> render(template, val)
      false -> render(template, val)
      [] -> render(template, val)
      _val -> ""
    end
  end

  defp indifferent_access(map, string_key) do
    map[string_key] || map[string_key |> String.to_atom]
  end

  defp scan_for_dot(template, data) do
    regex = regex("{{", "}}", "\\w+(\\.\\w+)+")
    matches = Regex.run(regex, template)
    case matches do
      nil -> template
      _  ->
        path = List.first(matches) |> clean(["{{", "}}"])
        scan_for_dot(interpolate(template, data, path), data)
    end
  end

  defp triple_mustaches(template, data) do
    scans = Regex.scan(triple_regex(), template) |> List.flatten
    case scans do
      [] -> template
      _  ->
        variable = List.first(scans) |> clean(["{{{", "}}}"])
        key = variable |> String.strip
        value = data |> indifferent_access(key) |> to_string
        if value == nil do
          template
        else
          triple_mustaches(String.replace(template, "{{{#{variable}}}}", value), data)
        end
    end
  end

  defp interpolate(template, data, path) do
    value = resolve(data, String.split(path, "."))
    String.replace(template, "{{#{path}}}", to_string(value))
  end

  defp resolve(data, path) do
    key = String.to_atom(hd(path))
    case tl(path) do
      [] -> data[key]
      _  -> resolve(data[key], tl(path))
    end
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
    [{ fn(template) -> Regex.match?(section_regex(), template) end,
        fn(template, data) -> process_section(template, data) end },
    { fn(template) -> Regex.match?(triple_regex(), template) end,
        fn(template, data) -> triple_mustaches(template, data) end},
    { fn(template) -> Regex.match?(regex("{{", "}}", "\\w+(\\.\\w+)+"), template) end,
        fn(template, data) -> scan_for_dot(template, data) end },
    { fn(template) -> Regex.match?(double_regex(), template) end,
        fn(template, data) -> double_mustaches(template, data) end}]
  end
end
