## 1. THE ANCHOR AND THE TWO INDEPENDENT LADDERS

`pic0RepresentableByOfCharts` — `AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161`, sorry-free (file has 0 `sorry`). Antecedent 3 is the instance binder `[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]`.

**Structural finding first, because it governs everything below: the coverage chain is two ladders that do not meet.**

- Ladder A (site/sieve side): reduces the instance down to a *pointwise datum whose payload is a class equation* `(f i).app (op ↑W) x = (pic0SigmaSheaf C).1.map W.ι.op s`.
- Ladder B (geometry side): produces `t ∈ chartLocus C m Z lam`.

`chartLocus` appears as a **conclusion** in 6 declarations and as a **hypothesis in zero**. Verified by `grep -rn "(h[a-z]* : .* ∈ chartLocus"` and by reading every `chartLocus` occurrence in the four files that carry both idioms (`Pic0ChartCoveragePointwise.lean:112`, `Pic0ChartAtlasCoupling.lean:24,50-53,141-142`, `Pic0ChartRestrictedFibre.lean:23-24`, `Pic0ChartOpenImmersionCriterion.lean:120` — **all prose, no Lean**). So ladder B's output is not consumed by ladder A anywhere. This is stated in the tree only as the "spreading-out" sentence quoted in §4.

## 2. LADDER A — SITE SIDE (all sorry-free, all rooted)

| decl | file:line | status |
|---|---|---|
| `ChartsCoverLocally` (`def … : Prop`) | `Pic0ChartLocalSurjectivity.lean:86` | named obligation |
| `isLocallySurjective_sigmaDesc` | `:103` | proved |
| `chartsCoverLocally_of_forall_surjective` | `:125` | proved (degenerate non-vacuity: one surjective chart) |
| `mem_zariskiTopology_iSup_of_pointwise` | `Pic0ChartCoveragePointwise.lean:92` | proved, chart-free |
| `chartsCoverLocally_of_pointwise` | `:128` | proved |
| `isLocallySurjective_sigmaDesc_of_pointwise` | `:145` | proved |
| `pointwise_of_chartsCoverLocally` | `:173` | proved converse |
| `mem_zariskiTopology_of_pullback_affine` | `Pic0ChartCoverageAffineTest.lean:128` | proved, chart-free |
| `chartsCoverLocally_of_affineLocal` | `:150` | proved — adds `[IsAffine Y]` only |
| `isLocallySurjective_sigmaDesc_of_affine` | `:181` | proved |
| `affineLocal_of_chartsCoverLocally` | `:200` | proved, but is `rfl`-equal to `:173`; its own header (`:69-77`) retracts the claim that it is a converse |
| `PointwiseCoverage` (`def … : Prop`) | `Pic0ChartAtlasCoupling.lean:99` | named obligation |
| `restrictChart_app_apply` | `:117` | `rfl` |
| `liftPointwiseToOpens` | `:143` | proved |
| `isLocallySurjective_restrictChart_of_pointwise` | `:164` | proved |
| `pointwise_of_pointwise_restrictChart` | `:192` | proved converse |
| `isLocallySurjective_sigmaDesc_mono` / `_unrestricted` / `_of_bot` | `Pic0ChartVMonotone.lean:196,250,272` | proved |
| `nested_iff_shared`, `shared_top_of_nested` | `:397,416` | proved |
| `chartsCoverLocally_of_slice`, `isLocallySurjective_of_slice` | `Pic0ChartCoverageSlice.lean:187,216` | proved |

**THE LOWEST-LEVEL STATEMENT A COVERAGE PRODUCER MUST PROVE**, read off `Pic0ChartCoverageAffineTest.lean:152-154` (cheapest quantifier form in the tree):

```lean
(h : ∀ (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y),
  ∃ (W : Y.Opens) (_ : y ∈ W) (i : ι) (x : (W : Scheme.{u}) ⟶ X i),
    (f i).app (op (W : Scheme.{u})) x = (pic0SigmaSheaf C).1.map (W.ι).op s)
```

