import React from 'react'

function Status({ size, value }) {
  let colorClasses
  switch (value) {
    case 'started':
    case 'in-progress':
      colorClasses = 'bg-cyan-50 text-cyan-700 ring-cyan-700/10'
      break
    case 'cancelled':
      colorClasses = 'bg-red-50 text-red-700 ring-red-600/10'
      break
    case 'completed':
      colorClasses = 'bg-green-50 text-green-700 ring-green-600/20'
      break
    default:
      colorClasses = 'bg-gray-50 text-gray-600 ring-gray-500/10'
  }

  const sizeClasses = size === 'lg' ? 'text-sm px-4 py-2 rounded-lg' : 'text-xs px-2 py-1 rounded-md'

  return (
    <span className={`${colorClasses} ${sizeClasses} align-top inline-flex items-center font-medium ring-1 ring-inset`}>
      {value}
    </span>
  )
}

export default Status
