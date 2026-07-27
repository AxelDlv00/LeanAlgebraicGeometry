---
author: sync
content_type: theorem
created: '2026-07-27T19:45:31'
decl: AlgebraicGeometry.Adelic.hasRigidPushforward_of_gammaBaseChange
docstring: '**The whole gate from a single statement.**  `HasRigidPushforward C`,
  for

  an AJC curve, now needs exactly one input: the `Γ`-level base-change

  bijectivity `RigidPushforwardGammaBaseChange C A` at every finitely generated

  `k`-algebra `A`.


  Compare `hasRigidPushforward_of_leaves` (`Picard/RigidPushforwardGate.lean`),

  which needed four, and `hasRigidPushforward_of_isIntegral_of_rank_of_baseChange`

  (`Picard/RigidPushforwardFrontier.lean`), which needed three.  The two ℙ¹

  leaves are discharged here; the sheaf-level content of the fourth is discharged

  by affine-target descent in `Picard/RigidPushforwardAffineDescent.lean`; what

  is left is the classical statement that `H⁰` of the family commutes with

  arbitrary base change, at the level of `Γ(Spec A, ⊤)`-modules.


  The route to it, and the precise pieces still missing, are recorded in the

  module docstring of `Picard/RigidPushforwardAffineDescent.lean`.'
file: AlgebraicJacobian/Picard/RigidPushforwardInstance.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.hasRigidPushforward_of_gammaBaseChange
type: lean
updated: '2026-07-27T19:45:31'
---
theorem hasRigidPushforward_of_gammaBaseChange
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    (hΓ : ∀ (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A],
      RigidPushforwardGammaBaseChange C A) :
    Scheme.HasRigidPushforward C :=
  hasRigidPushforward_of_isIntegral_of_rank_of_baseChange C
    (fun A => p1RankIdentity_proved A)
    (fun A => rigidPushforwardBaseChange_of_gamma C A (hΓ A))