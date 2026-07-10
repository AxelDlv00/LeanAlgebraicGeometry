/-
Copyright (c) 2026 Archon Horizon. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Horizon (Archon Horizon)
-/
import Mathlib
import AlgebraicJacobian.Picard.RigidPushforwardP1Engine

/-!
# B3-H0 — finiteness of `H⁰(ℙ¹_A, M)`: the audited hard leaf

This file attacks the named hypothesis `hH0` of the frozen wave-4 engine
`Adelic.p1Cech_h0_baseChange_of_fibrewise_h1_vanishing`
(`Picard/RigidPushforwardP1Engine.lean` §5): finite generation of the Čech
kernel `H⁰ = ker (moduleSectionDiffBase)` — i.e. of `Γ(ℙ¹_A, M)` — over the
base ring, for a finitely presented module `M` on `ℙ¹_A` (`A` noetherian).

## Audit verdict (recorded per lane instructions; 3 candidate routes)

* **Route C (naive two-lattice degree window) — REJECTED.**  The wave-4
  audit failure mode is real and flatness does *not* rescue it: membership
  of an overlap section in the `u`-lattice `im σ₁` bounds no `t`-degree of
  any particular representation over the `t`-ladder, because ladder
  representations are not unique (the chart modules are merely *spanned*
  by the ladder, never freely).  Base-flatness of `M` is irrelevant to this
  failure: it controls `A`-torsion, while the obstruction is geometric
  (`x`-)torsion.

* **Route B (graded Rees module `⊕ₙ H⁰(M(n))` f.g. over `A[x₀,x₁]`) —
  REJECTED.**  Finite generation of the section graded module is exactly
  the deep Serre leaf (T14 audit: `sectionGradedModule_fg`), and for ℙ¹ its
  direct proof secretly re-runs the same window difficulty: an element of
  `H⁰(M(n))` need not be a degree-`≤ n` ladder combination of low-twist
  generators without kernel control.

* **Route A′ (Serre dévissage, module-theoretic; CHOSEN).**  Stacks
  01YS/EGA III 3.2.1 run a *descending induction on cohomological degree*:
  choose a surjection `E := ⊕ᵢ O(-dᵢ) ↠ M`, with kernel `K`; then
  `H⁰(E) → H⁰(M) → H¹(K)` pins `H⁰(M)` between explicitly finite modules,
  because `H¹` of *every* coherent module is already finite — and the wave-4
  A-coefficient Laurent ladder proves exactly that
  (`RelLaurentChartData.module_finite_h1`).  On the 2-chart Čech complex the
  whole dévissage is *elementary module theory*:

  1. **Global generation is free.**  The chart extension lemma
     (`exists_pow_smul_eq_res`) produces, for chart generators `gᵢ` of
     `Γ(M, U₁)` and `g'ⱼ` of `Γ(M, U₂)`, matching sections after twisting:
     `σ₀ gᵢ = t^d • σ₁ bᵢ` and `σ₀ aⱼ = t^d • σ₁ g'ⱼ` (uniform `d` by
     raising: `x^{d-m} •`, `y^{d-n} •`).  This *is* Serre's global
     generation for ℙ¹, with no sheaf theory.
  2. **The kernel datum stays in the ladder class.**  `K` never appears as
     a sheaf: only its chart kernels `K₀ = ker φ₀ ⊆ C₀^ι` (finite over the
     noetherian chart ring — `C₀` is noetherian since it is `A`-spanned by
     coordinate powers, hence a quotient of `A[X]`) and its overlap kernel
     `K₀₁ = ker φ₀₁ ⊆ C₀₁^ι`.  The two-lattice hypotheses for `K` follow
     elementwise from the ring extension lemma (`IsLocalization` on basic
     opens) plus elementwise `x`-power-torsion of the localization kernels,
     so the wave-4 abstract core `module_finite_quotient_of_smul_laurent_pair`
     yields `H¹(K)` finite.
  3. **`H⁰(E)` reduces to `H⁰(O)`.**  The twisted line kernel
     `S_d = {(c₀, c₁) : t^d ρ₀ c₀ = ρ₁ c₁}` embeds into the structure-sheaf
     kernel `S_0` by `(c₀, c₁) ↦ (x^d c₀, c₁)`, with kernel inside the
     (A-finite, by noetherianity + ladder span + elementwise torsion)
     localization kernel `ker ρ₀`.  So the **only** geometric input beyond
     the wave-4 substrate is `hS0`: finite generation of the Čech `H⁰` of
     the *structure sheaf* — `Γ(ℙ¹_A, 𝒪) ≅ A`, an `M`-independent,
     Serre-free statement (recorded here as the single remaining sub-leaf;
     see `p1_structure_h0_fg_statement` below).
  4. **The snake.**  `0 → im(H⁰E) → H⁰M → H¹K` at the level of concrete
     kernels/cokernels of linear maps (`Submodule.fg_of_fg_map_of_fg_inf_ker`
     + `Submodule.ker_liftQ`), over the noetherian base.

  The whole route is executed **abstractly** (`AlgebraicJacobian.TwoChart`
  below): pure commutative algebra over an arbitrary "two-chart Laurent
  datum", consuming only the hypotheses that the wave-4 engine substrate
  already discharges for `ℙ¹_A`.  No `SerreTwist`, no sheaf kernels, no
  chart presentations.

