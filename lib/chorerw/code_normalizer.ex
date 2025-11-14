defmodule Chorerw.CodeNormalizer do
  @moduledoc false

  def normalize(code) do
    code
    |> replace_module_macro()
  end

  defp replace_module_macro(code) do
    # Extract module name from -module(X).
    case Regex.run(~r/^-module\((.*?)\)\./m, code) do
      [_, modname] ->
        String.replace(code, "?MODULE", modname)

      _ ->
        code
    end
  end
end
