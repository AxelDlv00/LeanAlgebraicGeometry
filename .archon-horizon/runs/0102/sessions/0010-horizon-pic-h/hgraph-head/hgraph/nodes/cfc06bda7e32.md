---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.Scheme.exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth
docstring: '**Stage 3 (Stacks 00TT, scheme-to-algebra bridge for the standard smooth

  presentation).** Iter-192 axiom-clean intermediate helper: combines Stage 2''s

  existence-of-standard-smooth-presentation output with the `RingHom`-to-`Algebra`

  bridge `RingHom.IsStandardSmooth.toAlgebra`, plus the affine-open stalk

  localisation `IsAffineOpen.isLocalization_stalk`. Returns the full algebra-side

  package needed by Stages 4-5 of the regularity proof: an affine neighbourhood

  `V ∋ z`, an `Algebra Γ(Spec _, U) Γ(X.left, V)` instance under which

  `Γ(X.left, V)` is `Algebra.IsStandardSmooth` over `Γ(Spec _, U)`, plus the

  `IsLocalization.AtPrime` witness identifying the stalk at `z` with the

  localisation of `Γ(X.left, V)` at the prime ideal of `z`.


  Axiom-clean: composition of `exists_isStandardSmooth_at_of_smooth` +

  `RingHom.IsStandardSmooth.toAlgebra` + `IsAffineOpen.isLocalization_stalk`.


  This is the iter-192 Lane M↓ HARD BAR new axiom-clean helper: it packages the

  "smooth ⟹ stalk is localisation of a standard-smooth Γ(Spec, U)-algebra"

  content as a standalone declaration that downstream Stages 4-5 (the genuine

  Stacks 00RT + 00OE Mathlib-gap chain) can consume directly.'
file: AlgebraicJacobian/Albanese/CodimOneStalkRegularity.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth
type: lean
updated: '2026-08-01T09:44:08'
---
private theorem exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (X : Over (Spec (.of kbar)))
    [Smooth X.hom]
    (z : X.left) :
    ∃ (U : (Spec (.of kbar)).Opens) (_hU : IsAffineOpen U)
      (V : X.left.Opens) (hV : IsAffineOpen V)
      (hzV : z ∈ V) (_e : V ≤ X.hom ⁻¹ᵁ U)
      (alg : Algebra Γ(Spec (.of kbar), U) Γ(X.left, V)),
      @Algebra.IsStandardSmooth _ _ _ _ alg ∧
      letI := TopCat.Presheaf.algebra_section_stalk X.left.presheaf ⟨z, hzV⟩
      IsLocalization.AtPrime
        (X.left.presheaf.stalk z) (hV.primeIdealOf ⟨z, hzV⟩).asIdeal := by
  obtain ⟨U, hU, V, hV, hzV, e, hStdSmooth⟩ :=
    exists_isStandardSmooth_at_of_smooth X z
  refine ⟨U, hU, V, hV, hzV, e, (X.hom.appLE U V e).hom.toAlgebra,
    hStdSmooth.toAlgebra, ?_⟩
  -- Localisation witness: the affine-open stalk is `Aₚ` for `p = primeIdealOf z`.
  letI := TopCat.Presheaf.algebra_section_stalk X.left.presheaf ⟨z, hzV⟩
  exact hV.isLocalization_stalk ⟨z, hzV⟩