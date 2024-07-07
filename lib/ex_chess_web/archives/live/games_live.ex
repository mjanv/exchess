defmodule ExChessWeb.Archives.Live.GamesLive do
  @moduledoc false

  use ExChessWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
