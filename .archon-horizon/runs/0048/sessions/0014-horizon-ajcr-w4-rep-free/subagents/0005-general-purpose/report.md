Both worksheets read in full (568 and 549 lines). Report below; `datc:N` / `datb:N` are worksheet line numbers.

---

# 1. The intended geometric construction of the pic⁰ chart atlas

**The parameter scheme.** `DivScheme!` (datc:149, `Picard/DivScheme.lean:144`; `divSchemeι!` `:148`, `divSchemeOver!` `:156`) is the "Div^g-lite" divisor scheme: it is intended to represent `divFunctor C π g : (Over (Spec k))ᵒᵖ ⥤ Type u` (`Picard/DivisorFamilyZarFunctor.lean:45-47`, datc:152), the functor of relative families of effective degree-`g` divisors on the curve `C` (finite over `P¹`, genus `g`, via `π`). The representability datum is `divRep : (divFunctor C π g).RepresentableBy divSchemeOver!` (datc:155-158) — **not landed** (see §7).

**The chart scheme — one scheme for all charts.** `V` is the *h¹-fibrewise-vanishing open* of `DivScheme!`, cut against the **tautological family** rather than chart-by-chart (datc:170-187):

> `univFam : divFamZar C π g (divSchemeOver!) := divRep.homEquiv (𝟙 divSchemeOver!)`
> **(V-def)** `V := { x : DivScheme! | IsH1VanishingAt univFam x }`, `isOpen_V : IsOpen V`, `VOver := Over.mk ((V.ι …) ≫ divSchemeOver!.hom)`

So: `V ⊆ DivScheme!` is the locus of effective degree-`g` divisors `D` with `H¹(𝒪(D)) = 0`. By Riemann–Roch at `deg = g`, `χ = 1`, this is exactly where `h⁰(𝒪(D)) = 1`, i.e. where `D` is the **unique** effective representative of its class — that is the "canonical-section normalization" of §2 (datc:268-315). **Every chart is the same scheme `VOver.left`**; only the map differs.

**The Abel–Jacobi map.** `abelDiv : divFunctor C π g ⟶ picEtTypeFunctor C` (datc:456-468), affine-level `abelDivAff S : F₀ ↦ relPicToPicEt (relPicMk (F₀.picClass))` — the class of the divisor family in the "étale-plus" relative Picard functor `picEt`. Its degree ledger (datc:474-484) shows `degAt (abelDiv F) t = g` on every fibre, so `abelDiv` factors through the degree-`g` layer `picDegLayerFunctor C g` (`ThetaShift.lean:162-186`).

**The twist — this is where "twisting by g·P" is generalized.** The strings `g*P` / `g·P` do **not** occur in either worksheet. Because the base field need not have a degree-1 rational point, the classical `D ↦ 𝒪(D − g·P)` is replaced by a *two-parameter* twist indexed by the chart. Chart index (datc:338-342, datb:161-162):

> `c = (m, Σ)`, `m : ℕ`, `Σ : (C ⊗ overSpec k k).left.CurveDivisor`, `0 ≤ Σ`, `deg k Σ = m·d₁ − g`, where `d₁ := classDeg k (thetaCechClass C)` (`ThetaShift.lean:263`, `1 ≤ d₁` `:270`).

`θ = thetaCechClass C` is a fixed "theta" class of positive degree `d₁` (the pullback-of-𝒪(1)-along-π class). The chart value (datc:346):

> `chartValue c F := abelDiv F * sigmaFamily Σ T * (thetaFamily C (thetaCechClass C) T ^ m)⁻¹`

i.e. in additive terms `[D] + [Σ] − m·[θ]`. Degrees: `g + (m·d₁ − g) − m·d₁ = 0`, so it lands in `pic0Subgroup C T` (datc:353-354, 486-491). The chart map into the Σ-extended sheaf (datc:356-358):

> `f_c : yoneda.obj (VOver.left) ⟶ (pic0SigmaSheaf C).1`, at `T'`: `v ↦ ⟨v ≫ VOver.hom, chartValue c (F_v)⟩`.

**Mathematician's summary.** `V ⊆ Div^g` is the open where the effective degree-`g` divisor is the unique effective representative of its class (h⁰=1, h¹=0). The map `D ↦ 𝒪(D + Σ − mθ)` sends `V` into `Pic⁰`. It is injective on `V` because of h⁰=1 uniqueness; its image is the set of degree-0 classes `λ` such that `λ + mθ − Σ` is effective of degree `g` with vanishing h¹. Varying `(m, Σ)` moves this "affine cell" around `Pic⁰`; joint coverage is DAT-B's theorem. `Pic⁰` is then glued from these charts by mathlib's 01JJ (`pic0RepresentableByOfCharts`, `Picard/Pic0SigmaSheaf.lean:161-171`).

