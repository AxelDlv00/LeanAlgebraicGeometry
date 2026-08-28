Read-only audit complete. No files were changed and no standalone build was run.

The two minimal `WalkingMultispan.functorExt` obligations are:

```lean
S.f U V ≫ (gluingChartIso C P U).hom =
  (gluingOverlapIso C P U V).hom ≫ T.f U V
```

```lean
(S.t U V ≫ S.f V U) ≫ (gluingChartIso C P V).hom =
  (gluingOverlapIso C P U V).hom ≫ (T.t U V ≫ T.f V U)
```

For `T := pic0SepClosedAtlasGlueData C`, the target maps reduce to `pullback.fst U.1.1.ι V.1.1.ι` and `pullback.snd U.1.1.ι V.1.1.ι`.

Recommended proof order:

1. Keep `P.L`/`P.M` algebraicity instances local to the diagram theorem.
2. Derive the direct right final-ring naturality at `Sum.inl (Sum.inr (U,V))`.
3. Rewrite it locally with `scalarExtension_transition_comp_restrictionLeft_eq_right`.
4. Feed that equality directly into `affineBaseChangeIso_trans_naturality`, using raw tensor carriers rather than exported dependent aliases.
5. Relate the source legs to affine base-change maps using `pullback.hom_ext`:
   - left: `nestedPullbackFlatteningIso_hom_comp_fst_comp_a` and `_comp_snd`;
   - right: `_comp_fst_comp_b` and `_comp_snd`.
6. Close the exact-open side with `Scheme.isoSpec_inv_naturality` and `IsPullback.isoPullback_hom_fst`/`snd`.

A projection-only proof cannot eliminate right restriction naturality: the current `gluingOverlapIso` is constructed from the left restriction structure, so its second projection still requires the rooted scalar-extension equation locally.
