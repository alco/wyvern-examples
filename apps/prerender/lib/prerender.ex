defmodule Prerender do
  @templates_dir "lib/prerender/templates"
  @output_dir "output"

  def render_views() do
    File.mkdir_p!(@output_dir)

    views = [
      ["layouts/base", "index"],
      ["layouts/base", "layouts/navbar", "red"],
      ["layouts/base", "layouts/navbar", "green"],
      ["layouts/base", "layouts/navbar", "blue"],
    ]
    Enum.each(views, fn layers ->
      result = Wyvern.render_view(layers, templates_dir: @templates_dir)
      path = Path.join(@output_dir, List.last(layers) <> ".html")
      File.write!(path, result)
    end)
  end
end
