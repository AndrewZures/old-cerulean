defmodule Cerulean.TestSupervisor do
  use Supervisor
  import Supervisor.Spec

  def start_link(_name) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_config) do
    children = [worker(Cerulean.BaseWorker, [])]
    opts = [strategy: :simple_one_for_one]
    supervise(children, opts)
  end

end
