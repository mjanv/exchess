defmodule ExChess.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :result, :string

      timestamps(type: :utc_datetime)
    end
  end
end
