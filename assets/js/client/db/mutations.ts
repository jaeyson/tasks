import type {
  Collection,
  MutationFn,
  PendingMutation
} from '@tanstack/react-optimistic'

import type { Step, Task } from './schema'

export const ingestMutations: MutationFn = async ({ transaction }) => {
  const payload = transaction.mutations.map(
    (mutation: PendingMutation<Task|Step>) => {
      const { collection: _, ...rest } = mutation

      return rest
    }
  )

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

  const result = await response.json()

  const collection: Collection = transaction.mutations[0]!.collection
  await collection.config.sync.awaitTxid(result.txid)
}
