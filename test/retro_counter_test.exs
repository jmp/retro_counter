defmodule RetroCounterTest do
  use ExUnit.Case
  doctest RetroCounter

  test "greets the world" do
    assert RetroCounter.hello() == :world
  end
end
