---
author: sync
content_type: lemma
created: '2026-07-17T16:57:12'
decl: AlgebraicGeometry.sectionsCollapse_resHom
docstring: The section collapse commutes with restriction.
file: AlgebraicJacobian/Cohomology/RelThetaTransportCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sectionsCollapse_resHom
type: lean
updated: '2026-07-31T20:15:18'
---
lemma sectionsCollapse_resHom {W V : C.left.Opens} (hWV : W ≤ V)
    (hW : IsCompact (W : Set C.left)) (hW' : IsQuasiSeparated (W : Set C.left))
    (hV : IsCompact (V : Set C.left)) (hV' : IsQuasiSeparated (V : Set C.left))
    (s : Γ(C.left, V)) :
    sectionsCollapse C W hW hW' (C.left.resHom hWV s) =
      (relCurve C k).resHom (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)
        (sectionsCollapse C V hV hV' s) := by
  rw [sectionsCollapse_apply, sectionsCollapse_apply, relPullbackSection_resHom']