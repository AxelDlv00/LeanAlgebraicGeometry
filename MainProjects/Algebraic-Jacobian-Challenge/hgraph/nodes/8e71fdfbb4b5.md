---
author: sync
content_type: theorem
created: '2026-07-30T08:42:03'
decl: AlgebraicJacobian.NonVacuity.galoisLevel_p1Over_rat
docstring: '**Non-vacuity 2: a concrete inhabitant.** `ℙ¹` over `ℚ` satisfies the
  binders and the

  conclusion holds for it, so §3 is not a statement about an empty class of curves.'
file: AlgebraicJacobian/Curve/GaloisLevelRationalPoint.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.NonVacuity.galoisLevel_p1Over_rat
type: lean
updated: '2026-07-30T08:42:03'
---
theorem galoisLevel_p1Over_rat :
    ∃ (k'' : IntermediateField ℚ (SeparableClosure ℚ)) (_ : FiniteDimensional ℚ k'')
      (_ : IsGalois ℚ k''),
      Scheme.HasRationalPoint (Scheme.baseChangeField (p1Over ℚ) k'') :=
  Scheme.exists_finiteGalois_level_hasRationalPoint_of_geometricallyIntegral (p1Over ℚ)

end AlgebraicJacobian.NonVacuity

/-! ## §5. Why the Galois hypothesis is the point: composing with the `G2` quotient engine

§3's whole advance over `Curve/FiniteLevelRationalPoint.lean` is `[IsGalois k k'']` rather than
`Algebra.IsSeparable k k'`. That is worth a *declaration* rather than a docstring claim, because
"the stronger hypothesis is the one the consumer wants" is exactly the sentence a costing gets
wrong. `G2`'s quotient engine takes a `SemilinearGalAction K L X f`, whose group is `L ≃ₐ[K] L`,
and its discharge `hasGaloisQuotient_of_isAffine` binds `[FiniteDimensional K L] [IsGalois K L]` —
both of which §3 now supplies at a level a curve over an arbitrary field actually reaches.

**Read the scope of §5 precisely.** It composes §3 with the **affine** half of `G2`, which is the
half that is proved (`GaloisQuotientAffineGeneral.lean`). The campaign's actual consumer `J'_r` is
a *glued* scheme, hence non-affine, and the gate there is open — `G2(c)`, the `Scheme.GlueData`
assembly, with the Hironaka trap. So §5 is evidence that the Galois strengthening reaches a real
engine, **not** evidence that `G2` is closed. And it is still the existential level of §3: the
quotient clause is universally quantified over affine `X` *at that* `k''`.
-/

namespace AlgebraicJacobian.GaloisLevel

open AlgebraicJacobian.GaloisDescent