defmodule ExChess.Chess do
  @moduledoc false

  defdelegate start_board, to: ExChess.Chess.Notations.Fen
end
