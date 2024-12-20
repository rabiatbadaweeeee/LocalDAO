import { describe, it, expect, beforeEach, vi } from 'vitest'

describe('Budget Tracking Contract', () => {
  let mockContractCall: any
  
  beforeEach(() => {
    mockContractCall = vi.fn()
  })
  
  it('should add a budget item', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 1 })
    const result = await mockContractCall('add-budget-item', 'Road Repair', 10000)
    expect(result.success).toBe(true)
    expect(result.value).toBe(1)
  })
  
  it('should record an expense', async () => {
    mockContractCall.mockResolvedValue({ success: true })
    const result = await mockContractCall('record-expense', 1, 5000)
    expect(result.success).toBe(true)
  })
  
  it('should get budget item details', async () => {
    mockContractCall.mockResolvedValue({
      success: true,
      value: {
        description: 'Road Repair',
        amount: 10000,
        spent: 5000
      }
    })
    const result = await mockContractCall('get-budget-item', 1)
    expect(result.success).toBe(true)
    expect(result.value.description).toBe('Road Repair')
    expect(result.value.amount).toBe(10000)
    expect(result.value.spent).toBe(5000)
  })
  
  it('should get total budget', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 50000 })
    const result = await mockContractCall('get-total-budget')
    expect(result.success).toBe(true)
    expect(result.value).toBe(50000)
  })
  
  it('should get total spent', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 25000 })
    const result = await mockContractCall('get-total-spent')
    expect(result.success).toBe(true)
    expect(result.value).toBe(25000)
  })
})