---

# 2. Relative representability / open immersion of each chart (DAT-C)

Target frozen by `pic0RepresentableByOfCharts` (datc:31-39): **`IsOpenImmersion.presheaf (f_c)` for every `c`** (mathlib `AlgebraicGeometry/Sites/Representability.lean:58`). It is split into four pieces:

- **§3.1 `V ×_Div T` (datc:321-334)** — "the BINDING consumption row". (hf-Div-a) pointwise law `u.left.base t ∈ V ↔ IsH1VanishingAt F_u t` via the `RepresentableBy` `homEquiv_comp` axiom; (hf-Div-b) the sub-presheaf `divFunctorH1 ⊆ divFunctor` of pointwise-h¹-vanishing families is representable by `VOver`, and the fibre product against any `u` is `u.left ⁻¹ᵁ V`. "Pure transcription given divRep; size M."
- **§3.2 mono-ness (datc:360-379)** — `chartValue c` is injective on `V`-points, hence `f_c` is a mono of presheaves. Route: group-cancel in `picEt`; (C1) unit injectivity `PicEtAff.unit_injective_of_ker`; then the **relPic base-twist hazard**: "`relPic` is the quotient by classes pulled back from the test … so the Čech classes differ by `p*N`, `N ∈ Pic(Spec S)` — NOT necessarily trivial on an affine test" (datc:369-371). Handled Zariski-locally via `gluedSheafCongr` transport + (N5) + `DivFamZar.eq_of_away_eq`. Flagged as risk 3 ("a Hilbert-90-class hazard", datc:133-134, 540-546).
- **§3.3 CHART-U (datc:381-415)**, the interface for `hf` at `pic0SigmaSheaf`:
  - **CHART-U(a)** — `chartLocus c λ := { t : T | the fibre class λ_t·θ^m·(−Σ) at κ(t) has an effective degree-g witness with h¹ = 0 }` (datc:391-392). DAT-C states everything against `chartLocus`; membership-vs-fibre-product is the mono + normalization.
  - **CHART-U(b)** — **openness of `chartLocus`. Honest new work, M→L, shared with DAT-B.** Chain: extraction → RE-5 → engine open → *étale-image openness descent*, of which "**(4) the étale-image openness descent — condition-on-the-cover ⟹ open image on `T` (étale maps are open; Kleiman tex 2204-2244 pattern) — has NO landed avatar (grep this pass)**" (datc:403-407). Keystone `isOpen_chartLocus`.
  - **CHART-U(c)** — the universal element: on `chartLocus`, the datum of `λθ^m(−Σ)` has invertible `H⁰`, a local basis cuts a `LocalEquations` family, **CERT-Σ certifies it**, and `divRep.homEquiv.symm` classifies it to `U ⟶ VOver` (datc:408-415).
- **Transition maps need no separate work**: "01JJ manufactures them from the certificates at `T := VOver`-tests (`LocalRepresentability.glueData`, mathlib `Representability.lean:66-80`)" (datc:417-420).

Openness discipline (binding, datc:255-259, 559-561): *every* open in this design is an instance of `datumRigidEngine_isOpen_vanishing` (`Cohomology/GluedSheafEngine.lean:221-231`, "Noetherian-free") — "no Fitting ideal, no semicontinuity, no rank-jump locus anywhere in this design."

---

# 3. Joint local surjectivity / coverage (DAT-B)

**DAT-B = exactly one instance** (datb:33-35): `Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)`. Target (datb:156-159):

```
instance pic0Charts_isLocallySurjective :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun c : ChartIndex C => f_c))
```

Reduces, via CHART-U(b)+(c), to the **pointwise coverage theorem** COV-1 (datb:178-181):

```
theorem pic0_chartLocus_cover
    (T : Over (Spec (.of k))) (lam : pic0Subgroup C T) (t : T.left) :
    ∃ c : ChartIndex C, t ∈ chartLocus c lam
```

