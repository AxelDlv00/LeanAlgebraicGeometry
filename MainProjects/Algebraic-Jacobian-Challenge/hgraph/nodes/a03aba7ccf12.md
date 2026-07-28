---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.per_j_surj
docstring: 'Per-cover-member surjectivity datum: from the hypothesis that the `(s
  j)`-localised map is a

  localisation at the powers of `f`, every `y : N` is hit by `g` up to a power of
  `s j` and a power of

  `f`.  Project-local helper for the surjectivity clause of `isLocalizedModule_of_span_cover`.'
file: AlgebraicJacobian/Cohomology/QcohTildeSections.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.per_j_surj
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma per_j_surj (g : M →ₗ[R] N) (f : R) (c : R)
    (hj : IsLocalizedModule (Submonoid.powers f)
      (IsLocalizedModule.map (Submonoid.powers c)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) M)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) N) g))
    (y : N) : ∃ (a k : ℕ) (m : M), c ^ a • f ^ k • y = g m := by
  haveI := hj
  obtain ⟨p, hxj⟩ := IsLocalizedModule.surj (Submonoid.powers f)
      (IsLocalizedModule.map (Submonoid.powers c)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) M)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) N) g)
      (LocalizedModule.mk y 1)
  obtain ⟨xj, ⟨tf, kk, (rfl : f ^ kk = tf)⟩⟩ := p
  rw [Submonoid.smul_def, LocalizedModule.smul'_mk] at hxj
  revert hxj
  induction xj using LocalizedModule.induction_on with
  | _ m u =>
    intro hxj
    rw [IsLocalizedModule.map_LocalizedModules] at hxj
    obtain ⟨⟨u', uu, (rfl : c ^ uu = u')⟩, hu'⟩ := (LocalizedModule.mk_eq).1 hxj
    obtain ⟨u2, vv, (rfl : c ^ vv = u2)⟩ := u
    simp only [Submonoid.smul_def, one_smul] at hu'
    refine ⟨vv + uu, kk, c ^ uu • m, ?_⟩
    rw [map_smul]
    rw [show c ^ (vv + uu) • f ^ kk • y = c ^ uu • c ^ vv • (f ^ kk • y) by
          rw [pow_add]; simp only [smul_smul]; ring_nf]
    exact hu'