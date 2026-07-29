---
author: sync
content_type: theorem
created: '2026-07-17T21:01:12'
decl: AlgebraicGeometry.mapAlg_sectionShuffle
docstring: '**The restriction square of the section-ring shuffle**: shuffling commutes
  with

  restriction of sections along an inclusion of opens (the `mapAlg` bilateral square
  of

  B-2, read at the section rings).'
file: AlgebraicJacobian/Picard/PicEtCrossBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mapAlg_sectionShuffle
type: lean
updated: '2026-07-29T15:31:47'
---
theorem mapAlg_sectionShuffle {V W : T.left.Opens} (h : W ≤ V)
    (x : PicEtAff C
      Γ(((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T).left, V)) :
    sectionShuffle k L C T W
        (PicEtAff.mapAlg C
          (Over.resAlgHom
            ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T) h) x)
      = PicEtAff.mapAlg ((baseChange k L).obj C) (Over.resAlgHom T h)
          (sectionShuffle k L C T V x) := by
  letI : Algebra k Γ(T.left, V) := Over.sectionsAlgebra
    ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T) V
  letI : Algebra k Γ(T.left, W) := Over.sectionsAlgebra
    ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T) W
  haveI : IsScalarTower k L Γ(T.left, V) := Over.isScalarTower_sections_map k L T V
  haveI : IsScalarTower k L Γ(T.left, W) := Over.isScalarTower_sections_map k L T W
  exact Over.resAlgHom_map_restrictScalars k L T h
    ▸ PicEtAff.mapAlg_baseFieldShuffle k L C (Over.resAlgHom T h) x