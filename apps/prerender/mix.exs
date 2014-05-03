defmodule Prerender.Mixfile do
  use Mix.Project

  def project do
    [app: :prerender,
     version: "0.0.1",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 0.13.1",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  #def application do
  #  [ applications: [],
  #    mod: {Prerender, []} ]
  #end

  defp deps do
    [{:wyvern, github: "alco/wyvern"}]
  end
end
