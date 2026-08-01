---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.CechPic.ind
file: AlgebraicJacobian/Picard/Pic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CechPic.ind
type: lean
updated: '2026-08-01T09:44:15'
---
theorem ind {motive : X.CechPic → Prop}
    (mk : ∀ (𝒰 : X.PointedCover) (a : X.unitsH1 𝒰), motive (mk 𝒰 a)) (x : X.CechPic) :
    motive x :=
  Quotient.ind (fun p ↦ by obtain ⟨𝒰, a⟩ := p; exact mk 𝒰 a) x