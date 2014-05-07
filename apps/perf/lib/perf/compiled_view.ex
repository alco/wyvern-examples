views_root = "tmp/compiled_view/views"

defmodule Perf.CompiledView.Generator do
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

        File.write!(Path.join(base_path, "layout.html.eex"),
                    "<%= yield %>" <> bindata)
        File.write!(Path.join(base_path, "sub_layout.html.eex"),
                    bindata <> "<%= yield %>" <> bindata)
        File.write!(Path.join(base_path, "view.html.eex"), bindata <> bindata <> bindata)

        total_mb = Perf.format_num((size * 6) / 1000000)
        Module.put_attribute mod, :template_size, total_mb

      _ -> nil
    end
  end
end

defmodule Perf.CompiledView do
  # Measures performance of precompiled views

  Perf.CompiledView.Generator.gen_templates(__MODULE__, 200000, clean: true)

  defmodule Views do
    require Wyvern
    # FIXME: replace literal values with variables when they are supported
    Wyvern.compile_views([
      [layers: ["layout", "view"],
       views_root: "tmp/compiled_view/views",
       name: "basic_view"],

      [layers: ["layout", "sub_layout", "view"],
       views_root: "tmp/compiled_view/views",
       name: "nested_view"],
    ])
  end


  defmodule SingleView do
    layers = ["layout", "sub_layout", "view"]

    use Wyvern.View, [
      layers: layers,
      views_root: views_root,
    ]
  end

  @views_root views_root

  def measure() do
    IO.puts ""
    IO.puts "## compiled_view tests ##"
    IO.puts "(total template size #{@template_size} MB)"
    IO.puts ""

    config = [views_root: @views_root]
    basic_layers = ["layout", "view"]
    nested_layers = ["layout", "view"]

    Perf.measure("Basic render_view(basic_view), no autocompile and no caching", fn ->
      Wyvern.render_view(basic_layers, config)
    end)

    Perf.measure("Precompiled basic_view, no caching", fn ->
      Views.render("basic_view")
    end)

    Perf.measure("Basic render_view(nested_view), no autocompile and no caching", fn ->
      Wyvern.render_view(nested_layers, config)
    end)

    Perf.measure("Precompiled nested_view, no caching", fn ->
      Views.render("nested_view")
    end)

    Perf.measure("Precompiled nested_view, no caching (using single module)", fn ->
      SingleView.render()
    end)
  end
end
