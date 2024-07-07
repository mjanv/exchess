defmodule ExChess.Games.GameServer do
  @moduledoc false

  use GenServer, restart: :transient

  require Logger

  alias ExChess.Chess.{Board, Clock, Game, Move, Notations}
  alias ExChess.Games.GameRecord

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: via(args[:id]))
  end

  def via(id), do: {:via, Horde.Registry, {ExChess.GameRegistry, id}}

  @impl true
  def init(id: id, time: time) do
    %Game{
      id: id,
      board: Notations.Fen.start_board(),
      clock: Clock.new(1_000, time)
    }
    |> tap(fn %{id: id} -> Logger.info("[#{__MODULE__}] Starting game server #{id}") end)
    |> tap(fn game -> broadcast(game, {:game, game}) end)
    |> tap(fn game -> broadcast({:game_started, game}) end)
    |> then(fn game -> {:ok, game} end)
  end

  def alive?(id), do: !dead?(id)
  def dead?(id), do: id |> via() |> GenServer.whereis() |> is_nil()

  def call(%{id: id}, message), do: GenServer.call(via(id), message)
  def cast(%{id: id}, message), do: GenServer.cast(via(id), message)

  @impl true
  def handle_call(:game, _from, game) do
    {:reply, game, game}
  end

  @impl true
  def handle_cast(:start, %{id: _id, clock: clock} = game) do
    game
    |> Map.put(:clock, Clock.start(clock))
    |> then(fn game -> {:noreply, game} end)
  end

  @impl true
  def handle_cast({:move, %Move{} = move}, %{board: board, clock: clock} = game) do
    game
    |> Map.put(:clock, Clock.switch(clock))
    |> Map.put(:board, Board.move(board, move))
    |> tap(fn game -> broadcast(game, {:game, game}) end)
    |> then(fn game -> {:noreply, game} end)
  end

  @impl true
  def handle_info(:tick, %{clock: %Clock{status: :stopped} = clock} = game) do
    game
    |> Map.put(:clock, clock)
    |> tap(fn game -> broadcast(game, {:game, game}) end)
    |> tap(fn game -> broadcast({:game_stopped, game}) end)
    |> then(fn game -> {:stop, :normal, game} end)
  end

  @impl true
  def handle_info(:tick, %{clock: %Clock{} = clock} = game) do
    game
    |> Map.put(:clock, Clock.tick(clock))
    |> tap(fn game -> broadcast(game, {:game, game}) end)
    |> then(fn game -> {:noreply, game} end)
  end

  @impl true
  def terminate(_reason, %{id: id} = game) do
    id
    |> GameRecord.get_game!()
    |> GameRecord.update_game(%{result: :white})

    game
    |> tap(fn game -> broadcast({:game_stopped, game}) end)

    :ok
  end

  def subscribe do
    Phoenix.PubSub.subscribe(ExChess.PubSub, "games")
  end

  def subscribe(%{id: id}) do
    Phoenix.PubSub.subscribe(ExChess.PubSub, "game:#{id}")
  end

  defp broadcast(%{id: id}, message) do
    Phoenix.PubSub.broadcast(ExChess.PubSub, "game:#{id}", message)
  end

  defp broadcast(message) do
    Phoenix.PubSub.broadcast(ExChess.PubSub, "games", message)
  end
end
