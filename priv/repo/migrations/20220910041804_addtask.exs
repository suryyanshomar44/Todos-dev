defmodule Todos.Repo.Migrations.Addtask do
  use Ecto.Migration

  def change do
    create table(:task) do
      add :subject, :string

      timestamps()
    end
  end
end
