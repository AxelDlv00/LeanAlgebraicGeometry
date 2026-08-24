# E-v campaign worksheet — degree multiplicativity under pullback (`AJCR.w7-functor.ev`)

**RATIFIED — BINDING (orchestrator, 2026-07-17 night session).** All §6 ratification
points adopted as recommended: the EV-main statement pin (Over-form, finrank along
`functionFieldMap`, multiplicativity decoupled from the dichotomy), the EV-2 route
through `Algebra.IsAlgebraic.finrank_of_isFractionRing` (integral-closure chain =
fallback), the EV-1d closed-immersion factorization route (class-level dodge =
fallback-of-fallback), the two-lane launch plan (Lane A dichotomy ∥ Lane B
multiplicativity), and the file split. TWO RIDERS: (1) any de-privatization in the
landed `RiemannRoch/ChartColength.lean` must be a minimal-diff SEPARATE commit touching
only visibility, with the SB-3b owner named in the message; (2) the Hartshorne
transcription gate resolves by queueing a reference-retriever task, never by citing
unread pages. Deviations go back through the orchestrator.

*Design-probe lane w7-ev-worksheet, 2026-07-17. Skeleton: the ratified `w7-worksheet.md`
§2.1 (EV-1a..EV-4) and its risk R-W7-1, both read in full this session. Evidence:
`w7-recon.md` §2.7/§2.8 (read in full), the landed degree stack re-read at source this
session (`RiemannRoch/Degree.lean`, `DegreeBaseFieldInvariance.lean` — the EV-4 model —
`DegreeBaseChange.lean`, `ChartColength.lean`, `ChiLedger.lean`,
`Curve/BaseFieldTransition.lean`, `Curve/Basic.lean`, `Picard/Pic.lean`), and the pinned
mathlib checkout (v4.31.0, `fabf563a7c…`) read at source for every gift cited below.
**Six machine-checked probes** were run this session via `lean_run_code` (§5: EV-A..EV-E
plus a 23-name `#check` batch); no file outside `informal/` touched, no build, no mutex.*

---

## §0 Verdict in one line

**E-v is a bounded campaign, not a balloon** — the ratified worksheet's hardest-leg flag on
EV-2 is *refuted by machine probe*: the "three-theory dictionary with no composite" EXISTS
in mathlib as a single lemma (`Algebra.IsAlgebraic.finrank_of_isFractionRing`,
`RingTheory/Algebraic/Integral.lean:552`, probe EV-D′ green with zero diagnostics), the
EV-3 gift splice fires at exactly the chart hypotheses EV-2 produces (probe EV-C green),
the EV-1d constant-leg factorization the ratified sheet marked UNPROBED exists in mathlib
(`IsClosedImmersion.lift` + `isClosed_singleton_iff_isClosedImmersion`, probe EV-B closes
EV-const in three rewrites), and EV-1a is a machine-checked two-liner (probe EV-E). The
campaign decomposes into **two gate-free parallel lanes** (dichotomy ∥ multiplicativity)
whose only consumer join is F-6. R-W7-1's "no cheap fallback" clause is retired for EV-2
and downgraded to line-count risk for EV-3 (§3).

---

## §1 The pinned Lean statements

### 1.1 EV-main (probe EV-A: elaborates verbatim against the live tree, zero errors)

Setting: `D E : Over (Spec (CommRingCat.of K))`, both with the standing pack
(`[IsProper _.hom] [SmoothOfRelativeDimension 1 _.hom] [GeometricallyIrreducible _.hom]`),
`h : D ⟶ E` an Over-morphism. The finite/dominant case is stated **with `[Surjective
h.left] [IsFinite h.left]` as hypotheses** — EV-main never mentions the dichotomy; EV-1*
feeds only F-6's case split. `n` is spelled as the function-field degree along the landed
`functionFieldMap`:

