---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.GenericFreeness.genericallyFree_quotient_prime_of_fibre_dim_le
docstring: '**Auxiliary induction for the domain core** [Nitsure §4, "Lemma on Generic

  Flatness", normalisation step]: for a noetherian domain `A` and a finite-type

  `A`-algebra `E` with a prime `q`, if the generic fibre of `C := E ⧸ q` has

  Krull dimension at most `n`, then `C` is generically free over `A`.


  Strong induction on `n`.  Either the kernel of `A → C` is non-zero (uniform

  annihilator, torsion case), or `A ↪ C`: Noether-normalise the fibre

  (`exists_finite_inj_algHom_of_fg`, with `s ≤ n` variables by the

  integral-dimension comparison), scale the variables into `C`

  (`exists_scaled_noether_datum`), clear denominators

  (`exists_smul_isIntegralElem_of_fibre_finite`) to obtain a module-finite

  subalgebra `C'''' ⊆ C` over `D := A[X₁,…,X_s]` with `C''''_g = C_g`, build the

  generic-rank exact sequence `0 → D^r → C'''' → T → 0` with `T` killed by some

  `0 ≠ d ∈ D` (`exists_generic_rank_comparison` applied to `M := ↥C''''`),

  dispose of `T` by prime-filtration dévissage over `D ⧸ (d)`

  (whose fibre has dimension `< s ≤ n`, so the inductive hypothesis applies),

  splice, and transport along the `g`-saturating inclusion `C'''' ⊆ C`.'
