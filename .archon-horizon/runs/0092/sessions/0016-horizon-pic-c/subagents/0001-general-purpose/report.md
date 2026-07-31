I have a complete picture. Here is the census.

## PART 1 — Producers of `(pic0TypeFunctor C).RepresentableBy _`

Note: `pic0TypeFunctor C` is a `noncomputable abbrev` for `(pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat` (`AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:58`), so the two slots in the task are **definitionally the same type**, machine-checked by the `example` at `AlgebraicJacobian/Picard/PicRepDatum.lean:144`. Only one declaration in the tree targets the unfolded spelling (`representableByOfShift`, R-6 below).

Ambient section binders shared by R-1…R-5, R-7, R-8: `{k : Type u} [Field k] {C : Over (Spec (.of k))}`, `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`; the chart files additionally fix `{π : C.left ⟶ P1 k} [IsAffineHom π]`, and `Pic0SigmaSheaf` adds `[GeometricallyReduced C.hom]`.

**R-1 `pic0RepresentableByOfCharts`** — `AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161` — THE ROOT ENGINE (all other chart-route producers are its wrappers).
```
{ι : Type u} {X : ι → Scheme.{u}}
(f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
(hf : ∀ i, IsOpenImmersion.presheaf (f i))
[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]
```
- `f` (chart family) — HAS-PRODUCER: `abelSigmaChart` / `mixedParamChart` / `abelSigmaChartZero`, but each takes `rep : (divFunctor C π n).RepresentableBy D` (see D-block below).
- `hf` — HAS-PRODUCER only conditionally: `isChartUniv_of_restrictedChartFibre` (`Pic0ChartRestrictedFibre.lean:158`), `isChartUniv_of_isChartLocusFibre` (`Pic0ChartUnivReduce.lean:184`), `isChartUniv_of_unrestricted` (`Pic0ChartPair.lean:185`), `isChartUniv_antitone` (`Pic0ChartVMonotone.lean:157`), and unconditionally at `V = ⊥` only: `isChartUniv_bot` (`Pic0ChartRestrictedFibreSat.lean:232`) via `restrictedChartFibre_bot` (`:190`). Also `isOpenImmersion_presheaf_abelSigmaChart_of_mono_of_cov` (`Pic0ChartSeamPairDecided.lean:527`, needs `Mono D.hom` + coverage), and `isOpenImmersion_presheaf_of_injective` under `hvan` (`seamPair_abelSigmaChartZero_of_subsingleton`).
- `[IsLocallySurjective (Sigma.desc f)]` — HAS-PRODUCER conditionally: `isLocallySurjective_restrictChart_of_pointwise` (`Pic0ChartAtlasCoupling.lean:165`, from `PointwiseCoverage`), `Pic0ChartCoveragePointwise.lean:150`, `Pic0ChartCoverageAffineTest.lean:186`, `Pic0ChartLocalSurjectivity.lean:106`. **No unconditional producer.** `PointwiseCoverage` itself: only conditional producer `Pic0ChartAtlasCoupling.lean:150`; refuted at `V = ⊥` (`not_coverageContainment_bot`) and at proper `V` under subsingleton (`not_pointwiseCoverage_of_subsingleton_of_ne_top`).

**R-2 `mixedParamRepresentableBy`** — `AlgebraicJacobian/Picard/Pic0ChartAtlasParamFree.lean:125` — thin wrapper of R-1.
```
{ι : Type u} (nn : ι → ℕ) (D : ι → Over (Spec (.of k)))
(rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
(m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
(hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i) = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
(V : ∀ i, (D i).left.Opens)
(hf : ∀ i, IsOpenImmersion.presheaf (mixedParamChart C π nn D rep m Z hdeg V i))
[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc (mixedParamChart …))]
```
- `rep` (divisor representability) — see D-block. `hdeg` — HAS-PRODUCER (degree-window lemmas exist in `JacobianDataAbelDegreeWindow`/`DivisorFamilyDegreeZero`; it is an equation, satisfiable by choice of `Z`). `hf`, instance — as R-1.

