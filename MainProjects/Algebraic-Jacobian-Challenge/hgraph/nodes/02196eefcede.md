---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.homCechComplex_d_eq
docstring: '**Degreewise differential identification** of the hom-complex with the
  mapped opposite of

  the free Čech complex.  Both differentials are alternating sums of (co)faces; pushing
  the

  opposite and the additive functor `Hom(-, F)` through the alternating sum on the
  right and

  using `homCechCosimplicial_δ` matches them term by term.  This is the naturality
  input for the

  cochain-complex isomorphism `homCechComplexMapOpIso`.'
file: AlgebraicJacobian/Cohomology/CechBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.homCechComplex_d_eq
type: lean
updated: '2026-07-24T03:02:09'
---
private lemma homCechComplex_d_eq (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) (p : ℕ) :
    (homCechComplex 𝒰 F).d p (p + 1)
      = (((preadditiveYoneda.obj F).mapHomologicalComplex (ComplexShape.up ℕ)).obj
          (HomologicalComplex.op (cechFreePresheafComplex 𝒰))).d p (p + 1) := by
  have hL : (homCechComplex 𝒰 F).d p (p + 1)
      = AlgebraicTopology.AlternatingCofaceMapComplex.objD (homCechCosimplicial 𝒰 F) p :=
    CochainComplex.of_d (fun n => (homCechCosimplicial 𝒰 F).obj (SimplexCategory.mk n)) (AlgebraicTopology.AlternatingCofaceMapComplex.objD (homCechCosimplicial 𝒰 F)) p
  have hR : (cechFreePresheafComplex 𝒰).d (p + 1) p
      = AlgebraicTopology.AlternatingFaceMapComplex.objD (cechFreeSimplicial 𝒰) p :=
    ChainComplex.of_d (fun n => (cechFreeSimplicial 𝒰).obj (Opposite.op (SimplexCategory.mk n))) (AlgebraicTopology.AlternatingFaceMapComplex.objD (cechFreeSimplicial 𝒰)) p
  rw [hL, AlgebraicTopology.AlternatingCofaceMapComplex.objD,
    Functor.mapHomologicalComplex_obj_d, HomologicalComplex.op_d, hR,
    AlgebraicTopology.AlternatingFaceMapComplex.objD]
  have hop := CategoryTheory.op_sum
    ((cechFreeSimplicial 𝒰).obj (Opposite.op (SimplexCategory.mk (p + 1))))
    ((cechFreeSimplicial 𝒰).obj (Opposite.op (SimplexCategory.mk p)))
    (Finset.univ : Finset (Fin (p + 2)))
    (fun i => (-1 : ℤ) ^ (i : ℕ) • (cechFreeSimplicial 𝒰).δ i)
  erw [hop, Functor.map_sum]
  refine Finset.sum_congr rfl (fun i _ => ?_)
  rw [homCechCosimplicial_δ, CategoryTheory.op_zsmul]
  erw [Functor.map_zsmul]
  rfl