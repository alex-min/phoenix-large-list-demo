defmodule LargeListDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LargeListDemo.Repo,
      # Start the Telemetry supervisor
      LargeListDemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LargeListDemo.PubSub},
      # Start the Endpoint (http/https)
      LargeListDemoWeb.Endpoint
      # Start a worker by calling: LargeListDemo.Worker.start_link(arg)
      # {LargeListDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LargeListDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LargeListDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
