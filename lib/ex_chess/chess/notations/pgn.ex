defmodule ExChess.Chess.Notations.Pgn do
  @moduledoc """
  Portable Game Notation

  https://en.wikipedia.org/wiki/Portable_Game_Notation
  """

  def history(pgn) do
    [tags, moves] = String.split(pgn, "\n\n", parts: 2)

    a =
      tags
      |> String.split("\n")
      |> Enum.map(&parse_tag/1)
      |> Enum.reject(&is_nil/1)
      |> Enum.into(%{})

    b =
      moves
      |> parse_moves()

    {a, b}
  end

  defp parse_tag(line) do
    case Regex.run(~r/\[(\w+)\s+"(.+)"\]$/, line) do
      [_, key, value] -> {key, value}
      _ -> nil
    end
  end

  defp parse_moves(moves) do
    moves
    |> String.replace("\n", " ")
    |> String.split(~r/\s+(?=\d+.)/)
    |> Enum.map(&parse_move/1)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_move(line) do
    Regex.scan(~r/(\d+).\s+?([0-9a-zA-Z\/\-\+]+)\s+([0-9a-zA-Z\/\-\+]+)/, line)
    |> case do
      [[_, _, w, b]] -> {parse_piece(w), parse_piece(b)}
      _ -> nil
    end
  end

  def parse_piece(x), do: x
end
