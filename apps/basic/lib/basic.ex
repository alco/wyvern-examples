defmodule Basic do
  # This shows the basic view rendering.
  #
  # Try it out as follows:
  #
  #   Basic.render_index() |> IO.puts
  #
  #   Basic.render_index(["layouts/base"]) |> IO.puts
  #
  #   Basic.render_index(["layouts/base", "layouts/nav"]) |> IO.puts
  #
  def render_index(layout \\ []) do
    Wyvern.render_view(layout ++ ["index"])
  end
end
