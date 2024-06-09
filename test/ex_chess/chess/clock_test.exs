defmodule ExChess.Chess.ClockTest do
  use ExUnit.Case

  alias ExChess.Chess.Clock

  test "a clock ?" do
    clock =
      Clock.new(500, 10_000)
      |> Clock.start()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.switch()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()

    %Clock{status: :started, turn: :black, remaining: %{black: 8500, white: 9000}} =
      clock

    assert true
  end

  test "a clock ??" do
    clock =
      Clock.new(1_000, 5_000)
      |> Clock.start()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()
      |> Clock.tick()

    %Clock{status: :expired, turn: :white, remaining: %{black: 5_000, white: 0}} =
      clock

    assert true
  end

  test "a clock ???" do
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

    %Clock{status: :expired, turn: :black, remaining: %{black: 0, white: 5_000}} =
      clock

    assert true
  end
end
