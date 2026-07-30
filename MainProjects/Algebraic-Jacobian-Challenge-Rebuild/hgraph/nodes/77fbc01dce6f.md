---
author: sync
content_type: theorem
created: '2026-07-29T05:13:20'
decl: AlgebraicGeometry.ThetaGeneratorSeed.isLocallyCertifiedAff_of_supportLocus_empty
docstring: '**The gate''s hypothesis set is jointly inhabited**, at the zero divisor
  with `n = 0`: the

  support locus is empty, so the `0B8B` containment holds for any affine open inside
  a cover member

  and every colength vanishes.


  See the section note above for exactly how much this is worth — it is a non-self-contradiction

  certificate, not a claim of non-trivial inhabitation.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffSeedGate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.isLocallyCertifiedAff_of_supportLocus_empty
type: lean
updated: '2026-07-30T15:46:03'
---
theorem isLocallyCertifiedAff_of_supportLocus_empty [IsProper C.hom] [IsNoetherianRing R]
    (hD : D.IsGenerator)
    (hempty : (D.localEquations hD).supportLocus = (∅ : Set (relCurve C R)))
    {W : (relCurve C R).Opens} (hW : IsAffineOpen W)
    (z₀ : relCurve C R) (hWle : W ≤ (D.localEquations hD).cover.opens z₀) :
    IsLocallyCertifiedAff 0 (D.localEquations hD) :=
  isLocallyCertifiedAff_of_isCertified hD
    (exists_isCertified_of_seed_of_supportLocus_empty C R hD hempty hW z₀ hWle)