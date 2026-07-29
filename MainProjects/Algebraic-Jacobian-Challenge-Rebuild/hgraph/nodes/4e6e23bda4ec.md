---
author: sync
content_type: definition
created: '2026-07-30T00:05:11'
decl: ProbeP4g.classifier_at_n
docstring: 'And the classifier''s own signature carries that hchi at the SAME `n`
  as the

  `DivScheme` parameter and the `hdeg` pin -- so the three are one parameter, not
  three.

  Recorded by instantiating the classifier and reading off the type.'
file: scratch_p4/Probe7.lean
generated: lean
lean_status: lean_ok
stale: true
title: ProbeP4g.classifier_at_n
type: lean
updated: '2026-07-30T00:56:05'
---
noncomputable def classifier_at_n (n r₁ r₂ : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (n : ℤ))
    (b₁ : Module.Basis (Fin r₁) k
      ↥(divisorSections k (windowM_choice π hπ n • fiberWeilDivisor π) ⊤))
    (b₂ : Module.Basis (Fin r₂) k
      ↥(divisorSections k
        ((windowM_choice π hπ n + windowS_choice π hπ n) • fiberWeilDivisor π) ⊤))
    {K : Type u} [Field K] [Algebra k K]
    [IsIntegral (relCurve C K)]
    [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
    [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]
    (D : (relCurve C K).CurveDivisor) (hD : 0 ≤ D)
    (hdeg : Scheme.CurveDivisor.deg K D = (n : ℤ)) :
    overSpec k K ⟶
      divSchemeOver k (windowS_choice π hπ n • fiberWeilDivisor π)
        (windowM_choice π hπ n • fiberWeilDivisor π) n r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hπ n).symm) :=
  effectiveDivisorClassifyZar hπ n hO hχ r₁ r₂ b₁ b₂ D hD hdeg