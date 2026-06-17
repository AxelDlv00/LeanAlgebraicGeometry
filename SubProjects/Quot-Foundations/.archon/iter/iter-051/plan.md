# Iter 051 — Plan (Quot-Foundations)

## TL;DR
iter-050 both lanes CONVERGED (GF seam-1 CLOSED +5; GR-quot new file +3). iter-051 = 3 prover lanes after a
blueprint-prep round (3 writers + clean + reviewer PASS). Coverage debt (15 unmatched decls) CLEARED.

## Decision made — 3 lanes; GF narrowed to G1-only per CHURNING corrective
- **GF (FlatteningStratification) [mathlib-build]:** progress-critic **CHURNING** (G1 deferred 3 iters, over
  budget). Corrective applied verbatim: **G1 base case (a/b/c) is the SOLE GF objective**; G3 + genericFlatness
  close NOT dispatched (G3 stub thin → needs flat-locality anchors; close is downstream of both). Rejected my
  initial G1+G3+close proposal as over-ambitious — critic was right.
- **GR-quot (GrassmannianQuot) [mathlib-build]:** UNCLEAR (fresh). `chartQuotientMap_epi` (split-epi, recipe
  in task_result) + `glue` signature must-fix (cocycle hyps C1/C2, auditor+lvb-checker).
- **SNAP (SectionGradedRing) [mathlib-build]:** UNCLEAR. First prover attempt on the re-decided Analogue-1
  route (crux `isIso_sheafification_whiskerRight_unit` → assoc → tensorPowAdd). Grace EXPIRED — re-flag if it
  stalls; fallback = scope change.

## Blueprint prep (gate)
3 writers added: G1 base-case block (a/b/c) + GeneratingSections.map engine + `gr_chartQuotientMap_epi` +
globalUnitSection/scalarEnd + `glue` cocycle hyps + 10 SNAP coverage-debt blocks. Dropped spurious
`[F.IsQuasicoherent]`. blueprint-clean stripped Lean/impl leakage. blueprint-reviewer **PASS** — all 3
hard-gate chapters complete+correct; G3 "soon" (anchors before future dispatch).

## Subagent skips
- strategy-critic: STRATEGY edit this iter is a one-row status refresh (seam-1 CLOSED, bottleneck → G1 base
  case) within UNCHANGED routes/phases/decomposition; prior verdict SOUND, FBC challenge addressed iter-050.
  No strategic change to challenge.
