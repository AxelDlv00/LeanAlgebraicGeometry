---
author: sync
content_type: definition
created: '2026-08-03T18:38:51'
decl: AlgebraicGeometry.divFamZarAffOfFibrewiseRegularLocalEquations
docstring: 'The widened divisor class represented by a fibrewise-regular, constant-degree
  intrinsic

  local-equation system.'
file: AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjectiveEffectivity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamZarAffOfFibrewiseRegularLocalEquations
type: lean
updated: '2026-08-03T19:06:09'
---
noncomputable def divFamZarAffOfFibrewiseRegularLocalEquations
    (pi : C.left ⟶ P1 k) [IsFinite pi]
    (hreg : ∀ (L : Type u) [Field L] [Algebra k L] [Algebra R L]
      [IsScalarTower k R L], ∀ z : relCurve C L,
      ((relCurve C L).presheaf.germ
        ((d.cover.pullback (relCurveMap C R L)).opens z) z
        ((d.cover.pullback (relCurveMap C R L)).mem_opens z)).hom
        (Scheme.LocalEquations.pullbackEqn (relCurveMap C R L) d z) ∈
          nonZeroDivisors ((relCurve C L).presheaf.stalk z))
    (hdeg : ∀ (L : Type u) [Field L] [Algebra k L] [Algebra R L]
      [IsScalarTower k R L],
      classDeg L (Scheme.CechPic.map (relCurveMap C R L) d.picClass) = (n : ℤ)) :
    DivFamZarAff C R n :=
  divFamZarAff_of_forall_prime_certified_adaptation
    (exists_away_certifiedAff_of_fibrewiseRegular_of_classDeg C n d pi hreg hdeg)

@[simp]