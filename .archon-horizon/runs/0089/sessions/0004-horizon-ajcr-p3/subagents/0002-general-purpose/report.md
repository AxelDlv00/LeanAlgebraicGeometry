## 1. Consumers of the three declarations — every one takes `lam` as a bound variable; none instantiates it

Full call graph (whole workspace grep; all hits are inside this project, `AlgebraicJacobian/Picard/`):

| decl | file:line | who consumes it | `lam` instantiated with |
|---|---|---|---|
| `chartLocusOpens` | `Pic0ChartUnivReduce.lean:115` | `mem_chartLocusOpens` (:124), `chartLocusOpens'` (`Pic0ChartCoverageAbel.lean:145`) | nothing — passed through as the same universally-quantified `(lam : picEt C T)` |
| `chartLocusOpens'` | `Pic0ChartCoverageAbel.lean:142` | `mem_chartLocusOpens'` (:148), `chartLocusOpensOfPlusFibre` (`Pic0ChartLocusPlusFibre.lean:182`) | same bound variable |
| `chartLocusOpensOfPlusFibre` | `Pic0ChartLocusPlusFibre.lean:173` | **only** `mem_chartLocusOpensOfPlusFibre` (:185) | — |
| `chartLocusOpensOfIsPlusHonest` | `Pic0ChartPlusFibreProducer.lean:334` | **only** `mem_chartLocusOpensOfIsPlusHonest` (:343) | — |
| `isOpen_chartLocus_of_isPlusHonest` | `Pic0ChartPlusFibreProducer.lean:316` | **only** `chartLocusOpensOfIsPlusHonest` (:340) | — |

So: **there is no consumer anywhere in the tree that supplies a concrete `lam`.** The chain terminates at `chartLocusOpensOfPlusFibre` / `chartLocusOpensOfIsPlusHonest`, both leaves. Nothing constructs `IsPlusHonest` for any particular class either — the only `IsPlusHonest` inhabitants are the generic closure/family lemmas at `Pic0ChartPlusFibreProducer.lean:209/220/230/245/256/275/294`.

Also absent: `chartLocusOpens_of_affineLocal`, listed in `Pic0ChartCoverageAbel.lean:66`'s Main-declarations block, **does not exist** — the only grep hit in the tree is that docstring line. (Same failure mode the file's own header retraction describes.)

The path that would actually consume the open is `IsChartLocusFibre` (`Pic0ChartUnivReduce.lean:152`), and it **does not call `chartLocusOpens`**: it asks for `Nonempty (ChartFibrePresented …)` whose `W : T.Opens` is an unfilled structure field (`Pic0ChartOpenImmersionCriterion.lean:133`). No `ChartFibrePresented` value is constructed anywhere in the tree (grep: zero `where`/`⟨…⟩` sites), and no `IsChartLocusFibre` value either. The `chartLocus`→`W` link is prose only.

## 2. `abelDiv_isPlusHonest` — exists, and it is *not* the class `chartLocus` reads

Verbatim, `Pic0ChartPlusFibreProducer.lean:275-283`:

```lean
theorem abelDiv_isPlusHonest {n : ℕ} (T : Over (Spec (.of k)))
    (s : divFamZar C π n T) :
    IsPlusHonest C T (abelDiv C π n T s) := by
  intro U
  refine ⟨relPicMk C (overSpec k Γ(T.left, U.1))
    ((divFamZarAffineEquiv C π n Γ(T.left, U.1)
      (divFamZar.map C π n (Over.fromSpecAffine T U) s)).picClass), ?_⟩
  rw [picEtMap_abelDiv, abelDiv_overSpec]
  rfl
```

The two twists, verbatim:

```lean
def chartValue (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s : divFamZar C π n T) : picEt C T :=
  abelDiv C π n T s * sigmaFamily C Z T
    * (thetaFamily C (thetaCechClass C) T ^ m)⁻¹
```
(`DivSchemeAbel.lean:351`)

```lean
def chartTwist (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (lam : picEt C T) : picEt C T :=
  lam * (thetaFamily C (thetaCechClass C) T ^ m) * (sigmaFamily C Z T)⁻¹
```
(`Pic0ChartLocus.lean:174`)

`chartValue = chartTwist (abelDiv …)` is **not a lemma and is false** — the twists are mutual inverses, not equal. What exists is the inversion law:

```lean
theorem chartTwist_chartValue {n : ℕ} (m : ℕ)
    (Z : (C ⊗ overSpec k k).left.CurveDivisor) (T : Over (Spec (.of k)))
    (s : divFamZar C π n T) :
    chartTwist C m Z T (chartValue C π n m Z T s) = abelDiv C π n T s
```
(`Pic0ChartLocus.lean:221`)

`abelChartApp_eq` (`Pic0ChartCoverageAbel.lean:104-114`) confirms the chart's value component is `chartValue C π n m Z (Over.mk (x ≫ D.hom)) (rep.homEquiv (Over.homMk x rfl))`, via `chartValueTrans` (`Pic0AtlasFromDivRep.lean:176`).

So `abelDiv C π n T s` is *not* the class `chartLocus` is applied to; it is the class `chartTwist` produces *from* a chart value.

## 3. `IsPlusHonest C T (chartValue …)` — MISSING

Grep for `chartValue_isPlusHonest` / any `IsPlusHonest … chartValue`: zero hits. The composite does not exist.

What must be composed, and the mismatch:

