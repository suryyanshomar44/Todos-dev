defmodule TodosWeb.User do
    use TodosWeb, :model
    schema "user" do
        field :email, :string
        field :provider, :string
        field :token, :string
        has_many :task, TodosWeb.Task

        timestamps()

    end
    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:email, :provider, :token])
        |> validate_required([:email, :provider, :token])
    end
end