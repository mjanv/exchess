defmodule ExChess.Chess.Board do
  @moduledoc false

  alias ExChess.Chess.{Move, Piece, Position}

  @type t() :: %__MODULE__{
          turn: :white | :black,
          pieces: %{atom() => Piece.t()}
        }

  defstruct [:turn, :pieces]

  def new, do: %__MODULE__{turn: :white, pieces: %{}}

  def at(%__MODULE__{pieces: pieces}, x) when is_atom(x), do: Map.get(pieces, x)
  def at(%__MODULE__{pieces: pieces}, %Position{} = x), do: Map.get(pieces, Position.as_atom(x))

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
      |> Map.put(Position.as_atom(to), piece)
      |> then(fn pieces -> Map.put(board, :pieces, pieces) end)
      |> turn()
    else
      board
    end
  end

  def move(%__MODULE__{} = board, _), do: board

  def turn(%__MODULE__{turn: :white} = board), do: %{board | turn: :black}
  def turn(%__MODULE__{turn: :black} = board), do: %{board | turn: :white}
end
