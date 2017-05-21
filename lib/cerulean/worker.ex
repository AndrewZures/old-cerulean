defmodule Cerulean.Worker do
  use GenServer

  # Api

  def start_link() do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def inc(pid, x) do
    GenServer.call(pid, {:inc, x})
  end

  # Callbacks

  def handle_call({:inc, x}, _from, state) do
    {:reply, state+x, state+x}
  end
end
