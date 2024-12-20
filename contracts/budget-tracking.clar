;; Budget Tracking Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

(define-map budget-items
  uint
  {
    description: (string-utf8 100),
    amount: uint,
    spent: uint
  }
)

(define-data-var budget-item-count uint u0)
(define-data-var total-budget uint u0)
(define-data-var total-spent uint u0)

(define-public (add-budget-item (description (string-utf8 100)) (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (let
      (
        (item-id (+ (var-get budget-item-count) u1))
      )
      (map-set budget-items item-id
        {
          description: description,
          amount: amount,
          spent: u0
        }
      )
      (var-set budget-item-count item-id)
      (var-set total-budget (+ (var-get total-budget) amount))
      (ok item-id)
    )
  )
)

(define-public (record-expense (item-id uint) (amount uint))
  (let
    (
      (item (unwrap! (map-get? budget-items item-id) err-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (<= (+ (get spent item) amount) (get amount item)) err-owner-only)
    (map-set budget-items item-id (merge item { spent: (+ (get spent item) amount) }))
    (var-set total-spent (+ (var-get total-spent) amount))
    (ok true)
  )
)

(define-read-only (get-budget-item (item-id uint))
  (ok (unwrap! (map-get? budget-items item-id) err-not-found))
)

(define-read-only (get-total-budget)
  (ok (var-get total-budget))
)

(define-read-only (get-total-spent)
  (ok (var-get total-spent))
)

