---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.exists_form_of_awayCompatible
docstring: '**Graded separation.** A compatible away-fraction family `(aᵢ)` (satisfying
  the

  Serre-twist condition `awayMap_{Xⱼ} aᵢ = awayMap_{Xᵢ} aⱼ · (Xⱼ/Xᵢ)^m`) comes from
  a

  single degree-`m` form `F`, with `formChart m i F = aᵢ` on every chart.  The single

  "no poles" divisibility `Xᵢ₀^{k₀} ∣ Xᵢ₀^m·N₀` at a base chart uses primality of
  `Xᵢ₀`

  against a second variable (or the subsingleton structure); the remaining charts
  follow

  from the cross-multiplication `away_cross_eq` and domain cancellation.'
file: AlgebraicJacobian/Picard/SerreTwistSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.exists_form_of_awayCompatible
type: lean
updated: '2026-07-16T21:14:28'
---
lemma exists_form_of_awayCompatible [Nonempty n₀] (m : ℕ)
    (a : ∀ i, Away (homogeneousSubmodule n₀ (ULift.{0} ℤ)) (X i))
    (hcompat : ∀ i j,
      awayMap (homogeneousSubmodule n₀ (ULift.{0} ℤ)) (X_mem_deg_one n₀ j) rfl (a i)
      = awayMap (homogeneousSubmodule n₀ (ULift.{0} ℤ)) (X_mem_deg_one n₀ i) (mul_comm (X i) (X j))
          (a j) * awayFractionInv n₀ i j ^ m) :
    ∃ F : homogeneousSubmodule n₀ (ULift.{0} ℤ) m, ∀ i, formChart m i F = a i := by
  haveI : IsDomain (ULift.{0} ℤ) := MulEquiv.isDomain ℤ (ULift.ringEquiv (R := ℤ)).toMulEquiv
  obtain ⟨i₀⟩ := ‹Nonempty n₀›
  have hXi₀ : (X i₀ : MvPolynomial n₀ (ULift.{0} ℤ)) ≠ 0 := X_ne_zero i₀
  obtain ⟨k₀, N₀, hN₀, hmk₀⟩ := Away.mk_surjective (homogeneousSubmodule n₀ (ULift.{0} ℤ))
    (X_mem_deg_one n₀ i₀) (a i₀)
  -- KEY divisibility `Xᵢ₀^{k₀} ∣ Xᵢ₀^m · N₀`
  have hdvd : (X i₀ ^ k₀ : MvPolynomial n₀ (ULift.{0} ℤ)) ∣ X i₀ ^ m * N₀ := by
    by_cases hex : ∃ j : n₀, j ≠ i₀
    · obtain ⟨j, hj⟩ := hex
      obtain ⟨kⱼ, Nⱼ, hNⱼ, hmkⱼ⟩ := Away.mk_surjective (homogeneousSubmodule n₀ (ULift.{0} ℤ))
        (X_mem_deg_one n₀ j) (a j)
      have hstar := away_cross_eq m i₀ j k₀ N₀ hN₀ kⱼ Nⱼ hNⱼ
        (by rw [hmk₀, hmkⱼ]; exact hcompat i₀ j)
      have hnd : ¬ (X i₀ : MvPolynomial n₀ (ULift.{0} ℤ)) ∣ X j ^ kⱼ := fun hd =>
        hj (((MvPolynomial.X_dvd_X).mp
          ((MvPolynomial.X_prime : Prime (X i₀ : MvPolynomial n₀ (ULift.{0} ℤ))).dvd_of_dvd_pow
            hd)).symm)
      have h' : (X i₀ ^ k₀ : MvPolynomial n₀ (ULift.{0} ℤ)) ∣ (X i₀ ^ m * N₀) * X j ^ kⱼ :=
        ⟨Nⱼ * X j ^ m, by linear_combination hstar⟩
      exact (MvPolynomial.X_prime :
          Prime (X i₀ : MvPolynomial n₀ (ULift.{0} ℤ))).pow_dvd_of_dvd_mul_right k₀ hnd h'
    · simp only [not_exists, not_ne_iff] at hex
      haveI : Subsingleton n₀ := ⟨fun x y => (hex x).trans (hex y).symm⟩
      exact (X_pow_dvd_of_homogeneous_subsingleton i₀ k₀ N₀ (by simpa using hN₀)).mul_left _
  obtain ⟨F₀, hF₀⟩ := hdvd
  have hgdeg : X i₀ ^ m * N₀ ∈ homogeneousSubmodule n₀ (ULift.{0} ℤ) (k₀ + m) := by
    rw [add_comm]
    exact SetLike.mul_mem_graded (by simpa using SetLike.pow_mem_graded m (X_mem_deg_one n₀ i₀))
      (by simpa using hN₀)
  have hF₀deg : F₀ ∈ homogeneousSubmodule n₀ (ULift.{0} ℤ) m :=
    homogeneous_of_X_pow_mul i₀ k₀ m F₀ _ hgdeg hF₀
  refine ⟨⟨F₀, hF₀deg⟩, fun i => ?_⟩
  obtain ⟨kᵢ, Nᵢ, hNᵢ, hmkᵢ⟩ := Away.mk_surjective (homogeneousSubmodule n₀ (ULift.{0} ℤ))
    (X_mem_deg_one n₀ i) (a i)
  have hstar := away_cross_eq m i₀ i k₀ N₀ hN₀ kᵢ Nᵢ hNᵢ (by rw [hmk₀, hmkᵢ]; exact hcompat i₀ i)
  have hbi : F₀ * X i ^ kᵢ = Nᵢ * X i ^ m := by
    have hcancel : (X i₀ ^ k₀ : MvPolynomial n₀ (ULift.{0} ℤ)) * (F₀ * X i ^ kᵢ)
        = X i₀ ^ k₀ * (Nᵢ * X i ^ m) := by
      linear_combination (-(X i ^ kᵢ)) * hF₀ + hstar
    exact mul_left_cancel₀ (pow_ne_zero k₀ hXi₀) hcancel
  rw [← hmkᵢ]
  apply HomogeneousLocalization.val_injective
  rw [formChart, Away.val_mk, Away.val_mk, Localization.mk_eq_mk_iff, Localization.r_iff_exists]
  exact ⟨1, by simp only [OneMemClass.coe_one, one_mul]; linear_combination hbi⟩

set_option backward.isDefEq.respectTransparency false in