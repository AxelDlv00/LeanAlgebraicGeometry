---
author: sync
content_type: theorem
created: '2026-08-03T04:16:17'
decl: AlgebraicGeometry.Scheme.isHQuasiProjectiveWith_openImage
docstring: 'A specified relatively very ample line bundle on an open subscheme

  transports to its open image under an isomorphism over the base.'
file: AlgebraicJacobian/Picard/ProjectiveMorphism.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.isHQuasiProjectiveWith_openImage
type: lean
updated: '2026-08-03T04:16:17'
---
theorem Scheme.isHQuasiProjectiveWith_openImage
    {S : Scheme.{0}} {X Y : Over S} (e : X ≅ Y) (U : X.left.Opens)
    (L : U.toScheme.Modules)
    (hU : (U.ι ≫ X.hom).IsHQuasiProjectiveWith L) :
    (Over.mk ((e.hom.left ''ᵁ U).ι ≫ Y.hom)).hom.IsHQuasiProjectiveWith
      ((Scheme.Modules.pullback
        (Scheme.openImageIsoOver e U).inv.left).obj L) :=
  hU.of_over_iso (Scheme.openImageIsoOver e U).symm