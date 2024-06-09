defmodule ExChess.GamesFixtures do
  @moduledoc false

  @game %{
    result: :draw
  }

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(@game)
    |> ExChess.Games.create_game()
    |> then(fn {:ok, game} -> game end)
  end
end
