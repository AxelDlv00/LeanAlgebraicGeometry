---
author: sync
content_type: theorem
created: '2026-07-30T13:03:21'
decl: AlgebraicGeometry.IsFinite.exists_closedImmersion_affineSpace
docstring: 'A finite morphism over an affine target is a closed subscheme of a

  finite-dimensional affine space over that target.'
file: AlgebraicJacobian/Picard/FiniteMorphismEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IsFinite.exists_closedImmersion_affineSpace
type: lean
updated: '2026-07-30T13:03:21'
---
theorem exists_closedImmersion_affineSpace {X Y : Scheme.{u}} (f : X ⟶ Y)
    [IsFinite f] [IsAffine Y] :
    ∃ (n : Type u) (_ : Finite n) (i : X ⟶ 𝔸(n; Y)),
      IsClosedImmersion i ∧ i ≫ (𝔸(n; Y) ↘ Y) = f := by
  letI : IsAffine X := isAffine_of_isAffineHom f
  letI : Algebra Γ(Y, ⊤) Γ(X, ⊤) := RingHom.toAlgebra f.appTop.hom
  haveI : Module.Finite Γ(Y, ⊤) Γ(X, ⊤) := f.finite_appTop
  obtain ⟨n, hn, q, hq⟩ :=
    Algebra.FiniteType.iff_quotient_mvPolynomial'.mp
      (inferInstance : Algebra.FiniteType Γ(Y, ⊤) Γ(X, ⊤))
  letI : Fintype n := hn
  let i : X ⟶ 𝔸(n; Y) :=
    AffineSpace.homOfVector f fun j => q (MvPolynomial.X j)
  refine ⟨n, inferInstance, i, ?_, AffineSpace.homOfVector_over _ _⟩
  apply IsClosedImmersion.of_surjective_of_isAffine
  intro x
  obtain ⟨p, rfl⟩ := hq x
  refine ⟨(AffineSpace.isoOfIsAffine n Y).hom.appTop
    ((Scheme.ΓSpecIso (.of (MvPolynomial n Γ(Y, ⊤)))).inv p), ?_⟩
  rw [AffineSpace.isoOfIsAffine_hom_appTop]
  simp only [CommRingCat.comp_apply, Iso.inv_hom_id_apply]
  change (i.appTop.hom.comp
    (eval₂Hom (𝔸(n; Y) ↘ Y).appTop.hom (AffineSpace.coord Y))) p = q.toRingHom p
  apply DFunLike.congr_fun ?_ p
  apply MvPolynomial.ringHom_ext
  · intro r
    simp only [RingHom.comp_apply, eval₂Hom_C]
    rw [show q.toRingHom (C r) = f.appTop.hom r by
      change q (C r) = f.appTop.hom r
      exact q.commutes r]
    have h := congrArg Scheme.Hom.appTop (AffineSpace.homOfVector_over f
      (fun j => q (MvPolynomial.X j)))
    rw [Scheme.Hom.comp_appTop] at h
    exact congrArg (fun e : Γ(Y, ⊤) ⟶ Γ(X, ⊤) => e.hom r) h
  · intro j
    simp [i]