**Key structural finding (datb:45-77): coverage proper is FIELD-LEVEL.** Membership of `t` in a chart locus is a statement about the fibre class at `κ(t)` alone, so RE-5/engine enter *only* through CHART-U(b), not the coverage proof. Consequences recorded: (1) the `DatumDescent` (1d-ii) seam is not on DAT-B's path; (2) "**the m-strata do NOT collapse**" — DAT-0a's bound `b_L` is per-field and never transports, so "the twist exponent `m` in the chart index must range … **no uniform `m₀` exists**" (datb:66-71); (3) DAT-B needs no relative high-twist certificate.

Proof chain of COV-1 (datb:190-230), stated at a **separably closed** instantiation `K_s`:
1. Fibre collapse: `picEtAffineEquiv` + étale field-cofinality → honest Čech class `μ₀` over a finite separable `L/κ(t)`.
2. `degAt λ t = 0`; fibre degree of `λ·θ^m` is `m·d₁`.
3. Choose `m` per fibre with `m·d₁ ≥ max b_L (g+1)`, `b_L` from DAT-0a at the fibre field.
4. Kill h¹ at the start (degree ≥ `b_L`).
5. **Greedy drop (B-1)** using **density of base-changed `K_s`-rational points (B-2)**: `e := m·d₁ − g` points `x₁,…,x_e` outside the base locus give `h⁰(μ − Σxᵢ) = 1`, `h¹ = 0`.
6. Package `Σ := Σᵢ single(xᵢ)`, effective of degree `m·d₁ − g` — a legal `ChartIndex` entry.

Injectivity (the other half of the node title) is asserted **already landed** — DAT-B builds no injectivity file, only a consumption table (datb:108-122, 395-412).

---

# 4. Index set: **INFINITE** (critical) — exact quotes

From DAT-B §0.3 (datb:83-90), the *staging DECISION*:

> **Decided:** the coverage theorem (hence the 01JJ assembly) is stated at a **separably closed instantiation** `K_s` of the standing pack (a separable closure of `k`; every Stage-B statement is generic in its base field, so this is an instantiation, not new machinery). The chart index is the full DAT-C index `c = (m, Σ)` with `Σ` an effective `CurveDivisor` on the `K_s`-curve — an **INFINITE** `Type u` index, which mathlib's 01JJ accepts as-is (`AlgebraicGeometry/Sites/Representability.lean:56-58` takes any `ι : Type u`).  Coverage at a FIXED finite separable level is **neither claimed nor needed**: the per-fibre drop argument requires rational points adapted to the fibre (the parent §2.5(d) genus-2/ℚ obstruction is exactly this), and no proof at finite level is known to this design.

The index type (datb:161-162):

> `ChartIndex C := (m : ℕ) × {Σ : (C ⊗ overSpec k k).left.CurveDivisor // 0 ≤ Σ ∧ CurveDivisor.deg k Σ = (m : ℤ) * d₁ - g}`

— a `Sigma` over all `m : ℕ`, itself infinite even before the `Σ`-component.

Finiteness is obtained only **after** gluing (datb:92-99):

> **The finite-level extraction is post-glue**: once `J_{K_s}` exists, its chart images are OPEN (each chart is an open subfunctor of the now-represented functor), they cover `J_{K_s}` (coverage), and `J_{K_s}` is quasi-compact by the DAT-J image argument (`|J| =` the image of the qc `DivScheme` under the Abel morphism — `compactSpace_divScheme` `Picard/DivSchemeQProj.lean:194` + the §3.3 effectivity export).  A finite chart subfamily follows topologically; its finitely many `Σ_i` … are defined over one finite separable `k'/k`, which is how `k'` is CHOSEN.

Descending from `K_s` to `k'` is flagged as **DAT-G0**, "a genuine brick **nobody's scoreboard carries**" (datb:99-106), owned by DAT-glue/DAT-G, not DAT-B. Also datb:505-512 ranks this risk 2, "high-impact coordination", correcting "the parent's surface reading ('01JJ over a finite separable k')".

Corroborating: DAT-C §0.2.2 also reads `m` as ranging; DAT-B §5.7 scope guard forbids "any `∀ n ≥ m` tail … the per-chart condition stays collapsed even though `m` ranges" (datb:539-540).

---

# 5. Quasi-compactness / affineness of the charts

**No quasi-compactness or affineness of the charts is claimed anywhere.** The only properties asserted of the chart scheme (datb:424-428):

> the lft certificate of the chart family is per-chart: `VOver.left` is an open of `DivScheme!` whose structure map inherits `locallyOfFiniteType_divSchemeOverHom` (`Picard/DivSchemeQProj.lean:199`; bundle `DivQProjBundle`/`divQProj` `:221/:245`) — consumed by DAT-glue directly, no DAT-B mediation.

