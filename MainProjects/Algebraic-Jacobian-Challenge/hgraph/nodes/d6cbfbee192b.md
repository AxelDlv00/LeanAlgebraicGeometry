---
author: sync
content_type: theorem
created: '2026-07-28T12:23:41'
decl: AlgebraicGeometry.Scheme.PicScheme.picEt_isSheaf_forget
docstring: '**`picEt` is an étale sheaf of sets.**


  The sheaf property of `Pic_{(C/k)ét}` survives forgetting the group structure,

  because the forgetful functor `AddCommGrpCat ⥤ Type` preserves the limits the

  sheaf condition is stated by. Together with the fact that a representable

  functor is a sheaf for a subcanonical topology, this is the structural reason

  the representability obligation is *consistent* as stated — which the

  unsheafified `picSharp` version was not, absent a rational point.'
file: AlgebraicJacobian/Picard/PicEtSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.picEt_isSheaf_forget
type: lean
updated: '2026-07-28T12:23:41'
---
theorem picEt_isSheaf_forget {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    Presieve.IsSheaf (etaleTopologyOver k) (picEt C) := by
  have h := ((CategoryTheory.sheafCompose (etaleTopologyOver k)
    (CategoryTheory.forget AddCommGrpCat.{u+1})).obj (PicSharp.etaleSheaf C)).property
  rw [CategoryTheory.isSheaf_iff_isSheaf_of_type] at h
  exact h