**R-3 `pic0RepresentableBy_of_restrictedChartFibre`** — `AlgebraicJacobian/Picard/Pic0ChartRestrictedFibre.lean:259` — same binders as R-2 but `hf` replaced by `(huniv : ∀ i, RestrictedChartFibre C π (nn i) (rep i) (m i) (Z i) (hdeg i) (V i))`, instance binder retained.
- `RestrictedChartFibre` — HAS-PRODUCER at `⊥` only (`restrictedChartFibre_bot`, `Pic0ChartRestrictedFibreSat.lean:190`); conditional at general `V` (`restrictedChartFibre_of_isChartLocusFibre`, `Pic0ChartRestrictedFibre.lean:209`, needs `IsChartLocusFibre` + range containment); iff at `⊤` (`restrictedChartFibre_top_iff`, `Pic0ChartRestrictedFibreSat.lean:378`).
- `IsChartLocusFibre` — NO-PRODUCER (only the `iff` restatements at `Pic0ChartSubsingletonCollapse.lean:344` and `restrictedChartFibre_top_iff`).

**R-4 `pic0RepresentableBy_of_restrictedChartFibre_of_coverage`** — `AlgebraicJacobian/Picard/Pic0ChartRestrictedFibre.lean:288` — concl. `Σ J, (pic0TypeFunctor C).RepresentableBy J`. Same as R-3 but the instance binder is replaced by explicit `hcov` (pointwise coverage with `Set.range (x.base) ⊆ Set.range ((V i).ι.base)`). Hypotheses: `rep` (D-block), `huniv` (as R-3), `hcov` — NO unconditional PRODUCER; refuted at `V = ⊥`.

**R-5 `pic0RepresentableBy_of_nested`** — `AlgebraicJacobian/Picard/Pic0ChartVMonotone.lean:309` — concl. `Σ J, …`. As R-4 but two opens `(Vc Vf : ∀ i, (D i).left.Opens) (hle : ∀ i, Vc i ≤ Vf i)`, `huniv` at `Vf`, `hcov` containment at `Vc`. Same hypothesis statuses.

**R-5b `pic0RepresentableBy_of_isChartLocusFibre_of_coverage`** — `AlgebraicJacobian/Picard/Pic0ChartSubsingletonCollapse.lean:377` — concl. `Σ J, …`. `V`-free form: `rep`, `m`, `Z`, `hdeg`, `(hcert : ∀ i, IsChartLocusFibre …)` [NO-PRODUCER], `(hcov : PointwiseCoverage C (fun i => abelSigmaChart …))` [NO unconditional producer].

**R-6 `representableByOfShift`** — `AlgebraicJacobian/Picard/ThetaShift.lean:225` — the only producer stated at the unfolded `((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J` spelling.
```
{J : Over (Spec (.of k))} (L₀ : (C ⊗ overSpec k k).left.CechPic) (m : ℕ)
(rep : (picDegLayerFunctor C ((m : ℤ) * classDeg k L₀)).RepresentableBy J)
```
- `rep` at the shifted layer — **NO-PRODUCER**. `(picDegLayerFunctor _ _).RepresentableBy` appears exactly once in the tree, at this binder.

**R-7 `pic0RepresentableBy_terminal_of_subsingleton`** — `AlgebraicJacobian/Picard/Pic0VanishingRoute.lean:175` — **the only chart-free, atlas-free producer, and the only one with a single hypothesis.**
```
(h : ∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup C T))
  : (pic0TypeFunctor C).RepresentableBy (Over.mk (𝟙 (Spec (CommRingCat.of k))))
```
- `h` — **NO-PRODUCER at the ∀-T level.** Reductions exist but all end in an unproduced hypothesis: `subsingleton_pic0Subgroup_of_overSpec` (`Pic0VanishingAffineReduction.lean:163`, affine tests → all tests), `subsingleton_pic0_of_affine` (`Pic0VanishingRoute.lean:283`), `subsingleton_pic0Subgroup_of_rigidityAff` (needs `genus C = 0` + `hA`), `PicEtAff.subsingleton_of_away` (`Pic0RingZariskiLocal.lean:189`). Unconditional producers exist only in degenerate cases: `subsingleton_pic0Subgroup_overSpec_of_subsingleton` (`Pic0RingZariskiLocal.lean:164`, `[Subsingleton A]`) and `subsingleton_pic0Subgroup_overSpec_field_of_genus_zero` (`Pic0VanishingFieldTest.lean:149`, one field test, needs `genus C = 0`). Circularly, `subsingleton_pic0Subgroup_of_surjective_app` (`Pic0ChartSeamPairDecided.lean:313`) derives it from chart surjectivity.

