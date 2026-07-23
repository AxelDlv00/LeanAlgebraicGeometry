---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.actApp_sectionsAlgebraMapHom
docstring: 'The compatibility square of a semilinear action, on sections over a stable
  open:

  transporting the structure map along `act γ` twists it by `γ⁻¹` (the same inversion

  as `toSpecAut`, forced by contravariance of taking sections).'
file: AlgebraicJacobian/Picard/GaloisQuotientGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.actApp_sectionsAlgebraMapHom
type: lean
updated: '2026-07-16T21:14:26'
---
lemma actApp_sectionsAlgebraMapHom (γ : L ≃ₐ[K] L) :
    sectionsAlgebraMapHom f U ≫ ρ.actApp hU γ
      = CommRingCat.ofHom (MulSemiringAction.toRingHom (L ≃ₐ[K] L) L γ⁻¹)
          ≫ sectionsAlgebraMapHom f U := by
  rw [sectionsAlgebraMapHom, actApp, Category.assoc,
    Scheme.Hom.appLE_comp_appLE, Scheme.Hom.appLE_congr_hom (ρ.compat γ),
    Scheme.Hom.appLE_congr_hom
      (congrArg (f ≫ ·) (toSpecAut_hom (L ≃ₐ[K] L) L γ)),
    Scheme.Hom.comp_appLE, ← Category.assoc, ← Category.assoc]
  congr 1
  exact (Scheme.ΓSpecIso_inv_naturality
    (CommRingCat.ofHom (MulSemiringAction.toRingHom (L ≃ₐ[K] L) L γ⁻¹))).symm