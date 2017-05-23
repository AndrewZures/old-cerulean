defmodule Cerulean.BaseWorker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, [args], name: args[:name])
  end

  def init(_args) do
    {:ok, []}
  end
end
