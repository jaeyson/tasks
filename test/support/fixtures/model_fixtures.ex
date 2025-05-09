defmodule Tasks.ModelFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tasks.Model` context.
  """

  alias Tasks.Accounts
  alias Tasks.Model

  @doc """
  Generate a task.
  """
  def task_fixture(%Accounts.User{id: user_id}, attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        status: :pending,
        title: "some title"
      })
      |> Map.put(:user_id, user_id)
      |> Model.create_task()

    task
  end

  @doc """
  Generate a step.
  """
  def step_fixture(%Model.Task{id: task_id}, attrs \\ %{}) do
    {:ok, step} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: :pending,
      })
      |> Map.put(:task_id, task_id)
      |> Model.create_step()

    step
  end
end