At the atlas the seam actually consumes (`restrictChart`), one conjunct is added — `Pic0ChartAtlasCoupling.lean:146-148`: `Set.range (x.base) ⊆ Set.range ((V i).ι.base)`, and `:192` proves that conjunct is *exactly* the difference, not a convenience.

Two `V`-endpoint refutations, both proved: `not_coverageContainment_bot` (`Pic0ChartRestrictedFibreSat.lean:248`) kills the containment at `V = ⊥` where `isChartUniv_bot` (`:223`) is free; `range_subset_range_top_ι` (`:279`) makes it free at `⊤` where antecedent 1 returns the unrestricted certificate three headers call false. `isLocallySurjective_unrestricted` (`Pic0ChartVMonotone.lean:250`) proves coverage at *any* `V` implies coverage at `⊤` — so the restriction buys nothing on this antecedent. `nested_iff_shared` (`:397`) proves the two-open escape collapses.

## 3. LADDER B — GEOMETRY SIDE (all sorry-free, all rooted)

| decl | file:line | notes |
|---|---|---|
| `IsSplitWitness` (`def … : Prop`) | `Pic0ChartLocus.lean:151` | asks `∃ L/K` fin. sep., presenting `M`, `∃ W` with `picClass L W = M ∧ Subsingleton H¹`. **No `0 ≤ W`, no `deg W = g`** |
| `chartLocus`, `mem_chartLocus_iff` | `:244`, `:249` | |
| `mem_chartLocus_of_isSplitWitness_fibre` | `Pic0ChartCoverageTest.lean:95` | |
| `mem_chartLocus_of_drop` | `:200` | 15 binders incl. 4-part point oracle; header `:106-158` proves its own arithmetic forces `e = 0` |
| `exists_isSplitWitness_of_drop` | `Pic0ChartCoverageFibre.lean:105` | ends in `exists_effective_sub_h0_eq_one` |
| `mem_chartLocus_of_witness_h1` | `Pic0ChartCoverageNoDrop.lean:106` | **the drop-free membership route**: splitting `hM₀` + any `W` in the twisted class with `Subsingleton H¹`. Strictly generalises `:200`'s membership half |
| `mem_chartLocus_of_vanishing_bound` | `:154` | adds threshold `hb` + ledger `hdeg` |
| `exists_mem_chartLocus_of_vanishing_bound` | `:214` | `∃ m' Z'` form |
| `classDeg_presenting_eq_zero`, `_twist`, `_twist_eq_add` | `Pic0ChartCoverageDegreeStep2.lean:98,125,148` | step 2, landed |
| `classDeg_chartTwistClass_baseChange` | `Pic0ChartCoverageDegree.lean:93` | |
| `classDeg_of_presenting` | `:140` | true, **no consumers** (own docstring `:135-137`) |
| `ledger_forces_b_eq_n` | `Pic0ChartCoverageIndexSlack.lean:119` | `hdeg` **forces** `b = n` |
| `index_of_threshold` | `:147` | `hdeg` satisfiable at `n := b.toNat` |
| `hb_forces_h0_eq_one` | `:180` | `hb` at `b = n` ⟹ every degree-`n` divisor has `h⁰ = 1` — **false in general for `n = g ≥ 1`** |

Openness side (feeds the `W`/`chartLocusOpens` field, not the coverage antecedent): `ChartLocusAffineLocal` (`Pic0ChartCoverageAbel.lean:132`) ← `chartLocusAffineLocal_of_presentation` (`:182`) ← `IsChartDatumPresentation` (`Pic0ChartLocusIsOpen.lean:178`) ← `IsChartDatumPlusFibre` (`Pic0ChartPresentationHalf.lean:103`) ← `IsPlusHonest` (`Pic0ChartPlusFibreProducer.lean:200`). That chain **is** closed: `isOpen_chartLocus_of_isPlusHonest` (`:316`) + `abelDiv_isPlusHonest` (`:275`), `thetaFamily_isPlusHonest` (`:245`), `chartTwist_isPlusHonest` (`:294`).

