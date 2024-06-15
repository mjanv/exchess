defmodule ExChessWeb.Live.Games.GameLive do
  @moduledoc false

  use ExChessWeb, :live_view

  alias ExChess.Chess.{Board, Game, Move, Position}
  alias ExChess.Games.GameServer
  alias ExChessWeb.Presence

  def mount(%{"id" => id}, _session, %{assigns: %{current_user: user}} = socket) do
    cond do
      GameServer.dead?(id) ->
        {:ok, push_navigate(socket, to: "/", replace: false)}

      !connected?(socket) ->
        socket
        |> assign(:game, Game.new(id, []) |> IO.inspect())
        |> assign(:selected, nil)
        |> assign(:moves, [])
        |> assign(:spectators, %{})
        |> then(fn socket -> {:ok, socket} end)

      true ->
        game = GameServer.call(%Game{id: id}, :game)
        Presence.game(game, user)
        GameServer.subscribe(game)

        socket
        |> assign(:game, game)
        |> assign(:selected, nil)
        |> assign(:moves, [])
        |> assign(:spectators, %{})
        |> then(fn socket -> {:ok, socket} end)
    end
  end

  def handle_info({:game, %Game{} = game}, socket) do
    socket
    |> assign(:game, game)
    |> then(fn socket -> {:noreply, socket} end)
  end

  def handle_info(
        %{event: "presence_diff", payload: %{leaves: _, joins: joins}},
        %{assigns: %{spectators: spectators}} = socket
      ) do
    socket
    |> assign(:spectators, Map.merge(spectators, joins))
    |> then(fn socket -> {:noreply, socket} end)
  end

  def handle_event(
        "select",
        %{"value" => "", "x" => x, "y" => y},
        %{assigns: %{selected: selected, game: game, moves: moves}} = socket
      ) do
    position = %Position{column: String.to_integer(x), rank: String.to_integer(y)}

    {selected, moves} =
      case {selected, position} do
        {nil, p} ->
          {p, Move.possible_moves(game.board, position)}

        {s, p} when s == p ->
          {p, []}

        {s, p} ->
          move = %Move{from: s, to: p, piece: Board.at(game.board, s)}

          if move in moves do
            GameServer.cast(game, {:move, move})
          end

          {nil, []}
      end

    socket
    |> assign(selected: selected)
    |> assign(moves: moves)
    |> then(fn socket -> {:noreply, socket} end)
  end
end
