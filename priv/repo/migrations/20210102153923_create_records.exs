defmodule LargeListDemo.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do
      add :name, :string
      add :value, :integer

      timestamps()
    end

  end
end