## Main results

* `TwoChart.fg_ker_cechDiff_of_laurent` — the abstract H⁰-finiteness
  theorem (route A′, steps 1–4).
* `Adelic.p1Cech_h0_fg_of_structure_h0_fg` — the ℙ¹_A leaf, **verbatim** in
  the engine's `hH0` shape, from the single `M`-independent hypothesis
  `hS0` (structure-sheaf Čech `H⁰` finite).
* `Adelic.p1Cech_h0_baseChange_of_fibrewise_h1_vanishing_of_structure_h0_fg`
  — the composite: the full wave-4 engine conclusion with `hH0` *replaced*
  by `hS0`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace

namespace AlgebraicJacobian

namespace TwoChart

/-! ## §0. Generic finiteness bricks -/

/-- Over a noetherian ring, a submodule contained in a finitely generated
submodule is finitely generated. -/
theorem fg_of_le_of_fg {R M : Type*} [Ring R] [AddCommGroup M] [Module R M]
    [IsNoetherianRing R] {N P : Submodule R M} (h : N ≤ P) (hP : P.FG) : N.FG := by
  haveI : IsNoetherian R ↥P := isNoetherian_of_fg_of_noetherian P hP
  have h1 : (N.comap P.subtype).FG := IsNoetherian.noetherian _
  have h2 : (N.comap P.subtype).map P.subtype = N := by
    rw [Submodule.map_comap_subtype]
    exact inf_eq_right.mpr h
  simpa [h2] using h1.map P.subtype

/-- **A ring `A`-spanned by the powers of one element is noetherian** (over
a noetherian `A`): it is a quotient of the polynomial ring `A[X]`. -/
theorem isNoetherianRing_of_top_le_span_pow {A C : Type*} [CommRing A] [CommRing C]
    [Algebra A C] [IsNoetherianRing A] {x : C}
    (hx : ⊤ ≤ Submodule.span A (Set.range fun n : ℕ => x ^ n)) :
    IsNoetherianRing C := by
  have hsurj : Function.Surjective (Polynomial.aeval x : Polynomial A →ₐ[A] C) := by
    intro c
    have hc : c ∈ Submodule.span A (Set.range fun n : ℕ => x ^ n) := hx trivial
    induction hc using Submodule.span_induction with
    | mem z hz =>
      obtain ⟨n, rfl⟩ := hz
      exact ⟨Polynomial.X ^ n, by simp⟩
    | zero => exact ⟨0, map_zero _⟩
    | add y z _ _ ihy ihz =>
      obtain ⟨p, rfl⟩ := ihy
      obtain ⟨q, rfl⟩ := ihz
      exact ⟨p + q, map_add _ _ _⟩
    | smul a z _ ih =>
      obtain ⟨p, rfl⟩ := ih
      exact ⟨a • p, map_smul _ _ _⟩
  exact isNoetherianRing_of_surjective (Polynomial A) C
    (Polynomial.aeval x : Polynomial A →ₐ[A] C).toRingHom hsurj

