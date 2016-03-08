defmodule Belixir.Result do

  def inspect({name, [total_run, run_time]}) do
    p_iter_p_sec = pretty_ips(total_run, run_time)
    p_total_run  = pretty_total_run(total_run)
    p_run_time   = pretty_run_time(run_time)

    IO.puts([IO.ANSI.green, "\n*************************** #{name} **********************"])    
    IO.puts([IO.ANSI.green, "#{p_run_time} #{p_total_run} total #{p_iter_p_sec} ips\n"])
  end

  defp pretty_ips(total_run, run_time) do
    total_run
      |> div(div(run_time, 1_000_000_000))
      |> pretty_total_run
  end

  defp pretty_total_run(total_run) do
    cond do
      total_run >= 1_000_000_000_000 ->
        to_string(:io_lib.format("~.2f T", [(total_run / 1_000_000_000_000)]))
      total_run >= 1_000_000_000 ->
        to_string(:io_lib.format("~.2f B", [(total_run / 1_000_000_000)]))
      total_run >= 1_000_000 ->
        to_string(:io_lib.format("~.2f M", [(total_run / 1_000_000)]))
      total_run >= 1_000 ->
        to_string(:io_lib.format("~.2f K", [(total_run / 1_000)]))
      true -> to_string(total_run)
    end
    |> String.rjust(10)
  end

  defp pretty_run_time(run_time) do
    cond do
      run_time >= 1_000_000_000 ->
        to_string(:io_lib.format("~.2f s", [(run_time / 1_000_000_000)]))
      run_time >= 1_000_000 ->
        to_string(:io_lib.format("~.2f ms", [(run_time / 1_000_000)]))
      run_time >= 1_000 ->
        to_string(:io_lib.format("~.2f µs", [(run_time / 1_000)]))
      true -> to_string(run_time)
    end
    |> String.rjust(7)
  end

end