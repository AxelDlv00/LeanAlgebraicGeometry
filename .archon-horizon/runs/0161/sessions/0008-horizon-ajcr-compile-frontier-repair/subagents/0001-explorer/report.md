Read-only findings for `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean`:

- `overlapBaseChangeIso_hom_comp_isoSpec_inv` is at lines 297–308. Its exact type is
  ```lean
  (overlapBaseChangeIso C P U V).hom ≫
      (pic0FiniteStageAffineOverlap C U V).1.ι =
    (overlapRingBaseChangeIso C P U V).hom ≫
      ((pic0FiniteStageAffineOverlap C U V).2.isoSpec.inv ≫
        (pic0FiniteStageAffineOverlap C U V).1.ι)
  ```
  and the proof is the one-line dependent reduction:
  ```lean
  simp only [overlapBaseChangeIso, overlapRingBaseChangeIso,
    overlapFinalBaseChangeEquiv, affineBaseChangeIso, Iso.trans_hom,
    Iso.symm_hom, Category.assoc]
  ```

- `overlapBaseChangeIso_hom_ι` is at lines 314–329. Its target replaces the inner `isoSpec.inv ≫ ι` with `.fromSpec`. The current two-step `calc` split is the smallest faithful decomposition:
  1. invoke `overlapBaseChangeIso_hom_comp_isoSpec_inv`;
  2. use `congrArg (fun q => overlapRingBaseChangeIso...hom ≫ q)` with `isoSpec_inv_ι`.

- The direct analogue is `chartBaseChangeIso_hom_ι` at lines 278–291. The overlap proof should retain the same structure; collapsing it into a single `simpa` risks re-triggering dependent instance elaboration.

- Immediate definitions:
  - `overlapBaseChangeIso`: `Pic0FiniteStageGluingBaseChange.lean:66–85`; nested `pullbackSymmetry`, `pullbackSpecIso`, `Spec.mapIso` of `overlapFinalBaseChangeEquiv`, then `(affineOverlap).2.isoSpec.symm`.
  - `overlapRingBaseChangeIso`: `Pic0FiniteStageRestrictionBaseChange.lean:165–181`; `affineBaseChangeIso` followed by `Spec.mapIso` of `overlapFinalBaseChangeEquiv.symm`.
  - `overlapFinalBaseChangeEquiv`: `Pic0FiniteStageRestrictionBaseChange.lean:99–108`; its dependent target is `Pic0FiniteStageRing C (Sum.inr (U,V))`.

- Main elaboration hotspot is the distinct dependent `CommRing`/`CommSemiring` witnesses for tensor/scalar-extended rings versus indexed `Pic0FiniteStageRing` aliases. `chartBaseChangeIso` explicitly pins many local instances (`ChartBaseChange.lean:67–121`), while `overlapBaseChangeIso` relies on inference. Avoid unfolding these globally; keep the helper boundary.

- `overlapBaseChangeIso_hom_atlas_f_ι` at lines 354–368 consumes `overlapBaseChangeIso_hom_ι` directly, so any failure there is likely inherited from the overlap helper rather than the atlas projection.

The hgraph cache records both helper declarations as `lean_ok`, but the `.olean` timestamp is older than the current source, so it is only historical evidence, not a current verification.
