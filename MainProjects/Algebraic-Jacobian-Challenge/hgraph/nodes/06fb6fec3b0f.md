---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.existence_chart_kpoint_eq
docstring: '**E4 K-point identity** (top-triangle core of `lem:gr_existence_lift`):
  for a field `K`,

  chart indices `I, J`, a ring hom `f : R^I → K` under which the minor `P^I_J` is
  a unit, the

  transported `K`-point `g := f'' ∘ θ̃_{I,J}` (with `f'' := IsLocalization.Away.lift
  f along P^I_J`)

  presents the *same* `K`-point through chart `J` as `f` does through chart `I`:

  `Spec.map g ≫ ι_J = Spec.map f ≫ ι_I`. Proved by the glue condition

  (`t_{I,J} ≫ ι_{J,I} ≫ ι_J = ι_{I,J} ≫ ι_I`), the comorphism identity

  `chartTransition_comp_chartIncl`, and `IsLocalization.Away.lift_comp`. Project-local:
  the

  geometric core of step E4 of the valuative-criterion existence argument (Nitsure
  §1).'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.existence_chart_kpoint_eq
type: lean
updated: '2026-07-16T21:14:27'
---
theorem existence_chart_kpoint_eq (d r : ℕ) {K : Type} [Field K] (I J : (theGlueData d r).J)
    (f : MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ →+* K)
    (hf : IsUnit (f (minorDet d r I.1 J.1 I.2 J.2))) :
    Spec.map (CommRingCat.ofHom
        ((IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
          (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom)) ≫ (theGlueData d r).ι J
      = Spec.map (CommRingCat.ofHom f) ≫ (theGlueData d r).ι I := by
  set f' : Localization.Away (minorDet d r I.1 J.1 I.2 J.2) →+* K :=
    IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf with hf'def
  -- `ofHom (f' ∘ θ̃) = ofHom θ̃ ≫ ofHom f'`, so `Spec.map (ofHom (f' ∘ θ̃))`
  -- `= Spec.map (ofHom f') ≫ Spec.map (ofHom θ̃)`.
  rw [show CommRingCat.ofHom (f'.comp (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom)
        = CommRingCat.ofHom (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom ≫ CommRingCat.ofHom f'
      from by rw [← CommRingCat.ofHom_comp], Spec.map_comp, Category.assoc,
    ← chartTransition_comp_chartIncl d r I.1 J.1 I.2 J.2]
  -- `Spec.map (ofHom f') ≫ (t_{I,J} ≫ ι_{J,I}) ≫ ι_J`; apply the glue condition.
  have hglue : (chartTransition d r I.1 J.1 I.2 J.2 ≫ chartIncl d r J.1 I.1 J.2 I.2)
        ≫ (theGlueData d r).ι J
      = chartIncl d r I.1 J.1 I.2 J.2 ≫ (theGlueData d r).ι I := by
    rw [Category.assoc]; exact (theGlueData d r).glue_condition I J
  -- The glue step (via `congrArg` — `rw`/`Category.assoc`/`Spec.map_comp` are blocked by the
  -- Scheme-category instance diamond on these heavy localisation objects, as in
  -- `chartTransition'_fac`; the whole tail is therefore term-mode).
  refine (congrArg (Spec.map (CommRingCat.ofHom f') ≫ ·) hglue).trans ?_
  -- `Spec.map (ofHom f') ≫ ι_{I,J} = Spec.map (ofHom f)`, via `f' ∘ (R^I → R^I_J) = f`.
  have hfI : Spec.map (CommRingCat.ofHom f') ≫ chartIncl d r I.1 J.1 I.2 J.2
      = Spec.map (CommRingCat.ofHom f) := by
    have e1 : CommRingCat.ofHom (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
          (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))) ≫ CommRingCat.ofHom f'
        = CommRingCat.ofHom f := by
      rw [← CommRingCat.ofHom_comp]
      exact congrArg CommRingCat.ofHom (IsLocalization.Away.lift_comp _ hf)
    calc Spec.map (CommRingCat.ofHom f') ≫ chartIncl d r I.1 J.1 I.2 J.2
        = Spec.map (CommRingCat.ofHom (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
              (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))) ≫ CommRingCat.ofHom f') :=
          (Spec.map_comp _ _).symm
      _ = Spec.map (CommRingCat.ofHom f) := congrArg Spec.map e1
  calc Spec.map (CommRingCat.ofHom f') ≫ chartIncl d r I.1 J.1 I.2 J.2 ≫ (theGlueData d r).ι I
      = (Spec.map (CommRingCat.ofHom f') ≫ chartIncl d r I.1 J.1 I.2 J.2)
          ≫ (theGlueData d r).ι I := (Category.assoc _ _ _).symm
    _ = Spec.map (CommRingCat.ofHom f) ≫ (theGlueData d r).ι I :=
        congrArg (· ≫ (theGlueData d r).ι I) hfI