```lean
theorem classDeg_cechPicMap_of_isFinite {K : Type u} [Field K]
    (D E : Over (Spec (CommRingCat.of K))) [pack D] [pack E]
    (h : D ⟶ E) [Surjective h.left] [IsFinite h.left] (Λ : E.left.CechPic) :
    -- letI-chain exactly as probed (probe EV-A, §5): `.ofHom D.hom`/`.ofHom E.hom` Over
    -- instances, SmoothOfRelativeDimension/QuasiCompact transported by `inferInstanceAs`,
    -- H⁰/H¹ finiteness by `moduleFinite_hModule_zero/one` (the Degree.lean:216-240 curve
    -- idiom), and
    letI : Algebra E.left.functionField D.left.functionField :=
      (h.left.functionFieldMap (genericPoint_eq_of_surjective h.left)).hom.toAlgebra
    classDeg K (Scheme.CechPic.map h.left Λ)
      = (Module.finrank E.left.functionField D.left.functionField : ℤ) * classDeg K Λ
```

`IsIntegral D.left`/`IrreducibleSpace` are found by instance search (`Curve/Basic.lean:51,
:69` + `Curve/GeometricallyReduced.lean:130,:140,:153` — smooth-of-rel-dim-1 ⇒
geometrically reduced ⇒ integral, all instances). `genericPoint_eq_of_surjective` is
`Curve/BaseFieldTransition.lean:173`.

### 1.2 EV-const (probe EV-B: the close is three rewrites, machine-checked)

```lean
theorem cechPicMap_eq_one_of_factorization {K} [Field K] (D E : Over (Spec (.of K)))
    (h : D ⟶ E) {x : E.left} (q : D.left ⟶ Spec (E.left.residueField x))
    (hfac : q ≫ E.left.fromSpecResidueField x = h.left) (Λ : E.left.CechPic) :
    Scheme.CechPic.map h.left Λ = 1
```

Proof (probed): `← hfac`, `Scheme.CechPic.map_comp` (`Picard/Pic.lean:237`),
`CechPic.eq_one_of_subsingleton` (`:268`; `Subsingleton (Spec κ(x))` =
`inferInstanceAs (Subsingleton (PrimeSpectrum _))`), `map_one`. Corollary
`classDeg K (CechPic.map h.left Λ) = 0` by `classDeg_one` (`Degree.lean:170`). This is
*stronger* than the ratified sheet's "dies in `relPic`" — the class dies in `CechPic`
already; the relPic/test-object version F-1 needs is the same three rewrites at
`h ▷ T`-level and belongs to F-1's file, consuming EV-1d's factorization.

### 1.3 The dichotomy (EV-1c output; consumed only by F-6)

```lean
theorem curveHom_isFinite_or_constant … (h : D ⟶ E) :
    (Surjective h.left ∧ IsFinite h.left)
  ∨ (∃ x : E.left, IsClosed ({x} : Set E.left) ∧ Set.range h.left.base = {x})
```

