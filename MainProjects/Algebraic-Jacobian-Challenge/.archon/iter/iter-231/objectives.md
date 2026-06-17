# Iter-231 objectives (per-task detail)

## Lane TS — `Picard/TensorObjSubstrate.lean` [prover-mode: mathlib-build] — DEFERRED 1 iter

**STATUS: prover NOT dispatched this iter — blueprint gate FAILED** (blueprint-reviewer ts231:
`Picard_TensorObjSubstrate.tex` `correct: partial`; falsified `overSliceSheafEquiv` recipe still in
`lem:dual_isLocallyTrivial`). blueprint-writer cbridge dispatched to fix it; re-engage next iter on
gate re-clear. Spec below is READY for that dispatch.

**Gating deliverable:** `AlgebraicGeometry.Scheme.Modules.dual_restrict_iso` — the presheaf-level
base-change iso `dual (M.restrict f) ≅ (dual M).restrict f` (`f^*ℋom(A,𝒪)≅ℋom(f^*A,f^*𝒪)`) for an open
immersion `f`. A REAL natural iso (NOT definitional), ~150–300 LOC, the FAVORABLE iso-base-change case
(codomain `𝒪`; `β` ring iso ⇒ `restrictScalars` equivalence). Anchors: per-`V` slice equiv
`Over_Y V ≌ Over_X (f.opensFunctor V)`, `restrictScalars`-as-equivalence (`restrictScalarsRingIsoDualEquiv`),
`pushforward` pseudofunctor coherence. Only opens `V ⊆ U` needed downstream. Do NOT route through
`overSliceSheafEquiv` (settled dead end iter-230).

**Then:** `dual_isLocallyTrivial` (mirror `tensorObj_isLocallyTrivial`; needs `dual_unit_iso`), then
close `exists_tensorObj_inverse` (L2210, 80→79) via the descent re-route (`homOfLocalCompat` glue +
`isIso_of_isIso_restrict`).

**HARD GATE:** PASS = 80→79 OR `dual_restrict_iso` axiom-clean. FAIL = probe/peripheral-helper/re-scope.

**On FAIL (pre-committed, next iter):** (1) pivot inverse off the dual — object-gluing route II
(`informal/exists_tensorObj_inverse.md`); (2) file-split `TensorObjSubstrate.lean`.

## Status snapshot
- Project sorry: 80 (entering). File-local sorries: L691 `isLocallyInjective_whiskerLeft_of_W`
  (vestigial, FORBIDDEN), L2210 `exists_tensorObj_inverse` (target), L2256 `addCommGroup_via_tensorObj`
  (RPF consumer, FORBIDDEN).
- Build: GREEN.

## Consults (reports in task_results/, recipes in analogies/ts231ih.md)
- progress-critic ts231(b): STUCK; defensible behind hard gate.
- mathlib-analogist ts231ih: NEEDS_MATHLIB_GAP_FILL; real iso ~150–300 LOC (favorable case); refuted "near-definitional"; build project-side w/ named anchors.
- strategy-critic ts231: CHALLENGE (narrow) — seed engine coverage for parallelism (blueprint-reviewer ts231).
- blueprint-clean ts231: CLEAN.
