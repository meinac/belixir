# Belixir

Elixir iteration per seconds benchmark tool inspired from awesome Ruby `benchmark-ips` gem.

## Installation

The package can be installed as:

  1. Add belixir to your list of dependencies in `mix.exs`:

        def deps do
          [{:belixir, "~> 0.1.0"}]
        end

## Example Usage

Define a module which uses `Belixir` like so:

```elixir
defmodule MyBenchmark do
  use Belixir

  Belixir.ips "foo" do
    a = (1 + 1) / 4 + 1
    :math.sqrt(a)
    b = (1 + 1) / 4 + 2
    :math.sqrt(b)
  end

  Belixir.ips "bar" do
    for n <- 1..2 do
      a = (1 + 1) / 4 + n
      :math.sqrt(a)
    end
  end

  Belixir.compare

end
```

Define your application in mix file as:

```
def application do
  [applications: [:logger], mod: { MyBenchmark , [] }]
end
```

Then run it with `iex -S mix`.

## Example Output

```

*************************** foo **********************
 5.01 s   138.85 M total    27.77 M ips


*************************** bar **********************
 5.00 s     8.40 M total     1.68 M ips

```
