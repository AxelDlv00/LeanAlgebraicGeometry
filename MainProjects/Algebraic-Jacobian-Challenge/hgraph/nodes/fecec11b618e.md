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

  removed in favour of this single uniform witness.


  The construction below is **wired to the Picard development**: the underlying scheme

  is `Scheme.Pic0Scheme C`, and four of the six witness fields are theorems of

  `Picard/Pic0AbelianVariety.lean` applied directly. This definition carries no `sorry`

  of its own, but that is a statement about this file, not a completeness claim: two
  of

  those four upstream theorems (`Pic0.smooth`, `Pic0.proper`) are `sorry`-bodied,
  so

  the witness depends on five open obligations — those two, plus the three leaves

  `hasRationalPoint_of_curve`, `smoothOfRelativeDimension_genus_pic0` and

  `isAlbanese_pic0` above. The `GeometricallyIntegral` hypothesis of the Picard

  development is *not* among them: it is synthesised from the challenge hypotheses

  through `Smooth.geometricallyIntegral` (see `geometricallyIntegral_of_curve`).'
file: AlgebraicJacobian/Jacobian.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picardJacobianWitness
type: lean
updated: '2026-07-28T02:46:09'
---
noncomputable def picardJacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C := by
  haveI := hasRationalPoint_of_curve C
  exact
    { J := Scheme.Pic0Scheme C
      grpObj := (Scheme.Pic0.grpObj C).some
      proper := Scheme.Pic0.proper C
      smooth := Scheme.Pic0.smooth C
      geomIrred := Scheme.Pic0.geometricallyIrreducible C
      smoothGenus := smoothOfRelativeDimension_genus_pic0 C
      isAlbaneseFor := fun P => isAlbanese_pic0 C _ _ _ _ P }

/-- **The witness over an algebraically closed field, free of the inconsistent leaf.**

Identical to `picardJacobianWitness` except that the rational point is supplied by the