So charts are: **open subschemes of `DivScheme!`, locally of finite type over `Spec k`.** Not affine, not asserted quasi-compact.

Quasi-compactness appears in exactly two other places, both about *other* objects: `DivScheme!` itself has "separatedness/qc/lft instances `:188-211`" (datc:65-66) and `compactSpace_divScheme` `DivSchemeQProj.lean:194`; and `|J|` is qc as the image of the qc `DivScheme` under the Abel morphism (datb:94-96, 439-456). "Affine" in DAT-C occurs only for *test schemes* / affine opens of the atlas (datc:154, 183, 203, 237, 243, 270, 361, 408), never for `V`/`VOver`.

---

# 6. Named Lean declarations claimed by the worksheets

### 6a. Asserted **DONE / LANDED** (verified by "DIRECT READ this pass" per datc:8-9, datb:13-15 — but these are exactly the claims to re-verify)

**Pic⁰ / sheaf / 01JJ seam** — `pic0RepresentableByOfCharts` `Picard/Pic0SigmaSheaf.lean:161-171` (datc:31, datb:21-31); `pic0SigmaFunctor_isSheaf` `:90`, `pic0SigmaSheaf` `:147` (datc:36, datb:111); `Over.sigmaExtension` `Picard/OverSigmaExtension.lean:118-125` (datc:36, datb:173); `existsUnique_glue_of_le_cover` `Picard/Pic0ZariskiSheaf.lean:246`, `pic0Subgroup_ext_of_le_cover` `:263`, `mem_pic0Subgroup_of_cover` `:277` (datc:40-41); `pic0Subgroup` `Picard/Pic0Functor.lean:107`, `mem_pic0Subgroup_iff` `:121`, `degAt` `:54` (datc:353-354, 394, 491).

**Field CRT / divisor-family dictionary** — `divFamDivisor` `Picard/DivisorFamilyField.lean:127` (effective `:165`) (datc:44, 222); `deg_divFamDivisor` `Picard/DivisorFamilyFieldCRT.lean:376-383`, adaptation form `:365`, pulled-seam `:397` (datc:45-47) — explicitly declared to supersede a stale "flagged open" warning; `divFamDivisor_injective` `Picard/DivisorFamilyFieldEquiv.lean:177`, `divFamFieldEquivOfDegOfSurj` `:199` (datc:46-47) — **but datb:367-371 says this last is CONDITIONAL, `hsurj` only half-done**; `deg_presentationDivisor` `FieldCRT:365`, CRT stalk-eval kit `FieldCRT:85-190` (datc:441); `deg_divFamDivisor_of_separated` `Picard/DivisorFamilyFieldDegree.lean:376-383` (datb:385); `exists_localEquations_presentationDivisor_eq` `Picard/DivisorFamilyBackward.lean:121` (datb:369); `PointPresentation` `Picard/PointPresentation.lean:255` (datb:383); `DivFam.toZar` `Picard/DivisorFamilyZar.lean:272`-region (datb:389).

**Extraction / descent / engine** — `exists_cechPicClass_eq` `Cohomology/GluedSheafExtraction.lean:301-314` (datc:49-51, claimed GLOBAL, "no Zariski-localization needed"); `BasicOpenCocycleDatum.exists_fg_isNoetherianRing_baseChange_eq` `Cohomology/DatumDescent.lean:514-520`, `descent_cechPicClass` `:525-532`, `descentRigidEngine` `:547-563` (datc:52-54); `datumRigidEngine` `Cohomology/GluedSheafEngine.lean:198-216`, `datumRigidEngine_isOpen_vanishing` `:221-231`, `datumH0BaseChangeEquiv` `:246-256` (datc:98, 248-251, 284); `rigidEngine_isOpen_vanishing` `Cohomology/RigidEngine4Assembly.lean:441-446` (datc:257); `subsingleton_datumPair_h1_iff` `Cohomology/GluedSheafFibre.lean:113`, `datum_subsingleton_h1_residueField_tensor_iff` `:123` (datc:124); `Cohomology/GluedSheafDatumFibre.lean:105` (δ-naturality), `:142` `subsingleton_sheaf_h1_of_picClass_eq`, `:169-190` `subsingleton_h1_residueField_tensor_of_witness` (datc:104, 125, 205); `gluedSheafCongr`/`gluedCongrEquiv` `Cohomology/GluedSheafCongr.lean:168/:110`, `subsingleton_hModule_gluedSheaf_congr` `:175` (datc:373-375); `Cohomology/GluedSheafDatum.lean:143-150` (datc:80); `Over.sectionsBaseChange` `Cohomology/SectionsBaseChange.lean` (datb:317).

