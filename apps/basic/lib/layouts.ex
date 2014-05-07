defmodule Basic.Layouts do
  # Defining layouts allows us to precompile a particular set of layers and
  # reference it later by name or by value

  # Wyvern generates a dynamic module to hold the compiled templates. As a
  # consequence of this, we need to ensure our calls to `Wyvern.define_layout`
  # happen at run time.

  def basic_layout() do
    # the value returned can be used as a layer passed to the
    # `Wyvern.render_view` function
    Wyvern.define_layout(["layouts/base"])
  end

  def nav_layout() do
    # here we are passing the 'name' option, so we can ignore the return value
    # of `define_layout` and use the name in subsequent calls to
    # `Wyvern.render_view`, relying on the caching facility provided by Wyvern
    Wyvern.define_layout(["layouts/base", "layouts/nav"], name: "layout:navbar")
  end

  # Try it out as follows:
  #
  #   Basic.render_index([Basic.Layouts.basic_layout()]) |> IO.puts
  #
  #   Basic.render_index([Basic.Layouts.nav_layout()]) |> IO.puts
  #
  #   Basic.render_index(["layout:navbar"]) |> IO.puts
  #
  # Note that we can use the name "layout:navbar" only after we called the
  # `nav_layout` function at least once. In subsequent examples we will see how
  # to define layouts and views at compile time.
end
