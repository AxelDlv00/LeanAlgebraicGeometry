# Mathlib analogist consult — `gm-grpobj-representable`

## Mode
api-alignment

## Slug
gm-grpobj-representable

## Question

What is the canonical Mathlib idiom for installing the `GrpObj` instance
on `𝔾_m = Spec (k̄[t, t⁻¹])` via the representable-by-units functor
construction? Specifically, the project's
`AlgebraicJacobian/Genus0BaseObjects/Points.lean:251`:

```lean
instance gm_grpObj (kbar : Type u) [Field kbar] : GrpObj (Gm kbar) := sorry
```

has been deferred for 11+ iterations (iter-167 escalation watch, never
fired). It is load-bearing for:

- `gm_smooth` (L255) — which uses `gm_grpObj` to feed
  `smooth_of_grpObj_of_isAlgClosed`.
- The entire Route C base case `morphism_P1_to_grpScheme_const_aux` chain
  (`AbelianVarietyRigidity.lean:144`) which applies
  `hom_additive_decomp_of_rigidity` with `W = Gm`.
- `iotaGm_isDominant` (`AbelianVarietyRigidity.lean:86`) the open immersion
  `Gm ↪ ℙ¹` that the chart-bridge route's density-half closes onto.

## Project artifact(s)

- `AlgebraicJacobian/Genus0BaseObjects/Points.lean:240-251` — declaration
  + docstring outlining the intended `GrpObj.ofRepresentableBy`-via-units
  construction. Body is bare `sorry`.
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean:253-258` — the
  downstream `gm_smooth` instance that consumes `gm_grpObj`.
- `analogies/gm-grpobj-and-friends.md` (if exists) — possibly some prior
  analogist context. Read it before forming the recipe.

## Decisions needed

1. **Is `GrpObj.ofRepresentableBy` the right Mathlib idiom?**
   - Check whether Mathlib has `GrpObj.ofRepresentableBy` at all (the
     project's docstring claims it exists). Use `lean_local_search` /
     `lean_loogle` / `lean_leansearch` to verify.
   - If yes, what's its signature? How does it take the "representable-by-units"
     witness?
   - If no, what's the canonical alternative (`GrpObj.mk_of_iso`, direct
     instance via `CartesianMonoidalCategory`-mul-arrow construction, etc.)?

2. **Is there a Mathlib analogue for `𝔾_m`'s `GrpObj` instance already?**
   - Mathlib has `Mathlib/AlgebraicGeometry/AffineScheme.lean`,
     `Mathlib/AlgebraicGeometry/GroupScheme.lean` (if exists), or
     similar. Does any Mathlib file already install `GrpObj` on a
     `Spec`-of-units construction?
   - If yes, can the project re-export / instantiate from that?

3. **What's the closed body's shape?**
   - Whatever Mathlib idiom you identify, what does the **closed body**
     look like in concrete terms? Cite the lemmas / instances by name and
     give a per-step recipe (no more than 8 steps, each a one-line claim
     about a Mathlib idiom).

4. **Cross-domain comparison (optional)**: is there a Mathlib pattern for
   installing a `MonObj` or `GrpObj` on `Spec (Localization.Away t)` or
   `Spec (FractionRing _)` via the units functor that's already shipped?
   Look in `Mathlib/Algebra/Category/Grp/`, `Mathlib/CategoryTheory/Monoidal/`,
   or `Mathlib/AlgebraicGeometry/GroupScheme/`.

## Project context

Char-general (no `CharZero`). `Gm kbar := Over.mk (Spec.map …) : Over (Spec (.of kbar))`
where the carrier is `Spec (CommRingCat.of (GmRing kbar))`,
`GmRing kbar = Localization.Away (1 : MvPolynomial Unit kbar)` (or the
equivalent `k̄[t, t⁻¹]`). The `GrpObj`-structure should make `(x, y) ↦ xy`
the multiplication, `1` the unit, `x ↦ x⁻¹` the inverse — represented
schematically by maps of `Spec`'s of the localizations.

The strategic stake: this is the LAST piece of the Route C base case
substrate. Without `gm_grpObj`, the `𝔾_m`-scaling shortcut to
`morphism_P1_to_grpScheme_const` can't be invoked. iter-181 RETIRE-OR-ESCALATE
trigger fires on the 2 TEMP axioms in 2 iters; this instance is parallel
substrate that needs resolution.

## Expected output

`analogies/gm-grpobj-representable.md` (persistent file) with:

- Verified Mathlib presence/absence of `GrpObj.ofRepresentableBy` (cite at
  the pinned commit `b80f227`).
- Recipe per Decision 3 above.
- LOC estimate for the closed body.
- Reversal trigger (if the recipe doesn't pan out).

## Cost / scope

Pure read-only analogist consult. Should land in < 10 min. The result
unblocks an iter-180+ prover lane on `gm_grpObj`. NO project edits this
iter beyond the report.
