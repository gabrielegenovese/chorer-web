defmodule Chorerw.Repo do
  use Ecto.Repo,
    otp_app: :chorerw,
    adapter: Ecto.Adapters.Postgres
end
