---
author: sync
content_type: theorem
created: '2026-08-18T01:05:18'
decl: AlgebraicGeometry.scalarExtensionMapOfAlgHom_tower_finSubext
docstring: 'The scalar-extension tower square, with the ambient map written using
  the

  canonical value map of a finite subextension.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageTripleTransitionFaceReflection.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.scalarExtensionMapOfAlgHom_tower_finSubext
type: lean
updated: '2026-08-18T01:05:18'
---
theorem scalarExtensionMapOfAlgHom_tower_finSubext
    {F K A B : Type u}
    [Field F] [Field K] [Algebra F K] [Algebra.IsAlgebraic F K]
    [Semiring A] [Algebra F A] [Semiring B] [Algebra F B]
    (N : DatG0.FinSubext F K) (f : A →ₐ[F] B) :
    (Algebra.TensorProduct.map N.1.val (AlgHom.id F B)).comp
        ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := F) (K := N.1) f).restrictScalars F) =
      ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := F) (K := K) f).restrictScalars F).comp
        (Algebra.TensorProduct.map N.1.val (AlgHom.id F A)) := by
  have hval : N.1.val = IsScalarTower.toAlgHom F N.1 K := by
    ext x
    rfl
  have htower := AlgebraicJacobian.scalarExtensionMapOfAlgHom_tower
    (F := F) (L := N.1) (K := K) f
  rw [← hval] at htower
  exact htower

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

section

variable {F : Type u} [Field F] [Algebra F k]
variable (L : DatG0.FinSubext F k)
variable (n m : Pic0FiniteStageRingIndex C → Nat)
variable (relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
variable (M : DatG0.FinSubext L.1 k)
variable [Algebra.IsAlgebraic M.1 k]
variable (mapM : ∀ q : Pic0FiniteStageMapIndex C,
  Pic0FiniteStageModelRing C L n m relation M
      (Pic0FiniteStageMapSource C q) →ₐ[M.1]
    Pic0FiniteStageModelRing C L n m relation M
      (Pic0FiniteStageMapTarget C q))

set_option synthInstance.maxHeartbeats 400000 in
-- The comparison equivalences contain dependent quotient-algebra towers.
set_option maxHeartbeats 6400000 in
-- Naturality must expose both comparison equivalences at once.
omit [Algebra.IsAlgebraic M.1 k] in