defmodule ExChess.Games.GameSupervisor do
  @moduledoc false

  use Horde.DynamicSupervisor

  alias ExChess.Chess.Game
  alias ExChess.Games.GameServer

  def start_link(args) do
    Horde.DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    Horde.DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start(%Game{id: id, clock: clock}) do
    case Horde.DynamicSupervisor.start_child(
           __MODULE__,
           {GameServer, [id: id, time: clock.remaining.white]}
         ) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :error
    end
  end

  def children do
    __MODULE__
    |> Horde.DynamicSupervisor.which_children()
    |> Enum.map(fn
      {:undefined, pid, :worker, _} ->
        case Horde.Registry.keys(ExChess.GameRegistry, pid) do
          [] -> nil
          [id] -> %Game{id: id}
        end

      _ ->
        nil
    end)
    |> Enum.reject(&is_nil/1)
  end
end
