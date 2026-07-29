---
author: sync
content_type: theorem
created: '2026-07-17T23:01:28'
decl: AlgebraicGeometry.divFamZar.glueValue_unique
docstring: 'Glued values are unique — from the Zariski separation over a basic refinement

  subordinate to the cover.'
file: AlgebraicJacobian/Picard/DivisorFamilyZarSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamZar.glueValue_unique
type: lean
updated: '2026-07-29T15:31:45'
---
theorem glueValue_unique (hcov : ∀ p : T.left, ∃ i, p ∈ O i)
    {W : T.left.affineOpens} {z z' : DivFamZar C Γ(T.left, W.1) π n}
    (hz : IsGlueValue O v W z) (hz' : IsGlueValue O v W z') : z = z' := by
  classical
  obtain ⟨sub, hspan, hsub⟩ := Scheme.exists_basic_subcover W.2
    (fun U₀ => ∃ i, U₀ ≤ O i)
    (fun w _ => by obtain ⟨i, hi⟩ := hcov w; exact ⟨O i, hi, ⟨i, le_rfl⟩⟩)
  refine eq_of_basic_eq W sub hspan (fun r hr => ?_)
  obtain ⟨U₀, ⟨i, hi⟩, hle⟩ := hsub r hr
  rw [hz ⟨_, W.2.basicOpen r⟩ (T.left.basicOpen_le r) i (hle.trans hi),
    hz' ⟨_, W.2.basicOpen r⟩ (T.left.basicOpen_le r) i (hle.trans hi)]

set_option maxHeartbeats 1600000 in
-- The instance towers over the section rings of the basic refinement exceed the
-- default elaboration budget (as in `Pic0ZariskiSheaf.exists_isGlueValue`).