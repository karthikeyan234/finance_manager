defmodule FinanceManager.Repo do
  use Ecto.Repo,
    otp_app: :finance_manager,
    adapter: Ecto.Adapters.Postgres
end
