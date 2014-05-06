defmodule Basic.Mixfile do
  use Mix.Project

  def project do
    [app: :basic,
     version: "0.0.1",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 0.13.1",
     deps: deps]
  end

  def application do
    [applications: [:wyvern]]
  end

  defp deps do
    [{:wyvern, github: "alco/wyvern"}]
  end
end
