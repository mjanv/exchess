defmodule ExChess.Repo do
  @moduledoc false

  @app :ex_chess

  use Ecto.Repo,
    otp_app: @app,
    adapter: Ecto.Adapters.Postgres

  def migrate do
    Application.load(@app)

    for repo <- Application.fetch_env!(@app, :ecto_repos) do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    Application.load(@app)

    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end
end
