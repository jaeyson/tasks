import uuid4 from 'uuid4'
import React, { useState } from 'react'
import { useOptimisticMutation } from '@tanstack/react-db'
import { mutationFn, stepCollection, taskCollection } from '../db'

function AddTask() {
  const [ open, setOpen ] = useState(false)
  const [ steps, setSteps ] = useState([uuid4(), uuid4(), uuid4()])

  const addTask = useOptimisticMutation({ mutationFn })

  const handleForm = (formData) => {
    const title = formData.get('title')
    const steps = formData.getAll('steps')

    addTask.mutate(() => {
      const taskId = uuid4()

      taskCollection.insert({
        id: taskId,
        title: title,
        status: 'pending'
      })

      steps.forEach(
        (name, index) => {
          const stepId = uuid4()
          const order = 100 * (index + 1)

          stepCollection.insert({
            id: stepId,
            name: name,
            order: order,
            status: 'pending',
            task_id: taskId
          })

          return stepId
        },
        null
      )
    })

    setOpen(false)
  }

  return (
    <div className="px-8 my-8">
      {open
        ? (
          <form className="m-auto max-w-screen-md border p-6 bg-zinc-200 rounded-lg"
              action={handleForm}>
            <button className="float-right" onClick={() => setOpen(false) }>
              ✕
            </button>
            <h3 className="text-lg pb-2 border-zinc-400 border-b">
              Add task
            </h3>
            <div className="mt-4 mb-3">
              <label htmlFor="title"
                  className="block text-sm font-semibold leading-6 text-zinc-800">
                Title
              </label>
              <input type="text"
                  name="title"
                  placeholder="Dispatch robot"
                  className="mt-1 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 border-zinc-300 focus:border-zinc-400"
                  required
              />
            </div>
            <div className="my-3">
              <label htmlFor="title"
                  className="block text-sm font-semibold leading-6 text-zinc-800">
                Steps
              </label>
              {steps.map((step, index) => (
                <div className="flex" key={ step }>
                  <input type="text"
                      name="steps"
                      placeholder={
                        index === 0 ? 'Plan' : (
                          index === 1 ? 'Execute' : (
                            index === 2 ? 'Review' : ''
                          )
                        )
                      }
                      className="w-11/12 mt-2 block rounded-md text-zinc-900 focus:ring-0 text-sm sm:leading-4 border-zinc-300 focus:border-zinc-400"
                      required
                  />
                  {index > 1 && (
                    <button className="w-1/12 rounded text-right bg-zinc-200 py-2 text-sm leading-4"
                        onClick={() => setSteps((steps) => [...steps.filter((s) => s != step)])}>
                      (-)</button>
                  )}
                </div>
              ))}
              <button className="rounded bg-zinc-200 mt-1 py-2 px-3 text-sm leading-4"
                  onClick={() => setSteps((steps) => [...steps, uuid4()]) }>
                + Add step
              </button>
            </div>
            <div className="mt-4 mb-3">
              <button type="submit"
                  className="rounded-lg bg-zinc-800 py-2 px-3 text-sm text-white leading-6 w-full">
                Create task
              </button>
            </div>
          </form>
        )
        : (
          <div className="max-w-screen-md mx-auto">
            <button className="rounded-lg bg-zinc-700 py-3 px-3 text-white leading-6 w-full"
                onClick={() => setOpen(true) }>
              + Add task
            </button>
          </div>
        )
      }
    </div>
  )
}

export default AddTask