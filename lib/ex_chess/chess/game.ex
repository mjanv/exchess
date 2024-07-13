defmodule ExChess.Chess.Game do
  @moduledoc false

  alias ExChess.Chess.{Board, Clock, Player}

  @type t() :: %__MODULE__{
          id: String.t(),
          status: nil | {:win, :white | :black} | :draw,
          players: %{:white => Player.t(), :black => Player.t()},
          board: Board.t(),
          clock: Clock.t()
        }

  defstruct [:id, :status, :players, :board, :clock]

  def new(id \\ nil, players \\ [], time \\ 120_000) do
    %__MODULE__{
      id: id || UUID.uuid4(),
      players: players |> Enum.map(fn p -> {p.color, p} end) |> Enum.into(%{}),
      clock: Clock.new(1_000, time),
      board: ExChess.Chess.start_board()
    }
  end

  def resign(%__MODULE__{} = game, color) do
    %{game | status: {:win, color}}
  end
end
