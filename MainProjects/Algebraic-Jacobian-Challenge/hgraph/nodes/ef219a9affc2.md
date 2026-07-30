---
author: sync
content_type: definition
created: '2026-07-30T16:55:39'
decl: AlgebraicGeometry.Scheme.PicScheme.twistAction
docstring: 'The canonical twists form a group action on the underlying representing

  scheme. The order in `twistMor_mul_left` is exactly the multiplication order in

  `Aut`, whose hom component reverses categorical composition.'
file: AlgebraicJacobian/Picard/GaloisDescent/PicEtGaloisAction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.twistAction
type: lean
updated: '2026-07-30T16:55:39'
---
noncomputable def twistAction :
    (k' ≃ₐ[k] k') →* Aut X'.left :=
  MonoidHom.mk' (twistAut C rep) fun γ τ => by
    apply Aut.ext
    exact twistMor_mul_left C rep γ τ