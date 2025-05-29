defmodule Tasks.Model do
  @moduledoc """
  The Model context.
  """

  import Ecto.Query, warn: false
  alias Tasks.Repo

  alias Tasks.Accounts
  alias Tasks.Model.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Loads a task by user and params. As long as the task belongs to the user.

      iex> load_task(user, %{"id" => 1234})
      %Task{}

      iex> load_task(wrong_user, %{"id" => 1234})
      nil

  Returns the struct or nil.
  """
  def load_task(%Accounts.User{id: user_id}, %{"id" => id}) do
    Repo.one(from t in Task, where: t.id == ^id and t.user_id == ^user_id)
  end

  def current_task_ids(%Accounts.User{id: user_id}) do
    IO.inspect(:current_task_ids)

    Repo.all(
      from t in Task,
        select: t.id,
        where: t.user_id == ^user_id
    )
    |> IO.inspect()
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def ingest_task_changeset(%Accounts.User{id: user_id}, %Task{} = task, attrs, :insert) do
    IO.inspect({:ingest_task_changeset, 111, task, attrs})

    attrs = Map.put(attrs, "user_id", user_id)

    Task.changeset(task, attrs)
  end

  def ingest_task_changeset(_user, %Task{} = task, attrs, _operation) do
    IO.inspect({:ingest_task_changeset, 222, task, attrs})

    Task.changeset(task, attrs)
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  alias Tasks.Model.Step

  @doc """
  Returns the list of steps.

  ## Examples

      iex> list_steps()
      [%Step{}, ...]

  """
  def list_steps do
    Repo.all(Step)
  end

  @doc """
  Gets a single step.

  Raises `Ecto.NoResultsError` if the Step does not exist.

  ## Examples

      iex> get_step!(123)
      %Step{}

      iex> get_step!(456)
      ** (Ecto.NoResultsError)

  """
  def get_step!(id), do: Repo.get!(Step, id)

  @doc """
  Loads a step by user and params, as long as the step belongs to
  a task which belongs to the user.

      iex> load_step(user, %{"id" => 1234})
      %Step{}

      iex> load_step(wrong_user, %{"id" => 1234})
      nil

  Returns the struct or nil.
  """
  def load_step(%Accounts.User{id: user_id}, %{"id" => id}) do
    Repo.one(
      from s in Step,
        join: t in Task,
        on: t.id == s.task_id,
        where: s.id == ^id and t.user_id == ^user_id
    )
  end

  # Get the first two non-completed steps
  def get_next_step(task_id) when is_binary(task_id) do
    Repo.one(
      from s in Step,
        where:
          s.task_id == ^task_id and
            (s.status == :pending or s.status == :started),
        order_by: s.order,
        limit: 1
    )
  end

  @doc """
  Creates a step.

  ## Examples

      iex> create_step(%{field: value})
      {:ok, %Step{}}

      iex> create_step(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_step(attrs \\ %{}) do
    %Step{}
    |> Step.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a step.

  ## Examples

      iex> update_step(step, %{field: new_value})
      {:ok, %Step{}}

      iex> update_step(step, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_step(%Step{} = step, attrs) do
    step
    |> Step.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a step.

  ## Examples

      iex> delete_step(step)
      {:ok, %Step{}}

      iex> delete_step(step)
      {:error, %Ecto.Changeset{}}

  """
  def delete_step(%Step{} = step) do
    Repo.delete(step)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking step changes.

  ## Examples

      iex> change_step(step)
      %Ecto.Changeset{data: %Step{}}

  """
  def change_step(%Step{} = step, attrs \\ %{}) do
    Step.changeset(step, attrs)
  end
end
