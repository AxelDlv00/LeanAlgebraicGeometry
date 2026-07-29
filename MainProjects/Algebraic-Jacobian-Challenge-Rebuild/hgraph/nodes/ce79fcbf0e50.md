---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.divFamFieldEquivOfDegOfSurj
docstring: "**The field dictionary, assembled from the two remaining named gaps**\n\
  (`informal/spec-dd-1.md` §3 (f), the frozen `divFamFieldEquiv`). Given\n\n* `hdeg`\
  \ — the **general** colength↔degree identity `deg (divFamDivisor F) = n` for an\n\
  \  *arbitrary* certified family (the honest Mayer–Vietoris wall of I-0179; needed\
  \ even to land\n  the forward map in the degree-`n` subtype), and\n* `hsurj` — **backward\
  \ realization**: every effective degree-`n` divisor is the divisor of\n  some family\
  \ (discharged over `K` by the `PointPresentation.pointEquations`-product\n  support-separated\
  \ construction, whose certificate rank is `deg D = n` *for free* via\n  `deg_divFamDivisor_of_separated`\
  \ — this direction needs no general MV),\n\nthe field dictionary `DivFam C K π n\
  \ ≃ {D // 0 ≤ D ∧ deg K D = n}` drops out: injectivity is\nalready free (`divFamDivisor_injective`),\
  \ effectivity is landed (`zero_le_divFamDivisor`).\n\nThe two hypotheses are exactly\
  \ the DD-1c residue: `hsurj` is a fundable construction, `hdeg`\nis the sole general-MV\
  \ obligation. See the module docstring for the DD-R consumption note."
file: AlgebraicJacobian/Picard/DivisorFamilyFieldEquiv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamFieldEquivOfDegOfSurj
type: lean
updated: '2026-07-29T15:31:45'
---
noncomputable def divFamFieldEquivOfDegOfSurj
    (hdeg : ∀ F : DivFam C K π n,
      Scheme.CurveDivisor.deg K (divFamDivisor F) = (n : ℤ))
    (hsurj : ∀ D : (relCurve C K).CurveDivisor, 0 ≤ D →
      Scheme.CurveDivisor.deg K D = (n : ℤ) → ∃ F : DivFam C K π n, divFamDivisor F = D) :
    DivFam C K π n
      ≃ {D : (relCurve C K).CurveDivisor // 0 ≤ D ∧ Scheme.CurveDivisor.deg K D = (n : ℤ)} :=
  Equiv.ofBijective
    (fun F => ⟨divFamDivisor F, zero_le_divFamDivisor F, hdeg F⟩)
    ⟨fun F G hFG => divFamDivisor_injective (Subtype.ext_iff.mp hFG),
     fun D => by
       obtain ⟨F, hF⟩ := hsurj D.1 D.2.1 D.2.2
       exact ⟨F, Subtype.ext hF⟩⟩