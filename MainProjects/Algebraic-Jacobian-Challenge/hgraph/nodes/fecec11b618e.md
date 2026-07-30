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


  **No hypothesis on `C(k)`.** The binders are exactly the three challenge hypotheses,
  which

  is the owner decision of 2026-07-28 (protection I-0491) and the full strength the
  challenge

  asks for. This is *not* a specialisation of

  `picardJacobianWitnessOfHasRationalPoint`: it is wired to the **étale** Picard development,

  with underlying scheme `Scheme.Pic0SchemeEt C` — the identity component of the scheme

  representing the étale-sheafified relative Picard functor (`Picard/Pic0Et.lean`,

  `Picard/FGAPicRepresentability.lean`). Sheafifying is what removes the rational
  point:

  over an arbitrary field, representability of the unsheafified functor is not available
  —

  see the file header for the precise statement, which is *unproved with a refutation
  route

  mapped out* rather than "false", and which does **not** rest on a Zariski-sheaf
  claim

  (`review-ajc`, 2026-07-30; this sentence carried both of the withdrawn versions).


  Four of the six witness fields come from theorems that are proved **unconditionally**
  and

  measure axiom-clean (`Pic0Et.grpObj`, `Pic0Et.geometricallyIrreducible`, and through
  them

  `Pic0Et.locallyOfFiniteType` / `Pic0Et.isSeparated`). This definition carries no
  `sorry` of

  its own, but that is a statement about this file, not a completeness claim: it depends
  on

  the five obligations enumerated in the file header —

  `Scheme.fgaPicardRepresentability`, `Scheme.Pic0Et.geometricallyReduced`,

  `Scheme.Pic0Et.universallyClosed`, `smoothOfRelativeDimension_genus_pic0Et` and

  `isAlbanese_pic0Et` — every one of which is a **true statement awaiting a proof**.


  **These five are not five independent distances, and counting them as such

  overstates the remaining work by one while understating what leaf B buys**

  (measured by `ajc-p3`, independently by `ajc-p2`, relayed here by `review-ajc`

  because both lanes declined to edit a third lane''s file mid-round; `I-1044`).

  `SmoothOfRelativeDimension.geometricallyReduced` turns obligation 4

  (`smoothOfRelativeDimension_genus_pic0Et`) directly into obligation 2

  (`Pic0Et.geometricallyReduced`), and composed with

  `Pic0Et.smooth_of_geometricallyReduced` it also gives `Pic0Et.smooth`. So the

  arrow runs 4 ⟹ 2: no work on 2 is wasted, but closing leaf B closes two of the

  five at once. Still genuinely independent: `Pic0Et.universallyClosed`, whose

  residue is `IsReduced`-free and which nothing in the smoothness cone touches. The

  `GeometricallyIntegral` hypothesis of the Picard development is *not* among them:
  it is

  synthesised from the challenge hypotheses through `Smooth.geometricallyIntegral`
  (see

  `geometricallyIntegral_of_curve`).'
file: AlgebraicJacobian/Jacobian.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picardJacobianWitness
type: lean
updated: '2026-07-30T08:42:03'
---
noncomputable def picardJacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C where
  J := Scheme.Pic0SchemeEt C
  grpObj := (Scheme.Pic0Et.grpObj C).some
  proper := Scheme.Pic0Et.proper C
  smooth := Scheme.Pic0Et.smooth C
  geomIrred := Scheme.Pic0Et.geometricallyIrreducible C
  smoothGenus := smoothOfRelativeDimension_genus_pic0Et C
  isAlbaneseFor := fun P => isAlbanese_pic0Et C _ _ _ _ P