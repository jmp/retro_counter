defmodule RetroCounter.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/count.svg" do
    conn |> send_resp(200, "")
  end
end
