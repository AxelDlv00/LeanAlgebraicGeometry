# Mathlib Analogist Report

## Mode
api-alignment (with cross-domain-inspiration follow-on)

## Slug
lane-a3i-stacks-04kv

## Iteration
195

## Question

Does Mathlib have the iff-direction of Stacks 037Q (or Stacks
04KU — connected `k`-scheme with a `k`-rational section is
geometrically connected) that Lane A.3.i needs to close the
sorry inside `geometricallyConnected_of_connected_of_section`
(`AlgebraicJacobian/Picard/IdentityComponent.lean:382-479`)? If
not directly, does it have the Stacks 04KV substrate or a
field-tensor-product criterion that the project can wire up?
And if not either, what cross-domain analogue suggests the
cheapest port?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Stacks 04KU (`section ⟹ geometrically connected`) lemma in Mathlib | NEEDS_MATHLIB_GAP_FILL | critical |
| Stacks 037Q iff-direction (`alg-closed-in iff geom. conn.`) | NEEDS_MATHLIB_GAP_FILL | critical |
| Stacks 04KV (reduction to finite separable extensions) | NEEDS_MATHLIB_GAP_FILL | critical |
| Field-tensor-product criterion (`alg-closed-in + finite separable ⟹ IsDomain (K ⊗ k')`) | NEEDS_MATHLIB_GAP_FILL | informational |
| Mathlib's `GeometricallyConnected` framing for the project's helper | PROCEED | informational |

## Informational

- **Mathlib's `GeometricallyConnected` framing is the right API target.**
  The class `AlgebraicGeometry.GeometricallyConnected`
  (`Mathlib/AlgebraicGeometry/Geometrically/Connected.lean:39-41`)
  plus the reduction
  `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms`
  (`Geometrically/Basic.lean:136-144`) and the pullback-connectedness
  instance (`Connected.lean:100-106`) are EXACTLY the shape the
  project's helper consumes; the iter-194 prover's body restructure
  has already exposed the precise pullback-connectedness gap.
- **The four gaps (037Q, 04KU, 04KV, field-tensor-product) are
  Mathlib-mergeable** and naturally land as a Mathlib PR cluster
  in `Mathlib/AlgebraicGeometry/Geometrically/Connected.lean` and
  `Mathlib/FieldTheory/LinearDisjoint.lean`. The project's
  `geometricallyConnected_of_connected_of_section` is the right
  Mathlib-shape lemma and would be a ~10 LOC consumer of the
  upstream lemma once landed.
- **Existing Mathlib substrate the planner should know about:**
  - `Algebra.TensorProduct.isField_of_isAlgebraic`
    (`Mathlib/FieldTheory/LinearDisjoint.lean:698-711`) — does the
    `IsDomain ⟹ IsField` half assuming one side is algebraic, but
    takes `IsDomain (E ⊗ K)` as a hypothesis.
  - `Subalgebra.LinearDisjoint.isDomain_of_injective`
    (`Mathlib/RingTheory/LinearDisjoint.lean`) — provides the
    `IsDomain` for linearly disjoint subalgebras, but needs the
    linear-disjointness witness which is the missing piece.
  - `Topology.IsCoinducing.connectedComponentsHomeomorph`
    (`Mathlib/Topology/Homeomorph/Lemmas.lean:572-580`) —
    topological-side building block for descent of connected
    components along quotient-shaped maps.
  - `AlgebraicGeometry.Flat.surjective_descendsAlong_surjective_inf_flat_inf_quasicompact`
    (`Mathlib/AlgebraicGeometry/Morphisms/FlatDescent.lean`) —
    surjective property descends along fpqc covers; useful for the
    Stacks 02LB part of Route A.

## Recommendation to the planner

This is a four-iter CHURNING signal (sorry 5 → 7 → 8 → 9; net +4
over the window) that the substrate is genuinely upstream. Three
options, ranked:

1. **(Strongly recommended) Park Lane A.3.i; file a Mathlib PR
   for Stacks 04KU.** Once the upstream lemma lands, Lane A.3.i
   reactivates as a 0-10 LOC re-export shim. The Mathlib PR is
   sized at ~350 LOC across Route B in
   `analogies/lane-a3i-stacks-04kv.md`. **This is the iter-200 sweep's
   intended corrective**; dispatching it 5 iters early (this consult)
   simply confirms the upstream-gap diagnosis.
2. **Project-side Route B build** (~350-450 LOC across 3-4 files,
   3-5 iters): construct the substrate inside a new file
   `AlgebraicJacobian/Picard/IdentityComponent_StacksSubstrate.lean`
   so it can be lifted to a Mathlib PR after landing project-side.
   Accept this only if the user is willing to absorb the substrate
   build inside the project.
3. **USER-escalate.** Appropriate if the user has a preference
   between options 1 and 2 or wants to discuss the Mathlib PR
   timeline.

The persistent file at `analogies/lane-a3i-stacks-04kv.md`
documents the full substrate map, the field-theoretic / topological
analogues, and a concrete 3-iter substrate-build itinerary for
option 2. **Do NOT continue iter-196 prover work on the inline
sorry inside `geometricallyConnected_of_connected_of_section`** —
the CHURNING is structural, not tactical.

## Persistent file
- `analogies/lane-a3i-stacks-04kv.md` — full substrate map, Route A
  vs Route B project-build estimates, cross-domain analogues.

Overall verdict: NEEDS_MATHLIB_GAP_FILL across four discrete
Stacks substrates; recommend option 1 (park Lane A.3.i + file
Mathlib PR for Stacks 04KU) given the four-iter CHURNING.
