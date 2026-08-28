## 1. Producers of `(divFunctor C _ _).RepresentableBy _`

Exhaustive (case-insensitive sweep of `divfunctor.*representableby` over all 799 `.lean` files; 5 declarations, all in `AlgebraicJacobian/Picard/`, all rooted in `AlgebraicJacobian.lean`). All five share the same ambient section context, transcribed once below.

**Common ambient context** (identical in `DivRepKit.lean`, `DivRepGlobalClassify.lean`, `DivRepAffPullClause.lean`, `DivRepChartRange.lean`):
```
{k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))} {pi : C.left ⟶ P1 k} [IsFinite pi]
[SmoothOfRelativeDimension 1 (C.left ↘ Spec …)] [IsIntegral C.left]
[LocallyOfFiniteType (C.left ↘ Spec …)] [QuasiCompact (C.left ↘ Spec …)] [IsDominant pi]
[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]   -- (†)
[Module.Finite k ((moduleKSheaf k C.left).HModule 0)] [Module.Finite k (… HModule 1)]
(hpi : pi ≫ P1.structureMap k = C.left ↘ Spec …) (g r1 r2 : ℕ)
(b1 : Module.Basis (Fin r1) k ↥(divisorSections k (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
(b2 : Module.Basis (Fin r2) k ↥(divisorSections k ((windowM_choice + windowS_choice) • fiberWeilDivisor pi) ⊤))
```
Target is always `DivOver := divSchemeOver k (windowS_choice …) (windowM_choice …) g r1 r2 b1 (b2.map (windowShiftEquiv hpi g).symm)`.

