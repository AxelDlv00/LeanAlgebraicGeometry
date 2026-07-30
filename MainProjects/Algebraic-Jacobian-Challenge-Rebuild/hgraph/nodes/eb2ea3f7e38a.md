---
author: sync
content_type: theorem
created: '2026-07-17T16:57:14'
decl: AlgebraicGeometry.RelPicTransportFamily.descentHom_descentMap
docstring: 'The descent-class transport commutes with refinement transport — what
  makes the

  plus-level transport well defined on `mk`-equal representatives.'
file: AlgebraicJacobian/Picard/PicEtAffTransport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.RelPicTransportFamily.descentHom_descentMap
type: lean
updated: '2026-07-30T15:46:06'
---
theorem descentHom_descentMap {U V : Algebra.EtaleCover A} (h : U.Carrier →ₐ[A] V.Carrier)
    (x : descentClasses E U) :
    T.descentHom V (descentMap E h x) = descentMap D h (T.descentHom U x) := by
  ext
  rw [descentHom_coe, descentMap_coe, descentMap_coe, descentHom_coe,
    T.relPicAlgMap_relPicHom (h.restrictScalars kD) (h.restrictScalars kE)
      (fun _ => rfl)]

/-! ## The étale-plus transport -/

variable (A) in