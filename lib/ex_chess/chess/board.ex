defmodule ExChess.Chess.Board do
  @moduledoc false

  alias ExChess.Chess.{History, Move, Piece, Position}

  @type color() :: :white | :black
  @type status() :: :active | :check | :checkmate | :draw | :pat

  @type t() :: %__MODULE__{
          turn: color(),
          status: status(),
          pieces: %{atom() => Piece.t()},
          captures: [Piece.t()],
          history: History.t()
        }

  defstruct [:turn, :status, :pieces, :captures, :history]

  def new(pieces \\ %{}, turn \\ :white) do
    %__MODULE__{
      turn: turn,
      status: :active,
      pieces: pieces,
      captures: [],
      history: %History{moves: []}
    }
  end

  def at(%__MODULE__{pieces: pieces}, p) when is_atom(p), do: Map.get(pieces, p)
  def at(%__MODULE__{} = board, %Position{} = p), do: at(board, Position.as_atom(p))

  def all_positions(%__MODULE__{pieces: pieces}, {role, color}) do
    pieces
    |> Enum.filter(fn {_, piece} -> piece.role == role and piece.color == color end)
    |> Enum.map(fn {position, _} -> Position.from_atom(position) end)
  end

  def capture_values(%__MODULE__{captures: captures}) do
    captures
    |> Enum.group_by(& &1.color, &Piece.value/1)
    |> Enum.map(fn {k, v} -> {k, Enum.sum(v)} end)
    |> Enum.into(%{})
  end

  def place(%__MODULE__{pieces: pieces} = board, %Position{} = position, %Piece{} = piece) do
    %{board | pieces: Map.put(pieces, Position.as_atom(position), piece)}
  end

  def move(
        %__MODULE__{turn: turn, pieces: pieces, captures: captures, history: history} = board,
        %Move{piece: %Piece{color: turn} = piece, from: from, to: to} = move
      ) do
    if Map.get(pieces, Position.as_atom(from)) == piece do
      pieces
      |> Map.pop!(Position.as_atom(from))
      |> then(fn {_, pieces} ->
        case Map.get(pieces, Position.as_atom(to)) do
          %Piece{color: color} when color == piece.color ->
            pieces = Map.put(pieces, Position.as_atom(from), piece)
            Map.put(board, :pieces, pieces)

          _ ->
            {old, pieces} = Map.pop(pieces, Position.as_atom(to))
            pieces = Map.put(pieces, Position.as_atom(to), piece)

            Map.put(board, :pieces, pieces)
            |> Map.put(:history, History.append(history, move))
            |> Map.put(:captures, (captures ++ [old]) |> Enum.reject(&is_nil/1))
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
