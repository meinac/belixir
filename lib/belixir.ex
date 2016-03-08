defmodule Belixir do

  defmacro __using__(_op) do
    quote do
      use Application
      require Logger

      Module.register_attribute __MODULE__, :benchmarks, accumulate: true

      def start(_type, _args) do
        res = Belixir.Supervisor.start_link([])
        Belixir.Comparison.compare([module: __MODULE__, benchmarks: benchmarks])
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

  defmacro compare do
    quote do
      def benchmarks do
        @benchmarks
      end
    end
  end
  
end
