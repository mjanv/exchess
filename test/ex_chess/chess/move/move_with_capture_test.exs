defmodule ExChess.Chess.Move.MoveWithCaptureTest do
  @moduledoc false

  use ExUnit.Case

  alias ExChess.Chess.{Board, Move, Piece, Position}

  describe "white pawn" do
    for {position, destinations} <- [
          {:a2, [:a3, :a4]},
          {:a3, [:a4]},
          {:a4, [:a5]},
          {:a5, [:a6]},
          {:a6, [:a7]},
          {:a7, [:a8]},
          {:a8, []}
        ] do
      @tag position: position, destinations: destinations
      test "moves forward from #{position}", %{position: position, destinations: destinations} do
        piece = %Piece{color: :white, role: :pawn}
        board = %Board{turn: :white, pieces: %{position => piece}}

        moves = Move.possible_moves(board, Position.from_atom(position))

        assert Enum.all?(moves, fn %Move{} = move -> move.piece == piece end)
        assert Enum.all?(moves, fn %Move{} = move -> Position.as_atom(move.from) == position end)
        assert Enum.map(moves, fn move -> Position.as_atom(move.to) end) == destinations
      end
    end
  end

  describe "black pawn" do
    for {position, destinations} <- [
          {:a1, []},
          {:a2, [:a1]},
          {:a3, [:a2]},
          {:a4, [:a3]},
          {:a5, [:a4]},
          {:a6, [:a5]},
          {:a7, [:a6, :a5]}
        ] do
      @tag position: position, destinations: destinations
      test "moves forward from #{position}", %{position: position, destinations: destinations} do
        piece = %Piece{color: :black, role: :pawn}
        board = %Board{turn: :black, pieces: %{position => piece}}

        moves = Move.possible_moves(board, Position.from_atom(position))

        assert Enum.all?(moves, fn %Move{} = move -> move.piece == piece end)
        assert Enum.all?(moves, fn %Move{} = move -> Position.as_atom(move.from) == position end)
        assert Enum.map(moves, fn move -> Position.as_atom(move.to) end) == destinations
      end
    end
  end
end
