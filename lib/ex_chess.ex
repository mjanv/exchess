defmodule ExChess do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExChess.Supervisor,
      ExChessWeb.Supervisor,
      {Cluster.Supervisor,
       [Application.get_env(:libcluster, :topologies), [name: ExChess.ClusterSupervisor]]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ExChess.Application)
  end

  @impl true
  def config_change(changed, _new, removed) do
    ExChessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
