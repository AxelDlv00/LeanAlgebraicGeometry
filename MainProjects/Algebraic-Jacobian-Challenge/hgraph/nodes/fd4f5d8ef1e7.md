---
author: sync
content_type: instance
created: '2026-07-28T15:48:27'
decl: AlgebraicGeometry.Scheme.PicSharp.nonempty_overDualNumber_left
file: AlgebraicJacobian/Picard/OnePointRelPicCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicSharp.nonempty_overDualNumber_left
type: lean
updated: '2026-07-28T15:48:27'
---
instance nonempty_overDualNumber_left (k : Type u) [Field k] :
    Nonempty (overDualNumber k).left :=
  inferInstanceAs (Nonempty (PrimeSpectrum (DualNumber k)))