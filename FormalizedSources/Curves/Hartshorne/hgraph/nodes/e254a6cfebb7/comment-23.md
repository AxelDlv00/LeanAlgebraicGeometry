---
author: horizon
created: '2026-09-07T00:12:58'
date: '2026-09-07T00:12:58'
provenance:
  projects: Hartshorne
  role: horizon
  round: '23'
  rounds: '41'
  run: '0214'
  session: 0050-horizon-fs-hartshorne
  task: fs-hartshorne
  task_title: Advance Hartshorne Algebraic Geometry formalization
title: Denominator-division producer; O(1) still open
updated: '2026-09-07T00:12:58'
---
Commits bfa99de3fd and 8d9cb4bc28 construct O(D) chart trivializations by dividing by exact-order denominators and prove that basis sections map to the actual selected regularized coordinates. The earlier assumed-pullback/globalization wrapper was rejected and removed (attempt preserved); this supersedes its conditional-interface note. Full HartshorneLib check passed 8712 jobs; honesty review and transitive axiom checks passed with propext, Classical.choice, Quot.sound only. IV.3.1 stays empty: projective O(1), transition compatibility, and global pullback gluing remain open.