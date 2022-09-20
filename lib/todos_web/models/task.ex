defmodule TodosWeb.Task do
    use TodosWeb, :model
    schema "task" do
        field :subject, :string
        belongs_to :user, TodosWeb.User
        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:subject])
        |> validate_required([:subject])
    end
end