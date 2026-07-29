---
author: sync
content_type: instance
created: '2026-07-16T21:33:28'
decl: search
file: AlgebraicJacobian/Picard/WitnessAway.lean
generated: lean
lean_status: lean_ok
stale: true
title: search
type: lean
updated: '2026-07-29T11:07:21'
---
instance search finds it; since `(overSpec k R).left = Spec (.of R)` holds by `rfl` the
re-keyed forms apply on the nose).  The bridge between the scheme-side base rings
`Γ(Spec R, ⊤)` and the algebra-side rings `R` is crossed exactly twice, abstractly: by
`isLocalization_away_sections` (transport of the canonical localization along `ΓSpecIso`
via `IsLocalization.of_ringEquiv_left`) and by the elementwise naturality lemmas
`ΓSpecIso_hom_appTop` / `ΓSpecIso_inv_appTop`.  The `A`-algebra structures on the
section rings are the composites through the canonical `R`-structures
(`algebraA_sections`); all of these are `local instance`s — consumers reactivate them
with `attribute [local instance]`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite TopologicalSpace

open scoped TensorProduct

namespace AlgebraicGeometry

/-! ## Section rings on basic opens as localizations of the ring itself -/