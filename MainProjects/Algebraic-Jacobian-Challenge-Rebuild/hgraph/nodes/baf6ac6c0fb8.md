---
author: sync
content_type: theorem
created: '2026-07-25T15:32:34'
decl: AlgebraicGeometry.DivisorAdaptation.forall_noLeak_of_forall_supportLocus_subset
docstring: 'The no-leak clause for **every** piece, from containment of the support
  in each: the

  exact `hnoLeak` input of the certificate assemblers

  (`DivisorAdaptation.isCertified_of_noLeak_kernel_spanning`,

  `ThetaGeneratorSeed.divisorAdaptation_isCertified_of_noLeak_kernel_spanning`).'
file: AlgebraicJacobian/Picard/DivSchemeCertZarTube.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.forall_noLeak_of_forall_supportLocus_subset
type: lean
updated: '2026-07-30T15:46:02'
---
theorem forall_noLeak_of_forall_supportLocus_subset
    (hsub : ∀ j : A.index, d.supportLocus ⊆ (A.pieces j : Set (relCurve C R))) :
    ∀ (j : A.index) (s : Spec (CommRingCat.of R)),
      ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹' {s}
          ∩ closure (d.supportLocus ∩ (A.pieces j : Set (relCurve C R)))
        ⊆ (A.pieces j : Set (relCurve C R)) :=
  fun j => A.forall_fibre_closure_subset_of_supportLocus_subset j (hsub j)

end DivisorAdaptation

end NoLeakOverTube

/-! ## The tube-fibre reduction

Combining the two halves: to obtain the certificate assembler's `hnoLeak` input over an
`Away` chart, it is enough to check at ONE base prime that the support fibre lies in an
open — the tube spreads it to a basic-open neighbourhood, and containment there upgrades to
the fibrewise clause. This is the precise statement the remaining geometric work has to
feed, and it mentions only a single fibre. -/

section TubeFibre

variable {k : Type u} [Field k] (C : Over (Spec (.of k))) [IsProper C.hom]
variable (R : Type u) [CommRing R] [Algebra k R]