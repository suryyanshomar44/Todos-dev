defmodule Todos.Repo.Migrations.Calendaraddcolor do
  use Ecto.Migration

  def change do
    create table(:calendars) do
      add :day, :integer
      add :month, :integer
      add :year, :integer
      add :status, :string
      timestamps()
    end

  end
end
