The census is complete. Here is the map.

# The CHART/ATLAS route to `pic0TypeFunctor` representability

## 0. Keystone and the two-clause split (context)

`AlgebraicGeometry.pic0RepresentableByOfCharts` — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161`. Verbatim as you quoted. Three inputs: `f`, `hf`, and the `IsLocallySurjective` instance on `Sigma.desc f`.

`hf` decomposes via `Pic0ChartOpenImmersionCriterion.lean:174` (`isOpenImmersion_presheaf_of_chartFibrePresented`) into a `ChartFibrePresented` datum with fields `W : T.Opens`, `r`, `sq`, `exists_factor` (structure at `:129`). Necessary direction is landed and load-bearing: `mono_of_isOpenImmersion_presheaf` (`:91`) and `injective_of_isOpenImmersion_presheaf` (`:104`).

---

## 1. Declarations that CONSTRUCT an `f` of the keystone's shape

There are exactly **six** definitions in the project whose type is `yoneda.obj _ ⟶ (pic0SigmaSheaf C).1` (verified by grepping the return type; nothing else has this shape).

### 1a. `abelSigmaChart` — the chart-typed Abel map
`AlgebraicJacobian/Picard/Pic0AtlasFromDivRep.lean:205`
```lean
def abelSigmaChart {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) :
    yoneda.obj D.left ⟶ (pic0SigmaSheaf C).1 :=
  rep.toSigmaExtension ≫ Over.sigmaExtensionNat (chartValueTrans C π n m Z hdeg)
