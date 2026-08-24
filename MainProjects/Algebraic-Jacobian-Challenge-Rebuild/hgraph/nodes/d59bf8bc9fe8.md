---
author: sync
content_type: theorem
created: '2026-08-02T04:08:39'
decl: AlgebraicGeometry.Scheme.exists_homogeneous_pos_mem_forall_notMem_of_antichain
docstring: Graded prime avoidance for a finite antichain of relevant homogeneous primes.
file: AlgebraicJacobian/Picard/RelativeCurveFiniteInAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.exists_homogeneous_pos_mem_forall_notMem_of_antichain
type: lean
updated: '2026-08-18T20:51:07'
---
theorem exists_homogeneous_pos_mem_forall_notMem_of_antichain
    (T : Finset (Ideal A)) (hp : ∀ q ∈ T, q.IsPrime)
    (hph : ∀ q ∈ T, q.IsHomogeneous 𝒜)
    (hrel : ∀ q ∈ T, ¬ (HomogeneousIdeal.irrelevant 𝒜).toIdeal ≤ q)
    (hanti : ∀ q ∈ T, ∀ q' ∈ T, q ≠ q' → ¬ q ≤ q')
    {I : Ideal A} (hI : I.IsHomogeneous 𝒜) (hIp : ∀ q ∈ T, ¬ I ≤ q)
    (hM : ∃ (m : ℕ) (f : A), 0 < m ∧ f ∈ 𝒜 m ∧ f ∈ I) :
    ∃ (M : ℕ) (h : A), 0 < M ∧ h ∈ 𝒜 M ∧ h ∈ I ∧ ∀ q ∈ T, h ∉ q := by
  classical
  rcases T.eq_empty_or_nonempty with rfl | hne
  · obtain ⟨m, f, hm, hfd, hfI⟩ := hM
    exact ⟨m, f, hm, hfd, hfI, by simp⟩
  have key : ∀ q ∈ T, ∃ (m : ℕ) (f : A), 0 < m ∧ f ∈ 𝒜 m ∧
      f ∈ (I ⊓ (T.erase q).inf id) ∧ f ∉ q := by
    intro q hq
    haveI := hp q hq
    refine exists_homogeneous_pos_mem_notMem 𝒜 (I := I ⊓ (T.erase q).inf id) ?_
      (hrel q hq) ?_
    · exact fun i x hx =>
        ⟨hI i hx.1,
          Ideal.IsHomogeneous.finsetInf 𝒜 _ id
            (fun q' hq' => hph q' (Finset.mem_of_mem_erase hq')) i hx.2⟩
    · intro hle
      rcases (hp q hq).inf_le.mp hle with h | h
      · exact hIp q hq h
      · obtain ⟨q', hq', hq'le⟩ := (hp q hq).inf_le'.mp h
        exact hanti q' (Finset.mem_of_mem_erase hq') q hq
          (Finset.ne_of_mem_erase hq') hq'le
  choose! m f hmpos hfdeg hfmem hfout using key
  have hfI : ∀ q ∈ T, f q ∈ I := fun q hq => (hfmem q hq).1
  have hfin : ∀ q ∈ T, ∀ q' ∈ T.erase q, f q ∈ q' := fun q hq q' hq' =>
    Finset.inf_le (f := id) hq' (hfmem q hq).2
  set M : ℕ := ∏ q ∈ T, m q with hMdef
  have hMpos : 0 < M := Finset.prod_pos hmpos
  have hquot : ∀ q ∈ T, 0 < M / m q := fun q hq =>
    Nat.div_pos (Finset.single_le_prod' (fun i hi => hmpos i hi) hq) (hmpos q hq)
  set F : Ideal A → A := fun q => (f q) ^ (M / m q) with hFdef
  have hFdeg : ∀ q ∈ T, F q ∈ 𝒜 M := by
    intro q hq
    have h2 := SetLike.pow_mem_graded (M / m q) (hfdeg q hq)
    rwa [smul_eq_mul, Nat.div_mul_cancel (Finset.dvd_prod_of_mem m hq)] at h2
  have hFI : ∀ q ∈ T, F q ∈ I := fun q hq =>
    Ideal.pow_mem_of_mem I (hfI q hq) _ (hquot q hq)
  have hFin : ∀ q ∈ T, ∀ q' ∈ T.erase q, F q ∈ q' := fun q hq q' hq' =>
    Ideal.pow_mem_of_mem _ (hfin q hq q' hq') _ (hquot q hq)
  have hFout : ∀ q ∈ T, F q ∉ q := fun q hq hmem =>
    hfout q hq ((hp q hq).mem_of_pow_mem _ hmem)
  refine ⟨M, ∑ q ∈ T, F q, hMpos, sum_mem hFdeg,
    Ideal.sum_mem _ fun q hq => hFI q hq, ?_⟩
  intro q hq hmem
  rw [← Finset.add_sum_erase T F hq] at hmem
  have hrest : (∑ q' ∈ T.erase q, F q') ∈ q :=
    Ideal.sum_mem _ fun q' hq' => hFin q' (Finset.mem_of_mem_erase hq') q
      (Finset.mem_erase.mpr ⟨(Finset.ne_of_mem_erase hq').symm, hq⟩)
  exact hFout q hq ((Ideal.add_mem_iff_left _ hrest).mp hmem)