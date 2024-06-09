defmodule ExChess.Chess.Notations.Fen do
  @moduledoc """
  Forsyth–Edwards Notation importer

  https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation
  """

  alias ExChess.Chess.{Board, Piece, Position}

  def start_board, do: board("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")

  def board(fen) when is_binary(fen) do
    board(Board.new(), {1, 8}, fen)
  end

  defp board(board, {column, rank}, <<empty, rest::binary>>) when empty in ?1..?8 do
    board(board, {column + (empty - ?1 + 1), rank}, rest)
  end

  defp board(board, {_, rank}, <<"/", rest::binary>>) do
    board(board, {1, rank - 1}, rest)
  end

  defp board(board, {_, _}, <<" w", _::binary>>) do
    %{board | turn: :white}
  end

  defp board(board, {_, _}, <<" b", _::binary>>) do
    %{board | turn: :black}
  end

  defp board(board, {column, rank}, <<piece::utf8, rest::binary>>) do
    board
    |> Board.place(%Position{column: column, rank: rank}, piece(piece))
    |> board({column + 1, rank}, rest)
  end

  def piece(?P), do: %Piece{color: :white, role: :pawn}
  def piece(?p), do: %Piece{color: :black, role: :pawn}
  def piece(?N), do: %Piece{color: :white, role: :knight}
  def piece(?n), do: %Piece{color: :black, role: :knight}
  def piece(?B), do: %Piece{color: :white, role: :bishop}
  def piece(?b), do: %Piece{color: :black, role: :bishop}
  def piece(?R), do: %Piece{color: :white, role: :rook}
  def piece(?r), do: %Piece{color: :black, role: :rook}
  def piece(?Q), do: %Piece{color: :white, role: :queen}
  def piece(?q), do: %Piece{color: :black, role: :queen}
  def piece(?K), do: %Piece{color: :white, role: :king}
  def piece(?k), do: %Piece{color: :black, role: :king}
end