```
Section binders: `[Field k] {C : Over (Spec (.of k))} {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`.

Hypotheses and their producer status:
- `rep : (divFunctor C π n).RepresentableBy D` — **binder, no unconditional producer at general `n`.** The only routes are U2-gated:
  - `divFunctor_representableBy_of_chartClause` (`DivRepAffPullClause.lean:490`) — takes `hU : DivRepChartFamily.IsChartClause …`; `IsChartClause` has no producer (U2 / G-4 certificate).
  - `divFunctor_representableBy_of_id` (`DivRepAffPullClause.lean:510`) — takes `hid : ∀ i j, IsDivRepClassify …`; no producer.
  - `divFunctor_representableBy_of_chartRange` (`DivRepChartRange.lean:220`) — takes `hrange : ∀ i j, ∃ F, (divRepClassifyZar …).left = ChartMap i j`; no producer.
  - `DivRepAffinePullback.representableBy` (`DivRepGlobalClassify.lean:306`) and `DivRepGlobalData.representableBy` (`DivRepKit.lean:113`) — both take an unwitnessed structure. All five additionally require `hO : Sheaf.h0 … = 1`, `hchi : Sheaf.chi … = 1 - g`, `hpi`, and are pinned at `g` only.
  - **The one exception is at `n = 0`**: `divFunctorZeroRepresentableBy` (`DivisorFamilyDegreeZeroRep.lean:227`), sorry-free and unconditional in the curve's binders.
- `hdeg` — dischargeable arithmetic; `chartIndex_of_isDegree` gives it from `IsDivisorDegree C n`.

### 1b. `abelSigmaChartZero` — the only chart with NO `rep` binder
`AlgebraicJacobian/Picard/DivisorFamilyDegreeZeroUseSite.lean:86`
```lean
noncomputable def abelSigmaChartZero
    [IsIntegral (C ⊗ overSpec k k).left]
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (0 : ℕ)) :
    yoneda.obj (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left ⟶ (pic0SigmaSheaf C).1 :=
  abelSigmaChart C pi 0 divFunctorZeroRepresentableBy m Z hdeg
```
All hypotheses discharged: `rep` by `divFunctorZeroRepresentableBy`. But the source is terminal (`Spec k`), and its `Opens` lattice is `{⊥, ⊤}` (`opens_eq_bot_or_top_of_terminalRep`, used at `Pic0ChartMonoUnconditional.lean:115`).

### 1c. `abelSigmaChartAff` — the R2/widened carrier (I-0492)
`AlgebraicJacobian/Picard/Pic0AtlasFromDivRepAff.lean:114`
```lean
def abelSigmaChartAff {D : Over (Spec (.of k))}
    (rep : (divFunctorAff C n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) :
    yoneda.obj D.left ⟶ (pic0SigmaSheaf C).1 :=
  rep.toSigmaExtension ≫ Over.sigmaExtensionNat (chartValueAffTrans C n m Z hdeg)
```
`(divFunctorAff C n).RepresentableBy` has **zero producers** in the tree (grep-verified: every occurrence is a binder).

### 1d. `mixedParamChart` — the heterogeneous restricted atlas
`AlgebraicJacobian/Picard/Pic0ChartAtlasParamFree.lean:86`
```lean
def mixedParamChart {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens) (i : ι) :
    yoneda.obj ((V i : Scheme.{u})) ⟶ (pic0SigmaSheaf C).1 :=
  restrictChart (abelSigmaChart C π (nn i) (rep i) (m i) (Z i) (hdeg i)) (V i)
```
Same `rep` gap, per index. Its `hf` clause is *definitionally* per-index `IsChartUniv` (`isOpenImmersion_presheaf_mixedParamChart`, `:103`, proof is `huniv i`).

### 1e. `restrictChart` — the generic restriction
`AlgebraicJacobian/Picard/Pic0ChartPair.lean:120`. Takes an `f` and `V : X.Opens`; `yoneda.map V.ι ≫ f`. Unconditional.

### 1f–1g. Probe/witness families (not real charts)
- `duplicatedSpecFamily` (`Pic0ChartMultiIndexInterval.lean:538`) and `satFam` (`:587`), built from `yonedaEquiv.symm (specSigmaSectionTaut C)` (`Pic0ChartCoverForcesNonInj.lean:302`). Unconditional, but deliberate non-vacuity witnesses; one member has an empty source.

**Bottom line for point 1**: the `rep` slot is inhabited at exactly one parameter, `n = 0`, and nowhere else.

---

## 2. Producers of `IsOpenImmersion.presheaf (abelSigmaChart …)` / `IsChartUniv`

### `IsChartUniv`, verbatim
`AlgebraicJacobian/Picard/Pic0ChartPair.lean:173`
```lean
def IsChartUniv {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens) : Prop :=
  IsOpenImmersion.presheaf (restrictChart (abelSigmaChart C π n rep m Z hdeg) V)
```

### Complete census of `IsChartUniv` producers (5, exhaustive)

| declaration | file:line | hypothesis |
|---|---|---|
| `isChartUniv_of_unrestricted` | Pic0ChartPair.lean:184 | `IsOpenImmersion.presheaf (abelSigmaChart …)` unrestricted |
| `isChartUniv_antitone` | Pic0ChartVMonotone.lean:152 | `IsChartUniv … V` and `U ≤ V` |
| `isChartUniv_bot` | Pic0ChartRestrictedFibreSat.lean:232 | **none — but `V = ⊥` only** |
| `isChartUniv_of_isChartLocusFibre` | Pic0ChartUnivReduce.lean:184 | `IsChartLocusFibre C π n rep m Z hdeg` |
| `isChartUniv_of_restrictedChartFibre` | Pic0ChartRestrictedFibre.lean:158 | `RestrictedChartFibre … V` |

**There is no unconditional producer of `IsChartUniv` at any useful `V`.** `isChartUniv_bot` is unconditional and worthless: the coverage side is refuted at `⊥` (`not_isLocallySurjective_restrictChart_bot'`, `Pic0ChartBotRefute.lean:225`, unconditional, for *every* chart family), and `isLocallySurjective_of_bot`'s antecedent is therefore uninhabitable (`false_of_isLocallySurjective_bot`, `Pic0ChartBotRefute.lean:262`).

### `IsOpenImmersion.presheaf (abelSigmaChart …)` unrestricted — 3 producers
- `isOpenImmersion_presheaf_abelSigmaChart_of_isChartLocusFibre` (Pic0ChartLocusFibreGuard.lean:122) — from `IsChartLocusFibre`.
- `isOpenImmersion_presheaf_abelSigmaChart_of_restrictedChartFibre_top` (Pic0ChartRestrictedFibreSat.lean:337) — from `RestrictedChartFibre … ⊤`; and `restrictedChartFibre_top_iff` (`:378`) makes these two *equivalent*, so they are one obligation.
- `isOpenImmersion_presheaf_abelSigmaChart_of_mono_of_cov` (Pic0ChartSeamPairDecided.lean:529):
```lean
theorem isOpenImmersion_presheaf_abelSigmaChart_of_mono_of_cov {n : ℕ}
    {D : Over (Spec (.of k))} (rep : (divFunctor C pi n).RepresentableBy D) [Mono D.hom]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (abelSigmaChart C pi n rep m Z hdeg)) :
    IsOpenImmersion.presheaf (abelSigmaChart C pi n rep m Z hdeg)
```
This is the cheapest structural route: given coverage, `hf` costs only `Mono D.hom` — no `ChartFibrePresented`, no relative GAP-2.

### The `IsChartLocusFibre` residue and its unsatisfiability fork
`Pic0ChartUnivReduce.lean:166`:
```lean
def IsChartLocusFibre {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : … ) : Prop :=
  ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
    Nonempty (ChartFibrePresented C (abelSigmaChart C π n rep m Z hdeg) g)
```
Note it is stated for the **unrestricted** chart and `chartLocus` appears nowhere in it (the file's own retraction at `:138`). Hence `not_isChartLocusFibre_of_not_injective` (Pic0ChartLocusFibreGuard.lean:163) and `not_isChartLocusFibre_of_points` (Pic0ChartAbelNonInjective.lean:196): if the `|D|` non-injectivity headers are right, this predicate is **unsatisfiable** and its reduction can never fire. The fork is *decided in the negative for those headers* at `n = 0` — `injective_abelSigmaChartZero` (Pic0ChartMonoUnconditional.lean:82) proves the chart *is* injective there, unconditionally.

### Clause (i) — the `W` field / chart-locus openness — IS discharged
This is the one certificate half fully paid, and only on the widened carrier:
- `isOpen_chartLocus_of_isPlusHonest` (Pic0ChartPlusFibreProducer.lean:316) — from `IsPlusHonest`.
- `abelDiv_isPlusHonest` (Pic0ChartPlusFibreProducer.lean:275) and `chartTwist_isPlusHonest` (`:294`) — **unconditional producers of `IsPlusHonest` for chart values**.
- `chartValueAff_isPlusHonest` (Pic0ChartHonestAff.lean:160), `chartLocusAffineLocal_chartValueAff` (`:205`), `chartLocusOpensChartValueAff` (`:221`) — `haff` produced, not passed through, for the widened chart value.

So the `haff` gate the tree repeatedly prices at "dat-b B-4" is closed for chart values. `chartLocusOpens` (Pic0ChartUnivReduce.lean:115) still carries `haff` as an argument, and its docstring's "nothing in the tree produces `haff`" is stale.

---

## 3. Producers of `Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc …)`

### The reduction chain (all sorry-free, all conditional)
```lean
-- Pic0ChartLocalSurjectivity.lean:86
def ChartsCoverLocally {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) : Prop :=
  ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)),
    (⨆ i, Presheaf.imageSieve (f i) s) ∈ Scheme.zariskiTopology T
```
- `isLocallySurjective_sigmaDesc` (Pic0ChartLocalSurjectivity.lean:103) — `ChartsCoverLocally C f → the instance`. The site-theoretic bookkeeping, unconditional in itself.
- `chartsCoverLocally_of_pointwise` / `isLocallySurjective_sigmaDesc_of_pointwise` (Pic0ChartCoveragePointwise.lean:128 / :145) — from per-point `(W, t ∈ W, i, x, class-equation)` data. Converse landed (`pointwise_of_chartsCoverLocally`, `:173`), so not a strengthening.
- `chartsCoverLocally_of_affineLocal` / `isLocallySurjective_sigmaDesc_of_affine` (Pic0ChartCoverageAffineTest.lean:150 / :181) — the same with `[IsAffine Y]` added. Converse at `:200`.
- `isLocallySurjective_restrictChart_of_pointwise` (Pic0ChartAtlasCoupling.lean:165) — the *restricted* atlas form; costs the extra `Set.range x.base ⊆ Set.range ((V i).ι.base)`. Converse `pointwise_of_pointwise_restrictChart` (`:196`) shows `hV` is exactly the difference.
- `isLocallySurjective_of_slice` (Pic0ChartCoverageSlice.lean:216) — the cheapest measured form, at the one-chart Abel family, from affine-test slice data. Its residue is one class equation = a spreading-out.
- `chartsCoverLocally_of_forall_surjective` (Pic0ChartLocalSurjectivity.lean:125) — non-vacuity check only (needs one chart surjective on every test).
- Monotonicity: `isLocallySurjective_sigmaDesc_mono` (Pic0ChartVMonotone.lean:200), `isLocallySurjective_unrestricted` (`:254`) — restricting `V` never weakens coverage.

### The one place the seam actually FIRES, and its gate
`AlgebraicJacobian/Picard/Pic0ChartSeamPairDecided.lean:496`
```lean
theorem exists_representableBy_pic0TypeFunctor_of_subsingleton
    (pi' : C.left ⟶ P1 k) [IsAffineHom pi']
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (hvan : ∀ S : Over (Spec (.of k)), Subsingleton (pic0Subgroup C S)) :
    ∃ J : Over (Spec (.of k)), Nonempty ((pic0TypeFunctor C).RepresentableBy J)
```
This is the **only** declaration in the project that reaches `pic0RepresentableByOfCharts` with all three inputs supplied. It supplies the `Sigma.ι_desc` factorisation the instance needs (an earlier claim without it was false — the instance is on `Sigma.desc f`, not `f`).

Its gate is decided, sharply and both ways:
```lean
-- Pic0ChartSeamPairDecided.lean:469
theorem isLocallySurjective_abelSigmaChartZero_iff (m Z hdeg) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
        (abelSigmaChartZero (C := C) (pi := pi) m Z hdeg)
      ↔ ∀ S : Over (Spec (.of k)), Subsingleton (pic0Subgroup C S)
```
Coverage at the terminal chart **is** the vanishing of `pic⁰` — i.e. the Jacobian being a point. Contrapositive at `:447` (`not_seamPair_abelSigmaChartZero_of_two_pic0`). So there are **no unconditional producers**, and the conditional ones at `n = 0` carry a hypothesis that is false for any positive-genus curve.

Non-atlas comparison (not part of the chart route, but the same hypothesis): `pic0RepresentableBy_terminal_of_subsingleton` (Pic0VanishingRoute.lean:175), `jacobianData_of_overSpec_subsingleton` (Pic0VanishingAffineReduction.lean:266), and the only *unconditional* instance of the hypothesis anywhere: `P1.subsingleton_pic0Subgroup_overSpec_field` (Pic0VanishingFieldTest.lean:172), at genus 0.

---

## 4. `sorry` census under `AlgebraicJacobian/`

**13 occurrences, in 2 files.** All others matching `sorry` are prose ("sorry-free", "sorry census").

`AlgebraicJacobian/Challenge.lean` (the mathematician-owned signature file, imported at `AlgebraicJacobian.lean:160`) — 12:

| line | declaration |
|---|---|
| 99 | `noncomputable def Jacobian` |
| 108 | `noncomputable instance instGrpObj : GrpObj (Jacobian C)` |
| 113 | `instance smoothOfRelativeDimension_genus` |
| 117 | `instance : IsProper (Jacobian C).hom` |
| 121 | `instance : GeometricallyIrreducible (Jacobian C).hom` |
| 126 | `noncomputable def ofCurve` |
| 134 | `theorem comp_ofCurve` |
| 147 | `theorem exists_unique_ofCurve_comp` |
| 157, 158, 159 | `noncomputable def Jacobian.functor` — fields `map`, `map_id`, `map_comp` |
| 248 | `noncomputable def baseChangeIso` |
| 259 | `theorem baseChangeIso_id` |
| 272 | `theorem baseChangeIso_comp` |
| 283 | `theorem baseChange_ofCurve` |

`AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean:76` — `theorem pic0Theta_comp` (`pic0Theta k M C = cocycleRHS k L M C`). **This file is not reachable from the root**, so this sorry is not in the root's import closure.

---

## 5. Modules not reachable from the root

Root is `AlgebraicJacobian.lean` (736 lines, all imports). Of 830 `.lean` files under `AlgebraicJacobian/`, **18 are unreachable — all 18 in `Picard/`**, none elsewhere:

```
DivSchemeFlatteningBridge          DivSchemeRedesignRDN
DivSchemeRedesignFlatIdealFibre    DivSchemeRedesignRangeFlatBridge
DivSchemeRedesignKappaZEquiv       DivSchemeRedesignRankOneChart
DivSchemeRedesignKappaZFibre       DivSchemeRedesignRankOneFibre
DivSchemeRedesignKappaZPurity      DivSchemeRedesignSeedFinish
DivSchemeRedesignKappaZSeed        DivSchemeSeedUnivSecondWindowMap
DivSchemeRedesignLocalIdealFibre   EntryIdeal.lean
DivSchemeRedesignPointPrime        Pic0ThetaCocycle
                                   Pic0ThetaCocycleIdentity
                                   ScratchChartLocal
```
Every module on the chart/atlas route surveyed above **is** rooted (verified: Pic0ChartPair, Pic0ChartUnivReduce, Pic0ChartRestrictedFibre(+Sat), Pic0ChartLocalSurjectivity, Pic0ChartCoveragePointwise, Pic0ChartCoverageAffineTest, Pic0ChartCoverageSlice, Pic0ChartAtlasCoupling, Pic0ChartSeamPairDecided, Pic0ChartPlusFibreProducer, Pic0ChartHonestAff, Pic0AtlasFromDivRepAff, DivisorFamilyDegreeZeroUseSite, Pic0ChartMonoUnconditional, Pic0ChartForkNegativeBranch, Pic0ChartLocusFibreGuard, Pic0ChartAbelNonInjective).

---

## Which brick is load-bearing

Three candidates, ranked by how many downstream obligations each unblocks:

1. **`(divFunctor C π n).RepresentableBy D` at some `n > 0`** — this is the single gate under items 1a, 1c, 1d simultaneously. Every chart in the tree except `abelSigmaChartZero` is a chart *shape*. All five existing routes bottom out in U2 / the G-4 certificate. At `n = 0`, where `rep` exists, the whole route is dead: the chart source is terminal, its `Opens` lattice is `{⊥, ⊤}` (`no_proper_open_abelSigmaChartZero`), and coverage there is *equivalent* to `pic⁰` vanishing.

2. **`Mono D.hom` on a representing object**, given a coverage producer — via `isOpen_chartLocus_of_mono_of_cov` (Pic0ChartSeamPairDecided.lean:529) this is the whole of antecedent 1: no `ChartFibrePresented`, no relative GAP-2. This is strictly cheaper than `IsChartLocusFibre`, whose satisfiability is itself in doubt (`not_isChartLocusFibre_of_not_injective`). Caveat: `Pic0ChartForkNegativeBranch.lean:278` refutes chart injectivity wherever an effective degree-`n` divisor has `2 ≤ h⁰`, so `Mono D.hom` is a real obligation about the divisor scheme — but a divisor-scheme obligation, not a Picard-functor one.

3. **The pointwise coverage datum** at an affine test in slice form (`isLocallySurjective_of_slice`, Pic0ChartCoverageSlice.lean:216) — one class equation, whose cost is a spreading-out: a divisor family over a *neighbourhood* from data at a *point*.

Two things worth noting against the roadmap's framing. Antecedent 1's clause (i) — the `W`/chart-locus field, repeatedly priced at "dat-b B-4 through `haff`" — is **actually closed** for chart values (`abelDiv_isPlusHonest` + `chartLocusAffineLocal_chartValueAff`, both unconditional); `chartLocusOpens`' docstring saying otherwise is stale. And `isChartUniv_bot`, the only unconditional `IsChartUniv`, is provably useless: its `V` is exactly where coverage is refuted for every chart family.
