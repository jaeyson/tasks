defmodule Tasks.Model.Step do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "steps" do
    field :name, :string
    field :order, :integer
    field :status, Ecto.Enum, values: [:pending, :started, :cancelled, :completed]

    belongs_to :task, Tasks.Model.Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(step, attrs) do
    step
    |> cast(attrs, [:id, :name, :order, :status, :task_id])
    |> validate_required([:name, :order, :status, :task_id])
    |> foreign_key_constraint(:task_id)
  end
end
