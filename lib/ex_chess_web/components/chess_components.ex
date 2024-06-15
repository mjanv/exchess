defmodule ExChessWeb.Components.ChessComponents do
  @moduledoc false

  use Phoenix.Component

  alias ExChess.Chess.Position

  def board(assigns) do
    ~H"""
      <div class="relative max-w-xl aspect-square w-full rounded-lg overflow-hidden">
          <div class="absolute grid grid-cols-8 grid-rows-8 w-full h-full" style="font-family: Arial;">
              <.piece :for={{position, piece} <- Enum.map(@pieces, & &1)} 
                      position={Position.from_atom(position)} piece={piece} />
          </div>
          <div class="absolute grid grid-cols-8 grid-rows-8 w-full h-full" style="font-family: Arial;">
              <.highlight :for={move <- @moves} position={move.to} />
          </div>
          <div class="grid grid-cols-8 grid-rows-8 w-full h-full">
              <%= for y <- 1..8 do %>
                  <%= for x <- 1..8 do %>
                      <.tile x={x} y={9-y} selected={@selected} />
                  <% end %>
              <% end %>  
          </div>
      </div>
    """
  end

  def piece(assigns) do
    ~H"""
    <div
      style={"left: #{(((@position.column - 1) / 8)) * 100}%; top: #{(((8 - @position.rank) / 8)) * 100}%; width: 12.5%; height: 12.5%;"}
      class="absolute aspect-square flex overflow-clip transition-all pointer-events-none"
    >
      <div class="relative w-full h-full flex justify-center items-center">
        <p class={"text-5xl text-center z-10 text-" <> Atom.to_string(@piece.color)}>
            <%= p(@piece.role) %>
        </p>
      </div>
    </div>
    """
  end

  def p(:king), do: "♚"
  def p(:queen), do: "♛"
  def p(:rook), do: "♜"
  def p(:bishop), do: "♝"
  def p(:knight), do: "♞"
  def p(:pawn), do: "♟︎"

  def tile(assigns) do
    ~H"""
    <button style={"background-color: #{tile_color({@x, @y}, @selected)};"} 
            class="aspect-square flex overflow-clip" phx-click="select" 
            phx-value-x={@x} phx-value-y={@y}>
      <div class="relative w-full h-full flex justify-center items-center">
        <div class="absolute w-full h-full" style={"background-color: none;"}></div>
      </div>
    </button>
    """
  end

  def tile_color({x, y}, %Position{column: column, rank: rank}) when {x, y} == {column, rank},
    do: :yellow

  def tile_color({x, y}, _) when rem(x, 2) == rem(y, 2), do: :green
  def tile_color({x, y}, _) when rem(x, 2) != rem(y, 2), do: :brown

  def highlight(assigns) do
    ~H"""
    <button 
    style={"left: #{((@position.column - 1) / 8) * 100}%; top: #{(((8 - @position.rank) / 8)) * 100}%; width: 12.5%; height: 12.5%; background-color: purple;"} 
            class="absolute aspect-square flex overflow-clip transition-all pointer-events-none" 
            >
      <div class="relative w-full h-full flex justify-center items-center">
        <div class="absolute w-full h-full" style={"background-color: none;"}></div>
      </div>
    </button>
    """
  end
end
