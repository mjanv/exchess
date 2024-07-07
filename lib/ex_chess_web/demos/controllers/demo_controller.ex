defmodule ExChessWeb.Demos.DemoController do
  use ExChessWeb, :controller

  alias ExChess.Chess.Notations.Fen
  alias ExChess.Chess.{Piece, Position}

  def tiles(conn, _params) do
    render(conn, :tiles)
  end

  def pieces(conn, _params) do
    pieces = [
      {Position.from_atom(:a1), %Piece{role: :knight, color: :white}}
    ]

    render(conn, :pieces, pieces: pieces)
  end

  def chessboard(conn, _params) do
    render(conn, :chessboard, board: Fen.start_board())
  end
end
