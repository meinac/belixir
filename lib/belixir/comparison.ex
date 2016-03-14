defmodule Belixir.Comparison do
  require Logger

  @warm_up_duration 1_000_000_000

  def compare(%{ module: module, benchmarks: benchmarks, duration: duration }) when length(benchmarks) > 0 do
    Enum.map(benchmarks, &benchmark(module, &1, duration))
    |> Enum.map(&Belixir.Result.inspect(&1))
  end

  def compare(_) do
    error("You have to register code to benchmark!")
    System.halt(1)
  end

  defp benchmark(module, { name, method }, duration) do
    Logger.debug("Running `#{name}`")
    try do
      { name, Belixir.Server.benchmark(module, method, duration * 1_000_000_000, @warm_up_duration, timeout_for(duration)) }
    catch
      :exit, { :timeout, _ } ->
        error("Timeout happaned for `#{name}`!")
        System.halt(2)
    end
  end

  defp timeout_for(duration) do
    (duration * 1_000 * 1.5 + @warm_up_duration / 1_000_000)
    |> round
  end

  defp error(message) do
    IO.puts([IO.ANSI.red, message])
  end

end