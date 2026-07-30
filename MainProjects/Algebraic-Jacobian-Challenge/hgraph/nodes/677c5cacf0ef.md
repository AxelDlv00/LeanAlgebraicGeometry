---
author: sync
content_type: theorem
created: '2026-07-30T10:26:46'
decl: AlgebraicJacobian.GaloisDescent.isGaloisQuotient_away
docstring: '**A localization at an invariant element has a Galois quotient, namely
  `Spec` of

  its own invariants.**


  `Spec S` with the action `awayAction` transported in §2 satisfies

  `IsGaloisQuotient` against `Spec (S^Γ)` — all three clauses, including the

  universal `T`-points property, for every `T`.


  **Nothing new is proved here and that is the point.** The whole content is

  `isSemilinear_away`: once the transported action is known semilinear,

  `isGaloisQuotient_spec` (`Picard/FiniteGaloisQuotientAffine.lean`) applies

  verbatim, Speiser and all. So layer 3, gluing per-chart quotients along stable

  opens, can quote a quotient at each localized piece instead of constructing one
  —

  which is the same simplification `GaloisQuotientGlue.lean`''s header records for

  the affine case at layer 1.


  **The universe is `Type u` throughout, not `Type v`, and this is a real

  constraint rather than tidying**: `isGaloisQuotient_spec` lives at `Scheme.{u}`,

  so it does not apply to a `Type v` ring. §§1–3 above are universe-polymorphic in

  `A`; only this corollary is pinned, and a consumer whose section ring sits at

  another level owes a universe bridge here and nowhere else.


  Still **no** discharge of `HasGaloisQuotient` for a non-affine `X`: this is one

  piece of a cover, and assembling the pieces is layer 3, where the Hironaka trap

  bites.


  `[Algebra K A]` and `[IsScalarTower K L A]` are `omit`ted: inherited from

  `isSemilinear_away`, consumed by neither (linter-confirmed). What the corollary

  needs of `A` is only that it acts and maps to `S`.


  **WHAT I COULD NOT CLOSE, and a consumer should read this before relying on the

  corollary.** The binders are jointly satisfiable at a *non-degenerate* site:

  `A = L ⊗[K] K[X]` with the left-factor Galois action, `N = 1 ⊗ X` — an **invariant

  non-unit**, so the localization is not trivially `A` — where all five of

  `Algebra L`, `Algebra K`, `IsScalarTower K L`, `IsScalarTower L A` and

  `IsLocalization.Away` synthesise, and `IsSemilinear K L (L ⊗[K] K[X])` closes by

  `inferInstance`. That much is measured. But **applying this corollary there did
  not

  elaborate**: the goal `IsSemilinear K L (L ⊗[K] K[X])` fails synthesis at the

  application even with a hypothesis of exactly that type in context (measured — the

  context shows `hsl : IsSemilinear K L (L ⊗[K] K[X])` and the unsolved goal is

  literally it). So this is an **instance-path mismatch**, not an absence: the

  tensor-product action is a *scoped* instance

  (`instMulSemiringActionTensor`) and `IsSemilinear` is indexed by the

  `DistribMulAction`, so the action supplied by `letI` and the one the ambient

  instance found are different terms at the same type.


  Recorded as unmeasured rather than papered over: the corollary is a theorem and
  its

  axiom list is clean, but *no site in this project has been shown to satisfy its

  binders in a way that lets it be applied*. A lane consuming it should elaborate
  at

  its own object and, if it hits this, pin the action with an explicit `letI` before

  the application rather than relying on synthesis.'
file: AlgebraicJacobian/Picard/GaloisDescent/InvariantsLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.isGaloisQuotient_away
type: lean
updated: '2026-07-30T10:40:20'
---
theorem isGaloisQuotient_away :
    letI := SemilinearAction.awayAction K L N hN S
    letI := SemilinearAction.isSemilinear_away K L N hN S
    IsGaloisQuotient (specSemilinearGalAction K L S)
      (AlgebraicGeometry.Spec.map (CommRingCat.ofHom
        (algebraMap K (SemilinearAction.invariantsSubalgebra K L S)))) := by
  letI := SemilinearAction.awayAction K L N hN S
  letI := SemilinearAction.isSemilinear_away K L N hN S
  exact isGaloisQuotient_spec K L S