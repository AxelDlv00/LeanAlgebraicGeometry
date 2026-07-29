The map is complete. Report:

# Reduction chain: `hf` of `pic0RepresentableByOfCharts`

All files below are sorry-free (zero `sorry`/`admit`/`native_decide` in code; the hits my grep found are all in docstring prose). Every declaration I probed carries only `[propext, Classical.choice, Quot.sound]`.

## The chain, verbatim

**1. The consumer.** `AlgebraicGeometry.pic0RepresentableByOfCharts`, `Picard/Pic0SigmaSheaf.lean:161`. Its `hf : ∀ i, IsOpenImmersion.presheaf (f i)`.

**2. `IsChartUniv`** — `Picard/Pic0ChartPair.lean:173`:
```lean
def IsChartUniv {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens) : Prop :=
  IsOpenImmersion.presheaf (restrictChart (abelSigmaChart C π n rep m Z hdeg) V)
```
Section binders: `{k}[Field k]{C}{π}[IsAffineHom π]{n}[SmoothOfRelativeDimension 1 C.hom][IsProper C.hom][GeometricallyIrreducible C.hom]`.

**3. The composition half, landed unconditionally** — `isOpenImmersion_presheaf_restrictChart` (`Pic0ChartPair.lean:139`), takes `(V : X.Opens) (hfV : IsOpenImmersion.presheaf f)`.

**4. The criterion** — `isOpenImmersion_presheaf_of_chartFibrePresented` (`Pic0ChartOpenImmersionCriterion.lean:195`): takes `f` and `D : ∀ T g, ChartFibrePresented C f g`, gives `IsOpenImmersion.presheaf f`. Discharges both clauses of `MorphismProperty.relative`. Genuinely certificate-free.

**5. `ChartFibrePresented`** — `Pic0ChartOpenImmersionCriterion.lean:129`, four fields, verbatim: `W : T.Opens`; `r : (W : Scheme.{u}) ⟶ X`; `sq : yoneda.map r ≫ f = yoneda.map W.ι ≫ g`; `exists_factor : ∀ (S : Scheme.{u}) (v : S ⟶ X) (w : S ⟶ T), f.app (op S) v = g.app (op S) w → ∃ u : S ⟶ (W : Scheme.{u}), u ≫ r = v ∧ u ≫ W.ι = w`.

**6. `IsChartLocusFibre`** — `Pic0ChartUnivReduce.lean:152`, same binders as `IsChartUniv` minus `V`:
```lean
  ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
    Nonempty (ChartFibrePresented C (abelSigmaChart C π n rep m Z hdeg) g)
```

## Findings, in order of value

### A. `IsChartLocusFibre` is stated about the UNRESTRICTED Abel chart, which the tree proves is the false statement

This is the load-bearing defect. `IsChartLocusFibre`'s body binds `abelSigmaChart … ` with **no `V`, no restriction**. So it is not "the residue of `IsChartUniv`"; it is strictly stronger — it implies the unrestricted certificate three files call false. I compiled both, from the file's own lemmas:

```lean
example … (h : IsChartLocusFibre C π n rep m Z hdeg) :
    IsOpenImmersion.presheaf (abelSigmaChart C π n rep m Z hdeg) :=
  isOpenImmersion_presheaf_of_chartFibrePresented _ fun T g => (h T g).some
```
and hence `Function.Injective ((abelSigmaChart …).app T)` on **every** test, unrestricted — the linear system `|D|` non-injectivity the `Pic0AtlasFromDivRep.lean:54` header says makes this fail. I also compiled the contrapositive: one non-injective test refutes `IsChartLocusFibre` outright, via the file's own `isEmpty_forall_chartFibrePresented_of_not_injective`.

`isChartUniv_of_isChartLocusFibre` (`:170`) is *true* (it throws the strength away through `restrictChart`), but the reduction runs the wrong way: its hypothesis is expected-false for `g ≥ 1`. The `V`-arbitrariness the docstring celebrates ("restriction never has to be to the chart locus") is the symptom, not a feature. The sound route — instantiate the criterion at `restrictChart … V` so `X := V` — also compiles and is one line; nothing in the tree does it.

### B. Vacuity: neither `IsChartLocusFibre` nor `ChartFibrePresented` mentions `chartLocus`

