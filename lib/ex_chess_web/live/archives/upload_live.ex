defmodule ExChessWeb.Live.Archives.UploadLive do
  @moduledoc false

  use ExChessWeb, :live_view

  alias ExChess.Archives.Uploader

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(:status, [])
    |> allow_upload(:avatar, accept: ~w(.txt), max_entries: 1)
    |> then(fn socket -> {:ok, socket} end)
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    socket
    |> consume_uploaded_entries(:avatar, fn %{path: path}, _entry ->
      path
      |> File.read!()
      |> String.split("\n\n\n")
      |> Uploader.upload_pgns()
      |> then(fn results -> {:ok, results} end)
    end)
    |> then(fn status -> {:noreply, assign(socket, :status, status)} end)
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
end
