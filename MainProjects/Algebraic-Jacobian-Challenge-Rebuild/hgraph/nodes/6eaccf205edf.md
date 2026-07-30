---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: RingTheory.Module.exists_minimalSurjection_finite_localRing
file: AlgebraicJacobian/Algebra/ABSyzygy.lean
generated: lean
lean_status: lean_ok
title: RingTheory.Module.exists_minimalSurjection_finite_localRing
type: lean
updated: '2026-07-30T15:45:59'
---
lemma exists_minimalSurjection_finite_localRing
    (R : Type u) [CommRing R] [IsLocalRing R]
    (M : Type u) [AddCommGroup M] [Module R M] [_root_.Module.Finite R M] :
    ∃ (n : ℕ) (f : (Fin n → R) →ₗ[R] M),
      Function.Surjective f ∧
      n = _root_.Module.finrank (IsLocalRing.ResidueField R)
        (TensorProduct R (IsLocalRing.ResidueField R) M) ∧
      LinearMap.ker f ≤ (IsLocalRing.maximalIdeal R) • ⊤ := by
  set κ := IsLocalRing.ResidueField R with hκ
  set n := _root_.Module.finrank κ (TensorProduct R κ M) with hn
  -- Pick a κ-basis of `κ ⊗_R M`.
  let b : _root_.Module.Basis (Fin n) κ (TensorProduct R κ M) :=
    _root_.Module.finBasis κ (TensorProduct R κ M)
  -- The canonical map `(1 : κ) ⊗_R -` is surjective.
  have hsurj_mk : Function.Surjective ((TensorProduct.mk R κ M) 1) := by
    apply TensorProduct.mk_surjective
    exact Ideal.Quotient.mk_surjective
  -- Lift each basis element to a representative in M.
  choose lift hlift using hsurj_mk
  let m : Fin n → M := fun i => lift (b i)
  have hm : ∀ i, (1 : κ) ⊗ₜ[R] m i = b i := fun i => hlift (b i)
  -- Define `f` by sending each standard basis vector of `Fin n → R` to `m i`.
  let f : (Fin n → R) →ₗ[R] M := (Pi.basisFun R (Fin n)).constr R m
  -- Evaluation: `f x = Σ x i • m i`.
  have hf_eval : ∀ x : Fin n → R, f x = ∑ i, x i • m i := by
    intro x
    rw [show f x = ((Pi.basisFun R (Fin n)).constr R) m x from rfl,
        _root_.Module.Basis.constr_apply]
    have h : (Pi.basisFun R (Fin n)).repr x = Finsupp.equivFunOnFinite.symm x := by
      ext i; rw [Pi.basisFun_repr]; rfl
    rw [h, Finsupp.sum_fintype _ _ (by intros; simp)]
    exact Finset.sum_congr rfl (fun i _ => by simp)
  -- Range = span of `m`.
  have hf_range : LinearMap.range f = Submodule.span R (Set.range m) :=
    _root_.Module.Basis.constr_range _ _
  -- Nakayama: span of `m i` equals all of `M`.
  have hspan : Submodule.span R (Set.range m) = ⊤ :=
    IsLocalRing.span_eq_top_of_tmul_eq_basis m b hm
  refine ⟨n, f, ?_, rfl, ?_⟩
  · exact LinearMap.range_eq_top.mp (by rw [hf_range, hspan])
  · -- Kernel containment in `𝔪 • ⊤`.
    intro x hx
    have hfx : f x = 0 := hx
    rw [hf_eval] at hfx
    -- Apply `(1 : κ) ⊗_R -` to `Σ x i • m i = 0`.
    have h1 : (1 : κ) ⊗ₜ[R] (∑ i, x i • m i) = (0 : TensorProduct R κ M) := by
      rw [hfx]; exact TensorProduct.tmul_zero _ _
    rw [TensorProduct.tmul_sum] at h1
    -- Rewrite each summand: `1 ⊗_R (x i • m i) = residue(x i) • b i`.
    have hrewrite : ∀ i, (1 : κ) ⊗ₜ[R] (x i • m i)
        = (IsLocalRing.residue R (x i) : κ) • b i := by
      intro i
      rw [show ((1 : κ) ⊗ₜ[R] (x i • m i))
          = x i • ((1 : κ) ⊗ₜ[R] m i) from
        (TensorProduct.tmul_smul (R := R) (x i) (1 : κ) (m i))]
      rw [hm i]; rfl
    rw [show (∑ i, (1 : κ) ⊗ₜ[R] (x i • m i))
        = ∑ i, (IsLocalRing.residue R (x i) : κ) • b i from
      Finset.sum_congr rfl (fun i _ => hrewrite i)] at h1
    -- Linear independence of `b` forces each `residue (x i) = 0`.
    have hlin : LinearIndependent κ b := b.linearIndependent
    have hall : ∀ i, (IsLocalRing.residue R (x i) : κ) = 0 := by
      have := Fintype.linearIndependent_iff.mp hlin
        (fun i => IsLocalRing.residue R (x i)) h1
      exact fun i => this i
    -- Convert each component-in-𝔪 to `x ∈ 𝔪 • ⊤` via `Pi.single` decomposition.
    have hx_pi : ∀ i, x i ∈ IsLocalRing.maximalIdeal R := by
      intro i
      have : IsLocalRing.residue R (x i) = 0 := hall i
      rwa [IsLocalRing.residue_eq_zero_iff] at this
    rw [show x = ∑ i, Pi.single i (x i) from (Finset.univ_sum_single x).symm]
    refine Submodule.sum_mem _ ?_
    intro i _
    have hsingle :
        (Pi.single i (x i) : Fin n → R)
          = (x i) • (Pi.single i (1 : R) : Fin n → R) := by
      ext j; by_cases hij : i = j <;> simp [Pi.single, Function.update, hij]
    rw [hsingle]
    exact Submodule.smul_mem_smul (hx_pi i) trivial

/-! ### Bridge from the `projectiveDimension` equation to `HasProjectiveDimensionLT`

Converts the `Module.projectiveDimension R M = ((n : ℕ) : WithBot ℕ∞)` hypothesis
(the carrier used in `auslander_buchsbaum_formula` / `_succ_pd`) to Mathlib's
inductive Ext-vanishing predicate `HasProjectiveDimensionLT (ModuleCat.of R M) (n+1)`.
This single rewrite via `CategoryTheory.projectiveDimension_lt_iff` is the entry
point for the SES-descent path: once we have `HasProjectiveDimensionLT M (n+1)`,
the SES `0 → K → R^n → M → 0` plus
`ShortComplex.ShortExact.hasProjectiveDimensionLT_X₁` deliver the syzygy descent
(`HasProjectiveDimensionLT K n`) abstractly, with no minimal-resolution carving
required. -/