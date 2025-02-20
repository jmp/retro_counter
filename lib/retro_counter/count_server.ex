defmodule RetroCounter.CountServer do
  use GenServer

  @name :count_server

  def start_link(count) do
    IO.puts("Starting server with count #{count}...")
    GenServer.start_link(__MODULE__, %{:count => count}, name: @name)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:increment, _from, state) do
    new_count = state.count + 1
    new_state = %{state | count: new_count}
    {:reply, new_count, new_state}
  end
end
