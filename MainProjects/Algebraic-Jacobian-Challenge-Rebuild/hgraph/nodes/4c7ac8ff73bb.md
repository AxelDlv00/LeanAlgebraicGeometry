---
author: sync
content_type: theorem
created: '2026-08-14T07:25:47'
decl: AlgebraicGeometry.canonicalRankOneSection_abel
file: AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.canonicalRankOneSection_abel
type: lean
updated: '2026-08-18T20:51:05'
---
theorem canonicalRankOneSection_abel {T : Over (Spec (.of k))}
    (lam : picDegLayer C (genus C : ℤ) T)
    (hlam : lam ∈ (PicRankOneOpen (divRepAffP1Map C)).obj (op T)) :
    abelDivAff' C (genus C) T (canonicalRankOneSection lam hlam) = lam.1 := by
  refine picEt.ext fun U => ?_
  rw [abelDivAff'_val, canonicalRankOneSection]
  calc
    abelDivAffPlus C Γ(T.left, U.1)
        (canonicalRankOneDivisorOfMem (pi := divRepAffP1Map C)
          (divRepAffP1Map_comp C)
          (picRankOneOpen_map_mem (divRepAffP1Map C)
            (Over.fromSpecAffine T U).op hlam))
        = picEtAffineEquiv C Γ(T.left, U.1)
            ((picDegLayerFunctor C (genus C : ℤ)).map
              (Over.fromSpecAffine T U).op lam).1 :=
          canonicalRankOneDivisorOfMem_abel
            (pi := divRepAffP1Map C) (divRepAffP1Map_comp C) _
    _ = lam.1.1 U := picEtAffineEquiv_map_fromSpecAffine T lam.1 U