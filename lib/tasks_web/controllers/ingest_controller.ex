defmodule TasksWeb.IngestController do
  use TasksWeb, :controller

  alias Tasks.Model
  alias Tasks.Repo
  alias Tasks.Worker

  alias Phoenix.Sync.Writer
  alias Phoenix.Sync.Writer.Format

  def create(%{assigns: %{current_user: user}} = conn, %{"mutations" => mutations}) do
    {:ok, txid, _changes} =
      Writer.new()
      |> Writer.allow(
        Model.Step,
        load: &Model.load_step(user, &1),
        update: [
          post_apply: &Worker.process_step/3
        ]
      )
      |> Writer.allow(
        Model.Task,
        load: &Model.load_task(user, &1),
        validate: &Model.ingest_task_changeset(user, &1, &2, &3),
        insert: [
          post_apply: &Worker.process_task/3
        ]
      )
      |> Writer.apply(mutations, Repo, format: Format.TanstackDB)

    json(conn, %{txid: txid})
  end
end
