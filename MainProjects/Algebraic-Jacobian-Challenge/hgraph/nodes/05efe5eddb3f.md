---
author: sync
content_type: class
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.Scheme.HasPicScheme
docstring: 'Typeclass asserting existence of a scheme over `Spec k` that represents

  the **unsheafified** relative Picard functor `picSharp C` and is separated and

  locally of finite type over `k`.


  **This is the legacy, conditional interface, not the headline target.** Its only

  producer is `picSchemeOfHasRationalPoint`, which needs `[HasRationalPoint C]`

  (from which it derives the comparison via

  `picEtComparison_isIso_of_hasRationalPoint`), and

  there is deliberately **no instance**: without a section the plain relative

  functor is not representable in general, so an unconditional instance would

  assert a false statement. The unconditional étale target is `HasPicSchemeEt`.


  Consumers that quantify over `[HasPicScheme C]` as a hypothesis remain

  kernel-clean and valid; what they prove are conditional statements until

  restated against `picEt`.


  Representability, local finiteness and separatedness are bundled into a single

  existential because Kleiman §4 Thm `th:main`(1) delivers them as one package:

  `Pic_{C/k}` is a separated scheme locally of finite type over `k`, a disjoint

  union of open quasi-projective `k`-subschemes. Bundling therefore adds no

  strength beyond representability, and lets the carriers

  `PicScheme.instPicSchemeLocallyOfFiniteType` and `PicScheme.isSeparated` be

  obtained by extraction.'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.HasPicScheme
type: lean
updated: '2026-07-29T20:27:12'
---
class HasPicScheme {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] : Prop where
  has_pic_scheme : ∃ (X : Over (Spec (.of k))),
    Nonempty ((PicScheme.picSharp C).RepresentableBy X) ∧
      LocallyOfFiniteType X.hom ∧ IsSeparated X.hom