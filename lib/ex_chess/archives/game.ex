defmodule ExChess.Archives.Game do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias ExChess.Repo

  schema "games" do
    field(:result, Ecto.Enum, values: [:unknown, :white, :draw, :black])

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:result])
    |> validate_required([:result])
  end

  def list_game, do: Repo.all(__MODULE__)
  def get_game!(id), do: Repo.get!(__MODULE__, id)

  def create_game(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update_game(%__MODULE__{} = game, attrs) do
    game
    |> changeset(attrs)
    |> Repo.update()
  end

  def change_game(%__MODULE__{} = game, attrs \\ %{}) do
    changeset(game, attrs)
  end

  def delete_game(%__MODULE__{} = game), do: Repo.delete(game)
end
