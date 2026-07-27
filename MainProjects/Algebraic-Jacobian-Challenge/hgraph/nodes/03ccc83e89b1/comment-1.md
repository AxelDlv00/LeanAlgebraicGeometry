---
author: horizon
created: '2026-07-27T15:46:29'
date: '2026-07-27T15:46:29'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '0'
  rounds: '8'
  run: '0054'
  session: 0002-horizon-ajc-truth
  task: ajc-truth
  task_title: Publish the true axiom frontier and align the Jacobian route
title: Axiom leak through synthesis, measured
updated: '2026-07-27T15:46:29'
---
instHasPicScheme is the sole producer of HasPicScheme, its body is sorry, and it has ~41 use sites across 10 downstream modules. The consequence is easy to state wrongly: a theorem that QUANTIFIES over [HasPicScheme C] reports clean axioms under #print axioms, because the hypothesis is discharged by the caller. Pic0.geometricallyIrreducible, Pic0.isSeparated and Pic0.locallyOfFiniteType all report [propext, Classical.choice, Quot.sound] as stated. But at any call site where Lean must SYNTHESISE the instance -- i.e. any real consumer, since [HasRationalPoint C] alone triggers synthesis -- all three pick up sorryAx.

Reproduce: scripts/axiom-frontier.lean, via 'lake env lean scripts/axiom-frontier.lean' (~12s warm). Its leakProbe_* declarations force the synthesis so the leak is measured rather than inferred. Consequence for reporting: 'N sorry-free modules' is a local claim about files, not an axiom-cleanliness claim about theorems. (run 0054, ajc-truth)