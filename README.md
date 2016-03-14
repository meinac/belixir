# Belixir

Elixir iterations per second benchmark tool inspired from awesome Ruby `benchmark-ips` gem.

## Installation

Add belixir to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [{:belixir, "~> 0.1.0"}]
  end
```

Then run `mix deps.get`.

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

  Belixir.compare(3) # Runs each benchmark for 3 seconds. If you don't send any parameter, it runs for 5 seconds.

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

*************************** bar **********************
 5.00 s     8.93 M total     1.79 M ips


*************************** foo **********************
 5.00 s   148.35 M total    29.67 M ips

`foo` is fastest
`bar` is 16.61 times slower than `foo`

```
