defmodule ExChess.Chess.Position do
  @moduledoc false

  @type t() :: %__MODULE__{
          column: integer(),
          rank: integer()
        }

  defstruct [:column, :rank]

  def from_atom(a) when is_atom(a) do
    a
    |> Atom.to_string()
    |> String.to_charlist()
    |> then(fn [c, r] -> %__MODULE__{column: c - ?a + 1, rank: r - ?1 + 1} end)
  end

  def valid?(%__MODULE__{column: c, rank: r}) do
    1 <= r and r <= 8 and (1 <= c and c <= 8)
  end

  def as_atom(%__MODULE__{column: column, rank: rank}) do
    :"#{List.to_string([column + 96])}#{rank}"
  end

  def vec(%__MODULE__{} = position, {column, rank}) do
    %{position | column: position.column + column, rank: position.rank + rank}
  end
end
