defmodule ExChess.Models.EvaluationModel do
  @moduledoc false

  alias ExChess.Chess.Board

  def eval(%Board{} = board) do
    Nx.Serving.batched_run(
      ExChess.Models.EvaluationServing,
      Nx.Batch.stack([%{"board" => board_to_input(board)}]),
      &Nx.backend_transfer/1
    )
    |> Nx.reshape({})
    |> Nx.to_number()
  end

  def board_to_input(%Board{} = board) do
    [
      {:pawn, :white},
      {:rook, :white},
      {:knight, :white},
      {:bishop, :white},
      {:queen, :white},
      {:king, :white},
      {:pawn, :black},
      {:rook, :black},
      {:knight, :black},
      {:bishop, :black},
      {:queen, :black},
      {:king, :black}
    ]
    |> Enum.map(&Board.all_positions(board, &1))
    |> Enum.reject(fn positions -> positions == [] end)
    |> Enum.with_index(fn positions, i -> {positions, i} end)
    |> Enum.reduce(
      Nx.broadcast(Nx.u8(0), {8, 8, 12}),
      fn {positions, i}, acc ->
        indices = Nx.tensor(Enum.map(positions, fn p -> [7 - (p.rank - 1), p.column - 1, i] end))
        updates = Nx.broadcast(Nx.u8(1), {Nx.axis_size(indices, 0)})
        Nx.indexed_add(acc, Nx.tensor(indices), updates)
      end
    )
  end

  def params do
    :ex_chess
    |> :code.priv_dir()
    |> to_string()
    |> Path.join("evaluator_weights.nx")
    |> File.read!()
    |> Nx.deserialize()
  end

  def serving(batch_size \\ 20) do
    Nx.Serving.new(
      fn _ ->
        params = params()

        predict =
          model()
          |> Axon.build()
          |> elem(1)
          |> Nx.Defn.compile(
            [
              Nx.to_template(params),
              %{"board" => Nx.template({batch_size, 8, 8, 12}, :u8)}
            ],
            compiler: EXLA
          )

        fn inputs ->
          inputs
          |> Nx.Batch.pad(batch_size - inputs.size)
          |> then(&predict.(params, &1))
        end
      end,
      batch_size: batch_size
    )
  end

  defp model do
    resnet = fn input, n, k ->
      input
      |> Axon.conv(n, kernel_size: k, padding: :same, activation: :relu)
      |> then(fn layer ->
        layer
        |> Axon.conv(n, kernel_size: k, padding: :same, activation: :linear)
        |> Axon.add(layer)
      end)
      |> Axon.relu()
      |> Axon.batch_norm()
    end

    board_input = Axon.input("board", shape: {nil, 8, 8, 12})

    [
      board_input |> resnet.(16, 3) |> resnet.(16, 3),
      board_input |> resnet.(16, 7) |> resnet.(16, 7)
    ]
    |> Axon.concatenate(axis: -1)
    |> resnet.(32, 3)
    |> Axon.conv(128, kernel_size: 8, feature_group_size: 32, activation: :linear)
    |> Axon.batch_norm()
    |> Axon.relu()
    |> Axon.flatten()
    |> Axon.dense(128, activation: :relu)
    |> Axon.dense(128, activation: :relu)
    |> Axon.dense(1, activation: :tanh)
    |> Axon.nx(&Nx.multiply(&1, 20.0))
  end
end
