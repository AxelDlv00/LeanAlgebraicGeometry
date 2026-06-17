# Lean ↔ Blueprint Checker — QcohRestrictBasicOpen.lean (iter-037)

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(this consolidated chapter covers QcohRestrictBasicOpen via a `% archon:covers` entry; the
relevant blocks are the Route B B1–B6 chain, especially `lem:presentation_over_basicOpen` (B2),
`lem:restrict_over_compat` (B3), `lem:presentation_modulesRestrictBasicOpen` (B4), and the
`Opens.overEquivalence` continuity infra.)

## What to check
- Does `presentationOverBasicOpen` faithfully realize `lem:presentation_over_basicOpen` (B2)?
  Statement shape, hypotheses (`D(g) ⊆ U`, presentation of `M.over U`), conclusion
  (`M.over D(g)` admits a presentation).
- The four new `Opens.overEquivalence_*` continuity declarations close a Mathlib TODO and have
  NO blueprint block. Report this as coverage debt (Lean → blueprint gap) and assess whether the
  chapter should carry a Mathlib-anchor/infra block for them and whether B3's `\uses` should thread
  them in.
- `lem:restrict_over_compat` (B3) and `lem:presentation_modulesRestrictBasicOpen` (B4) are NOT yet
  formalized (left absent). Confirm the blueprint blocks for B3/B4 are detailed enough to guide
  the next prover (the prover decomposed B3 into B3a/B3b/B3c via `(specBasicOpen g).ι.appIso` — is
  that level of detail reflected or missing in the chapter?).
- Flag any `\lean{...}` pin mismatch, fake/placeholder statement, or signature divergence.

Report bidirectionally (Lean→blueprint AND blueprint→Lean). Read-only; write only your report.
