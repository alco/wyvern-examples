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
    file_opts = [
      output_dir: @output_dir,
      ext: "html",
      check: :timestamp,
    ]
    Wyvern.render_views(views, templates_dir: @templates_dir, file_opts: file_opts)
  end
end