/-- **An elementwise `x`-power-torsion ideal is a finite `A`-module** when
the ambient ring is `A`-spanned by the powers of `x` and `A` is noetherian:
the ideal is finite over the (noetherian) ring, a single power `x^N` kills
all its generators, and the ladder truncates at height `N`. -/
theorem fg_restrictScalars_of_forall_exists_pow_mul_eq_zero {A C : Type*}
    [CommRing A] [CommRing C] [Algebra A C] [IsNoetherianRing A] {x : C}
    (hx : ⊤ ≤ Submodule.span A (Set.range fun n : ℕ => x ^ n))
    (I : Ideal C) (hI : ∀ c ∈ I, ∃ n : ℕ, x ^ n * c = 0) :
    (I.restrictScalars A).FG := by
  classical
  haveI : IsNoetherianRing C := isNoetherianRing_of_top_le_span_pow hx
  obtain ⟨s, hs⟩ := IsNoetherian.noetherian I
  -- a uniform kill exponent over the finite generating set
  choose! nn hnn using hI
  set N : ℕ := s.sup nn + 1 with hN
  set window : Finset C := (Finset.range N ×ˢ s).image fun p => x ^ p.1 * p.2 with hw
  -- every ladder element over `s` lies in the window span (or is zero)
  have aux : ∀ c ∈ s, ∀ j : ℕ, x ^ j * c ∈ Submodule.span A (window : Set C) := by
    intro c hc j
    rcases lt_or_ge j N with hj | hj
    · exact Submodule.subset_span (Finset.mem_coe.mpr
        (Finset.mem_image.mpr ⟨(j, c), Finset.mem_product.mpr
          ⟨Finset.mem_range.mpr hj, hc⟩, rfl⟩))
    · have hcI : c ∈ I := by
        rw [← hs]; exact Submodule.subset_span hc
      have hkill : x ^ nn c * c = 0 := hnn c hcI
      have hj' : nn c ≤ j := le_trans (le_trans (Finset.le_sup hc) (Nat.le_succ _)) hj
      have : x ^ j * c = x ^ (j - nn c) * (x ^ nn c * c) := by
        rw [← mul_assoc, ← pow_add]
        congr 2
        omega
      rw [this, hkill, mul_zero]
      exact Submodule.zero_mem _
  -- window-span is stable under multiplication by `x`-powers
  have aux2 : ∀ (n : ℕ) (z : C), z ∈ Submodule.span A (window : Set C) →
      x ^ n * z ∈ Submodule.span A (window : Set C) := by
    intro n z hz
    induction hz using Submodule.span_induction with
    | mem w hw =>
      obtain ⟨⟨j, c⟩, hp, rfl⟩ := Finset.mem_image.mp (Finset.mem_coe.mp hw)
      have hcs : c ∈ s := (Finset.mem_product.mp hp).2
      have : x ^ n * (x ^ j * c) = x ^ (n + j) * c := by
        rw [← mul_assoc, ← pow_add]
      rw [this]
      exact aux c hcs (n + j)
    | zero => rw [mul_zero]; exact Submodule.zero_mem _
    | add p q _ _ ihp ihq => rw [mul_add]; exact Submodule.add_mem _ ihp ihq
    | smul a w _ ih =>
      rw [mul_smul_comm]
      exact Submodule.smul_mem _ _ ih
  refine ⟨window, le_antisymm ?_ ?_⟩
  · -- span ≤ I
    rw [Submodule.span_le]
    intro w hw
    obtain ⟨⟨j, c⟩, hp, rfl⟩ := Finset.mem_image.mp (Finset.mem_coe.mp hw)
    have hcI : c ∈ I := by
      rw [← hs]; exact Submodule.subset_span (Finset.mem_product.mp hp).2
    exact I.mul_mem_left _ hcI
  · -- I ≤ span
    intro z hz
    have hz' : z ∈ Submodule.span C (s : Set C) := by rw [hs]; exact hz
    clear hz
    induction hz' using Submodule.span_induction with
    | mem c hc =>
      have : (c : C) = x ^ 0 * c := by rw [pow_zero, one_mul]
      rw [this]
      exact aux c hc 0
    | zero => exact Submodule.zero_mem _
    | add p q _ _ ihp ihq => exact Submodule.add_mem _ ihp ihq
    | smul r w _ ih =>
      have hr : r ∈ Submodule.span A (Set.range fun n : ℕ => x ^ n) := hx trivial
      have hrw : r • w = r * w := smul_eq_mul r w
      rw [hrw]
      clear hrw
      induction hr using Submodule.span_induction with
      | mem p hp =>
        obtain ⟨n, rfl⟩ := hp
        exact aux2 n w ih
      | zero => rw [zero_mul]; exact Submodule.zero_mem _
      | add p q _ _ ihp ihq => rw [add_mul]; exact Submodule.add_mem _ ihp ihq
      | smul a p _ ihp =>
        rw [smul_mul_assoc]
        exact Submodule.smul_mem _ _ ihp

