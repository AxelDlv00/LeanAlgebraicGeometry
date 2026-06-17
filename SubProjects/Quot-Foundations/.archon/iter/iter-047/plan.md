# Iter 047 — Plan (Quot-Foundations)

## TL;DR
2 fresh import-independent prover lanes: **GF G1 base case** (FlatteningStratification, build 4 seams
mathlib-build) + **SNAP layer-1** (NEW SectionGradedRing.lean, build sheaf-tensor-powers mathlib-build).
Both blueprint-gate-cleared (blueprint-reviewer iter047 HARD GATES PASSED). QuotScheme annihilator
blueprint reconciled (prior attempt this iter). FBC un-park trigger added; GF route ingredient named.

## Decision made — GF seam-2 mechanism + 2-lane dispatch
- **GF seam 2 (the crux) resolved via Mathlib.** strategy-critic CHALLENGE: "exact-functor transport"
  is unsound (qcoh≃Mod built object-wise, no global exact functor). mathlib-analogist found the fix:
  Mathlib's affine `tilde.adjunction` counit `fromTildeΓ` + `tilde.functor` faithful-reflects-epi gives
  surjectivity in ~12 lines, NO H¹-vanishing. Refined seam-2 blueprint to this (writer `gf-seam2` +
  clean). Recipe `analogies/gf-gamma-exact.md`. STRATEGY GF route prose corrected to name the ingredient.
- **2 lanes, both mathlib-build, both first-dispatch.** progress-critic dispatch OK (UNCLEAR/proceed on
  both). SNAP scaffolds a real new leaf and builds layer 1 axiom-clean (not sorry-stubs — mathlib-build).

## Critic must-fixes — all actioned
- **FBC CHURNING/CHALLENGE (both critics):** un-park trigger written into STRATEGY (FBC-A1 row + route):
  resume once GF base case + SNAP land (≈iter 050) or a lane frees. Goal-required, off critical path.
- **GF CHALLENGE (strategy-critic):** ingredient named (counit + faithful-reflects-epi) in STRATEGY +
  blueprint. **Format DRIFT:** Status cells de-prosed, "this iter" leak removed, SNAP monoidal-absent
  claim corrected (`PresheafOfModules.Monoidal` PRESENT).

## Deferrals (documented, not blocking this iter's lanes)
- G3 stub thin (blueprint-reviewer must-fix-1): downstream of G1, expand iter-048 before G3 prover.
- RelativeSpec prose mismatch (must-fix-2, low): Lean done, doc-only — iter-048.
- FBC chapter unaudited (must-fix-3, infra): parked route — audit before any FBC resume.

## Subagent skips
- blueprint-reviewer / progress-critic / strategy-critic / mathlib-analogist: all dispatched this iter
  (reports `*-iter047.md`, `*-gf-gamma-exact.md`). blueprint-writer `gf-seam2` + blueprint-clean
  `iter047` dispatched for the seam-2 refinement. No mandatory subagent skipped.
