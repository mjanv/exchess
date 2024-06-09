defmodule ExChess.GameSupervisor do
  @moduledoc false

  use DynamicSupervisor

  alias ExChess.Chess.Game
  alias ExChess.GameServer

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start(%Game{id: id} = game) do
    case DynamicSupervisor.start_child(__MODULE__, {GameServer, [id: id]}) do
      {:ok, _pid} ->
        GameServer.cast(game, :start)
        :ok

      {:error, {:already_started, _pid}} ->
        :ok
    end
  end

  def children do
    __MODULE__
    |> Supervisor.which_children()
    |> Enum.map(fn
      {:undefined, pid, :worker, _} ->
        case Registry.keys(ExChess.GameRegistry, pid) do
          [] -> nil
          [id] -> %Game{id: id}
        end

      _ ->
        nil
    end)
    |> Enum.reject(&is_nil/1)
  end
end
