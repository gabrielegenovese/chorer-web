defmodule Chorerw.CodeNormalizer do
  @moduledoc false

  @doc """
  Normalize Erlang source text for chorer:

  - remove /* ... */ block comments (dotall)
  - remove line comments starting with `%`
  - replace occurrences of `?MODULE` with the module name from `-module(name).`
  - trim leading/trailing whitespace
  """
  def normalize(code) when is_binary(code) do
    code
    |> remove_block_comments()
    |> remove_line_comments()
    |> replace_module_macro()
    |> String.trim()
  end

  # Remove /* ... */ (non-greedy, dot matches newline)
  defp remove_block_comments(code) do
    Regex.replace(~r/\/\*.*?\*\//msu, code, "")
  end

  # Remove everything from % to end of *each* line.
  # Use the multiline flag so $ matches end-of-line.
  defp remove_line_comments(code) do
    Regex.replace(~r/%.*$/m, code, "")
  end

  # Extract module name from -module(name). allowing whitespace, atoms or simple identifiers
  # and replace ?MODULE with the extracted name.
  defp replace_module_macro(code) do
    case Regex.run(~r/-module\s*\(\s*([A-Za-z0-9_]+)\s*\)\s*\./m, code) do
      [_, modname] ->
        String.replace(code, "?MODULE", modname)

      _ ->
        code
    end
  end
end
