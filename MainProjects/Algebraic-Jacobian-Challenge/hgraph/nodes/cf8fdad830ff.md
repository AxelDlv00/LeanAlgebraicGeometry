---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.baseChange_bridge
docstring: '**Base-change bridge to the localised cocycle, matrix form** (`lem:gr_baseChange_bridge`):

  over the triple overlap `V_IJK` the three geometrically base-changed Cramer inverses
  satisfy

  the multiplicative cocycle. The three projection bridges rewrite each base-changed
  matrix as

  the σ-image (`tripleOverlapSections`) of the corresponding L1 matrix, and the matrix-level

  cocycle `bundleTransition_cocycle_matrix` transports along the ring homomorphism
  σ.

  Project-local — this is the (b)-step of the bundle cocycle.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.baseChange_bridge
type: lean
updated: '2026-07-16T21:14:27'
---
theorem baseChange_bridge (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (CommRingCat.Hom.hom (Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r J K hJ hK))))
          (chartTransition' d r I J K hI hJ hK ≫
            Limits.pullback.fst (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI)))).mapMatrix
        ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
            (minorDet d r J K hJ hK)))).inv.hom.mapMatrix (universalMinorInv d r J K hJ hK))
      * (CommRingCat.Hom.hom (Scheme.Hom.appTop
            (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ))))
            (Limits.pullback.fst (chartIncl d r I J hI hJ)
              (chartIncl d r I K hI hK)))).mapMatrix
          ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
              (minorDet d r I J hI hJ)))).inv.hom.mapMatrix (universalMinorInv d r I J hI hJ))
      = (CommRingCat.Hom.hom (Scheme.Hom.appTop
            (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I K hI hK))))
            (Limits.pullback.snd (chartIncl d r I J hI hJ)
              (chartIncl d r I K hI hK)))).mapMatrix
          ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
              (minorDet d r I K hI hK)))).inv.hom.mapMatrix
            (universalMinorInv d r I K hI hK)) := by
  have hL := congrArg CommRingCat.Hom.hom (baseChange_bridge_left d r I J K hI hJ hK)
  have hR := congrArg CommRingCat.Hom.hom (baseChange_bridge_right d r I J K hI hJ hK)
  have hT := congrArg CommRingCat.Hom.hom (baseChange_bridge_transition d r I J K hI hJ hK)
  simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom] at hL hR hT
  -- collapse the iterated `mapMatrix`s into single `Matrix.map`s along composite ring homs,
  -- rewrite the composites through the three bridges, and split off the σ-factor
  simp only [RingHom.mapMatrix_apply, Matrix.map_map, ← RingHom.coe_comp, hL, hR, hT]
  -- split off exactly the outer σ-layer of each factor, recombine the product under σ, and
  -- close by the matrix cocycle L1; a `calc` keeps every sub-goal freshly elaborated (the
  -- carrier representations `↥(of R)` vs `R` block positional `rw` on the simp-produced goal)
  calc (universalMinorInv d r J K hJ hK).map
          ⇑((CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)).comp
            ((cocycleΘIJ d r I J K hI hJ hK).comp
              (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))) *
        (universalMinorInv d r I J hI hJ).map
          ⇑((CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)).comp
            (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)))
      = ((universalMinorInv d r J K hJ hK).map
            ⇑((cocycleΘIJ d r I J K hI hJ hK).comp
              (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))).map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)) *
        ((universalMinorInv d r I J hI hJ).map
            ⇑(awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))).map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)) := by
        simp only [RingHom.coe_comp, Matrix.map_map]
    _ = ((universalMinorInv d r J K hJ hK).map
            ⇑((cocycleΘIJ d r I J K hI hJ hK).comp
              (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))) *
          (universalMinorInv d r I J hI hJ).map
            ⇑(awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))).map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)) :=
        Matrix.map_mul.symm
    _ = ((universalMinorInv d r I K hI hK).map
            ⇑(awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))).map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)) :=
        congrArg (fun N => N.map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)))
          (bundleTransition_cocycle_matrix d r I J K hI hJ hK)
    _ = (universalMinorInv d r I K hI hK).map
          ⇑((CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)).comp
            (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))) := by
        simp only [RingHom.coe_comp, Matrix.map_map]

set_option maxHeartbeats 1600000 in
-- The endpoint-cast collapses rewrite under the `X.Modules` diamond on the heavy
-- triple-overlap localisation objects; the raised limit covers the `isDefEq` cost
-- (the Cells `chartTransition'_fac` precedent).