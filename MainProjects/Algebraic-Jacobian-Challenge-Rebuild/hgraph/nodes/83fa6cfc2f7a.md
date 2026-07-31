---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.sectionsPushoutIso_tmul_one
file: AlgebraicJacobian/Picard/SectionsDescent.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.Over.sectionsPushoutIso_tmul_one
type: lean
updated: '2026-07-31T20:14:47'
---
private lemma sectionsPushoutIso_tmul_one {U : (XA).Opens} (hU : IsAffineOpen U) (s : Γ(XA, U)) :
    (sectionsPushoutIso (R := R) hU).hom (s ⊗ₜ 1)
      = (C ◁ Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left.appLE U
          ((C ◁ Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left ⁻¹ᵁ U) le_rfl s :=
  congr($((CommRingCat.isPushout_tensorProduct A Γ(XA, U) R).inl_isoIsPushout_hom
    _ _ (isPushout_algebraMap_gen hU)).hom s)