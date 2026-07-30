---
author: sync
content_type: definition
created: '2026-07-30T10:40:20'
decl: AlgebraicGeometry.Scheme.PicScheme.twistTestFunctor
docstring: '**The `γ`-twist of `k''`-tests**: post-compose the structure morphism
  with

  `Spec γ`.


  This is `Over.map` along an **isomorphism** of the base, which is what will make
  the

  twist reversible; it leaves the underlying scheme of a test untouched.'
file: AlgebraicJacobian/Picard/GaloisDescent/PicEtGaloisAction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.twistTestFunctor
type: lean
updated: '2026-07-30T10:40:20'
---
noncomputable abbrev twistTestFunctor (γ : k' ≃ₐ[k] k') :
    Over (Spec (CommRingCat.of k')) ⥤ Over (Spec (CommRingCat.of k')) :=
  Over.map (toSpecAut (k' ≃ₐ[k] k') k' γ).hom