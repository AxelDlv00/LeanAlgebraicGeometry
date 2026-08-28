Done. All checks pass. Here is the final report.

## Result: PROVED

Created one new file, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneAbelInverse.lean`. No existing file was edited; nothing was committed.

### The reduction is genuine and closes
`∀ E : PicRankOneEvaluationDivisorData pi, E.AbelInverse` reduces to `rankOneDivisorUniqueness` exactly as hypothesized: the divisor-preimage locus element over an arbitrary scheme `X` is a `Σ`-extension element carrying a widened *vehicle* section `divFamZarAff C (genus C) (Over.mk a)`, which is a compatible family of affine-test data `DivFamZarAff C Γ(·,U) (genus C)` over affine opens, and equality of two sections is checked affine-open-locally (`divFamZarAff.ext`). Naturality (`picRankOneOpen_map_mem` along `Over.fromSpecAffine T U`) transports the rank-one membership to each affine open, where `rankOneDivisorUniqueness` applies.

### Declarations landed (all `AlgebraicGeometry.…`)
- `divFamZarAffAffineEquiv_map_fromSpecAffine` — vehicle collapse: restrict-along-`fromSpecAffine`-then-collapse recovers `s.1 U` (the one missing lemma; assembled from `mapVal_eq_mapAlgHom` + `fromSpecAffine_ΓTop_comp_appLEAlgHom`, both already in-tree).
- `divFamZarAff_eq_of_rankOne` — arbitrary-test uniqueness of the widened Abel map on the rank-one locus.
- `rankOneAbelRepresented_app_injective`, `rankOneAbelSigma_app_injective` — slicewise/componentwise injectivity of the restricted Abel map (`Σ`-extension preserves it).
- **`PicRankOneEvaluationDivisorData.abelInverse_of_uniqueness (E) : E.AbelInverse`** — the requested main theorem, via right-inverse `E.divisor_abel` + injectivity cancellation.
- **`PicRankOneEvaluationDivisorData.rankOneAbelIso (E) : rankOneDivisorLocus ≅ rankOneLocus`** — the packaged iso `E.evaluationIso pi (E.abelInverse_of_uniqueness pi)`.

`rankOneDivisorUniqueness` is used directly (not taken as a hypothesis).

### Verification
- `mcp__lean-lsp__lean_diagnostic_messages`: zero errors, zero warnings.
- Faithful kernel check `lake env lean AlgebraicJacobian/Picard/Pic0RankOneAbelInverse.lean`: **exit 0** (8.9 s).
- `lean_verify` on both `abelInverse_of_uniqueness` and `rankOneAbelIso`: axioms `{propext, Classical.choice, Quot.sound}` only — **no `sorryAx`**. (The one `lean_verify` "local instance" flag at line 55 is the expected `attribute [local instance] Over.sectionsAlgebra …`.)

All lines ≤ 100 chars; house header, `set_option autoImplicit false`, `backward.isDefEq.respectTransparency false`, `maxSynthPendingDepth 3` in place. `GeometricallyReduced C.hom` (needed by `abelDivAff'`) is supplied automatically by the smoothness instance.
