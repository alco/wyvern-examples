defmodule Perf.RenderView do
  # Measures performance of the `Wyvern.render_view` function with different
  # compilation and caching settings

  @views_root "tmp/render_view/views"

  # generate sizable templates
  def gen_templates(size, [clean: should_clean]) do
    base_path = Path.join(@views_root, "templates")

    if should_clean do
      File.rm_rf!(base_path)
    end

    case File.stat(Path.join(base_path, "view.html.eex")) do
      {:error, :enoent} ->
        IO.write "generating templates..."
        File.mkdir_p!(base_path)

        bindata =
          Stream.repeatedly(fn -> "*" end)
          |> Stream.take(size)
          |> Enum.join()

        File.write!(Path.join(base_path, "base.html.eex"),
                    "<%= yield %>" <> bindata <> "<%= yield :footer %>")
        File.write!(Path.join(base_path, "interm.html.eex"),
                    bindata <> "<%= yield %>" <> bindata)
        File.write!(Path.join(base_path, "view.html.eex"),
                    bindata <> bindata <> bindata)

        total_mb = Perf.format_num((size * 6) / 1000000)

        IO.puts "done (total size #{total_mb} MB)"
      _ -> nil
    end
  end

  def measure(size) do
    IO.puts ""
    IO.puts "## render_view tests ##"
    gen_templates(size, clean: true)
    IO.puts ""

    layers = ["base", "interm", "view"]
    config = [views_root: @views_root]
    autocompile_config = [autocompile: true] ++ config


    Perf.measure("No autocompile and no caching", fn ->
      Wyvern.render_view(layers, config)
    end)

    Wyvern.purge_cache(:autocompile)

    Perf.measure("Autocompile but no caching", fn ->
      Wyvern.render_view(layers, autocompile_config)
    end)

    Wyvern.purge_cache(:autocompile)

    # precompile before measuring begins
    Wyvern.render_view(layers, autocompile_config)

    Perf.measure("Autocompile with precompilation but no caching", fn ->
      Wyvern.render_view(layers, autocompile_config)
    end)
  end
end
