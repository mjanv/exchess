defmodule ExChess.Chess.HistoryTest do
  use ExUnit.Case

  alias ExChess.Chess.History

  test "?" do
    history = %History{}

    assert history.moves == nil
  end
end
