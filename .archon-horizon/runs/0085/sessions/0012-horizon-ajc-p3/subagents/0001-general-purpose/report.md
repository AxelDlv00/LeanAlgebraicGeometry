## 1. Exact statement

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161-169`

```
noncomputable def pic0RepresentableByOfCharts
    {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (hf : ∀ i, IsOpenImmersion.presheaf (f i))
    [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)] :
    (pic0TypeFunctor C).RepresentableBy (Over.mk (...homEquiv (𝟙 ...glued)).1)
```
Section binders: `{k}[Field k] (C : Over (Spec (.of k)))`, `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` (:50-52), `[GeometricallyReduced C.hom]` (:79).

**It does not represent `picEt`.** It represents `pic0TypeFunctor C` (:58) = `pic0Functor C ⋙ forget₂ ⋙ forget`, and `pic0Functor` (`Pic0Functor.lean:151`) is the **degree-zero subgroup subfunctor** `pic0Subgroup` (`Pic0Functor.lean:107`, "degree zero at every field point") of AJCR's `picEtFunctor`. Slice-valued, `(Over (Spec (.of k)))ᵒᵖ ⥤ Type u`. The *sheaf* consumed is a Σ-extension onto `Scheme.{u}ᵒᵖ` (`:76`, `pic0SigmaSheaf` :147).

## 2. Antecedents: no producer for either

- `hf`: sources are `isOpenImmersion_presheaf_yoneda_map` (`Pic0ChartPair.lean:105`, only for `yoneda.map g` — not a chart), `isOpenImmersion_presheaf_of_chartFibrePresented` (`Pic0ChartOpenImmersionCriterion.lean:199`, assumed datum), and `..._of_restrictedChartFibre_top` (`Pic0ChartRestrictedFibreSat.lean:343`). The latter needs `RestrictedChartFibre … ⊤`, equivalent to `IsChartLocusFibre` (`:384`), for which the tree has **only refutations**: `Pic0ChartAbelNonInjective.lean:201,219`, `Pic0ChartCoverForcesNonInj.lean:279`, `Pic0ChartAbelForkReduce.lean:456`. The one positive producer is at `⊥` (`:195`) — **no producer**.
- `IsLocallySurjective`: `isLocallySurjective_sigmaDesc` (`Pic0ChartLocalSurjectivity.lean:105`) from `ChartsCoverLocally`, whose producers are three reductions with assumed data (`Pic0ChartCoveragePointwise.lean:133`, `Pic0ChartCoverageAffineTest.lean:155`, `Pic0ChartCoverageSlice.lean:200`) plus one degenerate case its own docstring calls non-geometric (`:128`). Refuted at `⊥`: `Pic0ChartBotRefute.lean:245`. **No producer.**
- AJCR itself records that `∃ V` with **both** clauses "has never been measured at any `V`" (`Pic0ChartRestrictedFibreSat.lean:327`). Consistent with my grep: **zero** `Nonempty (JacobianData C)` anywhere in AJCR.

## 3. Sorry-free: verified

`grep -n sorry` on the file: 0 hits. Import closure = 135 local files; sorries appear only in `Challenge.lean` (16 code sorries). `lake env lean` on `/tmp/ajcp3probe/probe.lean`, EXIT=0: all three of `pic0RepresentableByOfCharts`, `pic0SigmaFunctor_isSheaf`, `pic0SigmaSheaf` report `[propext, Classical.choice, Quot.sound]` — **no `sorryAx`**. Genuinely sorry-free and axiom-clean; it is a conditional whose antecedents are unfilled.

## 4. Carrier: confirmed different, three ways

AJC `picEt` (`PicEtSheaf.lean:264`) = `(PicSharp.etaleSheaf C).obj ⋙ forget AddCommGrpCat`, a categorical `toSheafify` (`:222`) for `etaleTopologyOver k`, valued in `Type (u+1)`, **full** Pic. AJCR `picEt` (`PicEt.lean:105`) = `picEtSubgroup` (`:91`), a subgroup of `Π U : T.left.affineOpens, PicEtAff C Γ(T.left,U)` where `PicEtAff` (`PicEtAff.lean:218`) is a `Quotient` of a **one-step étale plus**; `Type u`. AJCR contains no `sheafify` for `picEt` and no iso to one (grep). Mismatches: (a) construction; (b) universe `Type u` vs `Type (u+1)`; (c) **the target is Pic⁰, not Pic** — and AJC has *no* degree-zero subfunctor of `picEt` at all (its only `Pic0` names are `Pic0SchemeEt`, `Pic0Et.lean:81`, and `Pic0Scheme`, `IdentityComponent.lean:1386`, identity components of an already-representing scheme). Transport is not available: even with antecedents granted, the conclusion is about a different functor of a different Pic in a different universe.

## 5. Import: impossible

Both `lakefile.toml`s declare `name = "AlgebraicJacobian"` and `[[lean_lib]] name = "AlgebraicJacobian"`; identical toolchain v4.31.0 and mathlib rev `fabf563a7c95`; shared `packagesDir = "../../.lake-packages"`; **no `require` edge either way**. The name collision makes coexistence as dependencies impossible. Reuse = transcription.

## Bottom line

**Not a real option, and you do not need it.** AJC already has its own 01JJ wrapper, `Scheme.representable_of_openCover` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean:1352`), sorry-free (its single `sorry` hit is docstring prose at `:26`) — and it is **strictly stronger where it matters**: it *proves* both of the antecedents the sibling assumes, `chart_presheaf` (`:1140`) and `isLocallySurjective_chart` (`:1153`), from a Zariski-sheaf-over-`S` plus local-representability hypothesis. Transcribing the sibling engine would buy AJC an unconditional theorem it already has, in a shape whose two open antecedents AJC would then owe from scratch, about a Pic⁰ functor AJC has never defined. Caveat on the AJC engine: it is universe-pinned (`{S : Scheme.{0}}`, `F : (Over S)ᵒᵖ ⥤ Type 1`), so applying it to `picEt C : … ⥤ Type (u+1)` needs the `u = 0` instance or a generalisation — that, not transcription, is where AJC's seam work sits.
