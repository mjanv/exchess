defmodule ExChessWeb.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      ExChessWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:ex_chess, :dns_cluster_query, :ignore)},
      {Phoenix.PubSub, name: ExChess.PubSub},
      ExChessWeb.Presence,
      ExChessWeb.Endpoint
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
