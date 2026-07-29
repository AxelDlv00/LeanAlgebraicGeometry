---
author: sync
content_type: theorem
created: '2026-07-20T08:01:14'
decl: AlgebraicGeometry.ThetaGeneratorSeed.finrank_baseChange_divUniversalSeedK_add
docstring: '**The source rank of the carve seed at `κ(p)`**: the universal seed `K_univ`,
  base-changed

  to the residue field `κ(p)` of any prime `p` of `R_Z`, has constant `κ(p)`-dimension
  `r₁ − g`

  (spelled `+ g = dim_k (Fin r₁ → k)`).  `K_univ` is `R_Z`-linearly the tautological
  Grassmannian

  subbundle `divUniversalFst` (through `finrank_baseChange_divUniversalSeedK_eq`),
  so its residue

  fibre is the corank-`g` fibre of that subbundle

  (`finrank_baseChange_divUniversalFst_toSubmodule_add`) — no fibre of `K_univ` gains
  or loses

  dimension over any prime.  This is the source half of the constant-rank pin that
  discharges the

  carve fibre non-collapse `hsub_chart`.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignHsubChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.finrank_baseChange_divUniversalSeedK_add
type: lean
updated: '2026-07-29T15:26:40'
---
theorem finrank_baseChange_divUniversalSeedK_add
    (p : PrimeSpectrum (seedChartRing' C hπ g r₁ r₂ b₁ b₂ i j)) :
    Module.finrank p.asIdeal.ResidueField
        (p.asIdeal.ResidueField ⊗[seedChartRing' C hπ g r₁ r₂ b₁ b₂ i j]
          ↥(divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j)) + g
      = Module.finrank k (Fin r₁ → k) :=
  (congrArg (· + g)
      (finrank_baseChange_divUniversalSeedK_eq C hπ g r₁ r₂ b₁ b₂ i j p)).trans
    (finrank_baseChange_divUniversalFst_toSubmodule_add C hπ g r₁ r₂ b₁ b₂ i j p)