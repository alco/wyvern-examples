defmodule Perf.DefineLayout do
  # Measures performance of the `Wyvern.render_view` function with predefined
  # layouts

  @views_root "tmp/define_layout/views"

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

        n = 10
        Enum.each(1..n, fn i ->
          File.write!(Path.join(base_path, "layout#{i}.html.eex"),
                      "<%= yield %>" <> bindata)
        end)
        File.write!(Path.join(base_path, "view.html.eex"), bindata)

        total_mb = Perf.format_num((size * (n+1)) / 1000000)

        IO.puts "done (total size #{total_mb} MB)"
      _ -> nil
    end
  end

  def measure(size) do
    IO.puts ""
    IO.puts "## define_layout tests ##"
    gen_templates(size, clean: true)
    IO.puts ""

    layout_layers = ["layout1", "layout2", "layout3", "layout4", "layout5",
                     "layout6", "layout7", "layout8", "layout9", "layout10"]
    layers = layout_layers ++ ["view"]
    config = [views_root: @views_root]
    autocompile_config = [autocompile: true] ++ config


    Perf.measure("No autocompile and no caching", fn ->
      Wyvern.render_view(layers, config)
    end)

    Wyvern.purge_cache(:autocompile)

    # precompile before measuring begins
    Wyvern.render_view(layers, autocompile_config)

    Perf.measure("Autocompile with precompilation but no caching", fn ->
      Wyvern.render_view(layers, autocompile_config)
    end)

    Wyvern.purge_cache(:autocompile)

    Perf.measure("Defining layout", fn ->
      Wyvern.define_layout(layout_layers, views_root: @views_root, name: "layout:layered")
    end)

    Perf.measure("No autocompile with layout", fn ->
      Wyvern.render_view(["layout:layered", "view"], config)
    end)

    # FIXME: predefined layout is currently incompatible with autocompile
    #Perf.measure("Autocompile with layout", fn ->
      #Wyvern.render_view(["layout:layered", "view"], autocompile_config)
    #end)
  end
end
