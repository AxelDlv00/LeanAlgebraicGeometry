---
author: sync
content_type: definition
created: '2026-07-28T12:23:41'
decl: AlgebraicGeometry.Scheme.PicSharp.etaleSheaf
docstring: '**The étale-sheafified relative Picard functor** `Pic_{(C/k)ét}`

  (Kleiman §2 Def. `df:Pfs`, étale-sheaf clause).


  The associated étale sheaf of the relative Picard presheaf

  `T ↦ Pic(C ×_k T)/π_T^* Pic(T)` (`PicSharp.relPresheaf`), as a bundled object

  of `Sheaf (etaleTopologyOver k) AddCommGrpCat`. Its sheaf property is not an

  assumption but part of the datum — `Sheaf.cond`, extracted as

  `etaleSheaf_isSheaf` below — which is the whole point of passing to it: the

  unsheafified `relPresheaf` is not a sheaf even Zariski-locally.


  This is a genuine instantiation of the parametric `PicSharp.etSheaf` of

  `Picard/RelPicFunctor.lean` at the canonical étale topology, with one

  correction: `etSheaf` sheafifies the *absolute* functor `PicSharp.presheaf`

  (`T ↦ Pic(C ×_k T)`), whereas Kleiman''s `Pic_{(C/k)ét}` and the

  representability theorem are about the *relative* one, `relPresheaf`. It is

  the relative functor that is sheafified here.


  The abelian-group structure survives sheafification because the target

  `AddCommGrpCat` has the sheafification adjunction

  (`HasWeakSheafify` for a concrete, filtered-colimit-preserving forgetful

  functor); `toEtaleSheaf` below is the unit.'
file: AlgebraicJacobian/Picard/PicEtSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicSharp.etaleSheaf
type: lean
updated: '2026-07-28T12:23:41'
---
noncomputable def etaleSheaf {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    Sheaf (etaleTopologyOver k) AddCommGrpCat.{u+1} :=
  (CategoryTheory.presheafToSheaf (etaleTopologyOver k) AddCommGrpCat.{u+1}).obj
    (PicSharp.relPresheaf C)