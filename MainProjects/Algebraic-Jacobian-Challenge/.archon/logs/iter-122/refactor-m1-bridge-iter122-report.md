# Refactor Report

## Slug
m1-bridge-iter122

## Status
COMPLETE

## Directive (excerpted)

### Problem
Iter-121 strategic pivot opened milestone **M1** (bridge between the
presheaf-form section module of `relativeDifferentialsPresheaf` and the
algebra-Kähler module on an affine chart). Lean side lacked the
declarations. iter-122 introduces them as `sorry`-bodied scaffolding so the
subsequent prover lane has a concrete target.

### Changes Requested
Add three declarations to `AlgebraicJacobian/Differentials.lean`:
1. `AlgebraicGeometry.IsAffineOpen.appLE_unitSubmonoid` (def, M1.a) — the
   submonoid `{g ∈ Γ(S,U) : appLE(g) ∈ Γ(X,V)^×}`.
2. `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (theorem with
   sorry, M1.b) — `IsLocalization` predicate for `A → A_colim`.
3. `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`
   (LinearEquiv with sorry, bridge) — the bridge theorem.

Imports to add: `Mathlib.RingTheory.Unramified.Basic`,
`Mathlib.RingTheory.Localization.Basic`.

## Changes Made

### File: `AlgebraicJacobian/Differentials.lean`

- **What:** Added two new imports (`Mathlib.RingTheory.Unramified.Basic`,
  `Mathlib.RingTheory.Localization.Basic`).
  - **Why:** Required for `Algebra.FormallyUnramified.of_isLocalization`
    (used in M1.c/M1.d in the future prover lane) and the
    `IsLocalization` predicate used in the M1.b statement.

- **What:** Added `AlgebraicGeometry.IsAffineOpen.appLE_unitSubmonoid` as a
  bare `def`. The submonoid carrier `{g | IsUnit ((Hom.appLE f U V e).hom g)}`
  comes with full closure-property proofs (no sorry):
  - `one_mem'`: `simp only [Set.mem_setOf_eq, map_one]; exact isUnit_one`
  - `mul_mem'`: unpacks `IsUnit` via `map_mul`, finishes with `IsUnit.mul`.
  - **Why:** M1.a per directive. Both closure obligations were trivial
    one-liners, so the directive's alternative ("close inline if possible")
    was taken — submonoid lands with **0 sorries** (vs the directive's
    estimate of +2 if not inlined).
  - **Cascading:** None.

