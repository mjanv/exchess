defmodule ExChessWeb.Presence do
  @moduledoc false

  use Phoenix.Presence,
    otp_app: :ex_chess,
    pubsub_server: ExChess.PubSub

  def user(_socket, %{id: id}) do
    {:ok, _} =
      __MODULE__.track(self(), "users", Integer.to_string(id), metadata())
  end

  def game(%{id: id}, %{id: user_id}) do
    __MODULE__.track(self(), "game:#{id}", user_id, metadata())
  end

  defp metadata do
    %{
      online_at: System.system_time(:second)
    }
  end

  def list_game(%{id: id}) do
    "game:#{id}"
    |> __MODULE__.list()
    |> Enum.map(fn {k, %{metas: [m | _]}} -> {k, Map.drop(m, [:phx_ref])} end)
    |> Enum.into(%{})
  end
end
