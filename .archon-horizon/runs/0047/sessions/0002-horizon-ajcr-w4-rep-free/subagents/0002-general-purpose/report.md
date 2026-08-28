## 1. divRep: what exists

Two conditional packaging kits, both **structure-only** — every field is a hypothesis, no producer exists.

`DivRepAffinePullback` (`/…/AlgebraicJacobian/Picard/DivRepAffKit.lean:167`) — 4 fields: `pull : ∀ S, (overSpec k S ⟶ DivOver) → DivFamZar C S pi g`, `pull_classify`, `isDivRepClassify_pull`, `pull_naturality`. Its `equiv` (`:185`) gives `(overSpec k S ⟶ DivOver) ≃ DivFamZar C S pi g`, using the **landed** backward half.

`DivRepGlobalData` (`DivRepKit.lean:68`) — 5 fields (`pull`, `classify`, `classify_pull`, `pull_classify`, `pull_comp`); `representableBy` (`:113`) yields exactly `(divFunctor C pi g).RepresentableBy DivOver`. So *yes*, the full equivalence is already packaged — under the standing geometric pack plus `hpi`, `hO : h⁰ = 1`, `hχ : χ = 1 - g`, and the two bases `b1`, `b2`.

Landed (unconditional, given `hO`/`hχ`): `IsDivRepClassify` (`DivRepClassifyZar.lean:90`), `divClassifyZar` ∃! (`:206`), `divRepClassifyZar` (`:244`), `divRepClassifyZar_isDivRepClassify` (`:256`), `divRepClassifyZar_eq_of_isDivRepClassify` (`:265`). Atlas factorization `divScheme_exists_chartFactor` (`DivSchemeAtlasFactor.lean:382`). Total mono `divFam_divEq_of_eps_eq_total` (`DivSchemeMonoBridgeRel.lean:417`). Zariski sheaf of the vehicle (`DivisorFamilyZarSheaf.lean:66,237`).

**Un-producible today:** the whole *forward* direction. No def anywhere produces `pull`, an `IsCompatible` chart family (`DivRepAffKit.lean:127`), or the affine→general lift (`DivRepGlobalData.pull`/`pull_comp`). `DivRepAffinePullback` / `DivRepGlobalData` have **zero** references outside their own files.

## 2. Universal family over the chart ring

`divRepPullAt` (`DivRepAffKit.lean:90`) consumes `U : ∀ i j, CertifiedDivisorFamily C (ChartRing i j) pi g`. **No `U` exists.** But it is one step from a certificate:

- `ThetaGeneratorSeed.certifiedFamily` (`DivSchemeEps.lean:237`) turns `(hD : D.IsGenerator)` + `hc : (D.divisorAdaptation hD).IsCertified g` into `CertifiedDivisorFamily C R pi g`.
- The seed at the chart ring is landed unconditionally: `highWindowPointwiseGeneratorSeed` / `isGenerator_highWindowPointwiseGeneratorSeed` (`DivSchemeHighWindowPointwiseGenerator.lean:76,89`), over `RZ = DivCarveChartRing …`, gated only on `hb : 0 < windowBound`.
- ε-projection `ThetaGeneratorSeed.divFamEps_certifiedFamily` (`DivSchemeEps.lean:312`) is landed; its `hle₂` is discharged by `divUniversalSndWindow_le_highWindow_divisorWindow` (`DivSchemeHighWindowSecondContainment.lean:114`), `hsurj₁/₂` by `IsCertified.thetaGluedEval_surjective` (`DivisorThetaFibreData.lean:271`).
- Certificate assemblers ready to be fed: `DivSchemeCertUniv.lean:53,104,144`, `DivSchemeCertSeed.lean:61`.

So: a certificate term at the chart-ring seed immediately yields `U`, plus `ε(U i j) = (x₁, x₂)`. Nothing produces the *DivFamZar section over a general test* or a chart-level `RepresentableBy`.

Caveat: `DivRepKit`, `DivRepAffKit`, and all `DivSchemeCert*` / `…HighWindow*` / `…Redesign*` files are **not imported** by `AlgebraicJacobian.lean`.

