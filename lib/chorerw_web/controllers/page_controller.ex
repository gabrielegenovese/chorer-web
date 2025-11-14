defmodule ChorerwWeb.PageController do
  use ChorerwWeb, :controller

  def home(conn, _params) do
    render(conn, :home, code: nil, result: nil, layout: false)
  end

  def create(conn, %{"code" => code}) do
    render(conn, :home, code: code, result: code, layout: false)
  end
end
