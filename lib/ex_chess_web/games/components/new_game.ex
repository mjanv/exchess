defmodule ExChessWeb.Live.Games.Components.NewGame do
  @moduledoc false

  use ExChessWeb, :live_component

  alias ExChess.Chess.{Game, Player}
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
          field={@form[:time_control]}
          type="select"
          label="Time Control"
          prompt="Choose a value"
          options={Ecto.Enum.values(ExChess.Games.GameRecord, :time_control)}
        />
        <.input
          field={@form[:against_ia]}
          type="checkbox"
          label="Against IA"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Start the game</.button>
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
    |> Map.merge(%{
      "player_white" => Integer.to_string(socket.assigns.user.id),
      "result" => "unknown"
    })
    |> Games.create_game()
    |> case do
      {:ok, game_record} ->
        time =
          case game_record.time_control do
            :"1+0" -> 60_000
            :"3+0" -> 180_000
            :"10+0" -> 600_000
          end

        game =
          Game.new(
            Integer.to_string(game_record.id),
            [
              %Player{color: :white, id: game_record.player_white},
              %Player{color: :black, id: -1}
            ],
            time
          )

        :ok = Games.start(game)

        socket
        |> put_flash(:info, "Game created successfully")
        |> push_navigate(to: "/games/#{game.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, :form, to_form(changeset))
    end
    |> then(fn socket -> {:noreply, socket} end)
  end
end
