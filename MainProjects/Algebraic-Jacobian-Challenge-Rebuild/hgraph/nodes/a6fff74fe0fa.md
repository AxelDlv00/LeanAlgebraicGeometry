---
author: sync
content_type: theorem
created: '2026-07-20T20:32:02'
decl: AlgebraicGeometry.DivRepAffinePullback.equiv_apply
file: AlgebraicJacobian/Picard/DivRepAffKit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivRepAffinePullback.equiv_apply
type: lean
updated: '2026-07-30T15:28:02'
---
theorem equiv_apply
    (D : DivRepAffinePullback hpi g hO hchi r1 r2 b1 b2)
    (S : Type u) [CommRing S] [Algebra k S] (v : overSpec k S ⟶ DivOver) :
    equiv (hpi := hpi) (g := g) (hO := hO) (hchi := hchi) (r1 := r1) (r2 := r2)
        (b1 := b1) (b2 := b2) D S v = D.pull S v :=
  rfl

@[simp]