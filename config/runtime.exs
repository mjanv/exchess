import Config

if config_env() == :prod do
  config :ex_chess, ExChessWeb.Endpoint, server: true

  config :ex_chess, ExChess.Repo,
    # ssl: true,
    url:
      System.get_env("DATABASE_URL") ||
        raise("""
        environment variable DATABASE_URL is missing.
        For example: ecto://USER:PASS@HOST/DATABASE
        """),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: if(System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: [])

  config :ex_chess, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :ex_chess, ExChessWeb.Endpoint,
    url: [host: System.get_env("PHX_HOST") || "example.com", port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base:
      System.get_env("SECRET_KEY_BASE") ||
        raise("""
        environment variable SECRET_KEY_BASE is missing.
        You can generate one by calling: mix phx.gen.secret
        """)

  config :libcluster,
    local: [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
      ]
    ]
end
