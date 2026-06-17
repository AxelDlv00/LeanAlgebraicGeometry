# Refactor Report — lofft-thread (iter-161)

## Status: ✅ COMPLETE — build GREEN, no new axioms

## What was done

Threaded the instance binder `[LocallyOfFiniteType (X ⊗ Y).hom]` through the five
Rigidity-Lemma chain theorems in `AlgebraicJacobian/AbelianVarietyRigidity.lean`, placed
immediately after `[GeometricallyIrreducible (X ⊗ Y).hom]` and before
`[IsReduced (X ⊗ Y).left]` (single `replace_all` edit; the binder block is identical across
all five and disjoint from the `P1.hom`/`C.hom`/`A.hom` scaffolds, so no over-matching):

1. `rigidity_eqAt_closedPoint_of_proper_into_affine`  — L156
2. `rigidity_eqOn_saturated_open_to_affine`           — L209
3. `rigidity_eqOn_dense_open`                         — L277
4. `rigidity_core`                                    — L445
5. `rigidity_lemma`                                   — L528

`morphism_eq_of_eqAt_closedPoints` (~L107) was left untouched (takes `[JacobsonSpace W]`
directly), as instructed.

## Call sites

All four internal call sites elaborated with **no explicit-argument changes** — the binder
is instance-implicit and in scope at each caller, so typeclass resolution threads it down
automatically. No `sorry` insertion was needed at any call site. (`rigidity_eqOn_dense_open`,
`rigidity_core`, `rigidity_lemma` do not even appear in the sorry-warning list, confirming
their bodies + downward calls are clean.)

## Comment update

Reworded the stale "SIGNATURE GAP" block (~L227–236) above the `:237` `JacobsonSpace` sorry.
It now states that `[LocallyOfFiniteType (X ⊗ Y).hom]` is a hypothesis of the lemma, so
`JacobsonSpace U` is derivable (Spec k̄ Jacobson via `PrimeSpectrum.instJacobsonSpaceOfIsJacobsonRing`
→ `LocallyOfFiniteType.jacobsonSpace` → `JacobsonSpace.of_isOpenEmbedding` for the open `U`),
and that the remaining `sorry` is a routine instance discharge for the prover phase — not an
as-typed-unprovability.

## Sorry landscape (unchanged in count: 5)

`lake env lean AlgebraicJacobian/AbelianVarietyRigidity.lean` emits exactly 5 sorry warnings,
0 errors:
- L151 `rigidity_eqAt_closedPoint_of_proper_into_affine` — deep residual (`:172` body), untouched
- L204 `rigidity_eqOn_saturated_open_to_affine` — `JacobsonSpace` instance sorry (`:237`), now provable-as-typed
- L558 `morphism_P1_to_grpScheme_const` — pre-existing deferred scaffold
- L582 `genusZero_curve_iso_P1` — pre-existing deferred scaffold
- L607 `rigidity_genus0_curve_to_grpScheme` — pre-existing deferred scaffold

Both remaining **chain** sorries are now provable as literally typed.

## Verification

- `AlgebraicJacobian/AbelianVarietyRigidity.lean`: GREEN (5 sorry warnings only).
- `AlgebraicJacobian/Jacobian.lean` (downstream importer): GREEN, 0 errors.
- `#print axioms rigidity_lemma` → `[propext, sorryAx, Classical.choice, Quot.sound]` —
  no new custom axioms.
- No protected signature touched (none of the five is in `archon-protected.yaml`).
