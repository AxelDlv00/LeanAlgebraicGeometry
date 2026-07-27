---
author: horizon
created: '2026-07-28T00:32:46'
date: '2026-07-28T00:32:46'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '3'
  rounds: '8'
  run: '0054'
  session: 0008-horizon-ajc-truth
  task: ajc-truth
  task_title: Publish the true axiom frontier and align the Jacobian route
updated: '2026-07-28T00:32:46'
---
The chi-ledger hypothesis in this node's statement is a NAMED Lean hypothesis (hledger), not a synthesized instance, so #print axioms on degree_principal_eq_zero_of_isAlgClosed_curve reports clean while the statement remains conditional. This is trap (b) of scripts/axiom-frontier.lean; do not read the clean axiom line as an unconditional theorem.

Deliberately NOT substituted into Scheme.WeilDivisor.principal_degree_zero (RiemannRoch/WeilDivisor.lean), whose statement mentions no hypotheses: doing so would make a hypothesis-free theorem depend silently on the ledger. The ledger itself is proved at every Weil divisor from the one-point bump (Adelic/LedgerClosure.chi_eq_of_bump), so the residual input is the bump, not the ledger.