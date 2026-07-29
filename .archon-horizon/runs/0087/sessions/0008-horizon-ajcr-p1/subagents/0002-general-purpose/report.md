The census is complete. All items gathered; report follows.

## 1. `univSeed`

**Definition** — `AlgebraicJacobian/Picard/DivRepChartClassUniv.lean:131-134`, namespace `AlgebraicGeometry.PointwiseAchiever`:

```lean
noncomputable abbrev univSeed (hb : 0 < windowBound pi hpi) :
    ThetaGeneratorSeed C RZ pi (windowM_choice pi hpi g)
      (divUniversalSeedK C pi hpi g r1 r2 b1 b2 i j) :=
  highWindowPointwiseGeneratorSeed C hpi g r1 r2 b1 b2 i j hO hchi hb
```

with `RZ` the file-local notation (`:125-127`) for `DivCarveChartRing k (windowS_choice pi hpi g • fiberWeilDivisor pi) (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1 b2 i j`.

**It has no `supportLocus` of its own.** `supportLocus` (`Picard/SupportTube.lean:131`, `def supportLocus : Set X := (d.unitLocus : Set X)ᶜ` where `unitLocus := ⨆ x, X.basicOpen (d.eqn x)`) is a field-free function of a `LocalEquations`, not of a seed. The seed reaches one only through `localEquations` (`Picard/DivSchemeFamily.lean:349`), which needs the generator clause:

```lean
noncomputable def localEquations [IsNoetherianRing R] (hD : D.IsGenerator) :
    (relCurve C R).LocalEquations where
  cover := { opens := D.piece, mem_opens := D.mem_piece }
  eqn := D.eqn
  ...
```

So the probe's object is `(univSeed …).localEquations (isGenerator_univSeed …)`, which the tree already names: `PointwiseAchiever.univSystem`, `Picard/DivRepChartClassUnivZarLocal.lean:261-264`.

**Unfolding chain, all measured:** `univSeed` = `highWindowPointwiseGeneratorSeed` (`Picard/DivSchemeHighWindowPointwiseGenerator.lean:76`) = `pointwiseGeneratorSeed … (pointwiseSeedRDN_of_highWindow …)` (`Picard/DivSchemeSeedUnivPointwiseGenerator.lean:258`) = `ThetaGeneratorSeed.productCutter (pointwiseBaseSeed …) …` (`Picard/DivSchemeRedesignSeedUnivProduct.lean:43`), and `productCutter` sets `side := D.side`, so the seed's side function is `pointwiseBaseSeed`'s, namely `pointwiseSide` (`Picard/DivSchemeSeedUnivPointwiseGenerator.lean:202`):

```lean
noncomputable def pointwiseSide (z : relCurve C RZ) : Bool :=
  (exists_mem_relPinnedChart (C := C) (π := π) z).choose
```
(`Picard/DivSchemeSeedUnivPointwise.lean:88`)

**This is decisive for the probe as stated.** `pointwiseSide` is a `Classical.choose` off `exists_mem_relPinnedChart` (`Picard/DivSchemeSeedUnivGen.lean:63`, proved from `relCover_sup`), so the side of a point is not computable from the geometry — it is whatever choice extracted. Any attempt to show two support points take *opposite* sides (the shape `DivRepChartClassUnivZarLocal.lean:208` prescribes) has to reason about `Classical.choose`, and there is no lemma in the tree pinning `pointwiseSide` at any point.

**All files mentioning `univSeed`** (four, matching the row):
- `Picard/DivRepChartClassUniv.lean` — defines it (`:131`), `isGenerator_univSeed` (`:137`), the ε-identity `divFamEps_highWindow_eq_universal_pair` (`:166`), existential form (`:200`), `divFamZarUniv` (`:213`). All consume a certificate `hc`; none touches support.
- `Picard/DivRepChartClassUnivFree.lean` — same statements with `hb` replaced by `g ≠ 0` (`:153, :170, :183`).
- `Picard/DivRepChartClassUnivAny.lean` — `:232` weakens `hc` to `HasCertifiedAdaptation`; `:261` `divFamZarUnivOfHasCertifiedAdaptation`. Carries the refutation warning at `:223-231`.
- `Picard/DivRepChartClassUnivZarLocal.lean` — `univSystem` (`:261`), `ForallPrimeAwayCertified` (`:273`), `divFamZarUnivOfForallPrimeAway` (`:287`), and the prose owing the probe (`:89-119`).

None compares support to charts. Confirmed.

## 2. The pinned charts

