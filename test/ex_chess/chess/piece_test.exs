defmodule ExChess.Chess.PieceTest do
  use ExUnit.Case

  alias ExChess.Chess.Piece

  test "Pieces have values" do
    assert Piece.value(%Piece{color: :white, role: :pawn}) == 1
    assert Piece.value(%Piece{color: :white, role: :knight}) == 3
    assert Piece.value(%Piece{color: :white, role: :bishop}) == 3
    assert Piece.value(%Piece{color: :white, role: :rook}) == 5
    assert Piece.value(%Piece{color: :white, role: :queen}) == 9
    assert Piece.value(%Piece{color: :white, role: :king}) == :infinity
  end
end
