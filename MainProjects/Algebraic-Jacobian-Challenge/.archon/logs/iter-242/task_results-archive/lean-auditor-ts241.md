# Lean Audit Report

## Slug
ts241

## Iteration
241

## Scope
- files audited: 2 (as directed)
- files skipped (per directive): all others — narrowed scope per directive

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - The `gammaPushforwardIsoAt` change (iter-241) — replacing the `eqToIso` middle step with `(ModuleCat.restrictScalarsCongr hcomp).app SecN` — is **sound**. `restrictScalarsCongr hcomp` constructs a `NatIso` whose component at `SecN` has the identity as its underlying additive-group map (it only repackages the scalar action via the ring equation `hcomp`), so it is `rfl` on elements, exactly as the comment at L632–636 claims.
  - The `hsq` close `ext x; rfl` at L637–638 is a **genuine proof**, not a vacuous or ill-typed one. After `rw [he₁, he₂, hGmor, hρ', hσ']` substitutes the structural exposures and `simp only [gammaPushforwardIsoAt, Iso.trans_hom, Iso.symm_hom]` unfolds the iso chain, every constituent (`restrictScalarsComp'App_hom/inv_apply`, `restrictScalarsCongr_app`, `restrictScalars.map_apply`) is definitionally the identity on the underlying carrier — so both sides send `x` to `tForget x`. The comment block (L626–637) describing this accurately matches the code.
  - Two remaining `sorry` bodies: `affineBaseChange_pushforward_iso` (L682) and `flatBaseChange_pushforward_isIso` (L704). Both have extensive honest comments explaining what Mathlib-absent ingredients are needed. Neither is an excuse-comment.
  - Minor observation: `gammaPushforwardIso` (L300–302) still uses `eqToIso` while the sister `gammaPushforwardIsoAt` (L347–349) was updated to `restrictScalarsCongr`. The difference is deliberate — `gammaPushforwardIsoAt` needs `rfl`-on-elements for `hsq`; `gammaPushforwardIso` does not face that requirement and compiles correctly with `eqToIso`. Neither docstring explains the split, which is a minor readability gap.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged (see below)
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - `isIso_pbu_of_final` (L1041–1043): private helper, body `inferInstance` at a clean typeclass site. Correct and well-motivated (isolates the `(Opens.map g.base).Final` hypothesis to avoid collision with in-scope witnesses).
  - `pullbackObjUnitToUnitIso` (L1049–1054): uses `@asIso _ _ _ _ (SheafOfModules.pullbackObjUnitToUnit g.toRingCatSheafHom) (isIso_pbu_of_final g)` — explicit witness bypasses the reducible-transparency synthesis failure. Sound.
  - `pullbackObjUnitToUnitIso_hom` (L1056–1059): `@[simp]` lemma, body `rfl`. Correct.
  - `pullbackUnitIso` (L1066–1070): one-liner using `haveI : (TopologicalSpace.Opens.map f.base).Final := final_of_representablyFlat _` then `pullbackObjUnitToUnitIso f`. The mathematical claim — that the preimage functor on opens is representably flat because it preserves finite limits — is correct (it is a frame homomorphism). The Lean lemma `final_of_representablyFlat` is a Mathlib wrapper for this fact. The body is **sound and the docstring is accurate**: it correctly states the comparison functor is always `Final`. No stale chart-chase prose in the docstring.
  - `sheafifyTensorUnitIso` (L1084–1118): uses the same `W_whisker{Right,Left}_of_W` + `isIso_sheafification_map_of_W` technique as `tensorObj_assoc_iso`. Looks sound.
  - **STALE HANDOFF COMMENT (major)**: The `/- **HANDOFF ... -/` block at L1120–1172 was written before the iter-241 resolution and is now incorrect in two specific claims:
    1. "NOT closable this iter" — `pullbackUnitIso` **was** closed this iter (immediately above).
    2. "`SheafOfModules.pullbackObjUnitToUnit` is an iso only under `F.Final` (open immersions), false for general `f`." — Now known to be wrong: `(Opens.map f.base).Final` is always true, so `pullbackObjUnitToUnit` is an iso for every `f`.
    The "RECOMMENDED PIVOT (1)" section describes a local-chart-finality route that turned out to be unnecessary. Parts of the block (strategic alternatives for `pullbackTensorIso` and `IsInvertible.pullback`) remain accurate, but the `pullbackUnitIso`-specific claims actively contradict the code directly above. The section note at L1011–1035 does explain the resolution, but readers who scan the HANDOFF block will find contradictory information.
  - **STALE DOCSTRING (minor)**: `pullbackObjUnitToUnit_comp` docstring (L912): "Consumed by `pullbackUnitIso`: on an affine chart `V` the inclusion `V.ι ≫ f` factors as `g ≫ U.ι` …" — the actual `pullbackUnitIso` proof never calls `pullbackObjUnitToUnit_comp` (the direct `final_of_representablyFlat` route made it unnecessary). The section note at L1025–1027 does clarify that the linchpin is retained for Phase-2 tensor use, but the docstring claim that it is "Consumed by `pullbackUnitIso`" remains stale.
  - Two remaining `sorry` bodies: `exists_tensorObj_inverse` (L715) and `addCommGroup_via_tensorObj` (L1205). Both have extensive honest documentation of remaining bridges. Neither is an excuse-comment.
  - No `axiom` declarations found.

---

## Must-fix-this-iter

None. No excuse-comments, weakened definitions, axioms on non-trivial claims, or suspect sorry bodies were found in either file.

---

## Major

- `TensorObjSubstrate.lean:1120–1172` — HANDOFF comment block is stale and actively incorrect: (a) claims `pullbackUnitIso` is "NOT closable this iter" when it was closed this very iteration; (b) asserts `pullbackObjUnitToUnit` is an iso "only under F.Final (open immersions), false for general f" — now known to be false (it is an iso for ALL f). The block actively contradicts the code immediately above it and will mislead readers.

---

## Minor

- `TensorObjSubstrate.lean:912` — `pullbackObjUnitToUnit_comp` docstring says it is "Consumed by `pullbackUnitIso`" (via the chart-chase route), but the actual `pullbackUnitIso` never calls it. The section note at L1025–1027 corrects this, but the docstring itself is stale.
- `FlatBaseChange.lean:300–302 vs 347–349` — `gammaPushforwardIso` uses `eqToIso` while `gammaPushforwardIsoAt` uses `(ModuleCat.restrictScalarsCongr hcomp).app SecN`. The divergence is deliberate and technically sound, but neither docstring explains the split or why the two sister definitions differ in this detail.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 — stale HANDOFF block contradicting `pullbackUnitIso` closure
- **minor**: 2 — stale `pullbackObjUnitToUnit_comp` docstring; undocumented `eqToIso`/`restrictScalarsCongr` split
- **excuse-comments**: 0

Overall verdict: Both files are code-correct; the four new iter-241 declarations are sound, the `ext x; rfl` close on `hsq` is genuine, and the `pullbackUnitIso` one-liner is mathematically valid — but TensorObjSubstrate.lean carries a stale HANDOFF comment block that actively misstates the current state of the code and should be removed or updated.
