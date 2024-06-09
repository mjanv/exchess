defmodule ExChess.Games do
  @moduledoc """
  The Games context.
  """

  alias ExChess.Games.{GameRecord, GameServer, GameSupervisor}

  defdelegate list_game, to: GameRecord
  defdelegate get_game!(id), to: GameRecord
  defdelegate create_game(attrs \\ %{}), to: GameRecord
  defdelegate update_game(game, attrs), to: GameRecord
  defdelegate change_game(game, attrs \\ %{}), to: GameRecord
  defdelegate delete_game(game), to: GameRecord

  def start(game) do
    with :ok <- GameSupervisor.start(game),
         :ok <- GameServer.cast(game, :start) do
      :ok
    else
      _ -> :error
    end
  end
end
