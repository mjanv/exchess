defmodule ExChess.Chess.Player do
  @moduledoc false

  @type t() :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          color: :white | :black
        }

  defstruct [:id, :name, :color]
end
