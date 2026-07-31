---
author: sync
content_type: theorem
created: '2026-07-31T19:55:23'
decl: AlgebraicGeometry.FiberCoordinateData.uniformBaseDivisor_fixedCoordinate
file: AlgebraicJacobian/RiemannRoch/Ledger/FixedFiberDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.uniformBaseDivisor_fixedCoordinate
type: lean
updated: '2026-07-31T19:55:23'
---
theorem uniformBaseDivisor_fixedCoordinate :
    UniformBaseDivisor C (fixedCoordinateDegree C) := by
  apply uniformBaseDivisor_of_exists_deg_le C
  intro κ _ _
  letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
    .ofHom (Scheme.baseChangeField C κ).hom
  haveI : SmoothOfRelativeDimension 1
      ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
  have hbase :
      letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
      haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
        inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
      Subsingleton (Sheaf.HModule (C.left.divisorSheaf k
        (genus C • (fixedCoordinateData C).coordinateWeilDivisor (K := k))) 1) := by
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    simpa only [fixedCoordinateData,
      FiberCoordinateData.coordinateWeilDivisor_ofMap] using
      subsingleton_hModule_divisorSheaf_one_genus_smul_fiber_curve C
        (fixedFiniteMapToP1 C) (fixedFiniteMapToP1_comp_structureMap C)
  have hvan := subsingleton_coordinate_baseChange_of_base κ
    (fixedCoordinateData C) (genus C) hbase
  have hdeg := degree_coordinate_baseChange_eq κ
    (fixedCoordinateData C) (genus C) hbase
  refine ⟨genus C • ((fixedCoordinateData C).baseChangeField κ).coordinateWeilDivisor,
    hvan, ?_⟩
  simpa only [fixedCoordinateDegree] using hdeg.le