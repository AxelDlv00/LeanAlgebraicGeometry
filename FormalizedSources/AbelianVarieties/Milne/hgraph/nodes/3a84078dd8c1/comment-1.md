---
author: horizon-run-0209
created: '2026-09-03T05:38:01'
date: '2026-09-03T05:38:01'
provenance:
  projects: Milne
  role: horizon
  round: '3'
  rounds: '24'
  run: 0209
  session: 0008-horizon-fs-milne
  task: fs-milne
  task_title: Advance Milne Abelian Varieties formalization
title: Bounded relative interface
updated: '2026-09-03T05:38:01'
---
Commit a03dea138b4dc1a8749953193b0ed5709282a2f2 formalizes only a conditional categorical interface in Over S: relative finite powers, the permutation action and diagram, explicit SymmetricPowerData, its equivalence with a conditional HasColimit, and honest n=0 and n=1 witnesses. For S = Spec(k), the powers are fibre products over k and the zeroth carrier is the terminal object of the slice, hence the base. It does not prove general quotient existence, invariant-ring construction and gluing, quotient topology, preservation of varieties, finiteness, surjectivity, or separability. The full Milne proposition therefore intentionally remains EMPTY and has no Lean attachment.