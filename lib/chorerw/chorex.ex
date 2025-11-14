defmodule Chorerw.Chorex do
  def deep_to_string(term) when is_list(term) do
    if Enum.all?(term, &is_integer/1) do
      List.to_string(term)
    else
      Enum.map(term, &deep_to_string/1)
    end
  end

  def deep_to_string(term) when is_binary(term), do: term

  def deep_to_string(term) when is_map(term) do
    term
    |> Enum.map(fn {k, v} ->
      {deep_to_string(k), deep_to_string(v)}
    end)
    |> Map.new()
  end

  def deep_to_string(term), do: term
end
