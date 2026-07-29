---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
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
file: AlgebraicJacobian/Albanese/CodimOneSmoothReduced.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.isIntegral_pullback_self
type: lean
updated: '2026-07-29T15:31:33'
---
theorem isIntegral_pullback_self
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (X : Over (Spec (.of kbar)))
    [Smooth X.hom] [GeometricallyIrreducible X.hom] [IsIntegral X.left] :
    IsIntegral (pullback X.hom X.hom) := by
  -- The composite structure map `X ×_{k̄} X → Spec k̄` is smooth (`smooth_comp` of
  -- the base-change-smooth projection with `X.hom`); package it as an `Over` object.
  haveI hsm : Smooth (Over.mk (pullback.fst X.hom X.hom ≫ X.hom)).hom := by
    change Smooth (pullback.fst X.hom X.hom ≫ X.hom); infer_instance
  haveI hred : IsReduced (pullback X.hom X.hom) :=
    isReduced_of_smooth_of_isAlgClosed (Over.mk (pullback.fst X.hom X.hom ≫ X.hom))
  -- Irreducibility of `X ×_{k̄} X` from geometric irreducibility of `X.hom` (the
  -- projection is universally open). Drive synthesis through the `Scheme`-typed
  -- application so the `Scheme → Type` coercion on the pullback is inserted (a bare
  -- `IrreducibleSpace (pullback …)` mis-resolves `pullback` in the `Type` category).
  haveI : UniversallyOpen X.hom := inferInstance
  exact isIntegral_of_irreducibleSpace_of_isReduced (pullback X.hom X.hom)