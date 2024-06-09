defmodule ExChessWeb.Presence do
  @moduledoc false

  alias ExChess.Chess.Game

  use Phoenix.Presence,
    otp_app: :my_app,
    pubsub_server: ExChess.PubSub

  def join(%Game{id: id}, key) do
    __MODULE__.track(self(), "game:#{id}", key, %{})
  end
end
