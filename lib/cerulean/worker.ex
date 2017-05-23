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
    case start_children(sup, state) do
      {:ok, _} ->
        {:noreply, state}
      {:error, error} ->
        {:stop, error}
    end
  end

  def handle_call({:start_children, sup}, _from, state) do
    start_children(sup, state)
  end

  def start_children(sup, state) do
    case start_child_supervisor(sup, state) do
      {:ok, child_sup} ->
        start_all_children(child_sup)
        {:ok, child_sup}
      {:error, error} ->
        {:error, error}
      _ ->
        {:error, :unknown}
    end
  end

  def start_child_supervisor(sup, state) do
    opts = [id: "hello", restart: :permanent]
    Supervisor.start_child(sup, supervisor(Cerulean.TestSupervisor, [], opts))
  end

  def start_all_children(child_sup) do
    1..3
    |> Enum.each(fn (idx) -> start_child(idx, child_sup) end)
  end

  def start_child(idx, sup) do
    {:ok, child} = Supervisor.start_child(sup, [[name: :"#{idx}BaseWorker"]])
  end
end
