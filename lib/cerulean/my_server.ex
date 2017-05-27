defmodule Cerulean.MyServer do
  use GenServer
  import Supervisor.Spec

  # Api

  defmodule State do
    defstruct workers: [], sup: nil, child_sup: nil
  end

  def start_link(sup) do
    GenServer.start_link(__MODULE__, [sup], name: __MODULE__)
  end

  # Callbacks

  def init([sup]) do
    send(self(), {:start_children, sup})
    {:ok, %State{sup: sup}}
  end

  def handle_info({:start_children, sup}, state) do
    state = start_children(sup, state)
    {:noreply, state}
    # case start_children(sup, state) do
    #   {:ok, children} ->
    #     {:noreply, state}
    #   {:error, error} ->
    #     {:stop, error}
    # end
  end

  def start_children(sup, state) do
    start_child_supervisor(sup, state)
    |> start_all_children()
    |> register_children(state)
  end

  def start_child_supervisor(sup, state) do
    opts = [restart: :permanent]
    {:ok, child_sup} = Supervisor.start_child(sup, supervisor(Cerulean.TestSupervisor, [name: "Hello"], opts))
    child_sup
  end

  def start_all_children(child_sup) do
    1..3
    |> Enum.map(fn (idx) -> Supervisor.start_child(child_sup, [[]]) end)
    |> Enum.map(fn ({:ok, child}) -> child end)
  end

  def register_children([], state), do: state
  def register_children([child|children], state = %{workers: workers}) do
    state = %{state | workers: [child|workers]}
    register_children(children, state)
  end

end
