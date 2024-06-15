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

  def do_possible_moves(%Board{} = b, %Position{rank: rank} = s, %Piece{
        color: :white,
        role: :pawn
      }) do
    1..if(rank == 2, do: 2, else: 1) |> Enum.map(&{0, &1}) |> check_route(b, s)
  end

  def do_possible_moves(%Board{} = b, %Position{rank: rank} = s, %Piece{
        color: :black,
        role: :pawn
      }) do
    1..if(rank == 7, do: 2, else: 1) |> Enum.map(&{0, -&1}) |> check_route(b, s)
  end

  def do_possible_moves(%Board{} = b, %Position{} = s, %Piece{role: :rook}) do
    so = 1..8 |> Enum.map(&{0, -&1}) |> check_route(b, s) |> Enum.reverse()
    no = 1..8 |> Enum.map(&{0, +&1}) |> check_route(b, s)
    we = 1..8 |> Enum.map(&{-&1, 0}) |> check_route(b, s) |> Enum.reverse()
    es = 1..8 |> Enum.map(&{+&1, 0}) |> check_route(b, s)

    so ++ no ++ we ++ es
  end

  def do_possible_moves(%Board{} = b, %Position{} = s, %Piece{role: :bishop}) do
    sw = 1..8 |> Enum.map(&{-&1, -&1}) |> check_route(b, s) |> Enum.reverse()
    ne = 1..8 |> Enum.map(&{+&1, +&1}) |> check_route(b, s)
    nw = 1..8 |> Enum.map(&{-&1, +&1}) |> check_route(b, s) |> Enum.reverse()
    se = 1..8 |> Enum.map(&{+&1, -&1}) |> check_route(b, s)

    sw ++ ne ++ nw ++ se
  end

  def do_possible_moves(%Board{} = b, %Position{} = s, %Piece{role: :queen} = p) do
    do_possible_moves(b, s, %{p | role: :rook}) ++ do_possible_moves(b, s, %{p | role: :bishop})
  end

  def do_possible_moves(%Board{} = b, %Position{} = s, %Piece{role: :knight}) do
    [{1, 2}, {2, 1}, {2, -1}, {1, -2}, {-1, -2}, {-2, -1}, {-2, 1}, {-1, 2}]
    |> check_jumps(b, s)
  end

  def do_possible_moves(%Board{} = b, %Position{} = s, %Piece{role: :king}) do
    [{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}]
    |> check_jumps(b, s)
  end

  defp check_jumps(vectors, %Board{} = b, %Position{} = s) do
    vectors
    |> Enum.map(&Position.vec(s, &1))
    |> Enum.filter(fn p -> Position.valid?(p) and is_nil(Board.at(b, p)) end)
  end

  defp check_route(vectors, %Board{} = b, %Position{} = s) do
    vectors
    |> Enum.map(&Position.vec(s, &1))
    |> Enum.reduce_while([], fn p, moves ->
      if Position.valid?(p) and is_nil(Board.at(b, p)) do
        {:cont, moves ++ [p]}
      else
        {:halt, moves}
      end
    end)
  end
end
