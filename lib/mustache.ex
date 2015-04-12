defmodule Mustache do

  def render(template, data \\%{}) do
    Enum.reduce(strategies, template, fn(strategy, template) ->
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
    scans = Regex.scan(double_regex, template) |> List.flatten
    case scans do
      [] -> template
      _  ->
        variable = List.first(scans) |> clean(["{{", "}}"]) |> String.to_atom
        value = data[variable] |> to_string |> escape
        if value == nil do
          template
        else
          double_mustaches(String.replace(template, "{{#{variable}}}", value), data)
        end
    end
  end

  defp scan_for_dot(template, data) do
    regex = regex("{{", "}}", "\\w+\\.\\w+")
    scans = Regex.scan(regex, template) |> List.flatten
    case scans do
      [] -> template
      _  ->
        path = List.first(scans) |> clean(["{{", "}}"])
        interpolate(template, data, path)
    end
  end

  defp triple_mustaches(template, data) do
    scans = Regex.scan(triple_regex, template) |> List.flatten
    case scans do
      [] -> template
      _  ->
        variable = List.first(scans) |> clean(["{{{", "}}}"]) |> String.to_atom
        value = data[variable] |> to_string
        if value == nil do
          template
        else
          triple_mustaches(String.replace(template, "{{{#{variable}}}}", value), data)
        end
    end
  end

  defp interpolate(template, data, path) do
    value = resolve(data, String.split(path, "."))
    String.replace(template, "{{#{path}}}", value)
  end

  defp resolve(data, path) do
    key = String.to_atom(hd(path))
    case tl(path) do
      [] -> data[key]
      _  -> resolve(data[key], tl(path))
    end
  end

  defp double_regex do
    regex("{{", "}}")
  end

  defp triple_regex do
    regex("{{{", "}}}")
  end

  defp regex(otag, ctag, body \\ "\\w+") do
    Regex.compile!("#{otag}#{body}#{ctag}")
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
    [{ fn(template) -> Regex.match?(triple_regex, template) end,
        fn(template, data) -> triple_mustaches(template, data) end},
    { fn(template) -> Regex.match?(regex("{{", "}}", "\\w+\\.\\w+"), template) end,
        fn(template, data) -> scan_for_dot(template, data) end },
    { fn(template) -> Regex.match?(double_regex, template) end,
        fn(template, data) -> double_mustaches(template, data) end}]
  end
end
