---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.picardJacobianWitness
docstring: 'The Albanese witness for a smooth proper geometrically irreducible curve
  `C`,

  constructed **uniformly in the genus** as the identity component `Pic⁰_{C/k}` of
  the

  Picard scheme of `C`.


  By the FGA route (`AlgebraicJacobian.Picard.*`), `Pic⁰_{C/k}` is representable

  (`Scheme.PicScheme.representable`) and is an abelian variety of dimension `genus
  C`:

  its tangent space at the identity is `H¹(C, 𝒪_C)` (`Scheme.Pic0.tangentSpaceIso`),

  giving smoothness of relative dimension `genus C` (`Scheme.Pic0.smooth`), properness

  (`Scheme.Pic0.proper`), and geometric irreducibility

  (`Scheme.Pic0.geometricallyIrreducible`); the Albanese universal property is the

  Abel–Jacobi factorisation of `AlgebraicJacobian.Albanese.AlbaneseUP`.


  The genus-`0` case is **not** special and needs no separate construction: when

  `genus C = 0` the tangent space is `0`-dimensional, so `Pic⁰_{C/k} = Spec k`

  automatically, and the universal property degenerates to the (then trivial) statement

  that every pointed morphism `C ⟶ A` into an abelian variety is constant. The former

  `genusZeroWitness` / `positiveGenusWitness` genus split — together with its bespoke

  rigidity / cotangent-vanishing / Frobenius / `ℙ¹`-identification machinery — has
  been

  removed in favour of this single uniform witness.'
file: AlgebraicJacobian/Jacobian.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.picardJacobianWitness
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def picardJacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C :=
  sorry