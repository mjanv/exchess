defmodule ExChess.Chess.History do
  @moduledoc false

  alias ExChess.Chess.Move

  @type t() :: %__MODULE__{
          moves: [Move.t()]
        }

  defstruct [:moves]

  def append(%__MODULE__{moves: moves} = history, %Move{} = move) do
    %{history | moves: moves ++ [move]}
  end
end
