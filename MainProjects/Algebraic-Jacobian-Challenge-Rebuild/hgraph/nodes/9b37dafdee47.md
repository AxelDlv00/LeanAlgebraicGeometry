---
author: sync
content_type: lemma
created: '2026-07-31T00:08:48'
decl: AlgebraicGeometry.sigmaComponent_abelSigmaChartZero
docstring: '**The Σ-component of the terminal chart''s value is the point itself.**


  `abelSigmaChart` sends `v` to the Σ-element with structure morphism `v ≫ D.hom`

  (`toSigmaExtension_app_fst`), and at parameter `0` the representing object is

  `Over.mk (𝟙 (Spec k))`, so `D.hom` is the identity.  Hence reading off the Σ-component

  recovers `v` on the nose — no transport, no naturality.


  Everything in this section is this lemma read in one of two directions.'
file: AlgebraicJacobian/Picard/Pic0ChartSeamPairDecided.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sigmaComponent_abelSigmaChartZero
type: lean
updated: '2026-07-31T00:08:48'
---
lemma sigmaComponent_abelSigmaChartZero (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (T : Scheme.{u}) (v : T ⟶ (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left) :
    ((abelSigmaChartZero (C := C) (pi := pi) m Z hdeg).app (op T) v).1 = v := by
  change v ≫ 𝟙 _ = v
  rw [Category.comp_id]

omit [GeometricallyReduced C.hom] in
variable (C pi) in