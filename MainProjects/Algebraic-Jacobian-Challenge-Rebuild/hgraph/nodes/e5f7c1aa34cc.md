---
author: sync
content_type: theorem
created: '2026-08-17T13:21:30'
decl: AlgebraicGeometry.exists_finSubext_pic0FiniteStageTripleTransition_models_of_comparisons
docstring: 'Given scalar-extension comparisons for the triple models, all transported
  cyclic

  triple transitions descend simultaneously through one finite subextension `N/M`.  The

  displayed square is the precise comparison with the transported exact transition.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageTripleTransitionModels.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_finSubext_pic0FiniteStageTripleTransition_models_of_comparisons
type: lean
updated: '2026-08-18T20:51:05'
---
theorem exists_finSubext_pic0FiniteStageTripleTransition_models_of_comparisons
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C → ℕ)
    (relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    [Algebra.IsAlgebraic M.1 k]
    (mapM : ∀ q : Pic0FiniteStageMapIndex C,
      Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q) →ₐ[M.1]
        Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))
    (Q : ∀ q : Pic0FiniteStageTripleTransitionIndex C,
      k ⊗[M.1] Pic0FiniteStageTripleTransitionModelTarget
          C L n m relation M mapM q ≃ₐ[k]
        Pic0FiniteStageTripleRing C q.1 q.2.1 q.2.2) :
    ∃ N : DatG0.FinSubext M.1 k,
      ∀ p : Pic0FiniteStageTripleTransitionIndex C,
        ∃ thetaN :
          N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelSource
              C L n m relation M mapM p →ₐ[N.1]
            N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelTarget
              C L n m relation M mapM p,
          (Algebra.TensorProduct.map N.1.val
              (AlgHom.id M.1
                (Pic0FiniteStageTripleTransitionModelTarget
                  C L n m relation M mapM p))).comp
              (thetaN.restrictScalars M.1) =
            ((pic0FiniteStageTransportedTripleTransition
              C L n m relation M mapM Q p).restrictScalars M.1).comp
              (Algebra.TensorProduct.map N.1.val
                (AlgHom.id M.1
                  (Pic0FiniteStageTripleTransitionModelSource
                    C L n m relation M mapM p))) := by
  letI : ∀ p : Pic0FiniteStageTripleTransitionIndex C,
      Algebra.FiniteType M.1
        (Pic0FiniteStageTripleTransitionModelSource
          C L n m relation M mapM p) := fun p =>
    finiteType_pic0FiniteStageTripleModelRing
      C L n m relation M mapM p.2.1 p.2.2 p.1
  exact DatG0.exists_finSubext_tensorProduct_algHom_finite
    (F := M.1) (K := k)
    (fun p : Pic0FiniteStageTripleTransitionIndex C =>
      Pic0FiniteStageTripleTransitionModelSource C L n m relation M mapM p)
    (fun p : Pic0FiniteStageTripleTransitionIndex C =>
      Pic0FiniteStageTripleTransitionModelTarget C L n m relation M mapM p)
    (pic0FiniteStageTransportedTripleTransition C L n m relation M mapM Q)