| # | file:line | name | hypotheses beyond ambient |
|---|---|---|---|
| P1 | `Picard/DivRepKit.lean:113` | `DivRepGlobalData.representableBy` | `(D : DivRepGlobalData hpi g r1 r2 b1 b2)` — **nothing else**. Verified by hover: no `hO`, no `hchi`, and **no (†)** (`IsProper`/`GeometricallyIrreducible` absent from this file's context). |
| P2 | `Picard/DivRepGlobalClassify.lean:306` | `DivRepAffinePullback.representableBy` | `(hO : (moduleKSheaf k C.left).h0 = 1)`, `(hchi : (moduleKSheaf k C.left).chi = 1 - ↑g)`, `(D : DivRepAffinePullback hpi g hO hchi r1 r2 b1 b2)` |
| P3 | `Picard/DivRepAffPullClause.lean:482` | `divFunctor_representableBy_of_chartClause` | `hO`, `hchi`, `(U : ∀ i j, DivFamZar C (ChartRing i j) pi g)`, `(hU : DivRepChartFamily.IsChartClause hpi g r1 r2 b1 b2 U)` |
| P4 | `Picard/DivRepAffPullClause.lean:502` | `divFunctor_representableBy_of_id` | `hO`, `hchi`, `U`, `(hid : ∀ i j, IsDivRepClassify hpi g r1 r2 b1 b2 (U i j) (ChartMap i j))` |
| P5 | `Picard/DivRepChartRange.lean:220` | `divFunctor_representableBy_of_chartRange` | `hO`, `hchi`, `(hrange : ∀ i j, ∃ F : DivFamZar C (ChartRing i j) pi g, (divRepClassifyZar hpi g hO hchi r1 r2 b1 b2 (ChartRing i j) F).left = ChartMap i j)` |

`DivRepAffPullClause.lean:486` is P3's conclusion line and `:507/:508` are P4's conclusion+body — not separate declarations. `DivRepAffPullClause.lean:461` `divRepAffinePullback_ofChartClause` concludes `DivRepAffinePullback`, not `RepresentableBy`. **No sixth producer exists** anywhere in the tree.

Chain shape: P5 → P3 → P2 → P1, and P4 → P3. All five bottom out in the same place.

## 2. Producers of `IsChartUniv …`

`IsChartUniv` is defined at `Picard/Pic0ChartPair.lean:173` as `IsOpenImmersion.presheaf (restrictChart (abelSigmaChart C π n rep m Z hdeg) V)`. Ambient for all of these: `{k}[Field k]{C}`, `{π : C.left ⟶ P1 k}[IsAffineHom π]{n : ℕ}`, `[SmoothOfRelativeDimension 1 C.hom][IsProper C.hom][GeometricallyIrreducible C.hom]`, plus `(rep : (divFunctor C π n).RepresentableBy D) (m : ℕ) (Z) (hdeg : deg k Z = m * classDeg k (thetaCechClass C) - n)`.

| file:line | name | extra hypotheses | V |
|---|---|---|---|
| `Pic0ChartPair.lean:184` | `isChartUniv_of_unrestricted` | `(V : D.left.Opens)`, `(h : IsOpenImmersion.presheaf (abelSigmaChart …))` — the **unrestricted** certificate | arbitrary V |
| `Pic0ChartUnivReduce.lean:184` | `isChartUniv_of_isChartLocusFibre` | `(h : IsChartLocusFibre C π n rep m Z hdeg)`, `(V : D.left.Opens)` | arbitrary V |
| `Pic0ChartRestrictedFibre.lean:158` | `isChartUniv_of_restrictedChartFibre` | `(V : D.left.Opens)`, `(h : RestrictedChartFibre C π n rep m Z hdeg V)` | arbitrary V |
| `Pic0ChartVMonotone.lean:148` | `isChartUniv_antitone` | `{U V}`, `(e : U ≤ V)`, `(h : IsChartUniv … V)` | conclusion at U ≤ V |
| `Pic0ChartRestrictedFibreSat.lean:223` | `isChartUniv_bot` | **none** | **pinned `V = ⊥`** |

`Pic0ChartAtlasParamFree.lean:103` `isOpenImmersion_presheaf_mixedParamChart` and `Pic0ChartRestrictedFibre.lean:235` `mixedParamHf` conclude `IsOpenImmersion.presheaf (mixedParamChart …)` — the per-index unfolding of the same thing; the first is literally `huniv i` (`:113`), the second is `isChartUniv_of_restrictedChartFibre` applied per index.

Only `isChartUniv_bot` is hypothesis-free, and it is at `V = ⊥`. `Pic0ChartRestrictedFibreSat.lean:207` (`isOpenImmersion_presheaf_restrictChart_bot`) records that the `⊥` witness works for *any* morphism into the Σ-sheaf, so it carries no information about the Abel chart. And `Pic0ChartVMonotone.lean:249` `isLocallySurjective_of_bot` shows the coverage binder at `⊥` implies the unrestricted one, so `⊥` is not an escape.

## 3. Producers of `Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc …)`

No `instance` in the tree provides it — every occurrence in a consumer is an unproduced `[…]` binder or a `letI`. Theorem-level producers (ambient: `{k}[Field k]{C}`, `[SmoothOfRelativeDimension 1 C.hom][IsProper C.hom][GeometricallyIrreducible C.hom]`):

| file:line | name | hypotheses |
|---|---|---|
| `Pic0ChartLocalSurjectivity.lean:104` | `isLocallySurjective_sigmaDesc` | `(f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)`, `(h : ChartsCoverLocally C f)` |
| `Pic0ChartCoveragePointwise.lean:147` | `isLocallySurjective_sigmaDesc_of_pointwise` | pointwise datum: `∀ T s t, ∃ W (_ : t ∈ W) i (x : ↑W ⟶ X i), (f i).app _ x = map W.ι.op s` |
| `Pic0ChartCoverageAffineTest.lean:182` | `isLocallySurjective_sigmaDesc_of_affine` | same, with `[IsAffine Y]` on the test |
| `Pic0ChartAtlasCoupling.lean:164` | `isLocallySurjective_restrictChart_of_pointwise` | pointwise datum **+ range containment** `Set.range x.base ⊆ Set.range ((V i).ι.base)`; conclusion at the *restricted* atlas |
| `Pic0ChartCoverageSlice.lean:206` | `isLocallySurjective_of_slice` | `[Nonempty ι]`, `rep, m, Z, hdeg`, affine-test slice datum with one class equation |
| `Pic0ChartVMonotone.lean:196` | `isLocallySurjective_sigmaDesc_mono` | `U V`, `(e : ∀ i, U i ≤ V i)`, instance at `U` |
| `Pic0ChartVMonotone.lean:249` | `isLocallySurjective_unrestricted` | instance at some `V` ⟹ instance at unrestricted `Sigma.desc f` |
| `Pic0ChartVMonotone.lean:271` | `isLocallySurjective_of_bot` | instance at `⊥` |
| `Pic0ChartVMonotone.lean:344` | `coverage_instance_of_nested` | `rep, m, Z, hdeg, Vc ≤ Vf`, `hcov` (pointwise + containment in `Vc`) |

`ChartsCoverLocally` (`Pic0ChartLocalSurjectivity.lean:86`) has producers at `:127` (`chartsCoverLocally_of_forall_surjective`: needs one chart surjective on every test — the file's own docstring says this is not the geometric situation), `Pic0ChartCoveragePointwise.lean:129`, `Pic0ChartCoverageAffineTest.lean:151`, `Pic0ChartCoverageSlice.lean:191`. Every one of these takes the coverage geometry as a hypothesis. Nothing in the tree produces the pointwise/slice datum.

## 4. The leaf obligations — is anything inhabited?

**No. The divisor-representability chain has zero inhabitants, and the bottom obligation has zero producers.**

- **`DivRepChartFamily.IsChartClause`** (`DivRepAffPullClause.lean:119`) — **no producer**. Only three declarations mention it in conclusion position and none is a producer: `:156` `IsChartClause.of_id` (converts *from* `hid`), `:190` `.isCompatible` (consumes it), `DivRepChartRange.lean:183` `isChartClause_iff_forall_classify_eq` (an iff with `hrange`-shaped RHS). The file's own header admits this at `:44`.
- **`IsDivRepClassify … (U i j) (ChartMap i j)`** (P4's `hid`, equivalently P5's `hrange`) — **no producer**. The one producer of `IsDivRepClassify` is `DivRepClassifyZar.lean:256` `divRepClassifyZar_isDivRepClassify`, which produces it only for `(divRepClassifyZar … F₀).left` — i.e. for the classifier's own morphism, never for `ChartMap i j`. By `DivRepChartRange.lean:150` the obligation *is* the equation `(divRepClassifyZar … F).left = ChartMap i j`; nothing proves it.
- **`DivRepAffinePullback`** (`DivRepAffKit.lean:175`) — two producers: `DivRepAffPullbackReduce.lean:141` `ofPull` (three fields, incl. `isDivRepClassify_pull` at every affine test) and `DivRepAffPullClause.lean:461` `divRepAffinePullback_ofChartClause` (from `IsChartClause`). No inhabitant.
- **`DivRepGlobalData`** (`DivRepKit.lean:68`) — exactly one producer, `DivRepGlobalClassify.lean:288` `toGlobalData`, from a `DivRepAffinePullback`. So P1's hypothesis-light signature is not a cheaper route: every *inhabitant* of `DivRepGlobalData` carries `hO`/`hchi` and (†) through `toGlobalData`.
- **`ForallPrimeAwayCertified`** (`DivRepChartClassUnivZarLocal.lean:273`) — **no producer**. Note something sharper: even discharged it would not help. Its consumer `divFamZarUnivOfForallPrimeAway` (`:287`) outputs a `DivFamZar C RZ pi g` — the *class* — and **no declaration in the tree links any `divFamZarUniv*` to `divRepClassifyZar` or `ChartMap`** (grep of `divFamZarUniv` against `classif|chartmap|isdivrep` returns nothing). The class half is not the obligation; the classifier equation is.
- **`HasCertifiedAdaptation`** (`DivRepChartClassUnivAny.lean:155`) — no producer; only `:161` from a stronger `IsCertified`. Its own docstring (`:224`) records it is *conditionally refuted* by `forall_not_isCertified_of_straddling` (`DivisorFamilyAffStrict.lean:127`), with the straddling of the high-window universal seed unmeasured.
- **`IsCertified` at `(univSeed …).divisorAdaptation`** — no producer; all three `DivRepChartClassUniv.lean` sites (`:168/:202/:215`) take it as a hypothesis, as does `DivRepChartClassUnivFree.lean`. The generic `A.IsCertified n` producers (`DivSchemeCertUniv.lean:125`, `DivSchemeCertZarKerSpan.lean:83/:140`, `DivisorFamilyAffRank.lean:133`, …) are not instantiated at the universal seed.
- **`IsChartLocusFibre`** (`Pic0ChartUnivReduce.lean:166`) — **no producer, three refutations**: `Pic0ChartLocusFibreGuard.lean:160`, `Pic0ChartAbelNonInjective.lean:170/:191`, `Pic0ChartAbelForkReduce.lean:~430`.
- **`RestrictedChartFibre`** (`Pic0ChartRestrictedFibre.lean:143`) — producers: `Pic0ChartRestrictedFibreSat.lean:181` at `⊥` (free, and content-free), and `Pic0ChartRestrictedFibre.lean:209` from `IsChartLocusFibre` + range containment. At `⊤` it is *equivalent* to `IsChartLocusFibre` (`Pic0ChartRestrictedFibreSat.lean:346`) and conditionally refuted (`:373`).

## Docstring vs signature discrepancies

- `Picard/DivRepAffPullClause.lean:146`: "the one `divUniversalFamily` is built to satisfy, whose left-hand side is `divUniversalFst` definitionally (`Picard/DivSchemeFamilyUniv.lean:72-79`)". **`divUniversalFamily` does not exist in the Lean tree** — it occurs only in `informal/spec-dd4-seam.md` and `informal/w4-ddr9-worksheet.md`. `divUniversalFst`/`Snd` do exist at `DivSchemeFamilyUniv.lean:72`/`:79`, but nothing named `divUniversalFamily` is "built".
- `Picard/Pic0ChartUnivReduce.lean:55`: cites `isChartLocusFibre_of_isChartUniv` as "the **converse**". That name occurs nowhere in the tree. Already self-flagged at `Pic0ChartRestrictedFibreSat.lean:341`.
- `Picard/DivisorFamilyAffTheta.lean:38` cites `IsChartClause` at `DivRepAffPullClause.lean:121`; the `def` is at `:119` (minor).
- `Picard/DivRepAffPullClause.lean:30-32` calls `divRepAffinePullback_ofChartClause` "**a producer of `DivRepAffinePullback` from `IsChartClause` alone**". Signature-accurate as an implication; the same header correctly denies producing an inhabitant at `:44`.
- `Picard/Pic0ChartAbelForkReduce.lean:378` says `DivRepKit.lean:113` produces `RepresentableBy DivOver` "with no `χ` hypothesis in its own signature" — **confirmed by hover**, and its follow-on reasoning (that `DivRepGlobalData`'s sole producer `toGlobalData` carries `hchi`) is also confirmed: `DivRepGlobalClassify.lean:290` is the only declaration concluding `DivRepGlobalData`.
