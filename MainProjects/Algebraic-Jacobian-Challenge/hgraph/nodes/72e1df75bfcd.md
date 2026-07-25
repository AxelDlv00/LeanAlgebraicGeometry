---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.overResHom_fromGluedHom
docstring: 'The structure morphism of `T|_{W k}` composed with the inverse of

  `fromGlued` is the `k`-th chart morphism of the glue datum.'
file: AlgebraicJacobian/Picard/GrassmannianZariskiSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.overResHom_fromGluedHom
type: lean
updated: '2026-07-26T05:02:39'
---
lemma overResHom_fromGluedHom (k : κ) :
    Scheme.overResHom T (W k) ≫ fromGluedHom W hW = glueChartHom W hW k := by
  apply Over.OverMorphism.ext
  change (W k).ι ≫ inv (opensCover T.left W hW).fromGlued = (covGD W hW).ι k
  rw [IsIso.comp_inv_eq]
  exact (Scheme.Cover.ι_fromGlued (opensCover T.left W hW) k).symm

set_option backward.isDefEq.respectTransparency false in