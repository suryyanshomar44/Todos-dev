defmodule Todos.Repo.Migrations.Addtask do
  use Ecto.Migration

  def change do
    create table(:task) do
      add :subject, :string
      add :done, :integer, default: 0

      timestamps()
    end
  end
end
