import { Collection, createElectricSync } from '@tanstack/react-optimistic'

import { stepSchema, taskSchema } from './schema'
import type { Step, Task } from './schema'

const relativeUrl = (path) => (
  `${window.location.origin}${path}`
)

const parser = {
  timestamptz: (date: string) => new Date(date)
}
const syncOpts = {
  primaryKey: ['id']
}

const tasksUrl = relativeUrl('/sync/tasks')

export const taskCollection = new Collection<Task>({
  id: 'tasks',
  sync: createElectricSync({ url: tasksUrl, parser}, syncOpts),
  schema: taskSchema
})

// const stepsUrl = relativeUrl('/sync/steps')

// export const stepCollection = new Collection<Step>({
//   id: 'tasks',
//   sync: createElectricSync({ url: stepsUrl, parser}, syncOpts),
//   schema: stepSchema
// })