The `W` field is an arbitrary `T.Opens`, existentially chosen by the producer. `IsChartLocusFibre`'s name, its docstring ("`ChartFibrePresented` with its `W` field already discharged — it is `chartLocus`"), and the `Pic0ChartUnivReduce.lean:23-27` table row all assert `W = chartLocus`. **The Lean binders do not.** Nothing constrains `W`; a producer may pick `⊥`, and `exists_factor` then carries everything. This is the `HasDivFunctor` shape: the structure does not mention the object it claims to be about. Consequence: the whole `chartLocus`/`haff`/B-4 leg is **not on `IsChartUniv`'s critical path at all** — `IsChartUniv` never mentions `chartLocus`, and `chartLocusOpens` has zero call sites in any proof term. The two legs are disjoint, not composed.

### C. LOUDLY: the `haff` prerequisite the chain declares open ALREADY EXISTS, discharged

`Pic0ChartUnivReduce.lean:46` (and `Pic0ChartCoverageAbel.lean:42`, and `Pic0ChartUnivReduce.lean:105`) state: `chartLocusOpens` takes `haff`, "and **nothing in the tree discharges it**". That is stale. `Pic0ChartPlusFibreProducer.lean` (Jul 29 15:24, in the root import list, olean fresh, zero diagnostics) closes it. I compiled `ChartLocusAffineLocal C m Z T lam` from `IsPlusHonest C T lam` alone. The full landed chain: `isChartDatumPresentation_of_plusFibre_tower` → `chartLocusAffineLocal_of_presentation` → `chartLocusAffineLocal_of_plusFibre` → `exists_isChartDatumPlusFibre_of_mem_range` → `isOpen_chartLocus_of_isPlusHonest` / `chartLocusOpensOfIsPlusHonest`. Three files' prose still price a discharged obligation as the gate.

### D. `ChartLocusAffineLocal` / `chartLocusAffineLocal_of_presentation`

`ChartLocusAffineLocal` (`Pic0ChartCoverageAbel.lean:132`) — takes `(m) (Z) (T : Over (Spec (.of k))) (lam : picEt C T)`, is `∀ U : T.left.affineOpens, IsOpen (chartLocus C m Z (picEtMap C (Over.fromSpecAffine T U) lam))`. Exactly the `haff` argument of `isOpen_chartLocus_of_affineLocal'`. `chartLocusAffineLocal_of_presentation` (`:182`) takes `[IsFinite π] (hπ : π ≫ P1.structureMap k = C.hom) (m) (Z) (T) (lam)` plus `hpres : ∀ U : T.left.affineOpens, ∃ D : BasicOpenCocycleDatum C (Γ(T.left, U.1)) π, IsChartDatumPresentation C π (chartTwist C m Z _ (picEtMap C (Over.fromSpecAffine T U) lam)) D`, and produces `ChartLocusAffineLocal C m Z T lam`. Note `[IsFinite π]`, strictly stronger than the `[IsAffineHom π]` that `IsChartUniv` carries.

### E. `IsChartDatumPresentation` (B-4) — the witness-half claim VERIFIED, and the stated remainder is stale

Definition, `Pic0ChartLocusIsOpen.lean:178`:
```lean
def IsChartDatumPresentation {A : Type u} [CommRing A] [Algebra k A]
    (μ : picEt C (overSpec k A)) (D : BasicOpenCocycleDatum C A π) : Prop :=
  ∀ t : (overSpec k A).left,
    D.HasWitnessH1Vanishing (Over.testPointField (T := overSpec k A) t)
      ↔ IsSplitWitness C (picEtMap C (Over.testPoint t) μ)
```
The witness half is discharged by **`hasWitnessH1Vanishing_of_isSplitWitness_at`** (`Pic0ChartPresentationConverse.lean:163`), via `PicEtAff.unit_injective` + `relPicMk_injective_of_subsingleton`. So the `Pic0ChartUnivReduce.lean:109` claim is accurate.

