defmodule Chorerw.CodeNormalizer do
  @moduledoc false

  def normalize(code) do
    code
    |> remove_comments()
    |> replace_module_macro()
  end

  # Remove Erlang comments:
  #  - Line comments: %
  #  - Block comments: /* ... */
  defp remove_comments(code) do
    code
    |> remove_line_comments()
    |> remove_block_comments()
  end

  defp remove_line_comments(code) do
    # Removes everything from % to end of line
    Regex.replace(~r/%.*$/, code, "", global: true)
  end

  defp remove_block_comments(code) do
    # Removes /* ... */ (non-greedy)
    Regex.replace(~r/\/\*.*?\*\//s, code, "", global: true)
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
