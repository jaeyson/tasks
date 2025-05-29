import type {
  Collection,
  MutationFn,
  PendingMutation,
  Transaction
} from '@tanstack/react-db'

import type { Step, Task } from './schema'

function buildPayload(tx: Transaction) {
  const mutations = tx.mutations.map(
    (mutation: PendingMutation) => {
      const { collection: _, ...rest } = mutation

      return rest
    }
  )

  return { mutations }
}

async function hasSyncedBack(tx: Transaction, txid: number, timeout: number) {
  const collections = new Set(
    tx.mutations
      .map(mutation => mutation.collection)
      .filter(Boolean)
  )

  const promises = [...collections].map(collection => {
    if (typeof collection.awaitTxId === 'function') {
      return collection.awaitTxId(txid, timeout)
    }

    if (typeof collection.refetch === 'function') {
      return collection.refetch()
    }

    throw new Error(`Unknown collection type`, { cause: collection })
  })

  await Promise.all(promises)
}

export const mutationFn: MutationFn = async ({ transaction }) => {
  console.log('mutationFn', transaction)

  const payload = buildPayload(transaction)
  const response = await fetch('/ingest/mutations', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload)
  })

  if (!response.ok) {
    throw new Error(`HTTP Error: ${response.status}`)
  }

  const { txid } = await response.json()
  await hasSyncedBack(transaction, txid)
}
