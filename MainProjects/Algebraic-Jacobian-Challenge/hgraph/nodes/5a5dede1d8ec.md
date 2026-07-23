---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicJacobian.TwoChart.fg_ker_cechDiff_of_laurent
docstring: '**Abstract `H⁰`-finiteness for a two-chart Laurent datum** (Serre

  dévissage, Stacks 01YS / EGA III 3.2.1, made module-theoretic on the

  two-term Čech complex).  For a noetherian base `A`, chart-finite `M₀, M₁`,

  and the localization-style extension/torsion hypotheses of the wave-4

  substrate, the Čech kernel `H⁰ = ker (σ₀ − σ₁)` is a finitely generated

  `A`-submodule — given `hS0`, finiteness of the structure-sheaf Čech kernel

  (`H⁰(O)`; the `M`-independent anchor).


  Proof: uniform twisted generating family (`σ₀ aᵢ = t^d • σ₁ bᵢ` with the

  `aᵢ` generating `M₀` over `C₀` and `bᵢ` generating `M₁` over `C₁`), giving

  a twisted free datum `E = O(-d)^ι ↠ M`; its kernel datum `K` satisfies the

  two-lattice hypotheses elementwise, so `Ȟ¹(K)` is `A`-finite by the wave-4

  core `module_finite_quotient_of_smul_laurent_pair`; `Ȟ⁰(E) ≅ (S_d)^ι` is

  `A`-finite by the `x^d`-embedding into `S_0`; and the connecting snake

  `0 → im Ȟ⁰(E) → Ȟ⁰(M) → Ȟ¹(K)` finishes over the noetherian base.'
