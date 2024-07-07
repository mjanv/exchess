defmodule ExChess.Chess.Piece do
  @moduledoc false

  @type color() :: :white | :black
  @type role() :: :king | :queen | :rook | :bishop | :knight | :pawn

  @type t() :: %__MODULE__{color: color(), role: role()}

  defstruct [:color, :role]
end
