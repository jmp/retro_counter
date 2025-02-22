defmodule RetroCounter.CountServer do
  use GenServer

  def start_link(opts) do
    count_path = Keyword.fetch!(opts, :count_path)
    name = Keyword.get(opts, :name, :count_server)
    write_interval = Keyword.get(opts, :write_interval, :timer.hours(1))
    write_callback = Keyword.get(opts, :write_callback, fn -> :ok end)
    count = RetroCounter.Storage.read_integer(count_path)

    GenServer.start_link(
      __MODULE__,
      %{
        :count => count,
        :count_path => count_path,
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
    RetroCounter.Storage.write_integer(state.count, state.count_path)
    state.write_callback.()
    schedule_write(state.write_interval)
    {:noreply, state}
  end

  defp schedule_write(delay) do
    Process.send_after(self(), :write, delay)
  end
end