file: AlgebraicJacobian/Picard/P1SectionsFinite.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.TwoChart.fg_ker_cechDiff_of_laurent
type: lean
updated: '2026-07-16T21:14:27'
---
theorem fg_ker_cechDiff_of_laurent {A C₀ C₁ C₀₁ M₀ M₁ V : Type*} [CommRing A]
    [CommRing C₀] [CommRing C₁] [CommRing C₀₁]
    [Algebra A C₀] [Algebra A C₁] [Algebra A C₀₁] [IsNoetherianRing A]
    [AddCommGroup M₀] [AddCommGroup M₁] [AddCommGroup V]
    [Module C₀ M₀] [Module C₁ M₁] [Module C₀₁ V]
    [Module A M₀] [Module A M₁] [Module A V]
    [IsScalarTower A C₀ M₀] [IsScalarTower A C₁ M₁] [IsScalarTower A C₀₁ V]
    [Module.Finite C₀ M₀] [Module.Finite C₁ M₁]
    (ρ₀ : C₀ →ₐ[A] C₀₁) (ρ₁ : C₁ →ₐ[A] C₀₁) (x : C₀) (y : C₁)
    (htu : ρ₀ x * ρ₁ y = 1)
    (hspan₀ : ⊤ ≤ Submodule.span A (Set.range fun n : ℕ => x ^ n))
    (σ₀ : M₀ →ₗ[A] V) (σ₁ : M₁ →ₗ[A] V)
    (hσ₀ : ∀ (c : C₀) (m : M₀), σ₀ (c • m) = ρ₀ c • σ₀ m)
    (hσ₁ : ∀ (c : C₁) (m : M₁), σ₁ (c • m) = ρ₁ c • σ₁ m)
    (hext₀ : ∀ v : V, ∃ (n : ℕ) (m : M₀), ρ₀ x ^ n • v = σ₀ m)
    (hext₁ : ∀ v : V, ∃ (n : ℕ) (m : M₁), ρ₁ y ^ n • v = σ₁ m)
    (htor₀ : ∀ m : M₀, σ₀ m = 0 → ∃ n : ℕ, x ^ n • m = 0)
    (htor₁ : ∀ m : M₁, σ₁ m = 0 → ∃ n : ℕ, y ^ n • m = 0)
    (hRext₀ : ∀ c : C₀₁, ∃ (n : ℕ) (q : C₀), ρ₀ x ^ n * c = ρ₀ q)
    (hRext₁ : ∀ c : C₀₁, ∃ (n : ℕ) (q : C₁), ρ₁ y ^ n * c = ρ₁ q)
    (hRtor₀ : ∀ c : C₀, ρ₀ c = 0 → ∃ n : ℕ, x ^ n * c = 0)
    (hS0 : (LinearMap.ker (cechDiff ρ₀.toLinearMap ρ₁.toLinearMap)).FG) :
    (LinearMap.ker (cechDiff σ₀ σ₁)).FG := by
  classical
  have hpow : ∀ n : ℕ, ρ₀ x ^ n * ρ₁ y ^ n = 1 := fun n => by
    rw [← mul_pow, htu, one_pow]
  haveI hNC₀ : IsNoetherianRing C₀ := isNoetherianRing_of_top_le_span_pow hspan₀
  -- ### Step 1: the uniform twisted generating family
  obtain ⟨n₀, g, hg⟩ := Module.Finite.exists_fin (R := C₀) (M := M₀)
  obtain ⟨n₁, g', hg'⟩ := Module.Finite.exists_fin (R := C₁) (M := M₁)
  choose nb b hb using fun i : Fin n₀ => hext₁ (σ₀ (g i))
  choose ma a ha using fun j : Fin n₁ => hext₀ (σ₁ (g' j))
  set d : ℕ := max (Finset.univ.sup nb) (Finset.univ.sup ma) with hd
  have hdb : ∀ i, nb i ≤ d := fun i =>
    le_trans (Finset.le_sup (Finset.mem_univ i)) (le_max_left _ _)
  have hda : ∀ j, ma j ≤ d := fun j =>
    le_trans (Finset.le_sup (Finset.mem_univ j)) (le_max_right _ _)
  set aa : Fin n₀ ⊕ Fin n₁ → M₀ :=
    Sum.elim g (fun j => x ^ (d - ma j) • a j) with haa
  set bb : Fin n₀ ⊕ Fin n₁ → M₁ :=
    Sum.elim (fun i => y ^ (d - nb i) • b i) g' with hbb
  have hab : ∀ i, σ₀ (aa i) = ρ₀ x ^ d • σ₁ (bb i) := by
    rintro (i | j)
    · have e1 : σ₁ (bb (Sum.inl i)) = ρ₁ y ^ (d - nb i) • σ₁ (b i) := by
        simp only [hbb, Sum.elim_inl]
        rw [hσ₁, map_pow]
      have e2 : ρ₀ x ^ d * ρ₁ y ^ (d - nb i) = ρ₀ x ^ nb i := by
        have hsplit : ρ₀ x ^ d = ρ₀ x ^ nb i * ρ₀ x ^ (d - nb i) := by
          rw [← pow_add]
          congr 1
          have := hdb i
          omega
        rw [hsplit, mul_assoc, hpow (d - nb i), mul_one]
      calc σ₀ (aa (Sum.inl i)) = σ₀ (g i) := by simp only [haa, Sum.elim_inl]
        _ = (1 : C₀₁) • σ₀ (g i) := (one_smul _ _).symm
        _ = (ρ₀ x ^ nb i * ρ₁ y ^ nb i) • σ₀ (g i) := by rw [hpow]
        _ = ρ₀ x ^ nb i • (ρ₁ y ^ nb i • σ₀ (g i)) := by rw [mul_smul]
        _ = ρ₀ x ^ nb i • σ₁ (b i) := by rw [hb i]
        _ = (ρ₀ x ^ d * ρ₁ y ^ (d - nb i)) • σ₁ (b i) := by rw [e2]
        _ = ρ₀ x ^ d • (ρ₁ y ^ (d - nb i) • σ₁ (b i)) := by rw [mul_smul]
        _ = ρ₀ x ^ d • σ₁ (bb (Sum.inl i)) := by rw [← e1]
    · have e3 : (d - ma j) + ma j = d := by
        have := hda j
        omega
      calc σ₀ (aa (Sum.inr j)) = σ₀ (x ^ (d - ma j) • a j) := by simp only [haa, Sum.elim_inr]
        _ = ρ₀ x ^ (d - ma j) • σ₀ (a j) := by rw [hσ₀, map_pow]
        _ = ρ₀ x ^ (d - ma j) • (ρ₀ x ^ ma j • σ₁ (g' j)) := by rw [ha j]
        _ = (ρ₀ x ^ (d - ma j) * ρ₀ x ^ ma j) • σ₁ (g' j) := by rw [mul_smul]
        _ = ρ₀ x ^ d • σ₁ (bb (Sum.inr j)) := by
              rw [← pow_add, e3]
              simp only [hbb, Sum.elim_inr]
  have hspanaa : Submodule.span C₀ (Set.range aa) = ⊤ := by
    refine le_antisymm le_top ?_
    rw [← hg]
    refine Submodule.span_mono ?_
    rintro _ ⟨i, rfl⟩
    exact ⟨Sum.inl i, by simp only [haa, Sum.elim_inl]⟩
  have hspanbb : Submodule.span C₁ (Set.range bb) = ⊤ := by
    refine le_antisymm le_top ?_
    rw [← hg']
    refine Submodule.span_mono ?_
    rintro _ ⟨j, rfl⟩
    exact ⟨Sum.inr j, by simp only [hbb, Sum.elim_inr]⟩
  -- ### Step 2: the twisted free datum `E` and its chart surjections
  set φ₀ : (Fin n₀ ⊕ Fin n₁ → C₀) →ₗ[C₀] M₀ := Fintype.linearCombination C₀ aa with hφ₀
  set φ₁ : (Fin n₀ ⊕ Fin n₁ → C₁) →ₗ[C₁] M₁ := Fintype.linearCombination C₁ bb with hφ₁
  set φ₀₁ : (Fin n₀ ⊕ Fin n₁ → C₀₁) →ₗ[C₀₁] V :=
    Fintype.linearCombination C₀₁ (fun i => σ₁ (bb i)) with hφ₀₁
  have hφ₀surj : Function.Surjective φ₀ := by
    rw [← LinearMap.range_eq_top, hφ₀, Fintype.range_linearCombination, hspanaa]
  have hφ₁surj : Function.Surjective φ₁ := by
    rw [← LinearMap.range_eq_top, hφ₁, Fintype.range_linearCombination, hspanbb]
  set ε₀ : (Fin n₀ ⊕ Fin n₁ → C₀) →ₗ[A] (Fin n₀ ⊕ Fin n₁ → C₀₁) :=
    LinearMap.pi (fun i =>
      LinearMap.mulLeft A (ρ₀ x ^ d) ∘ₗ ρ₀.toLinearMap ∘ₗ LinearMap.proj i) with hε₀
  set ε₁ : (Fin n₀ ⊕ Fin n₁ → C₁) →ₗ[A] (Fin n₀ ⊕ Fin n₁ → C₀₁) :=
    LinearMap.pi (fun i => ρ₁.toLinearMap ∘ₗ LinearMap.proj i) with hε₁
  have hε₀apply : ∀ (e : Fin n₀ ⊕ Fin n₁ → C₀) (i : Fin n₀ ⊕ Fin n₁),
      ε₀ e i = ρ₀ x ^ d * ρ₀ (e i) := fun e i => rfl
  have hε₁apply : ∀ (e : Fin n₀ ⊕ Fin n₁ → C₁) (i : Fin n₀ ⊕ Fin n₁),
      ε₁ e i = ρ₁ (e i) := fun e i => rfl
  -- the commuting squares
  have hsq₀ : ∀ e, φ₀₁ (ε₀ e) = σ₀ (φ₀ e) := by
    intro e
    rw [hφ₀₁, hφ₀, Fintype.linearCombination_apply, Fintype.linearCombination_apply, map_sum]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [hσ₀, hab i, smul_smul, hε₀apply, mul_comm]
  have hsq₁ : ∀ e, φ₀₁ (ε₁ e) = σ₁ (φ₁ e) := by
    intro e
    rw [hφ₀₁, hφ₁, Fintype.linearCombination_apply, Fintype.linearCombination_apply, map_sum]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [hσ₁, hε₁apply]
  -- semilinearity of the twisted inclusions over the coordinates
  have hε₀x : ∀ (j : ℕ) (e : Fin n₀ ⊕ Fin n₁ → C₀), ε₀ (x ^ j • e) = ρ₀ x ^ j • ε₀ e := by
    intro j e
    funext i
    rw [hε₀apply, Pi.smul_apply, Pi.smul_apply, smul_eq_mul, smul_eq_mul, hε₀apply,
      map_mul, map_pow]
    ring
  have hε₁y : ∀ (j : ℕ) (e : Fin n₀ ⊕ Fin n₁ → C₁), ε₁ (y ^ j • e) = ρ₁ y ^ j • ε₁ e := by
    intro j e
    funext i
    rw [hε₁apply, Pi.smul_apply, Pi.smul_apply, smul_eq_mul, smul_eq_mul, hε₁apply,
      map_mul, map_pow]
  -- ### Step 3: the kernel datum `K` and `Ȟ¹(K)` finiteness
  set K₀ : Submodule C₀ (Fin n₀ ⊕ Fin n₁ → C₀) := LinearMap.ker φ₀ with hK₀
  set K₁ : Submodule C₁ (Fin n₀ ⊕ Fin n₁ → C₁) := LinearMap.ker φ₁ with hK₁
  set K01 : Submodule C₀₁ (Fin n₀ ⊕ Fin n₁ → C₀₁) := LinearMap.ker φ₀₁ with hK01
  haveI hKfin : Module.Finite C₀ ↥K₀ :=
    Module.Finite.iff_fg.mpr (IsNoetherian.noetherian K₀)
  haveI hscc : SMulCommClass A C₀₁ ↥K01 :=
    ⟨fun r c m => Subtype.ext (smul_comm r c (m : Fin n₀ ⊕ Fin n₁ → C₀₁))⟩
  have hε₀K : ∀ e ∈ K₀, ε₀ e ∈ K01 := by
    intro e he
    rw [hK01, LinearMap.mem_ker, hsq₀, LinearMap.mem_ker.mp he, map_zero]
  have hε₁K : ∀ e ∈ K₁, ε₁ e ∈ K01 := by
    intro e he
    rw [hK01, LinearMap.mem_ker, hsq₁, LinearMap.mem_ker.mp he, map_zero]
  set κ₀ : ↥K₀ →ₗ[A] ↥K01 :=
    { toFun := fun e => ⟨ε₀ e.1, hε₀K _ e.2⟩
      map_add' := fun e f => Subtype.ext (by
        change ε₀ (e.1 + f.1) = ε₀ e.1 + ε₀ f.1
        rw [map_add])
      map_smul' := fun r e => Subtype.ext (by
        change ε₀ (r • e.1) = r • ε₀ e.1
        rw [map_smul]) } with hκ₀
  set κ₁ : ↥K₁ →ₗ[A] ↥K01 :=
    { toFun := fun e => ⟨ε₁ e.1, hε₁K _ e.2⟩
      map_add' := fun e f => Subtype.ext (by
        change ε₁ (e.1 + f.1) = ε₁ e.1 + ε₁ f.1
        rw [map_add])
      map_smul' := fun r e => Subtype.ext (by
        change ε₁ (r • e.1) = r • ε₁ e.1
        rw [map_smul]) } with hκ₁
  have hκ₀x : ∀ (j : ℕ) (e : ↥K₀), κ₀ (x ^ j • e) = ρ₀ x ^ j • κ₀ e := by
    intro j e
    refine Subtype.ext ?_
    change ε₀ (x ^ j • e.1) = ρ₀ x ^ j • ε₀ e.1
    exact hε₀x j _
  have hκ₁y : ∀ (j : ℕ) (e : ↥K₁), κ₁ (y ^ j • e) = ρ₁ y ^ j • κ₁ e := by
    intro j e
    refine Subtype.ext ?_
    change ε₁ (y ^ j • e.1) = ρ₁ y ^ j • ε₁ e.1
    exact hε₁y j _
  -- t-side extension for the kernel datum
  have hextK₀ : ∀ κ : ↥K01, ∃ (n : ℕ) (e : ↥K₀), ρ₀ x ^ n • κ = κ₀ e := by
    intro κ
    choose nn cc hcc using fun i : Fin n₀ ⊕ Fin n₁ => hRext₀ (κ.1 i)
    set N : ℕ := Finset.univ.sup nn with hN
    set e : Fin n₀ ⊕ Fin n₁ → C₀ := fun i => x ^ (N - nn i) * cc i with he
    have he₀ : ε₀ e = ρ₀ x ^ (d + N) • (κ : Fin n₀ ⊕ Fin n₁ → C₀₁) := by
      funext i
      rw [Pi.smul_apply, smul_eq_mul, hε₀apply, he]
      rw [map_mul, map_pow, ← hcc i]
      have hexp : ρ₀ x ^ d * (ρ₀ x ^ (N - nn i) * (ρ₀ x ^ nn i * κ.1 i)) =
          (ρ₀ x ^ d * ρ₀ x ^ (N - nn i) * ρ₀ x ^ nn i) * κ.1 i := by ring
      rw [hexp, ← pow_add, ← pow_add,
        show d + (N - nn i) + nn i = d + N by
          have : nn i ≤ N := Finset.le_sup (Finset.mem_univ i)
          omega]
    have hφe : σ₀ (φ₀ e) = 0 := by
      rw [← hsq₀, he₀, map_smul, LinearMap.mem_ker.mp κ.2, smul_zero]
    obtain ⟨m, hm⟩ := htor₀ (φ₀ e) hφe
    have hmem : x ^ m • e ∈ K₀ := by
      rw [hK₀, LinearMap.mem_ker, map_smul, hm]
    refine ⟨m + (d + N), ⟨x ^ m • e, hmem⟩, ?_⟩
    refine Subtype.ext ?_
    change ρ₀ x ^ (m + (d + N)) • κ.1 = ε₀ (x ^ m • e)
    rw [hε₀x m e, he₀, smul_smul, ← pow_add]
  -- u-side extension for the kernel datum
  have hextK₁ : ∀ κ : ↥K01, ∃ (n : ℕ) (e : ↥K₁), ρ₁ y ^ n • κ = κ₁ e := by
    intro κ
    choose nn cc hcc using fun i : Fin n₀ ⊕ Fin n₁ => hRext₁ (κ.1 i)
    set N : ℕ := Finset.univ.sup nn with hN
    set e : Fin n₀ ⊕ Fin n₁ → C₁ := fun i => y ^ (N - nn i) * cc i with he
    have he₀ : ε₁ e = ρ₁ y ^ N • (κ : Fin n₀ ⊕ Fin n₁ → C₀₁) := by
      funext i
      rw [Pi.smul_apply, smul_eq_mul, hε₁apply, he]
      rw [map_mul, map_pow, ← hcc i]
      have hexp : ρ₁ y ^ (N - nn i) * (ρ₁ y ^ nn i * κ.1 i) =
          (ρ₁ y ^ (N - nn i) * ρ₁ y ^ nn i) * κ.1 i := by ring
      rw [hexp, ← pow_add,
        show N - nn i + nn i = N by
          have : nn i ≤ N := Finset.le_sup (Finset.mem_univ i)
          omega]
    have hφe : σ₁ (φ₁ e) = 0 := by
      rw [← hsq₁, he₀, map_smul, LinearMap.mem_ker.mp κ.2, smul_zero]
    obtain ⟨m, hm⟩ := htor₁ (φ₁ e) hφe
    have hmem : y ^ m • e ∈ K₁ := by
      rw [hK₁, LinearMap.mem_ker, map_smul, hm]
    refine ⟨m + N, ⟨y ^ m • e, hmem⟩, ?_⟩
    refine Subtype.ext ?_
    change ρ₁ y ^ (m + N) • κ.1 = ε₁ (y ^ m • e)
    rw [hε₁y m e, he₀, smul_smul, ← pow_add]
  -- the two lattices in `K₀₁` and the ladder span
  set NL₀ : Submodule A ↥K01 := LinearMap.range κ₀ with hNL₀
  set NL₁ : Submodule A ↥K01 := LinearMap.range κ₁ with hNL₁
  have h₀stab : ∀ z ∈ NL₀, ρ₀ x • z ∈ NL₀ := by
    rintro _ ⟨e, rfl⟩
    refine ⟨x • e, ?_⟩
    have h := hκ₀x 1 e
    rw [pow_one, pow_one] at h
    exact h
  have h₁stab : ∀ z ∈ NL₁, ρ₁ y • z ∈ NL₁ := by
    rintro _ ⟨e, rfl⟩
    refine ⟨y • e, ?_⟩
    have h := hκ₁y 1 e
    rw [pow_one, pow_one] at h
    exact h
  obtain ⟨G, hG⟩ := AlgebraicGeometry.Adelic.exists_finset_forall_mem_span_pow_smul
    (A := A) (MM := ↥K₀) x hspan₀
  set s : Set ↥K01 := ⇑κ₀ '' ↑G with hsdef
  have Hpow : ∀ κ : ↥K01, ∃ n : ℕ,
      ρ₀ x ^ n • κ ∈ Submodule.span A (⋃ j : ℕ, (fun z => ρ₀ x ^ j • z) '' s) := by
    intro κ
    obtain ⟨n, e, he⟩ := hextK₀ κ
    refine ⟨n, ?_⟩
    rw [he]
    have h1 : κ₀ e ∈ Submodule.map κ₀ (Submodule.span A
        (⋃ j : ℕ, (fun z => x ^ j • z) '' (G : Set ↥K₀))) :=
      Submodule.mem_map_of_mem (hG e)
    rw [Submodule.map_span] at h1
    refine Submodule.span_le.mpr ?_ h1
    rintro _ ⟨z, hz, rfl⟩
    simp only [Set.mem_iUnion, Set.mem_image] at hz
    obtain ⟨j, w, hw, rfl⟩ := hz
    refine Submodule.subset_span (Set.mem_iUnion.mpr ⟨j, ⟨κ₀ w, ⟨w, hw, rfl⟩, ?_⟩⟩)
    exact (hκ₀x j w).symm
  have hspanladder := AlgebraicGeometry.Adelic.span_smul_ladder_of_pow_smul_mem_span
    (A := A) htu s Hpow
  have hsfin : s.Finite := G.finite_toSet.image _
  have hsNL₀ : s ⊆ (NL₀ : Set ↥K01) := by
    rintro _ ⟨w, _, rfl⟩
    exact ⟨w, rfl⟩
  have hextcore : ∀ z ∈ s, ∃ n : ℕ, ρ₁ y ^ n • z ∈ NL₁ := by
    intro z _
    obtain ⟨n, e, he⟩ := hextK₁ z
    exact ⟨n, he ▸ ⟨e, rfl⟩⟩
  have hQfin : Module.Finite A (↥K01 ⧸ (NL₀ ⊔ NL₁)) :=
    AlgebraicGeometry.Adelic.module_finite_quotient_of_smul_laurent_pair
      h₀stab h₁stab hsfin hsNL₀ hspanladder hextcore
  -- ### Step 4: `Ȟ⁰(E)` is `A`-finite via the twisted-line reduction
  set τ₀ : C₀ →ₗ[A] C₀₁ := LinearMap.mulLeft A (ρ₀ x ^ d) ∘ₗ ρ₀.toLinearMap with hτ₀
  have hSd : (LinearMap.ker (cechDiff τ₀ ρ₁.toLinearMap)).FG :=
    fg_ker_cechDiff_twisted ρ₀ ρ₁ x y htu hspan₀ hRtor₀ hS0 d
  set DE : ((Fin n₀ ⊕ Fin n₁ → C₀) × (Fin n₀ ⊕ Fin n₁ → C₁)) →ₗ[A]
      (Fin n₀ ⊕ Fin n₁ → C₀₁) := cechDiff ε₀ ε₁ with hDE
  have hDEmem : ∀ z : (Fin n₀ ⊕ Fin n₁ → C₀) × (Fin n₀ ⊕ Fin n₁ → C₁),
      z ∈ LinearMap.ker DE ↔
        ∀ i, cechDiff τ₀ ρ₁.toLinearMap (z.1 i, z.2 i) = 0 := by
    intro z
    rw [LinearMap.mem_ker]
    constructor
    · intro h i
      have h' := congrFun h i
      simpa [hDE, cechDiff_apply, hτ₀, Pi.sub_apply, hε₀apply, hε₁apply] using h'
    · intro h
      funext i
      have h' := h i
      simpa [hDE, cechDiff_apply, hτ₀, Pi.sub_apply, hε₀apply, hε₁apply] using h'
  haveI hSdfin : Module.Finite A ↥(LinearMap.ker (cechDiff τ₀ ρ₁.toLinearMap)) :=
    Module.Finite.iff_fg.mpr hSd
  set Ξ : (Fin n₀ ⊕ Fin n₁ → ↥(LinearMap.ker (cechDiff τ₀ ρ₁.toLinearMap))) →ₗ[A]
      ↥(LinearMap.ker DE) :=
    { toFun := fun sfun => ⟨(fun i => ((sfun i : C₀ × C₁)).1, fun i => ((sfun i : C₀ × C₁)).2),
        (hDEmem _).mpr fun i => LinearMap.mem_ker.mp (sfun i).2⟩
      map_add' := fun sf sg => Subtype.ext (Prod.ext
        (funext fun i => rfl) (funext fun i => rfl))
      map_smul' := fun r sf => Subtype.ext (Prod.ext
        (funext fun i => rfl) (funext fun i => rfl)) } with hΞ
  have hΞsurj : Function.Surjective Ξ := by
    rintro ⟨⟨e₀, e₁⟩, hz⟩
    refine ⟨fun i => ⟨(e₀ i, e₁ i), LinearMap.mem_ker.mpr ((hDEmem _).mp hz i)⟩, ?_⟩
    exact Subtype.ext (Prod.ext rfl rfl)
  haveI hkerDEfin : Module.Finite A ↥(LinearMap.ker DE) :=
    Module.Finite.of_surjective Ξ hΞsurj
  -- ### Step 5: the connecting snake and the finiteness assembly
  set DM : (M₀ × M₁) →ₗ[A] V := cechDiff σ₀ σ₁ with hDM
  set W : Submodule A ((Fin n₀ ⊕ Fin n₁ → C₀) × (Fin n₀ ⊕ Fin n₁ → C₁)) :=
    LinearMap.ker ((φ₀₁.restrictScalars A) ∘ₗ DE) with hW
  set ΦW : ↥W →ₗ[A] ↥(LinearMap.ker DM) :=
    { toFun := fun w => ⟨(φ₀ w.1.1, φ₁ w.1.2), by
        rw [LinearMap.mem_ker, hDM, cechDiff_apply, ← hsq₀, ← hsq₁]
        have hw := LinearMap.mem_ker.mp w.2
        rw [LinearMap.comp_apply, LinearMap.restrictScalars_apply] at hw
        have hsub : φ₀₁ (ε₀ w.1.1) - φ₀₁ (ε₁ w.1.2) = φ₀₁ (DE w.1) := by
          rw [hDE, cechDiff_apply, map_sub]
        rw [hsub, hw]⟩
      map_add' := fun w w' => Subtype.ext (Prod.ext
        (by change φ₀ (w.1.1 + w'.1.1) = _; rw [map_add]; rfl)
        (by change φ₁ (w.1.2 + w'.1.2) = _; rw [map_add]; rfl))
      map_smul' := fun r w => Subtype.ext (Prod.ext
        (by change φ₀ (r • w.1.1) = _; rw [LinearMap.map_smul_of_tower]; rfl)
        (by change φ₁ (r • w.1.2) = _; rw [LinearMap.map_smul_of_tower]; rfl)) } with hΦW
  have hΦWsurj : Function.Surjective ΦW := by
    rintro ⟨⟨m₀, m₁⟩, hm⟩
    obtain ⟨e₀, rfl⟩ := hφ₀surj m₀
    obtain ⟨e₁, rfl⟩ := hφ₁surj m₁
    have hWmem : ((e₀, e₁) : (Fin n₀ ⊕ Fin n₁ → C₀) × (Fin n₀ ⊕ Fin n₁ → C₁)) ∈ W := by
      rw [hW, LinearMap.mem_ker, LinearMap.comp_apply, LinearMap.restrictScalars_apply,
        hDE, cechDiff_apply, map_sub, hsq₀, hsq₁]
      have := LinearMap.mem_ker.mp hm
      rw [hDM, cechDiff_apply] at this
      exact this
    exact ⟨⟨(e₀, e₁), hWmem⟩, Subtype.ext rfl⟩
  set DEK : ↥W →ₗ[A] ↥K01 :=
    { toFun := fun w => ⟨DE w.1, by
        rw [hK01, LinearMap.mem_ker]
        have hw := LinearMap.mem_ker.mp w.2
        rw [LinearMap.comp_apply, LinearMap.restrictScalars_apply] at hw
        exact hw⟩
      map_add' := fun w w' => Subtype.ext (by
        change DE (w.1 + w'.1) = DE w.1 + DE w'.1
        rw [map_add])
      map_smul' := fun r w => Subtype.ext (by
        change DE (r • w.1) = r • DE w.1
        rw [map_smul]) } with hDEK
  set Θb : ↥W →ₗ[A] (↥K01 ⧸ (NL₀ ⊔ NL₁)) := (NL₀ ⊔ NL₁).mkQ ∘ₗ DEK with hΘb
  have hkerincl : LinearMap.ker ΦW ≤ LinearMap.ker Θb := by
    intro w hw
    rw [LinearMap.mem_ker] at hw ⊢
    have hw' : φ₀ w.1.1 = 0 ∧ φ₁ w.1.2 = 0 := by
      have h := Subtype.ext_iff.mp hw
      exact ⟨congrArg Prod.fst h, congrArg Prod.snd h⟩
    have hd0 : DEK w = κ₀ ⟨w.1.1, LinearMap.mem_ker.mpr hw'.1⟩
        - κ₁ ⟨w.1.2, LinearMap.mem_ker.mpr hw'.2⟩ := by
      refine Subtype.ext ?_
      change DE w.1 = ε₀ w.1.1 - ε₁ w.1.2
      rw [hDE, cechDiff_apply]
    rw [hΘb, LinearMap.comp_apply, Submodule.mkQ_apply, Submodule.Quotient.mk_eq_zero, hd0]
    exact sub_mem (Submodule.mem_sup_left ⟨_, rfl⟩) (Submodule.mem_sup_right ⟨_, rfl⟩)
  set ψ : (↥W ⧸ LinearMap.ker ΦW) →ₗ[A] (↥K01 ⧸ (NL₀ ⊔ NL₁)) :=
    (LinearMap.ker ΦW).liftQ Θb hkerincl with hψ
  -- the `Ȟ⁰(E)`-part of `W`
  have hDEleW : LinearMap.ker DE ≤ W := by
    intro z hz
    rw [hW, LinearMap.mem_ker, LinearMap.comp_apply, LinearMap.restrictScalars_apply,
      LinearMap.mem_ker.mp hz, map_zero]
  set J : Submodule A ↥W := (LinearMap.ker DE).comap W.subtype with hJ
  have hJfin : J.FG := by
    have e := Submodule.comapSubtypeEquivOfLe hDEleW
    haveI : Module.Finite A ↥J := Module.Finite.equiv e.symm
    exact Module.Finite.iff_fg.mp this
  have hkerΘb : LinearMap.ker Θb = J ⊔ LinearMap.ker ΦW := by
    refine le_antisymm ?_ (sup_le ?_ hkerincl)
    · intro w hw
      rw [LinearMap.mem_ker, hΘb, LinearMap.comp_apply, Submodule.mkQ_apply,
        Submodule.Quotient.mk_eq_zero] at hw
      obtain ⟨p, hp, q, hq, hpq⟩ := Submodule.mem_sup.mp hw
      obtain ⟨k₀, rfl⟩ := hp
      obtain ⟨k₁, rfl⟩ := hq
      have hamb : DE w.1 = ε₀ k₀.1 + ε₁ k₁.1 := by
        have h := congrArg Subtype.val hpq
        exact h.symm
      set kp : (Fin n₀ ⊕ Fin n₁ → C₀) × (Fin n₀ ⊕ Fin n₁ → C₁) :=
        (k₀.1, -k₁.1) with hkp
      have hDEkp : DE kp = ε₀ k₀.1 + ε₁ k₁.1 := by
        rw [hDE, cechDiff_apply, hkp]
        change ε₀ k₀.1 - ε₁ (-k₁.1) = _
        rw [map_neg, sub_neg_eq_add]
      have hkpW : kp ∈ W := by
        rw [hW, LinearMap.mem_ker, LinearMap.comp_apply, LinearMap.restrictScalars_apply,
          hDEkp, map_add, hsq₀, hsq₁, LinearMap.mem_ker.mp k₀.2, LinearMap.mem_ker.mp k₁.2,
          map_zero, map_zero, add_zero]
      have hkpker : (⟨kp, hkpW⟩ : ↥W) ∈ LinearMap.ker ΦW := by
        rw [LinearMap.mem_ker]
        refine Subtype.ext (Prod.ext ?_ ?_)
        · change φ₀ k₀.1 = 0
          exact LinearMap.mem_ker.mp k₀.2
        · change φ₁ (-k₁.1) = 0
          rw [map_neg, LinearMap.mem_ker.mp k₁.2, neg_zero]
      have hsplit : w = (w - ⟨kp, hkpW⟩) + ⟨kp, hkpW⟩ := by
        rw [sub_add_cancel]
      rw [hsplit]
      refine Submodule.add_mem _ (Submodule.mem_sup_left ?_) (Submodule.mem_sup_right hkpker)
      rw [hJ, Submodule.mem_comap, LinearMap.mem_ker]
      change DE (w.1 - kp) = 0
      rw [map_sub, hamb, hDEkp, sub_self]
    · intro w hw
      rw [hJ, Submodule.mem_comap, LinearMap.mem_ker] at hw
      rw [LinearMap.mem_ker, hΘb, LinearMap.comp_apply, Submodule.mkQ_apply,
        Submodule.Quotient.mk_eq_zero]
      have hDEK0 : DEK w = 0 := Subtype.ext (by
        change DE w.1 = 0
        exact hw)
      rw [hDEK0]
      exact Submodule.zero_mem _
  have hkerψfg : (LinearMap.ker ψ).FG := by
    have hkerψ : LinearMap.ker ψ = (LinearMap.ker Θb).map (LinearMap.ker ΦW).mkQ :=
      Submodule.ker_liftQ _ _ _
    rw [hkerψ, hkerΘb, Submodule.map_sup]
    have h1 : (LinearMap.ker ΦW).map (LinearMap.ker ΦW).mkQ = ⊥ := by
      rw [eq_bot_iff]
      rintro _ ⟨z, hz, rfl⟩
      simpa [Submodule.mkQ_apply, Submodule.Quotient.mk_eq_zero] using hz
    rw [h1, sup_bot_eq]
    exact hJfin.map _
  haveI := hQfin
  haveI hQnoeth : IsNoetherian A (↥K01 ⧸ (NL₀ ⊔ NL₁)) :=
    isNoetherian_of_isNoetherianRing_of_finite A _
  have htop : (⊤ : Submodule A (↥W ⧸ LinearMap.ker ΦW)).FG := by
    refine Submodule.fg_of_fg_map_of_fg_inf_ker ψ ?_ ?_
    · exact IsNoetherian.noetherian _
    · rw [top_inf_eq]
      exact hkerψfg
  haveI : Module.Finite A (↥W ⧸ LinearMap.ker ΦW) := Module.finite_def.mpr htop
  haveI : Module.Finite A ↥(LinearMap.ker DM) :=
    Module.Finite.equiv (ΦW.quotKerEquivOfSurjective hΦWsurj)
  exact Module.Finite.iff_fg.mp this

end TwoChart

end AlgebraicJacobian

namespace AlgebraicGeometry

/-! ## §4. Localization facts on affine charts (ring and module dialects)

The extension/torsion hypotheses of the abstract theorem, discharged from
mathlib's `IsAffineOpen.isLocalization_basicOpen` (ring side) and the qcqs
section-localization engine `isLocalizedModule_basicOpen_of_isCompact`
(module side, `Picard/QuotScheme.lean`), both in the caller-friendly
`W = X.basicOpen f` transport shape of `exists_pow_smul_eq_res`. -/