---
author: sync
content_type: class
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Adelic.HasFiniteMapToP1
docstring: '**The finite-map gate (node `N9`).**  A single-field `Prop` class asserting
  the

  existence of a finite `k`-morphism from the curve `C` to the projective line

  `ℙ¹_k = ℙ(ULift (Fin 2); Spec k)`.


  This is a **gate** in the `HasPicScheme` style: it is a *Kleiman-independent

  classical existence statement* — any nonconstant rational function `x ∈ k(C)`

  determines a finite morphism `C ⟶ ℙ¹_k` of degree `[k(C) : k(x)]`.  The class

  carries **no instance**; the future keystone (`N11`, the reduction of `H¹`

  finiteness of `C` to the ℙ¹ base case above) consumes it as a hypothesis, and the

  proved instance (transcendence degree one of `k(C)/k` for a geometrically integral

  curve) is later work.


  The witness is packaged as a morphism in the over-category `Over (Spec k)`, so it

  automatically commutes with the structure maps: it is a genuine `k`-morphism.'
file: AlgebraicJacobian/RiemannRoch/Adelic/P1BaseCase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.HasFiniteMapToP1
type: lean
updated: '2026-07-24T17:02:57'
---
class HasFiniteMapToP1 (C : Over (Spec (CommRingCat.of k))) : Prop where
  /-- There exists a finite `k`-morphism `C ⟶ ℙ¹_k`. -/
  nonempty_finite_map :
    ∃ π : C ⟶ Over.mk (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)) ↘
        Spec (CommRingCat.of k)),
      IsFinite π.left