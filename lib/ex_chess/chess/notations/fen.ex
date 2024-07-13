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

  def notation(%Board{turn: turn, pieces: pieces}) do
    board =
      for rank <- Enum.reverse(1..8) do
        for column <- 1..8 do
          pieces
          |> Map.get(Position.as_atom(%Position{column: column, rank: rank}))
          |> code()
        end
        |> collapse()
        |> Enum.join("")
      end
      |> Enum.join("/")

    turn = if turn == :white, do: "w", else: "b"

    "#{board} #{turn}"
  end

  def collapse(row), do: collapse(row, [], 0)
  def collapse([], acc, 0), do: acc
  def collapse([], acc, n) when n >= 1, do: acc ++ [Integer.to_string(n)]
  def collapse([nil | tail], acc, n), do: collapse(tail, acc, n + 1)

  def collapse([head | tail], acc, n) when n >= 1,
    do: collapse(tail, acc ++ [Integer.to_string(n), head], 0)

  def collapse([head | tail], acc, 0), do: collapse(tail, acc ++ [head], 0)

  def code(nil), do: nil
  def code(%Piece{color: :white, role: :pawn}), do: "P"
  def code(%Piece{color: :black, role: :pawn}), do: "p"
  def code(%Piece{color: :white, role: :knight}), do: "N"
  def code(%Piece{color: :black, role: :knight}), do: "n"
  def code(%Piece{color: :white, role: :bishop}), do: "B"
  def code(%Piece{color: :black, role: :bishop}), do: "b"
  def code(%Piece{color: :white, role: :rook}), do: "R"
  def code(%Piece{color: :black, role: :rook}), do: "r"
  def code(%Piece{color: :white, role: :queen}), do: "Q"
  def code(%Piece{color: :black, role: :queen}), do: "q"
  def code(%Piece{color: :white, role: :king}), do: "K"
  def code(%Piece{color: :black, role: :king}), do: "k"
end
