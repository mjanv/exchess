defmodule ExChess.GamesTest do
  use ExChess.DataCase

  alias ExChess.Games

  describe "game" do
    alias ExChess.Games.GameRecord, as: Game

    import ExChess.GamesFixtures

    @invalid_attrs %{result: nil, black: nil, white: nil}

    test "list_game/0 returns all game" do
      game = game_fixture()
      assert Games.list_game() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{result: :draw}

      assert {:ok, %Game{} = game} = Games.create_game(valid_attrs)
      assert game.result == :draw
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{result: :draw}

      assert {:ok, %Game{} = game} = Games.update_game(game, update_attrs)
      assert game.result == :draw
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end
end
