defmodule FlyTest do
  use ExUnit.Case

  @regions [
    {"cdg", "🇫🇷 - cdg"},
    {"sea", "🇺🇸 - sea"},
    {"?", "🇺🇳 - ?"}
  ]

  test "Fly regions can be displayed" do
    for {env, region} <- @regions do
      System.put_env("FLY_REGION", env)
      assert Fly.region() == region
    end
  end

  test "Node name can be displayed" do
    assert Fly.name() == "nonode@nohost"
  end
end
