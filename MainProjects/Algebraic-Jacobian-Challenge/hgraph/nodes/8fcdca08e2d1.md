---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.overlapCocycleComponent_comp_ne
docstring: 'The diagonal components of the overlap cocycle vanish, also after composing
  with

  a further restriction.'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.overlapCocycleComponent_comp_ne
type: lean
updated: '2026-07-24T03:02:13'
---
lemma AffineCoverMVSquare.overlapCocycleComponent_comp_ne
    {j : Fin 2 → ULift.{u} (Fin 2)} (h1 : j ≠ ![⟨0⟩, ⟨1⟩]) (h2 : j ≠ ![⟨1⟩, ⟨0⟩])
    {W : TopologicalSpace.Opens C.left.toTopCat}
    (hW : W ≤ ∏ᶜ ((FormalCoproduct.mk _ S.coverFamily).obj ∘ j)) :
    S.overlapCocycleComponent F j ≫ F.obj.map (homOfLE hW).op = 0 := by
  simp only [overlapCocycleComponent, dif_neg h1, dif_neg h2, zero_comp]