But its "leaving a plus-class base-change identity" is **stale by two files**. That residue (`hplus`/`IsChartDatumPlusFibreAt`) was closed by `isChartDatumPlusFibreAt_of_isScalarTower` (`Pic0ChartPlusFibreTower.lean:112`), leaving `IsChartDatumPlusFibre` alone (`isChartDatumPresentation_of_plusFibre_tower`, `:215`) — and *that* was closed by `exists_isChartDatumPlusFibre_of_mem_range` (`Pic0ChartPlusFibreProducer.lean:178`), leaving only `IsPlusHonest`. `IsChartDatumPresentation` is no longer an open obligation for an honest class.

### F. `IsChartLocusFibre` / `ChartFibrePresented` field-by-field: see 5 and 6 above. The `W`-vacuity is B; the "W field discharged" claim is false in the binders.

### G. Smaller flags
- **`isChartLocusFibre_of_isChartUniv`** — advertised as "the **converse**" at `Pic0ChartUnivReduce.lean:55`. **Does not exist.** One workspace hit: that sentence. The converse-check role is actually filled by `injective_of_isChartUniv` (`:191`), which is much weaker (injectivity, not the datum). This is the `docstring-declaration-lists-unchecked` mode this very file's neighbours filed lessons about.
- **`isChartUniv_of_unrestricted`** (`Pic0ChartPair.lean:184`) and the criterion route are the same statement; per A, `IsChartLocusFibre` is a renaming of the hypothesis the file's own docstring calls false.
- **`IsPlusHonest`** (`Pic0ChartPlusFibreProducer.lean:200`) is genuinely open for an arbitrary class (`exact?` fails, as its docstring claims). It is *not* open for a chart value: I compiled `IsPlusHonest C T (chartValue C π n m Z T s)` from `abelDiv_isPlusHonest` + the three closure lemmas. That composite is **not in the tree under any name** — grep for `chartValue_isPlusHonest` returns nothing. Cheap, and it is the last brick of the openness leg.
- `[IsFinite π]` vs `[IsAffineHom π]`: the openness leg needs finiteness (rigid engine), `IsChartUniv` declares only affineness. Any assembly must strengthen.

## The single innermost still-open obligation

Because of A and B, `chartLocus` is not beneath `IsChartUniv` in Lean. The innermost genuinely-open mathematical obligation on the `hf` chain is `exists_factor` **at the restricted chart** — which nothing in the tree states. Written with binders (`{k}[Field k]{C}{π}[IsAffineHom π]{n}` + the three curve instances):

```lean
∀ {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
  (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
  (hdeg : Scheme.CurveDivisor.deg k Z
    = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
  (V : D.left.Opens) (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
  ∃ (W : T.Opens) (r : (W : Scheme.{u}) ⟶ (V : Scheme.{u})),
    yoneda.map r ≫ restrictChart (abelSigmaChart C π n rep m Z hdeg) V
        = yoneda.map W.ι ≫ g
      ∧ ∀ (S : Scheme.{u}) (v : S ⟶ (V : Scheme.{u})) (w : S ⟶ T),
        (restrictChart (abelSigmaChart C π n rep m Z hdeg) V).app (op S) v = g.app (op S) w →
          ∃ u : S ⟶ (W : Scheme.{u}), u ≫ r = v ∧ u ≫ W.ι = w
```

**Distance from what is proved.** The `W`/`r`/`sq` triple is reachable: `W := chartLocusOpensOfIsPlusHonest` once the `chartValue` honesty composite above is written (one line), and `r` is `divRepClassifyZar` (`DivRepClassifyZar.lean:244`) with `sq` its characterising property. The `exists_factor` conjunct is the real gap and is **two steps** from landed material: the absolute case is `Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one` (`RiemannRoch/EffectiveUniqueness.lean:144`, landed, takes `0 ≤ D`, `0 ≤ D'`, equal `picClass`, `h⁰ = 1`), and the family-level injectivity of the classifier is `divRepClassifyZar_injective` (`DivRepClassifyZarSep.lean:414`, landed). What is missing between them is the relative/in-families uniqueness over the locus — no declaration in the tree states it. Note `Pic0ChartLocus.lean:146-149` warns explicitly that `IsSplitWitness` supplies **neither** `0 ≤ W` nor `deg W = g`, so effectivity must be re-supplied at exactly this step; the degree comes free from `degAt_chartTwist` + the `hdeg` constraint, giving `h⁰ = 1` by the `FLVClass.lean:412` anchor.
