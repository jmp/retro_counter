defmodule RetroCounter.Test do
  use ExUnit.Case, async: true

  test "counter works" do
    response = get("/count.svg")

    assert response.status == 200
    assert response.headers["content-type"] == "image/svg+xml; charset=utf-8"
    assert response.body == svg_with_text("0000001")
  end

  defp get(path) do
    url = String.to_charlist("http://localhost:4000#{path}")
    {:ok, {{_, status, _}, headers, body}} = :httpc.request(url)

    %{
      status: status,
      headers: for({k, v} <- headers, into: %{}, do: {to_string(k), to_string(v)}),
      body: to_string(body)
    }
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
