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
        Nx.Serving,
        serving: EvaluationModel.serving(),
        name: ExChess.Models.EvaluationServing,
        batch_timeout: 100
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
