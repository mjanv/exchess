defmodule ExChess.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :player_white, :id
      add :player_black, :id
      add :against_ia, :boolean
      add :time_control, :string
      add :result, :string

      timestamps(type: :utc_datetime)
    end
  end
end
