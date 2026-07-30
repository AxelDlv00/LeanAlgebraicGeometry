---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.finrank_quotient_primeIdealOf
docstring: '**The residue leg of the dictionary**: the residue of the chart at the
  prime of a

  closed point `x ∈ V` is the residue field of `x`, `K`-linearly —

  `finrank K (Γ(X, V) ⧸ p_x) = [κ(x) : K]`.'
file: AlgebraicJacobian/RiemannRoch/ChartColength.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finrank_quotient_primeIdealOf
type: lean
updated: '2026-07-30T15:46:07'
---
theorem finrank_quotient_primeIdealOf {x : X} (hx : x ∈ V) (hxg : x ≠ genericPoint X) :
    finrank K (Γ(X, V) ⧸ (hV.primeIdealOf ⟨x, hx⟩).asIdeal) = X.residueDeg K x := by
  haveI : (hV.primeIdealOf ⟨x, hx⟩).asIdeal.IsMaximal :=
    hV.primeIdealOf_isMaximal_of_isClosed ⟨x, hx⟩
      (isClosed_singleton_of_ne_genericPoint (X ↘ Spec (CommRingCat.of K)) hxg)
  letI : Algebra Γ(X, V) (X.presheaf.stalk x) := X.presheaf.algebra_section_stalk ⟨x, hx⟩
  haveI hloc : IsLocalization.AtPrime (X.presheaf.stalk x)
      (hV.primeIdealOf ⟨x, hx⟩).asIdeal := hV.isLocalization_stalk ⟨x, hx⟩
  set e := IsLocalization.AtPrime.equivQuotMaximalIdeal
    (hV.primeIdealOf ⟨x, hx⟩).asIdeal (X.presheaf.stalk x) with he
  have hcompat : ∀ c : K,
      e (algebraMap K (Γ(X, V) ⧸ (hV.primeIdealOf ⟨x, hx⟩).asIdeal) c)
        = X.residueOverAlgebraMap K x c := by
    intro c
    rw [← Ideal.Quotient.mk_algebraMap,
      IsLocalization.AtPrime.equivQuotMaximalIdeal_apply_mk]
    change IsLocalRing.residue (X.presheaf.stalk x)
        ((X.presheaf.germ V x hx).hom (X.overAlgebraMap K V c)) = _
    rw [germ_overAlgebraMap_congr K hx c]
    rfl
  have hfr : finrank K (Γ(X, V) ⧸ (hV.primeIdealOf ⟨x, hx⟩).asIdeal)
      = finrank K (X.residueField x) :=
    LinearEquiv.finrank_eq
      { e with
        map_smul' := fun c z => by
          simp only [RingHom.id_apply, RingEquiv.toEquiv_eq_coe, Equiv.toFun_as_coe,
            EquivLike.coe_coe]
          rw [Algebra.smul_def, map_mul, hcompat c]
          rfl }
  rw [hfr]
  rfl

end ResidueLeg

/-! ## The multiplicity leg: order of vanishing = multiplicity in the factorization -/

section MultiplicityLeg

attribute [local instance] Scheme.overSectionsAlgebra

variable (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
  [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  {V : X.Opens} (hV : IsAffineOpen V) (hη : genericPoint X ∈ V)