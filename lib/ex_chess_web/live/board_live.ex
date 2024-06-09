defmodule ExChessWeb.Live.BoardLive do
  @moduledoc false

  use ExChessWeb, :live_view

  alias ExChess.Chess.{Board, Game, Move, Position}
  alias ExChess.{GameServer, GameSupervisor}
  alias ExChessWeb.Presence

  def mount(%{"id" => id}, _session, socket) do
    socket
    |> assign(:id, id)
    |> then(fn socket ->
      game = %Game{id: id}

      Presence.join(game, socket.assigns.current_user.id)
      GameServer.subscribe(game)
      :ok = GameSupervisor.start(game)
      game = GameServer.call(game, :game)

      assign(socket, :board, game.board)
    end)
    |> assign(:selected, nil)
    |> assign(:moves, [])
    |> assign(:players, %{})
    |> assign(:clocks, %{})
    |> then(fn socket -> {:ok, socket} end)
  end

  def handle_info({:game, %Game{board: board, clock: clock}}, socket) do
    socket
    |> assign(:board, board)
    |> assign(:clock, clock)
    |> then(fn socket -> {:noreply, socket} end)
  end

  def handle_info(
        %{event: "presence_diff", payload: %{leaves: _, joins: joins}},
        %{assigns: %{players: players}} = socket
      ) do
    socket
    |> assign(:players, Map.merge(players, joins))
    |> then(fn socket -> {:noreply, socket} end)
  end

  def handle_event(
        "select",
        %{"value" => "", "x" => x, "y" => y},
        %{assigns: %{id: id, selected: selected, board: board, moves: moves}} = socket
      ) do
    position = %Position{column: String.to_integer(x), rank: String.to_integer(y)}

    {selected, moves} =
      case {selected, position} do
        {nil, p} ->
          {p, Move.possible_moves(board, position)}

        {s, p} when s == p ->
          {p, []}

        {s, p} ->
          move = %Move{from: s, to: p, piece: Board.at(board, s)}

          if move in moves do
            GameServer.cast(%{id: id}, {:move, move})
          end

          {nil, []}
      end

    socket
    |> assign(selected: selected)
    |> assign(moves: moves)
    |> then(fn socket -> {:noreply, socket} end)
  end
end
