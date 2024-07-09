defmodule ExChess.Chess.BoardTest do
  @moduledoc false

  use ExUnit.Case

  import ExUnit.CaptureLog
  require Logger

  alias ExChess.Chess.{Board, Move, Notations, Piece}

  test "A board can be represented as a string" do
    board = "♜|♞|♝|♛|♚|♝|♞|♜
♟︎|♟︎|♟︎|♟︎|♟︎|♟︎|♟︎|♟︎
_|_|_|_|_|_|_|_
_|_|_|_|_|_|_|_
_|_|_|_|_|_|_|_
_|_|_|_|_|_|_|_
♟︎|♟︎|♟︎|♟︎|♟︎|♟︎|♟︎|♟︎
♜|♞|♝|♛|♚|♝|♞|♜"

    assert capture_log(fn ->
             Logger.error("#{inspect(Notations.Fen.start_board())}")
           end) =~ board
  end

  test "A piece can be moved on a board" do
    pawn = %Piece{color: :white, role: :pawn}
    board = %Board{turn: :white, pieces: %{:e2 => pawn}}

    board = Board.move(board, Move.new(pawn, :e2, :e4))

    assert board == %Board{turn: :black, pieces: %{:e4 => pawn}}
  end

  test "A piece can be moved on a board only if it is your turn" do
    pawn = %Piece{color: :white, role: :pawn}
    board = %Board{turn: :black, pieces: %{:e2 => pawn}}

    board = Board.move(board, Move.new(pawn, :e2, :e4))

    assert board == %Board{turn: :black, pieces: %{:e2 => pawn}}
  end

  test "A piece can be moved on a board only if the move is with the right piece" do
    pawn = %Piece{color: :white, role: :pawn}
    knight = %Piece{color: :white, role: :knight}
    board = %Board{turn: :white, pieces: %{:e2 => knight}}

    board = Board.move(board, Move.new(pawn, :e2, :e4))

    assert board == %Board{turn: :white, pieces: %{:e2 => knight}}
  end

  test "A piece can be moved on a board only if there is a piece" do
    pawn = %Piece{color: :white, role: :pawn}
    board = %Board{turn: :white, pieces: %{:e2 => pawn}}

    board = Board.move(board, Move.new(pawn, :g2, :g4))

    assert board == %Board{turn: :white, pieces: %{:e2 => pawn}}
  end

  test "A piece can be captured with a piece of opposite color" do
    white_pawn = %Piece{color: :white, role: :pawn}
    black_pawn = %Piece{color: :black, role: :pawn}

    board = %Board{
      turn: :white,
      pieces: %{
        :e2 => white_pawn,
        :d3 => black_pawn
      }
    }

    board = Board.move(board, Move.new(white_pawn, :e2, :d3))

    assert board == %Board{turn: :black, pieces: %{:d3 => white_pawn}}
  end

  test "A piece cannot be captured with a piece of same color" do
    white_pawn = %Piece{color: :white, role: :pawn}

    board = %Board{
      turn: :white,
      pieces: %{
        :e2 => white_pawn,
        :d3 => white_pawn
      }
    }

    board = Board.move(board, Move.new(white_pawn, :e2, :d3))

    assert board == %Board{
             turn: :white,
             pieces: %{
               :e2 => white_pawn,
               :d3 => white_pawn
             }
           }
  end
end