**Separatedness / effectivity (C1)(C2)** — `PicEtAff.unit_injective_of_ker` `Picard/EtaleSeparatednessClose.lean:193` (datc:58); `PicEtAff.unit_injective` `Picard/EtaleSeparatedness.lean:16` (datb:116); `PicEtAff.unit_surjective_of_section` `Picard/EffectivityClose.lean:141`, `PicEtAff.unitEquiv_of_section` `:186` (datc:59-60); `PicEtAff.eq_of_away_eq` `Picard/PicEtAffZariskiSep.lean:137` (datb:114).

**Theta / degree ledger** — `cechPicClass_thetaIdealDatum` `Picard/DivSchemeFibreH1.lean:354-357` (datc:62); `thetaIdealDatum` `Picard/DivisorThetaDatum.lean:362`, `:264` (datc:78, 289); `fiberTwist_zero` `RiemannRoch/FiberTwist.lean:363`, `cechPicClass_thetaChartDatum` `Cohomology/RelCurveCollapse.lean:641` (datc:85-86); `thetaFamily` `Picard/ThetaShift.lean:104`/`:111`/`:136`, `thetaCechClass`/`classDeg` `:263`/`:270`, `degAt_thetaFamily_pow` `:149`, `picDegLayerFunctor` `:162-186`, `representableByOfShift` `:225` (datc:340-352, 486-492); `degAt_pow`/`degAt_pic0_mul_pow` `Picard/DegreeSeam.lean:135/:145`, `degAt_of_affineEquiv_eq_unit_*` `:67-107` (datc:490, datb:220); `cechPicClass_map_thetaChartDatum` `Picard/ThetaChartClassNaturality.lean` (datb:219); `relPicDeg_relPicAlgMap` `RiemannRoch/DegreeBaseFieldInvariance.lean` (datb:204).

**Abel / relPic / picEt** — `relPic` `Picard/RelPic.lean:63`, `relPicMk` `:70`, `relPicMk_eq_relPicMk_iff` `:80` (datc:369, 461); `relPicToPicEt` `Picard/PicEtUnit.lean:126`, `:161`, `:194`, `picEtUnit` `:231` (datc:461); `picEtMap_relPicToPicEt` (datc:463); `Picard/PicEt.lean:105`, `picEtAffineEquiv` `Picard/PicEt.lean:235` + naturality `Picard/PicEtMap.lean:354` (datc:464, datb:193); `PicEtAff.mk` `Picard/PicEtAff.lean:224` (datb:195); `abelPicEt` `Picard/AbelElement.lean:82-96`, `degAt_relPicToPicEt` `:69-75` (datc:471, 480); `relPicDeg_relPicMk` `RelPicDegree.lean:75`, `classDeg_picClass` `Degree.lean:157` (datc:481-482); `Over.universalSections` `Picard/UniversalSections.lean:123` (datc:378).

**Divisor-scheme / classify layer** — `DivScheme` `Picard/DivScheme.lean:144`, `divSchemeι!` `:148`, `divSchemeOver!` `:156` (datc:149); `DivQProjBundle` `:221`, `divQProj` `:245`, qc/lft/sep instances `:188-211`, `compactSpace_divScheme` `:194`, `locallyOfFiniteType_divSchemeOverHom` `:199` — all `Picard/DivSchemeQProj.lean` (datc:65, datb:426, 455); `JacobianData` `Picard/JacobianData.lean:87` (datc:67); `divFunctor` `Picard/DivisorFamilyZarFunctor.lean:45-47` (datc:152); `divFamZar` `Picard/DivisorFamilyZarVehicle.lean:187-190`, `divFamZarAffineEquiv` `:300`, `compat` `:198` (datc:153, 238); `DivFamZar.picClass`/`picClass_mapAlg` `Picard/DivisorFamilyZarMapAlg.lean:195-199`, `DivFamZar.eq_of_away_eq` `:240` (datc:216, 310); `Picard/DivisorFamilyZarMap.lean` map laws (datc:333); `divRepClassifyZar` `Picard/DivRepClassifyZar.lean:244-249`, `IsDivRepClassify` `:90-110`, uniqueness `:168-200`, `divClassifyZar` ∃! `:206` (datc:159-160, 415, datb:118); `DivFamZar.exists_certified_away_rep` `Picard/DivRepClassifyZarKit.lean` (datc:244); `IsCertified` `Picard/DivisorFamily.lean:426-441` (datc:433); `pairChartMap` is an `IsOpenImmersion` `Picard/DivCarvePairChart.lean:169` (datc:116); `carveIdealSheaf_ideal_pairChartOpen` (I-0238) (datc:118); `Picard/DivSchemeAtlasFactor.lean` "has only the defining triangle" (datc:117).

