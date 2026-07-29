---
author: sync
content_type: theorem
created: '2026-07-17T18:01:32'
decl: AlgebraicGeometry.divEq_pullback_awayGluedEquations
docstring: '**Chart restriction of the glued system** (`informal/spec-dd-2.md` §5):
  the pullback

  of `awayGluedEquations` along the open immersion `relCurveMap C R (S i)` is

  divisor-equal to the `i`-th local system.  Pointwise: on the overlap of the glued

  member with the image of the chart member, the transported equations differ by a
  unit

  (the cross unit spread by the Kit engine), and the relation pulls back up the

  immersion, where the transported equation restricts back to the chart equation (the

  immersion round trip).'
file: AlgebraicJacobian/Picard/DivisorFamilyZariskiGlueClass.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divEq_pullback_awayGluedEquations
type: lean
updated: '2026-07-29T15:26:36'
---
theorem divEq_pullback_awayGluedEquations (hg : Ideal.span (Set.range g) = ⊤)
    (hcompat : AwayCompatDivEq S E T) (i : ι) (hreg) :
    Scheme.LocalEquations.DivEq
      ((awayGluedEquations g S E T hg hcompat).pullback (relCurveMap C R (S i)) hreg)
      (E i).eqns := by
  classical
  refine ⟨((awayGluedEquations g S E T hg hcompat).cover.pullback
      (relCurveMap C R (S i))) ⊓ (E i).eqns.cover,
    fun z' => inf_le_left, fun z' => inf_le_right, fun z' => ?_⟩
  -- the downstairs overlap of the glued member with the image of the chart member
  obtain ⟨uO, huO⟩ := Scheme.exists_unit_mul_of_locally_unit_mul
    (X := relCurve C R)
    (V := (awayGluedEquations g S E T hg hcompat).cover.opens
        ((relCurveMap C R (S i)).base z')
      ⊓ relCurveMap C R (S i) ''ᵁ (E i).eqns.cover.opens z')
    (s := ((relCurve C R).presheaf.map (homOfLE inf_le_left).op).hom
      ((awayGluedEquations g S E T hg hcompat).eqn ((relCurveMap C R (S i)).base z')))
    (t := ((relCurve C R).presheaf.map (homOfLE inf_le_right).op).hom
      (((relCurveMap C R (S i)).appIso ((E i).eqns.cover.opens z')).inv.hom
        ((E i).eqns.eqn z')))
    (fun z hz => by
      rw [(relCurve C R).presheaf.germ_res_apply]
      exact germ_awayTransport_mem_nonZeroDivisors S E i z' z hz.2)
    (fun z hz => by
      obtain ⟨W, hWO, hzW, u, hu⟩ := exists_res_awayTransport_eq_unit_mul g S E T
        hcompat
        (inf_le_left :
          (awayGluedEquations g S E T hg hcompat).cover.opens
              ((relCurveMap C R (S i)).base z')
            ⊓ relCurveMap C R (S i) ''ᵁ (E i).eqns.cover.opens z' ≤ _)
        (inf_le_right :
          (awayGluedEquations g S E T hg hcompat).cover.opens
              ((relCurveMap C R (S i)).base z')
            ⊓ relCurveMap C R (S i) ''ᵁ (E i).eqns.cover.opens z' ≤ _)
        z hz
      refine ⟨W, hWO, hzW, u, ?_⟩
      rw [res_res, res_res]
      exact hu)
  -- pull the overlap unit up the immersion
  have hpre : ((awayGluedEquations g S E T hg hcompat).cover.pullback
        (relCurveMap C R (S i))).opens z' ⊓ (E i).eqns.cover.opens z'
      ≤ relCurveMap C R (S i) ⁻¹ᵁ
        ((awayGluedEquations g S E T hg hcompat).cover.opens
            ((relCurveMap C R (S i)).base z')
          ⊓ relCurveMap C R (S i) ''ᵁ (E i).eqns.cover.opens z') :=
    (relCurveMap C R (S i)).le_preimage_inf inf_le_left
      (inf_le_right.trans ((relCurveMap C R (S i)).preimage_image_eq _).ge)
  refine ⟨(relCurveMap C R (S i)).unitsAppLE _ _ hpre uO, ?_⟩
  -- transport the unit relation through `appLE`
  have hkey := congrArg ((relCurveMap C R (S i)).appLE _ _ hpre).hom huO
  rw [map_mul] at hkey
  -- the left factor: the restricted pulled equation
  have hL : ((relCurveMap C R (S i)).appLE _ _ hpre).hom
      (((relCurve C R).presheaf.map (homOfLE inf_le_left).op).hom
        ((awayGluedEquations g S E T hg hcompat).eqn
          ((relCurveMap C R (S i)).base z')))
      = ((relCurve C (S i)).presheaf.map (homOfLE (inf_le_left :
          ((awayGluedEquations g S E T hg hcompat).cover.pullback
              (relCurveMap C R (S i))).opens z' ⊓ (E i).eqns.cover.opens z'
            ≤ _)).op).hom
        (Scheme.LocalEquations.pullbackEqn (relCurveMap C R (S i))
          (awayGluedEquations g S E T hg hcompat) z') := by
    rw [← CommRingCat.comp_apply, Scheme.Hom.map_appLE,
      Scheme.LocalEquations.pullbackEqn_res]
  -- the right factor: the immersion round trip back to the chart equation
  have hR : ((relCurveMap C R (S i)).appLE _ _ hpre).hom
      (((relCurve C R).presheaf.map (homOfLE inf_le_right).op).hom
        (((relCurveMap C R (S i)).appIso ((E i).eqns.cover.opens z')).inv.hom
          ((E i).eqns.eqn z')))
      = ((relCurve C (S i)).presheaf.map (homOfLE (inf_le_right :
          ((awayGluedEquations g S E T hg hcompat).cover.pullback
              (relCurveMap C R (S i))).opens z' ⊓ (E i).eqns.cover.opens z'
            ≤ _)).op).hom ((E i).eqns.eqn z') := by
    rw [← CommRingCat.comp_apply, Scheme.Hom.map_appLE,
      Scheme.Hom.appIso_inv_appLE_apply]
  rw [hL, hR] at hkey
  exact hkey

/-! ## The class-level assembly -/