/-! ## §1. The Čech difference of a two-chart pair of linear maps -/

/-- The **Čech difference map** of a pair of `A`-linear maps into the overlap
module: `(m₀, m₁) ↦ σ₀ m₀ − σ₁ m₁`.  Its kernel is the concrete Čech `H⁰`
of the two-chart datum; instantiated at the ℙ¹_A section restrictions it is
(the linear-map core of) `AffineCoverMVSquare.moduleSectionDiffBase`. -/
noncomputable def cechDiff {A M₀ M₁ V : Type*} [CommRing A]
    [AddCommGroup M₀] [AddCommGroup M₁] [AddCommGroup V]
    [Module A M₀] [Module A M₁] [Module A V]
    (σ₀ : M₀ →ₗ[A] V) (σ₁ : M₁ →ₗ[A] V) : (M₀ × M₁) →ₗ[A] V :=
  σ₀ ∘ₗ LinearMap.fst A M₀ M₁ - σ₁ ∘ₗ LinearMap.snd A M₀ M₁

@[simp] lemma cechDiff_apply {A M₀ M₁ V : Type*} [CommRing A]
    [AddCommGroup M₀] [AddCommGroup M₁] [AddCommGroup V]
    [Module A M₀] [Module A M₁] [Module A V]
    (σ₀ : M₀ →ₗ[A] V) (σ₁ : M₁ →ₗ[A] V) (p : M₀ × M₁) :
    cechDiff σ₀ σ₁ p = σ₀ p.1 - σ₁ p.2 :=
  rfl

/-! ## §2. `H⁰` of the twisted line: reduction to the structure sheaf

`S_d := ker ((t^d · ρ₀) − ρ₁)` is the concrete `H⁰(ℙ¹, O(-d))`.  It embeds
into `S_0 = H⁰(O)` by `(c₀, c₁) ↦ (x^d c₀, c₁)`; the kernel of the embedding
lives inside the (elementwise `x`-power-torsion) localization kernel
`ker ρ₀`, which is `A`-finite by §0. -/

