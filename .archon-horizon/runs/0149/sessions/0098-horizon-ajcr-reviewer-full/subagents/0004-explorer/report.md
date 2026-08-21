Audit complete, read-only. No files or Horizon state were modified.

The existing tensor-stage datum theorem is sufficient to descend an honest relative Picard class:
```lean
q : relPic C (overSpec F (K ⊗[F] B))
```
to some
```lean
qM : relPic C (overSpec F (M.1 ⊗[F] B))
```
with
```lean
relPicAlgMap C
  (Algebra.TensorProduct.map M.1.val (AlgHom.id F B)) qM = q.
```

This exact theorem and proof compiled successfully through `lean_run_code` with no diagnostics. It uses:

- [`Pic0FiniteStageDatum.lean:31`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageDatum.lean:31), `BasicOpenCocycleDatum.exists_finSubext_tensorStage`
- [`GluedSheafExtraction.lean:301`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/GluedSheafExtraction.lean:301), `exists_cechPicClass_eq`
- [`GluedSheafClass.lean:358`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/GluedSheafClass.lean:358), `cechPicClass_baseChange`
- `relPicMk_surjective` and `relPicAlgMap_mk`

Consequently, an honest `PicEtAff.unit` class also descends: take `xM := PicEtAff.unit C _ qM` and close with `PicEtAff.mapAlg_unit`. The base-changed-curve version compiles using `baseFieldShuffle`, its inverse, and the same equality.

This does not prove descent of arbitrary `PicEtAff` chart classes. [`PicEtAffFiniteStage.lean:34`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicEtAffFiniteStage.lean:34) only descends covers over a field and deliberately leaves the descent class over the full field. Ring-level honesty remains absent, as documented in [`EffectivityRingClose.lean:31`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/EffectivityRingClose.lean:31).

The first missing general-purpose lemma is therefore tensor-chart descent of an étale cover:
```lean
E : Algebra.EtaleCover (K ⊗[F] B)
```
to an `E_M : Algebra.EtaleCover (M ⊗[F] B)` with an algebra equivalence after base change. `Algebra.Etale.exists_subalgebra_fg` and `DatG0.exists_finSubext_fg_subalgebra_tensorProduct_factor` provide its algebraic pieces; faithful-flat reflection is needed for Spec-surjectivity. Descending the representative’s double-face equality would remain a second layer. For the universal chart, proving its class honest is the shorter route.
