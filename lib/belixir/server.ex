defmodule Belixir.Server do
  use GenServer
  require Logger

  @time_unit 1_000_000_000

  ##############
  # Public API #
  ##############

  def start_link(initial_list) do
    { :ok, _pid } = GenServer.start_link(__MODULE__, initial_list, name: __MODULE__)
  end

  def benchmark(module, method, limit, warm_up, timing) do
    GenServer.call(__MODULE__, { :benchmark, module, method, limit, warm_up }, timing)
  end

  #############

  def init(initial_list) do
    { :ok, initial_list }
  end

  def handle_call({ :benchmark, module, method, limit, warm_up }, _from, _state) do
    { iterations, run_time } = run_code(module, method, limit, warm_up)
    { :reply, [iterations, run_time], [] }
  end

  # Run warm up & benchmark
  defp run_code(module, method, limit, warm_up) do
    Logger.debug("... Warming up  ...")
    approx_loop = run_warmup(module, method, warm_up) |> cycles_per_10ms
    Logger.debug("... Calculating ...")
    run_benchmark(module, method, limit, approx_loop)
  end

  # Run warm up
  defp run_warmup(module, method, limit, loop_count \\ 1, elapsed \\ 0) do
    if limit > elapsed do
      time_diff = diff_in_times(module, method, loop_count)
      run_warmup(module, method, limit, loop_count * 2, time_diff + elapsed)
    else
      { loop_count, elapsed }
    end
  end

  # Run benchmark
  defp run_benchmark(module, method, limit, loop_count, t_loop_count \\ 0, elapsed \\ 0) do
    if limit > elapsed do
      time_diff = diff_in_times(module, method, loop_count)
      run_benchmark(module, method, limit, loop_count, t_loop_count + loop_count, elapsed + time_diff)
    else
      { t_loop_count, elapsed }
    end
  end

  # Run code n times & calculate time
  defp diff_in_times(module, method, loop_count) do
    started_at = :erlang.system_time(@time_unit)
    n_times(module, method, loop_count)
    :erlang.system_time(@time_unit) - started_at
  end

  # Calculate iterations for 10 ms
  defp cycles_per_10ms({ warm_iterations, warm_time }) do
    case trunc(warm_iterations / (warm_time / 10_000_000)) do
      0 -> 1
      count -> count
    end
  end

  # Run code 1 time
  defp n_times(module, method, 1) do
    apply(module, method, [])
  end

  # Run code n times
  defp n_times(module, method, n) do
    apply(module, method, [])
    n_times(module, method, n - 1)
  end

end