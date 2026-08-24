---
author: sync
content_type: theorem
created: '2026-08-16T20:15:44'
decl: AlgebraicGeometry.DatG0.exists_finSubext_tensorProduct_algHom
docstring: 'A `K`-algebra map between base changes of `F`-algebras descends to a finite

  subextension of `K/F` when the source algebra is of finite type. The descended map

  commutes with the canonical maps to the original `K`-algebras.'
file: AlgebraicJacobian/Picard/FinitePresentationAlgebraMapFiniteStage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.exists_finSubext_tensorProduct_algHom
type: lean
updated: '2026-08-18T20:51:03'
---
theorem exists_finSubext_tensorProduct_algHom
    {F K A B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing A] [Algebra F A]
    [Algebra.FiniteType F A] [CommRing B] [Algebra F B]
    (phi : K ⊗[F] A →ₐ[K] K ⊗[F] B) :
    ∃ L : FinSubext F K, ∃ phiL : L.1 ⊗[F] A →ₐ[L.1] L.1 ⊗[F] B,
      (Algebra.TensorProduct.map L.1.val (AlgHom.id F B)).comp
          (phiL.restrictScalars F) =
        (phi.restrictScalars F).comp
          (Algebra.TensorProduct.map L.1.val (AlgHom.id F A)) := by
  let fA : A →ₐ[F] K ⊗[F] B :=
    (phi.restrictScalars F).comp Algebra.TensorProduct.includeRight
  have hfA : fA.range.FG := by
    simpa only [Algebra.map_top] using
      (Subalgebra.FG.map fA Algebra.FiniteType.out)
  obtain ⟨L, g, hg⟩ :=
    exists_finSubext_fg_subalgebra_tensorProduct_factor fA.range hfA
  let fL : A →ₐ[F] L.1 ⊗[F] B := g.comp fA.rangeRestrict
  let phiL : L.1 ⊗[F] A →ₐ[L.1] L.1 ⊗[F] B :=
    AlgHom.liftEquiv F L.1 A (L.1 ⊗[F] B) fL
  have hbase (a : A) :
      (Algebra.TensorProduct.map L.1.val (AlgHom.id F B)) (fL a) = fA a := by
    change ((Algebra.TensorProduct.map L.1.val (AlgHom.id F B)).comp g)
      (fA.rangeRestrict a) = fA a
    rw [hg]
    rfl
  refine ⟨L, phiL, ?_⟩
  ext x
  · change (Algebra.TensorProduct.map L.1.val (AlgHom.id F B))
        (phiL (Algebra.TensorProduct.includeLeft (R := F) (S := L.1)
          (A := L.1) (B := A) x)) =
      phi ((Algebra.TensorProduct.map L.1.val (AlgHom.id F A))
        (Algebra.TensorProduct.includeLeft (R := F) (S := L.1)
          (A := L.1) (B := A) x))
    simp only [Algebra.TensorProduct.includeLeft_apply, phiL, AlgHom.liftEquiv_tmul,
      Algebra.TensorProduct.map_tmul, map_one]
    simpa [Algebra.smul_def] using (phi.commutes (x : K)).symm
  · change (Algebra.TensorProduct.map L.1.val (AlgHom.id F B))
        (phiL (Algebra.TensorProduct.includeRight (R := F) (A := L.1) (B := A) x)) =
      phi ((Algebra.TensorProduct.map L.1.val (AlgHom.id F A))
        (Algebra.TensorProduct.includeRight (R := F) (A := L.1) (B := A) x))
    simp only [Algebra.TensorProduct.includeRight_apply, phiL, AlgHom.liftEquiv_tmul,
      Algebra.TensorProduct.map_tmul, AlgHom.id_apply, map_one, one_smul]
    exact hbase x