defmodule ExChess.Chess.Notations.FenTest do
  use ExUnit.Case

  alias ExChess.Chess.Notations.Fen
  alias ExChess.Chess.{Board, History, Piece}

  describe "Fen -> Board" do
    test "Starting position" do
      notation = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

      board = Fen.board(notation)

      assert board == %Board{
               turn: :white,
               status: :active,
               history: %History{moves: []},
               captures: [],
               pieces: %{
                 :a1 => %Piece{color: :white, role: :rook},
                 :b1 => %Piece{color: :white, role: :knight},
                 :c1 => %Piece{color: :white, role: :bishop},
                 :d1 => %Piece{color: :white, role: :queen},
                 :e1 => %Piece{color: :white, role: :king},
                 :f1 => %Piece{color: :white, role: :bishop},
                 :g1 => %Piece{color: :white, role: :knight},
                 :h1 => %Piece{color: :white, role: :rook},
                 :a2 => %Piece{color: :white, role: :pawn},
                 :b2 => %Piece{color: :white, role: :pawn},
                 :c2 => %Piece{color: :white, role: :pawn},
                 :d2 => %Piece{color: :white, role: :pawn},
                 :e2 => %Piece{color: :white, role: :pawn},
                 :f2 => %Piece{color: :white, role: :pawn},
                 :g2 => %Piece{color: :white, role: :pawn},
                 :h2 => %Piece{color: :white, role: :pawn},
                 :a8 => %Piece{color: :black, role: :rook},
                 :b8 => %Piece{color: :black, role: :knight},
                 :c8 => %Piece{color: :black, role: :bishop},
                 :d8 => %Piece{color: :black, role: :queen},
                 :e8 => %Piece{color: :black, role: :king},
                 :f8 => %Piece{color: :black, role: :bishop},
                 :g8 => %Piece{color: :black, role: :knight},
                 :h8 => %Piece{color: :black, role: :rook},
                 :a7 => %Piece{color: :black, role: :pawn},
                 :b7 => %Piece{color: :black, role: :pawn},
                 :c7 => %Piece{color: :black, role: :pawn},
                 :d7 => %Piece{color: :black, role: :pawn},
                 :e7 => %Piece{color: :black, role: :pawn},
                 :f7 => %Piece{color: :black, role: :pawn},
                 :g7 => %Piece{color: :black, role: :pawn},
                 :h7 => %Piece{color: :black, role: :pawn}
               }
             }
    end

    test "Scottish opening" do
      notation = "r1bq1rk1/p1pp1ppp/2p2n2/8/1b2P3/2NB4/PPP2PPP/R1BQ1RK1 b - - 3 8"

      board = Fen.board(notation)

      assert board == %Board{
               turn: :black,
               status: :active,
               captures: [],
               history: %History{moves: []},
               pieces: %{
                 a1: %Piece{color: :white, role: :rook},
                 a2: %Piece{color: :white, role: :pawn},
                 a7: %Piece{color: :black, role: :pawn},
                 a8: %Piece{color: :black, role: :rook},
                 b2: %Piece{color: :white, role: :pawn},
                 b4: %Piece{color: :black, role: :bishop},
                 c1: %Piece{color: :white, role: :bishop},
                 c2: %Piece{color: :white, role: :pawn},
                 c3: %Piece{color: :white, role: :knight},
                 c6: %Piece{color: :black, role: :pawn},
                 c7: %Piece{color: :black, role: :pawn},
                 c8: %Piece{color: :black, role: :bishop},
                 d1: %Piece{color: :white, role: :queen},
                 d3: %Piece{color: :white, role: :bishop},
                 d7: %Piece{color: :black, role: :pawn},
                 d8: %Piece{color: :black, role: :queen},
                 e4: %Piece{color: :white, role: :pawn},
                 f1: %Piece{color: :white, role: :rook},
                 f2: %Piece{color: :white, role: :pawn},
                 f6: %Piece{color: :black, role: :knight},
                 f7: %Piece{color: :black, role: :pawn},
                 f8: %Piece{color: :black, role: :rook},
                 g1: %Piece{color: :white, role: :king},
                 g2: %Piece{color: :white, role: :pawn},
                 g7: %Piece{color: :black, role: :pawn},
                 g8: %Piece{color: :black, role: :king},
                 h2: %Piece{color: :white, role: :pawn},
                 h7: %Piece{color: :black, role: :pawn}
               }
             }
    end
  end

  describe "Board -> Fen" do
    test "Starting position" do
      board = %Board{
        turn: :white,
        status: :active,
        history: %History{moves: []},
        captures: [],
        pieces: %{
          :a1 => %Piece{color: :white, role: :rook},
          :b1 => %Piece{color: :white, role: :knight},
          :c1 => %Piece{color: :white, role: :bishop},
          :d1 => %Piece{color: :white, role: :queen},
          :e1 => %Piece{color: :white, role: :king},
          :f1 => %Piece{color: :white, role: :bishop},
          :g1 => %Piece{color: :white, role: :knight},
          :h1 => %Piece{color: :white, role: :rook},
          :a2 => %Piece{color: :white, role: :pawn},
          :b2 => %Piece{color: :white, role: :pawn},
          :c2 => %Piece{color: :white, role: :pawn},
          :d2 => %Piece{color: :white, role: :pawn},
          :e2 => %Piece{color: :white, role: :pawn},
          :f2 => %Piece{color: :white, role: :pawn},
          :g2 => %Piece{color: :white, role: :pawn},
          :h2 => %Piece{color: :white, role: :pawn},
          :a8 => %Piece{color: :black, role: :rook},
          :b8 => %Piece{color: :black, role: :knight},
          :c8 => %Piece{color: :black, role: :bishop},
          :d8 => %Piece{color: :black, role: :queen},
          :e8 => %Piece{color: :black, role: :king},
          :f8 => %Piece{color: :black, role: :bishop},
          :g8 => %Piece{color: :black, role: :knight},
          :h8 => %Piece{color: :black, role: :rook},
          :a7 => %Piece{color: :black, role: :pawn},
          :b7 => %Piece{color: :black, role: :pawn},
          :c7 => %Piece{color: :black, role: :pawn},
          :d7 => %Piece{color: :black, role: :pawn},
          :e7 => %Piece{color: :black, role: :pawn},
          :f7 => %Piece{color: :black, role: :pawn},
          :g7 => %Piece{color: :black, role: :pawn},
          :h7 => %Piece{color: :black, role: :pawn}
        }
      }

      notation = Fen.notation(board)

      # KQkq - 0 1"
      assert notation == "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w"
    end

    test "Scottish opening" do
      board = %Board{
        turn: :black,
        status: :active,
        captures: [],
        history: %History{moves: []},
        pieces: %{
          a1: %Piece{color: :white, role: :rook},
          a2: %Piece{color: :white, role: :pawn},
          a7: %Piece{color: :black, role: :pawn},
          a8: %Piece{color: :black, role: :rook},
          b2: %Piece{color: :white, role: :pawn},
          b4: %Piece{color: :black, role: :bishop},
          c1: %Piece{color: :white, role: :bishop},
          c2: %Piece{color: :white, role: :pawn},
          c3: %Piece{color: :white, role: :knight},
          c6: %Piece{color: :black, role: :pawn},
          c7: %Piece{color: :black, role: :pawn},
          c8: %Piece{color: :black, role: :bishop},
          d1: %Piece{color: :white, role: :queen},
          d3: %Piece{color: :white, role: :bishop},
          d7: %Piece{color: :black, role: :pawn},
          d8: %Piece{color: :black, role: :queen},
          e4: %Piece{color: :white, role: :pawn},
          f1: %Piece{color: :white, role: :rook},
          f2: %Piece{color: :white, role: :pawn},
          f6: %Piece{color: :black, role: :knight},
          f7: %Piece{color: :black, role: :pawn},
          f8: %Piece{color: :black, role: :rook},
          g1: %Piece{color: :white, role: :king},
          g2: %Piece{color: :white, role: :pawn},
          g7: %Piece{color: :black, role: :pawn},
          g8: %Piece{color: :black, role: :king},
          h2: %Piece{color: :white, role: :pawn},
          h7: %Piece{color: :black, role: :pawn}
        }
      }

      notation = Fen.notation(board)

      # - - 3 8"
      assert notation == "r1bq1rk1/p1pp1ppp/2p2n2/8/1b2P3/2NB4/PPP2PPP/R1BQ1RK1 b"
    end
  end
end
