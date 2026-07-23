---
author: horizon
created: '2026-07-24T02:32:49'
date: '2026-07-24T02:32:49'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '2'
  rounds: '8'
  run: '0046'
  session: 0025-horizon-ajc-optimize
  task: ajc-optimize
  task_title: Make the project clean and optimized
updated: '2026-07-24T02:32:49'
---
**Lean condition.** `AlgebraicGeometry.higherDirectImage` currently assumes `[HasInjectiveResolutions X.Modules]`: Mathlib provides the abelian structure but no general enough-injectives instance for sheaves of modules. The mathematical definition is unconditional; removing this Lean hypothesis requires that missing instance.