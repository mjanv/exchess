defmodule ExChess.Archives.Uploader do
  @moduledoc false

  @supervisor ExChess.Archives.TaskSupervisor
  # @node :"foo@computer-name"

  def upload_pgns(pgns) do
    {@supervisor, node()}
    |> Task.Supervisor.async_stream(
      pgns,
      fn _pgn ->
        :ok
      end,
      max_concurrency: 2
    )
    |> Enum.to_list()
  end
end
