defmodule Cerulean.MyServer do
  use GenServer
  import Supervisor.Spec

  defmodule State do
    defstruct children: [], sup: nil, my_sup: nil, config: nil
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init() do
    # send(self(), {:start_children, sup})
    {:ok, []}
  end

  def handle_info({:start_children, sup}, state) do
    # Supervisor.start_child(sup, worker(Cerulean.Worker, []))
  end
end
