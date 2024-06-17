defmodule ExChess.Models.EvaluationModelTest do
  use ExUnit.Case

  alias ExChess.Chess.Notations.Fen
  alias ExChess.Models.EvaluationModel

  test "Board evaluation" do
    assert EvaluationModel.eval(Fen.start_board()) == -0.05384990572929382
  end
end
