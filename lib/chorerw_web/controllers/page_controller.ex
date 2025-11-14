defmodule ChorerwWeb.PageController do
  use ChorerwWeb, :controller

  def create(conn, %{"code" => code}) do
    # Temp options
    entrypoint = "main/0"
    min_lv = true
    min_gv = false
    gstates = true

    cleaned = Chorerw.CodeNormalizer.normalize(code)

    code_c = String.to_charlist(cleaned)
    entrypoint_c = String.to_charlist(entrypoint)

    raw_result =
      try do
        :chorer.analyse(code_c, entrypoint_c, min_lv, min_gv, gstates)
      rescue
        e ->
          IO.puts("Chorer crashed:")
          IO.inspect(e)
          %{}
      end

    result = Chorerw.Chorex.deep_to_string(raw_result)
    # IO.inspect(result, label: "Chorer returned")

    render(conn, :home,
      code: code,
      result: result,
      layout: false
    )
  end

  def home(conn, _params) do
    render(conn, :home, code: nil, result: %{}, layout: false)
  end
end