**G-4 in-flight** — `existsUnique_effective_divisor_divUniversalFibre` `DivSchemeSeedUnivAssembleKappa.lean:426`, `divUniversalFibreDivisor` `:449-461`, `PFibPack.lean:368` (datc:69-71).

**Sections / support-tube / colength** — `sectionLocalEquations_eqn` `Picard/SectionsToDivisorsClass.lean:129`, `sectionLocalEquationsOfFibrewiseRegular` `:201`, class law `:212`/`:159`, independence `:173` (datc:290, 301-304); `germ_component_mem_nonZeroDivisors` `Picard/SectionsToDivisors.lean:270`, `Scheme.germ_mem_nonZeroDivisors_of_ne_zero` `:114` (datc:296, 439); `flat/projective_colength_of_forall_tmul_residueField` `Picard/SupportTube.lean:313/:329`, `finite_colength_of_forall_fibre_closure_subset` `Picard/SupportTubeFinite.lean:282`, closed-trace `:263` (datc:113, 439-440); `Picard/SlicingFlatKernel.lean` keystones 3/4/5/7 (datc:443); `LocalEquations.rescale`/`picClass_rescale` `Picard/DivisorClass.lean` (datc:309); `Picard/LocalGenerators.lean` (datc:108); `Picard/DivisorFamilyMapAlg.lean` (datc:111).

**Riemann–Roch layer** — `picClass_eq_iff_exists_divOf` `Picard/PresentationExtraction.lean:112` (datc:93); `subsingleton_hModule_one_of_picClass_eq` `RiemannRoch/ClassCohomology.lean:111`, `h0_divisorSheaf_eq_of_picClass_eq` `:89` (datc:104, 126); `h0_eq_deg_add_chi_of_subsingleton_hModule_one` `RiemannRoch/FLVClass.lean:412` (datc:106, datb:188); `exists_effective_of_picClass` `FLVClass.lean:208` (datb:269); `exists_effective_of_h0_pos` `RiemannRoch/SectionBound.lean:175`, `h1_le_h1_sub_single`/`h1_add_single_le` `:67/:89` (datb:268, 284); `Scheme.baseDivisor` `RiemannRoch/BaseDivisor.lean:80`, `le_divisorSections_sub_baseDivisor` `:160`, `exists_coeffAt_eq_baseDivisorAt` `:143` (datb:273-275); `h0_normalization_sub_single_lt` `RiemannRoch/PFib.lean:71`, `h0_window_sub_single_lt` `RiemannRoch/CarveDegreePinch.lean:76` (datb:286-288, "imitate, do not consume"); `riemann_inequality` `RiemannRoch/ChiLedger.lean:137`, `chi_divisorSheaf` (datb:282, 451); `exists_bound_subsingleton_hModule_one_of_isFinite_toP1` `RiemannRoch/UniformVanishing.lean:71`, context `:60-66` (datb:58, 207, 146); `CurveDivisor.exists_picClass_eq` `Picard/DivisorClassMeromorphic.lean:118` (datb:214); `Over.exists_rationalPoint_mem` `Curve/SeparablyClosedPoints.lean:157`, scheme form `:135` (datb:309); `Algebra/EtaleCover.lean` field-cofinality (datb:196).

**Mathlib** — `IsOpenImmersion.presheaf` `Sites/Representability.lean:58`, `ι : Type u` at `:56-58`, `LocalRepresentability.glueData` `:66-80`, `representableBy` `:192`; `Presheaf.IsLocallySurjective`/`imageSieve_mem` `Sites/LocallySurjective.lean:94`, `imageSieve` `:38-52`; `homEquiv_comp` `CategoryTheory/Yoneda.lean:284-288`.

### 6b. Asserted **NOT LANDED / TODO** (the six GAPs + the new bricks)

