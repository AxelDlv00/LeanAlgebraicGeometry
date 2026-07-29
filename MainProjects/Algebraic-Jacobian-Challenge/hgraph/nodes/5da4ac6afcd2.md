---
author: sync
content_type: theorem
created: '2026-07-29T23:41:45'
decl: AlgebraicGeometry.Scheme.singleton_pullback_mem_etalePrecoverage
docstring: 'The base-changed cover, as an étale cover of the *underlying scheme* of
  a

  slice object `T`. Restatement of §3 in presieve form.'
file: AlgebraicJacobian/Picard/EtaleFieldCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.singleton_pullback_mem_etalePrecoverage
type: lean
updated: '2026-07-29T23:41:45'
---
theorem singleton_pullback_mem_etalePrecoverage (T : Over (Spec (CommRingCat.of k))) :
    Presieve.singleton
        (pullback.fst T.hom (Spec.map (CommRingCat.ofHom (algebraMap k k')))) ∈
      Scheme.precoverage @Etale T.left := by
  haveI := etale_specMap_algebraMap k k'
  haveI : Surjective (Spec.map (CommRingCat.ofHom (algebraMap k k'))) :=
    surjective_specMap_algebraMap k k'
  rw [Scheme.singleton_mem_precoverage_iff]
  exact ⟨Surjective.surj
    (f := pullback.fst T.hom (Spec.map (CommRingCat.ofHom (algebraMap k k')))),
    inferInstance⟩