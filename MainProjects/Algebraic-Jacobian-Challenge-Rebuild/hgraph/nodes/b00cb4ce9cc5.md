---
author: sync
content_type: definition
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.Scheme.RationalMap.precomp
docstring: '**Precomposition of a rational map with an open morphism.** For `f : X
  ⤏ Y`

  and a morphism `p : W ⟶ X` whose underlying map is open, `f.precomp p hp : W ⤏ Y`

  is the composite `f ∘ p`, obtained by pulling any representative partial map back

  along `p`.'
file: AlgebraicJacobian/Albanese/RationalMapPrecomp.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.RationalMap.precomp
type: lean
updated: '2026-07-17T08:41:24'
---
noncomputable def RationalMap.precomp (f : X ⤏ Y) (p : W ⟶ X) (hp : IsOpenMap p.base) :
    W ⤏ Y :=
  Quotient.map (PartialMap.precomp · p hp) (fun _ _ ↦ PartialMap.precomp_equiv p hp) f

@[simp]