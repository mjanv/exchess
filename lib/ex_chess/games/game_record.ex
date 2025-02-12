defmodule ExChess.Games.GameRecord do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias ExChess.Chess.Game
  alias ExChess.Repo

  schema "games" do
    field(:player_white, :id)
    field(:player_black, :id)
    field(:against_ia, :boolean, default: false)
    field(:time_control, Ecto.Enum, values: [:"1+0", :"3+0", :"10+0"])
    field(:result, Ecto.Enum, values: [:unknown, :white, :draw, :black])

    timestamps(type: :utc_datetime)
  end

  def changeset(game, attrs) do
    game
    |> cast(attrs, [:player_white, :player_black, :against_ia, :time_control, :result])
    |> validate_required([:player_white, :against_ia, :time_control])
  end

  def list_game, do: Repo.all(__MODULE__)
  def get_game!(id), do: Repo.get!(__MODULE__, id)

  def create_game(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update_game(%__MODULE__{} = record, %Game{} = game) do
    record
    |> changeset(
      %{}
      |> parse_status(game)
    )
    |> Repo.update()
  end

  def update_game(%__MODULE__{} = game, attrs) do
    game
    |> changeset(attrs)
    |> Repo.update()
  end

  defp parse_status(attrs, %{status: nil, board: board}), do: Map.put(attrs, :result, board.turn)
  defp parse_status(attrs, %{status: {:win, color}}), do: Map.put(attrs, :result, color)
  defp parse_status(attrs, _), do: attrs

  def change_game(%__MODULE__{} = game, attrs \\ %{}), do: changeset(game, attrs)
  def delete_game(%__MODULE__{} = game), do: Repo.delete(game)
end
