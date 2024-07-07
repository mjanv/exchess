defmodule ExChessWeb.Games.Live.HomeLive do
  @moduledoc false

  use ExChessWeb, :live_view

  alias ExChess.{Analytics, Games}
  alias ExChessWeb.Presence

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Games.GameServer.subscribe()
      Analytics.Online.subscribe()

      Presence.user(socket, socket.assigns.current_user)
    end

    socket
    |> assign(:games, Games.GameSupervisor.children())
    |> assign(:past_games, Games.list_game())
    |> assign(:analytics, Analytics.online_stats())
    |> then(fn socket -> {:ok, socket} end)
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket
    |> then(fn
      %{assigns: %{live_action: :index}} = socket ->
        assign(socket, :game, nil)

      %{assigns: %{live_action: :new}} = socket ->
        assign(socket, :game, %ExChess.Games.GameRecord{})
    end)
    |> then(fn socket -> {:noreply, socket} end)
  end

  @impl true
  def handle_info({:stats, stats}, socket) do
    socket
    |> assign(:analytics, stats)
    |> then(fn socket -> {:noreply, socket} end)
  end

  @impl true
  def handle_info({:game_started, _game}, socket) do
    socket
    |> assign(:games, Games.GameSupervisor.children())
    |> then(fn socket -> {:noreply, socket} end)
  end

  @impl true
  def handle_info({:game_stopped, _game}, socket) do
    socket
    |> then(fn socket -> {:noreply, socket} end)
  end
end
