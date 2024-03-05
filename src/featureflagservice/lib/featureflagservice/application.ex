defmodule Featureflagservice.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    OpentelemetryEcto.setup([:featureflagservice, :repo])
    OpentelemetryPhoenix.setup()

    children = [
      # Start the Ecto repository
      Featureflagservice.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Featureflagservice.PubSub},
      # Start the Endpoint (http/https)
      FeatureflagserviceWeb.Endpoint,
      Featureflagservice.Scheduler
      # Start a worker by calling: Featureflagservice.Worker.start_link(arg)
      # {Featureflagservice.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Featureflagservice.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    FeatureflagserviceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
