defmodule Todos.Repo.Migrations.AddUserIdToTask do
  use Ecto.Migration

  def change do
    alter table(:task) do
      add :user_id, references(:user)
    end
  end
end
