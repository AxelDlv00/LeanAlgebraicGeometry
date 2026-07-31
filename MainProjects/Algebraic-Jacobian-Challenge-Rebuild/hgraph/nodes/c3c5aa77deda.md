---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.TwoCover.mumfordScaling
docstring: '**The Mumford `ε ↦ aε` scaling of the thickened Čech `Ȟ¹`** of the two-cover,
  for

  a scalar `a : k` (acting through the structure constant

  `X.overAlgebraMap k (U₀ ⊓ U₁) a`). Descends to the quotient because the scaling

  preserves the thickened coboundaries

  (`TruncExpCech.cechCoboundaryUnits_le_comap_unitsScale`, with the chart compatibility

  `resHom_overAlgebraMap_left/right`).'
file: AlgebraicJacobian/Tangent/TruncExpCechH1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.TwoCover.mumfordScaling
type: lean
updated: '2026-07-31T20:15:29'
---
noncomputable def mumfordScaling (a : k) :
    ((Γ(X, U₀ ⊓ U₁)[ε])ˣ ⧸ cechCoboundaryUnits
        (mapRingHom (X.resHom (inf_le_left : U₀ ⊓ U₁ ≤ U₀)))
        (mapRingHom (X.resHom (inf_le_right : U₀ ⊓ U₁ ≤ U₁)))) →*
      (Γ(X, U₀ ⊓ U₁)[ε])ˣ ⧸ cechCoboundaryUnits
        (mapRingHom (X.resHom (inf_le_left : U₀ ⊓ U₁ ≤ U₀)))
        (mapRingHom (X.resHom (inf_le_right : U₀ ⊓ U₁ ≤ U₁))) :=
  QuotientGroup.map _ _
    (Units.map (scaleRingHom (X.overAlgebraMap k (U₀ ⊓ U₁) a)).toMonoidHom)
    (cechCoboundaryUnits_le_comap_unitsScale _ _
      (resHom_overAlgebraMap_left k X U₀ U₁ a)
      (resHom_overAlgebraMap_right k X U₀ U₁ a))