`Pic0ChartCoverageAbel.lean:105` `abelChartApp_eq` (`rfl`) is the crossing: the datum's class equation is a **pair** equation (Σ-component + class).

## 4. NAMED RESIDUES — `def … : Prop`, with producer census (case-insensitive)

| Prop | file:line | producer? |
|---|---|---|
`ChartsCoverLocally` | `Pic0ChartLocalSurjectivity.lean:86` | only reductions + degenerate `:125`. **No geometric producer** |
`PointwiseCoverage` | `Pic0ChartAtlasCoupling.lean:99` | **none** (only `:149` conclusion from a hypothesis of the same shape, and `:194`) |
`ChartLocusAffineLocal` | `Pic0ChartCoverageAbel.lean:132` | yes: `:182`, `Pic0ChartLocusPlusFibre.lean:120` |
`IsChartDatumPresentation` | `Pic0ChartLocusIsOpen.lean:178` | yes: `Pic0ChartPlusFibreTower.lean:215`, `Pic0ChartPresentationHalf.lean:166`, `Pic0ChartPresentationConverse.lean:295` |
`IsChartDatumPlusFibre` | `Pic0ChartPresentationHalf.lean:103` | yes: `exists_isChartDatumPlusFibre_of_mem_range` (`Pic0ChartPlusFibreProducer.lean` ~:180) |
`IsPlusHonest` | `Pic0ChartPlusFibreProducer.lean:200` | yes for θ/Σ/abelDiv/chartTwist (`:245,256,275,294`); **not for a general `lam`** |
`IsSplitWitnessIsoInvariant` | `Pic0ChartLocusGeneralTest.lean:129` | **proved**: `isSplitWitnessIsoInvariant_holds`, `Pic0ChartLocusIsoInvariance.lean:263` |
`IsChartLocusFibre` | `Pic0ChartUnivReduce.lean:167` | none; its own docstring `:138-149` says it is conditionally **unsatisfiable** |
`RestrictedChartFibre` | `Pic0ChartRestrictedFibre.lean:143` | `restrictedChartFibre_of_isChartLocusFibre` (`:209`) + `restrictedChartFibre_bot` (`Sat:181`) |
`RelPicSeparatesDivFamZar` | `Pic0ChartAbelForkReduce.lean:237` | **zero producers project-wide** |

Un-produced hypotheses in the chain: `rep : (divFunctor C π n).RepresentableBy D` (divrep, no producer — stated at `Pic0ChartVMonotone.lean:343`, `Pic0ChartRestrictedFibre.lean:259ff`), the twist exponent `m` and `hb`/`hdeg` pair.

## 5. EFFECTIVITY / RIEMANN-ROCH INPUTS — all over a FIELD, all sorry-free

| decl | file:line | base |
|---|---|---|
`exists_effective_sub_h0_eq_one` | `RiemannRoch/CoverageDrop.lean:213` | field `K`, curve bundle `Y`; needs oracle `P` (dense, closed, `residueDeg = 1`), `deg W = g + e`, `Subsingleton H¹` |
`exists_admissible_nonbase_point` | `:86` | field |
`h0_sub_single_of_rational_nonbase` | `:141` | field |
`exists_effective_of_picClass` | `RiemannRoch/FLVClass.lean:208` | field; entry `1 ≤ deg W + χ` |
`h0_eq_deg_add_chi_of_subsingleton_hModule_one` (rank anchor) | `:412` | field |
`exists_effective_of_h0_pos` | `RiemannRoch/SectionBound.lean:175` | field |
`exists_effective_deg_eq_of_le_classDeg` | `JacobianDataAbelDegreeWindow.lean:138` | field; window `g ≤ d` |
`exists_effective_of_classDeg_eq_zero_of_le_deg` | `:169` | field — closest to "degree-zero class, after twisting, effective" |
`h0_eq_one_of_subsingleton_hModule_one_of_deg_eq` | `:283` | field; **`h¹ = 0` + `deg = g` ⟹ `h⁰ = 1`** |
`eq_of_picClass_eq_of_deg_eq_of_subsingleton_hModule_one` | `:307` | field |
`exists_effective_deg_eq_of_classDeg_eq_zero` / `_relCurve_` | `JacobianDataAbelEffective.lean:147,225` | field |
`exists_effective_deg_eq_of_pic0_at_point` | `JacobianDataAbelEffectivePoint.lean:137` | at a **point** of a test `J`, via `Over.testPoint` ⟹ field |
`DivFamZar.exists_effective_witness` | `DivisorFamilyH1Locus.lean:146` | ring-indexed family, but conclusion at a **field** `L` of the tower |

