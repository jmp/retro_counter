defmodule RetroCounter.Test do
  use ExUnit.Case, async: true
  import Plug.Test
  import Plug.Conn

  @opts RetroCounter.Router.init([])

  test "counter works" do
    conn = conn(:get, "/count.svg")
    conn = RetroCounter.Router.call(conn, @opts)

    assert conn.status == 200
    assert get_resp_header(conn, "content-type") == ["image/svg+xml; charset=utf-8"]
    assert conn.resp_body == svg_with_text("0000001")
  end

  defp svg_with_text(text) do
    """
    <svg width="200" height="50" viewBox="0 0 200 50" xmlns="http://www.w3.org/2000/svg">
      <rect width="100%" height="100%" fill="black" stroke="white" stroke-width="4"/>
      <text x="195" y="39" fill="white" text-anchor="end" font-size="45" font-family="Courier New">
        #{text}
      </text>
    </svg>
    """
  end
end
