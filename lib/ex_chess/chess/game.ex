defmodule ExChess.Chess.Game do
  @moduledoc false

  alias ExChess.{Board, Clock, Move}

  @type t() :: %__MODULE__{
          id: String.t(),
          board: Board.t(),
          clock: Clock.t(),
          history: [Move.t()]
        }

  defstruct [:id, :board, :clock, :history]
end
