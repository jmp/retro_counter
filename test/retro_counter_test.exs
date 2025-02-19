defmodule RetroCounterTest do
  use ExUnit.Case

  test "smoke" do
    pid = RetroCounter.start(:normal, [])
    assert pid != nil
  end
end
