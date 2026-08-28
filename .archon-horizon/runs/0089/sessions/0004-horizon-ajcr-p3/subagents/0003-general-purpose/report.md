## 1. `IsOpenImmersion.presheaf` — mathlib, and what it unfolds to

Not a project declaration. It is **dot-notation on the morphism property** `@IsOpenImmersion : MorphismProperty Scheme` resolving to `MorphismProperty.presheaf`.

`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/MorphismProperty/Representable.lean:328`
```lean
abbrev presheaf : MorphismProperty (Cᵒᵖ ⥤ Type v₁) := P.relative yoneda
```
`:315`
```lean
def relative : MorphismProperty D :=
  fun X Y f ↦ F.relativelyRepresentable f ∧
    ∀ ⦃a b : C⦄ (g : F.obj a ⟶ Y) (fst : F.obj b ⟶ X) (snd : b ⟶ a)
      (_ : IsPullback fst (F.map snd) f g), P snd
```
`:103`
```lean
def Functor.relativelyRepresentable : MorphismProperty D :=
  fun X Y f ↦ ∀ ⦃a : C⦄ (g : F.obj a ⟶ Y), ∃ (b : C) (snd : b ⟶ a)
    (fst : F.obj b ⟶ X), IsPullback fst (F.map snd) f g
```

So CHART-U(c) is **not** "mono + local on target" and **not** a bare `RelativelyRepresentable`; it is the conjunction: (i) `yoneda.relativelyRepresentable (restrictChart (abelSigmaChart …) V)` — every fibre product against a representable test is again representable by a scheme; (ii) every represented pullback `snd` is `IsOpenImmersion`. `IsOpenImmersion` is `MorphismProperty` there via the instances at `Mathlib/AlgebraicGeometry/OpenImmersion.lean:768` (`IsStableUnderComposition`), `:771` (`RespectsIso`), `:782` (`IsStableUnderBaseChange`), `:490` (`le_monomorphisms`).

Reducing lemmas actually available: `MorphismProperty.relative.of_exists` (Representable.lean:351 — needs `F.Full/Faithful/P.RespectsIso`, reduces to *some* pullback per test point), `relative_of_snd` (:361), `relative_map` (:369), `relative_isStableUnderComposition` (:400), `presheaf_mono_of_le` (:442), `presheaf_monomorphisms_le_monomorphisms` (:426).

## 2. Partial results in the tree

**Landed, unconditional (project):**
- `isOpenImmersion_presheaf_yoneda_map` — `Pic0ChartPair.lean:103`; `{X Y : Scheme.{u}} (g : X ⟶ Y) [IsOpenImmersion g] : IsOpenImmersion.presheaf (yoneda.map g)`, by `MorphismProperty.relative_map`.
- `restrictChart` — `Pic0ChartPair.lean:120`; `(f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (V : X.Opens) : yoneda.obj (V : Scheme.{u}) ⟶ (pic0SigmaSheaf C).1 := yoneda.map V.ι ≫ f`.
- `isOpenImmersion_presheaf_restrictChart` — `:139`; `(V : X.Opens) (hfV : IsOpenImmersion.presheaf f) : IsOpenImmersion.presheaf (restrictChart f V)`. **Composition half only** — it consumes the unrestricted certificate.
- `chartHom_restrictChart` — `:204`.
- `mono_of_isOpenImmersion_presheaf` — `Pic0ChartOpenImmersionCriterion.lean:90`; `(hf : IsOpenImmersion.presheaf f) : Mono f`.
- `injective_of_isOpenImmersion_presheaf` — `:103`; `… (T : Scheme.{u}ᵒᵖ) : Function.Injective (f.app T)`.
- `ChartFibrePresented` (structure) — `:129`; `isPullback` — `:156`; `isOpenImmersion_presheaf_of_chartFibrePresented` — `:195`:
```lean
theorem isOpenImmersion_presheaf_of_chartFibrePresented {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (D : ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
      ChartFibrePresented C f g) :
    IsOpenImmersion.presheaf f
```
  This is the **only** criterion in the tree; it discharges both clauses at once, via `relative.of_exists`, with `W.ι` supplying the property clause for free.
