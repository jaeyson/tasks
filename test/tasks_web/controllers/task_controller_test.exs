defmodule TasksWeb.TaskControllerTest do
  use TasksWeb.ConnCase

  import Tasks.AccountsFixtures
  # import Tasks.ModelFixtures

  setup do
    %{user: user_fixture()}
  end

  test "GET /sync/tasks", %{conn: conn} do
    conn = get(conn, ~p"/sync/tasks?offset=-1")

    assert response(conn, 401)
  end

  test "GET /sync/tasks logged in", %{conn: conn, user: user} do
    conn =
      conn
      |> log_in_user(user)
      |> get(~p"/sync/tasks?offset=-1")

    assert body = json_response(conn, 200)
    assert body == []
  end

  # test "GET /sync/tasks with content", %{conn: conn, user: user} do
  #   _ = task_fixture(user)
  #
  #   Process.sleep(1000)
  #
  #   conn =
  #     conn
  #     |> log_in_user(user)
  #     |> get(~p"/sync/tasks?offset=-1")
  #
  #   assert body = json_response(conn, 200)
  #   assert Enum.count(body) > 0
  # end
end
