defmodule BooksApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BooksApiWeb.Telemetry,
      BooksApi.Repo,
      {DNSCluster, query: Application.get_env(:books_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BooksApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BooksApi.Finch},
      # Start a worker by calling: BooksApi.Worker.start_link(arg)
      # {BooksApi.Worker, arg},
      # Start to serve requests, typically the last entry
      BooksApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BooksApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BooksApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
