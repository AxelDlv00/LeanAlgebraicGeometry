# Mathlib-analogist directive — iter-215 — d.2 feasibility

## Mode: cross-domain-inspiration

## Structural problem

We need, for a presheaf of commutative rings `R` on the topological site `Opens X` and presheaves
of `R`-modules `F`, `M`, a natural isomorphism identifying the STALK of the (sectionwise, relative)
module-presheaf tensor with the tensor of stalks over the STALK RING:

    (F ⊗ᵖ_R M).stalk x  ≅  (F.stalk x) ⊗_{R.stalk x} (M.stalk x)

and, downstream, the identification of `(F ◁ g)_x` (left-whiskering a morphism `g : M ⟶ N`) with
`LinearMap.lTensor (F.stalk x) (g.stalk x)`. The stalk is a FILTERED COLIMIT over neighborhoods; the
tensor is over a VARYING base ring (the ring `R(U)` changes with `U`, and the colimit ring is
`R.stalk x`). So this is "the stalk functor (a filtered colimit) commutes with the relative tensor
product of modules over a varying ring."

This is ingredient **d.2** of the project's `(J.W).IsMonoidal` build (route (e), file
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`). The prover reports it as "genuinely
Mathlib-absent, the largest piece (~150–250 LOC)." Before we commit multiple prover iters to it, we
want a fresh read on its BUILDABILITY from current Mathlib.

## What I need from you

1. **Building blocks.** What does current Mathlib supply that this can be assembled from? Candidates
   to check and report on (cite file + decl):
   - `TensorProduct` commuting with filtered/directed colimits (e.g. `TensorProduct.directLimit`,
     `Module.DirectLimit`, any `tensorProduct_comm_colimit` / `tensorLeft`/`tensorRight` preserves
     filtered colimits at the `ModuleCat` level).
   - The `PresheafOfModules` stalk: `Mathlib/Algebra/Category/ModuleCat/Stalk.lean` (Andrew Yang) —
     `Module (R.stalk x) (TopCat.Presheaf.stalk M.presheaf x)`, `germ_smul`. How is the stalk module
     structure defined there, and does it expose the colimit presentation we'd tensor through?
   - `Mathlib/Algebra/Category/ModuleCat/Presheaf/Monoidal.lean` (the sectionwise relative tensor)
     and `…/Presheaf/ColimitFunctor.lean` (the colimit functor on PresheafOfModules).
   - Any varying-base "change of rings commutes with colimit/tensor" machinery.

2. **Structural analogues (the cross-domain ask).** Has Mathlib solved the SAME shape — "a colimit
   functor commutes with a tensor / monoidal product" — in a DIFFERENT area (e.g. localization of
   modules as a filtered colimit and its interaction with ⊗; direct limits of algebras; sheafy
   tensor over a fixed ring; the fixed-base presheaf stalk-tensor in `Sites/Point`)? For each: the
   citation, the technique used, and how portable it is to the varying-ring module case.

3. **Verdict on buildability.** Is d.2 (a) a routine assembly from existing Mathlib filtered-colimit
   + tensor lemmas (~150–250 LOC, low risk), (b) buildable but requiring a substantial new
   sub-construction (name it), or (c) blocked on infrastructure that is itself deeply absent (so the
   ~150–250 LOC estimate is optimistic and the lane risks a multi-iter swamp)? This verdict directly
   feeds a continue-vs-escalate decision on the lane.

## Search radius: narrow

(Same general area — algebraic geometry / module categories / colimits — but range across
sub-areas: localization, direct limits, sheaf theory, the fixed-base presheaf monoidal stalk.)

## Failed approaches (for context, do NOT re-suggest)

- Section-level injectivity alone (needs Tor₁ / flatness) — dead end.
- `MonoidalClosed (PresheafOfModules R)` — verified absent.
- Fixed-base `Sites/Monoidal.lean` / `Sites/Point/IsMonoidalW.lean` instances — these are the
  TEMPLATE for the technique but apply only to `Cᵒᵖ ⥤ A` for fixed monoidal-closed `A`, not to
  modules over a varying ring. (We want to port their stalk technique, not reuse the instance.)
