---
author: sync
content_type: definition
created: '2026-08-01T13:18:07'
decl: AlgebraicGeometry.pic0GaloisRestrictTest
docstring: Restriction of an `L`-test to a `k`-test.
file: AlgebraicJacobian/Picard/Pic0GaloisAction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0GaloisRestrictTest
type: lean
updated: '2026-08-01T13:18:07'
---
noncomputable abbrev pic0GaloisRestrictTest :
    Over (Spec (CommRingCat.of L)) ⥤ Over (Spec (CommRingCat.of k)) :=
  Over.map (pic0GaloisBaseMap (k := k) (L := L))