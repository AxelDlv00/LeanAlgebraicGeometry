Investigation was complete when the status check arrived — nothing is unfinished. Report below, Q5 and Q2 first.

## Q5 (most important): AJCR has a sorry-free engine whose antecedents are ALSO undischarged

**No AJCR declaration concludes representability of a Picard-type functor with no undischarged hypothesis.** I checked every `RepresentableBy` occurrence in AJCR (~90 hits, ~25 files). Every conclusion sits under an explicit binder supplying either the chart pair `(f, hf)` plus the locally-surjective instance, or a `divFunctor` representation, or a `PicRepDatum`, or a `picDegLayerFunctor` representation (`ThetaShift.lean:227`). Grep for `Nonempty (… RepresentableBy` and `Functor.Representable` across AJCR returns **zero hits** — no unconditional existence assertion exists anywhere.

Three independent confirmations:
- **No `jacobianData` producer.** Only the hypothesis-taking `JacobianData.of*` constructors exist. `JacobianDataFromPicRepDatum.lean:49` says it outright: "It produces no `PicRepDatum`."
- **`PicRepDatum` is uninhabited.** It occurs only in its defining file, in `JacobianDataFromPicRepDatum` (as binder `d`), and in `PicRepColimitCompat`. No constructor application.
- **AJCR's `Jacobian` is itself a bare `sorry`** — `Challenge.lean:99`; 8 sorries in that file, 22 sorry-lines across AJCR/Picard.

## Q2: antecedents not inhabited; four call sites, all hypothesis-taking

**Call sites** (all under binders `hf : ∀ i, IsOpenImmersion.presheaf (f i)` and `[Presheaf.IsLocallySurjective …]`): `JacobianDataCharts.lean:187`, `:214` (binders at `:116`/`:117`), `Pic0ChartAtlasParamFree.lean:138` (binders at `:132`/`:133`). Confirmed by elaborated `#check`.

(a) **No chart family exists.** The sole chart source `abelSigmaChart` (`Pic0AtlasFromDivRep.lean:205`) takes `rep : (divFunctor C π n).RepresentableBy D` as a hypothesis — its docstring: "this file never constructs a representation of the divisor functor". Divisor representability is itself gated at every endpoint (`DivRepGlobalClassify.lean:306`, `DivRepAffPullClause.lean:482`/`:502`, `DivRepChartRange.lean:220`).

(b) **No `IsLocallySurjective` instance.** Both producers take coverage as a hypothesis (`Pic0ChartLocalSurjectivity.lean:106`, `Pic0ChartCoveragePointwise.lean:150`). The one unconditional discharge, `chartsCoverLocally_of_forall_surjective` (`:125`), is self-labelled non-geometric: "no single Abel chart is surjective on all tests".

(c) **`IsOpenImmersion.presheaf` never discharged for a chart** — pinned as an unproved `Prop` definition `IsChartUniv` (`Pic0ChartPair.lean:173`), and recorded as **FALSE** unrestricted (`Pic0AtlasFromDivRep.lean:54`): the Abel map has fibres `|D|`, so not even a monomorphism.

## Q1: axiom-clean, verbatim (EXIT=0)

```
'AlgebraicGeometry.pic0RepresentableByOfCharts' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.pic0SigmaFunctor_isSheaf' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.pic0SigmaSheaf' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.pic0TypeFunctor' depends on axioms: [propext, Classical.choice, Quot.sound]
```
No `sorryAx`. Genuine content is `pic0SigmaFunctor_isSheaf` (`Pic0SigmaSheaf.lean:90-142`) + mathlib 01JJ + `overSlice` (`OverSigmaExtension.lean:235`).

## Q3: four real differences

AJC `PicScheme.picEt C` (`PicEtSheaf.lean:221`) is `Type (u+1)`, étale, genuinely sheafified (`presheafToSheaf`, `:152`), full Pic. AJCR `pic0TypeFunctor C` (`Pic0SigmaSheaf.lean:58`) is `Type u`, Zariski-sited engine, **not** sheafified, degree-0 only (`pic0Subgroup`, `Pic0Functor.lean:107`/`:151`). Universes probe-confirmed.

Precision on (ii)/(iii): AJCR's carrier is étale-*flavoured* (`PicEt.lean:105` is an affine-opens limit of the étale plus construction `PicEtAff`, `PicEtAff.lean:218`), but it is not `presheafToSheaf` — grep for `presheafToSheaf|toSheafify|sheafify` across AJCR/Picard gives zero hits — and its sheaf theorem and the engine's site are Zariski. Different objects by different routes, not one object in two universes.

**AJC has no degree-zero functor**: `pic0Functor|pic0Subgroup|pic0TypeFunctor` → zero hits in AJC. AJC's `Pic⁰` is scheme-level (`Scheme.Pic0SchemeEt C = IdentityComponent (PicSchemeEt C)`, `Pic0Et.lean`), defined *downstream* of representability where AJCR's is *upstream*. That inverts the dependency order.

## Q4: 134 of 135 closure modules absent from AJC

Level-1 imports: `Picard.PicEtCoverBridge`, `Picard.OverSigmaExtension`, `Mathlib.AlgebraicGeometry.Sites.Representability`. Transitive AJCR-local closure **135 modules** (Picard 68, RiemannRoch 22, Algebra 15, Curve 12, Cohomology 10, Descent 7, Challenge 1). Exactly **1** same-named file exists in AJC (`Curve.GeometricallyReduced`); **134 absent**. Rough transcription cost ~134 files, and that reaches only the engine, not its antecedents.

Worth flagging: **AJC already has its own sorry-free, axiom-clean 01JJ engine** — `Scheme.representable_of_openCover` (`ZariskiDescentRepresentability.lean:1353`), probing `[propext, Classical.choice, Quot.sound]`, solving the same `Type 1`→`Type 0` size reduction and calling the same mathlib `LocalRepresentability.representableBy`. The 01JJ technique is not what AJC lacks.

## Pricing verdict

The route transfers a *reduction*, not a proof, and AJC already owns equivalent reduction machinery. AJCR's residue (Abel-chart open-immersion certification + Zariski coverage + `divFunctor` representability) and AJC's residue (Kleiman §4 slice + Div via Quot) **both bottom out in divisor representability and Abel-map behaviour**. Paying ~134 files plus a universe and carrier rewrite would re-express the same debt in new vocabulary against a strictly weaker target (degree-0 vs full `picEt`). I found no evidence the AJCR route retires any obligation AJC currently carries.

Unverified: I did not attempt to construct the missing chart family or assess whether `IsChartUniv` is *provable* at `chartLocus` — only that it is unproved and false unrestricted. Absence claims rest on grep across AJCR/AJC `AlgebraicJacobian/` trees plus elaborated signature probes, not on a full build (build lock respected; only `lake env lean` on /tmp scratch files was run).