- `isEmpty_forall_chartFibrePresented_of_not_injective` — `:219`; `injective_of_chartFibrePresented` — `:231`.
- `chartLocusOpens` — `Pic0ChartUnivReduce.lean:115` (takes `haff`); `chartLocusOpens'` — `Pic0ChartCoverageAbel.lean:142`; `ChartLocusAffineLocal` — `:132`; `chartLocusAffineLocal_of_presentation` — `:182`.
- `abelChartApp_eq` — `Pic0ChartCoverageAbel.lean:105`; the Abel chart's value is `⟨x ≫ D.hom, ⟨chartValue …, _⟩⟩` (`rfl`).
- `chartLocusOpensOfPlusFibre` — `Pic0ChartLocusPlusFibre.lean:173`; `chartLocusOpensOfIsPlusHonest` — `Pic0ChartPlusFibreProducer.lean:334` (**`haff` genuinely produced from `IsPlusHonest`**, `isOpen_chartLocus_of_isPlusHonest`, `:317`).
- `abelSigmaChart` — `Pic0AtlasFromDivRep.lean:205`; `chartHom_abelSigmaChart` — `:219`.

**Names asked about that do not exist:** `chartMono` — zero hits tree-wide. `isChartLocusFibre_of_isChartUniv` (`Pic0ChartUnivReduce.lean:55` advertises it) — **does not exist**; the only converse landed is `injective_of_isChartUniv` (`:191`). `chartLocusOpens_of_affineLocal` (advertised `Pic0ChartCoverageAbel.lean:66`) — **does not exist**; only `chartLocusOpens'`. `ChartFibrePresented.fibre_injective` (cited `Pic0ChartOpenImmersionCriterion.lean:98`) — **does not exist**; the field is `exists_factor`.

**A pricing defect, load-bearing.** `IsChartLocusFibre` (`Pic0ChartUnivReduce.lean:152`) is stated about the **unrestricted** `abelSigmaChart`, and `chartLocus` appears nowhere in its body:
```lean
def IsChartLocusFibre … : Prop :=
  ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
    Nonempty (ChartFibrePresented C (abelSigmaChart C π n rep m Z hdeg) g)
```
The `W` field of each `ChartFibrePresented` is an arbitrary `T.Opens`, never pinned to `chartLocusOpens`. So the docstring at `:138` ("`ChartFibrePresented` with its `W` field already discharged — it is `chartLocus`") does not describe the Lean statement. Consequence: `isChartUniv_of_isChartLocusFibre` (`:170`) routes through `isOpenImmersion_presheaf_of_chartFibrePresented _ …` at the unrestricted chart, then `isOpenImmersion_presheaf_restrictChart` — i.e. it is the same route as `isChartUniv_of_unrestricted` (`Pic0ChartPair.lean:184`), whose hypothesis the same tree calls **false** (`Pic0AtlasFromDivRep.lean:54-57`, `Pic0ChartPair.lean:134`). By the tree's own `injective_of_chartFibrePresented` (`:231`), `IsChartLocusFibre` implies the unrestricted Abel chart is injective on every test. So the "reduction from four fields to three" asks for strictly more than CHART-U(c) as prosed, and is unsatisfiable if the tree's `|D|`-fibre claim holds. Nobody proves `¬ Function.Injective` for the Abel chart, so the falsity is asserted, not measured.

## 3. GAP-2 and its relative form

`AlgebraicJacobian/RiemannRoch/EffectiveUniqueness.lean:144`:
```lean
theorem CurveDivisor.eq_of_picClass_eq_of_h0_one {D D' : X.CurveDivisor}
    (hD : 0 ≤ D) (hD' : 0 ≤ D')
    (hcl : CurveDivisor.picClass K D = CurveDivisor.picClass K D')
    (hone : Sheaf.h0 (X.divisorSheaf K D) = 1) :
    D' = D :=
  CurveDivisor.eq_of_picClass_eq_of_finrank_one K hD hD' hcl
    ((finrank_divisorSections_top K D).trans hone)
```
Section context (`:50`, `:79`): `variable (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]` plus `[LocallyOfFiniteType (X ↘ …)] [QuasiCompact (X ↘ …)]`. Worker form: `eq_of_picClass_eq_of_finrank_one`, `:111`. File is sorry-free. `K` is a **field**; the base is a point.

**The relative form is ABSENT.** Evidence: `rg` over `eq_of_picClass`, `uniqueEffective`, `relUnique`, `familyUnique`, `InjOn`, `unique.*effective` yields only (a) the field-level EffectiveUniqueness pair above, (b) `h0/h1/chi_divisorSheaf_eq_of_picClass_eq` (`ClassCohomology.lean:89,98`, `Degree.lean:80` — cohomology invariance, not divisor uniqueness), (c) `existsUnique_effective_divisor_of_carve` (`PFib.lean:241`) / `…_pack` (`PFibPack.lean:368`) / `…_divUniversalFibre_seedPrime` (`DivSchemeSeedUnivFields.lean:109`) — all at a field / at a residue field of a seed prime, and about window-carve data, not about equal `picClass`, (d) `divFamDivisor_injective` (`DivisorFamilyFieldEquiv.lean:178`, `[Field K]`), `eq_of_divFamEps_fst_eq` (`DivisorFamilyEpsMono.lean:378`, field level). Only three files mention "relative form of GAP-2" and all three are the C9b docstrings themselves (`Pic0ChartPair.lean:165`, `Pic0ChartUnivReduce.lean:27,146,187`, `Pic0ChartOpenImmersionCriterion.lean:13,101,192`) — prose, no statement.

