---
author: sync
content_type: class
created: '2026-07-24T17:02:47'
decl: '`M_V`'
file: AlgebraicJacobian/Picard/EffectivityPieceClass.lean
generated: lean
lean_status: lean_ok
title: '`M_V`'
type: lean
updated: '2026-07-24T17:02:47'
---
class `M_V` are in `AlgebraicJacobian.Picard.EffectivityPieceDescent`.

## Kernel discipline

The trimmed Amitsur overlap is an opaque `def` with named `≤`-lemmas
(`Over.pieceAmitsurOpen`), and the three coface expansions of the glued unit are their
own (private) declarations in insertion normal form — the E1 lessons applied to the
piece towers.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite
  TopologicalSpace CategoryTheory.PresheafOfGroups

open scoped TensorProduct