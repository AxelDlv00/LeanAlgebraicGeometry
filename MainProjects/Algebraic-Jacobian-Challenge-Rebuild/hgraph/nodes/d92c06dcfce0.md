---
author: sync
content_type: theorem
created: '2026-07-27T01:04:30'
decl: AlgebraicGeometry.DivRepAffinePullback.homOfLE_classifyPiece
docstring: 'The gluing datum: the family `classifyPiece` is compatible with the transition
  maps

  of the directed cover of `T.left` by its affine opens.  This is naturality of the
  affine

  classifier along the section restriction, applied to the coherence of `F`.'
file: AlgebraicJacobian/Picard/DivRepGlobalClassify.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.DivRepAffinePullback.homOfLE_classifyPiece
type: lean
updated: '2026-07-31T20:15:20'
---
private theorem homOfLE_classifyPiece
    (D : DivRepAffinePullback hpi g hO hchi r1 r2 b1 b2)
    {T : Over (Spec (CommRingCat.of k))} (F : divFamZar C pi g T)
    {U V : T.left.affineOpens} (hle : U.1 ≤ V.1) :
    T.left.homOfLE hle ≫ classifyPiece hpi g hO hchi r1 r2 b1 b2 F V
      = classifyPiece hpi g hO hchi r1 r2 b1 b2 F U := by
  have hres : (Over.overSpecMap (Over.resAlgHom T hle)).left ≫ V.2.fromSpec
      = U.2.fromSpec :=
    congrArg CategoryTheory.Over.Hom.left (Over.fromSpecAffine_resAlgHom (T := T) hle)
  have hkey : U.2.isoSpec.hom ≫ (Over.overSpecMap (Over.resAlgHom T hle)).left
      = T.left.homOfLE hle ≫ V.2.isoSpec.hom := by
    rw [← cancel_mono V.2.fromSpec, Category.assoc, Category.assoc, hres,
      isoSpec_hom_fromSpec, isoSpec_hom_fromSpec, Scheme.homOfLE_ι]
  have hcl : (Over.overSpecMap (Over.resAlgHom T hle)).left
        ≫ (divRepClassifyZar hpi g hO hchi r1 r2 b1 b2 Γ(T.left, V.1) (F.1 V)).left
      = (divRepClassifyZar hpi g hO hchi r1 r2 b1 b2 Γ(T.left, U.1) (F.1 U)).left := by
    rw [← CategoryTheory.Over.comp_left,
      overSpecMap_comp_divRepClassifyZar hpi g hO hchi r1 r2 b1 b2 D, F.compat U V hle]
  rw [classifyPiece, classifyPiece, ← Category.assoc, ← hkey, Category.assoc, hcl]