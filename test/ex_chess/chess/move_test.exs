defmodule ExChess.Chess.MoveTest do
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

  describe "rook" do
    for {position, destinations} <- [
          {:a1, [:a2, :a3, :a4, :a5, :a6, :a7, :a8] ++ [:b1, :c1, :d1, :e1, :f1, :g1, :h1]},
          {:a3, [:a1, :a2, :a4, :a5, :a6, :a7, :a8] ++ [:b3, :c3, :d3, :e3, :f3, :g3, :h3]},
          {:a8, [:a1, :a2, :a3, :a4, :a5, :a6, :a7] ++ [:b8, :c8, :d8, :e8, :f8, :g8, :h8]},
          {:e1, [:e2, :e3, :e4, :e5, :e6, :e7, :e8] ++ [:a1, :b1, :c1, :d1, :f1, :g1, :h1]},
          {:e4, [:e1, :e2, :e3, :e5, :e6, :e7, :e8] ++ [:a4, :b4, :c4, :d4, :f4, :g4, :h4]},
          {:e8, [:e1, :e2, :e3, :e4, :e5, :e6, :e7] ++ [:a8, :b8, :c8, :d8, :f8, :g8, :h8]},
          {:h1, [:h2, :h3, :h4, :h5, :h6, :h7, :h8] ++ [:a1, :b1, :c1, :d1, :e1, :f1, :g1]},
          {:h3, [:h1, :h2, :h4, :h5, :h6, :h7, :h8] ++ [:a3, :b3, :c3, :d3, :e3, :f3, :g3]},
          {:h8, [:h1, :h2, :h3, :h4, :h5, :h6, :h7] ++ [:a8, :b8, :c8, :d8, :e8, :f8, :g8]}
        ] do
      @tag position: position, destinations: destinations
      test "moves vertical and horizontal from #{position}", %{
        position: position,
        destinations: destinations
      } do
        piece = %Piece{color: :white, role: :rook}
        board = %Board{turn: :white, pieces: %{position => piece}}

        moves = Move.possible_moves(board, Position.from_atom(position))

        assert Enum.all?(moves, fn %Move{} = move -> move.piece == piece end)
        assert Enum.all?(moves, fn %Move{} = move -> Position.as_atom(move.from) == position end)
        assert Enum.map(moves, fn move -> Position.as_atom(move.to) end) == destinations
      end
    end
  end

  describe "bishop" do
    for {position, destinations} <- [
          {:a1, [:b2, :c3, :d4, :e5, :f6, :g7, :h8]},
          {:a3, [:b4, :c5, :d6, :e7, :f8] ++ [:b2, :c1]},
          {:a8, [:b7, :c6, :d5, :e4, :f3, :g2, :h1]},
          {:e1, [:f2, :g3, :h4] ++ [:a5, :b4, :c3, :d2]},
          {:e4, [:b1, :c2, :d3] ++ [:f5, :g6, :h7] ++ [:a8, :b7, :c6, :d5] ++ [:f3, :g2, :h1]},
          {:e8, [:a4, :b5, :c6, :d7] ++ [:f7, :g6, :h5]},
          {:h1, [:a8, :b7, :c6, :d5, :e4, :f3, :g2]},
          {:h3, [:f1, :g2] ++ [:c8, :d7, :e6, :f5, :g4]},
          {:h8, [:a1, :b2, :c3, :d4, :e5, :f6, :g7]}
        ] do
      @tag position: position, destinations: destinations
      test "moves diagonals from #{position}", %{
        position: position,
        destinations: destinations
      } do
        piece = %Piece{color: :white, role: :bishop}
        board = %Board{turn: :white, pieces: %{position => piece}}

        moves = Move.possible_moves(board, Position.from_atom(position))

        assert Enum.all?(moves, fn %Move{} = move -> move.piece == piece end)
        assert Enum.all?(moves, fn %Move{} = move -> Position.as_atom(move.from) == position end)
        assert Enum.map(moves, fn move -> Position.as_atom(move.to) end) == destinations
      end
    end
  end

  describe "queen" do
    for {position, destinations} <- [
          {:a1,
           [:a2, :a3, :a4, :a5, :a6, :a7, :a8] ++
             [:b1, :c1, :d1, :e1, :f1, :g1, :h1] ++ [:b2, :c3, :d4, :e5, :f6, :g7, :h8]},
          {:a3,
           [:a1, :a2, :a4, :a5, :a6, :a7, :a8] ++
             [:b3, :c3, :d3, :e3, :f3, :g3, :h3] ++ [:b4, :c5, :d6, :e7, :f8] ++ [:b2, :c1]},
          {:a8,
           [:a1, :a2, :a3, :a4, :a5, :a6, :a7] ++
             [:b8, :c8, :d8, :e8, :f8, :g8, :h8] ++ [:b7, :c6, :d5, :e4, :f3, :g2, :h1]},
          {:e1,
           [:e2, :e3, :e4, :e5, :e6, :e7, :e8] ++
             [:a1, :b1, :c1, :d1, :f1, :g1, :h1] ++ [:f2, :g3, :h4] ++ [:a5, :b4, :c3, :d2]},
          {:e4,
           [:e1, :e2, :e3, :e5, :e6, :e7, :e8] ++
             [:a4, :b4, :c4, :d4, :f4, :g4, :h4] ++
             [:b1, :c2, :d3] ++ [:f5, :g6, :h7] ++ [:a8, :b7, :c6, :d5] ++ [:f3, :g2, :h1]},
          {:e8,
           [:e1, :e2, :e3, :e4, :e5, :e6, :e7] ++
             [:a8, :b8, :c8, :d8, :f8, :g8, :h8] ++ [:a4, :b5, :c6, :d7] ++ [:f7, :g6, :h5]},
          {:h1,
           [:h2, :h3, :h4, :h5, :h6, :h7, :h8] ++
             [:a1, :b1, :c1, :d1, :e1, :f1, :g1] ++ [:a8, :b7, :c6, :d5, :e4, :f3, :g2]},
          {:h3,
           [:h1, :h2, :h4, :h5, :h6, :h7, :h8] ++
             [:a3, :b3, :c3, :d3, :e3, :f3, :g3] ++ [:f1, :g2] ++ [:c8, :d7, :e6, :f5, :g4]},
          {:h8,
           [:h1, :h2, :h3, :h4, :h5, :h6, :h7] ++
             [:a8, :b8, :c8, :d8, :e8, :f8, :g8] ++ [:a1, :b2, :c3, :d4, :e5, :f6, :g7]}
        ] do
      @tag position: position, destinations: destinations
      test "moves horizontally, vertically and diagonals from #{position}", %{
        position: position,
        destinations: destinations
      } do
        piece = %Piece{color: :white, role: :queen}
        board = %Board{turn: :white, pieces: %{position => piece}}

        moves = Move.possible_moves(board, Position.from_atom(position))

        assert Enum.all?(moves, fn %Move{} = move -> move.piece == piece end)
        assert Enum.all?(moves, fn %Move{} = move -> Position.as_atom(move.from) == position end)
        assert Enum.map(moves, fn move -> Position.as_atom(move.to) end) == destinations
      end
    end
  end

  describe "knight" do
    for {position, destinations} <- [
          {:a1, [:b3, :c2]},
          {:a3, [:b5, :c4, :c2, :b1]},
          {:a8, [:c7, :b6]},
          {:e1, [:f3, :g2, :c2, :d3]},
          {:e4, [:f6, :g5, :g3, :f2, :d2, :c3, :c5, :d6]},
          {:e8, [:g7, :f6, :d6, :c7]},
          {:h1, [:f2, :g3]},
          {:h3, [:g1, :f2, :f4, :g5]},
          {:h8, [:g6, :f7]}
        ] do
      @tag position: position, destinations: destinations
      test "moves in L-shape from #{position}", %{
        position: position,
        destinations: destinations
      } do
        piece = %Piece{color: :white, role: :knight}
        board = %Board{turn: :white, pieces: %{position => piece}}

        moves = Move.possible_moves(board, Position.from_atom(position))

        assert Enum.all?(moves, fn %Move{} = move -> move.piece == piece end)
        assert Enum.all?(moves, fn %Move{} = move -> Position.as_atom(move.from) == position end)
        assert Enum.map(moves, fn move -> Position.as_atom(move.to) end) == destinations
      end
    end
  end

  describe "king" do
    for {position, destinations} <- [
          {:a1, [:a2, :b2, :b1]},
          {:a3, [:a4, :b4, :b3, :b2, :a2]},
          {:a8, [:b8, :b7, :a7]},
          {:e1, [:e2, :f2, :f1, :d1, :d2]},
          {:e4, [:e5, :f5, :f4, :f3, :e3, :d3, :d4, :d5]},
          {:e8, [:f8, :f7, :e7, :d7, :d8]},
          {:h1, [:h2, :g1, :g2]},
          {:h3, [:h4, :h2, :g2, :g3, :g4]},
          {:h8, [:h7, :g7, :g8]}
        ] do
      @tag position: position, destinations: destinations
      test "moves in L-shape from #{position}", %{
        position: position,
        destinations: destinations
      } do
        piece = %Piece{color: :white, role: :king}
        board = %Board{turn: :white, pieces: %{position => piece}}

        moves = Move.possible_moves(board, Position.from_atom(position))

        assert Enum.all?(moves, fn %Move{} = move -> move.piece == piece end)
        assert Enum.all?(moves, fn %Move{} = move -> Position.as_atom(move.from) == position end)
        assert Enum.map(moves, fn move -> Position.as_atom(move.to) end) == destinations
      end
    end
  end
end
