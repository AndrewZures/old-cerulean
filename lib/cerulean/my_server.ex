defmodule Cerulean.MyServer do
  use GenServer
  import Supervisor.Spec
  require IEx

  defmodule State do
    defstruct children: [], sup: nil, my_sup: nil, config: nil
  end

  def start_link(sup, config) do
    GenServer.start_link(__MODULE__, [sup, config], name: __MODULE__)
  end

  def init([sup, config]) do
    state = %State{ sup: sup, config: config }
    send(self(), :start_children)
    {:ok, state}
  end

  def handle_info(:start_children, state = %{ sup: sup, config: config }) do
    worker_sup = start_worker_supervisor(sup)
    # workers =  start_workers(worker_sup, config)
    {:noreply, %{ state | worker_sup: worker_sup }}
  end

  defp start_worker_supervisor(sup) do
    {:ok, worker_sup} = Supervisor.start_child(sup, supervisor(Cerulean.MySupervisor, []))
    worker_sup
  end

  defp start_workers(worker_sup, config = %{ child_count: child_count }) do
    start_worker(worker_sup, [], child_count)
  end

  defp start_worker(worker_sup, children, 0), do: children
  defp start_worker(worker_sup, children, cnt) do
    {:ok, worker} = Supervisor.start_child(worker_sup, [[]])
    start_worker(worker_sup, [children | worker], cnt-1)
  end

  # def handle_call(:start_children, state = %{ sup: sup, config: config }) do
  #   # children = start_children(sup, 3, [])
  #   # {:noreply, %{state | children: children}}
  #   {:noreply, state}
  # end
  #
  # defp start_children(_, 0, children), do: children
  # defp start_children(sup, cnt, children) do
  #   {:ok, child} = Supervisor.start_child(sup, [[]])
  #   start_children(sup, cnt-1, [children | child])
  # end

end
