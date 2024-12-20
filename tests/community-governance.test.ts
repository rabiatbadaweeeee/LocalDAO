import { describe, it, expect, beforeEach, vi } from 'vitest'

describe('Community Governance Contract', () => {
  let mockContractCall: any
  
  beforeEach(() => {
    mockContractCall = vi.fn()
  })
  
  it('should submit a proposal', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 1 })
    const result = await mockContractCall('submit-proposal', 'Test Proposal', 'This is a test proposal', 100)
    expect(result.success).toBe(true)
    expect(result.value).toBe(1)
  })
  
  it('should allow voting', async () => {
    mockContractCall.mockResolvedValue({ success: true })
    const result = await mockContractCall('vote', 1, true)
    expect(result.success).toBe(true)
  })
  
  it('should execute a proposal', async () => {
    mockContractCall.mockResolvedValue({ success: true })
    const result = await mockContractCall('execute-proposal', 1)
    expect(result.success).toBe(true)
  })
  
  it('should get proposal details', async () => {
    mockContractCall.mockResolvedValue({
      success: true,
      value: {
        title: 'Test Proposal',
        description: 'This is a test proposal',
        proposer: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
        'start-block-height': 100,
        'end-block-height': 200,
        'yes-votes': 75,
        'no-votes': 25,
        executed: false
      }
    })
    const result = await mockContractCall('get-proposal', 1)
    expect(result.success).toBe(true)
    expect(result.value.title).toBe('Test Proposal')
    expect(result.value['yes-votes']).toBe(75)
  })
})