- `chartTwist_isPlusHonest` (`Pic0ChartPlusFibreProducer.lean:294-296`) is the composite the file offers:
  ```lean
  theorem chartTwist_isPlusHonest (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
      (T : Over (Spec (.of k))) {lam : picEt C T} (hlam : IsPlusHonest C T lam) :
      IsPlusHonest C T (chartTwist C m Z T lam)
  ```
  Fed `abelDiv_isPlusHonest` it yields `IsPlusHonest C T (abelDiv s * θᵐ * Σ⁻¹)` — **not** `chartValue = abelDiv s * Σ * (θᵐ)⁻¹`. Wrong twist direction; no rewrite closes it.

  The route that does work is `IsPlusHonest.mul` (:209) / `.inv` (:220) / `.pow` (:230) applied directly after `rw [chartValue]`, with `abelDiv_isPlusHonest` (:275), `sigmaFamily_isPlusHonest` (:256), `thetaFamily_isPlusHonest` (:245). That is a 2-line proof and it is simply absent.

- A second, harder mismatch blocks plugging any of this into c9b's `W`: hypothesis sets differ.
  `isOpen_chartLocus_of_isPlusHonest` / `chartLocusOpensOfIsPlusHonest` carry `[IsFinite π]`, `[GeometricallyReduced C.hom]` and the explicit `(hπ : π ≫ P1.structureMap k = C.hom)` (`Pic0ChartPlusFibreProducer.lean:92,94,317,335`). `chartLocusOpens` and `IsChartLocusFibre` live under `[IsAffineHom π]` with **no** `GeometricallyReduced` and **no** `hπ` (`Pic0ChartUnivReduce.lean:81-83`). So the honest-class open is not a drop-in for the `haff`-taking one.

- The load-bearing gap, which the composite would not fix: `chartLocus` in the `W` field is applied to the class named by an **arbitrary** test point `g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1` — i.e. an arbitrary element of `pic0Subgroup C (Over.mk a)` (`pic0SigmaFunctor` = `Over.sigmaExtension (Spec (.of k)) (pic0TypeFunctor C)`, `Pic0SigmaSheaf.lean:76`). It is *not* applied to a `chartValue`. Honesty of `chartValue` would say nothing about it; asserting `lam` is a chart value on the locus where the datum says `lam` is a chart value is circular. The project's own worksheet states this at `informal/w4-datc-worksheet.md:676-679`: "What remains genuinely unpriced is honesty of an *arbitrary* `pic⁰` class on a test."

**Answer to the framing question: CHART-U(b) is not unconditional for the class the Σ-chart reads.** It is unconditional for `IsPlusHonest λ`, and no `IsPlusHonest` proof exists for any concrete `λ` reaching a consumer.

## 4. `Pic0ChartUnivReduce.lean` around 115

`chartLocusOpens` (:115-121) takes `haff : ∀ U : T.left.affineOpens, IsOpen (chartLocus C m Z (picEtMap C (Over.fromSpecAffine T U) lam))` and returns `T.left.Opens` with `carrier := chartLocus C m Z lam`, `is_open' := isOpen_chartLocus_of_affineLocal' C m Z T lam haff`.

**What consumes the open in that file: nothing.** Only `mem_chartLocusOpens` (:124) and, out of file, `chartLocusOpens'`. The file's residue `IsChartLocusFibre` (:152-157) is:

```lean
def IsChartLocusFibre {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) : Prop :=
  ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
    Nonempty (ChartFibrePresented C (abelSigmaChart C π n rep m Z hdeg) g)
```

consumed only by `isChartUniv_of_isChartLocusFibre` (:170-178). The `W` field it needs is `W : T.Opens` (`Pic0ChartOpenImmersionCriterion.lean:133`) plus `r`, `sq`, `exists_factor` (:135-141) — and `sq`/`exists_factor` are stated *relative to whatever `W` is*, so filling `W` with `chartLocus` is only useful together with an `exists_factor` proof that reads the locus. None exists.

`IsChartDatumPresentation` (`Pic0ChartLocusIsOpen.lean:178-182`):

```lean
def IsChartDatumPresentation {A : Type u} [CommRing A] [Algebra k A]
    (μ : picEt C (overSpec k A)) (D : BasicOpenCocycleDatum C A π) : Prop :=
  ∀ t : (overSpec k A).left,
    D.HasWitnessH1Vanishing (Over.testPointField (T := overSpec k A) t)
      ↔ IsSplitWitness C (picEtMap C (Over.testPoint t) μ)
```

The reduction chain that is real and complete: `chartLocusAffineLocal_of_presentation` (`Pic0ChartCoverageAbel.lean:182`) → `isChartDatumPresentation_of_plusFibre_tower` (`Pic0ChartPlusFibreTower.lean:216`) → `chartLocusAffineLocal_of_plusFibre` (`Pic0ChartLocusPlusFibre.lean:120`) → `isOpen_chartLocus_of_plusFibre` (:149) → `isOpen_chartLocus_of_isPlusHonest` (`Pic0ChartPlusFibreProducer.lean:316`). Every link is sorry-free. It bottoms out on `IsPlusHonest λ`, unfurnished.

## 5. `sorry` census

None in any of the five files. All hits are prose inside docstrings: `Pic0ChartPlusFibreProducer.lean:52`, `Pic0ChartLocusIsOpen.lean:99,102,238`. `Pic0ChartLocusPlusFibre.lean`, `Pic0ChartUnivReduce.lean`, `Pic0ChartPlusFibreTower.lean`: zero occurrences of the token.

Project-wide code-level `sorry` (for context): `Picard/Pic0ThetaCocycle.lean:246,320` (that module is imported by nothing and is absent from `AlgebraicJacobian.lean`), and `AlgebraicJacobian/Challenge.lean` (many, lines 99-283). No `axiom` declarations in the Picard tree.
