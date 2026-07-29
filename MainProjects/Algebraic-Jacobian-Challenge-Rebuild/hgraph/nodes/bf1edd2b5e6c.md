---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.PointedCover.pullback_mono
file: AlgebraicJacobian/Picard/UnitsCocycle.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.PointedCover.pullback_mono
type: lean
updated: '2026-07-29T15:26:32'
---
lemma pullback_mono (f : X ⟶ Y) {𝒰 𝒱 : Y.PointedCover} (h : 𝒱 ≤ 𝒰) :
    𝒱.pullback f ≤ 𝒰.pullback f :=
  fun x ↦ ((TopologicalSpace.Opens.map f.base).map (homOfLE (h (f.base x)))).le

end PointedCover

/-! ## Unit cocycles on a pointed cover and their restriction -/