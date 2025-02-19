defmodule RetroCounter.ApplicationTest do
  use ExUnit.Case

  test "returns 200 OK" do
    response = Req.get!("http://localhost:4000/count.svg")

    assert response.status == 200
  end
end
