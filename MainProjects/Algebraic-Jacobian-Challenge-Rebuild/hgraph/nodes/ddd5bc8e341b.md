---
author: sync
content_type: theorem
created: '2026-08-14T07:25:47'
decl: AlgebraicGeometry.canonicalRankOneSection_compat
file: AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.canonicalRankOneSection_compat
type: lean
updated: '2026-08-18T20:51:05'
---
private theorem canonicalRankOneSection_compat {T : Over (Spec (.of k))}
    (lam : picDegLayer C (genus C : ℤ) T)
    (hlam : lam ∈ (PicRankOneOpen (divRepAffP1Map C)).obj (op T)) :
    ∀ (U V : T.left.affineOpens) (h : U.1 ≤ V.1),
      DivFamZarAff.mapAlgHom (Over.resAlgHom T h)
          (canonicalRankOneDivisorOfMem (pi := divRepAffP1Map C)
            (divRepAffP1Map_comp C)
            (picRankOneOpen_map_mem (divRepAffP1Map C)
              (Over.fromSpecAffine T V).op hlam))
        = canonicalRankOneDivisorOfMem (pi := divRepAffP1Map C)
            (divRepAffP1Map_comp C)
            (picRankOneOpen_map_mem (divRepAffP1Map C)
              (Over.fromSpecAffine T U).op hlam) := by
  intro U V h
  let fU : overSpec k Γ(T.left, U.1) ⟶ T := Over.fromSpecAffine T U
  let fV : overSpec k Γ(T.left, V.1) ⟶ T := Over.fromSpecAffine T V
  let r : Γ(T.left, V.1) →ₐ[k] Γ(T.left, U.1) := Over.resAlgHom T h
  let lamU : picDegLayer C (genus C : ℤ) (overSpec k Γ(T.left, U.1)) :=
    (picDegLayerFunctor C (genus C : ℤ)).map fU.op lam
  let lamV : picDegLayer C (genus C : ℤ) (overSpec k Γ(T.left, V.1)) :=
    (picDegLayerFunctor C (genus C : ℤ)).map fV.op lam
  have hlamU : lamU ∈ (PicRankOneOpen (divRepAffP1Map C)).obj
      (op (overSpec k Γ(T.left, U.1))) :=
    picRankOneOpen_map_mem (divRepAffP1Map C) fU.op hlam
  have hlamV : lamV ∈ (PicRankOneOpen (divRepAffP1Map C)).obj
      (op (overSpec k Γ(T.left, V.1))) :=
    picRankOneOpen_map_mem (divRepAffP1Map C) fV.op hlam
  have hclass : lamU.1 = picEtMap C (Over.overSpecMap r) lamV.1 := by
    change picEtMap C (Over.fromSpecAffine T U) lam.1 =
      picEtMap C (Over.overSpecMap (Over.resAlgHom T h))
        (picEtMap C (Over.fromSpecAffine T V) lam.1)
    rw [← picEtMap_comp]
    exact congrArg (fun q => picEtMap C q lam.1)
      (Over.fromSpecAffine_resAlgHom h).symm
  have habel : abelDivAffPlus C Γ(T.left, U.1)
      (DivFamZarAff.mapAlgHom r
        (canonicalRankOneDivisorOfMem (pi := divRepAffP1Map C)
          (divRepAffP1Map_comp C) hlamV)) =
      picEtAffineEquiv C Γ(T.left, U.1) lamU.1 := by
    calc
      abelDivAffPlus C Γ(T.left, U.1)
          (DivFamZarAff.mapAlgHom r
            (canonicalRankOneDivisorOfMem (pi := divRepAffP1Map C)
              (divRepAffP1Map_comp C) hlamV))
          = PicEtAff.mapAlg C r
              (abelDivAffPlus C Γ(T.left, V.1)
                (canonicalRankOneDivisorOfMem (pi := divRepAffP1Map C)
                  (divRepAffP1Map_comp C) hlamV)) :=
            (abelDivAffPlus_mapAlgHom r _).symm
      _ = PicEtAff.mapAlg C r
          (picEtAffineEquiv C Γ(T.left, V.1) lamV.1) := by
            rw [canonicalRankOneDivisorOfMem_abel
              (pi := divRepAffP1Map C) (divRepAffP1Map_comp C) hlamV]
      _ = picEtAffineEquiv C Γ(T.left, U.1)
          (picEtMap C (Over.overSpecMap r) lamV.1) :=
            (picEtAffineEquiv_naturality C r lamV.1).symm
      _ = picEtAffineEquiv C Γ(T.left, U.1) lamU.1 := by rw [hclass]
  exact canonicalRankOneDivisorOfMem_unique (pi := divRepAffP1Map C)
    (divRepAffP1Map_comp C) hlamU
    (DivFamZarAff.mapAlgHom r
      (canonicalRankOneDivisorOfMem (pi := divRepAffP1Map C)
        (divRepAffP1Map_comp C) hlamV)) habel