`V₀`/`V₁` are fields of `Scheme.AffineTwoCover` (`Picard/AffineTwoCover.lean:51-63`). The pinned pair is `relCover C R (fiberTwoCover π)`: `fiberTwoCover` at `Cohomology/RigidEngine4Relative.lean:75` (`V₀ := fiberChart₀ π = π⁻¹D₊(X₀)`, `V₁ := fiberChart₁ π`), base-changed by `relCover` (`Cohomology/RelativeTwoCover.lean:128`, `:= D.pullbackProd R`, preimages under the first projection).

Side-indexed spelling, `Picard/DivSchemeFamilySide.lean:115`:
```lean
noncomputable def relPinnedChart : Bool → (relCurve C R).Opens
  | false => (relCover C R (fiberTwoCover π)).V₀
  | true  => (relCover C R (fiberTwoCover π)).V₁
```
A second, `rfl`-equal spelling `pinnedChartOfSide` (a `bif`) sits at `Picard/DivisorFamilyAffCover.lean:196`; `AffAdaptation.pinnedChartOfSide_eq` (`Picard/DivisorFamilyAffTheta.lean:153`) reconciles them.

"A point outside V₀ and a point outside V₁" is spelled, in both straddling theorems, as two set-membership negations at the coercion:
```lean
(hx₀ : x ∉ ((relCover C R (fiberTwoCover pi)).V₀ : Set (relCurve C R)))
(hy₁ : y ∉ ((relCover C R (fiberTwoCover pi)).V₁ : Set (relCurve C R)))
```
Note the pairing: `x` off `V₀`, `y` off `V₁` — one witness per chart, and they may be distinct points. `relPinnedChart` does *not* appear in the hypotheses; only the raw `relCover … .V₀/.V₁`.

## 3. The two straddling theorems, verbatim

`AlgebraicGeometry.forall_not_isCertified_of_straddling`, `Picard/DivisorFamilyAffStrict.lean:127-134`. Section binders at `:109-111`: `{k : Type u} [Field k] {C : Over (Spec (.of k))} [IsProper C.hom]`, `{R : Type u} [CommRing R] [Algebra k R]`, `{pi : C.left ⟶ P1 k} [IsFinite pi]`.

```lean
theorem forall_not_isCertified_of_straddling
    {d : (relCurve C R).LocalEquations}
    (hconn : _root_.IsPreconnected d.supportLocus)
    {x y : relCurve C R} (hx : x ∈ d.supportLocus) (hy : y ∈ d.supportLocus)
    (hx₀ : x ∉ ((relCover C R (fiberTwoCover pi)).V₀ : Set (relCurve C R)))
    (hy₁ : y ∉ ((relCover C R (fiberTwoCover pi)).V₁ : Set (relCurve C R))) :
    ∀ (A : DivisorAdaptation C R pi d) (n : ℕ), ¬ A.IsCertified n :=
  fun A _ => A.not_isCertified_of_isPreconnected_of_witnesses hconn hx hy hx₀ hy₁
```

The roadmap's "takes its base ring as a SECTION VARIABLE" is accurate — `R` is a section variable, and `d` is implicit, so the schema instantiates at `Localization.Away r` with the pulled system. Its engine is `DivisorAdaptation.not_isCertified_of_isPreconnected_of_witnesses` (`Picard/DivSchemeCertZarVerdict.lean:62`), which runs through `supportLocus_subset_chart_of_isCertified` (`Picard/DivSchemeCertZarC1.lean:131`) → `supportLocus_subset_chart_of_isPreconnected` (`Picard/DivSchemeCertZarConn.lean:149`), whose upgrade step consumes `relCover_sup` (`V₀ ⊔ V₁ = ⊤`).

`AlgebraicGeometry.AffAdaptation.isEmpty_chartTyping_of_straddling`, `Picard/DivisorFamilyAffTheta.lean:658-667`. Namespace `AffAdaptation` (opened `:139`); section binders `:132-142`, note `{π : C.left ⟶ P1 k} [IsFinite π]` and the ambient `(A : AffAdaptation D d) (τ : …) (a : ℕ)` — but `D` here is the *theorem's own* explicit binder, shadowing:

```lean
theorem isEmpty_chartTyping_of_straddling (D : AffCoverData C R) (j : D.index)
    {x y : relCurve C R} (hxj : x ∈ D.pieces j) (hyj : y ∈ D.pieces j)
    (hx₀ : x ∉ ((relCover C R (fiberTwoCover π)).V₀ : Set (relCurve C R)))
    (hy₁ : y ∉ ((relCover C R (fiberTwoCover π)).V₁ : Set (relCurve C R))) :
    IsEmpty (ChartTyping C R π D) := by
```

