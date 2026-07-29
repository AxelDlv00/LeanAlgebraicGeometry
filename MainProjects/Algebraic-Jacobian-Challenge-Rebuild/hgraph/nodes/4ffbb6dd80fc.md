---
author: sync
content_type: definition
created: '2026-07-17T08:59:06'
decl: AlgebraicGeometry.JacobianData.pointTranslationIso
docstring: 'Translation of the Jacobian datum''s representing object, as an isomorphism
  of the

  underlying scheme `d.J.left`.'
file: AlgebraicJacobian/AbelianVariety/Translation.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.JacobianData.pointTranslationIso
type: lean
updated: '2026-07-29T15:26:20'
---
noncomputable def pointTranslationIso (d : JacobianData C)
    (x y : 𝟙_ (Over (Spec (.of k))) ⟶ d.J) : d.J.left ≅ d.J.left :=
  letI := d.grpObj
  GrpObj.pointTranslationIso d.J x y

/-- Translations of `d.J.left` commute with the structure morphism. -/
@[reassoc (attr := simp)]