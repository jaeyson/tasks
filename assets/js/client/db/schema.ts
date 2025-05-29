import { z } from 'zod'

const idSchema = z.object({id: z.string().uuid()})
type Identifiable = z.infer<typeof idSchema>

const status = z.enum(['pending', 'started', 'cancelled', 'completed'])
const timestamps = {
  inserted_at: z.date().optional(),
  updated_at: z.date().optional()
}

export const stepSchema = z.object({
  id: z.string().uuid(),

  name: z.string(),
  order: z.number().int(),
  status: status,

  task_id: z.string().uuid(),

  ...timestamps
})

export const taskSchema = z.object({
  id: z.string().uuid(),

  title: z.string(),
  description: z.string().nullable().optional(),

  user_id: z.string().uuid().optional(),

  ...timestamps
})

export type Task = z.infer<typeof taskSchema>
export type PartialTask = Partial<PartialTask> & Identifiable

export type Step = z.infer<typeof stepSchema>
export type PartialStep = Partial<Step> & Identifiable

export type Model =
  Task |
  Step

export type PartialModel =
  PartialTask |
  PartialStep
