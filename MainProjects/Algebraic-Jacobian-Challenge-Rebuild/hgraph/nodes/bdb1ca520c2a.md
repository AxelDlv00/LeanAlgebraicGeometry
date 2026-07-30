---
author: sync
content_type: lemma
created: '2026-07-17T16:57:12'
decl: AlgebraicGeometry.relPullbackSection_resHom'
docstring: '**Pullback of sections to the relative curve commutes with restriction**
  (the

  `RelativeSectionsLinear`-level fact, re-derived here to avoid the `Challenge` import
  of

  `H1BaseFieldInvariance`): restricting on the curve then pulling back agrees with
  pulling

  back then restricting on the relative curve.'
file: AlgebraicJacobian/Cohomology/RelThetaTransportCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relPullbackSection_resHom'
type: lean
updated: '2026-07-30T15:46:00'
---
lemma relPullbackSection_resHom' {W V : C.left.Opens} (hWV : W ≤ V) (s : Γ(C.left, V)) :
    relPullbackSection C k W (C.left.resHom hWV s) =
      (relCurve C k).resHom
        (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)
        (relPullbackSection C k V s) := by
  have h1 : C.left.presheaf.map (homOfLE hWV).op ≫
      (fst C (overSpec k k)).left.appLE W ((fst C (overSpec k k)).left ⁻¹ᵁ W) le_rfl =
      (fst C (overSpec k k)).left.appLE V ((fst C (overSpec k k)).left ⁻¹ᵁ W)
        (le_rfl.trans (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)) :=
    Scheme.Hom.map_appLE _ le_rfl (homOfLE hWV).op
  have h2 : (fst C (overSpec k k)).left.appLE V ((fst C (overSpec k k)).left ⁻¹ᵁ V)
        le_rfl ≫
      (relCurve C k).presheaf.map
        (homOfLE (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)).op =
      (fst C (overSpec k k)).left.appLE V ((fst C (overSpec k k)).left ⁻¹ᵁ W)
        (le_rfl.trans (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)) :=
    Scheme.Hom.appLE_map _ le_rfl
      (homOfLE (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)).op
  exact (congr($(h1).hom s)).trans (congr($(h2).hom s)).symm