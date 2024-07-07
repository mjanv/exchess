defmodule ExChess.Chess.ClockTest do
  use ExUnit.Case

  alias ExChess.Chess.Clock

  test "a clock removes remaining time from players when ticks happens" do
    clock =
      Clock.new(500, 10_000)
      |> Clock.start()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.switch()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()

    %Clock{status: :started, turn: :black, remaining: remaining} = clock

    assert remaining == %{black: 8500, white: 9000}
  end

  test "a clock is stopped when the white player has no remaining time" do
    clock =
      Clock.new(1_000, 5_000)
      |> Clock.start()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()

    %Clock{status: :stopped, turn: :white, remaining: remaining} = clock

    assert remaining == %{black: 5_000, white: 0}
  end

  test "a clock is stopped when the black player has no remaining time" do
    clock =
      Clock.new(1_000, 5_000)
      |> Clock.start()
      |> Clock.switch()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()

    %Clock{status: :stopped, turn: :black, remaining: remaining} = clock

    assert remaining == %{black: 0, white: 5_000}
  end
end
