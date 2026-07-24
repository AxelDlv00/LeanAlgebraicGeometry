---
author: sync
content_type: class
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.Scheme.HasPicScheme
docstring: 'Typeclass asserting existence of a scheme over `Spec k` that represents

  the relative Picard functor `picSharp C` **and is locally of finite type over

  `k`**. The single sorry-carrying site for `PicScheme` is the `⟨sorry⟩`

  instance below, **conditional on `[HasRationalPoint C]`** — without a section

  the plain relative functor is not representable in general, so an

  unconditional instance would assert a false statement. Consumers that

  quantify over `[HasPicScheme C]` as a hypothesis remain kernel-clean.


  Run 0010 strengthening: the existential also carries

  `LocallyOfFiniteType X.hom`. This is truth-preserving because Kleiman §4 Thm

  `th:main`(1) makes local finiteness part of the SAME existence package as

  representability (`Pic_{C/k}` is a disjoint union of open quasi-projective

  `k`-subschemes), so the strengthened statement is exactly as true as the old

  one; it lets the local-finiteness carrier `instPicSchemeLocallyOfFiniteType`

  be PROVED by extraction instead of carrying its own sorry.


  Iter-current strengthening: the existential additionally carries

  `IsSeparated X.hom`. Kleiman §4 Thm `th:main` delivers `Pic_{C/k}` as a

  *separated* scheme locally of finite type over `k`, so separatedness sits in

  the very same existence package; bundling it here (as the third conjunct)

  lets the global `PicScheme.isSeparated` instance — and the sibling `Pic0`

  `picScheme_isSeparated` — be PROVED by extraction, exactly as with local

  finiteness, rather than carrying a fresh sorry.'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.HasPicScheme
type: lean
updated: '2026-07-24T17:02:56'
---
class HasPicScheme {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] : Prop where
  has_pic_scheme : ∃ (X : Over (Spec (.of k))),
    Nonempty ((PicScheme.picSharp C).RepresentableBy X) ∧
      LocallyOfFiniteType X.hom ∧ IsSeparated X.hom