Closest *relative* uniqueness that does exist, over an arbitrary affine test `S`: `eq_of_isDivRepClassify` (`DivRepClassifyZarSep.lean:352`) and `divRepClassifyZar_injective` (`:414`, `Function.Injective (divRepClassifyZar …)`). Different statement — same classifying morphism ⇒ same `DivFamZar` class — but it is the only family-level separation theorem in the tree and is the natural donor.

## 4. The structure and its `exists_factor`

`exists_factor` is a field of **`ChartFibrePresented`**, not of `IsChartLocusFibre`. `Pic0ChartOpenImmersionCriterion.lean:129`:
```lean
structure ChartFibrePresented {X T : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1)
    where
  W : T.Opens
  r : (W : Scheme.{u}) ⟶ X
  sq : yoneda.map r ≫ f = yoneda.map W.ι ≫ g
  exists_factor : ∀ (S : Scheme.{u}) (v : S ⟶ X) (w : S ⟶ T),
    f.app (op S) v = g.app (op S) w → ∃ u : S ⟶ (W : Scheme.{u}), u ≫ r = v ∧ u ≫ W.ι = w
```
Fields produced today: **none, in the structure**. `rg "ChartFibrePresented"` returns only the definition site, `isPullback`, the criterion, the two non-vacuity lemmas, and `IsChartLocusFibre`'s use — **zero constructions** (`… where` / anonymous constructor: none).

- `W`: only the *shape* exists, and only for the test side — `chartLocusOpens` (`Pic0ChartUnivReduce.lean:115`, argument `haff`), `chartLocusOpens'` (`Pic0ChartCoverageAbel.lean:142`), `chartLocusOpensOfPlusFibre` (`Pic0ChartLocusPlusFibre.lean:173`), and `chartLocusOpensOfIsPlusHonest` (`Pic0ChartPlusFibreProducer.lean:334`) which discharges `haff` outright from `IsPlusHonest`. None is ever fed to a `ChartFibrePresented`.
- `r`: **the classifier's `r` is not produced anywhere.** `divRepClassifyZar` (`DivRepClassifyZar.lean:244`) has type `overSpec k S ⟶ divSchemeOver k … g r₁ r₂ b₁ …` with `{S : Type u} [CommRing S] [Algebra k S]` — an *affine* test into the concrete `DivScheme`, not `(W : Scheme) ⟶ X` for the abstract `X = D.left` of a `rep : (divFunctor C π n).RepresentableBy D`. Its field-point specialisation is `effectiveDivisorClassifyZar` (`DivisorFamilyFieldSurj.lean:217`, `[Field K]`). The general-test classifier exists as `classifyGlobal` (`DivRepGlobalClassify.lean:204`, `(F : divFamZar C pi g T) : T ⟶ DivOver`) but it goes *out of the test into the divisor scheme* — no restriction to an open of the test, and it is a `DivRepAffinePullback`-conditional. Nothing bridges either to `r`.
- `sq`, `exists_factor`: no producer, no partial.

## 5. Is `IsChartUniv` ever discharged?

No unconditional discharge; exactly **two** theorems conclude it, both hypothetical, both in sorry-free files:

`Pic0ChartPair.lean:184`
```lean
lemma isChartUniv_of_unrestricted … (V : D.left.Opens)
    (h : IsOpenImmersion.presheaf (abelSigmaChart C π n rep m Z hdeg)) :
    IsChartUniv C π n rep m Z hdeg V
```
`Pic0ChartUnivReduce.lean:170`
```lean
theorem isChartUniv_of_isChartLocusFibre … (h : IsChartLocusFibre C π n rep m Z hdeg)
    (V : D.left.Opens) : IsChartUniv C π n rep m Z hdeg V
```
Both hypotheses are unproduced anywhere; as noted in §2 they are the *same* hypothesis up to `isOpenImmersion_presheaf_of_chartFibrePresented`. Consumers only: `isOpenImmersion_presheaf_mixedParamChart` (`Pic0ChartAtlasParamFree.lean:110`) and `injective_of_isChartUniv` (`Pic0ChartUnivReduce.lean:191`). No `sorry`-reachable discharge exists — every file in the chain has zero real `sorry`.