| name | worksheet | status |
|---|---|---|
| `BasicOpenCocycleDatum.inv`, `cechPicClass_inv`, `d.divisorDatum`, `canon` (GAP-1, file C0) | datc:76-87, 510 | TODO, launchable now |
| Σ-UNIQ-fld (GAP-2, unnamed; file C3 `RiemannRoch/EffectiveUniqueness.lean`) | datc:88-96, 513 | TODO, launchable now |
| Σ-RANK1 `Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p = 1` (GAP-3, C2) | datc:97-108, 512 | TODO |
| `isCertified_sectionAdaptation … : A.IsCertified g` (CERT-Σ, GAP-4, C8) | datc:109-114, 430, 518 | TODO — "THE heart", (c3)/(c4) pattern-gated on G-4 CertUniv |
| `IsOpenImmersion (divCarveChartToDivScheme i j)` (GAP-5) | datc:115-121 | TODO, "is not landed" |
| Σ-H1LOC iff dictionary (GAP-6) | datc:122-127 | TODO — "all halves landed … nobody has stated the iff" |
| `DivFamZar.IsH1VanishingAt`, (V1a)/(V1b)/(V1c), `isOpen_setOf_isH1VanishingAt` | datc:209-239, 261 | TODO |
| `univFam`, `V`, `isOpen_V`, `VOver`, `mem_V_iff` | datc:180-187, 261-264 | TODO — gated on divRep(F7) |
| (N1)–(N6) normalization lemmas | datc:280-315 | TODO |
| `divFunctorH1`, hf-Div-a, hf-Div-b | datc:325-334 | TODO — gated on divRep |
| `chartValue`, `sigmaFamily`, `f_c` | datc:346-358, 515 | TODO, launchable now (C5) |
| `chartLocus` (CHART-U(a)), `isOpen_chartLocus` (CHART-U(b)), CHART-U(c) | datc:389-415, datb:359 | TODO — (b) "has NO landed avatar" |
| `abelDivAff`, `abelDiv` | datc:456-468 | TODO, launchable now |
| `pic0Charts_isLocallySurjective` | datb:156-159, 486 | TODO — only divRep-gated DAT-B row |
| `ChartIndex C` | datb:161-162 | TODO |
| `pic0_chartLocus_cover` (COV-1/B-5) | datb:178-181, 485 | TODO |
| `exists_effective_sub_h0_eq_one` (B-1) | datb:250-261, 481 | TODO, "NOW" |
| `dense_baseChange_rationalPoints` (B-2) | datb:298-304, 482 | TODO, "NOW" |
| `exists_divFam_divFamDivisor_eq` + unconditional `divFamFieldEquiv` (B-3) | datb:376-379, 388, 483 | TODO, "NOW" |
| `pic0_field_point_effective` (qc/effectivity export) | datb:442-446 | TODO |
| DAT-G0 (finite-level transfer of the representing datum) | datb:99-106, 458-466 | Flagged debt, unowned |

### 6c. Asserted **BLOCKED**

- **`divRep : (divFunctor C π g).RepresentableBy (divSchemeOver!)`** together with `divRep_homEquiv_apply` and `divRep_homEquiv_symm_apply` — "**F6/F7 NOT landed**" (datc:155-158); risk 5 "divRep slippage (externalized). F5–F7 pending (F4 landed, I-0243)" (datc:553-554). Gates DAT-C rows C6, C7, C9 and DAT-B row B-6.
- **`divRepPullAt`** — "this is F5's `divRepPullAt` computation lemma consumed through DDR9-U, a POST-G-4 corollary, not an input" (datc:197-199).
- CERT-Σ's (c3)/(c4) heart — "**binding coordination: wait for CertUniv's discharge pattern and share it; do not invent a second mechanism**" (datc:443); C8 "statement YES; heart pattern-gated" (datc:518).
- CHART-U(b) — blocked pending co-sign between the two lanes (datc:406-407, datb:325-329, 484).

---

# 7. Certificates, U1/U2, ThetaGeneratorSeed, certifiedFamily

**`ThetaGeneratorSeed` — does NOT occur** in either worksheet (grep-verified). **`certifiedFamily` — does NOT occur**; the closest is the structure `CertifiedDivisorFamily C S π g` (datc:270). **`g*P` / `g·P` — does NOT occur.**

**`U1` / `U2` — exactly two occurrences, both in DAT-C, both referring to the frozen DDR9-U interface:**

> datc:71-72: "**G-4 is mid-flight beyond the task brief** … DAT-C still consumes G-4 ONLY through DDR9-U (U1/U2, w4-ddr9 §3.1 — frozen)."
> datc:263-264: "and the atlas traces `V ∩ range (divCarveChartToDivScheme i j)` = the engine-open of the universal family's datum (post-G-4 computation; **stated against DDR9-U's U1 only**)."

