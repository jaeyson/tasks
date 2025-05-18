import { z } from 'zod'

const status = z.enum(['pending', 'started', 'cancelled', 'completed'])
const timestamps = {
  inserted_at: z.date(),
  updated_at: z.date()
}

export const taskSchema = z.object({
  id: z.string().uuid(),

  title: z.string(),
  description: z.string().nullable(),
  status: status,

  user_id: z.string().uuid(),

  ...timestamps
})
export type Task = z.infer<typeof taskSchema>

export const stepSchema = z.object({
  id: z.string().uuid(),

  name: z.string(),
  status: status,

  previous_step_id: z.string().uuid().nullable(),
  task_id: z.string().uuid(),

  ...timestamps
})
export type Step = z.infer<typeof stepSchema>
