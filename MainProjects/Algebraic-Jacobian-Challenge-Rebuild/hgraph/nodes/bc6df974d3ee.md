---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.divCarveArrow
docstring: '**The DD-R carve arrow** (`informal/spec-dd-r.md` §3 item 1) over a pair
  chart, at a

  multiplier section `a ∈ H⁰(𝒪(A))`: the carve-pair arrow

  `K_taut^I ⟶ (R_{I,J} ⊗ H₂) ⧸ K_taut^J` of the tautological pair at the coordinate

  multiplier of `a`.  In the coordinate ambients of the scheme side (spec §3 preamble);

  the section-space form is `carveArrow` through `carveArrow_eq_carvePairArrow` and
  the

  boundary bases.'
file: AlgebraicJacobian/Picard/DivCarveLocus.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divCarveArrow
type: lean
updated: '2026-07-31T20:15:20'
---
noncomputable def divCarveArrow (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)
    (a : ↥(divisorSections k A ⊤)) :
    ↥(pairTautFst k g r₁ r₂ i j).toSubmodule →ₗ[PairChartRing k g r₁ g r₂ i j]
      (TensorProduct k (PairChartRing k g r₁ g r₂ i j) (Fin r₂ → k)) ⧸
        (pairTautSnd k g r₁ r₂ i j).toSubmodule :=
  carvePairArrow (divCarveMul k A B r₁ r₂ b₁ b₂ a)
    (pairTautFst k g r₁ r₂ i j).toSubmodule (pairTautSnd k g r₁ r₂ i j).toSubmodule