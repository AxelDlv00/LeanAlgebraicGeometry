---
author: sync
content_type: lemma
created: '2026-08-01T09:44:16'
decl: AlgebraicGeometry.pic0DescentPullback_p₁
file: AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0DescentPullback_p₁
type: lean
updated: '2026-08-01T09:44:16'
---
lemma pic0DescentPullback_p₁ (i j : Unit) :
    (pic0DescentPullback (k := k) (L := L) i j).p₁ =
      tensorOverlapInl (k := k) (L := L) := rfl

@[simp]