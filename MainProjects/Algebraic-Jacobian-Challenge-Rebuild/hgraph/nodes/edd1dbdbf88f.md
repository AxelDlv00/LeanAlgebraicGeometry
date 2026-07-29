---
author: sync
content_type: theorem
created: '2026-07-29T20:00:06'
decl: AlgebraicGeometry.isLocallySurjective_restrictChart_of_pointwise
docstring: '**The composite**: coverage plus the containment gives the local-surjectivity
  instance

  `pic0RepresentableByOfCharts` consumes *at the restricted atlas* — which is the
  atlas

  `mixedParamRepresentableBy` (`Pic0ChartAtlasParamFree.lean:125`) and every real
  chart family

  is built from.


  Stated because this, not `isLocallySurjective_sigmaDesc_of_pointwise`, is what a
  coverage lane

  owes when the atlas is restricted: the two differ by exactly `hV`.'
file: AlgebraicJacobian/Picard/Pic0ChartAtlasCoupling.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isLocallySurjective_restrictChart_of_pointwise
type: lean
updated: '2026-07-29T20:00:06'
---
theorem isLocallySurjective_restrictChart_of_pointwise {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) (V : ∀ i, (X i).Opens)
    (h : ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : ↥T),
      ∃ (W : T.Opens) (_ : t ∈ W) (i : ι) (x : (W : Scheme.{u}) ⟶ X i),
        (f i).app (op (W : Scheme.{u})) x = (pic0SigmaSheaf C).1.map (W.ι).op s ∧
          Set.range (x.base) ⊆ Set.range ((V i).ι.base)) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun i => restrictChart (f i) (V i))) :=
  isLocallySurjective_sigmaDesc_of_pointwise C _ (liftPointwiseToOpens C f V h)

/-! ## The converse: `hV` is the exact difference, not a convenient extra

A coupling lemma whose hypothesis is stronger than the gap it bridges hides the gap instead of
naming it.  This section rules that out: restricted coverage gives back unrestricted coverage
together with the containment, so `hV` is precisely what separates the two. -/

variable (C) in