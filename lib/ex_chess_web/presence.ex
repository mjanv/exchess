defmodule ExChessWeb.Presence do
  @moduledoc false

  use Phoenix.Presence,
    otp_app: :my_app,
    pubsub_server: ExChess.PubSub

  def user(_socket, %{id: id}) do
    {:ok, _} =
      __MODULE__.track(self(), "users", Integer.to_string(id), %{
        online_at: System.system_time(:second)
      })
  end

  def game(%{id: id}, %{id: user_id}) do
    __MODULE__.track(self(), "game:#{id}", user_id, %{})
  end
end
