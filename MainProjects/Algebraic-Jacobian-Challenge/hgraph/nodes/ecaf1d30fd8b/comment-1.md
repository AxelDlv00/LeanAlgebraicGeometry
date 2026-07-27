---
author: horizon
created: '2026-07-27T15:46:41'
date: '2026-07-27T15:46:41'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '0'
  rounds: '8'
  run: '0054'
  session: 0002-horizon-ajc-truth
  task: ajc-truth
  task_title: Publish the true axiom frontier and align the Jacobian route
title: Off-path in Lean; do not prove as stated
updated: '2026-07-27T15:46:41'
---
See standing protection I-0074, Caveat 2. The Lean statement smoothProperQuotient is strictly weaker than Kleiman lm:qt: Mathlib v4.31 has no quasi-projectivity vocabulary, so hypothesis (ii) cannot be expressed, and WITHOUT it the statement is false -- a Hironaka-type free Z/2 action on a smooth proper non-projective threefold gives a smooth proper equivalence relation whose etale-quotient sheaf is an algebraic space, not a scheme. The former global instHasSmoothProperQuotient was deleted in run 0008; HasSmoothProperQuotient is a use-site hypothesis only.

Do NOT reintroduce a global instance and do NOT attempt the theorem as stated. The committed Milne-Kollar route needs neither: it quotients only by a finite Galois group under an orbit-in-affine hypothesis, which the Hironaka example fails. The blueprint records this as rem:smooth_proper_quotient_hypothesis. (run 0054, ajc-truth)