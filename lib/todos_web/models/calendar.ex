defmodule TodosWeb.Calendar do
    use TodosWeb, :model
    schema "calendars" do
        field :day, :integer
        field :month, :integer
        field :year, :integer
        field :status, :string
        timestamps()
    end
    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:day, :month, :year, :status])
        |> validate_required([:day, :month, :year, :status])
    end
end