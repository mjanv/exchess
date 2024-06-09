defmodule ExChess.Chess.Clock do
  @moduledoc false

  @type t() :: %__MODULE__{
          timer: any(),
          status: :created | :started | :stopped | :expired,
          turn: :white | :black,
          interval: integer(),
          remaining: %{white: integer(), black: integer()}
        }

  defstruct [:timer, :status, :interval, :turn, :remaining]

  def new(interval \\ 1_000, remaining \\ 180_000) do
    %__MODULE__{
      timer: nil,
      status: :created,
      interval: interval,
      turn: :white,
      remaining: %{white: remaining, black: remaining}
    }
  end

  def start(%__MODULE__{interval: interval, timer: nil} = clock) do
    {:ok, {:interval, ref}} = :timer.send_interval(interval, :tick)
    %{clock | status: :started, timer: ref}
  end

  def start(%__MODULE__{} = clock), do: clock

  def stop(%__MODULE__{timer: ref} = clock) do
    {:ok, _} = :timer.cancel(ref)
    %{clock | status: :stopped, timer: nil}
  end

  def wait(%__MODULE__{interval: interval} = clock) do
    receive do
      :tick -> tick(clock)
    after
      2 * interval -> clock
    end
  end

  def tick(
        %__MODULE__{status: :started, interval: interval, turn: turn, remaining: remaining} =
          clock
      ) do
    clock = %{clock | remaining: Map.update(remaining, turn, 0, fn x -> max(0, x - interval) end)}

    if min(clock.remaining.white, clock.remaining.black) == 0 do
      %{clock | status: :expired}
    else
      clock
    end
  end

  def tick(%__MODULE__{} = clock), do: clock

  def switch(%__MODULE__{turn: :white} = clock), do: %{clock | turn: :black}
  def switch(%__MODULE__{turn: :black} = clock), do: %{clock | turn: :white}
end
