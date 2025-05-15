defmodule RetroCounter.Test do
  use ExUnit.Case, async: true

  test "counter works" do
    response = get("/count.svg")

    assert response.status == 200
    assert response.headers["content-type"] == "image/svg+xml; charset=utf-8"
    assert response.body == svg_with_text("0000001")
  end

  defp get(path) do
    url = "http://localhost:4000#{path}"
    {:ok, {{_, status, _}, header_list, body_chars}} = :httpc.request(url)

    headers = Map.new(header_list, fn {k, v} -> {List.to_string(k), List.to_string(v)} end)
    body = List.to_string(body_chars)

    %{
      :status => status,
      :headers => headers,
      :body => body
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
