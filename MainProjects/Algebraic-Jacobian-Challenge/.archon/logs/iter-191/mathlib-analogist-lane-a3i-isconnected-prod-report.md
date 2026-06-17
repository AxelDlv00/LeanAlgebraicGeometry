# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
lane-a3i-isconnected-prod

## Iteration
191

## Structural problem

For a group object `G` in `Sch/k` with connected identity component
`G^0 ⊂ G` carrying a `k`-rational identity section, the project needs (i)
`G^0 ×_k G^0` to be connected as a topological space (substrate for the
multiplication morphism restricting to `G^0 × G^0 → G^0`), and (ii) a
`GrpObj`-structure on `G^0` inherited from `GrpObj G` through the open
immersion `G^0 ↪ G`. Sub-question (i) is the EGA IV₂ 4.5.8 step that has
blocked four iters; sub-question (ii) is a bridging concern between the
project's `Over.mk (pullback.snd _ _)` shape and Mathlib's `asOver M S`
shape via `OverClass`.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Mathlib/AlgebraicGeometry/Geometrically/Connected.lean:100` (`ConnectedSpace (pullback f g)` instance) + `UniversallyOpen.lean:149` (`[IsIntegral Y] [Subsingleton Y] → UniversallyOpen f`) | algebraic geometry / scheme theory | medium | ANALOGUE_FOUND |
| `Mathlib/CategoryTheory/Monoidal/Cartesian/Over.lean:312` (`grpObjMkPullbackSnd`) | category theory (cartesian monoidal) | low | ANALOGUE_FOUND |
| `Mathlib/Topology/Algebra/Group/Basic.lean:740` (`Subgroup.connectedComponentOfOne` with one-coordinate-continuity technique) | topology / topological groups | high | PARTIAL_ANALOGUE |

## Top suggestion

**The iter-190 directive's framing is mistaken**: the EGA IV₂ 4.5.8
substrate the project planned to build (`Scheme.isConnected_pullback_of_isGeometricallyConnected`,
estimated 80–150 LOC at iter-189) is **already in Mathlib at b80f227** as
the instance at `Mathlib/AlgebraicGeometry/Geometrically/Connected.lean:100-102`:

> `instance [GeometricallyConnected f] [UniversallyOpen f] [ConnectedSpace Y] : ConnectedSpace ↥(pullback f g)`

paired with the auxiliary instance at
`Mathlib/AlgebraicGeometry/Morphisms/UniversallyOpen.lean:149-150`:

> `instance (priority := low) [IsIntegral Y] [Subsingleton Y] : UniversallyOpen f`

These two combine to give: for any morphism `f : X ⟶ Spec k` with
`GeometricallyConnected f` and `ConnectedSpace X`, the pullback
`X ×_{Spec k} X` is `ConnectedSpace`. The `UniversallyOpen` premise is
discharged automatically because `Spec k` is integral and a topological
subsingleton (so the second instance fires); the `ConnectedSpace G^0`
premise is by-construction (G^0 is literally the topological connected
component of the identity point, and the open-subscheme topology coincides
with the subspace topology).

The ONLY substrate gap that remains is establishing
`GeometricallyConnected (IdentityComponent G).hom`. This is **Stacks 04KU
/ EGA IV₂ 4.5.14** ("a connected scheme with a k-rational point is
geometrically connected"), which Mathlib does not yet have at b80f227.
The planner should commit iter-191 to building exactly one project-side
helper:

> `geometricallyConnected_of_connected_of_section : ∀ {X : Scheme} {k : Type u} [Field k] (f : X ⟶ Spec (.of k)) (s : Spec (.of k) ⟶ X), s ≫ f = 𝟙 _ → ConnectedSpace X → GeometricallyConnected f`

First call site: `AlgebraicJacobian/Picard/IdentityComponent.lean:332`
(`isSubgroupHomomorphism`). The helper is one declaration in one file,
estimated **80–120 LOC** (matches the iter-189 prover estimate for the
substrate it was planning to build — but now the budget buys a clean
upstream-able lemma instead of pullback-connectedness machinery the
project would have duplicated).

**Secondary**: for the `GrpObj` inheritance in `baseChangeIso`, the
planner should consume `grpObjMkPullbackSnd` from
`Mathlib/CategoryTheory/Monoidal/Cartesian/Over.lean:312`, **not** the
scheme-side `Scheme.GrpObjAsOverPullback` (which is `asOver`-wrapped and
would force `OverClass` plumbing). The category-theory version's
conclusion is `GrpObj (Over.mk (pullback.snd f g))` — the project's exact
shape. **~10–20 LOC** of plumbing in `baseChangeIso`.

**Total project-side budget for the substrate gap**: ~100–140 LOC across
two files (the new helper in a fresh file like
`AlgebraicJacobian/Picard/GeometricallyConnectedSection.lean`, plus the
plumbing in `IdentityComponent.lean`). The first file is upstream-able
to Mathlib once landed.

## Discarded

- A direct port of the topological-group `mul_mem_connectedComponent_one`
  technique (which sidesteps "G × G connected" via one-coordinate
  continuity): cannot replace the substrate because `|G^0 ×_k G^0|`
  strictly contains `|G^0| × |G^0|` over non-algebraically-closed `k`, so
  set-level continuity arguments on the product topology don't certify
  the scheme-level factoring through `G^0`. (See PARTIAL_ANALOGUE row in
  the analogy file for the architectural insight this analogue still
  provides — separating the carrier-level closure-under-mul obligation
  from the scheme-level factoring.)

- An attempt to derive `GeometricallyConnected (IdentityComponent G).hom`
  from `GeometricallyIrreducible (IdentityComponent G).hom`: Mathlib does
  not have the implication instance at b80f227, and even with a project-side
  ~10-LOC bridge instance, the path would be circular because the project's
  `GeometricallyIrreducible` proof goes via the group-translation argument
  that depends on `isSubgroupHomomorphism` (which depends on the substrate
  in question). The Stacks 04KU helper severs this circular dependency by
  routing through "connected + section" instead of "geometrically
  irreducible".

## Persistent file
- `analogies/lane-a3i-isconnected-prod.md` — analogue list captured for
  future iters.

Overall verdict: **substrate is OWNED in Mathlib** — the project needs
one ~100-LOC Stacks-04KU helper plus ~20 LOC of `Over.mk` plumbing, not
the 80–150 LOC custom substrate the iter-189 prover estimated.
