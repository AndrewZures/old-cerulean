defmodule Cerulean.Primes do

  def start_link do
  end

  def find(x) do
    loop(0)
    hi = self()
    # 1..x
    # |> Enum.map(fn (i) -> Task.async(fn -> send(hi, {:add, i}) end) end)
    # |> Enum.each(fn (task) -> Task.await(task) end)
    # send(hi, :result)
  end

  def help do
    # |> Enum.map(fn (i) -> Task.async(fn -> send(hi, {:add, i}) end) end)
  end

  def loop(sum) do
    receive do
      {:add, i} ->
        loop(sum+i)
      :result
        sum
      _ ->
        loop(sum)
    end
  end
end
