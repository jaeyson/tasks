import { createElectricCollection } from '@tanstack/db-collections'

import { stepSchema, taskSchema } from './schema'
import type { Step, Task } from './schema'

const relativeUrl = (path) => (
  `${window.location.origin}${path}`
)

const parser = {
  timestamp: (date: string) => {
    console.log(date, new Date(date))

    return new Date(date)
  }
}

export const stepCollection = createElectricCollection<Step>({
  streamOptions: {
    url: relativeUrl('/sync/steps'),
    params: {
      table: 'steps'
    },
    parser
  },
  primaryKey: ['id'],
  schema: stepSchema
})

export const taskCollection = createElectricCollection<Task>({
  streamOptions: {
    url: relativeUrl('/sync/tasks'),
    params: {
      table: 'tasks'
    },
    parser
  },
  primaryKey: ['id'],
  schema: taskSchema
})

window.taskCollection = taskCollection