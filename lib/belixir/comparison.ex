defmodule Belixir.Comparison do
  require Logger

  @default_duration 5_000
  @warm_up_duration 1_000_000_000

  def compare([module: module, benchmarks: benchmarks]) when length(benchmarks) > 0 do
    Enum.map(benchmarks, &benchmark(module, &1))
      |> Enum.map(&Belixir.Result.inspect(&1))
  end

  def compare(_) do
    error("You have to register code to benchmark!")
    System.halt(1)
  end

  defp benchmark(module, {name, method}) do
    Logger.debug("Running `#{name}`")
    try do
      { name, Belixir.Server.benchmark(module, method, @default_duration * 1_000_000, @warm_up_duration, @default_duration * 2) }
    catch
      :exit, { :timeout, _ } ->
        error("Timeout happaned for `#{name}`!")
        System.halt(2)
    end
  end

  defp error(message) do
    IO.puts([IO.ANSI.red, message])
  end

end