**R-8 `exists_representableBy_pic0TypeFunctor_of_subsingleton`** — `AlgebraicJacobian/Picard/Pic0ChartSeamPairDecided.lean:496` — concl. `∃ J, Nonempty ((pic0TypeFunctor C).RepresentableBy J)`. Binders: `(pi' : C.left ⟶ P1 k) [IsAffineHom pi'] (m : ℕ) (Z : …CurveDivisor) (hdeg : …) (hvan : ∀ S, Subsingleton (pic0Subgroup C S))`. Same `hvan` status as R-7 (NO-PRODUCER). Routes through R-1 rather than R-7.

**R-9 `representableBy_of_seam`** — `AlgebraicJacobian/Picard/Pic0ChartSeamCollapse.lean:248` — concludes `(pic0SigmaFunctor C).RepresentableBy X`, i.e. the **Σ-extension, one stage short**; the descent `Functor.RepresentableBy.overSlice` (`OverSigmaExtension.lean:235`) is the missing hop and is landed. Binders: `{X} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (hf : IsOpenImmersion.presheaf f) (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f)`. Same hypothesis statuses as R-1's `hf`/coverage, at a one-chart atlas.

### D-block: producers of `(divFunctor C π n).RepresentableBy D` (the `rep` binder of R-2…R-5b)

Ambient DivRep binders (shared, load-bearing): `{pi : C.left ⟶ P1 k} [IsFinite pi] [IsDominant pi]`, `[SmoothOfRelativeDimension 1 (C.left ↘ Spec …)] [IsIntegral C.left] [LocallyOfFiniteType …] [QuasiCompact …]`, `[Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]`, `[… 1]`, `(hpi : pi ≫ P1.structureMap k = C.left ↘ Spec …)`, `(g r1 r2 : ℕ)`, `(b1 b2 : Module.Basis …)`, and for the Clause files `(hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1) (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g:ℤ))`.

- **D-1 `DivRepGlobalData.representableBy`** — `Picard/DivRepKit.lean:113` — hypothesis: `(D : DivRepGlobalData hpi g r1 r2 b1 b2)`. Producer of that structure: exactly one, `DivRepAffinePullback.toGlobalData` (`DivRepGlobalClassify.lean:289`).
- **D-2 `DivRepAffinePullback.representableBy`** — `Picard/DivRepGlobalClassify.lean:306` — hypothesis: `(D : DivRepAffinePullback hpi g hO hchi r1 r2 b1 b2)`. Producers: `DivRepAffinePullback.ofPull` (`DivRepAffPullbackReduce.lean:140`, 3 fields) and `divRepAffinePullback_ofChartClause` (`DivRepAffPullClause.lean:470`).
- **D-3 `divFunctor_representableBy_of_chartClause`** — `Picard/DivRepAffPullClause.lean:490` — hypotheses `(U : ∀ i j, DivFamZar C (ChartRing i j) pi g)` and `(hU : IsChartClause … U)`. `IsChartClause` — HAS-PRODUCER only via `IsChartClause.of_id` (`:164`), whose own hypothesis `hid : ∀ i j, IsDivRepClassify … (U i j) (ChartMap i j)` is **U2, NO-PRODUCER**.
- **D-4 `divFunctor_representableBy_of_id`** — `Picard/DivRepAffPullClause.lean:510` — hypotheses `U` and `(hid : ∀ i j, IsDivRepClassify hpi g r1 r2 b1 b2 (U i j) (ChartMap i j))`. **`hid` = U2, NO-PRODUCER** (its file docstring says so explicitly).
- **D-5 `divFunctor_representableBy_of_chartRange`** — `Picard/DivRepChartRange.lean:220` — hypothesis `(hrange : ∀ i j, ∃ F : DivFamZar C (ChartRing i j) pi g, (divRepClassifyZar … F).left = ChartMap i j)`. **NO-PRODUCER** (same U2 obligation, preimage spelling).
- **D-6 `divFunctorZeroRepresentableBy`** — `Picard/DivisorFamilyDegreeZeroRep.lean:227` — **the only hypothesis-free producer in the D-block**, conclusion `(divFunctor C pi 0).RepresentableBy (Over.mk (𝟙 (Spec (CommRingCat.of k))))`. Binders: `{pi : C.left ⟶ P1 k} [IsAffineHom pi]` only. Pinned to `n = 0`; `hO`/`hchi`/`b1`/`b2` not required.
- `(divFunctorAff C n).RepresentableBy` (the widened R2 carrier, `Pic0AtlasFromDivRepAff.lean:115`): **ZERO producers**, confirmed by full-tree grep.

