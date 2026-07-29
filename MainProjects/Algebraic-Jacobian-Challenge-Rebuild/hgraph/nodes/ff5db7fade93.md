---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.subsingleton_hModule_gluedSheaf_one_of_picClass_eq
docstring: '**`hfib` in the sheaf form the engine consumes** (W6-full × W6-lite):
  vanishing of

  `H¹(𝒪(D))` for any witness divisor `D` of the presented class — e.g. the `(S)`-witness

  of `CurveDivisor.exists_picClass_eq` — discharges vanishing of `H¹` of the glued
  sheaf

  of the presentation. This is the sheaf-level form of Kleiman 3.10 (v)⟹(i) at a fibre:

  the engine''s complex-form `hfib` follows through steps (a)/(b)

  (`Cohomology/GluedSheafFibre.lean`).'
file: AlgebraicJacobian/RiemannRoch/W6Full.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.subsingleton_hModule_gluedSheaf_one_of_picClass_eq
type: lean
updated: '2026-07-29T15:26:40'
---
theorem subsingleton_hModule_gluedSheaf_one_of_picClass_eq
    (P : X.MeromorphicPresentation) {D : X.CurveDivisor}
    (h : CurveDivisor.picClass K D = P.picClass)
    (hsub : Subsingleton (Sheaf.HModule (X.divisorSheaf K D) 1)) :
    Subsingleton (Sheaf.HModule (P.gluedSheaf K) 1) := by
  refine (subsingleton_hModule_gluedSheaf_one_iff K P).mpr ?_
  refine subsingleton_hModule_one_of_picClass_eq K ?_ hsub
  rw [CurveDivisor.picClass_presentationDivisor]
  exact h