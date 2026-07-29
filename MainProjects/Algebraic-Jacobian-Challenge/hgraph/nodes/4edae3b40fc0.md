---
author: sync
content_type: theorem
created: '2026-07-29T08:19:25'
decl: AlgebraicGeometry.twistedPerSigmaCompat_of_counitSide
docstring: '**The whole residue from the WEAKEST of the three forms.**  `BcSquareCounitSide`
  is what a

  future session should aim at: it is implied by each of the other two, and it is
  the one

  `mateEquiv_counit` speaks about.  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.twistedPerSigmaCompat_of_counitSide
type: lean
updated: '2026-07-29T08:19:25'
---
theorem twistedPerSigmaCompat_of_counitSide (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [IsSeparated f] [IsAffine S]
    [∀ i, IsAffine (𝒰.X i)] (F : X.Modules) (hF : F.IsQuasicoherent)
    (hct : BcSquareCounitSide f g' 𝒰 F hF) :
    TwistedPerSigmaDeltaCompat f g f' g' h 𝒰 F hF :=
  twistedPerSigmaCompat_of_bcNaturality f g f' g' h 𝒰 F hF
    (bcSquareNaturality_of_counitSide f g' 𝒰 F hF hct)