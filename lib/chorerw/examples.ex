defmodule Chorerw.Examples do
  @moduledoc false

  @examples_config %{
    "tictacloop" => %{
      title: "Tit-Tac with loop",
      entry: "start/0",
      code: "",
      file: "priv/examples/tictacloop.erl",
      min_lv: true,
      min_gv: false,
      gstates: true
    },
    "dining" => %{
      title: "Two Dining Philosophers",
      entry: "main/0",
      code: "",
      file: "priv/examples/dining.erl",
      min_lv: true,
      min_gv: false,
      gstates: true
    },
    "async" => %{
      title: "Two Async Communications",
      entry: "main/0",
      code: "",
      file: "priv/examples/async.erl",
      min_lv: true,
      min_gv: false,
      gstates: true
    },
    "account" => %{
      title: "Bank Account Race Condition",
      entry: "main/0",
      code: "",
      file: "priv/examples/account.erl",
      min_lv: true,
      min_gv: false,
      gstates: true
    },
    "customer" => %{
      title: "Customer Example",
      entry: "main/0",
      code: "",
      file: "priv/examples/customer.erl",
      min_lv: true,
      min_gv: false,
      gstates: true
    },
    "tictacstop" => %{
      title: "Tic Tac with stop",
      entry: "start/0",
      code: "",
      file: "priv/examples/tictacstop.erl",
      min_lv: true,
      min_gv: false,
      gstates: true
    }
  }

  @on_load :load_examples
  def load_examples do
    loaded =
      Enum.reduce(@examples_config, %{}, fn {key, cfg}, acc ->
        {:ok, code} = File.read(cfg.file)

        new_cfg = Map.put(cfg, :code, code)

        Map.put(acc, key, new_cfg)
      end)

    :persistent_term.put({__MODULE__, :examples}, loaded)
    :ok
  end

  def all, do: :persistent_term.get({__MODULE__, :examples})
end
