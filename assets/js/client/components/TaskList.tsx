import React from 'react'

import { useLiveQuery, useOptimisticMutation } from '@tanstack/react-db'
import { findInCollection, mutationFn, taskCollection } from '../db'

import Task from './Task'

function TaskList() {
  const { data } = useLiveQuery(query => (
    query
      .from({ taskCollection })
      .select('@id', '@title', '@inserted_at')
      .orderBy({'@inserted_at': 'asc'})
      .keyBy('@id')
  ))

  // XXX `{'@inserted_at': 'asc'}` was working
  // but now appears not to be.
  tasks = data.toReversed()

  console.log('tasks', tasks, taskCollection)

  const deleteTask = useOptimisticMutation({ mutationFn })

  const handleDelete = (task) => {
    deleteTask.mutate(() => {
      const entry = findInCollection(taskCollection, task)

      taskCollection.delete(entry)
    })
  }

  return (
    <div className="mx-2 my-6 px-8">
      <div className="max-w-screen-md mx-auto">
        {tasks.map((task) => <Task key={`task-${task.id}`} task={task} />)}
      </div>
    </div>
  )
}

export default TaskList
