import React from 'react'

import { useLiveQuery, useOptimisticMutation } from '@tanstack/react-db'
import { findInCollection, mutationFn, stepCollection, taskCollection } from '../db'
import { type PartialStep } from '../db'

import Status from './Status'
import Step from './Step'

function getTaskStatus(statuses) {
  const firstNonCompleted = statuses.findIndex(status => status !== 'completed')
  if (firstNonCompleted === -1) {
    return 'completed'
  }

  const firstCancelled = statuses.findIndex(status => status === 'cancelled')
  const beforeCancelled = firstCancelled === -1 ? statuses : statuses.slice(0, firstCancelled)

  if (beforeCancelled.includes('started')) {
    return 'in-progress'
  }
  else if (beforeCancelled.includes('completed') && beforeCancelled.includes('pending')) {
    return 'in-progress'
  }
  else if (beforeCancelled.includes('pending')) {
    return 'pending'
  }
  else if (firstCancelled !== -1) {
    return 'cancelled'
  }

  return 'pending'
}

function Task({ task }) {
  const { data: steps } = useLiveQuery((query) => (
    query
      .from({ stepCollection })
      .select('@id', '@name', '@order', '@status')
      .where('@task_id', '=', task.id)
      .orderBy({'@order': 'asc'})
      .keyBy('@id')
  ))

  const taskStatus = getTaskStatus(steps.map(step => step.status))

  const deleteTask = useOptimisticMutation({ mutationFn })
  const handleDelete = (task) => {
    deleteTask.mutate(() => {
      const entry = findInCollection(taskCollection, task)

      taskCollection.delete(entry)
    })
  }

  return (
    <div key={`task-${task.id}`} className="bg-zinc-200 rounded-lg my-4 p-6">
      <button className="float-right text-sm" onClick={() => handleDelete(task) }>
        ✕
      </button>
      <p className="pb-2 border-b border-zinc-300">
        {task.title} <Status value={taskStatus} />
      </p>
      <div className="flex flex-row mt-3">
        {steps.map(step => (
          <div key={`step-${step.id}`} className="grow">
            <Step step={step} />
          </div>
        ))}
      </div>
    </div>
  )
}

export default Task
