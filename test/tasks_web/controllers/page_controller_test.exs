defmodule TasksWeb.PageControllerTest do
  use TasksWeb.ConnCase

  import Tasks.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")

    assert redirected_to(conn) == ~p"/users/log_in"
  end

  test "GET / logged in", %{conn: conn, user: user} do
    conn = conn |> log_in_user(user) |> get(~p"/")

    assert html_response(conn, 200) =~ "<div id=\"app\"></div>"
  end
end
