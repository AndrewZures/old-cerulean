defmodule Cerulean.MySupervisor do
  use Supervisor
  import Supervisor.Spec

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_config) do
    children = [
      worker(Cerulean.MyServer, [self()])
    ]
    opts = [strategy: :one_for_all]
    supervise(children, opts)
  end
end
