defmodule TasksWeb.TaskController do
  use TasksWeb, :controller
  import Ecto.Query, only: [from: 2]

  alias Tasks.Model.Task

  @doc """
  Sync a user's tasks.
  """
  def show(%{assigns: %{current_user: %{id: user_id}}} = conn, params) do
    query = from(t in Task, where: t.user_id == ^user_id)

    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json")
    |> Phoenix.Sync.Controller.sync_render(params, query)
  end
end