Related, unread advisory worth folding into any price: **I-0861** (review-ajcr, run 0082) records that `IsChartUniv`'s `V` is a free `D.left.Opens` while coverage (`chartsCoverLocally_of_pointwise`, `Pic0ChartCoveragePointwise.lean:128`) needs points into the *same* `V`, and nothing states the coupling; at `ι = PEmpty` or `V = ⊥` the `hf` antecedent is vacuous.

## 6. `sorry` counts (`grep -c 'sorry'`, files touched)

Every nonzero count below is **prose in a docstring only** (verified by `grep -n`); no file in the chain contains a real `sorry`.

| file | count |
|---|---|
| `AlgebraicJacobian/Picard/Pic0ChartPair.lean` | 1 (prose, `:29`) |
| `AlgebraicJacobian/Picard/Pic0ChartOpenImmersionCriterion.lean` | 0 |
| `AlgebraicJacobian/Picard/Pic0ChartUnivReduce.lean` | 0 |
| `AlgebraicJacobian/Picard/Pic0ChartCoverageAbel.lean` | 0 |
| `AlgebraicJacobian/Picard/Pic0ChartLocusPlusFibre.lean` | 0 |
| `AlgebraicJacobian/Picard/Pic0ChartPlusFibreProducer.lean` | 1 (prose, `:52`) |
| `AlgebraicJacobian/Picard/Pic0ChartLocusIsOpen.lean` | 3 (prose, `:99,:102,:238`) |
| `AlgebraicJacobian/Picard/Pic0ChartPresentationConverse.lean` | 1 (prose, `:249`) |
| `AlgebraicJacobian/Picard/JacobianDataAbelSquare.lean` | 1 (prose, `:23`) |
| `Pic0ChartLocus.lean`, `Pic0ChartLocusIsoInvariance.lean`, `Pic0ChartLocusGeneralTest.lean`, `Pic0ChartAtlasParamFree.lean`, `Pic0AtlasFromDivRep.lean`, `Pic0ChartCoverageNoDrop.lean`, `Pic0ChartCoverageTest.lean`, `Pic0ChartCoverageFibre.lean`, `Pic0ChartCoverageIndexSlack.lean`, `Pic0ChartCoveragePointwise.lean`, `Pic0ChartHonest.lean`, `Pic0ChartLocalSurjectivity.lean`, `Pic0ChartTestPoint.lean`, `Pic0ChartPresentationHalf.lean`, `Pic0SigmaSheaf.lean`, `DivRepClassifyZar.lean`, `DivRepClassifyZarSep.lean`, `DivRepChartRange.lean`, `DivRepGlobalLift.lean`, `DivRepGlobalClassify.lean`, `DivRepKit.lean`, `DivisorFamilyFieldSurj.lean`, `DivisorFamilyFieldEquiv.lean`, `DivisorFamilyEpsMono.lean`, `RiemannRoch/EffectiveUniqueness.lean` | 0 each |

## Net price of CHART-U(c)

Two clauses, and the criterion that reduces both is landed and non-vacuous. What is genuinely owed:
1. a per-test-point `ChartFibrePresented` at `abelSigmaChart` — **zero constructions exist**;
2. within it, `r`: a morphism `(W : Scheme) ⟶ D.left` from the classifier — the classifier exists only as `overSpec k S ⟶ divSchemeOver …` (affine test → concrete `DivScheme`), never as an open-of-test → abstract representing object; no bridge in the tree;
3. `exists_factor`: the relative GAP-2 — **absent**, only the field-level `eq_of_picClass_eq_of_h0_one`; the nearest relative donor is `eq_of_isDivRepClassify` / `divRepClassifyZar_injective` over an affine `S`;
4. **before any of that**, a statement-level repair: `IsChartLocusFibre` as written quantifies over the *unrestricted* chart with a free `W`, so discharging it entails the unrestricted certificate the tree calls false. The obligation that actually corresponds to CHART-U(c) — the datum at `V = chartLocus`, with `W` pinned to `chartLocusOpens` — is not stated in Lean anywhere.

Clause (i)'s `W` cost is the one thing genuinely paid: `chartLocusOpensOfIsPlusHonest` (`Pic0ChartPlusFibreProducer.lean:334`) produces the open from `IsPlusHonest` alone, no certificate, no divRep.
