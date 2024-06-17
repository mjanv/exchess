defmodule ExChess.Chess.Game do
  @moduledoc false

  alias ExChess.Chess.{Board, Clock, Move, Notations, Player}

  @type t() :: %__MODULE__{
          id: String.t(),
          players: %{:white => Player.t(), :black => Player.t()},
          board: Board.t(),
          clock: Clock.t(),
          history: [Move.t()]
        }

  defstruct [:id, :players, :board, :clock, :history]

  def new(id \\ nil, players \\ [], time \\ 120_000) do
    %__MODULE__{
      id: id || UUID.uuid4(),
      players: players |> Enum.map(fn p -> {p.color, p} end) |> Enum.into(%{}),
      clock: Clock.new(1_000, time),
      board: Notations.Fen.start_board(),
      history: []
    }
  end
end
