import Config

config :ex_chess,
  ecto_repos: [ExChess.Repo],
  generators: [timestamp_type: :utc_datetime]

config :ex_chess, ExChessWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: ExChessWeb.ErrorHTML, json: ExChessWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ExChess.PubSub,
  live_view: [signing_salt: "blu0dk60"]

config :esbuild,
  version: "0.17.11",
  ex_chess: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.0",
  ex_chess: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :ex_chess, ExChess.Mailer, adapter: Swoosh.Adapters.Local

config :libcluster,
  topologies: []

import_config "#{config_env()}.exs"
