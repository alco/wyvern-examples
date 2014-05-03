defmodule Prerender.Index do
  use Wyvern.View, [
    layers: [{:inline, "Hello I am index"}]
  ]
end