- **What:** Added `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`
  as a `theorem` body-`sorry`'d. The signature uses a `letI`-bound
  `Algebra Γ(S, U) A_colim` instance (also `sorry`-bodied) to enable the
  `IsLocalization` predicate to type-check.
  - **Why:** M1.b per directive. The canonical `Γ(S, U) → A_colim` cocone-leg
    algebra structure (from the fact that `fV ⊆ U` makes `U` an open in the
    colimit's index category) is non-trivial to spell out at refactor time;
    introducing it via a sorry-letI lets the prover lane refine the entire
    construction (algebra structure + IsLocalization proof) as a single
    coherent piece.
  - **Cascading:** None.

- **What:** Added `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`
  as a `noncomputable def` (LinearEquiv-valued; the directive's
  `theorem` shape was changed to `noncomputable def` since `LinearEquiv`
  lives in `Type`, not `Prop`).
  - **Why:** Bridge theorem per directive. Signature uses two `letI`s:
    one supplying `Algebra Γ(S, U) Γ(X, V)` (real, via
    `(Hom.appLE f U V e).hom.toAlgebra`), and one supplying
    `Module Γ(X, V) ((relativeDifferentialsPresheaf f).presheaf.obj (.op V))`
    (sorry-bodied, since the `.presheaf` field returns `Cᵒᵖ ⥤ Ab` and thus
    strips the module structure; the prover will either transport from
    `(relativeDifferentialsPresheaf f).obj (.op V) : ModuleCat _` via
    scalar-restriction, or reshape the signature to use `.obj` directly).
  - **Cascading:** None.

### File: import block of `Differentials.lean`
Added the two imports listed in the directive. Build still completes;
no circular-dependency issues.

## New Sorries Introduced
- `AlgebraicJacobian/Differentials.lean:109` — `Algebra Γ(S, U) A_colim`
  instance in `appLE_isLocalization` (canonical cocone-leg algebra
  structure; constructible by the prover via `colimit.ι` at the open
  `U`, since `fV ⊆ U`).
- `AlgebraicJacobian/Differentials.lean:112` — `appLE_isLocalization`
  body (M1.b proper; the two-direction `IsLocalization.of_le` pattern
  per blueprint § sec:bridge).
- `AlgebraicJacobian/Differentials.lean:142` — `Module Γ(X, V)` instance
  on `(relativeDifferentialsPresheaf f).presheaf.obj (.op V)` (transport
  from `(relativeDifferentialsPresheaf f).obj (.op V) : ModuleCat
  (X.ringCatSheaf.obj.obj (.op V))` via scalar identification with
  `Γ(X, V) = X.presheaf.obj (.op V)`).
- `AlgebraicJacobian/Differentials.lean:145` — bridge LinearEquiv body
  (M1.e composition: rfl-identification + inverse of the M1.d
  surjection-is-iso lemma).

Total new sorries: **4** (Differentials.lean alone). Project-wide
trajectory: **1 → 5** (the existing sorry at `Jacobian.lean:179`
remains untouched).

The directive predicted a trajectory of "1 → 3 (or 1 → 5 if the
submonoid closure obligations remain sorry'd)". The submonoid is
closed (0 sorries there) — the higher count comes from the
`Algebra`/`Module` letI instances on the colim ring and the presheaf
section, which the directive did not explicitly call out as additional
sorry sites. See "Notes for Plan Agent" below.

## Compilation Status
- `AlgebraicJacobian/Differentials.lean`: **compiles**, two `sorry`
  warnings (lines 104, 135 — the two theorem declarations).
- `AlgebraicJacobian.lean`: compiles (full project `lake build`
  completes successfully, 8328/8328 jobs).
- All other files: unaffected (additive change only).

## Notes for Plan Agent

### Divergence 1: `theorem` → `noncomputable def` for the bridge
The directive recommended `theorem
relativeDifferentialsPresheaf_equiv_kaehler_appLE : ... ≃ₗ[...] ...`.
Since `LinearEquiv` lives in `Type`, not `Prop`, this had to become
`noncomputable def`. Functionally identical from the consumer side
(the `LinearEquiv` term is named and reachable). The analogist's
draft API shape (`analogies/relative-differentials-presheaf-bridge.md`
lines 362–369) already used `noncomputable def`, so this matches the
analogist's recommendation. The blueprint `\lean{...}` hint
`AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`
still resolves correctly to a `def`.

### Divergence 2: 4 sorries vs directive's predicted 3
The directive predicted 3 sorries (after inlining M1.a):
- 1 for `appLE_isLocalization` body,
- 1 for `relativeDifferentialsPresheaf_equiv_kaehler_appLE` body,
- and no sorries in M1.a.

The actual count is 4. The two extra sorries are the **typeclass
instance** `letI`s inside the two theorem signatures — these are not
proofs of the theorems themselves, but `Algebra` / `Module` structure
constructions that should ideally be part of the proof. The reason
they had to be `sorry`-bodied rather than spelled out is:
- For `appLE_isLocalization`, the canonical `Algebra Γ(S, U) A_colim`
  structure requires invoking `colimit.ι` at the open `U` (since
  `fV ⊆ U` makes `U` an index in the cocone). The Mathlib-level cocone
  leg type is awkward to write at refactor time; rather than spell out
  a tentative formula that might not be the right one, the
  refactor agent left a sorry-letI for the prover to fill coherently
  with the M1.b proof.
- For the bridge, `(relativeDifferentialsPresheaf f).presheaf.obj (.op V)`
  has only an `AddCommGrp` structure via the `.presheaf` field (which
  is `Cᵒᵖ ⥤ Ab`). The `Module Γ(X, V)` instance is morally there (via
  `.obj` rather than `.presheaf.obj`, modulo the
  `forget₂ CommRingCat RingCat` scalar identification) but the
  transport requires non-trivial defeq work. Again deferred to the
  prover for coherent construction.

Neither extra sorry is mathematical content — they are typeclass
plumbing that the prover lane will handle as part of M1.b / M1.e.
The directive's sorry count is mathematically accurate (just the two
theorem bodies); the extra two count as "infrastructure sorries" the
prover will absorb. **Recommend**: when scoring the prover lane's
progress, count completion of `appLE_isLocalization` (including its
`letI` algebra structure) as one mathematical milestone, similarly
the bridge as one, even though `sorry_analyzer` will see 4 sites.

