defmodule RetroCounter.Counter do
  use GenServer

  def start_link(opts) do
    parsed_opts = read_opts(opts)

    GenServer.start_link(__MODULE__, parsed_opts, name: parsed_opts.name)
  end

  def init(state) do
    count = RetroCounter.Storage.read_integer(state.count_path)
    new_state = Map.put(state, :count, count)
    {:ok, new_state}
  end

  def handle_call(:increment, _from, state) do
    new_count = state.count + 1

    if !state.write_scheduled? do
      Process.send_after(self(), :write, state.write_delay)
    end

    new_state = %{state | count: new_count, write_scheduled?: true}
    {:reply, new_count, new_state}
  end

  def handle_info(:write, state) do
    write_state(state)
    state.write_callback.()
    new_state = %{state | write_scheduled?: false}
    {:noreply, new_state}
  end

  defp read_opts(opts) do
    %{
      :count_path => Keyword.fetch!(opts, :count_path),
      :write_delay => Keyword.get(opts, :write_delay, :timer.seconds(30)),
      :write_callback => Keyword.get(opts, :write_callback, fn -> :ok end),
      :write_scheduled? => false,
      :name => Keyword.get(opts, :name, :count_server)
    }
  end

  defp write_state(state) do
    RetroCounter.Storage.write_integer(state.count, state.count_path)
  end
end