file: AlgebraicJacobian/Picard/FlatteningStratification.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GenericFreeness.genericallyFree_quotient_prime_of_fibre_dim_le
type: lean
updated: '2026-07-24T03:02:10'
---
theorem genericallyFree_quotient_prime_of_fibre_dim_le (n : ℕ) :
    ∀ (A E : Type u) [CommRing A] [IsDomain A] [IsNoetherianRing A]
      [CommRing E] [Algebra A E] [Algebra.FiniteType A E]
      (q : Ideal E), q.IsPrime →
      ringKrullDim (Localization (Algebra.algebraMapSubmonoid (E ⧸ q)
        (nonZeroDivisors A))) ≤ (n : WithBot ℕ∞) →
      GenericallyFree A (E ⧸ q) := by
  induction n using Nat.strong_induction_on with
  | _ n IH =>
  intro A E _ _ _ _ _ _ q hq hdim
  haveI := hq
  by_cases hker : ∃ a : A, a ≠ 0 ∧ algebraMap A (E ⧸ q) a = 0
  · -- kernel case: the whole quotient is annihilated by a non-zero scalar
    obtain ⟨a, ha, ha0⟩ := hker
    exact genericallyFree_of_annihilator ha fun m => by
      rw [Algebra.smul_def, ha0, zero_mul]
  -- main case: `A ↪ C`
  have hinj : Function.Injective (algebraMap A (E ⧸ q)) := by
    rw [injective_iff_map_eq_zero]
    intro a h0
    by_contra hne
    exact hker ⟨a, hne, h0⟩
  haveI hFdom : IsDomain (Localization (Algebra.algebraMapSubmonoid (E ⧸ q)
      (nonZeroDivisors A))) := fibre_isDomain hinj
  haveI : Algebra.FiniteType A (E ⧸ q) :=
    Algebra.FiniteType.of_surjective (Ideal.Quotient.mkₐ A q)
      (Ideal.Quotient.mkₐ_surjective A q)
  obtain ⟨nn, ψ, hψ⟩ := Algebra.FiniteType.iff_quotient_mvPolynomial''.mp
    ‹Algebra.FiniteType A (E ⧸ q)›
  haveI : Algebra.FiniteType (FractionRing A)
      (Localization (Algebra.algebraMapSubmonoid (E ⧸ q) (nonZeroDivisors A))) :=
    Algebra.FiniteType.of_surjective _ (fibre_aeval_surjective ψ hψ)
  obtain ⟨s, φ, hφinj, hφfin⟩ := exists_finite_inj_algHom_of_fg (FractionRing A)
    (Localization (Algebra.algebraMapSubmonoid (E ⧸ q) (nonZeroDivisors A)))
  -- the number of Noether variables is bounded by `n`
  have hs_le : (s : WithBot ℕ∞) ≤ (n : WithBot ℕ∞) := by
    have h1 : ringKrullDim (MvPolynomial (Fin s) (FractionRing A)) ≤
        ringKrullDim (Localization (Algebra.algebraMapSubmonoid (E ⧸ q)
          (nonZeroDivisors A))) := by
      letI := φ.toRingHom.toAlgebra
      haveI : Module.Finite (MvPolynomial (Fin s) (FractionRing A))
          (Localization (Algebra.algebraMapSubmonoid (E ⧸ q)
            (nonZeroDivisors A))) := hφfin
      haveI := Algebra.IsIntegral.of_finite (MvPolynomial (Fin s) (FractionRing A))
        (Localization (Algebra.algebraMapSubmonoid (E ⧸ q) (nonZeroDivisors A)))
      exact le_ringKrullDim_of_isIntegral_of_injective _ _ hφinj
    have h2 : ringKrullDim (MvPolynomial (Fin s) (FractionRing A)) =
        (s : WithBot ℕ∞) := by
      rw [MvPolynomial.ringKrullDim_of_isNoetherianRing,
        ringKrullDim_eq_zero_of_field, Nat.card_eq_fintype_card,
        Fintype.card_fin, zero_add]
    calc (s : WithBot ℕ∞) = _ := h2.symm
    _ ≤ _ := h1
    _ ≤ (n : WithBot ℕ∞) := hdim
  -- scale the Noether datum into `C` and clear denominators per generator
  obtain ⟨b, φ', hφ'inj, hφ'fin, hb⟩ := exists_scaled_noether_datum φ hφinj hφfin
  have hclear : ∀ j : Fin nn, ∃ a : A, a ≠ 0 ∧
      (MvPolynomial.aeval b :
        MvPolynomial (Fin s) A →ₐ[A] (E ⧸ q)).toRingHom.IsIntegralElem
        (a • ψ (MvPolynomial.X j)) :=
    fun j => exists_smul_isIntegralElem_of_fibre_finite hinj φ' hφ'fin hb _
  choose aa haa hint using hclear
  have hg0 : (∏ j, aa j) ≠ 0 := Finset.prod_ne_zero_iff.mpr fun j _ => haa j
  -- `C''`: the subalgebra generated over `A[X₁,…,X_s]` by the cleared
  -- generators; module-finite since the generators are integral
  letI : Algebra (MvPolynomial (Fin s) A) (E ⧸ q) :=
    (MvPolynomial.aeval b).toRingHom.toAlgebra
  haveI : IsScalarTower A (MvPolynomial (Fin s) A) (E ⧸ q) :=
    IsScalarTower.of_algebraMap_eq' ((MvPolynomial.aeval b).comp_algebraMap).symm
  set C'' : Subalgebra (MvPolynomial (Fin s) A) (E ⧸ q) :=
    Algebra.adjoin (MvPolynomial (Fin s) A)
      (Set.range fun j => aa j • ψ (MvPolynomial.X j)) with hC''def
  haveI hC''fin : Module.Finite (MvPolynomial (Fin s) A) ↥C'' := by
    have hfg : (Subalgebra.toSubmodule C'').FG := by
      apply fg_adjoin_of_finite (Set.finite_range _)
      rintro x ⟨j, rfl⟩
      exact hint j
    exact Module.Finite.iff_fg.mpr hfg
  -- saturation: a power of `g := ∏ aa j` pushes every element of `C` into `C''`
  have hsat : ∀ c : E ⧸ q, ∃ (N : ℕ) (y : ↥C''), (∏ j, aa j) ^ N • c = ↑y := by
    intro c
    obtain ⟨p, rfl⟩ := hψ c
    induction p using MvPolynomial.induction_on with
    | C a =>
      refine ⟨0, ⟨ψ (MvPolynomial.C a), ?_⟩, by rw [pow_zero, one_smul]⟩
      have h2 : ψ (MvPolynomial.C a) =
          algebraMap (MvPolynomial (Fin s) A) (E ⧸ q) (MvPolynomial.C a) := by
        rw [show algebraMap (MvPolynomial (Fin s) A) (E ⧸ q) (MvPolynomial.C a) =
            (MvPolynomial.aeval b) (MvPolynomial.C a) from rfl,
          MvPolynomial.aeval_C, ← MvPolynomial.algebraMap_eq, AlgHom.commutes]
      rw [h2]
      exact Subalgebra.algebraMap_mem C'' _
    | add p1 p2 h1 h2 =>
      obtain ⟨N1, y1, hy1⟩ := h1
      obtain ⟨N2, y2, hy2⟩ := h2
      refine ⟨max N1 N2, (∏ j, aa j) ^ (max N1 N2 - N1) • y1 +
        (∏ j, aa j) ^ (max N1 N2 - N2) • y2, ?_⟩
      have hco : ((((∏ j, aa j) ^ (max N1 N2 - N1) • y1 +
          (∏ j, aa j) ^ (max N1 N2 - N2) • y2 : ↥C'')) : E ⧸ q) =
          (∏ j, aa j) ^ (max N1 N2 - N1) • (y1 : E ⧸ q) +
          (∏ j, aa j) ^ (max N1 N2 - N2) • (y2 : E ⧸ q) := rfl
      rw [map_add, smul_add, hco, ← hy1, ← hy2, smul_smul, smul_smul,
        ← pow_add, ← pow_add, Nat.sub_add_cancel (le_max_left N1 N2),
        Nat.sub_add_cancel (le_max_right N1 N2)]
    | mul_X p j hp =>
      obtain ⟨N, y, hy⟩ := hp
      refine ⟨N + 1,
        ((∏ k ∈ Finset.univ.erase j, aa k) • (⟨aa j • ψ (MvPolynomial.X j),
          Algebra.subset_adjoin ⟨j, rfl⟩⟩ : ↥C'')) * y, ?_⟩
      have hco : ((((∏ k ∈ Finset.univ.erase j, aa k) •
          (⟨aa j • ψ (MvPolynomial.X j),
            Algebra.subset_adjoin ⟨j, rfl⟩⟩ : ↥C'')) * y : ↥C'') : E ⧸ q) =
          ((∏ k ∈ Finset.univ.erase j, aa k) •
            (aa j • ψ (MvPolynomial.X j))) * (y : E ⧸ q) := rfl
      rw [map_mul, hco, ← hy, smul_smul, smul_mul_smul_comm]
      rw [show ψ p * ψ (MvPolynomial.X j) =
        ψ (MvPolynomial.X j) * ψ p from mul_comm _ _]
      congr 1
      rw [pow_succ, ← Finset.mul_prod_erase Finset.univ aa (Finset.mem_univ j)]
      ring
  -- ===== the generic-rank exact sequence over `D := A[X₁,…,X_s]` =====
  obtain ⟨r, Φ, hΦinj, d, hd0, hdT⟩ :=
    exists_generic_rank_comparison (MvPolynomial (Fin s) A) ↥C''
  -- ===== dévissage of the torsion cokernel over `E' := D ⧸ (d)` =====
  have hTBS : Module.IsTorsionBySet (MvPolynomial (Fin s) A)
      (↥C'' ⧸ LinearMap.range Φ)
      ((Ideal.span {d} : Ideal (MvPolynomial (Fin s) A)) : Set (MvPolynomial (Fin s) A)) :=
    (Module.isTorsionBySet_span_singleton_iff d).mpr hdT
  letI : Module
      (MvPolynomial (Fin s) A ⧸ (Ideal.span {d} : Ideal (MvPolynomial (Fin s) A)))
      (↥C'' ⧸ LinearMap.range Φ) := hTBS.module
  haveI : IsScalarTower A
      (MvPolynomial (Fin s) A ⧸ (Ideal.span {d} : Ideal (MvPolynomial (Fin s) A)))
      (↥C'' ⧸ LinearMap.range Φ) :=
    hTBS.isScalarTower
  haveI : Module.Finite
      (MvPolynomial (Fin s) A ⧸ (Ideal.span {d} : Ideal (MvPolynomial (Fin s) A)))
      (↥C'' ⧸ LinearMap.range Φ) :=
    Module.Finite.of_restrictScalars_finite (MvPolynomial (Fin s) A) _ _
  -- every prime quotient of `E'` is generically free: kernel case or recursion
  have hcore : ∀ (qt : Ideal (MvPolynomial (Fin s) A ⧸
      (Ideal.span {d} : Ideal (MvPolynomial (Fin s) A)))), qt.IsPrime →
      GenericallyFree A ((MvPolynomial (Fin s) A ⧸
        (Ideal.span {d} : Ideal (MvPolynomial (Fin s) A))) ⧸ qt) := by
    intro qt hqt
    haveI := hqt
    by_cases hker' : ∃ a : A, a ≠ 0 ∧ algebraMap A ((MvPolynomial (Fin s) A ⧸
        (Ideal.span {d} : Ideal (MvPolynomial (Fin s) A))) ⧸ qt) a = 0
    · obtain ⟨a, ha, ha0⟩ := hker'
      exact genericallyFree_of_annihilator ha fun m => by
        rw [Algebra.smul_def, ha0, zero_mul]
    · have hinj' : Function.Injective (algebraMap A ((MvPolynomial (Fin s) A ⧸
          (Ideal.span {d} : Ideal (MvPolynomial (Fin s) A))) ⧸ qt)) := by
        rw [injective_iff_map_eq_zero]
        intro a h0
        by_contra hne
        exact hker' ⟨a, hne, h0⟩
      -- the composite presentation kills `d`, so the fibre dimension drops
      have hπd : ((Ideal.Quotient.mkₐ A qt).comp
          (Ideal.Quotient.mkₐ A (Ideal.span {d}))) d = 0 := by
        rw [AlgHom.comp_apply, show (Ideal.Quotient.mkₐ A (Ideal.span {d})) d = 0 from
          Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_span_singleton_self d),
          map_zero]
      have h1 := fibre_dim_add_one_le_of_presentation
        ((Ideal.Quotient.mkₐ A qt).comp (Ideal.Quotient.mkₐ A (Ideal.span {d})))
        ((Ideal.Quotient.mkₐ_surjective A qt).comp
          (Ideal.Quotient.mkₐ_surjective A (Ideal.span {d})))
        hd0 hπd
      haveI := fibre_isDomain hinj'
      have h0 : (0 : WithBot ℕ∞) ≤ ringKrullDim (Localization
          (Algebra.algebraMapSubmonoid ((MvPolynomial (Fin s) A ⧸
            (Ideal.span {d} : Ideal (MvPolynomial (Fin s) A))) ⧸ qt)
            (nonZeroDivisors A))) :=
        ringKrullDim_nonneg_of_nontrivial
      obtain ⟨m', hm'lt, hm'le⟩ := exists_nat_le_of_add_one_le h0 h1 hs_le
      exact IH m' hm'lt A _ qt hqt hm'le
  -- assemble: the cokernel is generically free by dévissage
  have hGFT : GenericallyFree A (↥C'' ⧸ LinearMap.range Φ) :=
    genericallyFree_of_forall_quotient_prime
      (MvPolynomial (Fin s) A ⧸ (Ideal.span {d} : Ideal (MvPolynomial (Fin s) A)))
      hcore (↥C'' ⧸ LinearMap.range Φ)
  -- the free part is generically free
  have hGFfree : GenericallyFree A (Fin r → MvPolynomial (Fin s) A) :=
    GenericallyFree.of_free A _
  -- splice the exact sequence `0 → D^r → C'' → T → 0` over `A`
  have hGFC'' : GenericallyFree A ↥C'' := by
    have hinj' : Function.Injective (Φ.restrictScalars A) := by
      simpa only [LinearMap.coe_restrictScalars] using hΦinj
    have hsurj' : Function.Surjective
        (((LinearMap.range Φ).mkQ).restrictScalars A) := by
      simpa only [LinearMap.coe_restrictScalars] using
        (LinearMap.range Φ).mkQ_surjective
    have hex' : Function.Exact (Φ.restrictScalars A)
        (((LinearMap.range Φ).mkQ).restrictScalars A) := by
      have hex : Function.Exact Φ (LinearMap.range Φ).mkQ :=
        LinearMap.exact_iff.mpr (Submodule.ker_mkQ _)
      simpa only [LinearMap.coe_restrictScalars] using hex
    exact genericallyFree_of_exact (Φ.restrictScalars A)
      (((LinearMap.range Φ).mkQ).restrictScalars A) hinj' hsurj' hex' hGFfree hGFT
  -- transport along the `g`-saturating inclusion `C'' ⊆ C`
  exact hGFC''.of_saturating_injection
    ((Subalgebra.val C'').toLinearMap.restrictScalars A)
    (fun x y h => Subtype.ext h) hg0 hsat