defmodule ExChess.Chess.Move do
  @moduledoc false

  alias ExChess.Chess.{Board, Piece, Position}

  @type t() :: %__MODULE__{
          piece: Piece.t(),
          from: Position.t(),
          to: Position.t()
        }

  defstruct [:piece, :from, :to]

  def new(piece, from, to) when is_atom(from) and is_atom(to) do
    %__MODULE__{piece: piece, from: Position.from_atom(from), to: Position.from_atom(to)}
  end

  def new(piece, %Position{} = from, %Position{} = to) do
    %__MODULE__{piece: piece, from: from, to: to}
  end

  def possible_moves(%Board{} = board, %Position{} = position) do
    piece = Board.at(board, position)

    board
    |> do_possible_moves(position, piece)
    |> Enum.map(fn destination -> __MODULE__.new(piece, position, destination) end)
  end

  def do_possible_moves(_, _, nil), do: []

  def do_possible_moves(%Board{}, %Position{rank: rank} = s, %Piece{color: :white, role: :pawn}) do
    1..if(rank == 2, do: 2, else: 1) |> Enum.map(&{0, &1}) |> check_route(s)
  end

  def do_possible_moves(%Board{}, %Position{rank: rank} = s, %Piece{color: :black, role: :pawn}) do
    1..if(rank == 7, do: 2, else: 1) |> Enum.map(&{0, -&1}) |> check_route(s)
  end

  def do_possible_moves(%Board{}, %Position{} = s, %Piece{role: :rook}) do
    a = 1..8 |> Enum.map(&{0, -&1}) |> check_route(s) |> Enum.reverse()
    b = 1..8 |> Enum.map(&{0, +&1}) |> check_route(s)
    c = 1..8 |> Enum.map(&{-&1, 0}) |> check_route(s) |> Enum.reverse()
    d = 1..8 |> Enum.map(&{+&1, 0}) |> check_route(s)

    a ++ b ++ c ++ d
  end

  def do_possible_moves(%Board{}, %Position{} = s, %Piece{role: :bishop}) do
    a = 1..8 |> Enum.map(&{-&1, -&1}) |> check_route(s) |> Enum.reverse()
    b = 1..8 |> Enum.map(&{+&1, +&1}) |> check_route(s)
    c = 1..8 |> Enum.map(&{-&1, +&1}) |> check_route(s) |> Enum.reverse()
    d = 1..8 |> Enum.map(&{+&1, -&1}) |> check_route(s)

    a ++ b ++ c ++ d
  end

  def do_possible_moves(%Board{} = b, %Position{} = s, %Piece{role: :queen} = p) do
    do_possible_moves(b, s, %{p | role: :rook}) ++ do_possible_moves(b, s, %{p | role: :bishop})
  end

  def do_possible_moves(%Board{}, %Position{} = s, %Piece{role: :knight}) do
    [{1, 2}, {2, 1}, {2, -1}, {1, -2}, {-1, -2}, {-2, -1}, {-2, 1}, {-1, 2}]
    |> check_jumps(s)
  end

  def do_possible_moves(%Board{}, %Position{} = s, %Piece{role: :king}) do
    [{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}]
    |> check_jumps(s)
  end

  defp check_jumps(vectors, start) do
    vectors
    |> Enum.map(&Position.vec(start, &1))
    |> Enum.filter(&Position.valid?/1)
  end

  defp check_route(vectors, start) do
    vectors
    |> Enum.map(&Position.vec(start, &1))
    |> Enum.reduce_while([], fn p, moves ->
      if Position.valid?(p) do
        {:cont, moves ++ [p]}
      else
        {:halt, moves}
      end
    end)
  end
end
