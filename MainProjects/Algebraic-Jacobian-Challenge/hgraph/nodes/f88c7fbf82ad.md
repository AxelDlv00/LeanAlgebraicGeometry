---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.overlapCocycleComponent_eq_zero
docstring: The diagonal components of the overlap cocycle vanish (uncomposed form).
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.overlapCocycleComponent_eq_zero
type: lean
updated: '2026-07-16T21:14:28'
---
lemma AffineCoverMVSquare.overlapCocycleComponent_eq_zero
    {j : Fin 2 → ULift.{u} (Fin 2)} (h1 : j ≠ ![⟨0⟩, ⟨1⟩]) (h2 : j ≠ ![⟨1⟩, ⟨0⟩]) :
    S.overlapCocycleComponent F j = 0 := by
  unfold overlapCocycleComponent
  rw [dif_neg h1, dif_neg h2]