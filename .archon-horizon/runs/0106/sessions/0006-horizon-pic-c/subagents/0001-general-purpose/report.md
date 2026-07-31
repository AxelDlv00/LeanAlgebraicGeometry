I now have a complete picture. I have all the evidence needed to answer the three questions precisely.

## Report: the `pic0Subgroup C (overSpec k A)` route and the seminormality obstruction

All paths below are under `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`. All the key files checked are sorry-free; `PicEtAff.unit_injective` is proved (C1 étale-separatedness), not gated on an axiom.

### (a) The exact map chain: `CechPic → relPic → PicEtAff → picEt → pic0Subgroup`

For `X = (C ⊗ overSpec k A).left` (the base-changed curve) and affine test `T = overSpec k A`:

1. **`Scheme.CechPic X`** — `AlgebraicJacobian/Picard/Pic.lean:60`. The *Zariski* Čech `H¹(X, 𝒪ˣ)`, a `Quotient` over all pointed covers stabilised under refinement (so it is the full Picard group, seeing every cover, not just two-chart ones).

2. **`relPic C T := CechPic((C⊗T).left) ⧸ picFromBase C T`** — `RelPic.lean:54,63-64`. `picFromBase` = range of pullback from the base `T` (`RelPic.lean:54`). Projection `relPicMk` at `RelPic.lean:70`; restriction `relPicAlgMap C f := relPicMap C (overSpecMap f)` at `RelPicAlgebra.lean:88-90`.

3. **`PicEtAff C A`** — `PicEtAff.lean:218`. The **one-step étale plus construction** of `relPic`: `Quotient` of `Σ (E : EtaleCover A), descentClasses C E` modulo agreement on a common refinement (`descentClasses` = equalizer of the two `relPicAlgMap`s of the double-cover projections, `PicEtAff.lean:76-80`). The **unit** `relPic C (overSpec k A) →* PicEtAff C A` is at `PicEtAff.lean:377`, and it is **INJECTIVE** — `PicEtAff.unit_injective`, `CechKernelLemma.lean:361` (Kleiman 2.5(1), "axiom C1", but proved sorry-free here). This is decisive for part (b): the plus does **not** collapse `relPic` classes.

4. **`picEt C T`** — `PicEt.lean:105`. The bespoke affine-opens limit: the subgroup of `∏_{U ∈ T.left.affineOpens} PicEtAff C Γ(T.left,U)` cut out by restriction-compatibility.

