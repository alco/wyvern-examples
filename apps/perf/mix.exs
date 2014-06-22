defmodule Perf.Mixfile do
  use Mix.Project

  def project do
    [app: :perf,
     version: "0.0.1",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 0.14.0",
     deps: deps]
  end

  def application do
    [applications: [:wyvern],
     mod: {Perf, []}]
  end

  defp deps do
    [{:wyvern, github: "alco/wyvern"}]
  end
end
