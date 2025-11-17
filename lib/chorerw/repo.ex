defmodule Chorerw.Repo do
  use Ecto.Repo,
    otp_app: :chorerw,
    adapter: Ecto.Adapters.Postgres

  def prepare_query(operation, query, opts) do
    :telemetry.execute(
      [:chorerw, :repo, :query, :count],
      %{count: 1},
      %{}
    )

    super(operation, query, opts)
  end
end
