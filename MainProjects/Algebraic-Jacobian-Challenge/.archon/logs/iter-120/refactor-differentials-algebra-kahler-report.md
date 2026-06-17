# Refactor Report

## Slug
differentials-algebra-kahler

## Status
COMPLETE — `smooth_locally_free_omega` restated in the algebra-Kähler
form (Option iii) as specified by the iter-120 plan directive. The
file compiles with exactly one (expected) `sorry` warning at L91.

## Directive

### Problem
The iter-119 prover lane on `smooth_locally_free_omega` returned
PARTIAL with one residual `sorry` at L136. The conclusion was stated
on the presheaf-section module
`(relativeDifferentialsPresheaf f).presheaf.obj (.op V)` whose source
ring is the colimit `colim_{f V ⊆ W ⊆ S} Γ(S, W)`, not `Γ(S, U)`.
This colimit-source bridge cannot be closed directly from the Mathlib
chain on the appLE algebra `Γ(S, U) → Γ(X, V)`.

### Change Requested (Option iii)
Restate `smooth_locally_free_omega` on the appLE algebra Kähler
module `Ω[Γ(X, V) ⁄ Γ(S, U)]` directly, eliminating the bridge from
the theorem's content. Preserve the leaf objects
`relativeDifferentialsPresheaf` and
`relativeDifferentialsPresheaf_obj_kaehler` intact. Replace the body
with a single `sorry`; do not attempt to fill it.

## Changes Made

### File: `AlgebraicJacobian/Differentials.lean`
- **What:** Replaced the declaration of `smooth_locally_free_omega`
  (signature + body) at lines 87–136 with the algebra-Kähler form
  specified verbatim in the directive. The new signature uses the
  existential shape `∃ U V e, ...` with the algebra structure
  `(Scheme.Hom.appLE f U V e).hom.toAlgebra` installed via a `letI`
  inside the body, and conclusion `Module.Free Γ(X, V) Ω[Γ(X, V) ⁄
  Γ(S, U)] ∧ Module.rank Γ(X, V) Ω[Γ(X, V) ⁄ Γ(S, U)] = n`.
- **Why:** From directive — Option (iii) per iter-120 plan agent
  (consulted strategy-critic, blueprint-reviewer, progress-critic,
  mathlib-analogist). Aligns with Mathlib's existing
  `Algebra.IsStandardSmooth*` API and removes the project-side
  colimit-source obstacle from the theorem statement itself. The
  prover lane will close the new `sorry` from the algebraic Mathlib
  chain (`smoothOfRelativeDimension_iff`,
  `IsStandardSmoothOfRelativeDimension.isStandardSmooth`,
  `Algebra.IsStandardSmooth.free_kaehlerDifferential`, etc.).
- **Cascading:** None. `smooth_locally_free_omega` has no callers
  inside the project (grep confirms only the declaration site, the
  blueprint `\lean{...}` cross-reference, and iter-119 snapshot
  artifacts). The blueprint cross-reference still resolves because
  the theorem name is preserved.

The two preserved declarations
`relativeDifferentialsPresheaf` (L49–52) and
`relativeDifferentialsPresheaf_obj_kaehler` (L58–64) are unchanged.
The module docstring (L1–28), imports, namespace block, and
`set_option autoImplicit false` directive are all preserved.

## New Sorries Introduced
- `AlgebraicJacobian/Differentials.lean:99` (inside the theorem body
  whose declaration starts at L91) — the new `smooth_locally_free_omega`
  body is a single `sorry`, as required by the directive. The plan
  agent will assign this to the iter-120 prover lane.

(The iter-119 PARTIAL `sorry` at L136 of the previous body is removed
along with the rest of the proof body; the new file ends at L102.)

## Compilation Status
- `AlgebraicJacobian/Differentials.lean`: compiles. Single warning,
  `declaration uses 'sorry'` at L91:9. No errors.
- `lake build AlgebraicJacobian.Differentials`: SUCCESS
  (`Built AlgebraicJacobian.Differentials (2.1s)`, 2820 jobs).
- Sorry count on `AlgebraicJacobian/Differentials.lean`: exactly **1**
  (matches directive's verification step 4).
- No new axioms (no `axiom` keyword introduced; only `sorry` inside a
  proof body).
- No new declarations introduced (only the existing
  `smooth_locally_free_omega` was modified).
- No new imports.

## Verification Against Directive Checklist
1. ✅ `lean_diagnostic_messages` returns only the expected
   `declaration uses 'sorry'` warning at the new theorem.
2. ✅ `relativeDifferentialsPresheaf` and
   `relativeDifferentialsPresheaf_obj_kaehler` are unchanged and
   compile.
3. ✅ `lake build AlgebraicJacobian.Differentials` succeeds.
4. ✅ Sorry count on the file is exactly 1.
5. ✅ No new axioms.
6. ✅ No new declarations; bridge helper lemma NOT added (as
   instructed); `archon-protected.yaml` not touched (file has no
   entry for `smooth_locally_free_omega`, and the refactor is a
   signature change on a non-protected declaration); no files
   modified outside `AlgebraicJacobian/Differentials.lean`.

## Notes for Plan Agent

- The new signature precisely mirrors the existential output of
  `mk_iff`-generated `smoothOfRelativeDimension_iff` (an `∃ U₀ V₀ e,
  ...` clause carrying the chart and the ring-level smoothness
  witness), so the prover should be able to follow steps 1–4 of the
  iter-119 attempt verbatim (extract the chart, `algebraize` the
  appLE map, derive `Algebra.IsStandardSmooth`, then close
  `free_kaehlerDifferential` + `rank_kaehlerDifferential`) without
  needing step 5's colimit bridge.
- The `letI : Algebra Γ(S, U) Γ(X, V) := (Scheme.Hom.appLE f U V e).hom.toAlgebra`
  inside the existential body is the canonical place to install the
  algebra structure. Prover should match this with `letI` (not
  `haveI`) when unpacking the existential, since the `Module.Free`
  and `Module.rank` claims that follow depend on the algebra instance
  being definitionally available.
- Blueprint cross-reference `\lean{AlgebraicGeometry.Scheme.smooth_locally_free_omega}`
  at `blueprint/src/chapters/Differentials.tex:51` still points at
  the same fully qualified name; no blueprint edit is required from
  this refactor.
- The previous `iter-119` PARTIAL did its best to fight the
  colimit-source bridge as `sorry`; the new shape eliminates that
  obstacle entirely. No further refactor needed unless the bridge
  helper to the presheaf form is later prioritized (out-of-scope per
  the directive).
