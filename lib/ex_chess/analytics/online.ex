defmodule ExChess.Analytics.Online do
  @moduledoc false

  use GenServer

  require Logger

  alias ExChess.Games

  @interval 1_000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    %{
      online_users: 0,
      online_games: 0
    }
    |> tap(fn _ -> Logger.info("[#{__MODULE__}] Starting server") end)
    |> tap(fn _ -> Process.send_after(self(), :work, @interval) end)
    |> then(fn stats -> {:ok, stats} end)
  end

  @impl true
  def handle_info(:work, stats) do
    Process.send_after(self(), :work, @interval)

    online_users =
      ExChessWeb.Presence
      |> :rpc.multicall(:list, ["users"])
      |> elem(0)
      |> Enum.map(&map_size/1)
      |> Enum.sum()

    online_games =
      DynamicSupervisor
      |> :rpc.multicall(:count_children, [Games.GameSupervisor])
      |> elem(0)
      |> Enum.map(& &1.active)
      |> Enum.sum()

    new_stats = %{
      online_users: online_users,
      online_games: online_games
    }

    if new_stats != stats do
      Phoenix.PubSub.broadcast(ExChess.PubSub, "analytics:online", {:stats, new_stats})
    end

    {:noreply, new_stats}
  end

  @impl true
  def handle_call(:stats, _from, stats) do
    {:reply, stats, stats}
  end

  def online_stats, do: GenServer.call(__MODULE__, :stats)

  def subscribe, do: Phoenix.PubSub.subscribe(ExChess.PubSub, "analytics:online")
end
