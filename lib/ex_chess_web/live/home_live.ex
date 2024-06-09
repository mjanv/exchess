defmodule ExChessWeb.Live.HomeLive do
  @moduledoc false

  use ExChessWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns.current_user)
    socket = assign(socket, :games, ExChess.GameSupervisor.children())
    {:ok, socket}
  end

  def handle_event("create_game", %{"value" => ""}, socket) do
    uuid = UUID.uuid4()
    {:noreply, push_navigate(socket, to: "/board/#{uuid}")}
  end
end