5. **`picEtAffineEquiv C A : picEt C (overSpec k A) ≃* PicEtAff C A`** — `PicEt.lean:235` (limit collapses at the terminal `⊤` of an affine test's affine-opens poset). **So for an affine test, `picEt` IS `PicEtAff` — YES to your question.**

6. **`pic0Subgroup C T`** — `Pic0Functor.lean:107`. Subgroup of `picEt C T` of classes with `degAt lam t = 0` at *every* field point `t : overSpec k K ⟶ T`. `degAt` (`Pic0Functor.lean:54`) restricts `lam` along `t`, collapses via `picEtAffineEquiv C K` to `PicEtAff C K`, and takes `PicEtAff.degAff`.

Note: **`relPicMulEquivCechPic` (`RelPicPointTest.lean:99`) is NOT on this chain for general `A`.** It requires `[Subsingleton T.left]` (a one-point test) and is a Wave-5 dual-numbers tool. For `overSpec k A` with `A` a general ring, `Spec A` has many points, so it does not apply.

So `PicEtAff C A` is the **étale sheafification** of the relative Picard group `relPic C (overSpec k A) = CechPic(ℙ¹_A) / (pullbacks from Spec A)` — with an injective unit from `relPic`. It is *not* the absolute `CommRing.Pic(A[t])`; it is the relative Picard, étale-plus'd.

### (b) Verdict: the seminormality obstruction DOES bite the `pic0Subgroup` route (it is not confined to a naive `CommRing.Pic` route)

The étale/plus construction does **not** sheafify away the `Pic(A[t])` contribution. Three concrete reasons, each with evidence:

1. **The plus unit is injective (`CechKernelLemma.lean:361`).** `relPic C (overSpec k A) ↪ PicEtAff C A`. So every nonzero class of `relPic` survives into `PicEtAff = picEt`. The plus can only *add* étale-local classes, never collapse `relPic` ones. Hence it cannot kill a nonzero `relPic` class.

2. **Étale sheafification leaves `Pic` unchanged** (line bundles satisfy étale descent). The Traverso–Swan classes in `Pic(A[t])/Pic(A)` for non-seminormal `A` are genuine line bundles, not étale-locally-trivial phantoms, so étale-sheafifying does not remove them.

3. **The landed Laurent theory only resolves the two-chart / chart-trivial layer.** `mem_laurentCoboundaryUnits_iff_general` (`Algebra/LaurentCoboundaryGeneral.lean:71`) computes, over an arbitrary ring, that the two-chart coboundary subgroup = exponent-zero units (`C c·(1+z)`, `c` unit, `z` nilpotent) — i.e. the *two-chart* relative Čech `H¹` of `ℙ¹_A` is `ℤ` (degree), even non-reduced. But the criterion consuming it, `Scheme.cechPic_eq_one_of_forall_presenting_coboundary` (`TwoChartCechPicTrivial.lean:151`), has a **chart-triviality hypothesis** `hL : ∀ s, CechPic.map (V s).ι L = 1` — the class must already be trivial on each chart `A[t]`, `A[t⁻¹]`. Classes coming from `Pic(A[t])/Pic(A)` (nonzero exactly for non-seminormal `A`) are **not** chart-trivial and live in finer covers, invisible to the two-chart Čech `H¹`. So the Laurent bridge cannot touch them.

Consequence: a Traverso–Swan class (fibrewise-trivial, degree-zero, nonzero line bundle on `ℙ¹_A` for non-seminormal `A`) is a nonzero element of `relPic`, hence — by injectivity of the unit — nonzero in `picEt`, and since it is fibrewise trivial its `degAt` vanishes at every field point (this is exactly what `pic0_fibre_eq_one_of_genus_zero`, `Pic0RingFibrewiseTrivial.lean:141`, records). It is therefore a would-be **nonzero member of `pic0Subgroup C (overSpec k A)`**. So the obstruction is on the `pic0Subgroup` route itself, not merely on a naive `CommRing.Pic(A[t])` route.

The lane's own docstrings corroborate this and never claim the plus/étale layer resolves it: `P1DegreeZeroTrivial.lean:70-84`, `Pic0RingFibrewiseTrivial.lean:89-93`, `Pic0RingZariskiLocal.lean:111-119`, and `Pic0RingEngineFromPic0.lean:63-69` all state that `Subsingleton (CommRing.Pic (Polynomial A))` fails even given `Subsingleton (CommRing.Pic A)`, citing Traverso–Swan, and treat the ring case as genuinely open. There is no file where étale-sheafification is claimed to discharge it.

Caveat I cannot fully settle by reading alone: whether these chart classes survive all the way into `picEt` as *nonzero* elements would make the target `Subsingleton` statement outright **false** for non-seminormal `A`; the injectivity of the unit strongly suggests they do. Either way, the seminormality content is live and unaddressed on this route. This is the crux the lane must confront: it must either restrict to seminormal/reduced `A`, or prove a genuine "fibrewise-trivial ⟹ trivial" rigidity (cohomology-and-base-change) that does not exist in the tree.

### (c) Existing ring-case bridge files and their exact remaining gaps

1. **`Picard/Pic0RingFibrewiseTrivial.lean`** — `pic0_fibre_eq_one_of_genus_zero` (`:141`): a `pic0` class over ring `A` restricts to `1` at every field point (genus 0). Also `classDeg_fibre_eq_zero_of_cocyclePresented` (`:186`). **Gap:** fibrewise triviality ⟹ triviality is exactly Traverso–Swan, explicitly not closed (`:89-93`); the `classDeg` result needs a cocycle presentation `picEtAffineEquiv C A lam = PicEtAff.unit C A (relPicMk … L)`. The first two theorems are noted as affine specializations of a landed more-general lemma (`fibre_eq_one_of_mem_pic0Subgroup`, `Pic0VanishingRigidityReduction.lean:104`).

2. **`Picard/Pic0RingZariskiLocal.lean`** — `PicEtAff.subsingleton_of_away` (`:227`), `subsingleton_of_forall_prime` (`:320`), and `subsingleton_pic0Subgroup_overSpec_of_forall_prime` (`:338`); plus the degenerate `PicEtAff.subsingleton_of_subsingleton` (`:189`, unconditional at a zero ring). **Gap (self-documented, `:36-60`):** under the outer `∀ A` this is **not a weakening** — the converse with witness `f=1` (`forall_prime_subsingleton_of_forall`, `:441`) is one line, so it only helps at a *fixed* `A`. The hypothesis is about `Localization.Away f` (a basic open, **not** a local ring); the `AtPrime → Away` spreading-out bridge is unbuilt. The remaining content at each `Away` is "seminormality-flavoured, not quantifier-flavoured" (`:117-119`).

3. **`Picard/Pic0RingDatumEngine.lean`** — at genus 0, from a fibrewise-trivial hypothesis: `rigidEngine_of_genus_zero` (`:161`) gives `H¹(C_B,F_D)=0` and `H⁰` finite projective; `rankAtStalk_hModule_zero_eq_one_of_genus_zero` (`:179`) gives `π_*L` of stalk rank 1. **Gap (`:63-69`):** needs `IsNoetherianRing B`; and `H¹=0` + `H⁰` invertible do **not** give triviality — the missing step is the evaluation/counit map `π^*π_*L → L` being an **isomorphism**, which is absent from AJCR (the counit exists in mathlib's `pullbackPushforwardAdjunction` but no iso-at-this-sheaf theorem, and AJCR's carriers are not `Scheme.Modules`).

4. **`Picard/Pic0RingEngineFromPic0.lean`** — joins the datum engine to a `pic0` membership: `rigidEngine_of_pic0`, `rankAtStalk_hModule_zero_eq_one_of_pic0`, with the fibrewise binder discharged. **Gap (`:63-98`):** (i) the evaluation/counit-iso step (as in #3) still missing on the divisor/pushforward route; (ii) the genuinely missing input is **surjectivity of `relPicToPicEt` onto `picEt`** ("honesty" — that every étale-plus class over a ring comes from a relative Picard class), a different statement about a different map; (iii) `IsNoetherianRing` inherited. Note `picEtAffineEquiv_relPicToPicEt` (`PicEtUnit.lean:161`) already supplies the presentation seam at arbitrary test ring, so that is *not* the obstruction it was once priced as.

5. **The Laurent bridge (active claim I-1710, "pic-c"):** `Picard/TwoChartCechPicTrivial.lean` (criterion, `:151`) + `Picard/LaurentTwoChartCoboundary.lean` (domain case) + `Algebra/LaurentCoboundaryGeneral.lean` (`mem_laurentCoboundaryUnits_iff_general`, `:71`, arbitrary ring). **Gap — the largest and the one your memory note flags:** the algebraic layer is complete, but the **scheme-level base-changed two-chart cover for `ℙ¹_A` does not exist**. `LaurentChartPair` / `P1.laurentChartPair` (`Curve/P1Charts.lean:307+`) is built only over the **field** `k` at `P1 k`; there is no base-changed `LaurentChartPair` for `relCurve C (overSpec k A)` / `ℙ¹_A`. Confirmed: `LaurentChartPair` occurs only in `Curve/P1.lean`, `P1Charts.lean`, `P1H1Vanishing.lean`, and **nothing in the scheme layer imports `LaurentCoboundaryGeneral`** — no consumer connects `mem_laurentCoboundaryUnits_iff_general` to a `CechPic(ℙ¹_A)` statement. Additionally the criterion needs chart-triviality (the `Pic(A[t])` obstruction of part (b)), so even once the cover is base-changed, only chart-trivial classes are reachable.

6. **`Cohomology/RelCurveCollapse.lean`** — this is *not* a ring-case bridge: it is the base-**field** collapse (`B = k`), packaging the relative theta cocycle as a `BasicOpenCocycleDatum` and identifying its Čech class with the pulled fiber twist `Θᵃ` at `k` (`cechPicClass_thetaChartDatum`, `:668`). It feeds degree/theta machinery (`RiemannRoch/WindowFieldTransport`), not the arbitrary-`A` `pic0` target.

### Bottom line

The field case is closed (`Pic0VanishingFieldTest.lean`, sorry-free) because `Pic(K[t]) = 0`. Everything for the ring case is either a *quantifier reduction that is provably not a weakening* (file #2), a *cohomological half-result missing the counit-iso* (files #3–4), or a *complete pure-algebra layer with no scheme-level bridge and a chart-triviality wall* (file #5). The single mathematical fact blocking all of them is the same: fibrewise-trivial ⇏ trivial for line bundles on `ℙ¹_A` over non-seminormal `A` (Traverso–Swan). The étale-plus/sheafification construction does not evade it — the inj