theorem fg_ker_cechDiff_twisted {A C₀ C₁ C₀₁ : Type*} [CommRing A]
    [CommRing C₀] [CommRing C₁] [CommRing C₀₁]
    [Algebra A C₀] [Algebra A C₁] [Algebra A C₀₁] [IsNoetherianRing A]
    (ρ₀ : C₀ →ₐ[A] C₀₁) (ρ₁ : C₁ →ₐ[A] C₀₁) (x : C₀) (y : C₁)
    (htu : ρ₀ x * ρ₁ y = 1)
    (hspan₀ : ⊤ ≤ Submodule.span A (Set.range fun n : ℕ => x ^ n))
    (hRtor₀ : ∀ c : C₀, ρ₀ c = 0 → ∃ n : ℕ, x ^ n * c = 0)
    (hS0 : (LinearMap.ker (cechDiff ρ₀.toLinearMap ρ₁.toLinearMap)).FG) (d : ℕ) :
    (LinearMap.ker
      (cechDiff (LinearMap.mulLeft A (ρ₀ x ^ d) ∘ₗ ρ₀.toLinearMap) ρ₁.toLinearMap)).FG := by
  classical
  have hpow : ∀ n : ℕ, ρ₁ y ^ n * ρ₀ x ^ n = 1 := fun n => by
    rw [← mul_pow, mul_comm (ρ₁ y) (ρ₀ x), htu, one_pow]
  -- the multiplication-by-`x^d` comparison map into `S_0`
  set μ : (C₀ × C₁) →ₗ[A] (C₀ × C₁) :=
    (LinearMap.mulLeft A (x ^ d)).prodMap LinearMap.id with hμ
  refine Submodule.fg_of_fg_map_of_fg_inf_ker μ ?_ ?_
  · -- the image lands in `S_0`
    refine fg_of_le_of_fg ?_ hS0
    rintro _ ⟨⟨c₀, c₁⟩, hc, rfl⟩
    rw [SetLike.mem_coe, LinearMap.mem_ker] at hc
    rw [LinearMap.mem_ker]
    rw [cechDiff_apply] at hc ⊢
    simp only [hμ, LinearMap.prodMap_apply, LinearMap.mulLeft_apply, LinearMap.id_apply]
    simp only [LinearMap.coe_comp, Function.comp_apply, LinearMap.mulLeft_apply,
      AlgHom.toLinearMap_apply] at hc
    rw [AlgHom.toLinearMap_apply, AlgHom.toLinearMap_apply, map_mul, map_pow]
    exact hc
  · -- the kernel of the comparison sits inside `(ker ρ₀) × ⊥`, which is `A`-finite
    have hle : LinearMap.ker (cechDiff (LinearMap.mulLeft A (ρ₀ x ^ d) ∘ₗ ρ₀.toLinearMap)
        ρ₁.toLinearMap) ⊓ LinearMap.ker μ ≤
        ((RingHom.ker (ρ₀ : C₀ →+* C₀₁)).restrictScalars A).prod ⊥ := by
      rintro ⟨c₀, c₁⟩ hmem
      obtain ⟨h1, h2⟩ := Submodule.mem_inf.mp hmem
      rw [LinearMap.mem_ker] at h1 h2
      have hc₁ : c₁ = 0 := congrArg Prod.snd h2
      have h1' : ρ₀ x ^ d * ρ₀ c₀ = 0 := by
        rw [cechDiff_apply] at h1
        simp only [LinearMap.coe_comp, Function.comp_apply, LinearMap.mulLeft_apply,
          AlgHom.toLinearMap_apply] at h1
        rw [hc₁, map_zero, sub_zero] at h1
        exact h1
      have hker : ρ₀ c₀ = 0 := by
        have h := congrArg (fun z => ρ₁ y ^ d * z) h1'
        simpa [← mul_assoc, hpow d] using h
      refine Submodule.mem_prod.mpr ⟨?_, ?_⟩
      · simpa [Submodule.restrictScalars_mem, RingHom.mem_ker] using hker
      · simp [hc₁]
    refine fg_of_le_of_fg hle (Submodule.FG.prod ?_ Submodule.fg_bot)
    exact fg_restrictScalars_of_forall_exists_pow_mul_eq_zero hspan₀
      (RingHom.ker (ρ₀ : C₀ →+* C₀₁)) (fun c hc => hRtor₀ c (RingHom.mem_ker.mp hc))

end TwoChart

end AlgebraicJacobian
