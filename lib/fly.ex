defmodule Fly do
  @moduledoc false

  @doc """
  Returns the current node name
  """
  def name do
    Atom.to_string(node())
  end

  @doc """
  Returns the current application region

  Reference: https://fly.io/docs/reference/regions/
  """
  @spec region :: String.t()
  def region do
    region = System.get_env("FLY_REGION", "?")

    flag =
      case region do
        "cdg" ->
          "🇫🇷"

        "fra" ->
          "🇩🇪"

        "lhr" ->
          "🇬🇧"

        "ams" ->
          "🇳🇱"

        "syd" ->
          "🇦🇺"

        usa
        when usa in ["atl", "bos", "den", "dfw", "ewr", "iad", "lax", "mia", "ord", "sea", "sjc"] ->
          "🇺🇸"

        canada when canada in ["yul", "yyz"] ->
          "🇨🇦"

        _ ->
          "🇺🇳"
      end

    Enum.join([flag, region], " - ")
  end
end
