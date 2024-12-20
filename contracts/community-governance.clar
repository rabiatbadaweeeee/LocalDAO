;; Community Governance Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))

(define-map proposals
  uint
  {
    title: (string-utf8 100),
    description: (string-utf8 500),
    proposer: principal,
    start-block-height: uint,
    end-block-height: uint,
    yes-votes: uint,
    no-votes: uint,
    executed: bool
  }
)

(define-data-var proposal-count uint u0)

(define-public (submit-proposal (title (string-utf8 100)) (description (string-utf8 500)) (voting-period uint))
  (let
    (
      (proposal-id (+ (var-get proposal-count) u1))
      (start-block block-height)
      (end-block (+ start-block voting-period))
    )
    (map-set proposals proposal-id
      {
        title: title,
        description: description,
        proposer: tx-sender,
        start-block-height: start-block,
        end-block-height: end-block,
        yes-votes: u0,
        no-votes: u0,
        executed: false
      }
    )
    (var-set proposal-count proposal-id)
    (ok proposal-id)
  )
)

(define-public (vote (proposal-id uint) (vote-for bool))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) err-not-found))
      (voter-balance (unwrap! (contract-call? .community-token get-balance tx-sender) err-not-found))
    )
    (asserts! (>= block-height (get start-block-height proposal)) err-unauthorized)
    (asserts! (<= block-height (get end-block-height proposal)) err-unauthorized)
    (if vote-for
      (map-set proposals proposal-id (merge proposal { yes-votes: (+ (get yes-votes proposal) voter-balance) }))
      (map-set proposals proposal-id (merge proposal { no-votes: (+ (get no-votes proposal) voter-balance) }))
    )
    (ok true)
  )
)

(define-public (execute-proposal (proposal-id uint))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) err-not-found))
    )
    (asserts! (> block-height (get end-block-height proposal)) err-unauthorized)
    (asserts! (not (get executed proposal)) err-unauthorized)
    (asserts! (> (get yes-votes proposal) (get no-votes proposal)) err-unauthorized)
    (map-set proposals proposal-id (merge proposal { executed: true }))
    ;; Here you would typically call a function to implement the proposal
    ;; For this example, we'll just return success
    (ok true)
  )
)

(define-read-only (get-proposal (proposal-id uint))
  (ok (unwrap! (map-get? proposals proposal-id) err-not-found))
)

