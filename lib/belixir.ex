defmodule Belixir do

  @default_duration 5

  defmacro __using__(_op) do
    quote do
      use Application
      require Logger

      Module.register_attribute __MODULE__, :benchmarks, accumulate: true

      def start(_type, _args) do
        res = Belixir.Supervisor.start_link([])
        Belixir.Comparison.compare(Map.merge(%{ module: __MODULE__ }, configuration))
        res
      end
    end
  end

  defmacro ips(name, [do: code]) do
    call_function_name = :"ips_#{name}"

    quote do
      def unquote(call_function_name)() do
        unquote(code)
      end

      @benchmarks {:"#{unquote(name)}", unquote(call_function_name)}
    end
  end

  defmacro compare(duration \\ @default_duration) do
    quote do
      def configuration do
        %{ benchmarks: @benchmarks, duration: unquote(duration) }
      end
    end
  end
  
end