Both witnesses must lie in **one piece** `j` — this is about a widened `AffCoverData`, not about `d.supportLocus` at all. `ChartTyping` is `Picard/DivisorFamilyAffCover.lean:204` (`side : D.index → Bool`, `piece_le : ∀ j, D.pieces j ≤ pinnedChartOfSide C R π (side j)`).

## 4. `IsLocallyCertified`, `divFamZarSetoid`, `DivFamZar`

`Picard/DivisorFamilyZar.lean:71-80` (binders `:60-62`: `C : Over (Spec (.of k))`, `(R : Type u) [CommRing R] [Algebra k R]`, `(π : C.left ⟶ P1 k) [IsAffineHom π]`):

```lean
def IsLocallyCertified (n : ℕ) (d : (relCurve C R).LocalEquations) : Prop :=
  ∃ (m : ℕ) (g : Fin m → R), Ideal.span (Set.range g) = ⊤ ∧
    ∀ i : Fin m,
      haveI : IsOpenImmersion (relCurveMap C R (Localization.Away (g i))) :=
        isOpenImmersion_relCurveMap_away C R (Localization.Away (g i)) (g i)
      ∃ G : CertifiedDivisorFamily C (Localization.Away (g i)) π n,
        Scheme.LocalEquations.DivEq G.eqns
          (d.pullback (relCurveMap C R (Localization.Away (g i)))
            (Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion
              (relCurveMap C R (Localization.Away (g i))) d))
```

`:224-229` and `:235`:
```lean
def divFamZarSetoid : Setoid {d : (relCurve C R).LocalEquations //
    IsLocallyCertified C R π n d} where
  r d₁ d₂ := Scheme.LocalEquations.DivEq d₁.1 d₂.1
  iseqv :=
    ⟨fun d => Scheme.LocalEquations.divEq_refl d.1,
     fun h => h.symm, fun h h' => h.trans h'⟩

def DivFamZar : Type u := Quotient (divFamZarSetoid C R π n)
```

The `CertifiedDivisorFamily` inside `IsLocallyCertified` is the chart-typed one (it carries a `DivisorAdaptation`, which extends `FinCoverData`), which is why the no-go instantiates at the away ring — as `DivRepChartClassUnivZarLocal.lean:41-47` states, correctly.

## 5. Nothing computes, bounds, or hypothesises `univSeed`'s support relative to the pinned charts

Searched case-insensitively for `straddl`, `supportLocus`, `support`, `univSeed`, `univSystem` across all of `AlgebraicJacobian/`. The complete list of declarations whose name mentions straddling is four: `forall_not_isCertified_of_straddling`, `exists_affAdaptation_isCertified_of_straddling`, `isEmpty_chartTyping_of_straddling`, `side_straddle_gives_chart_separated_pieces`. None mentions `univSeed`. No declaration anywhere takes `univSeed`/`univSystem` and says anything about `supportLocus`. The row's claim stands.

**Two near misses worth pricing before a lane starts, both landed and both about a general seed, hence applicable to `univSeed`:**

- `ThetaGeneratorSeed.exists_matrix_opens_supportLocus_subset_twisted_chartInter` (`Picard/DivSchemeCertZarFibreAvoid.lean:355-365`): for **any** generator seed, at any base prime `p`, there is a `GL₂(k)` twist `M` and a base neighbourhood `V ∋ p` with `base⁻¹(V) ∩ (D.localEquations hD).supportLocus ⊆ (twistedRelCover C R π M).V₀ ⊓ .V₁`. Proved from the seed's own `fibre_regular` clause — no certificate. It is about `twistedRelCover` (`Cohomology/TwistedFiberTwoCover.lean:81`, `= relCover C R (twistedFiberTwoCover π M)`), not the pinned `fiberTwoCover`, so it does **not** answer the probe; it says the support is chart-confinable after a coordinate change, locally on the base. This is the closest thing in the tree to the measurement, and it cuts *toward* non-straddling in the twisted charts while saying nothing at `M = 1`. Requires `[Infinite k]` (section variable at `:270`).
- `PointwiseAchiever.supportLocus_ncard_residueFibreLocalEquations_pointwiseGeneratorSeed_le` (`Picard/DivSchemeCertZarFibreAvoid.lean:408`): the residue-fibre support of `pointwiseGeneratorSeed` — i.e. of `univSeed` up to the RD-N argument — has `ncard ≤ g` at every prime. A finiteness bound on the fibre support, not a chart comparison. Note its `RZ` is the `seedChartRing` notation (`Picard/DivSchemeRedesignCarvePin.lean:57`), which is an `abbrev` unfolding to the same `DivCarveChartRing` as `DivRepChartClassUniv`'s `RZ`, with `b₂` in the `(windowS + windowM)` spelling — matching.

