defmodule Cerulean.BaseWorker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, [args])
  end

  def init(_args) do
    {:ok, []}
  end
end
