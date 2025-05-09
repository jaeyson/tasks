defmodule Tasks.Model.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:pending, :started, :cancelled, :completed]

    belongs_to :user, Tasks.Accounts.User
    has_many :steps, Tasks.Model.Step

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status, :user_id])
    |> validate_required([:title, :status, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
