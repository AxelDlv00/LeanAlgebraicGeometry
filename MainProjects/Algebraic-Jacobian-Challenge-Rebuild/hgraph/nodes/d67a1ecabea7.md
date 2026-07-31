---
author: sync
content_type: theorem
created: '2026-07-17T10:31:28'
decl: AlgebraicGeometry.Over.isPullback_crossBase
docstring: "**The cross-base pasted square** (general form): for `X : Over S` and\
  \ `T : Over S'`, the\nsquare\n\n```\n((pullback f).obj X ⊗ T).left --(fst).left\
  \ ≫ pullback.fst--> X.left\n        |                                          \
  \            |\n    (snd).left                                               X.hom\n\
  \        ↓                                                      ↓\n      T.left\
  \ -----------------T.hom ≫ f----------------------> S\n```\n\nis a pullback: the\
  \ horizontal paste of the slice square\n`Over.isPullback_left ((Over.pullback f).obj\
  \ X) T` (over `S'`) with the defining base-change\nsquare of `(Over.pullback f).obj\
  \ X` (whose second projection *is* the structure morphism of\nthe pulled-back object)."
file: AlgebraicJacobian/Curve/CrossBaseSquare.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.isPullback_crossBase
type: lean
updated: '2026-07-31T20:15:18'
---
theorem Over.isPullback_crossBase (X : Over S) (T : Over S') :
    IsPullback ((fst ((Over.pullback f).obj X) T).left ≫ pullback.fst X.hom f)
      ((snd ((Over.pullback f).obj X) T).left) X.hom ((Over.map f).obj T).hom :=
  (Over.isPullback_left ((Over.pullback f).obj X) T).paste_horiz
    (IsPullback.of_hasPullback X.hom f)