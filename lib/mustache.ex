defmodule Mustache do
  def render(template, data \\ %{}) do
    {:ok, pattern} = Regex.compile("\{\{\\w+\}\}")
    scans = Regex.scan(pattern, template) |> List.flatten
    case scans do
      [] -> template
      _ ->
        variable = List.first(scans) |> clean |> String.to_atom
        value = data[variable]
        if value == nil do
          template
        else
          String.replace(template, "{{#{variable}}}", value)
        end
    end
  end

  defp clean(str) do
    String.replace(str, "{{", "")
      |> String.replace("}}", "")
  end
end
