---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairProj_snd
docstring: The second component of the pair projection is the restricted `(1)`-projection.
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairProj_snd
type: lean
updated: '2026-07-16T21:14:28'
---
lemma AffineCoverMVSquare.pairProj_snd :
    S.pairProj F ≫ ModuleCat.ofHom (LinearMap.snd k _ _)
      = Pi.π (cechTerm S.coverFamily F 1) ![⟨1⟩]
          ≫ F.obj.map (homOfLE S.prodOpens_single₁.ge).op :=
  ModuleCat.hom_ext (LinearMap.snd_prod _ _)