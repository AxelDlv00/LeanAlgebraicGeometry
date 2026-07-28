---
author: sync
content_type: theorem
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.Scheme.genus_baseChangeField
docstring: '**The genus is invariant under base field extension** (★★): `genus C_κ
  = genus C`, for a

  smooth proper geometrically integral curve `C/k` and **every** field extension `κ/k`
  — finite or

  infinite, separable or not, perfect or not, algebraically closed or not.


  This is **input (1)** of the extension-uniformity reduction

  (`Ledger/ExtensionUniformity.uniformVanishing_of_uniform_base_of_genus_invariant`),
  and it is now

  a theorem of AJC rather than a hypothesis.


  The proof composes three things AJC already had with the one it lacked: `h¹(𝒪_C)
  = genus C` on

  any cover, `h¹(𝒪_{C_κ}) = genus C_κ` on the base-changed cover, and §2''s comparison
  between the

  two `h¹`s.  The cover is produced by the curve''s own `AffineCoverMVSquare` — there
  is nothing to

  choose, and the statement does not mention one.'
file: AlgebraicJacobian/RiemannRoch/Ledger/GenusFieldInvariance.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.genus_baseChangeField
type: lean
updated: '2026-07-29T06:43:23'
---
theorem genus_baseChangeField [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] (S : C.left.AffineCoverMVSquare) :
    genus (baseChangeField C κ) = genus C := by
  have h₁ : (S.baseChangeField κ).h1 (baseChangeField C κ) (unitOf (baseChangeField C κ)) =
      genus (baseChangeField C κ) :=
    AffineCoverMVSquare.h1_unit_baseChangeField_eq_genus C κ S
  have h₂ : S.h1 C (unitOf C) = genus C := S.h1_unit_eq_genus C
  rw [← h₁, ← h₂]
  exact h1_unit_baseChangeField_eq_h1_unit κ S

end Scalars

/-! ## §4. The χ-ledger entry over `κ`

`Ledger/ExtensionUniformity.chi_moduleKSheaf_baseChangeField` already reads
`χ(𝒪_{C_κ}) = 1 − genus C_κ`.  With §3 the right-hand side is `1 − genus C`, so the χ-ledger
value does not move under base field extension either. -/

section Chi