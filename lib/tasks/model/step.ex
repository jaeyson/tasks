defmodule Tasks.Model.Step do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "steps" do
    field :name, :string
    field :status, Ecto.Enum, values: [:pending, :started, :cancelled, :completed]

    belongs_to :task, Tasks.Model.Task

    belongs_to :previous_step, Tasks.Model.Step
    has_one :next_step, Tasks.Model.Step

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(step, attrs) do
    step
    |> cast(attrs, [:name, :status, :previous_step_id, :task_id])
    |> validate_required([:name, :status, :task_id])
    |> foreign_key_constraint(:previous_step_id)
    |> foreign_key_constraint(:task_id)
  end
end
