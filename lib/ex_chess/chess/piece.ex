defmodule ExChess.Chess.Piece do
  @moduledoc false

  @type color() :: :white | :black
  @type role() :: :king | :queen | :rook | :bishop | :knight | :pawn

  @type t() :: %__MODULE__{color: color(), role: role()}

  defstruct [:color, :role]
  
  def value(%__MODULE__{role: :pawn}), do: 1
  def value(%__MODULE__{role: :knight}), do: 3
  def value(%__MODULE__{role: :bishop}), do: 3
  def value(%__MODULE__{role: :rook}), do: 5
  def value(%__MODULE__{role: :queen}), do: 9
  def value(%__MODULE__{role: :king}), do: :infinity
end
