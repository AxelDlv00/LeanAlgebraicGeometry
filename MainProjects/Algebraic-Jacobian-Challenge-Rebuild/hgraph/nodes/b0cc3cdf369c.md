---
author: sync
content_type: theorem
created: '2026-07-29T20:00:06'
decl: AlgebraicGeometry.exists_effective_of_classDeg_eq_zero_of_toP1
docstring: '**The effectivity leg with NO arithmetic hypothesis left**: on a curve
  with a finite

  dominant map to `ℙ¹`, every degree-zero class has an effective representative, of
  some degree

  `≥ g` named by the statement.


  This composes `exists_reference_divisor_le_deg` with

  `exists_effective_of_classDeg_eq_zero_of_le_deg`.  Compare

  `exists_effective_deg_eq_of_classDeg_eq_zero`, which takes the reference divisor
  as an argument

  and whose docstring records producing it as "a genuine arithmetic hypothesis on
  the curve, open

  here": here nothing is assumed about the curve beyond the package it already carries.


  What is *given up* relative to the `= g` form, stated plainly because it is the
  honest cost:

  the resulting degree is `deg Z`, a multiple of `δ` at least `g`, not `g` on the
  nose.  A

  consumer that genuinely needs degree exactly `g` — `effectiveDivisorClassifyZar`

  (`Picard/DivisorFamilyFieldSurj.lean`) does, through its `hdeg` field — is **not**
  served by

  this, and that residue is unchanged.  What this settles is that the obstruction
  lives in the

  *consumer''s* degree pin, not in the curve''s arithmetic.'
file: AlgebraicJacobian/Picard/JacobianDataAbelDegreeWindow.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.exists_effective_of_classDeg_eq_zero_of_toP1
type: lean
updated: '2026-07-31T20:14:49'
---
theorem exists_effective_of_classDeg_eq_zero_of_toP1 (g : ℕ)
    (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (g : ℤ))
    (π : Y ⟶ P1 K) [IsDominant π] [IsFinite π]
    (L₀ : Y.CechPic) (hL₀ : classDeg K L₀ = 0) :
    ∃ (Z : Y.CurveDivisor) (E : Y.CurveDivisor), (g : ℤ) ≤ CurveDivisor.deg K Z ∧
      0 ≤ E ∧ CurveDivisor.picClass K E = L₀ * CurveDivisor.picClass K Z ∧
      CurveDivisor.deg K E = CurveDivisor.deg K Z := by
  obtain ⟨Z, hZ⟩ := exists_reference_divisor_le_deg K π g
  obtain ⟨E, hE, hcl, hdeg⟩ :=
    exists_effective_of_classDeg_eq_zero_of_le_deg K g hχ Z hZ L₀ hL₀
  exact ⟨Z, E, hZ, hE, hcl, hdeg⟩

end Reference

/-! ## At degree `g`, `h¹ = 0` forces `h⁰ = 1` -/

section RankAnchor

variable {K : Type u} [Field K] {Y : Scheme.{u}} [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))] [IsIntegral Y]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]