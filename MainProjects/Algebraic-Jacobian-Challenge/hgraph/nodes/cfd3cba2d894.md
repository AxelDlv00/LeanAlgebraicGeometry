---
author: sync
content_type: theorem
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.riemannRoch_baseChangeField
docstring: '**Exact Riemann–Roch at `C_κ`, for every field extension `κ/k`**:

  `h⁰(𝒪(D)) = 1 − genus C_κ + deg_κ D` above a threshold over `κ`.


  Note the genus on the right is `genus C_κ`, taken over `κ`, **not** `genus C`.  Replacing
  it by

  `genus C` is exactly the scalar identity §3 isolates, and it is not available here.'
file: AlgebraicJacobian/RiemannRoch/Ledger/ExtensionUniformity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.riemannRoch_baseChangeField
type: lean
updated: '2026-07-29T06:43:23'
---
theorem riemannRoch_baseChangeField (κ : Type u) [Field κ] [Algebra k κ] :
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    haveI : SmoothOfRelativeDimension 1
        ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
    ∃ b : ℤ, ∀ D : (Scheme.baseChangeField C κ).left.CurveDivisor,
      b ≤ CurveDivisor.deg κ D →
      (Sheaf.h0 ((Scheme.baseChangeField C κ).left.divisorSheaf κ D) : ℤ)
        = 1 - genus (Scheme.baseChangeField C κ) + CurveDivisor.deg κ D :=
  exists_bound_h0_eq_genus_curve (Scheme.baseChangeField C κ)

/-! ### The χ of `C_κ` is `1 − genus C_κ`

The step that makes the decomposition of `b(κ)` in the module docstring a computation rather
than an estimate.  It is `ChiCurve.chi_moduleKSheaf` at `C_κ` with the genus name corrected by
`GenusBridge.ledgerGenus_eq_genus`; both fire at `C_κ` only because of §1. -/