import Config

config :ex_chess, ExChess.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ex_chess_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :ex_chess, ExChessWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "KyX0Rf6YnLl28lmejPU/wLrpZbbDxR+cGT1PX3kFNg27HGviHGg8Xfp39Chtdfh4",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:ex_chess, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:ex_chess, ~w(--watch)]}
  ]

config :ex_chess, ExChessWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/ex_chess_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :ex_chess, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true