Also relevant: `IsPreconnected d.supportLocus`, the no-go's first hypothesis, is nowhere established for any seed. So even granting the two witnesses, the refutation needs a third input nobody holds.

## 6. `ChartRing` vs `univSeed`'s ring — the probe is **not** decision-grade as written

`ChartRing` is **not a global definition**. It is a file-local notation in `Picard/DivRepAffPullClause.lean:98-101`:

```lean
local notation "ChartRing" => fun i j =>
  DivCarveChartRing k (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1
    (b2.map (windowShiftEquiv hpi g).symm) i j
```

(`DivCarveChartRing` itself: `Picard/DivSchemeFamilyUniv.lean:55`, `abbrev … := PairChartRing k g r₁ g r₂ i j ⧸ divCarveIdeal k A B g r₁ r₂ b₁ b₂ i j`.) A separate `ChartRing k d r J` in `Picard/GrassmannianScheme.lean` is an unrelated Grassmannian chart ring — different object, same name.

`IsChartClause` (`Picard/DivRepAffPullClause.lean:119-127`) quantifies over `U : ∀ i j, DivFamZar C (ChartRing i j) pi g`, i.e. over `DivFamZar C (PairChartRing … ⧸ divCarveIdeal … b1 (b2.map (windowShiftEquiv hpi g).symm) i j) pi g`.

**The mismatch:** `DivRepAffPullClause.lean`'s section binder for `b2` (`:89-91`) is a basis of `divisorSections k ((windowM_choice + windowS_choice) • fiberWeilDivisor pi) ⊤` and it feeds `b2.map (windowShiftEquiv hpi g).symm` to `DivCarveChartRing`. `univSeed`'s files bind `b2` (`DivRepChartClassUniv.lean:118-120`) as a basis of `divisorSections k ((windowS_choice • F) + (windowM_choice • F)) ⊤` and feed **bare `b2`**. `windowShiftEquiv` (`Picard/DivSchemeClassifyBridge.lean:86-92`) is exactly the `LinearEquiv.ofEq` between those two spellings, built from `add_nsmul`/`add_comm`. So the two `RZ`s are the same ring *provided* the transport aligns — the divisor argument to `DivCarveChartRing` is the same `A B` pair in both, and only the basis argument differs by that reindexing.

That alignment is **not proved anywhere in the tree**, and no declaration connects any of the four `divFamZarUniv*` (`…Univ.lean:213`, `…UnivFree.lean:183`, `…UnivAny.lean:261`, `…UnivZarLocal.lean:287`) to `IsChartClause`. Grepped: `IsChartClause` appears only in `DivRepAffPullClause.lean` and `DivRepChartRange.lean` (which states `isChartClause_iff_forall_classify_eq`, `:186`), never with `univSeed` or `divFamZarUniv`. `DivRepChartClassUniv.lean:67` says so itself: "It produces no certificate, hence no `DivFamZar` over `R_Z` and no `IsChartClause`."

So the answer to the caller's own gating question: `univSeed` is over `DivCarveChartRing … b1 b2 i j`, while U2's `IsChartClause` binds `DivFamZar C (DivCarveChartRing … b1 (b2.map (windowShiftEquiv hpi g).symm) i j) pi g`. They are plausibly the same object under a landed reindexing, but nothing in Lean says the family `univSeed` supplies is the family `IsChartClause` quantifies over. Until that rfl (or transport) is measured, a straddling verdict on `univSeed` decides the fate of `divFamZarUniv`, not directly of U2's class half.

**One further correction to the row's framing.** `DivRepChartClassUnivZarLocal.lean:89-105` already argues, and I confirm from the definitions, that "does `univSeed`'s supportLocus meet both V0 and V1?" is the wrong measurement for the *no-go*: `localEquations` builds a pointed cover with one member per point and `side` a function of the point, so per-piece chart confinement (`ThetaGeneratorSeed.piece_le`, `Picard/DivSchemeFamily.lean:98`) is free and global straddling is permitted but not produced. The support-locus question *is* however exactly what `forall_not_isCertified_of_straddling` consumes (`hx`, `hy` are `∈ d.supportLocus` with no piece mentioned), so the row's spelling is the right one for the refutation and the sibling file's `side`-based reframing is the right one only for `isEmpty_chartTyping_of_straddling`. Those are two different theorems and the two files each describe one of them.
