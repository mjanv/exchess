defmodule ExChess.Chess.Board do
  @moduledoc false

  alias ExChess.Chess.{Move, Piece, Position}

  @type t() :: %__MODULE__{
          turn: :white | :black,
          pieces: %{atom() => Piece.t()}
        }

  defstruct [:turn, :pieces]

  def new do
    %__MODULE__{turn: :white, pieces: %{}}
  end

  def at(%__MODULE__{pieces: pieces}, x) when is_atom(x), do: Map.get(pieces, x)
  def at(%__MODULE__{pieces: pieces}, %Position{} = x), do: Map.get(pieces, Position.as_atom(x))

  def all_positions(%__MODULE__{pieces: pieces}, {role, color}) do
    pieces
    |> Enum.filter(fn {_, piece} -> piece.role == role and piece.color == color end)
    |> Enum.map(fn {position, _} -> Position.from_atom(position) end)
  end

  def place(%__MODULE__{pieces: pieces} = board, %Position{} = position, %Piece{} = piece) do
    %{board | pieces: Map.put(pieces, Position.as_atom(position), piece)}
  end

  def move(
        %__MODULE__{turn: turn, pieces: pieces} = board,
        %Move{piece: %Piece{color: turn} = piece, from: from, to: to}
      ) do
    if Map.get(pieces, Position.as_atom(from)) == piece do
      pieces
      |> Map.pop!(Position.as_atom(from))
      |> elem(1)
      |> then(fn pieces ->
        case Map.get(pieces, Position.as_atom(to)) do
          %Piece{color: color} when color == piece.color ->
            pieces = Map.put(pieces, Position.as_atom(from), piece)
            Map.put(board, :pieces, pieces)

          _ ->
            pieces = Map.put(pieces, Position.as_atom(to), piece)

            Map.put(board, :pieces, pieces)
            |> turn()
        end
      end)
    else
      board
    end
  end

  def move(%__MODULE__{} = board, _), do: board

  def turn(%__MODULE__{turn: :white} = board), do: %{board | turn: :black}
  def turn(%__MODULE__{turn: :black} = board), do: %{board | turn: :white}
end

defimpl Inspect, for: ExChess.Chess.Board do
  alias ExChess.Chess.Position

  def inspect(board, _opts) do
    for rank <- 1..8 do
      for column <- 1..8 do
        board.pieces
        |> Map.get(Position.as_atom(%Position{column: column, rank: rank}))
        |> case do
          nil -> "_"
          x -> p(x.role)
        end
      end
      |> Enum.join("|")
    end
    |> Enum.join("\n")
  end

  def p(:king), do: "♚"
  def p(:queen), do: "♛"
  def p(:rook), do: "♜"
  def p(:bishop), do: "♝"
  def p(:knight), do: "♞"
  def p(:pawn), do: "♟︎"
end
