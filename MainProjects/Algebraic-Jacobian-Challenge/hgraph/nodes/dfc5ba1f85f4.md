---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.existence_chart_factorization
docstring: '**E1 — the `K`-point factors through a single chart**

  (`lem:gr_existence_chart_factorization`): for a field `K`, any morphism

  `i₁ : Spec K ⟶ Gr(d,r)` factors as `Spec(f) ≫ ι_I` through a single chart immersion
  `ι_I` of

  the glue datum (`theGlueData`), for some size-`d` subset `I` and ring homomorphism

  `f : R^I = ℤ[X^I] → K`. Project-local: step E1 of the valuative-criterion existence
  argument

  (Nitsure §1, "Properness").'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.existence_chart_factorization
type: lean
updated: '2026-07-16T21:14:27'
---
theorem existence_chart_factorization (d r : ℕ) {K : Type} [Field K]
    (i₁ : Spec (CommRingCat.of K) ⟶ scheme d r) :
    ∃ (I : (theGlueData d r).J)
      (f : MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ →+* K),
      i₁ = Spec.map (CommRingCat.ofHom f) ≫ (theGlueData d r).ι I := by
  obtain ⟨x₀⟩ : Nonempty (↥(Spec (CommRingCat.of K))) := inferInstance
  obtain ⟨I, y, hy⟩ := (theGlueData d r).ι_jointly_surjective (i₁.base x₀)
  have hrange : Set.range i₁.base ⊆ Set.range ((theGlueData d r).ι I).base := by
    rintro z ⟨x', rfl⟩
    rw [Subsingleton.elim x' x₀]
    exact ⟨y, hy⟩
  haveI hoi : IsOpenImmersion ((theGlueData d r).ι I) := (theGlueData d r).ι_isOpenImmersion I
  refine ⟨I, (Spec.preimage
    (@IsOpenImmersion.lift _ _ _ ((theGlueData d r).ι I) i₁ hoi hrange)).hom, ?_⟩
  rw [CommRingCat.ofHom_hom, Spec.map_preimage]
  exact (@IsOpenImmersion.lift_fac _ _ _ ((theGlueData d r).ι I) i₁ hoi hrange).symm