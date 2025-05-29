import React from 'react'

import { useOptimisticMutation } from '@tanstack/react-db'
import { findInCollection, mutationFn, stepCollection } from '../db'

import Status from './Status'

function Step({ step }) {
  const tx = useOptimisticMutation({ mutationFn })

  const toggleCancelled = () => {
    if (step.status === 'completed') {
      return
    }

    const newStatus =
      step.status === 'cancelled'
      ? 'pending'
      : 'cancelled'

    tx.mutate(() => {
      const entry = findInCollection(stepCollection, step)

      stepCollection.update(entry, draft => {
        draft.status = newStatus
      })
    })
  }

  return (
    <div>
      <a onClick={toggleCancelled} className="cursor-pointer">
        {step.status === 'started' && (
          <img src="/images/working.gif" className="inline w-4 mb-1 me-1 align-middle" />
        )}
        {step.name} <Status value={step.status} />
      </a>
    </div>
  )
}

export default Step
