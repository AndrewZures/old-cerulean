defmodule Cerulean.MyServer do
  use GenServer
  import Supervisor.Spec

  defmodule State do
    defstruct children: [], sup: nil, config: nil
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end


  def init([sup, config]) do
    state = %State{ sup: sup, config: config }
    send(self(), :start_children)
    {:ok, state}
  end


  def handle_call(:start_children, state = %{ sup: sup, config: config }) do
    # children = start_children(sup, 3, [])
    # {:noreply, %{state | children: children}}
    {:noreply, state}
  end

  defp start_children(_, 0, children), do: children
  defp start_children(sup, cnt, children) do
    {:ok, child} = Supervisor.start_child(sup, [[]])
    start_children(sup, cnt-1, [children | child])
  end

end
