---
author: sync
content_type: lemma
created: '2026-07-28T12:23:40'
decl: AlgebraicGeometry.Scheme.one_le_coheight_of_ne_genericPoint
docstring: 'On an irreducible sober scheme, every point other than the generic point

  has coheight at least one.'
file: AlgebraicJacobian/Albanese/Milne33TransportLocal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.one_le_coheight_of_ne_genericPoint
type: lean
updated: '2026-07-31T09:45:57'
---
lemma Scheme.one_le_coheight_of_ne_genericPoint {Y : Scheme.{u}}
    [IrreducibleSpace ↥Y] {z : ↥Y} (hz : z ≠ genericPoint ↥Y) :
    1 ≤ Order.coheight z := by
  have h := Scheme.coheight_add_one_le_of_specializes
    (genericPoint_specializes z) (fun h' => hz h'.symm)
  exact le_trans le_add_self h

end AlgebraicGeometry

/-! ## §2. The Krull codimension count -/

namespace RingTheory.CohenMacaulay

variable {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]

omit [IsNoetherianRing R] in