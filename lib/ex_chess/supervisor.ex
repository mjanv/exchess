defmodule ExChess.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      ExChess.Games.Supervisor,
      ExChess.Repo
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