**No declaration in the project produces an effective representative over a general base ring/test.** Every one lands over a field, reached through `Over.testPoint`/`relCurve C L`.

## 6. THE GAP SENTENCE — it is (d), a spreading-out, not (a)/(b)/(c)

Quoted verbatim:

- `Pic0ChartCoverageSlice.lean:213-215`: "**The class equation is still open**, and it is the whole of what is left here. Its cost is a divisor family over a *neighbourhood* produced from data at a *point* — a spreading-out, absent from the tree for this carrier."
- `Pic0ChartCoverageSlice.lean:43-49` (same claim with the census): "every `DivFamZar` producer takes its base ring or the affine-opens limit first; the only spreading lemmas, `exists_supportTube` and its `Confine` instance, act on the support locus of an already-given local-equation system, not on a class; mathlib's `spread_out_of_isGermInjective'` is about morphism germs."
- `Pic0ChartCoverageAffineTest.lean:62-67`: "It does **not** produce the datum at an affine test. That is B-5's geometry and it remains open."
- `Pic0ChartCoverageIndexSlack.lean:61-67`: "the residue is neither 'instantiate DAT-0a' … nor 'restate with slack' … It is: **reconcile the chart parameter with the threshold** … whose own legality (`0 ≤ Σ`) is the open question."
- `Pic0ChartCoverageTest.lean:144`: "What remains of B-5 is step 3's per-fibre `m`."
- `Pic0ChartAtlasCoupling.lean:24-28`: "The two opens the route wants to identify live on different objects … and no declaration in the tree relates them. That is an obligation *between* two antecedents, owned by no row."
- `Pic0ChartCoverageAffineTest.lean:80-87`: "the pair `(huniv V, hcov V)` has **no measured inhabitant at any `V`** (`I-1012`). Two bad endpoints are two refutations, not a non-vacuity check."

Not (b): no `IsPlusHonest`-style honesty statement gates the *coverage* antecedent — honesty gates openness (`chartLocusOpens`'s `haff`), which is the `W` field of antecedent 1. Not (c): `IsLocallyCertified` occurs in zero `Pic0Chart*` files.

## 7. SORRY / ROOTEDNESS

All 10 `Pic0ChartCoverage*.lean`, `Pic0ChartAtlasCoupling`, `Pic0ChartVMonotone`, `Pic0ChartLocalSurjectivity`, `Pic0ChartLocus`, `Pic0ChartTwistSplit`, `RiemannRoch/CoverageDrop`, `Pic0SigmaSheaf`: **0 `sorry`**. Whole-project real sorries: **17**, all in `Challenge.lean` (15, incl. `Jacobian`, `baseChangeIso`) and `Pic0ThetaCocycle.lean:246,320`. Import-closure check (Python, 330-345 modules per target): every coverage-chain file transitively imports `Challenge` (via `RiemannRoch/ChiCurve`, `Curve/CrossBaseSquare`, `Cohomology/H1BaseFieldInvariance`) — so the closures are not sorry-free as *files*, though no coverage declaration cites a sorried `Challenge` constant (`grep` for `Jacobian C`/`baseChangeIso` in the chain: zero hits).

All chain files are in `AlgebraicJacobian.lean` (root=1). Two are leaves with no importers: `Pic0ChartCoverageSlice.lean`, `Pic0ChartVMonotone.lean`; also `Pic0ChartPlusFibreProducer.lean`.
