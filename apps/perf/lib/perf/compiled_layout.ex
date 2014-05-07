views_root = "tmp/compiled_layout/views"

defmodule Perf.CompiledLayout.Generator do
  @views_root views_root

  # generate sizable templates
  def gen_templates(mod, size, [clean: should_clean]) do
    base_path = Path.join(@views_root, "templates")

    if should_clean do
      File.rm_rf!(base_path)
    end

    case File.stat(Path.join(base_path, "view.html.eex")) do
      {:error, :enoent} ->
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
        Module.put_attribute mod, :template_size, total_mb

      _ -> nil
    end
  end
end

defmodule Perf.CompiledLayout do
  # Measures performance of the `Wyvern.render_view` function with precompiled
  # layouts

  defmodule Layouts do
    Perf.CompiledLayout.Generator.gen_templates(Perf.CompiledLayout, 100000, clean: true)

    require Wyvern
    # FIXME: replace literal values with variables when they are supported
    Wyvern.compile_layouts([
      [layers: ["layout1", "layout2", "layout3", "layout4", "layout5",
                     "layout6", "layout7", "layout8", "layout9", "layout10"],
       views_root: "tmp/compiled_layout/views",
       name: "layout:compiled"],
    ])
  end


  @views_root views_root

  def measure() do
    IO.puts ""
    IO.puts "## compiled_layout tests ##"
    IO.puts "(total template size #{@template_size} MB)"
    IO.puts ""

    config = [views_root: @views_root]
    layout_layers = ["layout1", "layout2", "layout3", "layout4", "layout5",
                     "layout6", "layout7", "layout8", "layout9", "layout10"]

    Perf.measure("Basic render_view, no autocompile and no caching", fn ->
      Wyvern.render_view(layout_layers ++ ["view"], config)
    end)

    Perf.measure("Predefined layout, no autocompile and no caching", fn ->
      layout = Wyvern.define_layout(layout_layers, config)
      Wyvern.render_view([layout, "view"], config)
    end)

    Perf.measure("Precompiled layout, no autocompile and no caching", fn ->
      Wyvern.render_view([Layouts.layout("layout:compiled"), "view"], config)
    end)

    Perf.measure("Precompiled layout, no autocompile and no caching (using Layouts.render)", fn ->
      Layouts.render("layout:compiled", "view", config)
    end)

    # FIXME: autocompile is not compatible with precompiled layout
    #Wyvern.purge_cache(:autocompile)

    ## precompile before measuring begins
    #Wyvern.render_view([Layouts.layout("layout:compiled"), "view"], autocompile_config)

    #Perf.measure("Precompiled layout, autocompile with precompilation but no caching", fn ->
      #Wyvern.render_view([Layouts.layout("layout:compiled"), "view"], autocompile_config)
    #end)
  end
end
