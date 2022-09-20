defmodule Todos.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Todos.Repo,
      # Start the Telemetry supervisor
      TodosWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Todos.PubSub},
      # Start the Endpoint (http/https)
      TodosWeb.Endpoint
      # Start a worker by calling: Todos.Worker.start_link(arg)
      # {Todos.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Todos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TodosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
