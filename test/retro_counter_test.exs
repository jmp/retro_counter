defmodule RetroCounterTest do
  use ExUnit.Case

  test "smoke" do
    assert RetroCounter.start(:normal, []) != nil
  end
end
