defmodule Belixir.Supervisor do
  use Supervisor
  require Logger

  def start_link(initial_list) do
    { :ok, _pid } = Supervisor.start_link(__MODULE__, initial_list, name: __MODULE__)
  end

  def init(initial_list) do
    children = [ worker(Belixir.Server, [initial_list]) ]
    supervise(children, strategy: :one_for_one)
  end

end