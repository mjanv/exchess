defmodule ExChessWeb.Live.Games.Components.NewGame do
  @moduledoc false

  use ExChessWeb, :live_component

  alias ExChess.Chess.Game
  alias ExChess.Games

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Start a new game
        <:subtitle></:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="game-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:result]}
          type="select"
          label="Result"
          prompt="Choose a value"
          options={Ecto.Enum.values(ExChess.Games.GameRecord, :result)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Game</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{game: game} = assigns, socket) do
    socket
    |> assign(assigns)
    |> assign(:form, to_form(Games.change_game(game)))
    |> then(fn socket -> {:ok, socket} end)
  end

  @impl true
  def handle_event("validate", %{"game_record" => game_params}, socket) do
    changeset =
      socket.assigns.game
      |> Games.change_game(game_params)
      |> Map.put(:action, :validate)

    socket
    |> assign(:form, to_form(changeset))
    |> then(fn socket -> {:noreply, socket} end)
  end

  def handle_event("save", %{"game_record" => params}, socket) do
    params
    |> Games.create_game()
    |> case do
      {:ok, game} ->
        game = %Game{id: Integer.to_string(game.id)}
        :ok = Games.start(game)

        socket
        |> put_flash(:info, "Game created successfully")
        |> push_navigate(to: "/game/#{game.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, :form, to_form(changeset))
    end
    |> then(fn socket -> {:noreply, socket} end)
  end
end
