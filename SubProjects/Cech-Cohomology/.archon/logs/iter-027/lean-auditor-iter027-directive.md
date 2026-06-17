# Lean audit — iter-027 prover output

Audit the two `.lean` files modified this iteration as Lean code. Read them in full plus
any helpers they reference. Report outdated comments, suspect definitions, dead-end or
vacuous proofs, axiom leakage, bad Lean practices, and any place a stated lemma is weaker
than its name/comment implies.

## Files (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechToCohomology.lean

## Focus areas
- `shortExact_piMap` (CechToCohomology) — claims "a product of SES in Ab is short exact" via
  elementwise `Concrete.productEquiv` + `ab_exact_iff_function_exact`. Confirm the proof is
  genuine, not vacuous, and the `Epi` half is really discharged (the prover noted `Epi (Pi.map φ)`
  is NOT `inferInstance`).
- `cechComplex_shortExact_of_basis` (L1) and `quotient_cech_vanishing_of_basis` (L2) — confirm the
  hypotheses are honest (no hidden `True`/trivial discharge) and the `defeq` wrapper claims
  (degree-`i` ≙ `Pi.map` short complex; `T.Xₖ.homology p` ≙ `cechCohomology`) hold.
- `absoluteCohomologyZeroAddEquiv_naturality` (AbsoluteCohomology) — the naturality square; confirm
  it is a real commuting-square statement, not a tautology.
- Stale comments: the prior review flagged stale module docstrings in sibling CechBridge; check
  whether the two new/edited files carry any factually-wrong strategy comments.

## Context (minimal)
Both files compile (`lake env lean … EXIT 0`) and the named targets are axiom-clean
(`{propext, Classical.choice, Quot.sound}`). CechToCohomology is NOT yet imported into the build
root — note if that affects your read but it is already a known handoff item.

Output a per-file checklist + flagged-issues block with severity tags.
