---
author: sync
content_type: theorem
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.Scheme.isIntegral_pullback_self
docstring: '**Integrality of the self-product `X ×_{k̄} X`.** For a smooth, geometrically

  irreducible, integral scheme `X` over an algebraically closed field `k̄`, the self

  fibre product `X ×_{k̄} X` is integral: it is reduced because it is smooth over
  the

  algebraically closed field (`isReduced_of_smooth_of_isAlgClosed` on the composite

  structure map `pr₁ ≫ X.hom`) and irreducible because `X.hom` is geometrically

  irreducible and universally open (`GeometricallyIrreducible.irreducibleSpace`,

  base change of geometric irreducibility along the open projection).


  This discharges the `[IsIntegral (pullback X.hom X.hom)]` hypothesis of

  `AlgebraicGeometry.Scheme.RationalMap.differenceRationalMap` (Milne Lemma 3.3,

  Sub-step 1, `Albanese/DifferenceMap.lean`), and supplies the integral-surface input

  to the pole-purity engine of Sub-step 4 (`Albanese/PolePurity.lean`). Axiom-clean.'
file: AlgebraicJacobian/Albanese/CodimOneExtension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.isIntegral_pullback_self
type: lean
updated: '2026-07-24T22:10:32'
---
theorem isIntegral_pullback_self
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (X : Over (Spec (.of kbar)))
    [Smooth X.hom] [GeometricallyIrreducible X.hom] [IsIntegral X.left] :
    IsIntegral (pullback X.hom X.hom) := by
  -- The composite structure map `X ×_{k̄} X → Spec k̄` is smooth (`smooth_comp` of
  -- the base-change-smooth projection with `X.hom`); package it as an `Over` object.
  haveI hsm : Smooth (Over.mk (pullback.fst X.hom X.hom ≫ X.hom)).hom := by
    change Smooth (pullback.fst X.hom X.hom ≫ X.hom)
    infer_instance
  haveI hred : IsReduced (pullback X.hom X.hom) :=
    isReduced_of_smooth_of_isAlgClosed (Over.mk (pullback.fst X.hom X.hom ≫ X.hom))
  -- Irreducibility of `X ×_{k̄} X` from geometric irreducibility of `X.hom` (the
  -- projection is universally open). Drive synthesis through the `Scheme`-typed
  -- application so the `Scheme → Type` coercion on the pullback is inserted (a bare
  -- `IrreducibleSpace (pullback …)` mis-resolves `pullback` in the `Type` category).
  haveI : UniversallyOpen X.hom := inferInstance
  exact isIntegral_of_irreducibleSpace_of_isReduced (pullback X.hom X.hom)

/-! ## §3.C. Project-local Mathlib supplement

### Matsumura regular-sequence bridge (iter-203, Step A1)

Lane COE Step A1 substrate (Matsumura *Commutative Ring Theory* Thm 14.2 /
Stacks 00NQ). The goal of this section is the criterion: on a regular local
Noetherian ring `(A, 𝔪)`, a finite sequence `f₁,…,f_c ∈ 𝔪` whose images in the
cotangent space `𝔪/𝔪²` are `κ`-linearly independent forms a
`RingTheory.Sequence.IsRegular` sequence.

The induction is on the length `c`, peeling the head `f₁`. The mathematical
peeling step uses `RingTheory.Sequence.IsRegular.cons'`, whose tail lives over
the *module* quotient `QuotSMulTop f₁ A = A ⧸ (f₁ • ⊤)`. The two bridges below
convert that module-quotient bookkeeping into the *ring* quotient
`A ⧸ Ideal.span {f₁}` (over which the induction hypothesis is naturally
phrased): `quotSMulTop_quotientRing_linearEquiv` is the canonical
`(A ⧸ span{f₁})`-linear identification `QuotSMulTop f₁ A ≃ₗ A ⧸ span{f₁}`, and
`isRegular_cons_of_quotient_ring` is the resulting clean cons rule.

These are project-local because Mathlib ships only the `QuotSMulTop`-flavoured
`IsRegular.cons'`; the ring-quotient repackaging is what makes a downstream
ring-theoretic induction (the Matsumura criterion) ergonomic. -/