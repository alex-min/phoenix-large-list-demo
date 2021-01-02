defmodule LargeListDemo.Repo do
  use Ecto.Repo,
    otp_app: :large_list_demo,
    adapter: Ecto.Adapters.Postgres
end
