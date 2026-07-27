---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.QuotFamily.pullbackAlong
docstring: 'The **pullback action** on a family of quotients along `ψ : T'' ⟶ T` of

  `Over S`: pull the sheaf and the quotient map back along

  `quotBaseMap π ψ : X_{T''} ⟶ X_T`, matching the `E`-side through

  `pullbackTriangleIso (quotBaseMap_fst π ψ)`.  Well-definedness of the four

  conditions is the content of §2.'
file: AlgebraicJacobian/Picard/QuotFunctorDef.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.QuotFamily.pullbackAlong
type: lean
updated: '2026-07-27T12:05:13'
---
noncomputable def pullbackAlong [L.IsQuasicoherent] {T T' : Over S} (ψ : T' ⟶ T)
    (x : QuotFamily π L E Φ T) : QuotFamily π L E Φ T' where
  F := (Scheme.Modules.pullback (quotBaseMap π ψ)).obj x.F
  isFinitePresentation :=
    Modules.pullback_isFinitePresentation _ x.F x.isFinitePresentation
  flat := fun {U} hU {V} hV e =>
    CoherentSheafFlat.of_isPullback (quotBaseSquare π ψ) x.F
      (letI := x.isFinitePresentation; inferInstance) x.flat hU hV e
  properSupport :=
    Modules.HasProperSupport.of_isPullback (quotBaseSquare π ψ) x.F
      x.isFinitePresentation x.properSupport
  q := (pullbackTriangleIso (quotBaseMap_fst π ψ) E).inv ≫
    (Scheme.Modules.pullback (quotBaseMap π ψ)).map x.q
  epi :=
    @CategoryTheory.epi_comp _ _ _ _ _
      (pullbackTriangleIso (quotBaseMap_fst π ψ) E).inv inferInstance
      ((Scheme.Modules.pullback (quotBaseMap π ψ)).map x.q)
      (@CategoryTheory.Functor.map_epi _ _ _ _
        (Scheme.Modules.pullback (quotBaseMap π ψ)) inferInstance _ _ x.q x.epi)
  hilb := fun t' => by
    obtain ⟨N, hN⟩ := x.hilb (ψ.left.base t')
    exact ⟨N, fun m hm => (hN m hm).trans (congrArg (Nat.cast : ℕ → ℚ)
      (hilbertFunction_quotBaseMap π L ψ x.F x.isFinitePresentation
        x.properSupport t' m).symm)⟩

omit [IsLocallyNoetherian S] in