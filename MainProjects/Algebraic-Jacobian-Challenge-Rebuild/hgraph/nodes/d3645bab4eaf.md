---
author: sync
content_type: lemma
created: '2026-07-20T06:01:15'
decl: AlgebraicGeometry.ThetaGeneratorSeed.relPinnedTermBaseChangeAlg_one_tmul
docstring: 'The chart-ring base change on `1 ⊗ s` is the side-uniform chart comparison

  `relPinnedSectionsMap`.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignHinjChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.relPinnedTermBaseChangeAlg_one_tmul
type: lean
updated: '2026-07-30T15:28:04'
---
lemma relPinnedTermBaseChangeAlg_one_tmul (b : Bool)
    (s : Γ(relCurve C R, relPinnedChart C R π b)) :
    relPinnedTermBaseChangeAlg C R R' π b ((1 : R') ⊗ₜ[R] s)
      = relPinnedSectionsMap C R R' π b s := by
  cases b with
  | false =>
      have h := relTermBaseChangeAlg_tmul (C := C) (R := R) R' (fiberChart₀ π)
        (fiberTwoCover π).isAffineOpen₀.isCompact
        (fiberTwoCover π).isAffineOpen₀.isQuasiSeparated (1 : R') s
      rw [one_smul] at h
      exact h
  | true =>
      have h := relTermBaseChangeAlg_tmul (C := C) (R := R) R' (fiberChart₁ π)
        (fiberTwoCover π).isAffineOpen₁.isCompact
        (fiberTwoCover π).isAffineOpen₁.isQuasiSeparated (1 : R') s
      rw [one_smul] at h
      exact h