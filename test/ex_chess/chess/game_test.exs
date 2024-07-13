defmodule ExChess.Chess.GameTest do
  use ExUnit.Case

  alias ExChess.Chess.{Game, Notations, Player}

  test "A new game can be created" do
    players = [
      %Player{id: "1", name: "A", color: :white},
      %Player{id: "2", name: "B", color: :black}
    ]

    game = Game.new(nil, players)

    assert game == %ExChess.Chess.Game{
             id: game.id,
             players: %{
               black: %ExChess.Chess.Player{id: "2", name: "B", color: :black},
               white: %ExChess.Chess.Player{id: "1", name: "A", color: :white}
             },
             board:
               Notations.Fen.board("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"),
             clock: %ExChess.Chess.Clock{
               timer: nil,
               status: :created,
               interval: 1000,
               turn: :white,
               remaining: %{black: 120_000, white: 120_000}
             }
           }
  end

  test "A game can be resigned" do
    players = [
      %Player{id: "1", name: "A", color: :white},
      %Player{id: "2", name: "B", color: :black}
    ]

    game = Game.new(nil, players)
    game = Game.resign(game, :white)

    assert game.status == {:win, :white}
  end
end
