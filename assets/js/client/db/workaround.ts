import { type Collection } from '@tanstack/db'
import { type PartialModel } from './schema'

// Temporary workaround for
// https://github.com/TanStack/db/issues/54
export function findInCollection(collection: Collection, candidate: PartialModel): PartialModel {
  const entries = Array.from(collection.state.values())
  const model = entries.find(entry => entry.id === candidate.id)

  if (model === undefined) {
    const cause = {
      candidate,
      collection
    }

    throw new Error(`${candidate.id} is not in collection`, { cause })
  }

  return model
}

