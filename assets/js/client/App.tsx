import React from 'react'
// import type { FormEvent } from 'react'

// import { createTransaction, useLiveQuery } from '@tanstack/react-optimistic'
import { useLiveQuery } from '@tanstack/react-optimistic'

import { taskCollection } from './db'

export default function App() {
  const { data: tasks } = useLiveQuery((query) => (
    query
      .from({ taskCollection })
      .keyBy(`@id`)
      .select(`@id`, `@title`, `@description`, '@status')
  ))

  return (
    <main>
      <h3 className="bg-zinc-200 px-8 py-6 text-xl">
        🤖 Tasks
      </h3>
      <ul className="mx-2 my-6">
        {tasks.map((task) => (
          <li key={`task-${task.id}`} className="bg-zinc-100 rounded-lg m-4 p-6">
            {task.title}
          </li>
        ))}
      </ul>
    </main>
  )
}
