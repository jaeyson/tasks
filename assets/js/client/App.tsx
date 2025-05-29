import React from 'react'
import { AddTask, Header, TaskList } from './components'

export default function App() {
  return (
    <main>
      <Header />
      <AddTask />
      <TaskList />
    </main>
  )
}
