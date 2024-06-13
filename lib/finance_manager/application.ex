defmodule FinanceManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FinanceManagerWeb.Telemetry,
      FinanceManager.Repo,
      {DNSCluster, query: Application.get_env(:finance_manager, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FinanceManager.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FinanceManager.Finch},
      # Start a worker by calling: FinanceManager.Worker.start_link(arg)
      # {FinanceManager.Worker, arg},
      # Start to serve requests, typically the last entry
      FinanceManagerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FinanceManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FinanceManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
