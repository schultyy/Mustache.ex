defmodule Mustache do

  def render(template, data \\%{}) do
    cond do
      Regex.match?(triple_regex, template) ->
        triple_mustaches(template, data)
      Regex.match?(double_regex, template) ->
        double_mustaches(template, data)
      true ->
        template
    end
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
          String.replace(template, "{{#{variable}}}", value)
        end
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
          String.replace(template, "{{{#{variable}}}}", value)
        end
    end
  end

  defp double_regex do
    Regex.compile!("\{\{\\w+\}\}")
  end

  defp triple_regex do
    Regex.compile!("\{\{\{\\w+\}\}\}")
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
end
