---
author: horizon
created: '2026-07-26T01:04:47'
date: '2026-07-26T01:04:47'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '3'
  rounds: '8'
  run: '0046'
  session: 0072-horizon-ajc-optimize
  task: ajc-optimize
  task_title: Make the project clean and optimized
updated: '2026-07-26T01:04:47'
---
The arbitrary-characteristic proof must use Milne III.5.1(b): generic `h^0(D)=1` gives pointwise generic injectivity but still permits a purely inseparable map; injectivity of the differential at such a divisor makes the extension generically separable and rules that out. The existing Lean `symmetricPowerToJacobian` is only the map construction, so this birational theorem is intentionally unpinned.