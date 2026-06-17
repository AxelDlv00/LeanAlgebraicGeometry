# AlgebraicJacobian/Albanese/CodimOneExtension.lean

## Iter-191 Lane M↓ first scaffold dispatch

**HARD BAR**: Stage 1-2 axiom-clean (smooth → flat + standard
presentation skeleton). Helper budget = 2.

**Result**: ✅ HARD BAR met. 2/2 helpers landed axiom-clean (kernel
axioms only — `propext`, `Classical.choice`, `Quot.sound`). Sorry
count unchanged at 3 (Stages 3-4 residual is now scoped to a single
named scoped `sorry` inside `isRegularLocalRing_stalk_of_smooth`).

## `stalkMap_flat_of_smooth` (line ~244, Stage 1)

### Attempt 1
- **Approach**: Compose `AlgebraicGeometry.instFlatOfSmooth`
  (the `[Smooth f] : Flat f` instance) with
  `AlgebraicGeometry.Flat.stalkMap` (which produces
  `(f.stalkMap x).hom.Flat` from `[Flat f]`).
- **Lemma found**: `AlgebraicGeometry.Flat.stalkMap` (direct extraction
  lemma at `Mathlib.AlgebraicGeometry.Morphisms.Flat:94`); also
  `AlgebraicGeometry.Flat.iff_flat_stalkMap` (the iff version at
  line 98).
- **Result**: RESOLVED — single-line `:= AlgebraicGeometry.Flat.stalkMap X.hom z`.
- **Key insight**: The `[Smooth X.hom]` instance is enough; `[Flat X.hom]`
  is automatically synthesized via the priority-`low`
  `instance [Smooth f] : Flat f` at
  `Mathlib.AlgebraicGeometry.Morphisms.Smooth:113`.

### Axioms
`propext`, `Classical.choice`, `Quot.sound` — kernel-clean.

## `exists_isStandardSmooth_at_of_smooth` (line ~270, Stage 2)

### Attempt 1
- **Approach**: Re-export `AlgebraicGeometry.Smooth.exists_isStandardSmooth`
  (line 99 of `Mathlib.AlgebraicGeometry.Morphisms.Smooth`) at the
  project's `Over (Spec (.of k̄))` calling convention.
- **Lemma found**: `AlgebraicGeometry.Smooth.exists_isStandardSmooth`
  produces exactly the existential we need:
  `∃ U V, IsAffineOpen U, IsAffineOpen V, x ∈ V, V ≤ f ⁻¹' U,
  IsStandardSmooth (f.appLE U V e).hom`.
- **Result**: RESOLVED — single-line
  `:= AlgebraicGeometry.Smooth.exists_isStandardSmooth X.hom z`.
- **Key insight**: Mathlib already packages Stacks tag 00T7 (smooth
  morphism ⟹ existence of standard smooth presentation locally) as a
  direct extraction lemma off the `Smooth` typeclass — no need to go
  through the affine cover by hand.

### Axioms
`propext`, `Classical.choice`, `Quot.sound` — kernel-clean.

## `isRegularLocalRing_stalk_of_smooth` (line ~286, main)

### Attempt 1
- **Approach**: Wire Stage 1 + Stage 2 helpers, then scope the
  remaining content into a single `sorry` capturing Stages 3-4 (Stacks
  02JK + 00OE: polynomial generators ⟹ regular sequence ⟹ regular
  local ring).
- **Result**: PARTIAL — Stages 1-2 axiom-clean inside the body; Stages
  3-4 captured as scoped `sorry`. Sorry count unchanged at 3.
- **Next step (iter-192+)**: Either upstream cotangent /
  sheaf-of-relative-differentials route to close the Jacobian-criterion
  regularity, or project-side `02JK`/`00OE` chain build.

### Axioms (consuming the scoped sorry)
`propext`, `sorryAx`, `Classical.choice`, `Quot.sound` — the `sorryAx`
is the Stages 3-4 residual.

## Sorry projection

Entering iter-191 prover phase: **3 sorries** in this file.
After this dispatch: **3 sorries** in this file (unchanged — Stages
1-2 axiom-clean helpers added, main theorem's body still has 1 scoped
sorry for Stages 3-4).

Downstream consumers
(`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`,
`localRing_dvr_of_codim_one`) inherit the closure automatically once
the Stages 3-4 residual lands.

## Blueprint markers

- `lem:smooth_to_regular_local_ring` (Stacks 00TT): the Lean target
  `isRegularLocalRing_stalk_of_smooth` is now structured into 4
  stages, with Stages 1-2 axiom-clean. The chapter block could carry
  a `% NOTE:` annotation explaining the 4-stage scaffolding; the
  review agent (which owns blueprint semantic markers) may want to
  add this note. The block does NOT yet warrant `\leanok` (the body
  still contains `sorry` for Stages 3-4) — `sync_leanok` will
  continue to keep it unmarked.
- `lem:smooth_codim_one_dvr` (Hartshorne II.6): unchanged; continues
  to depend on `isRegularLocalRing_stalk_of_smooth`.

No `\leanok` changes required by this iter (the deterministic
`sync_leanok` phase will handle the marker accordingly).

## Helpers introduced

Two new `private` helpers — well within the helper budget of 2:

1. `stalkMap_flat_of_smooth` — Stage 1 axiom-clean
2. `exists_isStandardSmooth_at_of_smooth` — Stage 2 axiom-clean

Both are minimal re-exports of Mathlib b80f227 lemmas at the project's
`Over (Spec (.of k̄))` calling convention, with no additional
hypotheses beyond `[Smooth X.hom]`. The strict subset of typeclasses
required (only `[Smooth X.hom]`) makes them maximally reusable.

## Verification

- `lake env lean AlgebraicJacobian/Albanese/CodimOneExtension.lean`
  → 3 sorry warnings, no errors.
- `lean_verify AlgebraicGeometry.Scheme.stalkMap_flat_of_smooth`
  → axioms `propext`, `Classical.choice`, `Quot.sound`.
- `lean_verify AlgebraicGeometry.Scheme.exists_isStandardSmooth_at_of_smooth`
  → axioms `propext`, `Classical.choice`, `Quot.sound`.
- `lean_verify AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth`
  → axioms `propext`, `sorryAx`, `Classical.choice`, `Quot.sound`
  (sorryAx is the Stages 3-4 residual, expected).
- `lean_verify AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one`
  → axioms `propext`, `sorryAx`, `Classical.choice`, `Quot.sound`
  (inherits the same single residual, expected).
