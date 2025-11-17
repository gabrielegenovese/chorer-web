defmodule ChorerwWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 5_000},
      {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Total requests count
      counter("phoenix.endpoint.stop.duration",
        tag_values: fn _ -> %{} end,
        tag: [],
        description: "Total requests handled"
      ),

      # Requests per second (aggregated in dashboard)
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond},
        description: "Request duration"
      ),

      # Router breakdown (pages)
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond},
        description: "Time spent in each route"
      ),

      # -----------------------------
      # ACTIVE USER METRICS
      # -----------------------------

      last_value("chorerw.live.users.count",
        description: "Current number of connected LiveView users"
      ),
      last_value("chorerw.live.users.peak",
        description: "Peak number of connected LiveView users"
      ),

      # -----------------------------
      # DATABASE METRICS
      # -----------------------------

      counter("chorerw.repo.query.count",
        description: "How many DB queries executed"
      ),
      summary("chorerw.repo.query.total_time",
        unit: {:native, :millisecond},
        description: "Total query time"
      ),

      # -----------------------------
      # VM METRICS
      # -----------------------------
      last_value("vm.memory.total", unit: :byte),
      last_value("vm.system_counts.process_count"),
      last_value("vm.total_run_queue_lengths.total")
    ]
  end

  @doc """
  Periodic measurements (every 5 seconds)
  """
  defp periodic_measurements do
    [
      {__MODULE__, :measure_users, []}
    ]
  end

  # Store peak users in an ETS table
  @ets :telemetry_user_stats

  def start_ets do
    :ets.new(@ets, [:named_table, :public, :set])
    :ets.insert(@ets, {:peak_users, 0})
  rescue
    _ -> :ok
  end

  # Count LiveView connections
  def measure_users do
    start_ets()

    count =
      Phoenix.PubSub.local_broadcasts(Chorerw.PubSub)
      |> Enum.count()

    # Update peak
    [{:peak_users, peak}] = :ets.lookup(@ets, :peak_users)
    new_peak = max(peak, count)
    :ets.insert(@ets, {:peak_users, new_peak})

    :telemetry.execute(
      [:chorerw, :live, :users, :count],
      %{count: count},
      %{}
    )

    :telemetry.execute(
      [:chorerw, :live, :users, :peak],
      %{peak: new_peak},
      %{}
    )
  end
end
