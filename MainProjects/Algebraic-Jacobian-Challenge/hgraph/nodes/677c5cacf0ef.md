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

  needs of `A` is only that it acts and maps to `S`.'
file: AlgebraicJacobian/Picard/GaloisDescent/InvariantsLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.isGaloisQuotient_away
type: lean
updated: '2026-07-30T10:26:46'
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