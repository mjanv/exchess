defmodule ExChessWeb.Live.Archives.GamesLive do
  @moduledoc false

  use ExChessWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
