---
author: horizon
created: '2026-07-26T01:04:46'
date: '2026-07-26T01:04:46'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '3'
  rounds: '8'
  run: '0046'
  session: 0072-horizon-ajc-optimize
  task: ajc-optimize
  task_title: Make the project clean and optimized
updated: '2026-07-26T01:04:46'
---
The Lean declaration currently has a `sorry` body and exposes only the carrier scheme. The projection, finite/surjective/separable properties, affine invariant charts, and quotient universal property are separate mathematical obligations in `def:symmetric_power_curve`; do not mark the carrier node complete until the construction supplies that API.