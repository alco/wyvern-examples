defmodule Perf do
  use Application.Behaviour

  def start(_type, _args) do
    ##Perf.RenderView.measure(10000)
    #Perf.RenderView.measure(100000)
    ##Perf.RenderView.measure(200000)

    #Perf.DefineLayout.measure(50000)

    #Perf.CompiledLayout.measure()

    Perf.CompiledView.measure()

    {:ok, self()}
  end


  @iterations 10

  def measure(msg, f) do
    IO.write "#{msg}..."

    {t1, _} = :timer.tc(f)
    {t2, _} = :timer.tc(fn -> repeat(@iterations-1, f) end)

    total_s = format_num((t1 + t2) / 1000000)
    first_ms = format_num(t1 / 1000)
    avg_ms = format_num(t2 / 1000 / (@iterations-1))

    IO.write """
    done
      total:        #{total_s} s (#{@iterations} iterations)
      avg per call: #{avg_ms} ms
      first call:   #{first_ms} ms
    """
  end


  defp repeat(1, f) do
    f.()
  end

  defp repeat(n, f) do
    f.()
    repeat(n-1, f)
  end


  def format_num(num) when is_integer(num) do
    integer_to_binary(num)
  end

  def format_num(num) when is_float(num) do
    float_to_binary(num, decimals: 2)
  end
end