## PART 2 — Producers of `JacobianData C` (20 total)

Every one factors through `JacobianData.ofRepresentableBy`; they differ only in how `quasiCompact` is paid.

| # | Producer | file:line | hypotheses beyond ambient | status |
|---|---|---|---|---|
| J-1 | `JacobianData.ofRepresentableBy` | `Picard/JacobianDataCharts.lean:71` | `(J)`; `rep : (pic0TypeFunctor C).RepresentableBy J`; `hlft : LocallyOfFiniteType J.hom`; `hqc : QuasiCompact J.hom` | rep: PART 1. hlft/hqc: HAS-PRODUCER only at specific carriers — `divSchemeOver` (`DivSchemeQProj.lean:200`/`:189`) and the terminal object (`Pic0VanishingRoute.lean:152`/`:159`); NO general producer at an arbitrary glued `J`. |
| J-2 | `JacobianData.ofCharts` | `Picard/JacobianDataCharts.lean:182` | `[Finite ι]`; section `f`, `hf`, `[IsLocallySurjective (Sigma.desc f)]`; `hlft : ∀ i, LocallyOfFiniteType (chartHom C f i)`; `hcpt : ∀ i, CompactSpace (X i)` | `[Finite ι]` is the blocker for the class-indexed atlas. `hlft` per-chart: NO-PRODUCER at a general chart. |
| J-3 | `JacobianData.ofChartsOfCompactSpace` | `Picard/JacobianDataCharts.lean:209` | same minus `[Finite ι]`, with `hcpt : CompactSpace (Scheme.LocalRepresentability.glueData hf).glued` | `hcpt`: HAS-PRODUCER at a finite atlas over the divisor carrier (`Pic0AtlasCompactNoetherian.lean:291`), and from `hcl` (`Pic0AtlasCompactFromClass.lean:209`, `:359`). |
| J-4 | `JacobianData.ofAbelImage` | `Picard/JacobianDataAbelImage.lean:119` | `J`; `rep`; `hlft`; `abel : DivScheme k A B g r₁ r₂ b₁ b₂ ⟶ J.left`; `hsurj : Function.Surjective abel.base` | `abel`: **NO-PRODUCER** (only ever a binder; sole `DivScheme ⟶ _` producer in tree is `divSchemeι` into `grPair`). `hsurj`: NO-PRODUCER. |
| J-5 | `JacobianData.ofChartsOfAbelImage` | `Picard/JacobianDataAbelImage.lean:159` | chart section vars; `hlft : ∀ i, …(chartHom …)`; `abel : … ⟶ (gluedOfCharts C f hf).left`; `hsurj` | same |
| J-6 | `JacobianData.ofAbelLifts` | `Picard/JacobianDataAbelSurj.lean:149` | `J`; `rep`; `hlft`; `abel`; `hlift : ∀ y : J.left, ∃ q : Spec (J.left.residueField y) ⟶ DivScheme …, q ≫ abel = J.left.fromSpecResidueField y` | `abel` NO-PRODUCER; `hlift` NO-PRODUCER (only `JacobianDataAbelSquareVacuity.lean:198` at a degenerate `pt`). |
| J-7 | `JacobianData.ofChartsOfAbelLifts` | `Picard/JacobianDataAbelSurj.lean:193` | chart vars; `hlft`; `abel`; `hlift` at `gluedOfCharts` | same |
| J-8 | `PicRepDatum.toJacobianData` | `Picard/JacobianDataFromPicRepDatum.lean:83` | `(d : PicRepDatum k k C)`; `hqc : QuasiCompact d.J.hom` | **`PicRepDatum` has ZERO producers in the entire repo** (whole-repo grep: it appears only as a binder, in `PicRepDatum.lean`, `JacobianDataFromPicRepDatum.lean`, and prose). |
| J-9 | `PicRepDatum.toJacobianDataOfAbelLifts` | `Picard/JacobianDataFromPicRepDatum.lean:132` | `d : PicRepDatum k k C`; `abel`; `hlift` | all three NO-PRODUCER |
| J-10 | `JacobianData.ofPic0ClassSurjective` | `Picard/JacobianDataQcFromRep.lean:394` | `(C)…`; `J`; `rep`; `hlft`; `lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂)`; `hcl : ∀ y : J.left, ∃ q : overSpec k (Over.testPointField y) ⟶ divSchemeOver …, pic0Map C q lam = rep.homEquiv (Over.testPoint y)` | `lam`: HAS-PRODUCER — `lamOfDivRep` (`JacobianDataQcFromRep.lean:361`, from a `divRep`). `hcl`: **NO-PRODUCER** (falsifiable, not vacuous: implies `CompactSpace J.left`, `:330`). |
| J-11 | `jacobianDataOfCompactFromClass` | `Picard/Pic0AtlasCompactFromClass.lean:232` | `nn`, `D`, `rep`, `m`, `Z`, `hdeg`, `V`, `hf`, `[IsLocallySurjective …]`, `hD : ∀ i, LocallyOfFiniteType (D i).hom`, `lam`, `hcl` at `gluedOfCharts` | `hD`: HAS-PRODUCER at `divSchemeOver` (`DivSchemeQProj.lean:200`). rest as above; `hcl` NO-PRODUCER. |
| J-12 | `jacobianDataOfFiniteMixedParamCharts` | `Picard/Pic0AtlasCompactNoetherian.lean:311` | `[Finite ι]`, `nn`, `gg`, `rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (divSchemeOver k A B (gg i) r₁ r₂ b₁ b₂)`, `m`, `Z`, `hdeg`, `V`, `hf`, `[IsLocallySurjective …]` | **the shortest chart-route list**: `hlft`/`hcpt` both discharged (`inferInstance`, `compactSpace_glued_of_finite_mixedParamChart`). Remaining: `rep` at the pinned divisor carrier (D-block; only `n = 0` available, and then `gg` must match), `hf`, coverage instance, `[Finite ι]`. |
| J-13 | `jacobianDataOfMixedParamCharts` | `Picard/Pic0AtlasFiniteType.lean:294` | `nn`, `D`, `rep`, `m`, `Z`, `hdeg`, `V`, `hf`, `[IsLocallySurjective …]`, `hD`, `hcpt : CompactSpace (…glueData hf).glued` | five open inputs; `hcpt` HAS-PRODUCER at finite atlas only. |
| J-14 | `jacobianData_of_subsingleton` | `Picard/Pic0VanishingRoute.lean:204` | `h : ∀ T, Subsingleton (pic0Subgroup C T)` | **single hypothesis, NO-PRODUCER**; this is R-7 + two identity certificates. Docstring itself flags the hypothesis as "the Jacobian is a point", unmeasured. |
| J-15 | `jacobianData_of_affine_subsingleton` | `Picard/Pic0VanishingRoute.lean:296` | `h : ∀ (A : Type u) [CommRing A] [Algebra k A], Subsingleton (PicEtAff C A)` | NO-PRODUCER |
| J-16 | `jacobianData_of_overSpec_subsingleton` | `Picard/Pic0VanishingAffineReduction.lean:266` | `h : ∀ (A) [CommRing A] [Algebra k A], Subsingleton (pic0Subgroup C (overSpec k A))` | NO-PRODUCER (unconditional producers only for `[Subsingleton A]`, `Pic0RingZariskiLocal.lean:164`) |
| J-17 | `jacobianData_of_rigidityAff` | `Picard/Pic0RigidityAffineReduction.lean:240` | `hg : genus C = 0`; `hA : ∀ (A) [CommRing A] [Algebra k A] (q : PicEtAff C A), (∀ (K) [Field K] [Algebra k K] (φ : A →ₐ[k] K), PicEtAff.mapAlg C φ q = 1) → q = 1` | `hg`: HAS-PRODUCER at `ℙ¹` only (`P1.genus_asOver_eq_zero`). `hA`: NO-PRODUCER. |
| J-18 | `jacobianData_of_forall_prime_subsingleton` | `Picard/Pic0RingZariskiLocal.lean:355` | `h : ∀ (A) [CommRing A] [Algebra k A], ∀ p : PrimeSpectrum A, ∃ f : A, f ∉ p.asIdeal ∧ Subsingleton (PicEtAff C (Localization.Away f))` | NO-PRODUCER |
| J-19 | `jacobianData_of_forall_prime_rigidity` | `Picard/Pic0RingZariskiLocal.lean:369` | `hg : genus C = 0`; the pointwise-local rigidity clause | NO-PRODUCER |
| J-20 | `jacobianData_of_vanishing` | `Albanese/Genus0VanishingDatum.lean:93` | `h : ∀ T, pic0Subgroup C T = ⊥` | NO-PRODUCER; interderivable with J-14's hypothesis. |

