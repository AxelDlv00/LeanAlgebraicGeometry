**Status: COMPLETE.** Kernel check passed (`lake env lean AlgebraicJacobian/Picard/Pic0RankOneSplitDescent.lean` → clean exit), zero diagnostics from LSP, no `sorry`.

**Delivered:** `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneSplitDescent.lean` (208 lines, new file only; nothing else touched, nothing committed) containing

```lean
theorem isSplitWitness_of_overSpecMap
    (pi : C.left ⟶ P1 k) [IsFinite pi]
    {K K' : Type u} [Field K] [Algebra k K] [Field K'] [Algebra k K']
    (e : K →ₐ[k] K') (nu : picEt C (overSpec k K))
    (h : IsSplitWitness C (picEtMap C (Over.overSpecMap e) nu)) :
    IsSplitWitness C nu
```

**Proof shape** — exactly the design's D2 route, with the `isSplitWitness_map_overSpecMap_of_algHom` proof as instance-plumbing template: split `nu` over `L/K` (`exists_splitting_of_picEt`), destructure `h` into `L'/K'` + witness, present both classes by `BasicOpenCocycleDatum.exists_cechPicClass_eq`, build the compositum `P` from `((Algebra.EtaleCover.ofField L).baseChange L').exists_finiteSeparableField_algHom` with the full letI/haveI tower (k, K, K', L, L' into P; `sigma : L →ₐ[K] P` verbatim from the template), push both presenting equations to `P` via `congrArg (PicEtAff.map C P)` + `map_map/map_unit/relPicAlgMap_mk`, collapse the naturality side with `picEtAffineEquiv_naturality` + the template's `change`-to-`map C K'` trick, close the Čech-level identity with `PicEtAff.unit_injective` + `relPicMk_injective_of_subsingleton`, then chain the witness `L' → P` (fieldExtension iff) → congr (`hasWitnessH1Vanishing_congr_of_cechPicClass_eq`) → `P → L` (iff .mpr), finishing with `isSplitWitness_of_presenting_witness C nu M hM W _ hW1`.

**Deviations from the design spec (all minor):**
1. `PicEtAff.unit_injective` lives at `Picard/CechKernelLemma.lean:361` — the `EtaleSeparatedness.lean:16` citation is only a docstring mention of the "future home". Transitively imported already.
2. Added one insurance line not in the design: `haveI : Subsingleton (overSpec k P).left := inferInstanceAs (Subsingleton (PrimeSpectrum P))` before the injectivity step (precedent: `RiemannRoch/RelPicDegree.lean:50`).
3. Flagged risk (iii) did not materialize — `relPicMk_injective_of_subsingleton` instance search succeeded over `P`; no relPic-level congr wrapper needed. Risk (ii) also fine: the two `relCurveMap C X X = 𝟙` hid-collapses were staged per-tower exactly as the template, no generic `CechPic.map_comp` used.
4. Budget: `set_option maxHeartbeats 1600000` sufficed on the first kernel run; no bump needed.
5. Imports are exactly the template's two (`Pic0ChartTwistSplit`, `Pic0RankOneNativePresentationDatum`), which transitively supply every brick including the extraction keystone and both fibre-field lemmas.
