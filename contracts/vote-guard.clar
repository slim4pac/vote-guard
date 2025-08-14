(define-data-var proposal-count uint u0)

(define-map proposals
  { id: uint }
  {
    creator: principal,
    title: (string-ascii 100),
    description: (string-ascii 200),
    deadline: uint,
    yes-votes: uint,
    no-votes: uint
  }
)

(define-map has-voted
  { proposal-id: uint, voter: principal }
  bool
)

(define-public (create-proposal (title (string-ascii 100)) (description (string-ascii 200)) (duration uint))
  (let (
    (sender tx-sender)
    (id (+ (var-get proposal-count) u1))
    (deadline (+ stacks-block-height duration))
  )
    (begin
      (map-set proposals { id: id } {
        creator: sender,
        title: title,
        description: description,
        deadline: deadline,
        yes-votes: u0,
        no-votes: u0
      })
      (var-set proposal-count id)
      (ok id)
    )
  )
)

(define-public (vote (proposal-id uint) (support bool))
  (let (
    (sender tx-sender)
    (prop (map-get? proposals { id: proposal-id }))
  )
    (match prop data
      (begin
        (asserts! (< stacks-block-height (get deadline data)) (err u100))
        (asserts! (is-none (map-get? has-voted { proposal-id: proposal-id, voter: sender })) (err u101))

        ;; Get voter's STX balance (as voting power)
        (let ((weight (stx-get-balance sender)))
          (asserts! (> weight u0) (err u102))

          ;; Update vote tally
          (begin
            (map-set has-voted { proposal-id: proposal-id, voter: sender } true)
            (if support
              (map-set proposals { id: proposal-id } {
                creator: (get creator data),
                title: (get title data),
                description: (get description data),
                deadline: (get deadline data),
                yes-votes: (+ (get yes-votes data) weight),
                no-votes: (get no-votes data)
              })
              (map-set proposals { id: proposal-id } {
                creator: (get creator data),
                title: (get title data),
                description: (get description data),
                deadline: (get deadline data),
                yes-votes: (get yes-votes data),
                no-votes: (+ (get no-votes data) weight)
              })
            )
            (ok true)
          )
        )
      )
      (err u103)
    )
  )
)

(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals { id: proposal-id })
)

(define-read-only (has-user-voted (proposal-id uint) (user principal))
  (is-some (map-get? has-voted { proposal-id: proposal-id, voter: user }))
)
