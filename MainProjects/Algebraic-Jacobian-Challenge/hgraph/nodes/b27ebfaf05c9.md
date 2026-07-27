---
author: sync
content_type: class
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Adelic.HasFiniteMapToP1
docstring: "**The finite-map gate (node `N9`).**  A single-field `Prop` class asserting\
  \ the\nexistence of a finite `k`-morphism from the curve `C` to the projective line\n\
  `ℙ¹_k = ℙ(ULift (Fin 2); Spec k)`.\n\nIntroduced as a **gate** in the `HasPicScheme`\
  \ style: a *Kleiman-independent classical\nexistence statement* — any nonconstant\
  \ rational function `x ∈ k(C)` determines a finite\nmorphism `C ⟶ ℙ¹_k` of degree\
  \ `[k(C) : k(x)]`.\n\n**Update (2026-07-27): this class is no longer instance-free,\
  \ and the docstring above\nused to say otherwise.**  For an AJC curve the gate is\
  \ now *discharged*, by a chain that\nis present and sorry-free:\n\n* `hasFiniteMapToP1_of_existsNonconstantMapToP1`\
  \ (`FiniteMapToP1.lean`) — nonconstant\n  ⟹ finite, via Zariski's main theorem;\n\
  * `existsNonconstantMapToP1_of_existsNonconstantMapToProjInt` and\n  `existsNonconstantMapToProjInt_of_ajc`\
  \ (`NonconstantToP1.lean`) — the two-chart\n  construction of a nonconstant map,\
  \ for `[SmoothOfRelativeDimension 1] [IsProper]\n  [GeometricallyIntegral]`.\n\n\
  So the \"proved instance is later work\" claim is obsolete: under the AJC ambient\n\
  hypotheses this synthesises.  The class is kept because the keystone `N11` is stated\
  \ at\ngreater generality than the AJC curve, where it is still an honest hypothesis.\n\
  \nThe witness is packaged as a morphism in the over-category `Over (Spec k)`, so\
  \ it\nautomatically commutes with the structure maps: it is a genuine `k`-morphism."
file: AlgebraicJacobian/RiemannRoch/Adelic/P1BaseCase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.HasFiniteMapToP1
type: lean
updated: '2026-07-27T19:45:31'
---
class HasFiniteMapToP1 (C : Over (Spec (CommRingCat.of k))) : Prop where
  /-- There exists a finite `k`-morphism `C ⟶ ℙ¹_k`. -/
  nonempty_finite_map :
    ∃ π : C ⟶ Over.mk (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)) ↘
        Spec (CommRingCat.of k)),
      IsFinite π.left