No existing Mathlib/AJCR theorem descends a qcqs locally-finitely-presented scheme itself to a finite subextension with a base-change isomorphism. The strongest relevant theorem is only morphism descent through an inverse limit:

`AlgebraicGeometry.Scheme.exists_π_app_comp_eq_of_locallyOfFinitePresentation`
in [AffineTransitionLimit.lean:1177](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:1177):

```lean
(D : I ⥤ Scheme) -> (t : D ⟶ const S) -> (f : X ⟶ S) ->
(c : Cone D) -> IsLimit c ->
[IsCofiltered I] -> [LocallyOfFinitePresentation f] ->
[affine transitions] -> [qc stages] -> [qs stages] ->
(a : c.pt ⟶ X) ->
... -> ∃ i (g : D.obj i ⟶ X), c.π.app i ≫ g = a ∧ g ≫ f = t.app i
```

It descends one map from the limit into a fixed lfp target. Its equality companion is `AlgebraicGeometry.Scheme.exists_hom_hom_comp_eq_comp_of_locallyOfFiniteType` at [AffineTransitionLimit.lean:686](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:686). The finite-cover/open-spreading tools are:

- `AlgebraicGeometry.exists_isAffineOpen_preimage_eq`, [AffineTransitionLimit.lean:1058](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:1058)
- `AlgebraicGeometry.Scheme.exists_isOpenCover_and_isAffine`, [AffineTransitionLimit.lean:1078](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:1078)

None returns a stage scheme `X_L` or an isomorphism
`(baseChange L K_s).obj X_L ≅ X_{K_s}`.

Ring APIs are similarly map-level, but are the correct affine substrate:

- `RingHom.EssFiniteType.exists_eq_comp_ι_app_of_isColimit`, [FinitePresentation.lean:81](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/Algebra/Category/Ring/FinitePresentation.lean:81): a map from a finitely-presented algebra to a filtered colimit factors through a stage.
- `RingHom.EssFiniteType.exists_comp_map_eq_of_isColimit`, [FinitePresentation.lean:45](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/Algebra/Category/Ring/FinitePresentation.lean:45): equality of maps becomes true at a common stage.
- `Scheme.Hom.finitePresentation_appLE` / `finitePresentation_appTop`, [Morphisms/FinitePresentation.lean:45](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Morphisms/FinitePresentation.lean:45), give the finite-presentation certificates on affine pieces.

AJCR has the field system, not the scheme-descent theorem:

- `DatG0.FinSubext`, directedness, and `deltaIsColimit` establish `K_s = colim L`; [PicRepColimitResidual.lean:90](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepColimitResidual.lean:90), [PicRepColimitMountain.lean:83](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepColimitMountain.lean:83).
- `exists_finiteSubextension_point_of_point` is a successful application of the map theorem, but produces only an `L`-point of an lfp scheme ([Pic0FiniteSeparablePoint.lean:75](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteSeparablePoint.lean:75)).
- `Pic0PreservesFilteredBaseColimit` remains a defined residual Prop, not a proof ([PicRepColimitCompat.lean:136](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepColimitCompat.lean:136)).

A realistic next producer is therefore a new finite-stage-model theorem, not a direct application of `AffineTransitionLimit`:

```lean
∃ (L : DatG0.FinSubext k Ks) (J_L : Over (Spec (.of L.1))),
  LocallyOfFinitePresentation J_L.hom ∧
  QuasiCompact J_L.hom ∧ QuasiSeparatedSpace J_L.left ∧
  Nonempty ((baseChange L.1 Ks).obj J_L ≅ J_s)
```

where `J_s := (pic0_sepClosed_representableBy (C := C_Ks)).1`.

Proof skeleton:

1. Obtain finite affine cover `J_s.left.affineCover.finiteSubcover` from quasi-compactness. Its affine coordinate maps are finitely presented over `K_s` via `finitePresentation_appLE`.
2. For each finite affine ring presentation, spread its finitely many polynomial coefficients and relations to a common `L : FinSubext k K_s`; construct `A_i,L` explicitly and prove `K_s ⊗[L] A_i,L ≅ A_i`.
3. Use quasi-separatedness to choose finite affine refinements of every pairwise overlap. Spread the finite localization data and overlap isomorphisms. Enlarge `L` once more to force all inverse/cocycle equalities.
4. Build `Scheme.GlueData` at `L`, glue it, base-change that glue data, and prove chartwise that the resulting morphism to `J_s` is an isomorphism. Mathlib’s gluing implementation is available in `Mathlib/AlgebraicGeometry/Gluing.lean`, but no base-change/glue-descent wrapper exists.
5. Separately descend the representing natural isomorphism. Object descent alone does not yield `PicRepDatum`: its `rep` is natural over all tests. This is exactly where the unproved `Pic0PreservesFilteredBaseColimit` residual is needed, followed by a finite-stage naturality/equality argument.
6. Only after that can one normal-close `L/k` and invoke `pic0RepresentableBy_finiteGaloisDescent`; its `OrbitsInAffineOpen` input remains an independent missing gate.

So finite-stage object spread is substantial but well-scoped. It cannot by itself close DAT-G or the Jacobian headline.
