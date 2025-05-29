defmodule Tasks.Worker do
  use Oban.Worker, queue: :default, max_attempts: 3, unique: [
    states: [:scheduled]
  ]

  alias Ecto.Changeset
  alias Ecto.Multi

  alias Phoenix.Sync.Writer

  alias Tasks.Model
  alias Tasks.Repo

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"task_id" => task_id} = _args}) do
    {:ok, _changes} =
      case Model.get_next_step(task_id) do
        %Model.Step{status: status, id: step_id} = step ->
          {next_status, schedule_in_secs} =
            case status do
              :pending -> {:started, Enum.random(5..15)}
              :started -> {:completed, 0}
            end

          Multi.new()
          |> Multi.update(:step, Model.change_step(step, %{status: next_status}))
          |> process_task(task_id, "#{step_id}-#{next_status}", schedule_in_secs)
          |> Repo.transaction()

        _alt ->
          {:ok, %{}}
      end

    :ok
  end

  def process_task(%Multi{} = multi, %Changeset{} = changeset, %Writer.Context{} = context) do
    IO.inspect({:changeset, changeset})

    name = Writer.operation_name(context, :enque)
    task_id = Changeset.fetch_change!(changeset, :id)

    process_task(multi, task_id, name, 0)
  end

  def process_task(%Multi{} = multi, task_id, name \\ "job", schedule_in_secs \\ 2) do
    job = Tasks.Worker.new(%{task_id: task_id}, schedule_in: schedule_in_secs)

    Oban.insert(multi, name, job)
  end

  def process_step(
        %Multi{} = multi,
        %Changeset{changes: %{status: :pending}, data: %Model.Step{status: :cancelled, task_id: task_id}},
        %Writer.Context{} = context
      ) do
    name = Writer.operation_name(context, :enque)
    process_task(multi, task_id, name, 0)
  end

  def process_step(%Multi{} = multi, _changeset, _context) do
    multi
  end
end
