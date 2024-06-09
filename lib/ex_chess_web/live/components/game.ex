defmodule GameComponent do
  @moduledoc false

  use ExChessWeb, :live_component

  alias ExChess.GameServer

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    if connected?(socket) do
      GameServer.subscribe(assigns.game)
    end

    socket
    |> assign(:game, assigns.game)
    |> then(fn socket -> {:ok, socket} end)
  end

  def render(assigns) do
    ~H"""
    <div>
    <.link href={~p"/board/#{@game.id}"}>Link</.link>
    <%= inspect(@game) %>
    </div>
    """
  end
end
