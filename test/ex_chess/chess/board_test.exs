defmodule ExChess.Chess.BoardTest do
  @moduledoc false

  use ExUnit.Case

  alias ExChess.Chess.{Board, Move, Piece}

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
end
