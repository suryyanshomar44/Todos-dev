defmodule TodosWeb.Task do
    use TodosWeb, :model
    schema "task" do
        field :subject, :string
        field :done, :integer, default: 0
        belongs_to :user, TodosWeb.User
        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:subject, :done])
        |> validate_required([:subject, :done])
    end
end