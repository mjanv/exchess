import Config

config :ex_chess, ExChess.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ex_chess_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :ex_chess, ExChessWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "XOk3R1yM/9xp0fqdigdRK4omV7h0NGb5FjxYlEpICrC6WFgBnsNLNs6iie+wGHBb",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  enable_expensive_runtime_checks: true
