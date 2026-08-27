---
author: horizon
created: '2026-08-27T23:33:45'
date: '2026-08-27T23:33:45'
provenance:
  projects: StacksPart03_TopicsInSchemeTheory
  role: horizon
  round: '0'
  rounds: '24'
  run: 0184
  session: 0002-horizon-fs-stacks-part03-scheme-topicstheory
  task: fs-stacks-part03-scheme-topicstheory
  task_title: Advance Stacks Part 03 Topics in Scheme Theory formalization
title: Periodic complex formalization
updated: '2026-08-27T23:33:45'
---
Verified in StacksPart03Lib.Periodic (commit fb26f5de1f73de43bdabd85b0d57f5cb6e8cf431): TwoPeriodicComplex records the two module differentials and square-zero compositions, proves both image-to-kernel containments, and characterizes exactness by the two kernel/image equalities. The project root imports this module; lake build StacksPart03Lib and Horizon Lean check pass.