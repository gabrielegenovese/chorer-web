defmodule ChorerwWeb.PageController do
  use ChorerwWeb, :controller

  def create(conn, params) do
    code = Map.get(params, "code", "")
    entry_point = Map.get(params, "entry_point", "")

    min_lv = params["min_lv"] == "true"
    min_gv = params["min_gv"] == "true"
    gstates = params["gstates"] == "true"

    cleaned = Chorerw.CodeNormalizer.normalize(code)

    code_c = String.to_charlist(cleaned)
    entry_point_c = String.to_charlist(entry_point)

    raw_result =
      try do
        :chorer.analyse(code_c, entry_point_c, min_lv, min_gv, gstates)
      rescue
        e ->
          IO.puts("Chorer crashed:")
          IO.inspect(e)
          %{}
      end

    result = Chorerw.Chorex.deep_to_string(raw_result)
    # IO.inspect(result, label: "Chorer returned")

    render(conn, :home,
      examples: Chorerw.Examples.all(),
      code: code,
      entry_point: entry_point,
      min_lv: params["min_lv"],
      min_gv: params["min_gv"],
      gstates: params["gstates"],
      result: result,
      layout: false
    )
  end

  def home(conn, _params) do
    render(conn, :home,
      examples: Chorerw.Examples.all(),
      code: nil,
      entry_point: nil,
      min_lv: true,
      min_gv: nil,
      gstates: true,
      result: %{},
      layout: false
    )
  end

  def info(conn, _params) do
    render(conn, :info, layout: false)
  end
end