(The two legs may overlap when `E.left` has a subsingleton space; the disjunction is the
statement, not a partition — see EV-1c's hardest sub-step.)

---

## §2 Leg-by-leg: cites, size, hardest sub-step, bail

Notation: `B_E := Γ(E.left, V)`, `B_D := Γ(D.left, h.left ⁻¹ᵁ V)` for an affine chart
`V ∋ η_E` (preimage affine since `IsFinite ⇒ IsAffineHom`, mathlib
`Morphisms/Finite.lean:39`; `η_D ∈ h⁻¹V` by `genericPoint_eq_of_surjective`).

### EV-1a `h-proper` — **[S], machine-checked this session (probe EV-E)**

- Statement: `IsProper h.left`, plus the free corollaries `LocallyOfFiniteType h.left`,
  `QuasiCompact h.left`.
- Mathlib: `IsProper.of_comp` (`Morphisms/Proper.lean:118`), `IsProper` extends
  IsSeparated/UniversallyClosed/LocallyOfFiniteType (`:42`), `UniversallyClosed ⇒
  QuasiCompact` instance (`Morphisms/UniversallyClosed.lean:164`).
- Project: `Over.w h` supplies `h.left ≫ E.hom = D.hom`.
- To-build: ~15 lines (the probe text). Hardest sub-step: none. Bail: n/a.

### EV-1b `fiber-finiteness` — **[M]; the campaign's only genuinely new geometry brick**

- Statement pin: `{X : Scheme} [X.Over (Spec K)]`-form (RiemannRoch conventions):
  a closed `Z : Set X` of the curve bundle with `genericPoint X ∉ Z` is finite.
- Route (all tools named): `CompactSpace X` (`Curve/Basic.lean:56`) +
  `Scheme.OpenCover.finiteSubcover` (mathlib `Cover/Open.lean:77`) reduce to one affine
  chart `V` (nonempty open in irreducible ⇒ `η ∈ V`); `Z ∩ V = hV.fromSpec ''
  (fromSpec ⁻¹' Z)` via `IsAffineOpen.range_fromSpec` (mathlib `AffineScheme.lean:441`);
  the preimage is closed in `Spec B_E` = `zeroLocus I`
  (`PrimeSpectrum.isClosed_iff_zeroLocus_ideal`); `η ∉ Z` forces `I ≠ ⊥` (`⊥ ∈ zeroLocus
  I ↔ I = ⊥`); `B_E` Dedekind (`ChartColength.lean:126`,
  `isDedekindDomain_section` — landed); primes over a nonzero ideal are finite:
  `Ideal.finite_factors` (mathlib `DedekindDomain/Factorization.lean:86`) +
  `Ideal.dvd_iff_le` (#check-verified) + "every prime in `zeroLocus I` is nonzero, hence
  height-one". Image of finite is finite; finite union over the subcover.
- Mathlib-landed: the two names above + `finiteSubcover`. Project-landed: the
  points↔primes dictionary (`RiemannRoch/ChartPoints.lean`), `isDedekindDomain_section`.
- To-build: one lemma + point-set bookkeeping, ≤200 lines. **Hardest sub-step**: the
  `fromSpec`-transport of "closed subset ↦ ideal" (choosing the vanishing ideal and
  discharging `⊥ ∉ zeroLocus`) — pure bookkeeping, easy to mis-state.
- Bail: none needed (no unverified input). If the chart transport balloons, only F-6's
  case split waits — EV-main (Lane B) is unaffected.

### EV-1c `dichotomy-close` — **[M]**

- Route: image closed (`IsProper ⇒ UniversallyClosed`, `h.left.isClosedMap.isClosed_range`
  — the mathlib idiom at `Morphisms/Finite.lean:204`); image irreducible
  (`IsIrreducible.image`); sober ⇒ image = closure of its generic point `ζ`.
  Case `ζ ≠ η_E`: `{ζ}` closed (`RiemannRoch/ClosedPoint.lean:80`), range = `{ζ}` —
  constant leg. Case `ζ = η_E`: range = `E` ⇒ `Surjective h.left`; fibers: over closed
  `y ≠ η_E` the fiber is closed and avoids `η_D` (`h(η_D) = η_E`) ⇒ EV-1b; over `η_E` the
  fiber is `{η_D}` (a closed point `z ↦ η_E` would make `{η_E}` closed — then `E` is a
  single point and the CONSTANT leg applies instead); every point of a curve is `η` or
  closed (`ClosedPoint.lean:80`). Then `locallyQuasiFinite_iff_finite_preimage_singleton`
  (mathlib `Morphisms/QuasiFinite.lean:318`; its `[LocallyOfFiniteType] [QuasiCompact]`
  hypotheses are EV-1a's corollaries) + **ZMT**
  `IsFinite.of_isProper_of_locallyQuasiFinite` (`ZariskisMainTheorem.lean:371`).
- To-build: ≤250 lines. **Hardest sub-step**: the generic-fiber/singleton-space edge case
  (the `h⁻¹(η_E) = {η_D}` argument and the branch where `E.left` is a one-point space) —
  the disjunction legs overlap there by design (§1.3).
- Bail (real dodge, recorded): if the edge cases balloon, weaken to a THREE-way
  disjunction `finite ∨ constant ∨ Subsingleton E.left` — F-6 kills the third branch by
  `CechPic.eq_one_of_subsingleton` on `E` itself. No re-scope needed.

### EV-1d `constant-leg` — **[S/M]; the mandated probe: mathlib's factorization story is RESOLVED**

- The ratified sheet marked this UNPROBED with a class-level fallback. **Probed this
  session: mathlib has the whole gadget.**
  `isClosed_singleton_iff_isClosedImmersion : IsClosed {x} ↔ IsClosedImmersion
  (X.fromSpecResidueField x)` (`Morphisms/ClosedImmersion.lean:409`) and the universal
  property `IsClosedImmersion.lift (f g) (H : f.ker ≤ g.ker) : Y ⟶ X` with
  `lift_fac : lift f g H ≫ f = g` (`:207,:212`) — both #check-verified.
- Statement pin: `range h.left.base = {x}` + `IsClosed {x}` ⇒
  `∃ q : D.left ⟶ Spec (E.left.residueField x), q ≫ E.left.fromSpecResidueField x = h.left`.
- The one obligation: `(fromSpecResidueField x).ker ≤ h.left.ker`. Route: per affine
  `U`, a section `s` with `s(x) = 0` pulls to `h^♯s` with `basicOpen (h^♯s) =
  h⁻¹(basicOpen s) = ∅` (`Scheme.preimage_basicOpen`, #check-verified; `basicOpen s`
  misses `x` = the whole range), hence `h^♯s = 0` on the REDUCED source by
  `eq_zero_of_basicOpen_eq_bot` (mathlib `Properties.lean:178`; `IsReduced D.left` from
  integrality). Ideal-sheaf plumbing: `Scheme.Hom.ker` (`IdealSheaf/Basic.lean:692`, with
  the affine-level `ker.ideal U = RingHom.ker (f.app U)` at `:703`), `Hom.support_ker`
  (`:843`), `le_support_iff_le_vanishingIdeal` (`:611`) as needed.
- To-build: ≤150 lines. **Hardest sub-step**: computing `ker (fromSpecResidueField x)` on
  an affine chart (the `Γ(U) → κ(x)` evaluation kernel) against the `IdealSheafData`
  API's `ofIdeals` presentation.
- Bail: the ratified class-level dodge (pulled cocycle trivializes on the pullback of a
  trivializing cover of a neighbourhood of `x`) — now a fallback-of-a-fallback.
- Consumer close: EV-const = probe EV-B, three rewrites (§1.2).

### EV-2 `generic-rank` — **[M-]; the R-W7-1 flag is REFUTED — the composite exists in mathlib**

- The ratified sheet: "the finrank ↔ localization ↔ function-field-degree dictionary
  crosses three theories; every ingredient exists, no composite does." **Probe EV-D′
  (green, zero diagnostics): the composite is ONE lemma** —
  `Algebra.IsAlgebraic.finrank_of_isFractionRing`
  (`RingTheory/Algebraic/Integral.lean:552`): for `R → S` with `[FaithfulSMul R S]
  [Algebra.IsAlgebraic R S] [NoZeroDivisors S]` and fraction-ring pairs
  `[IsFractionRing R R'] [IsFractionRing S S']` in a scalar tower,
  `finrank R' S' = finrank R S`. With `[Module.Finite R S]` the algebraicity is
  `Algebra.IsAlgebraic.of_finite`. Neither Dedekind, integral closures, projectivity, nor
  rank-constancy-on-Spec is needed. The companion `isBaseChange_of_isFractionRing`
  (`:528`) exists too.
- Statement pin (chart form, `n` from §1.1):
  `Module.finrank E.left.functionField D.left.functionField = Module.finrank B_E B_D`,
  under the algebra tower pinned once (below).
- The four remaining legs, all [S]:
  1. **`Module.Finite B_E B_D`**: `HasRingHomProperty.appLE`
     (`Morphisms/RingHomProperties.lean:290`) applied to `IsIntegralHom` (from
     `IsFinite`, `Finite.lean:106`) and `LocallyOfFiniteType`, glued by
     `RingHom.finite_iff_isIntegral_and_finiteType`
     (`IntegralClosure/IsIntegralClosure/Basic.lean:114`).
  2. **`FaithfulSMul B_E B_D`** (= injectivity of `h.appLE`): germ at `η` + naturality
     `functionFieldMap_germ` (`BaseFieldTransition.lean:217`) +
     `functionFieldMap_injective` (`:233`) + `germ_injective_of_isIntegral`.
  3. **`IsFractionRing` legs**: mathlib
     `functionField_isFractionRing_of_isAffineOpen` (`FunctionField.lean:141`) on both
     curves.
  4. **The tower** `IsScalarTower B_E K(E) K(D)` / `IsScalarTower B_E B_D K(D)`:
     `functionFieldMap_germ` IS the tower equation; `IsScalarTower.of_algebraMap_eq`.
- Flatness output for EV-3 comes free: injectivity into a domain ⇒
  `Module.IsTorsionFree B_E B_D` ([S], elementwise) ⇒ `Module.Flat` by the mathlib
  INSTANCE `[IsDedekindDomain R] [IsTorsionFree R M] : Flat R M`
  (`Flat/TorsionFree.lean:143`; the iff is `:138`).
- To-build: one file, ≤350 lines, dominated by instance/`letI` bookkeeping. **Hardest
  sub-step** (downgraded from "hardest leg of the campaign"): the instance-diamond
  hygiene — mathlib's canonical `Algebra Γ(U) K(X)` keying
  (`algebra_section_stalk`) vs the `h`-dependent `letI` structures (`appLE.toAlgebra`,
  `functionFieldMap.toAlgebra`). **Discipline: ALL four `letI` towers are owned by named
  defs in ONE file with `algebraMap_…_eq` unfolding lemmas** — the
  `Scheme.overSectionsAlgebra` model (`ChartColength.lean:75-85`), R-W7-4 idiom.
- Bail: if the diamond friction exceeds budget, re-key every statement on mathlib's own
  `algebra_section_stalk` instances and bridge once (ChartColength already performs this
  dance). Recorded fallback route (probed green as EV-D before EV-D′ was found):
  `IsIntegralClosure.of_isIntegrallyClosed` + `IsIntegralClosure.isLocalization`
  (`DedekindDomain/IntegralClosure.lean:62`) + `isLocalizedModule_iff_isLocalization` +
  `isLocalizedModule_iff_isBaseChange` + `IsBaseChange.finrank_eq`
  (`Dimension/Localization.lean:178`) — one sorry-free chain modulo the algebraicity
  instance, which `of_finite` closes.

### EV-3 `fiber-Σef` — **[M]; the gift's hypotheses fit the charts exactly (probe EV-C green)**

- **Gift verification (the task's explicit demand)**:
  `Ideal.sum_ramification_inertia_eq_finrank` (`RamificationInertia/Basic.lean:72`)
  requires `[IsDomain R] [Module.Finite R S] [Module.Flat R S] [Fintype (p.primesOver S)]`
  and yields `∑ q : p.primesOver S, ramificationIdx' · inertiaDeg' = finrank R S` — with
  the **primed** e/f (`Ramification.lean:51`, `Inertia.lean:43`). Probe EV-C
  machine-checked that at a generic Dedekind pair with exactly EV-2's outputs
  (`Module.Finite` + `IsTorsionFree`, `p` maximal) the instance search discharges
  `Flat` (TorsionFree instance) and `Fintype (p.primesOver S)`
  (`IsDedekindDomain.primesOver_finite` + Fintype instance,
  `DedekindDomain/Ideal/Lemmas.lean:1232,1243` — hypotheses `[p.IsMaximal] [IsDomain A]
  [IsTorsionFree A B] [Algebra.IsIntegral A B] [IsDedekindDomain B]`, all EV-2 outputs)
  and the gift fires verbatim. **The primed-to-classical bridges are mathlib**:
  `Ideal.ramificationIdx_eq_ramificationIdx'` (`Ramification.lean:125`; hypotheses
  `[IsDomain R] [IsDedekindDomain S] [IsTorsionFree R S]`, `p ≠ ⊥` — all available) and
  `Ideal.inertiaDeg_eq_inertiaDeg'` (`Inertia.lean:79`; `p,q` maximal ✓) with
  `Ideal.inertiaDeg_algebraMap` (#check-verified).
- Statement pin (the (†)-mirror, `DegreeBaseChange.lean:212` shape): for the tracked
  chart `V ∋ η_E` with `t : B_E` whose germ underlies `g : K(E)ˣ`, unit at every closed
  point of `V` except `y` where `ord_y(g) = 1`, and `S` a finite set of closed points of
  `h⁻¹V` outside which `h^♯t` is a unit:
  `∑_{z ∈ S} ord_z(h^♯g) · [κ(z) : K] = n · [κ(y) : K]`.
- Proof route (pinned): (i) on the tracked chart `span{t} = p_y` (counts: 1 at `p_y` by
  `toAdd_ordZ_eq_count_factors` — landed `ChartColength.lean:278` — and 0 elsewhere by
  the unit hypothesis; conclude by `factors_prod` + `associated_iff_eq` for ideals +
  `Multiset.ext`); (ii) hence `span{h^♯t} = p_y·B_D` (`Ideal.map_span`) and
  `ord_z(h^♯g) = count q_z (factors (p_y·B_D)) = p_y.ramificationIdx q_z` by the landed
  D-side dictionary + `Ideal.IsDedekindDomain.ramificationIdx_eq_normalizedFactors_count`
  (mathlib `NumberTheory/RamificationInertia/Ramification.lean:214`;
  `factors_eq_normalizedFactors` seam) + the primed bridge; (iii) `[κ(z):K] =
  inertiaDeg'·[κ(y):K]` via `inertiaDeg_algebraMap` + the landed residue legs
  (`finrank_quotient_primeIdealOf`, `ChartColength.lean:199`, fired on BOTH curves) +
  `Module.finrank_mul_finrank` on the tower `K → B_E/p_y → B_D/q_z`; (iv) reindex
  `S ↔ p_y.primesOver B_D` by the `Finset.sum_bij_ne_zero` skeleton of
  `finrank_quotient_span_section` (`ChartColength.lean:441-482`, the model) and close
  with probe EV-C.
- To-build: ≤400 lines. **Hardest sub-step of the whole campaign (residual)**: the
  reindexing bijection `S ↔ primesOver` with its unit-outside bookkeeping (step iv) —
  the ChartColength skeleton is the exact model, but it must be rebuilt across TWO rings.
  API debt noted: `not_isUnit_germ_iff_mem` and `toAdd_ordZ_eq_zero_of_isUnit_germ` are
  `private` in `ChartColength.lean` (`:330,:344`) — the EV-3 lane either de-privates them
  (2-line patch, report it) or restates locally.
- Bail (recorded alternative, no re-scope): replace (i)-(iv) by colength
  multiplicativity — `finrank K (B_D/tB_D) = n · finrank K (B_E/tB_E)` via per-prime
  localization (finite flat over the DVR `(B_E)_{p}` is free of rank `n`;
  `IsBaseChange.finrank_eq_of_le_nonZeroDivisors` for the rank; composition-factor
  counting for `finrank K` over a local ring) — heavier but independent of the
  ramification API. This is a route swap inside one brick, a prover decision to be
  reported, not an orchestrator event.

### EV-4 `assembly` — **[M]; a line-by-line mirror of the landed E-iv-alg file**

- Model: `DegreeBaseFieldInvariance.lean` in full. The mirror map: `π := (C ◁
  overSpecMap φ).left` ↦ `h.left`; everything else is already stated at the needed
  generality:
  - regularity discharge `pullbackEqn_germ_mem_nonZeroDivisors` (`:72`) is stated for an
    ARBITRARY morphism of integral schemes hitting the generic point — consumed verbatim
    with `genericPoint_eq_of_surjective h.left`;
  - the pulled tracked system (`pointTransitionEquations :108` shape) and its
    `elem_of_ne`/`elem_of_eq` lemmas (`:157,:198`) mirror with `functionFieldMapUnits`
    (`BaseFieldTransition.lean:240`, arbitrary morphisms);
  - `deg_presentationDivisor` (`:273`) mirrors with (†) replaced by EV-3's keystone and
    the extra factor `n`;
  - the ladder (`classDeg_cechPicMap_baseFieldTransition :462`): `Finsupp.induction` over
    `CurveDivisor.picClass` generators + `classDeg_zpow` (`DegreeBaseChange.lean:69`) +
    `picClass_pullback`/`picClass_single` — verbatim, target §1.1.
- To-build: ≤500 lines (the model file is 494). **Hardest sub-step**: none new — the
  support bookkeeping (`hout`) is the model's, with `germ_stalkMap_apply` unchanged.
- Bail: none. If `LocalEquations.pullback` fights the arbitrary-`h` instantiation
  (it should not — checked stated-generality at source), report; that would be the only
  event that re-opens this worksheet.
- **Scope note**: EV-cor (pic0-membership preservation, per-field-point dodge) is NOT in
  this campaign — per the ratified D3/§2.2 it belongs to F-6 (needs F-3 naturality), which
  consumes EV-main + EV-const + the dichotomy over each field point `K'` (base-changed
  inputs legal by `Curve/BaseChangeInstances.lean`).

---

## §3 Risk register — R-W7-1 resolved

- **R-W7-1 (the E-v balloon) — RETIRED as a campaign-scale risk, with evidence.** The
  ratified register said EV-2/EV-3 have "NO cheap fallback" and a wall there means
  orchestrator re-scope. Findings: (a) EV-2's feared wall is *refuted* — probe EV-D′
  compiles the entire generic-rank dictionary from two mathlib lemmas
  (`Algebra.IsAlgebraic.of_finite` + `finrank_of_isFractionRing`) with zero diagnostics;
  (b) EV-3's gift fires with instance-search-discharged hypotheses at exactly the chart
  pair EV-2 hands over (probe EV-C); (c) EV-1d's unprobed factorization exists in mathlib
  (probe EV-B); (d) EV-1a is checked (probe EV-E). The residual risk is **line-count in
  two named places**: EV-2's instance diamonds and EV-3's reindexing bijection — both
  with in-tree models (`overSectionsAlgebra`, `sum_bij_ne_zero`) and both with recorded
  same-brick fallback routes. **For completeness, the re-scope sentence R-W7-1 demanded:
  if — against the probe evidence — EV-3's Σef splice were to wall, the orchestrator's
  re-scope would be to descope `functor.map` from arbitrary morphisms to isomorphisms
  plus (via EV-1d, which stands independently) constant morphisms — K-1's datum-level
  mathematics, `baseChangeIso`, and the whole B-cluster survive unharmed (they consume
  `congr` only at isos, w7-worksheet D3 nuance 1), and only the frozen `functor`
  fields and F-6 stay open pending a new algebraic route.** No cross-fleet interaction:
  nothing here touches `JacobianData`, DAT-J, or any other fleet's files.
- **R-EV-1 (instance diamonds, R-W7-4 inheritance).** All `h`-dependent algebra `letI`s
  owned by named defs in the EV-2 file; consumers never inline `toAlgebra`. Mitigation
  pinned in EV-2; fallback = re-key on mathlib's `algebra_section_stalk`.
- **R-EV-2 (private-lemma debt).** Two `private` ChartColength lemmas are EV-3 inputs
  (§2 EV-3); de-private patch is a 2-line diff to a landed file — the lane must take the
  mutex-free path (restate locally) unless the orchestrator clears the touch.
- **R-EV-3 (statement drift vs F-6).** EV-main/EV-const/dichotomy are consumed only by
  F-6 (same wave). The §1 statements are pinned NOW so F-6's worksheet can cite them;
  any change goes back through the orchestrator.

---

## §4 Launch plan (post-ratification)

Two lanes, **no cross-gate between them**; both launchable the moment this worksheet is
ratified. Lane protocol: `w5-worksheet.md` §0 / `protocol-concurrent-lanes.md` (private
index + CAS, ≤500-line files, `lean_verify` on keystones, zero sorries, blueprint node
per brick).

- **Lane A — dichotomy** (`Curve/CurveMorphismDichotomy.lean`, per the ratified §3 file
  map): EV-1a (probe text) → EV-1d (independent of 1b/1c; statement takes
  `range = {x}` as hypothesis) → EV-1b → EV-1c. Single lane, one file; EV-1d before
  EV-1b because it is smaller and unblocks F-1's constant-leg compat early.
  Gate: none. Output consumers: F-6, F-1.
- **Lane B — multiplicativity** (`RiemannRoch/DegreePullbackDictionary.lean` for EV-2,
  then `RiemannRoch/DegreePullback.lean` for EV-3+EV-4; this two-file split is within
  the ratified §3 "splits if > 500L" clause): EV-2 → EV-3 → EV-4 strictly sequenced
  (EV-3 consumes EV-2's `Module.Finite`/`FaithfulSMul`/finrank-identification; EV-4
  consumes EV-3's keystone). Output consumer: F-6.
- **Gates**: EV-3 ⇐ EV-2 landed; EV-4 ⇐ EV-3 landed; F-6 ⇐ both lanes + F-3 + D1 (as
  already ratified in w7-worksheet D3). K-cluster: never gated on any of this.
- **Sizing**: Lane A ≈ one session (EV-1a/1d same-day, 1b/1c the bulk); Lane B ≈ two
  sessions (EV-2 one, EV-3+EV-4 one-plus). If only one prover is available, run Lane B
  first — it is the wave's long pole and Lane A's consumers (F-6 case split) also wait
  on F-3.
- **Acceptance per brick**: statement matches §1/§2 pins verbatim (or a reported
  deviation), `lean_verify` on the file keystone, blueprint node with `\source{}` — and
  the Hartshorne debt below.

**Source debt (unchanged from the ratified sheet)**: the classical statement
(`deg h^*Λ = deg h · deg Λ`, Hartshorne II.6.9/IV) is in-workspace but UNREAD; a
page-transcriber task must land before the blueprint nodes cite it.

---

## §5 Machine-checked probes (this session, `lean_run_code`, live tree + pinned mathlib)

- **#check batch (23 names, all resolve)**: ZMT `:371`, `IsProper.of_comp`,
  `locallyQuasiFinite_iff_finite_preimage_singleton`,
  `isClosed_singleton_iff_isClosedImmersion`, `IsClosedImmersion.lift`/`lift_fac`,
  `Hom.support_ker`, `le_support_iff_le_vanishingIdeal`, `eq_zero_of_basicOpen_eq_bot`,
  `preimage_basicOpen`, `sum_ramification_inertia_eq_finrank`,
  `ramificationIdx_eq_ramificationIdx'`, `inertiaDeg_eq_inertiaDeg'`,
  `inertiaDeg_algebraMap`, `IsDedekindDomain.primesOver_finite`, `Ideal.finite_factors`,
  `Ideal.dvd_iff_le`, `IsIntegralClosure.isLocalization`/`of_isIntegrallyClosed`,
  `IsBaseChange.finrank_eq`, `isLocalizedModule_iff_isLocalization`/`_isBaseChange`,
  `functionField_isFractionRing_of_isAffineOpen`. (One name corrected en route:
  the count bridge lives at `NumberTheory/RamificationInertia/Ramification.lean:214`.)
- **EV-A**: the §1.1 EV-main statement elaborates against the live tree (Over-form,
  letI-chain, `functionFieldMap`-algebra `finrank` spelling) — zero errors.
- **EV-B**: EV-const closes in three rewrites (`map_comp`, `eq_one_of_subsingleton`,
  `map_one`) — zero errors.
- **EV-C**: the Σef gift fires at a generic Dedekind pair from exactly
  `[Module.Finite] [IsTorsionFree] [p.IsMaximal]` — `Flat` and `Fintype (primesOver)`
  found by instance search.
- **EV-D / EV-D′**: the EV-2 dictionary — EV-D (integral-closure chain) compiles modulo
  one algebraicity hole; EV-D′ (the pinned route) compiles with ZERO diagnostics from
  `Algebra.IsAlgebraic.of_finite` + `finrank_of_isFractionRing`.
- **EV-E**: EV-1a (`IsProper h.left` + the lft/qc corollaries) — zero errors.

---

## §6 Ratification points

1. §1 statement pins (EV-main hypotheses-form with `[Surjective] [IsFinite]`; EV-const
   as CechPic-level triviality; the overlapping dichotomy disjunction).
2. §2 route pins: EV-2 via `finrank_of_isFractionRing` (integral-closure chain demoted
   to fallback); EV-3 via the (†)-mirror + Σef with the recorded colength-multiplicativity
   fallback; EV-4 as the E-iv-alg mirror; EV-1d via `IsClosedImmersion.lift` (class-level
   dodge demoted).
3. §3: R-W7-1 retirement wording + the de-private decision for the two ChartColength
   lemmas (restate locally vs 2-line patch).
4. §4: the two-lane launch, the `DegreePullbackDictionary.lean` file split, Lane-B-first
   if single-prover, and the EV-cor/F-6 scope boundary.
5. The Hartshorne page-transcriber task (pre-blueprint gate).

*End of draft. One-line summary: every feared leg of E-v either exists in mathlib
(EV-1d, EV-2, the EV-3 splice — all machine-probed green this session) or has a landed
in-tree model (EV-1b's chart dictionary, EV-4's E-iv-alg mirror); ratify the pins and
launch the two lanes.*
