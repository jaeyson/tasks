defmodule Tasks.ModelTest do
  use Tasks.DataCase

  alias Tasks.Model

  import Tasks.AccountsFixtures
  import Tasks.ModelFixtures

  describe "tasks" do
    alias Tasks.Model.Task

    @invalid_attrs %{status: nil, description: nil, title: nil}

    setup do
      %{user: user_fixture()}
    end

    test "list_tasks/0 returns all tasks", %{user: user} do
      task = task_fixture(user)
      assert Model.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id", %{user: user} do
      task = task_fixture(user)
      assert Model.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task", %{user: user} do
      valid_attrs = %{
        status: :pending,
        description: "some description",
        title: "some title",
        user_id: user.id
      }

      assert {:ok, %Task{} = task} = Model.create_task(valid_attrs)
      assert task.status == :pending
      assert task.description == "some description"
      assert task.title == "some title"
      assert task.user_id == user.id
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task", %{user: user} do
      task = task_fixture(user)
      update_attrs = %{status: :started, description: "some updated description", title: "some updated title"}

      assert {:ok, %Task{} = task} = Model.update_task(task, update_attrs)
      assert task.status == :started
      assert task.description == "some updated description"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset", %{user: user} do
      task = task_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Model.update_task(task, @invalid_attrs)
      assert task == Model.get_task!(task.id)
    end

    test "delete_task/1 deletes the task", %{user: user} do
      task = task_fixture(user)
      assert {:ok, %Task{}} = Model.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Model.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset", %{user: user} do
      task = task_fixture(user)
      assert %Ecto.Changeset{} = Model.change_task(task)
    end
  end

  describe "steps" do
    alias Tasks.Model.Step

    @invalid_attrs %{name: nil, status: nil}

    setup do
      %{task: task_fixture(user_fixture())}
    end

    test "list_steps/0 returns all steps", %{task: task} do
      step = step_fixture(task)
      assert Model.list_steps() == [step]
    end

    test "get_step!/1 returns the step with given id", %{task: task} do
      step = step_fixture(task)
      assert Model.get_step!(step.id) == step
    end

    test "create_step/1 with valid data creates a step", %{task: task} do
      valid_attrs = %{
        name: "some name",
        status: :pending,
        task_id: task.id
      }

      assert {:ok, %Step{} = step} = Model.create_step(valid_attrs)
      assert step.name == "some name"
      assert step.status == :pending
      assert step.task_id == task.id
    end

    test "create_step/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_step(@invalid_attrs)
    end

    test "update_step/2 with valid data updates the step", %{task: task} do
      step = step_fixture(task)
      update_attrs = %{name: "some updated name", status: :started}

      assert {:ok, %Step{} = step} = Model.update_step(step, update_attrs)
      assert step.name == "some updated name"
      assert step.status == :started
    end

    test "update_step/2 with invalid data returns error changeset", %{task: task} do
      step = step_fixture(task)
      assert {:error, %Ecto.Changeset{}} = Model.update_step(step, @invalid_attrs)
      assert step == Model.get_step!(step.id)
    end

    test "delete_step/1 deletes the step", %{task: task} do
      step = step_fixture(task)
      assert {:ok, %Step{}} = Model.delete_step(step)
      assert_raise Ecto.NoResultsError, fn -> Model.get_step!(step.id) end
    end

    test "change_step/1 returns a step changeset", %{task: task} do
      step = step_fixture(task)
      assert %Ecto.Changeset{} = Model.change_step(step)
    end
  end
end