Also datc:516: row C6 "chart traces vs DDR9-U", and datc:554: "The §1.1 tautological spelling + DDR9-U keep the blast radius to C6/C7."

**"Certificate" — every distinct sense, quoted:**

- *01JJ / `hf` certificate* (the open-immersion data): title datc:1 "the chart functors and their 01JJ certificates"; datc:319 "§3 The chart functors and the 01JJ `hf` certificates"; datc:381 "The `hf` certificate at `pic0SigmaSheaf`"; datc:418 "01JJ manufactures them from the certificates at `T := VOver`-tests".
- *The `V ×_Div T` certificate*: datc:25-26 "Everything else — the V-open, the normalization, the mono, the `V ×_Div T` certificate, the Abel layer — is bounded assembly of landed keystones"; datc:329 "**(hf-Div-b) the subfunctor certificate**".
- *Big-site sheaf certificate*: datc:36 "The big-site sheaf certificate is landed"; datb:111 "the big-site sheaf certificate `pic0SigmaFunctor_isSheaf`".
- *lft certificate*: datb:424-427 "the lft certificate of the chart family is per-chart"; datc:556 "the 01JJ invocation itself and lft certificates (DAT-glue…)".
- *CERT-Σ, the divisor-family certificate*: datc:109-114 "**GAP-4 (CERT-Σ, L — THE heart).** §3.4. No certificate producer for canonical-section families exists (the landed producers are the pullback transport `Picard/DivisorFamilyMapAlg.lean` and the in-flight G-4 CertUniv for the universal family)"; datc:422 "CERT-Σ — the certificate for canonical-section families (GAP-4, THE heart)"; statement pin datc:430 `theorem isCertified_sectionAdaptation … : A.IsCertified g` with `IsCertified` fields at `Picard/DivisorFamily.lean:426-441`.

**Dependence of divisor-representability on a certificate — the explicit chain:**

- datc:203: "For an affine test `S` and a **locally certified class** `F₀ : DivFamZar C S π g`, define membership at `p`…"
- datc:224: "**(V1b) the datum bridge**: for a **certified representative** `G` over `S` with divisor datum `D_G := (G.adaptation.thetaIdealDatum 0).inv` (GAP-1)…"
- datc:243-246: "Per affine open `U ⊆ DivScheme!` with value `F_U`, **per certificate piece**: step 1 of the landed backward assembly (`DivFamZar.exists_certified_away_rep`, `Picard/DivRepClassifyZarKit.lean`, I-0243) gives **certified representatives** `G_l` over `Away (h l)` covering `U`".
- datc:408-415 (CHART-U(c), the load-bearing dependency): "a local basis cuts a `LocalEquations` family (N4) with class `λθ^m(−Σ)` (DAT-A class law); **CERT-Σ** (§3.4) certifies it; `divRep.homEquiv.symm` (= the landed `divRepClassifyZar` through F6/F7) classifies it to `U ⟶ VOver`".
- datc:445-447: "Consumers: CHART-U(c) here; DAT-B's coverage (its 'local divisor presentation of an arbitrary functor point' needs the identical brick at high twist — dat-worksheet §2.2.3a); **freeze this statement with DAT-B before building**."
- **DAT-B disagrees / narrows this** (datb:72-77): "**DAT-B needs NO relative high-twist certificate.** w4-datc §3.4 expects DAT-B to need CERT-Σ 'at high twist' … In the design below the high-twist divisor presentation is needed only at FIELD fibres … **The only relative certificate DAT-B consumes is DAT-C's own CERT-Σ at degree `g`, through CHART-U(c), untouched.**"
- datb:373 (field-level residue of the dictionary): "the docstring (`:113-119`) names the residue: **the certified support-separated adaptation**"; datb:384-386: "whose certificate is the SEPARATED case landed as `deg_divFamDivisor_of_separated`".

---

**Two internal inconsistencies worth flagging to the caller.** (i) DAT-C datc:46-47 lists `divFamFieldEquivOfDegOfSurj` (`DivisorFamilyFieldEquiv.lean:199`) among "DONE and stronger than DD-1's 'open' row", while DAT-B datb:367-371 says the same declaration is **conditional** with `hsurj` only half-discharged — B-3 exists precisely to close it. (ii) DAT-C's §3.4 consumer note assumes DAT-B needs CERT-Σ at high twist; DAT-B §0.2.3 explicitly rejects that. Both are unresolved cross-lane claims, not settled facts.
