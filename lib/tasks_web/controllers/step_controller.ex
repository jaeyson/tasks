defmodule TasksWeb.StepController do
  use TasksWeb, :controller
  import Ecto.Query

  alias Tasks.Model

  @doc """
  Sync all the steps that belong to tasks that belong to the current user.

  This will change the shape definition when the user adds or removes a task,
  causing a re-sync of all steps.
  """
  def show(%{assigns: %{current_user: user}} = conn, params) do
    query =
      Model.Step
      |> where([s], false)

    query =
      user
      |> Model.current_task_ids()
      |> Enum.reduce(query, &or_where_task_id/2)

    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json")
    |> Phoenix.Sync.Controller.sync_render(params, query)
  end

  defp or_where_task_id(task_id, query) do
    query
    |> or_where([s], s.task_id == ^task_id)
  end
end
