defmodule RetroCounter.CountServer do
  use GenServer

  def start_link(
        count,
        name \\ :count_server,
        write_interval \\ :timer.hours(1),
        write_callback \\ fn -> nil end
      ) do
    IO.puts("Starting server with count #{count}...")

    GenServer.start_link(
      __MODULE__,
      %{
        :count => count,
        :write_interval => write_interval,
        :write_callback => write_callback
      },
      name: name
    )
  end

  def init(state) do
    schedule_write(state.write_interval)
    {:ok, state}
  end

  def handle_call(:increment, _from, state) do
    new_count = state.count + 1
    new_state = %{state | count: new_count}
    {:reply, new_count, new_state}
  end

  def handle_info(:write, state) do
    RetroCounter.Storage.write_integer(state.count, "count.txt")
    state.write_callback.()
    schedule_write(state.write_interval)
    {:noreply, state}
  end

  defp schedule_write(delay) do
    Process.send_after(self(), :write, delay)
  end
end
