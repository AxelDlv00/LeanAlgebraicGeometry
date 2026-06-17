# Mathlib-analogist directive — iter-006 (D3′ route)

## Mode: cross-domain-inspiration

## Structural problem
We must prove a COMPOSITE-ADJUNCTION UNIT COCYCLE: the associativity/coherence identity
of the unit of `sheafification ∘ pullback` viewed as a composite of LEFT ADJOINTS, in
`AlgebraicGeometry.Scheme.Modules` (presheaves/sheaves of modules over a scheme). Concretely,
`sheafificationCompPullback_comp_tail` (in `TensorObjSubstrate.lean` ~L2467) is the residual
"tail" of `sheafificationCompPullback_comp`, an identity equating two factorisations of the
oplax-monoidal comparison `δ` of a composite of left adjoints (`Functor.OplaxMonoidal.comp_δ`)
with the adjunction-mate identity through `conjugateEquiv` (pullbackComp ↔ pushforwardComp).
The downstream consumer `pullbackTensorMap_restrict` (~L2824) then splices a δ-square into a
long composite. The blocker is the DEPENDENT REWRITE: splicing the local δ-square factorisation
(`hδ` helper) into the big composite needs an explicit `congrArg`/`conv` bridge that never lands.

## Failed approaches
- Direct `rw`/`erw` of the δ-square into the composite — the dependent-type indices
  (`eqToHom` of base-map equalities, `Over.map`/opensFunctor reindex) block the rewrite.
- `congrArg`/`conv` to navigate to the δ-square subterm — does not splice; the motive is
  ill-typed under the dependent composite.
- Re-proving `sheafificationCompPullback_comp` wholesale via surjective/injective reduction
  of `leftAdjointCompNatTrans_assoc`/`conjugateEquiv` (recipe d3-mate271.md) — reduction
  opens but the final coherence step is the same dependent δ-splice.

## Search radius: narrow
Same general area (category theory / sheaves / adjunctions in Mathlib), different sub-area.
Find how Mathlib proves an analogous COMPOSITE-ADJUNCTION coherence / unit cocycle WITHOUT
dependent-rewrite hell — e.g. `CategoryTheory.SheafOfModules.pullback_assoc`,
`Adjunction.comp` unit/counit coherence, `conjugateEquiv`/mate naturality (Mates.lean),
`Functor.OplaxMonoidal.comp_δ` coherence, or pseudofunctor `pullbackComp` cocycle proofs.
Return the Mathlib citation, the technique that AVOIDS splicing a dependent δ-square by
`congrArg`/`conv` (e.g. whisker + monoidal coherence, `conjugateEquiv.injective`, naturality
of the mate at the morphism level), and a concrete port for our two holes.
