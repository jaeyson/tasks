defmodule Tasks.Repo.Migrations.CreateSteps do
  use Ecto.Migration

  def change do
    create table(:steps, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :status, :string, null: false
      add :previous_step_id, references(:steps, on_delete: :nilify_all, type: :binary_id)
      add :task_id, references(:tasks, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:steps, [:previous_step_id])
    create index(:steps, [:task_id])
  end
end
