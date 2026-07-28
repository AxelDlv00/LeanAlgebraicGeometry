---
author: sync
content_type: lemma
created: '2026-07-17T16:57:14'
decl: AlgebraicGeometry.RelPicTransportFamily.mapSig_rel
docstring: "The descent-class transport commutes with refinement transport — what\
  \ makes the\nplus-level transport well defined on `mk`-equal representatives. -/\n\
  theorem descentHom_descentMap {U V : Algebra.EtaleCover A} (h : U.Carrier →ₐ[A]\
  \ V.Carrier)\n    (x : descentClasses E U) :\n    T.descentHom V (descentMap E h\
  \ x) = descentMap D h (T.descentHom U x) := by\n  ext\n  rw [descentHom_coe, descentMap_coe,\
  \ descentMap_coe, descentHom_coe,\n    T.relPicAlgMap_relPicHom (h.restrictScalars\
  \ kD) (h.restrictScalars kE)\n      (fun _ => rfl)]\n\n/-! ## The étale-plus transport\
  \ -/\n\nvariable (A) in\nprivate def mapSig (p : Σ U : Algebra.EtaleCover A, descentClasses\
  \ E U) :\n    Σ U : Algebra.EtaleCover A, descentClasses D U :=\n  ⟨p.1, T.descentHom\
  \ p.1 p.2⟩\n\n/- Stated with the sigma pairs destructured, so that no goal mentions\
  \ a sigma-literal\nprojection."
file: AlgebraicJacobian/Picard/PicEtAffTransport.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.RelPicTransportFamily.mapSig_rel
type: lean
updated: '2026-07-28T17:25:27'
---
private lemma mapSig_rel {U V : Algebra.EtaleCover A} {x : descentClasses E U}
    {y : descentClasses E V} (F : Algebra.EtaleCover A) (f : U.Carrier →ₐ[A] F.Carrier)
    (g : V.Carrier →ₐ[A] F.Carrier) (hfg : descentMap E f x = descentMap E g y) :
    descentMap D f (T.descentHom U x) = descentMap D g (T.descentHom V y) := by
  rw [← T.descentHom_descentMap f x, ← T.descentHom_descentMap g y, hfg]