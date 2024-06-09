defmodule ExChess.Chess.Notations.Pgn do
  @moduledoc """
  Portable Game Notation

  https://en.wikipedia.org/wiki/Portable_Game_Notation
  """

  def history(pgn) do
    IO.inspect(pgn)
    [tags, moves] = String.split(pgn, "\n\n", parts: 2)

    tags
    |> String.split("\n")
    |> Enum.map(&parse_tag/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{})

    moves |> parse_moves()
  end

  defp parse_tag(line) do
    Regex.run(~r/^[(\w+)\s+\"(\w+)\"]$/, line)
  end

  defp parse_moves(moves_section) do
    moves_section
    |> String.replace("\n", " ")
    |> String.split(~r/\s+(?=\d+.)/)
    |> Enum.flat_map(&parse_move_line/1)

    # |> Enum.split_with(&(&1 != "1-0" and &1 != "0-1" and &1 != "1/2-1/2"))
  end

  defp parse_move_line(line) do
    Regex.scan(~r/(\d+).\s+?([^ ]+)\s+([^ ]+)?/, line)
    # |> case do
    #   [_, n, w, b] -> {n, w, b}
    #   _ -> nil
    # end
    # |> Enum.reject(&(&1 == ""))
    # |> Enum.map(&String.trim/1)
    # |> Enum.reject(&String.match?(&1, ~r/^\d+.$/))
  end
end
