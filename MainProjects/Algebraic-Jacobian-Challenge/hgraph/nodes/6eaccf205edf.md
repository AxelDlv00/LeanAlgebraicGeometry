---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: RingTheory.Module.exists_minimalSurjection_finite_localRing
docstring: "For any commutative ring `R`, ideal `I`, `R`-module `M`, and nonempty\
  \ finite\ntype `ι`, the depth of the Pi module `ι → M` equals the depth of `M`:\n\
  ```\n  depth I (ι → M) = depth I M.\n```\nThis yields the `pd_R(M) = 0` case of\
  \ the Auslander–Buchsbaum formula: a nonzero\nfinite free module `M ≃ₗ[R] Fin k\
  \ → R` has `depth(M) = depth(R)`, so\n`0 + depth(M) = depth(R)` holds. -/\nlemma\
  \ depth_pi_const_eq_depth_of_nonempty\n    {R : Type u} [CommRing R] (I : Ideal\
  \ R)\n    {ι : Type*} [Finite ι] [Nonempty ι]\n    {M : Type v} [AddCommGroup M]\
  \ [Module R M] :\n    depth I (ι → M) = depth I M := by\n  unfold depth\n  by_cases\
  \ h : I • (⊤ : Submodule R (ι → M)) = ⊤\n  · rw [if_pos h, if_pos ((ideal_smul_top_pi_const_eq_top_iff\
  \ I).mp h)]\n  · rw [if_neg h, if_neg (mt (ideal_smul_top_pi_const_eq_top_iff I).mpr\
  \ h)]\n    congr 1\n    ext n\n    refine ⟨?_, ?_⟩\n    · rintro ⟨rs, hlen, hmem,\
  \ hreg⟩\n      exact ⟨rs, hlen, hmem, (isRegular_pi_const_iff_of_nonempty rs).mp\
  \ hreg⟩\n    · rintro ⟨rs, hlen, hmem, hreg⟩\n      exact ⟨rs, hlen, hmem, (isRegular_pi_const_iff_of_nonempty\
  \ rs).mpr hreg⟩\n\n/-! ### Minimal surjections onto a finite module over a local\
  \ ring\n\nFor a finite `R`-module `M` over a local ring `R`, there exists a surjective\n\
  `R`-linear map `f : (Fin n → R) →ₗ[R] M` of the **minimal possible rank**\n`n =\
  \ dim_κ (κ ⊗_R M)` (where `κ = R/\U0001D52A` is the residue field) whose **kernel\n\
  is contained in `\U0001D52A • ⊤`**. This is the first step of constructing a *minimal\n\
  finite free resolution*: iterating the construction on the kernel (which is\nitself\
  \ finitely generated when `R` is Noetherian) produces successive\nsyzygies whose\
  \ differential maps each have image in `\U0001D52A` times their target.\n\nThis\
  \ is the single-step form of Stacks `lemma-add-trivial-complex`, used in the\nAuslander–Buchsbaum\
  \ induction (`auslander_buchsbaum_formula_succ_pd`). The proof\nis the **Nakayama\
  \ lift** of a κ-basis of `κ ⊗_R M` to an `R`-spanning family in\n`M`; the kernel\
  \ containment is read off from linear independence of the basis\ncombined with the\
  \ `1 ⊗_R -` evaluation.\n\nMathlib input:\n* `IsLocalRing.span_eq_top_of_tmul_eq_basis`\
  \ — Nakayama lift of a κ-basis.\n* `TensorProduct.mk_surjective` — the `1 ⊗_R -`\
  \ map is surjective for the\n  residue-field tensor.\n* `Module.Basis.constr_range`\
  \ — range of the linear extension equals span of\n  the chosen image set.\n* `Module.Basis.linearIndependent`\
  \ — independence of a κ-basis.\n* `IsLocalRing.residue_eq_zero_iff` — `r ∈ \U0001D52A\
  \ ↔ residue r = 0`."
file: AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
generated: lean
lean_status: lean_ok
title: RingTheory.Module.exists_minimalSurjection_finite_localRing
type: lean
updated: '2026-07-27T12:05:09'
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

/-! ### From a `projectiveDimension` equation to `HasProjectiveDimensionLT`

Converts the hypothesis `Module.projectiveDimension R M = ((n : ℕ) : WithBot ℕ∞)`
(the form used in `auslander_buchsbaum_formula` and `_succ_pd`) into Mathlib's