# Mathlib-analogist directive — FBC `_legs_conj` fork (pick fallback A vs B)

## Mode: api-alignment

## Situation
File: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`. We must prove a mate/conjugate coherence
`base_change_mate_fstar_reindex_legs_conj` (`_legs_conj`, the sorry that gates the affine base-change
isomorphism `IsIso pushforwardBaseChangeMap` via `base_change_mate_gstar_transpose`). All three closing
LEGS are already proved axiom-clean this iter:
- `base_change_mate_reindex_conj_pullbackLeg` (conj-2b) — `= Adjunction.conjugateEquiv_leftAdjointCompIso_inv …`
- `base_change_mate_reindex_conj_pushforwardCollapse` (conj-2c) — pre-existing.
- `base_change_mate_reindex_conj_crossLayer` (conj-2d) — the ring-map-general port of Seam-1
  `base_change_mate_unit_value`, via `unit_conjugateEquiv_symm` raised by `conjugateEquiv_comp`.

The INTENDED proof was to fuse these three legs by recognising the whole section-level composite
`gammaPushforwardTildeIso.inv ≫ Γ.map(…) ≫ (gammaPushforwardIso ψ … ≪≫ restrictScalars ψ .mapIso(read_param … conjPullbackFactor)).hom`
as a single `conjugateEquiv adjL adjR` VALUE, then apply `(conjugateEquiv adjL adjR).injective` (and
`.surjective` to lift the locked components to free preimages). This has FAILED for 3 iterations: the
composite is not syntactically a `conjugateEquiv` value, so `apply conjugateEquiv.injective` does not
unify, and there is no element-level normal form to `ext` against under the `X.Modules` instance diamond
(a bare element-`ext` was executed at iter-035, `FlatBaseChange.lean:2097`, and produced no normal form).

## The question (which Mathlib idiom should we align to?)
When Mathlib proves a coherence between two composites built from adjunction conjugates / mates
(`Adjunction.conjugateEquiv`, `leftAdjointCompIso`, `mateEquiv`, the `CompositionIso` calculus,
`whiskerLeft`/`whiskerRight` of natural transformations), which canonical technique does it use, and
which of our two fallbacks does it match?

- **Fallback A** — element/component `ext` with a CHANGE-OF-RINGS DICTIONARY: take the goal to components
  (`NatTrans.ext` / `ext x`), then rewrite each side with conj-2b/2c/2d as a dictionary of
  per-leg simp lemmas until both sides reach a common normal form. Does Mathlib's mate calculus admit a
  component-wise normal form here, or is the `X.Modules`/pushforward-Γ composite genuinely
  normal-form-free (as iter-035 found)?

- **Fallback B** — RESTRUCTURE so the composite IS a conjugate value: rebuild `_legs`'s codomain read
  natively from `leftAdjointCompIso` primitives (and the proved `pullbackComp_eq_leftAdjointCompIso`,
  `conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_leftAdjointCompIso_inv`) so that
  `conjugateEquiv.injective` applies WITHOUT a reframing step. This is a refactor of the comparison's
  construction, not its proof.

Concretely: does Mathlib have a precedent where a multi-functor mate coherence is proved by
TRANSPORTING the equation INTO `conjugateEquiv`/`mateEquiv` form first (so `.injective` /
`Equiv.apply_eq_iff_eq` closes it), versus proving it by `ext` + a library of component rewrites? Cite
the Mathlib files (e.g. `CategoryTheory/Adjunction/Mates.lean`, `Adjunction/Triple.lean`,
`Adjunction/Composition.lean`, or the `Mates`/`CompositionIso` API) and tell us which fallback is the
Mathlib-aligned, lower-cost path. If a THIRD idiom exists (e.g. `Adjunction.mateEquiv_conjugateEquiv`
bridges, or proving the coherence one functor-layer at a time via `mateEquiv` naturality), name it.

## Deliverable
A ranked recommendation A vs B (vs any third idiom you find), each with the Mathlib citation and the
concrete first proof step it implies, plus the cost of NOT aligning (fragility / bridge-lemma sprawl).
Write the persistent `analogies/<slug>.md` so the iter-041 planner can act on it. This decides the
iter-041 FBC prover round; we run NO conjugate-component round this iter regardless.
