---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.Scheme.divEq_of_presentationDivisor_eq
docstring: '**The converse of DivEq-invariance** (`informal/spec-dd-1.md` §3 (f),
  the second

  inverse-law core): two local-equation systems on the curve `X` with the *same* Weil
  divisor

  are divisor-equal. On the common refinement `d₁.cover ⊓ d₂.cover`, at each point
  `x`, the

  ratio `r = elem₁ x / elem₂ x` of the anchor equations has order `1` at every closed
  point of

  the overlap — the equal divisor coefficient read off either piece

  (`MeromorphicPresentation.ordZ_elem_eq`, `coeffAt_presentationDivisor`) — so both
  `r` and

  `r⁻¹` are `𝒪(0)`-sections (`exists_section_germ_eq`), i.e. `r` is a unit section
  rescaling

  `d₂.eqn x` to `d₁.eqn x`. The converse of `Scheme.presentationDivisor_eq_of_divEq`.'
file: AlgebraicJacobian/Picard/DivisorFamilyFieldEquiv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.divEq_of_presentationDivisor_eq
type: lean
updated: '2026-07-17T16:57:13'
---
theorem divEq_of_presentationDivisor_eq {d₁ d₂ : X.LocalEquations}
    (h : presentationDivisor K d₁.presentation = presentationDivisor K d₂.presentation) :
    LocalEquations.DivEq d₁ d₂ := by
  refine ⟨d₁.cover ⊓ d₂.cover, inf_le_left, inf_le_right, fun x => ?_⟩
  have hηW : genericPoint X ∈ d₁.cover.opens x ⊓ d₂.cover.opens x :=
    ⟨d₁.cover.genericPoint_mem_opens x, d₂.cover.genericPoint_mem_opens x⟩
  have hWne : ((d₁.cover.opens x ⊓ d₂.cover.opens x : X.Opens) : Set X).Nonempty :=
    ⟨genericPoint X, hηW⟩
  simp only [PointedCover.inf_opens]
  set r : X.functionFieldˣ :=
    d₁.presentation.elem x * (d₂.presentation.elem x)⁻¹ with hr
  -- `r` is a stalk-unit at every closed point of the overlap
  have hru : ∀ (z : X) (hz : z ≠ genericPoint X),
      z ∈ d₁.cover.opens x ⊓ d₂.cover.opens x →
      Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hz r = 1 := by
    intro z hz hzW
    have e1 := d₁.presentation.ordZ_elem_eq K hz (y := x) hzW.1
    have e2 := d₂.presentation.ordZ_elem_eq K hz (y := x) hzW.2
    have hcoeff := congrArg (coeffAt hz) h
    rw [coeffAt_presentationDivisor, coeffAt_presentationDivisor] at hcoeff
    have hzz : Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hz (d₁.presentation.elem z)
        = Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hz (d₂.presentation.elem z) :=
      Multiplicative.toAdd.injective hcoeff
    have hkey : Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hz (d₁.presentation.elem x)
        = Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hz (d₂.presentation.elem x) :=
      e1.trans (hzz.trans e2.symm)
    rw [hr, map_mul, map_inv, hkey, mul_inv_cancel]
  -- both `r` and `r⁻¹` are `𝒪(0)`-sections over the overlap
  have hmem : ∀ (g : X.functionFieldˣ),
      (∀ (z : X) (hz : z ≠ genericPoint X), z ∈ d₁.cover.opens x ⊓ d₂.cover.opens x →
        Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hz g = 1) →
      (g : X.functionField) ∈ divisorSections K 0 (d₁.cover.opens x ⊓ d₂.cover.opens x) := by
    intro g hg
    rw [mem_divisorSections_of_nonempty K hWne]
    intro z hz hzW
    rw [divisorBound_zero]
    exact le_of_eq
      ((Scheme.ordZ_eq_one_iff (X ↘ Spec (CommRingCat.of K)) hz g).mp (hg z hz hzW))
  have hrinv : ∀ (z : X) (hz : z ≠ genericPoint X),
      z ∈ d₁.cover.opens x ⊓ d₂.cover.opens x →
      Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hz r⁻¹ = 1 := by
    intro z hz hzW
    rw [map_inv, hru z hz hzW, inv_one]
  obtain ⟨s, hs⟩ := exists_section_germ_eq K hηW (hmem r hru)
  obtain ⟨s', hs'⟩ := exists_section_germ_eq K hηW (hmem r⁻¹ hrinv)
  -- `s` and `s'` are inverse sections, giving the rescaling unit
  have hss' : s * s' = 1 :=
    germ_injective_of_isIntegral X (genericPoint X) hηW (by
      rw [map_mul, hs, hs', map_one, ← Units.val_mul, mul_inv_cancel, Units.val_one])
  have hs's : s' * s = 1 := by rw [mul_comm]; exact hss'
  have hu : (↑(⟨s, s', hss', hs's⟩ : Γ(X, d₁.cover.opens x ⊓ d₂.cover.opens x)ˣ) :
      Γ(X, d₁.cover.opens x ⊓ d₂.cover.opens x)) = s := rfl
  refine ⟨⟨s, s', hss', hs's⟩, ?_⟩
  -- the rescaling equation, verified at `η` by germ injectivity
  refine germ_injective_of_isIntegral X (genericPoint X) hηW ?_
  have hL : (X.presheaf.germ (d₁.cover.opens x ⊓ d₂.cover.opens x) (genericPoint X) hηW).hom
        ((X.presheaf.map (homOfLE inf_le_left).op).hom (d₁.eqn x))
      = (d₁.presentation.elem x : X.functionField) := by
    rw [X.presheaf.germ_res_apply]; exact (d₁.presentation_elem_val x).symm
  have hR : (X.presheaf.germ (d₁.cover.opens x ⊓ d₂.cover.opens x) (genericPoint X) hηW).hom
        ((X.presheaf.map (homOfLE inf_le_right).op).hom (d₂.eqn x))
      = (d₂.presentation.elem x : X.functionField) := by
    rw [X.presheaf.germ_res_apply]; exact (d₂.presentation_elem_val x).symm
  rw [map_mul, hu, hs, hL, hR, hr, Units.val_mul, Units.val_inv_eq_inv_val, mul_assoc,
    inv_mul_cancel₀ (d₂.presentation.elem x).ne_zero, mul_one]

end Scheme

/-! ## Forward injectivity and the equiv reduction on `DivFam` over a field -/

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {K : Type u} [Field K] [Algebra k K]
variable {π : C.left ⟶ P1 k} [IsAffineHom π]
variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]
variable {n : ℕ}