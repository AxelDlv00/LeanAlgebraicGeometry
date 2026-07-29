---
author: sync
content_type: theorem
created: '2026-07-29T23:41:45'
decl: AlgebraicGeometry.Scheme.picEt_isSheaf_etaleTopologyOver
docstring: '**`picEt C` is an étale sheaf on `(Sch/k)`**, in the type-valued form
  the

  descent test needs.


  `PicSharp.etaleSheaf C` is a sheaf by construction, and the sheaf property of an

  `AddCommGrpCat`-valued presheaf is equivalent to that of its underlying

  type-valued functor (`Presheaf.isSheaf_iff_isSheaf_forget`, the forgetful functor

  of a concrete algebraic category preserving limits and reflecting isomorphisms).

  Proved, not assumed — and with no hypothesis on `C(k)`.


  This is the same reflection step as

  `PicScheme.relPresheaf_isSheaf_of_representableBy`

  (`Picard/PicEtSubcanonical.lean`) run in the opposite direction: there it takes
  a

  representing scheme to make the *unsheafified* presheaf a sheaf; here the

  sheafified one is a sheaf for free.'
file: AlgebraicJacobian/Picard/EtaleFieldCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.picEt_isSheaf_etaleTopologyOver
type: lean
updated: '2026-07-29T23:41:45'
---
theorem picEt_isSheaf_etaleTopologyOver (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    Presieve.IsSheaf (etaleTopologyOver k) (PicScheme.picEt C) := by
  have h := PicSharp.etaleSheaf_isSheaf C
  rw [Presheaf.isSheaf_iff_isSheaf_forget
      (s := CategoryTheory.forget AddCommGrpCat.{u + 1}),
    isSheaf_iff_isSheaf_of_type] at h
  exact h