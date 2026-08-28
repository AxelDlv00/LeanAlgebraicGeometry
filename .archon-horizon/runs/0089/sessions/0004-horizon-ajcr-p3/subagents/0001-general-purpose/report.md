I have everything I need. Compiling the report.

## Report — antecedent B-6, `[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]`

All paths absolute-rooted at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`.

### 1. The two named theorems, verbatim

**`isLocallySurjective_sigmaDesc_of_pointwise`** — `AlgebraicJacobian/Picard/Pic0ChartCoveragePointwise.lean:145-151`, namespace `AlgebraicGeometry`, section variables `{k : Type u} [Field k] {C : Over (Spec (.of k))} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` (file lines 67-69), inside `noncomputable section`, with `variable (C) in`:

```lean
theorem isLocallySurjective_sigmaDesc_of_pointwise {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (h : ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : ↥T),
      ∃ (W : T.Opens) (_ : t ∈ W) (i : ι) (x : (W : Scheme.{u}) ⟶ X i),
        (f i).app (op (W : Scheme.{u})) x = (pic0SigmaSheaf C).1.map (W.ι).op s) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f) :=
  isLocallySurjective_sigmaDesc f (chartsCoverLocally_of_pointwise C f h)
```

Exactly two hypotheses beyond the standing curve instances: the chart family `f` and the pointwise datum `h`. No `π`, no `n`, no `rep`, no certificate, no `divRep`.

**`pointwise_of_chartsCoverLocally`** — same file, `:173-185`:

```lean
theorem pointwise_of_chartsCoverLocally {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (h : ChartsCoverLocally C f) (T : Scheme.{u})
    (s : (pic0SigmaSheaf C).1.obj (op T)) :
    ∃ (𝒰 : T.Cover.{u} (Scheme.precoverage @IsOpenImmersion)),
      ∀ j : 𝒰.I₀, ∃ (i : ι) (x : 𝒰.X j ⟶ X i),
        (f i).app (op (𝒰.X j)) x = (pic0SigmaSheaf C).1.map (𝒰.f j).op s
```

This is the converse *of the sieve condition*, not of the pointwise datum: it returns a cover by arbitrary schemes with open-immersion maps (`𝒰.X j`, `𝒰.f j`), where the hypothesis of the forward lemma consumes an opens inclusion `W.ι`. The docstring at `:166-172` states this difference explicitly and does not claim it is bridged.

Supporting chain: `ChartsCoverLocally` is `def` at `AlgebraicJacobian/Picard/Pic0ChartLocalSurjectivity.lean:86-89` (`∀ T s, (⨆ i, Presheaf.imageSieve (f i) s) ∈ Scheme.zariskiTopology T`); `isLocallySurjective_sigmaDesc` at `:103-113`; `chartsCoverLocally_of_pointwise` at `Pic0ChartCoveragePointwise.lean:128-136`; the site-level bridge `mem_zariskiTopology_iSup_of_pointwise` at `:92-100`.

### 2. The pointwise datum, component by component

Verbatim (the `h` above). Its four components at a given `T`, `s`, `t : ↥T`:

| component | what it is | producer in the tree today |
|---|---|---|
| `W : T.Opens` | open neighbourhood of `t` | **Yes, for an honest class.** `chartLocusOpensOfIsPlusHonest` (`AlgebraicJacobian/Picard/Pic0ChartPlusFibreProducer.lean:334`) builds the bundled `T.left.Opens` with `haff` discharged, from `IsPlusHonest` (`:200`) alone; `isOpen_chartLocus_of_isPlusHonest` (`:316`) is the openness. Weaker predecessors: `chartLocusOpens` (`Pic0ChartUnivReduce.lean:115`, takes `haff` as an argument), `chartLocusOpens'` / `ChartLocusAffineLocal` (`Pic0ChartCoverageAbel.lean:142`, `:132`), `chartLocusOpensOfPlusFibre` (`Pic0ChartLocusPlusFibre.lean:173`). Note the type mismatch: these are `T.left.Opens` for `T : Over (Spec (.of k))`, the datum wants `T.Opens` for a bare `T : Scheme.{u}` — reconciled definitionally per `Pic0ChartCoverageAbel.lean:18-24` ("`(Over.mk a).left` is `T` itself, definitionally"), asserted there, not stated as a lemma. |
| `_ : t ∈ W` | membership | **Yes** — `mem_chartLocusOpensOfIsPlusHonest` (`Pic0ChartPlusFibreProducer.lean:343`) is `Iff.rfl`; so membership reduces to `t ∈ chartLocus`, which is item 3's business. |
| `i : ι` | chart index, chosen per point | free (arbitrary function; `mem_zariskiTopology_iSup_of_pointwise`'s `idx` has no compatibility condition) |
| `x : (W : Scheme.{u}) ⟶ X i` | a chart point over `W` | **No producer.** `X i` is the chart source, i.e. `(V i : Scheme)` for the restricted atlas or `D.left` for `abelSigmaChart`; both need `rep : (divFunctor C π n).RepresentableBy D`, which nothing produces — `divFunctor_representableBy_of_chartClause` (`AlgebraicJacobian/Picard/DivRepAffPullClause.lean:482`) is conditional on `IsChartClause` (U2, certificate-gated). |
| `hx : (f i).app … x = … .map (W.ι).op s` | the class equation | **No producer.** The only thing computed is the *shape* of the left side: `abelChartApp_eq` (`AlgebraicJacobian/Picard/Pic0ChartCoverageAbel.lean:105-114`, `rfl`) gives `(abelSigmaChart …).app (op Y) x = ⟨x ≫ D.hom, ⟨chartValue …, …⟩⟩` — both Σ-component and class component, per that file's warning at `:28-31`. |

**Zero declarations in the tree conclude `ChartsCoverLocally`** other than the two reductions themselves: `chartsCoverLocally_of_pointwise` (`Pic0ChartCoveragePointwise.lean:133`) and `chartsCoverLocally_of_forall_surjective` (`Pic0ChartLocalSurjectivity.lean:125-133`, the degenerate satisfiability check requiring one chart surjective on points of every test — explicitly not the geometric situation, per its docstring `:118-121`). **Zero declarations conclude `PointwiseCoverage`** except `liftPointwiseToOpens`, which takes pointwise coverage as input.

**A distinct undischarged obligation between antecedents.** `AlgebraicJacobian/Picard/Pic0ChartAtlasCoupling.lean` (193 lines) records that the atlas the seam consumes is *restricted* charts, so the datum's `x` must land in `V i` (an open of the divisor scheme), while coverage geometry produces a point of `D.left`. `liftPointwiseToOpens` (`:128`) and `isLocallySurjective_restrictChart_of_pointwise` (`:149`) bridge this from a range containment `hV`, and `pointwise_of_pointwise_restrictChart` (`:177`) proves `hV` is exactly the difference. **This file is UNROOTED** — not reachable from `AlgebraicJacobian.lean` (confirmed by `python3 scripts/reach.py`: 18 unrooted of 755; only `Pic0ChartAtlasParamFree` and the two Coverage/LocalSurjectivity files import it, and `AlgebraicJacobian.lean:562,565,566` imports those but not the coupling file). Its `.olean` exists (built 19:10, src 19:07) and `#print axioms` on `isLocallySurjective_restrictChart_of_pointwise` returns only the three standard axioms.

### 3. `exists_mem_chartLocus_of_vanishing_bound`

`AlgebraicJacobian/Picard/Pic0ChartCoverageNoDrop.lean:214-242`, verbatim (standing variables at `:86-88`, `variable (C) in`):

```lean
theorem exists_mem_chartLocus_of_vanishing_bound {T : Over (Spec (.of k))} (lam : picEt C T)
    (t : T.left) (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L]
    [Algebra.IsSeparable (Over.testPointField t) L]
    (M₀ : (relCurve C L).CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)]
    (b : ℤ)
    (hb : ∀ D : ((C ⊗ overSpec k L).left).CurveDivisor,
      b ≤ Scheme.CurveDivisor.deg L D →
        Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L D) 1))
    (hdeg : classDeg L (M₀ * Scheme.CechPic.map (relCurveMap C k L)
      (chartTwistClass C m Z)) = b) :
    ∃ m' : ℕ, ∃ Z' : (C ⊗ overSpec k k).left.CurveDivisor, t ∈ chartLocus C m' Z' lam :=
  ⟨m, Z, mem_chartLocus_of_vanishing_bound C lam t m Z M₀ hM₀ b hb hdeg⟩
```

Inhabitability, hypothesis by hypothesis:

- **`hM₀` (the splitting): INHABITABLE, unconditionally.** `exists_splitting_of_picEt` (`AlgebraicJacobian/Picard/Pic0ChartSplit.lean:143-150`) produces `L`, its field/algebra/tower/finite/separable instances, and `M₀` with exactly this equation, for any plus class over any reading field, from `exists_splitting_of_picEtAff` (`:105`). Axioms: the three standard.
- **The five `[…]` instance binders: DISCHARGED at every instantiation.** `instIsIntegralBaseChange` (`AlgebraicJacobian/Curve/BaseChangeInstances.lean:152`), `instSmoothOfRelativeDimensionBaseChange` (`:125`), `instQuasiCompactBaseChange` (`:136`), `instModuleFiniteHModuleZeroBaseChange` (`:167`), `instModuleFiniteHModuleOneBaseChange` (`:176`). They are stated in the binder only because they are keyed to the product spelling while `hdeg` uses the `relCurve` alias (comment at `Pic0ChartCoverageNoDrop.lean:224-229`).
- **`hb` (the vanishing threshold): NOT INHABITABLE at the parameter that matters, and this is machine-checked in the tree.** The only threshold producer is `exists_bound_subsingleton_hModule_one_of_isFinite_toP1` (`AlgebraicJacobian/RiemannRoch/UniformVanishing.lean:71-77`), which requires `(π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]` and `hπ : π ≫ P1.structureMap K = Y ↘ Spec K` — **at the base-changed curve `(C ⊗ overSpec k L).left` no such `π_L` exists in the tree**: I found no declaration constructing a finite dominant map `relCurve C L ⟶ P1 L` (searched `P1 L`/`P1 K` against `relCurve`/`overSpec` signatures; the only relCurve-to-P1 map is the ad-hoc `q := (fst C (overSpec k R)).left ≫ π` at `AlgebraicJacobian/Picard/DivSchemeCertZarFibreAvoid.lean:286`, which targets `P1 k` not `P1 L`). And `hb` cannot be met by DAT-0a's own bound anyway: `hdeg` **forces `b = n`** at a legal chart index (`ledger_forces_b_eq_n`, `AlgebraicJacobian/Picard/Pic0ChartCoverageIndexSlack.lean:119-134`), and at `n = g`, `hb` forces every degree-`g` divisor to have `h⁰ = 1` (`hb_forces_h0_eq_one`, `:180-197`) — false on a curve with a moving degree-`g` family, and strictly below DAT-0a's `n₁·deg F + g`.
- **`hdeg`: SATISFIABLE, at a chart parameter chosen to match `b`.** `index_of_threshold` (`Pic0ChartCoverageIndexSlack.lean:147-161`) gives it by construction for any `b ≥ 0` at parameter `b.toNat`. Underlying ledger: `classDeg_presenting_twist` (`AlgebraicJacobian/Picard/Pic0ChartCoverageDegreeStep2.lean:125-137`).

So the honest reading: the `∃`-form theorem is sound and its splitting/instance/ledger hypotheses are all inhabited; `hb` is the live obstruction, and satisfying `hdeg` *and* `hb` simultaneously at `n = g` is what `Pic0ChartCoverageIndexSlack.lean:52-70` names as the residue (reconcile chart parameter with threshold — its own suggested move, letting `Z` carry slack in the `g + e` shape of `classDeg_presenting_twist_eq_add` at `Pic0ChartCoverageDegreeStep2.lean:148`, has an open legality question `0 ≤ Σ`).

Also note the **shape gap**: this theorem's conclusion is `∃ m' Z', t ∈ chartLocus C m' Z' lam` — an existential over the *index*. The pointwise datum in item 1 needs the index fixed by `f`'s indexing type `ι` and then a *morphism* `x` plus a class equation. Membership of `chartLocus` is a `Prop` about a split witness (`chartLocus` def at `AlgebraicJacobian/Picard/Pic0ChartLocus.lean:244-247`, via `IsSplitWitness` at `:151-161`); nothing converts it into the morphism `x`.

### 4. Declarations producing a chart point over an open with the right class

**None.** The full set of declarations matching the requested name patterns (grepped over the whole tree for `chartLocus`, `chartPoint`/`ChartPoint`, `coverLocally`/`CoverLocally`, `chartsCover`/`ChartsCover`, `abelChartApp`):

- `chartPoint`/`ChartPoint`: **zero hits** in `AlgebraicJacobian` (the only near-match is the unrelated import `AlgebraicJacobian.RiemannRoch.ChartPoints` cited at `AlgebraicJacobian/RiemannRoch/ChartColength.lean:7,35`).
- `coverLocally`/`chartsCover`: only `ChartsCoverLocally` (`Pic0ChartLocalSurjectivity.lean:86`), `chartsCoverLocally_of_forall_surjective` (`:125`), `chartsCoverLocally_of_pointwise` (`Pic0ChartCoveragePointwise.lean:128`), `pointwise_of_chartsCoverLocally` (`:173`).
- `abelChartApp`: only `abelChartApp_eq` (`Pic0ChartCoverageAbel.lean:105`), an `rfl` computing the chart's value at a *given* `x`, not producing one.
- `chartLocus` family (18 declarations): `chartLocus` (`Pic0ChartLocus.lean:244`), `mem_chartLocus_iff` (`:249`), `mem_chartLocus_of_mem_chartLocus_comp` (`:360`), `chartLocus_fromSpecAffine_eq_preimage` / `isOpen_chartLocus_of_affineLocal` (`Pic0ChartLocusGeneralTest.lean:168,191`), the primed pair (`Pic0ChartLocusIsoInvariance.lean:278,291`), `mem_chartLocus_iff_hasWitnessH1Vanishing` (`Pic0ChartLocusIsOpen.lean:293`), `chartLocusOpens` / `mem_chartLocusOpens` / `IsChartLocusFibre` / `isChartUniv_of_isChartLocusFibre` (`Pic0ChartUnivReduce.lean:115,124,152,170`), `ChartLocusAffineLocal` / `chartLocusOpens'` / `mem_chartLocusOpens'` / `chartLocusAffineLocal_of_presentation` (`Pic0ChartCoverageAbel.lean:132,142,148,182`), `chartLocusAffineLocal_of_plusFibre` / `isOpen_chartLocus_of_plusFibre` / `chartLocusOpensOfPlusFibre` / `mem_chartLocusOpensOfPlusFibre` (`Pic0ChartLocusPlusFibre.lean:120,149,173,185`), `isOpen_chartLocus_of_isPlusHonest` / `chartLocusOpensOfIsPlusHonest` / `mem_chartLocusOpensOfIsPlusHonest` (`Pic0ChartPlusFibreProducer.lean:316,334,343`), `mem_chartLocus_of_isSplitWitness_fibre` / `mem_chartLocus_of_drop` (`Pic0ChartCoverageTest.lean:95,200`), `mem_chartLocus_of_witness_h1` / `mem_chartLocus_of_vanishing_bound` / `exists_mem_chartLocus_of_vanishing_bound` (`Pic0ChartCoverageNoDrop.lean:106,154,214`).

Every one of these either builds the *open* (`W`) or proves *membership* (`t ∈ chartLocus`). None produces the morphism `x : (W : Scheme.{u}) ⟶ X i` or the class equation `hx`. The nearest thing is `IsChartLocusFibre` (`Pic0ChartUnivReduce.lean:152`), whose `r` field *is* such a morphism — but it is a hypothesis (`Prop`), is CERT-Σ/divRep-gated through `exists_factor`, and nothing in the tree produces it.

### 5. `sorry`-reachability

**No `sorry` in any file of the chain.** Direct grep: zero occurrences of the token in `Pic0SigmaSheaf.lean`, `Pic0ChartLocalSurjectivity.lean`, `Pic0ChartCoveragePointwise.lean`, `Pic0ChartCoverageNoDrop.lean`, `Pic0ChartCoverageAbel.lean`, `Pic0ChartCoverageTest.lean`, `Pic0ChartCoverageIndexSlack.lean`, `Pic0ChartLocus.lean`, `Pic0ChartUnivReduce.lean`, `Pic0ChartSplit.lean`, `Pic0ChartCoverageDegreeStep2.lean`, `Pic0ChartLocusPlusFibre.lean`, `Pic0ChartAtlasCoupling.lean`, `Pic0ChartOpenImmersionCriterion.lean`, `DivRepAffPullClause.lean`, `UniformVanishing.lean`. (`Pic0ChartPair.lean` has one occurrence, at line 29, inside a docstring saying "Landed here, sorry-free".)

**Import-closure result, which matters more.** I computed the transitive project-module closure of the chain seeds (365 modules) and scanned every one for `sorry` outside comments. The only hits are **`AlgebraicJacobian/Challenge.lean`, 15 sorries** (`:99,108,113,117,121,126,134,147,156,157,158,248,259,272,283` — `Jacobian`, `instGrpObj`, the four property instances, `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`, `functor`'s three fields, and four base-change laws). `Challenge.lean` **is** in the closure, reached via `Pic0ChartCoveragePointwise → Pic0ChartLocalSurjectivity → Pic0ChartUnivReduce → … → BaseChangeInstances → RiemannRoch.Degree → RiemannRoch.ChiCurve → Challenge` and via `Pic0ChartCoverageNoDrop → Pic0ChartCoverageTest → Pic0ChartCoverageFibre → DivSchemeSeedUnivAssembleKappa → Cohomology.H1BaseFieldInvariance → Challenge`.

That is import-level, not use-level. Kernel check settles it: `#print axioms` (via `lean_verify`) on `isLocallySurjective_sigmaDesc_of_pointwise`, `pointwise_of_chartsCoverLocally`, `exists_mem_chartLocus_of_vanishing_bound`, `exists_splitting_of_picEt`, `exists_bound_subsingleton_hModule_one_of_isFinite_toP1`, and `isLocallySurjective_restrictChart_of_pointwise` each returns exactly `["propext", "Classical.choice", "Quot.sound"]` — no `sorryAx`. The three importers of `Challenge.lean` consume only `genus` (`:89`, which is a real definition, not a sorry) and the surrounding non-sorried instances. So the chain is **not `sorry`-reachable at the kernel level**, while sitting in an import closure that contains 15 sorries — worth knowing for anyone running a module-level probe.

### Bottom line

B-6 as a *reduction* is complete and sorry-free: pointwise datum ⟹ instance, one step, with a converse showing the sieve form gives the datum back up to the opens-vs-cover-map difference the docstring names. What is missing is the datum's last two components — a chart point over the open and its class equation — for which there is no producer, since both need a `rep` nobody has. Item 3's `∃`-form theorem does not supply them either: it yields membership of `chartLocus` (a `Prop` about a split witness), not a morphism, and its `hb` needs a finite dominant `π_L : C_L ⟶ P1 L` that the tree does not construct, on top of the `b = n` calibration that makes `hb` at `n = g` a statement the tree itself proves false in general.
