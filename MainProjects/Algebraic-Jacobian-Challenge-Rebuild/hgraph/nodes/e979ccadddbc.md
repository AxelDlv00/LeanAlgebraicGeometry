---
author: sync
content_type: theorem
created: '2026-07-28T19:44:57'
decl: AlgebraicGeometry.surjective_of_forall_exists_residueField_lift
docstring: '**Per-point residue-field lifts give point surjectivity.**  If every point
  `y` of `Y`

  admits a morphism `q : Spec κ(y) ⟶ X` with `q ≫ f = Y.fromSpecResidueField y`, then
  the

  underlying map of `f` is surjective.


  `Spec κ(y)` is nonempty (a field is nontrivial), and the range of `Y.fromSpecResidueField
  y`

  is `{y}` (mathlib `Scheme.range_fromSpecResidueField`), so the image under `q` of
  any point

  of `Spec κ(y)` lies in the fibre of `f` over `y`.


  This is the missing link between what the Picard side produces and what DAT-J''s

  quasi-compactness field consumes: `exists_effective_of_picClass` yields a *morphism*
  out of

  a residue field, while `quasiCompact_of_surjective` wants a surjection of topological

  spaces.'
file: AlgebraicJacobian/Picard/JacobianDataAbelSurj.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.surjective_of_forall_exists_residueField_lift
type: lean
updated: '2026-07-29T15:31:46'
---
theorem surjective_of_forall_exists_residueField_lift (f : X ⟶ Y)
    (h : ∀ y : Y, ∃ q : Spec (Y.residueField y) ⟶ X,
      q ≫ f = Y.fromSpecResidueField y) :
    Function.Surjective f.base := by
  intro y
  obtain ⟨q, hq⟩ := h y
  -- a field is nontrivial, so `Spec κ(y)` has a point
  obtain ⟨s⟩ := (inferInstance : Nonempty (PrimeSpectrum (Y.residueField y)))
  refine ⟨q.base s, ?_⟩
  have hs : (q ≫ f).base s = (Y.fromSpecResidueField y).base s := by rw [hq]
  rw [Scheme.fromSpecResidueField_apply] at hs
  exact hs

end Topology

/-! ## DJ-1's quasi-compactness step from per-point lifts -/

section Qc

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of k))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of k))] [IsIntegral X]
variable (A B : X.CurveDivisor) (g r₁ r₂ : ℕ)
variable (b₁ : Module.Basis (Fin r₁) k ↥(Scheme.divisorSections k B ⊤))
variable (b₂ : Module.Basis (Fin r₂) k ↥(Scheme.divisorSections k (A + B) ⊤))