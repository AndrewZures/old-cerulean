defmodule Cerulean.Worker do
  use GenServer
  import Supervisor.Spec

  # Api

  def start_link(sup) do
    GenServer.start_link(__MODULE__, [sup], name: __MODULE__)
  end

  # Callbacks

  def init([sup]) do
    send(self(), {:start_children, sup})
    {:ok, []}
  end

  def handle_info({:start_children, sup}, state) do
    start_children(sup, state)
  end

  def handle_call({:start_children, sup}, _from, state) do
    start_children(sup, state)
  end

  def start_children(sup, state) do
    opts = [id: "hello", restart: :permanent]
    case Supervisor.start_child(sup, supervisor(Cerulean.TestSupervisor, [], opts)) do
      {:ok, w} ->
        {:noreply, state}
      {:error, error} ->
        {:error, error}
    end
  end

end
