---
author: sync
content_type: theorem
created: '2026-07-17T22:01:16'
decl: AlgebraicGeometry.divisorWindow_eq_of_le
docstring: '**The window form of the ε-projection identity** (`informal/spec-dd-r.md`
  §3

  item 5, the equality half): a Grassmannian point `x` whose submodule is contained
  in

  the window submodule `K_a(d)` *equals* it, given the Θ-twisted colength certificate

  slots (surjective evaluation + finite projective of constant rank `g`, exactly the

  `divisorWindowGr` inputs).  Both quotients are then finite projective of rank `g`,
  and

  nested submodules with same-rank quotients coincide by the rank engine.


  `hfin` and `hproj` are consumed by typeclass synthesis as local instances (they
  carry

  the `Module.Finite`/`Module.Projective` slots into `Module.Finite.equiv` /

  `Module.Projective.of_equiv`); the `unusedVariables` linter does not see the `hfin`

  synthesis and is disabled here for that false positive.'
file: AlgebraicJacobian/Picard/DivSchemeEps.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divisorWindow_eq_of_le
type: lean
updated: '2026-07-29T15:26:35'
---
theorem divisorWindow_eq_of_le (A : DivisorAdaptation C R π d)
    (hH1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (x : Grassmannian.grFunctorAff k
      (↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) g R)
    (hsurj : Function.Surjective (A.thetaGluedEval a))
    (hfin : Module.Finite R (A.ThetaGlued a))
    (hproj : Module.Projective R (A.ThetaGlued a))
    (hrank : ∀ p : PrimeSpectrum R, Module.rankAtStalk (A.ThetaGlued a) p = g)
    (hle : x.toSubmodule ≤ divisorWindow d hH1) :
    divisorWindow d hH1 = x.toSubmodule := by
  haveI hfinW : Module.Finite R
      ((R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
        divisorWindow d hH1) :=
    Module.Finite.equiv (windowQuotEquiv A hH1 hsurj).symm
  haveI hprojW : Module.Projective R
      ((R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
        divisorWindow d hH1) :=
    Module.Projective.of_equiv (windowQuotEquiv A hH1 hsurj).symm
  refine (Submodule.eq_of_le_of_rankAtStalk_quotient_eq hle fun p => ?_).symm
  rw [x.rankAtStalk_eq p,
    congrFun (Module.rankAtStalk_eq_of_equiv (windowQuotEquiv A hH1 hsurj)) p,
    hrank p]