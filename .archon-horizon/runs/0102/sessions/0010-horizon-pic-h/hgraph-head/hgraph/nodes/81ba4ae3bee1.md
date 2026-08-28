---
author: sync
content_type: theorem
created: '2026-07-17T23:01:28'
decl: AlgebraicGeometry.divFamZar.ext_of_le_cover
docstring: '**Separation of the locally certified vehicle** (`informal/spec-dd-2.md`
  §6,

  Addendum 2 — the `picEt.ext_of_le_cover` mirror): two sections of `divFamZar C π
  n T`

  agreeing on every affine open subordinate to an open cover of `T.left` are equal
  — the

  separation half of the Zariski sheaf property at an arbitrary test.'
file: AlgebraicJacobian/Picard/DivisorFamilyZarSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamZar.ext_of_le_cover
type: lean
updated: '2026-08-01T09:44:14'
---
theorem ext_of_le_cover {T : Over (Spec (.of k))} {ι' : Type*}
    (O : ι' → T.left.Opens) (hcov : ∀ p : T.left, ∃ i, p ∈ O i)
    {s t : divFamZar C π n T}
    (h : ∀ (U : T.left.affineOpens) (i : ι'), U.1 ≤ O i → s.1 U = t.1 U) : s = t := by
  classical
  refine ext fun U => ?_
  obtain ⟨sub, hspan, hsub⟩ := Scheme.exists_basic_subcover U.2
    (fun U₀ => ∃ i, U₀ ≤ O i)
    (fun w _ => by
      obtain ⟨i, hi⟩ := hcov w
      exact ⟨O i, hi, ⟨i, le_rfl⟩⟩)
  refine eq_of_basic_eq U sub hspan (fun r hr => ?_)
  obtain ⟨U₀, ⟨i, hle⟩, hrle⟩ := hsub r hr
  rw [s.compat ⟨_, U.2.basicOpen r⟩ U (T.left.basicOpen_le r),
    t.compat ⟨_, U.2.basicOpen r⟩ U (T.left.basicOpen_le r)]
  exact h ⟨T.left.basicOpen r, U.2.basicOpen r⟩ i (hrle.trans hle)

/-! ## Local data on an open cover -/

variable {T : Over (Spec (.of k))} {ι : Type u} (O : ι → T.left.Opens)