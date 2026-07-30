---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.P1.fromSpecChart_units
docstring: '**The gluing identity**: for a unit `u` of `A`, the morphism `[1 : u]`
  through chart `0`

  agrees with the morphism `[u⁻¹ : 1]` through chart `1`.  Both factor through the
  chart

  overlap `D₊(X₀X₁)`, where they are induced by the same ring homomorphism, namely
  the

  localization lift sending the overlap coordinate `T = X₁/X₀` to `u`.'
file: AlgebraicJacobian/Curve/P1Points.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.P1.fromSpecChart_units
type: lean
updated: '2026-07-30T15:27:58'
---
theorem fromSpecChart_units (u : Aˣ) :
    fromSpecChart k ρ 0 (u : A) = fromSpecChart k ρ 1 ((u⁻¹ : Aˣ) : A) := by
  have hunit : IsUnit ((chartEval k ρ 0 (u : A)).hom (chartCoord k 0 1)) := by
    rw [chartEval_chartCoord k ρ fin_zero_ne_one]
    exact u.isUnit
  set ψ : Away 𝒜 ((X 0 : MvPolynomial (Fin 2) k) * X 1) →+* A :=
    IsLocalization.Away.lift (chartCoord k 0 1) hunit with hψ
  -- `ψ` restricted to the left chart is the evaluation at `u`.
  have hleft : ψ.comp (awayToOverlapLeft k) = (chartEval k ρ 0 (u : A)).hom := by
    refine RingHom.ext fun z => ?_
    rw [RingHom.comp_apply, ← algebraMap_awayToOverlapLeft]
    exact IsLocalization.Away.lift_eq (chartCoord k 0 1) hunit z
  have hTu : ψ (awayToOverlapLeft k (chartCoord k 0 1)) = (u : A) :=
    (RingHom.congr_fun hleft (chartCoord k 0 1)).trans
      (chartEval_chartCoord k ρ fin_zero_ne_one (u : A))
  -- `ψ` sends the coordinate of the right chart to `u⁻¹`.
  have hSu : ψ (awayToOverlapRight k (chartCoord k 1 0)) = ((u⁻¹ : Aˣ) : A) := by
    have hmul := congrArg ψ (awayToOverlap_mul_eq_one k)
    rw [map_mul, map_one, hTu] at hmul
    exact (Units.inv_eq_of_mul_eq_one_right hmul).symm
  -- `ψ` restricted to the right chart is the evaluation at `u⁻¹`.
  have hbase : (ψ.comp (awayToOverlapRight k)).comp (algebraMap k (Away 𝒜 (X 1))) = ρ.hom := by
    refine RingHom.ext fun c => ?_
    rw [RingHom.comp_apply, RingHom.comp_apply, awayToOverlapRight_algebraMap,
      ← awayToOverlapLeft_algebraMap, ← RingHom.comp_apply, hleft]
    exact chartEval_algebraMap k ρ 0 (u : A) c
  have hright : ψ.comp (awayToOverlapRight k) = (chartEval k ρ 1 ((u⁻¹ : Aˣ) : A)).hom := by
    refine RingHom.ext fun z => ?_
    obtain ⟨p, rfl⟩ := polyToAway_surjective k fin_one_ne_zero z
    rw [chartEval_apply, awayToPoly_polyToAway_apply k fin_one_ne_zero]
    change (ψ.comp (awayToOverlapRight k)) (Polynomial.aeval (chartCoord k 1 0) p) = _
    rw [Polynomial.aeval_def, Polynomial.hom_eval₂, hbase, RingHom.comp_apply, hSu]
  -- Both morphisms factor through the overlap chart via `ψ`.
  have hfactor₀ : chartEval k ρ 0 (u : A) =
      CommRingCat.ofHom (awayToOverlapLeft k) ≫ CommRingCat.ofHom ψ := by
    ext z
    exact (RingHom.congr_fun hleft z).symm
  have hfactor₁ : chartEval k ρ 1 ((u⁻¹ : Aˣ) : A) =
      CommRingCat.ofHom (awayToOverlapRight k) ≫ CommRingCat.ofHom ψ := by
    ext z
    exact (RingHom.congr_fun hright z).symm
  rw [fromSpecChart, fromSpecChart, hfactor₀, hfactor₁, Spec.map_comp, Spec.map_comp,
    Category.assoc, Category.assoc, SpecMap_awayToOverlapLeft_chartι,
    SpecMap_awayToOverlapRight_chartι]

/-! ### The image of a transcendental point -/