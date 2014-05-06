# Wyvern examples

---

**The code in this repository is not ready for consumption and is most likely broken. The description below is a draft of the intended workflow to use with [Wyvern](https://github.com/alco/wyvern)**

---

Basic usage starts with the `Wyvern.render_view` function. It takes a list of
layers and config options and produces the rendered view.

This function will compile the templates in memory and will also cache the
results per the provided config, making subsequent calls to it using the same
layers fairly cheap.

There's a number of ways users can further optimize the rendering process.


## Defining layouts

First, we can define a layout which will more efficiently precompile it.

```
Wyvern.define_layout(["base", "navbar"], name: "layout:navbar")
```

Giving it a name allows us to use that name in calls to `render_view` like this:

```
Wyvern.render_view(["layout:navbar", "view"])
```

However, in order for this to work, `define_layout` has to be called at run
time, after the `:wyvern` application has been started.

Alternative way of using `define_layout` at run time:

```
defmodule MyLayouts do
  def navbar_layout do
    Wyvern.define_layout(["base", "navbar"])
  end
end

...

defmodule M do
  def render_my_view do
    Wyvern.render_view([MyLayouts.navbar_layout, "view"])
  end
end
```

Repeated calls to the `navbar_layout` function will hit the cache so it won't
recompile the layers every time.


## Precompiling layouts

In case you want to have a set of layouts already compiled before your app
starts, you need to put them into a module (or multiple modules).

```
defmodule MyLayouts do
  # define base so that it is not merged into subsequently defined layouts
  # but is referenced by them
  base = Wyvern.define_layout(["base"])

  require Wyvern

  Wyvern.compile_layouts([
    [layers: [base, "navbar"]],
    [layers: [base, "sidebar", "navbar"], name: "layout:sidenav"],
  ])
end
```

This will create a `render/3` function and a `layout/1` function within the
module with separate clause for each layout. Use those layouts as follows:

```
MyLayouts.render("layout:sidenav", "view", attrs: ...)
# or
Wyvern.render_view([MyLayouts.layout("layout:sidenav"), "view"])
```

To have one layout per module, do the following:

```
defmodule SingleLayout do
  use Wyvern.Layout, [
    layers: ["base", "navbar"]
  ]
end

SingleLayout.render("view", attrs: ...)
# or
Wyvern.render_view([SingleLayout, "view"])
```


## Precompiling views

We can also precompile views into modules during our project's compilation
phase. This can be done as follows:

```
defmodule MyViews do
  base_layout = "layouts/base"
  navbar_layout = Wyvern.define_layout(["base", "navbar"])

  require Wyvern

  Wyvern.compile_views([
    [layers: [base_layout, "index"], name: "home", attrs: [...]],
    [layers: [navbar_layout, "products/index"], attrs: [...]],
    [layers: [navbar_layout, "products/new"], attrs: [...]],
    [layers: [navbar_layout, "products/edit"], attrs: [...]],
  ])
end
```

This will create `MyViews.render/2` function with a separate clause for each
view. At run time, we can render our views like this:

```
MyViews.render("home", [])  # renders the "index" view; the name "home" was passed as an option
MyViews.render("products/edit", product_id: <id>)
```

To use a single module per view:

```
defmodule IndexView do
  navbar_layout = Wyvern.define_layout(["base", "navbar"])

  use Wyvern.View, [
    layers: [navbar_layout, "index"],
    attrs: ...,
  ]
end

IndexView.render(<attrs>)
```


## Prerendering views

Prerendering means rendering all or some of your app's views upfront, so that
your server can then serve static files directly. With Wyvern you just need to
set up a list of views you want prerendered along with caching config that will
indicate under which conditions views should be rendered again.

Caches can be individually invalidated to make sure your prerendered views
reflect the state of your app's models.


## Caching rendered views

Wyvern also supports caching of rendering results. Based on you application
needs, some views may change less frequently than others. Caching controls in
Wyvern allow us to cache rendered views until explicitly invalidated or until
one of the underlying templates change.

It is also possible to set up caching to files so that your http server can use
facilities provided by the OS so send view files over sockets if they don't
need to be recreated. This could further improve the performance of your app.


## Recap

Simple apps will most likely only ever need the `Wyvern.render_view` function.
Defining common layouts is easy even without special support from Wyvern:

```
base_layout = fn layers -> ["layouts/base" | List.wrap(layers)] end
navbar_layout = fn layers -> ["layouts/base", "layouts/navbar" | List.wrap(layers)] end

Wyvern.render_view(base_layout.("some_view"), attrs: ...)
Wyvern.render_view(navbar_layout.("other_view"), attrs: ...)
```

Thanks to caching, the views will be compiled on first rendering and subsequent
calls will be much faster. To ensure fast response for the first request,
simply call the rendering function at your app start:

```
defmodule MyViews do
  def render_index() do
    Wyvern.render_view(navbar_layout.("index"), attrs: ...)
  end
end

...

defmodule MyApp do
  use Application

  def start(_type, _args) do
    # precompile the index view
    MyViews.render_index()

    ...
  end
end
```


Beyond that you can start incorporating `define_layout` along with
`compile_layouts` and `compile_views` if you want to have complete control over
what is compiled and when.
