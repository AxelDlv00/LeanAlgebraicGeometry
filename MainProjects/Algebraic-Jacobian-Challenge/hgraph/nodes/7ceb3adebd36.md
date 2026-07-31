---
author: sync
content_type: theorem
created: '2026-08-01T04:12:00'
decl: AlgebraicGeometry.Scheme.DivFamily.twist_hasProperSupport
docstring: 'The D2 twist has proper support whenever the divisor structure sheaf does.

  This is unconditional in the twist module: it is the right-factor support

  transport, so no rational point, representability, or flatness hypothesis is

  introduced here.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.twist_hasProperSupport
type: lean
updated: '2026-08-01T04:12:00'
---
theorem twist_hasProperSupport (L : X.Modules) (x : DivFamily π T) :
    Modules.HasProperSupport (pullback.snd π T.hom) (x.twist L) := by
  dsimp [twist]
  exact Modules.hasProperSupport_tensorObj_right
    (pullback.snd π T.hom)
    ((Modules.pullback (pullback.fst π T.hom)).obj L) x.properSupport