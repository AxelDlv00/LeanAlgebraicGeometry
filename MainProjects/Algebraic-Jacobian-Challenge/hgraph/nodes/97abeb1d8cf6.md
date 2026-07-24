---
author: sync
content_type: lemma
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairComponent_eq₁'
docstring: The `(1)`-component of the pair lift, uncomposed form.
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairComponent_eq₁'
type: lean
updated: '2026-07-24T17:02:57'
---
lemma AffineCoverMVSquare.pairComponent_eq₁' :
    S.pairComponent F ![⟨1⟩]
      = ModuleCat.ofHom (LinearMap.snd k _ _)
          ≫ F.obj.map (homOfLE (le_of_eq S.prodOpens_single₁)).op := by
  unfold pairComponent
  rw [dif_neg (by decide), dif_pos rfl]