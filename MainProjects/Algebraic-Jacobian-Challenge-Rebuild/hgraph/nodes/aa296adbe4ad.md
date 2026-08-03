---
author: sync
content_type: definition
created: '2026-08-03T20:05:08'
decl: AlgebraicGeometry.admissibleAbelEtaleSourceIso
docstring: 'Subcanonicity identifies the universe-raised Yoneda sheaf of the admissible
  divisor

  representer with the sheafification of its underlying representable presheaf.'
file: AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSheafification.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.admissibleAbelEtaleSourceIso
type: lean
updated: '2026-08-03T20:05:08'
---
noncomputable def admissibleAbelEtaleSourceIso :
    Scheme.etaleTopology.uliftYoneda.{u + 1}.obj
        (divRepAffAdmissibleScheme C).left ≅
      (presheafToSheaf Scheme.etaleTopology (Type (u + 1))).obj
        (yoneda.obj (divRepAffAdmissibleScheme C).left ⋙ uliftFunctor.{u + 1}) :=
  (asIso ((sheafificationAdjunction Scheme.etaleTopology (Type (u + 1))).counit.app
    (Scheme.etaleTopology.uliftYoneda.{u + 1}.obj
      (divRepAffAdmissibleScheme C).left))).symm