## 3. Toward Pic⁰

Complete, sorry-free defs: `pic0Subgroup`/`pic0Map`/`pic0Functor` (`Pic0Functor.lean:107,132,151`); `pic0TypeFunctor`, `pic0SigmaFunctor_isSheaf`, `pic0SigmaSheaf`, and **`pic0RepresentableByOfCharts`** (`Pic0SigmaSheaf.lean:58,90,147,161`) — the 01JJ seam is finished; it just needs its two inputs (chart family `f`, `IsOpenImmersion.presheaf`, joint local surjectivity), which **nothing supplies** (`yoneda.obj` appears only there). `abelDivTrans : divFunctor ⟶ picDegLayerFunctor` (`DivSchemeAbel.lean:302`) and the θ-shift transfer `representableByOfShift` (`ThetaShift.lean:227`) are landed.

`PicRepDatum` (`PicRepDatum.lean:89`) — struct + consumers only; producer `picRepDatumKprime` absent; DAT-G0's colimit compatibility (`PicRepColimitCompat.lean`) is an open mountain.

`JacobianData` (`JacobianData.lean:87`) — struct, `grpObj`, `homEquiv`, `uniqueUpToIso` all landed. **`jacobianData C` producer does not exist** (only referenced in docstrings). Downstream consumers are already written *conditionally on a datum*: `isSeparated` (`GroupSeparated.lean:115`), `isProper_of_abelSource`/`geometricallyIrreducible_of_abelSource` (`AbelSource.lean:126,139` — need an unwritten `AbelSourceData`), `pullbackHom` + functor laws (`Pic0PullbackGrp.lean:77–178`), `baseChangeIsoOfData` (`JacobianDataBaseChange.lean:227`), `baseChange_ofCurve_data_of_core` (`JacobianDataBaseChangeAbel.lean:143`). Challenge.lean would be discharged by `Jacobian C := (jacobianData C).J`; all 14 `sorry`s there remain.

Blockers not certificate-gated: `pic0Theta_comp` (`Pic0ThetaCocycle.lean:268`, sorry, file unimported); DAT-G0 colimit; Albanese universal property (no `exists_unique` theorem in `Albanese/`); smoothness of relative dimension `genus C` (only a `GeometricallyReduced`-gated `Smooth` smoke test at `JacobianData.lean:173`).

## 4. If a certificate term existed tomorrow

1. **S** — `U i j` (apply `certifiedFamily`); reconcile the `b2` vs `b2.map (windowShiftEquiv …).symm` and `S+M`/`M+S` spellings; discharge `hb`.
2. **M** — `DivRepChartFamily.IsCompatible U` (needs total mono + ε identity, both landed).
3. **M** — `DivRepAffinePullback` producer (glue `divRepPullAt` over `divScheme_exists_chartFactor` covers; `pull_naturality` from `divRepPullAt_comp`).
4. **M** — affine→general lift to `DivRepGlobalData` (via `divFamZar` sheaf `existsUnique_glue_of_le_cover`); then `divRep` is free.
5. **L** — DAT-B/DAT-C: `chartLocus` is *undefined*; chart family + open-immersion + local-surjectivity certificates for `pic0SigmaSheaf`. This is the largest unwritten block.
6. **S** — DAT-glue: instantiate `pic0RepresentableByOfCharts` (already written).
7. **L** — DAT-G/DAT-G0 descent to `k` (`Pic0PreservesFilteredBaseColimit` mountain; independent of the certificate) + `PicRepDatum` producer.
8. **M** — DAT-J: `AbelSourceData` producer + Abel-image qc → `jacobianData C`.
9. **S** — discharge Challenge.lean `Jacobian`, `instGrpObj`, `functor`, `baseChangeIso*`, `baseChange_ofCurve` from landed conditional theorems.
10. **L** — genuinely orthogonal: `smoothOfRelativeDimension_genus`, `exists_unique_ofCurve_comp`, `ofCurve`/`comp_ofCurve`, `pic0Theta_comp`.
