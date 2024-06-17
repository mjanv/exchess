defmodule ExChess.GamesFixtures do
  @moduledoc false

  @game %{
    player_white: 1,
    player_black: 2,
    time_control: :"3+0",
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
