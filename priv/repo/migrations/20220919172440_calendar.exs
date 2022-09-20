defmodule Todos.Repo.Migrations.Calendar do
  use Ecto.Migration

  def change do
    create table(:calendar) do
      add :date, :utc_datetime
      add :status, :string
      timestamps()
    end
  end
end
