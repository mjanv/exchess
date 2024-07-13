defmodule ExChess.Models.Supervisor do
  @moduledoc false

  use Supervisor

  alias ExChess.Models.EvaluationModel

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {
        FLAME.Pool,
        name: ExChess.Models.FlameRunner,
        min: 0,
        max: 10,
        max_concurrency: 5,
        idle_shutdown_after: 15_000
      },
      {
        Nx.Serving,
        serving: EvaluationModel.serving(),
        name: ExChess.Models.EvaluationServing,
        batch_timeout: 100
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
