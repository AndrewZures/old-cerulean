defmodule Cerulean.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Cerulean.MyServer, [self(), %{ child_count: 3 }])
    ]
    opts = [strategy: :one_for_one, name: Cerulean.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
