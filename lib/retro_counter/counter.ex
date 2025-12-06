defmodule RetroCounter.Counter do
  use GenServer

  defstruct [:count_path, :write_delay, :write_callback, :count, :write_scheduled?]

  def start_link(opts) do
    name = Keyword.get(opts, :name, :count_server)

    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def increment(server \\ :count_server) do
    GenServer.call(server, :increment)
  end

  @impl true
  def init(opts) do
    state = %__MODULE__{
      count_path: Keyword.fetch!(opts, :count_path),
      write_delay: Keyword.get(opts, :write_delay, :timer.seconds(30)),
      write_callback: Keyword.get(opts, :write_callback, fn -> :ok end),
      write_scheduled?: false,
      count: 0
    }

    initial_count = RetroCounter.Storage.read_integer(state.count_path)

    {:ok, %{state | count: initial_count}}
  end

  @impl true
  def handle_call(:increment, _from, state) do
    new_count = state.count + 1

    if !state.write_scheduled? do
      Process.send_after(self(), :write, state.write_delay)
    end

    new_state = %{state | count: new_count, write_scheduled?: true}
    {:reply, new_count, new_state}
  end

  @impl true
  def handle_info(:write, state) do
    write_state(state)
    state.write_callback.()
    new_state = %{state | write_scheduled?: false}
    {:noreply, new_state}
  end

  defp write_state(state) do
    RetroCounter.Storage.write_integer(state.count, state.count_path)
  end
end
