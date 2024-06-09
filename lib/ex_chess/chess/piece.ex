defmodule ExChess.Chess.Piece do
  @moduledoc false

  @type t() :: %__MODULE__{
          color: :white | :black,
          role: :king | :queen | :rook | :bishop | :knight | :pawn
        }

  defstruct [:color, :role]
end
