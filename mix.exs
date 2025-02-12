defmodule ExChess.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_chess,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ExChess.Application, []},
      extra_applications: [:logger, :os_mon, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # Web
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix, "~> 1.7.12"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.2"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:plug_cowboy, "~> 2.7"},

      # Backend
      {:ecto_sql, "~> 3.10"},
      {:postgrex, "~> 0.18"},
      {:uuid, "~> 1.1"},
      {:swoosh, "~> 1.16"},
      {:hackney, "~> 1.20"},
      {:libcluster, "~> 3.3"},
      {:horde, "~> 0.9"},
      {:flame, "~> 0.1.12"},
      {:req, "~> 0.4", override: true},
      {:axon, "~> 0.6.1"},
      {:exla, "~> 0.7.2"},

      # Observability
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},

      # Development tools
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      setup: [
        "deps.get",
        "ecto.setup",
        "cmd --cd assets npm install",
        "assets.setup",
        "assets.build"
      ],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      quality: ["format", "credo --strict", "dialyzer"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind ex_chess", "esbuild ex_chess"],
      "assets.deploy": [
        "tailwind ex_chess --minify",
        "esbuild ex_chess --minify",
        "phx.digest"
      ],
      "deploy.start": ["cmd fly scale count 3 --yes --region cdg,iad,syd --max-per-region 1"],
      "deploy.stop": ["cmd fly scale count 0 --yes --region cdg,iad,syd --max-per-region 1"]
    ]
  end
end
