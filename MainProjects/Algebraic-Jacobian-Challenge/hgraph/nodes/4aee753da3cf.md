---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible
docstring: '**The identity component is of finite type and geometrically irreducible.**


  Kleiman §5 Lem.~`lem:agps`~(3) conclusion (c): the open subgroup `G^0` of

  a `k`-group scheme `G` locally of finite type is itself

  locally-of-finite-type-plus-quasi-compact (i.e., of finite type) over `k`,

  and is geometrically irreducible. The proof reduces (after base change to

  `\bar k`) to picking a nonempty irreducible open subset `U ⊆ G^0`; the

  translates `zg⁻¹U` give an open cover of the closed points of `G^0` by

  irreducible neighbourhoods, extended to all points by Jacobson density, so

  with connectedness this gives irreducibility globally (EGA I 6.1.10). The

  image `α(W × W) ⊆ G^0` of an affine open `W ∋ e` under the group law is

  quasi-compact and contains all closed points, so finitely many affine opens

  cover `G^0` and `G^0` is quasi-compact.


  CLOSED (run 0009, T6): `LocallyOfFiniteType` as before (open immersion

  composed with `G.hom`); `QuasiCompact` via `identityComponent_compactSpace`

  (Kleiman''s product trick over the algebraic closure + Jacobson density +

  descent along the surjective base-change projection) together with the

  affine-target characterisation of quasi-compactness;

  `GeometricallyIrreducible` via `identityComponent_geometricallyIrreducible`

  (translation of an irreducible open through all closed points over the

  algebraic closure, EGA I 6.1.10, and descent along the surjective

  projection from the algebraic closure of each field extension).'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible
type: lean
updated: '2026-07-24T03:02:11'
---
theorem IdentityComponent.isFiniteTypeGeometricallyIrreducible
    {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [GrpObj G] [LocallyOfFiniteType G.hom] :
    LocallyOfFiniteType (IdentityComponent G).hom ∧
      QuasiCompact (IdentityComponent G).hom ∧
      GeometricallyIrreducible (IdentityComponent G).hom := by
  refine ⟨identityComponent_locallyOfFiniteType G, ?_,
    identityComponent_geometricallyIrreducible G⟩
  haveI h : CompactSpace (IdentityComponent G).left := identityComponent_compactSpace G
  exact HasAffineProperty.iff_of_isAffine.mpr h

end GroupScheme

/-! ## §2. The identity component of the Picard scheme

We specialise the abstract identity-component substrate to
`G = PicScheme C`, the Picard scheme of a smooth proper geometrically
integral curve `C/k` (from sibling `Picard/FGAPicRepresentability.lean`).

Blueprint reference: `def:pic_zero_subscheme` (Kleiman §5 opening + Prp.
`prp:pic0`). -/