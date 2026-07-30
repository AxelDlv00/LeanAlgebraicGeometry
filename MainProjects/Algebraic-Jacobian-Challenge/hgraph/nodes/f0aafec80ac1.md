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

  unsheafified `relPresheaf` is not *a priori* an étale sheaf (Kleiman §2 L1330),

  so representability of `Pic_{(C/k)ét}` is the statement one can ask for over an

  arbitrary field.


  **Corrected 2026-07-30 (`review-ajc`): this said "not a sheaf even

  Zariski-locally", and that is the withdrawn claim.** It is wrong about exactly

  the functor named here. The lines it derives from (Kleiman §2 L1292–L1302) prove

  that the **absolute** `Pic_X` is never a separated Zariski presheaf; the

  **relative** functor — `relPresheaf`, this one — is *defined* by quotienting out

  `Pic(T)` precisely to defeat that argument. On these binders `th:cmp` part 1

  gives the opposite direction *in Kleiman*, `Pic_{X/S} ↪ Pic_{(X/S)zar}` whenever

  `O_S = f_*O_X` universally, i.e. `relPresheaf` is Zariski-**separated** there.


  **That last clause is about the SOURCE, and the Lean name first cited here does

  not carry it** (`review-ajc`, corrected in the same session by a fresh-context

  audit of this very fix). `PicScheme.picSharp_isSheaf_zariski_of_representableBy`

  (`Picard/PicEtSubcanonical.lean`) takes a `rep : (picSharp C).RepresentableBy X`

  hypothesis and concludes the Zariski sheaf property *from representability*, by

  subcanonicity — the converse direction, conditional on exactly what the seam

  lacks. `PicEtSubcanonical`''s §4 docstring scopes it correctly as "only the first

  half"; that caveat was dropped in copying the citation here. **Nothing in this

  project proves `th:cmp` part 1.**


  The seam and the blueprint were both corrected

  for this on 2026-07-29 (`I-0970`, `I-0973`) and this site was missed. Do not

  restore a Zariski-sheaf reason here; take the non-representability directly, via

  `PicScheme.not_exists_representing_picSharp_of_not_isIso`, whose one open input
  is

  that the comparison really fails for Kleiman''s pointless real conic.


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
updated: '2026-07-30T08:42:03'
---
noncomputable def etaleSheaf {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    Sheaf (etaleTopologyOver k) AddCommGrpCat.{u+1} :=
  (CategoryTheory.presheafToSheaf (etaleTopologyOver k) AddCommGrpCat.{u+1}).obj
    (PicSharp.relPresheaf C)