### Mathlib leverage checks
All the Mathlib names called out in the directive's
"Mathlib name verification" section resolve in snapshot `b80f227`
(verified by inspection of `.lake/packages/mathlib/Mathlib/...`):
- `Algebra.FormallyUnramified.of_isLocalization` at
  `Mathlib/RingTheory/Unramified/Basic.lean:303` ✓
- `Algebra.FormallyUnramified.subsingleton_kaehlerDifferential` at
  `Mathlib/RingTheory/Unramified/Basic.lean:59` (attribute instance) ✓
- `Scheme.Hom.appLE` at `Mathlib/AlgebraicGeometry/Scheme.lean:196` ✓
- `CommRingCat.KaehlerDifferential` at
  `Mathlib/Algebra/Category/ModuleCat/Differentials/Basic.lean:96` ✓
- `IsAffineOpen.isLocalization_basicOpen` — already used by the
  project; verified by analogist iter-121.

### Signature decision: `Hom.appLE` vs `(Hom.appLE _).hom`
The directive's recommended bridge RHS spelled
`CommRingCat.KaehlerDifferential.{u} ((Scheme.Hom.appLE f U V e).hom)`.
This is a typo: `CommRingCat.KaehlerDifferential` takes a `CommRingCat`
morphism (i.e., `Scheme.Hom.appLE f U V e` itself, without `.hom`),
not an underlying `RingHom`. The refactor used the corrected form
`CommRingCat.KaehlerDifferential (Scheme.Hom.appLE f U V e)`. The
underlying carrier type via the `CommRingCat.KaehlerDifferential`
definition (`ModuleCat.of B (_root_.KaehlerDifferential A B)` after
the `.hom.toAlgebra` letI) is identical to the `Ω[B ⁄ A]` notation
elsewhere in the file, so the bridge statement matches
`smooth_locally_free_omega`'s usage.

### Suggested next step for the prover lane
Per directive: target `appLE_isLocalization` (M1.b) as the primary
prover objective. The blueprint § sec:bridge spells out the
four-step strategy (M1.a inline, M1.b two-direction `IsLocalization.of_le`,
M1.c–M1.d inline via `FormallyUnramified.of_isLocalization`, M1.e
rfl + inverse). Closing M1.b (with its algebra-structure letI) plus
the bridge body together is a 100–250 LOC effort estimated at 2–3
prover iters. iter-122 PARTIAL on M1.b is the expected outcome.

### No `archon-protected.yaml` impact
None of the declarations in that file (which are all in
`Genus.lean` / `Jacobian.lean` / `AbelJacobi.lean`) were touched.
File is unchanged.

### No blueprint changes
Per directive's "DO NOT modify the blueprint". The blueprint
chapter `Differentials.tex` § sec:bridge already names
`AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` and
`AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`
in its `\lean{...}` hints, and those resolve to the new declarations.
No follow-up blueprint correction is needed for this refactor.
