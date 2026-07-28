---
author: sync
content_type: theorem
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.surjective_eval_of_deg_ge
docstring: '**Generation at a point above the degree bound** (★★, cluster-P item 3):
  past

  `deg D₀ + 1 − χ(𝒪_X)` — with a degree of room for the point being peeled — evaluation

  `H⁰(𝒪(D)) → H⁰(sky_x J) ≅ κ(x)` is surjective at **every** closed point `x`.


  The hypothesis is stated on `deg (D − x)` rather than `deg D` because it is the
  vanishing at

  `D − x`, not at `D`, that the slice consumes; the difference is exactly one residue
  degree.'
file: AlgebraicJacobian/RiemannRoch/Ledger/DegreeVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.surjective_eval_of_deg_ge
type: lean
updated: '2026-07-29T06:43:23'
---
theorem surjective_eval_of_deg_ge {D₀ : X.CurveDivisor}
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K D₀) 1))
    {x : X} (hx : x ≠ genericPoint X) (D : X.CurveDivisor)
    (hD : CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K)
      ≤ CurveDivisor.deg K (D - CurveDivisor.single hx 1)) :
    Function.Surjective (Sheaf.HModule.map (devissageSES K hx D).g 0) :=
  surjective_hModule_zero_devissageπ K hx D
    (subsingleton_hModule_one_of_deg_ge K h₀ _ hD)