Bottom line on the two slots: no `JacobianData C` and no `RepresentableBy` in either slot is derivable without an open hypothesis. There are exactly **two disjoint terminal debts**: (a) the chart route, whose minimal remaining list is J-12's `{rep at a pinned divisor carrier, hf, coverage instance, Finite ι}` — with `rep` reducing to U2 (`IsDivRepClassify` at chart maps) and coverage having no unconditional producer and being refuted at `⊥`; and (b) the vanishing route, whose entire debt is the single hypothesis `∀ T, Subsingleton (pic0Subgroup C T)` (J-14…J-20), which is false at positive genus. `PicRepDatum` (J-8/J-9) and the shifted layer (R-6) are two further slots with **zero producers anywhere in the repo**.

## PART 3 — Sorry census

16 real `sorry` occurrences, in 2 files. (86 raw grep matches; the other 70 are prose in docstrings, all of the form "sorry-free"/"a sorry census".)

`AlgebraicJacobian/Challenge.lean` — 15, all in the frozen challenge statement:
- `:99` `Jacobian` (the definition itself)
- `:108` `instGrpObj`
- `:113` `smoothOfRelativeDimension_genus`
- `:117` anonymous `instance : IsProper (Jacobian C).hom`
- `:121` anonymous `instance : GeometricallyIrreducible (Jacobian C).hom`
- `:126` `ofCurve`
- `:134` `comp_ofCurve`
- `:147` `exists_unique_ofCurve_comp`
- `:156`, `:157`, `:158` `functor` (fields `map`, `map_id`, `map_comp`)
- `:248` `baseChangeIso`
- `:259` `baseChangeIso_id`
- `:272` `baseChangeIso_comp`
- `:283` `baseChange_ofCurve`

`AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean` — 1:
- `:76` `pic0Theta_comp`

No `axiom` declarations and no `sorryAx` uses anywhere under `AlgebraicJacobian/`.
