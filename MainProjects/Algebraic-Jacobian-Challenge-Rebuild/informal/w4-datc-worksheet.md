# W4-DAT-C WORKSHEET — the Σ-charts: the h¹-vanishing open of Div^g-lite, the canonical-section normalization, the chart functors and their 01JJ certificates

*2026-07-19, Fable design lane (`AJCR.w4-rep.datum.dat-c`, worksheet-first).  BINDING
parents: `informal/dat-d-worksheet.md` §4.2 (the three DAT-C consumption rows) +
Addendum, `informal/w4-datum-worksheet.md` §2.2 items 3–4, §2.3, §4 DAT-C row, §5
risks 5/6, `informal/w4-ddr9-worksheet.md` §1.1 + §5 (the frozen `divRep` pin) + §3.1
(DDR9-U, frozen).  Inbox absorbed: I-0236…I-0244 (all gotcha lists REQUIRED READING
for implementation lanes), I-0230/I-0232/I-0235 (inherited hazards).  Every `file:line`
below was verified by DIRECT READ this pass — including the layer that landed TODAY
(divClassify I-0237, KeyChart I-0238, ε-carve I-0239, SlicingFlatKernel I-0240,
SeedUniv I-0241, AtlasFactor I-0242, DivRepClassifyZar I-0243, SupportTubeFinite
I-0244) and the layers no worksheet reflects yet (see §0.2).  No Lean edited, no lake
run.  This worksheet pins DAT-C so implementation lanes launch cold the moment
`divRep` (F5–F7) lands.*

## §0 Verdicts up front

### §0.1 The one-line verdict

DAT-C is **three quarters transcription against a tree that is much further along
than the roadmap node suggests**, plus **two honest new-mathematics bricks**: the
certificate production for canonical-section families (**CERT-Σ**, §3.4 — THE heart,
shared with DAT-B) and the chart-membership openness at arbitrary étale-plus classes
(**CHART-U(b)**, §3.3 — shared with DAT-B, engine + RE-5 + étale-image descent).
Everything else — the V-open, the normalization, the mono, the `V ×_Div T`
certificate, the Abel layer — is bounded assembly of landed keystones, and **six of
the nine file-plan rows are launchable before `divRep` lands** (§5).

### §0.2 Landed layers NO worksheet reflects (found this pass; supersede stale rows)

1. **DAT-6 is DONE including the 01JJ seam.** `pic0RepresentableByOfCharts`
   (`Picard/Pic0SigmaSheaf.lean:161-171`) already consumes exactly what DAT-C must
   produce: a family `f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1` with
   `hf : ∀ i, IsOpenImmersion.presheaf (f i)` and joint local surjectivity (DAT-B),
   and returns `(pic0TypeFunctor C).RepresentableBy (Over.mk …)`.  The big-site sheaf
   certificate is landed (`pic0SigmaFunctor_isSheaf` `:90`, `pic0SigmaSheaf` `:147`;
   Σ-extension `Picard/OverSigmaExtension.lean:125`).  **DAT-C's §3 target shape is
   therefore frozen by mathlib + this file: `IsOpenImmersion.presheaf (f_c)`**
   (mathlib `AlgebraicGeometry/Sites/Representability.lean:58`).
2. **DAT-2 is DONE** (`Picard/Pic0ZariskiSheaf.lean`: `existsUnique_glue_of_le_cover`
   `:246`, `pic0Subgroup_ext_of_le_cover` `:263`, `mem_pic0Subgroup_of_cover` `:277`).
3. **The DD-1c field dictionary is DONE and stronger than DD-1's "open" row**:
   `divFamDivisor` (`Picard/DivisorFamilyField.lean:127`), the colength↔degree law
   **unconditionally** — `deg_divFamDivisor : deg K (divFamDivisor F) = n`
   (`Picard/DivisorFamilyFieldCRT.lean:376-383`; adaptation form `:365`, pulled-seam
   form `:397`), `divFamDivisor_injective` (`Picard/DivisorFamilyFieldEquiv.lean:177`),
   `divFamFieldEquivOfDegOfSurj` (`:199`).  The w4-g4 §3 warning "field CRT
   colength↔degree flagged open — avoid it" is STALE: it landed.
4. **Extraction (DAT-1 (1f)) is DONE and GLOBAL**: `exists_cechPicClass_eq` —
   *every* Čech Picard class on `C_B` is the class of a `BasicOpenCocycleDatum`
   (`Cohomology/GluedSheafExtraction.lean:301-314`; no Zariski-localization needed).
5. **RE-5 is DONE**: `BasicOpenCocycleDatum.exists_fg_isNoetherianRing_baseChange_eq`
   (`Cohomology/DatumDescent.lean:514-520`), class correspondence
   `descent_cechPicClass` (`:525-532`), engine-over-the-stage `descentRigidEngine`
   (`:547-563`).  This is the standing answer to every `[IsNoetherianRing]`
   hypothesis in §2's chain at arbitrary tests.
6. **(C1)+(C2) are CLOSED at the level DAT-C needs**: unit injectivity
   `PicEtAff.unit_injective_of_ker` (`Picard/EtaleSeparatednessClose.lean:193`),
   effectivity headline `PicEtAff.unit_surjective_of_section`
   (`Picard/EffectivityClose.lean:141`) and the field-with-section iso
   `PicEtAff.unitEquiv_of_section` (`:186`).
7. **G-0a is LANDED**: `cechPicClass_thetaIdealDatum : (A.thetaIdealDatum a).cechPicClass
   = (thetaChartDatum C R π a).cechPicClass * d.picClass⁻¹`
   (`Picard/DivSchemeFibreH1.lean:354-357`) — the class law §1–§2 lean on.
8. **DD-Q is LANDED** (`Picard/DivSchemeQProj.lean`: `DivQProjBundle` `:221`,
   `divQProj` `:245`, separatedness/qc/lft instances `:188-211`) and **`JacobianData`
   is LANDED** (`Picard/JacobianData.lean:87`).  DAT-C's outputs feed a receptacle
   that already exists end-to-end.
9. **G-4 is mid-flight beyond the task brief**: `DivSchemeSeedUnivAssembleKappa.lean`
   already has the fibre P-fib firing (`existsUnique_effective_divisor_divUniversalFibre`
   `:426`, `divUniversalFibreDivisor` `:449-461`); `PFibPack.lean:368` landed.  DAT-C
   still consumes G-4 ONLY through DDR9-U (U1/U2, w4-ddr9 §3.1 — frozen).

### §0.3 Gaps found in the landed tree (pinned as named bricks; the w4-ddr9 §0.2 pattern)

* **GAP-1 (Σ-INV) — HALF LANDED 2026-07-28 (run 0072), and the two halves are of very
  different size.  Do not read "half done" as "nearly done".**
  * **The inverse half is LANDED**, `Picard/Pic0ChartShiftedDatum.lean`, sorry-free:
    `BasicOpenCocycleDatum.invDatum` (same cover data — same pieces, same partitions, same
    index; units inverted, so `pieces_invDatum` is `rfl` and every piece-level fact of `D`
    transports verbatim), `invDatum_invDatum` (the involution), and the cocycle law
    `Scheme.IsGluingCocycle.inv` — stated for an arbitrary unit family so the θ/Σ layer can
    reuse it without building a datum.  The only real content is that the triple-overlap
    section ring is **commutative**: `(ab)⁻¹ = a⁻¹b⁻¹` fails non-commutatively without a
    transposed index pair.
  * **The mul/tensor half is NOT landed — and it NEVER GATED CHART-U(b).  Retracted
    2026-07-28 (run 0072, later the same day), commit `a5da2f1a1`,
    `Picard/Pic0ChartTwistCollapse.lean`, sorry-free.**  The sentence this bullet used to
    carry ("this is the live gate of CHART-U(b)") was false for two independent reasons:
    * **the twist is not a product of families.**  `sigmaFamily C Z T` is *by definition*
      `thetaFamily C (picClass k Z) T` (`Picard/DivSchemeAbel.lean:326`; `degAt_sigmaFamily`
      already proved it by `change`), and `thetaFamily` applies **four group homomorphisms**
      to its class argument over the `CommGroup` `Scheme.CechPic`.  So it is multiplicative
      *in the class* (`thetaFamily_mul`/`_inv`/`_pow`, each `map_mul`/`map_inv`/`map_pow`
      four times), and `chartTwist_collapse` gives
      `chartTwist C m Z T λ = λ · thetaFamily C (picClass k Z · (θᵐ)⁻¹) T`.  Σ and `θᵐ` are
      ONE construction at two classes; the multiplication happens in `CechPic` over the
      **fixed** base `overSpec k k`, before any datum is extracted.  There is no datum
      product in the route to build;
    * **even for a genuine product, presentation is surjective.**
      `BasicOpenCocycleDatum.exists_cechPicClass_eq`
      (`Cohomology/GluedSheafExtraction.lean:301`) produces a datum for *every* Čech class
      over an affine base, so a datum for `c·c'⁻¹` exists outright
      (`exists_datum_cechPicClass_mul_inv`).  Extract AT the product class; do not multiply
      data.

    A genuine `BasicOpenCocycleDatum.mul` — build the product datum *from the factors'* data
    on a computable common refinement — is a strictly stronger statement, is still absent,
    and is still a reasonable thing to want.  It is simply not on the CHART-U(b) path.

    **How this error survived, because the mechanism will recur:** the gate was inferred from
    an ABSENT NAME (grep found no `BasicOpenCocycleDatum.mul`) rather than from the
    obligation.  An absent constructor blocks you only if what you need is the *construction*.
    Before pricing a gate on a missing name, check whether an existential already in the tree
    covers the obligation.  This is the §7-of-`w4-rep-critical-path` failure mode in its
    mirror form: not a stale MISSING claim, but a stale *inference* from one.
  * **`cechPicClass_inv` is NOT landed either.**  Stating it needs the subordinated-cocycle
    `inv_unitsEvInf`-style calculus that `Picard/DivSchemeFibreH1.lean:63-66` keeps
    *private*; publishing that is its own brick.  The paragraph below describes the route
    for it, not a landed lemma.

  Original statement (route for the remaining halves).  No datum in the class `[𝒪(d)]` exists —
  every landed datum built from a divisor family is the *twisted ideal*
  `thetaIdealDatum a` of class `θᵃ·[d]⁻¹` (`Picard/DivisorThetaDatum.lean:362`,
  class law §0.2.7).  Pin `BasicOpenCocycleDatum.inv` (same pieces, units
  `(D.unit i j)⁻¹`; the cocycle law inverts termwise — the units are honest `Units`,
  `Cohomology/GluedSheafDatum.lean:143-150`), with `cechPicClass_inv = (cechPicClass)⁻¹`
  (subordinated-cocycle level: the `inv_unitsEvInf`-style calculus already used
  privately at `DivSchemeFibreH1.lean:63-66`).  Then the **divisor datum**
  `d.divisorDatum := (A.thetaIdealDatum 0).inv` has class `d.picClass` by G-0a at
  `a = 0` + `fiberTwist_zero` (`RiemannRoch/FiberTwist.lean:363`) +
  `cechPicClass_thetaChartDatum` (`Cohomology/RelCurveCollapse.lean:641`, whose RHS at
  `a = 0` is the pullback of `1`).
* **GAP-2 (Σ-UNIQ-fld) — LANDED.  This row was STALE; corrected 2026-07-28 (run 0072).**
  `RiemannRoch/EffectiveUniqueness.lean` implements the pinned statement *verbatim*,
  sorry-free, and its module header cites this very GAP-2 row as its specification.  The
  keystone is
  `Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one` (`:144`) — `0 ≤ D`, `0 ≤ D'`, equal
  Čech classes, `h⁰(𝒪(D)) = 1` ⟹ `D' = D` — with the section-space form
  `eq_of_picClass_eq_of_finrank_one` (`:110`) and its three supports
  (`ord_functionFieldOverAlgebraMap_eq_one` `:55`,
  `divOf_eq_zero_of_val_eq_functionFieldOverAlgebraMap` `:81`,
  `one_mem_divisorSections_top` `:97`).  The route taken is the one this row prescribes,
  step for step.
  **Consequence for the chart lane:** the *field-level* uniqueness input of CHART-U(c) is
  available now; what CHART-U(c) still needs is the relative/family-level statement on
  `chartLocus` plus the classifier, not this brick.
  *(This is the §7-of-w4-rep-critical-path failure mode inside w4-datc's own gap list: the
  "no such lemma exists (grep this pass)" claim outlived the commit that landed it.  Check
  the ledger before trusting a MISSING claim here.)*

  Original pin, kept for the record: over a standing-pack
  field `K` with `hO`, for `D D' : CurveDivisor`, `0 ≤ D`, `0 ≤ D'`,
  `picClass K D = picClass K D'`, `h0 (𝒪(D)) = 1` ⟹ `D' = D`.  Route:
  `picClass_eq_iff_exists_divOf` (`Picard/PresentationExtraction.lean:112`, in its
  divisor avatar through `DivisorClassMeromorphic`) gives `f` with
  `divOf f = D' − D`; `f ∈ H⁰(𝒪(D))` since `divOf f + D = D' ≥ 0`; `1 ∈ H⁰(𝒪(D))`
  since `0 ≤ D`; `h⁰ = 1` forces `f = c·1`, so `D' − D = divOf c = 0`.
* **GAP-3 (Σ-RANK1, M, launchable now).**  No rank export for the datum engine's
  `H⁰` exists: `datumRigidEngine` (`Cohomology/GluedSheafEngine.lean:198`) gives
  finite + projective, never `rankAtStalk = 1`.  Pin: on the h¹-vanishing locus at
  fibre degree `g` (χ-normalized: `hχ` gives fibre `χ = 1`), `Module.rankAtStalk
  (Sheaf.HModule D.sheaf 0) p = 1` — via `datumH0BaseChangeEquiv` at
  `κ(p)` (`GluedSheafEngine.lean:246`), the fibre-datum `h⁰` reading through the
  witness divisor (`subsingleton_sheaf_h1_of_picClass_eq` pattern,
  `Cohomology/GluedSheafDatumFibre.lean:142`; `h0_divisorSheaf_eq_of_picClass_eq`,
  `RiemannRoch/ClassCohomology.lean:89`) and
  `h0_eq_deg_add_chi_of_subsingleton_hModule_one` at `deg = g`.  Companion S-lemma:
  a fibrewise-nonzero element of an invertible module is a Zariski-local basis
  (Nakayama; `Picard/LocalGenerators.lean` is the adjacent kit).
* **GAP-4 (CERT-Σ, L — THE heart).**  §3.4.  No certificate producer for
  canonical-section families exists (the landed producers are the pullback transport
  `Picard/DivisorFamilyMapAlg.lean` and the in-flight G-4 CertUniv for the universal
  family).  All four abstract engines it needs LANDED THIS WEEK: SlicingFlatKernel
  (I-0240), SupportTubeFinite (I-0244), `projective_colength_of_forall_tmul_residueField`
  (`Picard/SupportTube.lean:329`), the field degree laws (§0.2.3).
* **GAP-5 (Σ-OPENIMM, S).**  `IsOpenImmersion (divCarveChartToDivScheme i j)` is not
  landed (`pairChartMap` IS one, `Picard/DivCarvePairChart.lean:169`; the factor map
  `Picard/DivSchemeAtlasFactor.lean`, I-0242, has only the defining triangle).  Route:
  KeyChart (`carveIdealSheaf_ideal_pairChartOpen`, I-0238) says `Spec R_Z` is exactly
  the chart-open trace of the carve locus, i.e. the square
  (`Spec R_Z → Spec (PairChartRing)`, `divCarveChartToDivScheme`, `divSchemeι`,
  `pairChartMap`) is a pullback; open immersions are stable under base change.
* **GAP-6 (Σ-H1LOC dictionary, M).**  §1.2's membership predicate needs the fibre
  iff-dictionary assembled once (all halves landed: `subsingleton_datumPair_h1_iff`
  `Cohomology/GluedSheafFibre.lean:113`, `datum_subsingleton_h1_residueField_tensor_iff`
  `:123`, the δ-naturality base-change seam `GluedSheafDatumFibre.lean:105`, witness
  form `:169-190`, class invariance `ClassCohomology.lean:111`).  Transcription-grade
  but nobody has stated the iff.

### §0.4 Honest risks, ranked (details §5)

1. **CERT-Σ** (new mathematics at the (c1)-leak/(c3)/(c4) clauses for
   canonical-section families; I-0244's counterexample shows the leak clause is NOT
   free).  2. **CHART-U(b)** — chart-membership openness at arbitrary plus classes
   (étale-image descent has no landed avatar).  3. **Class-transport plumbing in the
   mono** (relPic's base-twist coset, §2.4 — a Hilbert-90-class hazard, handled
   Zariski-locally).  4. **Elaboration weight** of the datum-engine + Over + covers
   combination (the standing 58 GB profile; mitigations as always).  5. **divRep
   slippage** (externalized: F5–F7 pending; the §1.1 tautological-family spelling is
   the insulation).

### §0.5 Standing context (shared by every § below)

The DivRepClassifyZar context pack, consumed verbatim
(`Picard/DivRepClassifyZar.lean:56-81`): `{k} [Field k]`, `C : Over (Spec (.of k))`,
`π : C.left ⟶ P1 k` `[IsFinite π]`, the curve/instance block `:62-70`,
`hπ : π ≫ P1.structureMap k = C.left ↘ Spec (.of k)`, `g`, `hO`, `hχ`, `r₁ r₂`,
`b₁ b₂` at the ledger windows `:75-80`.  Abbreviations: `s/M := windowS/M_choice`,
`F̄ := fiberWeilDivisor π`,
`DivScheme! := DivScheme k (s•F̄) (M•F̄) g r₁ r₂ b₁ (b₂.map (windowShiftEquiv hπ g).symm)`
(`Picard/DivScheme.lean:144`), `divSchemeι!` (`:148`), `divSchemeOver!` (`:156`),
`R_Z i j := DivCarveChartRing k (s•F̄) (M•F̄) g r₁ r₂ b₁ b₂' i j`.  The functor is
`divFunctor C π g : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u`
(`Picard/DivisorFamilyZarFunctor.lean:45-47`), value `divFamZar C π g T` (vehicle
`Picard/DivisorFamilyZarVehicle.lean:187-190`, affine collapse `divFamZarAffineEquiv`
`:300`).  The frozen divRep pin (w4-ddr9 §1.1, §5 — F6/F7 NOT landed):
`divRep : (divFunctor C π g).RepresentableBy (divSchemeOver!)` with computation
lemmas `divRep_homEquiv_apply` (affine tests through `divFamZarAffineEquiv`) and
`divRep_homEquiv_symm_apply` (through `divRepAff.symm` = the landed
`divRepClassifyZar`, `Picard/DivRepClassifyZar.lean:244-249`, characterized by
`IsDivRepClassify` `:90-110`).  Instance seam (recorded once): the engine files run at
`hπ : π ≫ P1.structureMap k = C.hom` (`Cohomology/GluedSheafEngine.lean:183`); the
classify tree at `C.left ↘ Spec (.of k)` — defeq through the local instance
`⟨C.hom⟩` (`DivRepClassifyZar.lean:59-60`); no transport lemma, but every DAT-C file
must install the same local instance.

---

## §1 The chart scheme `V` (consumption row 1)

### §1.1 The definition — DECISION: from the tautological family, not chart-by-chart

The consumption row reads: "`V :=` the h¹-fibrewise-vanishing open of the universal
family's λθ-shifted glued sheaf, cut by `rigidEngine_isOpen_vanishing` on the affine
atlas".  Over `DivScheme!` itself the λθ-shifted class IS the class of the universal
family (`λ_taut · θ^m · (−Σ) = [D_univ]` — the degree bookkeeping of §4), so the
sheaf is a datum in the class `[𝒪(D_univ)]`.  **Pin the carrier as the tautological
Zar family, not the per-chart universal families:**

```
univFam : divFamZar C π g (divSchemeOver!)  :=  divRep.homEquiv (𝟙 divSchemeOver!)
```

— a compatible family of `DivFamZar C Γ(U) π g` over the affine opens of
`DivScheme!` (`DivisorFamilyZarVehicle.lean:187-190`).  Then

> **(V-def)** `V := { x : DivScheme! | IsH1VanishingAt univFam x }` (predicate §1.2),
> `isOpen_V : IsOpen V`, `VOver := Over.mk ((V.ι …) ≫ divSchemeOver!.hom)`.

Justification: (i) it kills the chart-overlap seam — the per-chart spelling would
need the universal families' overlap agreement, which is exactly F5's family-side W3
(w4-ddr9 §3.4), pending; the tautological family's compatibility is DD-2 vehicle
data, already carried.  (ii) It is the shape `V ×_Div T` (§3.1) wants: the pulled
family of `u : T ⟶ divSchemeOver!` is `divRep.homEquiv u = (divFunctor).map u
univFam` by `homEquiv_comp` at `𝟙` — naturality makes the T-side condition literally
the pullback of the V-side condition.  (iii) The chart-level computation is
recoverable: at the atlas point `divCarveChartToDivScheme i j` (I-0242), `univFam`
restricts to `toZar` of `DivFam.mk (divUniversalFamily i j)` — this is F5's
`divRepPullAt` computation lemma consumed through DDR9-U, a POST-G-4 corollary, not
an input.

### §1.2 The membership predicate (Σ-H1LOC — the ONE dictionary, GAP-6)

For an affine test `S` and a locally certified class `F₀ : DivFamZar C S π g`, define
membership at `p : PrimeSpectrum S` in the **fibre-witness form** (exactly the
`hwit` slot of `subsingleton_h1_residueField_tensor_of_witness`,
`Cohomology/GluedSheafDatumFibre.lean:169-190`):

```
def DivFamZar.IsH1VanishingAt (F₀ : DivFamZar C S π g) (p : PrimeSpectrum S) : Prop :=
  ∃ W : ((C ⊗ overSpec k κ(p)).left).CurveDivisor,
    Scheme.CurveDivisor.picClass κ(p) W
        = Scheme.CechPic.map (relCurveMap C S κ(p)) F₀.picClass
      ∧ Subsingleton (Sheaf.HModule (… .divisorSheaf κ(p) W) 1)
```

(`DivFamZar.picClass` and its mapAlg law: `Picard/DivisorFamilyZarMapAlg.lean:195-199`.)
Lemmas of the dictionary file:

* **(V1a) class-only**: the predicate depends only on the fibre class — from
  `subsingleton_hModule_one_of_picClass_eq` (`RiemannRoch/ClassCohomology.lean:111`);
  in particular any witness serves, e.g. `divFamDivisor` of the fibre family
  (`Picard/DivisorFamilyField.lean:127`), which is effective (`:165`) of degree `g`
  (`FieldCRT:376`).
* **(V1b) the datum bridge**: for a certified representative `G` over `S` with
  divisor datum `D_G := (G.adaptation.thetaIdealDatum 0).inv` (GAP-1),
  `IsH1VanishingAt (toZar G) p ↔ Subsingleton ((datumPair D_G).H1 ⊗[S] κ(p))`.
  Forward: `subsingleton_h1_residueField_tensor_of_witness` (`GluedSheafDatumFibre:169`).
  Backward: `datum_subsingleton_h1_residueField_tensor_iff`
  (`Cohomology/GluedSheafFibre.lean:123`) + the δ-naturality base-change square
  (`GluedSheafDatumFibre.lean:105` and the `datumDiffBaseChange` mechanism it wraps)
  identify `H¹pair ⊗ κ(p) ≅ H¹` of the fibre datum, then `presentationSheafIso` +
  (V1a) read it as the witness clause.  All halves landed; the iff is the only new
  statement.
* **(V1c) locality/functoriality**: invariance under `mapAlg` along `S → Away f`
  and under change of certified representative — free from (V1a) +
  `picClass_mapAlg`.  Consequently the predicate extends to vehicle sections at
  arbitrary tests `T` pointwise (evaluate on any affine open containing the point),
  well-defined by the vehicle compatibility (`divFamZar.compat`,
  `DivisorFamilyZarVehicle.lean:198`).

### §1.3 Openness (the ONE mechanism, audited)

Per affine open `U ⊆ DivScheme!` with value `F_U`, per certificate piece: step 1 of
the landed backward assembly (`DivFamZar.exists_certified_away_rep`,
`Picard/DivRepClassifyZarKit.lean`, I-0243) gives certified representatives `G_l`
over `Away (h l)` covering `U`; on each piece the datum engine's openness export

```
datumRigidEngine_isOpen_vanishing :
    IsOpen {p : PrimeSpectrum B | Subsingleton ((datumPair D).H1 ⊗[B] κ(p))}
```

(`Cohomology/GluedSheafEngine.lean:221-231`, **Noetherian-free**) fires at
`D := D_{G_l}`; (V1b) says the piece trace of `V` is exactly this open; the piece
opens agree on overlaps by (V1c) and glue.  Discipline check (dat-d §3.5 echoed):
this IS the single sanctioned mechanism — the wrapper is the datum-level avatar of
`rigidEngine_isOpen_vanishing` (`Cohomology/RigidEngine4Assembly.lean:441-446`,
consumed at `GluedSheafEngine.lean:226`); no Fitting ideal, no semicontinuity, no
rank-jump locus anywhere in this design.

Deliverables of the V-file: `isOpen_setOf_isH1VanishingAt` (affine tests),
`V`/`VOver` (V-def), `mem_V_iff` (the pointwise dictionary against `univFam`), and
the atlas traces `V ∩ range (divCarveChartToDivScheme i j)` = the engine-open of the
universal family's datum (post-G-4 computation; stated against DDR9-U's U1 only).

---

## §2 The canonical-section normalization (`h⁰ = 1`)

Throughout: `S` affine, `G : CertifiedDivisorFamily C S π g` with
`hvan : ∀ p, IsH1VanishingAt (toZar G) p` ("`G` lands in `V`"), and
`D_G := (G.adaptation.thetaIdealDatum 0).inv` its divisor datum (class
`G.eqns.picClass` by GAP-1 + G-0a).  Noetherian discipline: every statement in this
section is stated over `[IsNoetherianRing S]`; the arbitrary-test consumers reach it
through RE-5 stages (`DatumDescent.lean:514/:547`) — record this ONCE, here, instead
of threading Noetherian into consumer-facing statements (the w4-ddr9 §0.4 lesson;
`datumRigidEngine` `GluedSheafEngine.lean:198` and the DAT-A bundle below carry the
hypothesis, the openness export does not).

* **(N1) Invertible `H⁰`.**  `datumRigidEngine D_G hπ hfib` with
  `hfib := (V1b).mpr ∘ hvan`: `Subsingleton H¹`, `H⁰ := Sheaf.HModule D_G.sheaf 0`
  finite projective (`GluedSheafEngine.lean:198-216`); rank 1 by **Σ-RANK1** (GAP-3).
  Base change on the nose along any `S → S'` on the locus: `datumH0BaseChangeEquiv`
  (`:246-256`).
* **(N2) THE canonical section is the equation system itself.**  The components
  `(G.adaptation.eqn j)_j` satisfy the inverse-datum matching condition (they are a
  section of `𝒪(d)`: `f_j = (eqnRatio j i)·f_i` is `Picard/DivisorThetaDatum.lean:264`
  read against the inverted units), giving `canon G : H⁰(D_G)` — and
  `sectionLocalEquations` applied to `canon G` returns a datum whose equations are
  the restricted `f_j` (`sectionLocalEquations_eqn`,
  `Picard/SectionsToDivisorsClass.lean:129`, rfl-level), hence **`DivEq` to
  `G.eqns` by pure refinement** (`picClass_restrict`-side laws; no fibre argument).
  This kills the "does the canonical section cut back `D`?" question definitionally.
* **(N3) Generators.**  `canon G` is fibrewise nonzero (the equations are fibrewise
  regular — `germ_component_mem_nonZeroDivisors` inputs,
  `Picard/SectionsToDivisors.lean:270`, and the certified family's own regularity);
  a fibrewise-nonzero element of the invertible `H⁰` is a Zariski-local basis
  (GAP-3 companion).  Conversely every local basis is fibrewise nonzero.
* **(N4) Sections cut divisors — DAT-A consumed on the nose.**  For ANY
  fibrewise-regular `σ ∈ H⁰(D_G)` (in particular any local basis):
  `sectionLocalEquationsOfFibrewiseRegular` (`SectionsToDivisorsClass.lean:201`,
  `[IsNoetherianRing]`, hfib slot in the `mulSectionEnd`-rTensor form) with class law
  `… _picClass = D_G.cechPicClass = G.eqns.picClass`
  (`:212`, `:159`; independence of section and cover `:173`).
* **(N5) Uniqueness, relative form (the mono engine).**  Two fibrewise-nonzero
  sections `σ, σ'` of `H⁰(D_G)` cut `DivEq` families: Zariski-locally `σ` is a basis
  (N3), so `σ' = a·σ` with `a ∈ S'` fibrewise nonzero, hence `a ∈ S'ˣ`; unit
  rescaling is a `DivEq` move (`LocalEquations.rescale`/`picClass_rescale` layer,
  `Picard/DivisorClass.lean`); globalize by the Zar-layer separation
  `DivFamZar.eq_of_away_eq` (`Picard/DivisorFamilyZarMapAlg.lean:240`).  **This is
  the I-0231-safe route**: the relative datum spent is invertibility of `H⁰`, never
  "fibrewise ⟹ relative".
* **(N6) Field anchor.**  Fibrewise, (N5) collapses to GAP-2 (Σ-UNIQ-fld) — needed
  only for DAT-B's coverage bookkeeping and the §3.3 pointwise characterizations,
  not for (N5) itself.

---

## §3 The chart functors and the 01JJ `hf` certificates

### §3.1 `V ×_Div T` — the BINDING consumption row (launchable the moment divRep lands)

For `u : T ⟶ divSchemeOver!` write `F_u := divRep.homEquiv u`.  Deliverables:

1. **(hf-Div-a) the pointwise law**: `u.left.base t ∈ V ↔ IsH1VanishingAt F_u t` —
   `homEquiv_comp` (the `RepresentableBy` axiom, mathlib
   `CategoryTheory/Yoneda.lean:284-288`) at the field points of `T` against (V-def)
   + (V1c); "the same engine-open in `T`" verbatim.
2. **(hf-Div-b) the subfunctor certificate**: the sub-presheaf
   `divFunctorH1 ⊆ divFunctor C π g` of pointwise-h¹-vanishing families is
   representable by `VOver`, with the fibre product of `VOver ⟶ divSchemeOver!`
   (an open immersion) against any `u` being `u.left ⁻¹ᵁ V` — i.e. DD-1a consumed as
   `divFamZar.map` functoriality (`Picard/DivisorFamilyZarMap.lean`, laws landed) +
   (hf-Div-a).  Pure transcription given divRep; size M.

### §3.2 The chart functors (index, value, mono)

**Chart index** (dat-d §1.3, unchanged): `c = (m, Σ)`,
`Σ : (C ⊗ overSpec k k).left.CurveDivisor`, `0 ≤ Σ`,
`deg k Σ = m·d₁ − g` where `d₁ := classDeg k (thetaCechClass C)`
(`Picard/ThetaShift.lean:263`, positivity `:270`).

**Chart value.**  For a `T`-point of `VOver` with family `F` (through §3.1):

```
chartValue c F := abelDiv F * sigmaFamily Σ T * (thetaFamily C (thetaCechClass C) T ^ m)⁻¹
```

in `picEt C T`, where `abelDiv` is §4's Abel transformation and
`sigmaFamily Σ := thetaFamily C (Σ.picClass-as-CechPic)` — the DAT-5 base-class
pullback mechanism REUSED at `L₀ := CurveDivisor.picClass k Σ`
(`thetaFamily` `Picard/ThetaShift.lean:104`, naturality `:111`, degree law `:136` —
`degAt (sigmaFamily Σ) t = deg k Σ` with E-iv-alg under it).  Membership in
`pic0Subgroup C T` (`Picard/Pic0Functor.lean:107`, membership `:121`) is the degree
sum `g + (m·d₁ − g) − m·d₁ = 0` — §4.2's ledger, all landed names.  The chart map
into the Σ-extension: `f_c : yoneda.obj (VOver.left) ⟶ (pic0SigmaSheaf C).1`, at a
scheme `T'`: `v ↦ ⟨v ≫ VOver.hom, chartValue c (F_v)⟩` (the Σ-component bookkeeping
of `Over.sigmaExtension`, `Picard/OverSigmaExtension.lean:125`).

**Mono-ness** (the `h⁰ = 1` uniqueness; Kleiman tex 2024-2027 recast).  Suppose two
`V`-families `F, F'` over affine `S` have `chartValue c F = chartValue c F'`.  Then
`abelDiv F = abelDiv F'` (group cancellation in `picEt`); by (C1) unit injectivity
(`PicEtAff.unit_injective_of_ker` + the ζ1-reduction it wraps,
`EtaleSeparatednessClose.lean:193`; its `hker` slot is the (C2)-effectivity layer of
`Picard/EffectivityClose.lean` — the assembled "unit injective" corollary should be
consumed through ONE named wrapper, see risk 3) their relPic classes agree:
`relPicMk (F.picClass) = relPicMk (F'.picClass)`.  **The base-twist subtlety
(recorded — the Hilbert-90-class hazard of this campaign):** `relPic` is the
quotient by classes pulled back from the test (`Picard/RelPic.lean:63`,
`relPicMk_eq_relPicMk_iff` `:80`), so the Čech classes differ by `p*N`,
`N ∈ Pic(Spec S)` — NOT necessarily trivial on an affine test.  Route: Zariski-locally
on `S` the twist `N` trivializes; there the datum sheaves are identified by the
cohomologous-cocycle transport (`gluedSheafCongr` + `gluedCongrEquiv`,
`Cohomology/GluedSheafCongr.lean:168/:110`, with `subsingleton_hModule_gluedSheaf_congr`
`:175` carrying h¹-vanishing across); the transported canonical section of `D_{F'}`
is a fibrewise-nonzero section of `D_F`, so (N5) gives local `DivEq`; globalize by
`DivFamZar.eq_of_away_eq` (`ZarMapAlg:240`).  Unit-scalars live in
`Γ(C_S, 𝒪)ˣ = Sˣ` by `Over.universalSections` (`Picard/UniversalSections.lean:123`).
Output: `chartValue c` is injective on `V`-points — `f_c` is a mono of presheaves.

### §3.3 The `hf` certificate at `pic0SigmaSheaf` — the CHART-U interface (the DDR9-U pattern)

Target, frozen by §0.2.1: `IsOpenImmersion.presheaf (f_c)` for every `c`; then
`pic0RepresentableByOfCharts` (`Pic0SigmaSheaf.lean:161-171`) + DAT-B's joint
surjectivity finish Stage C.  For a test `T` with Σ-point `(a, λ)`,
`λ ∈ pic0Subgroup C (Over.mk a)`, the fibre product of `f_c` against `λ` is the
subfunctor of maps `T' → T` along which `λ` becomes a chart value.  Split, and pin
the boundary as a NAMED interface so the DAT-B lane slots in:

* **CHART-U(a) — the membership locus.**
  `chartLocus c λ := { t : T | the fibre class λ_t·θ^m·(−Σ) at κ(t) has an effective
  degree-g witness with h¹ = 0 }` — the field-point predicate, well-defined for plus
  classes through the DAT-4 collapse (`picEtAffineEquiv` naturality,
  `Picard/PicEtMap.lean`; degree part landed as `degAt`, `Pic0Functor.lean:54`; the
  h¹ part is the witness clause at the κ(t)-collapse — for classes reached through
  §3.2's `chartValue` this is (V1a) on the nose).  DAT-C states everything against
  `chartLocus`; membership-vs-fibre-product is the mono (§3.2) + normalization (§2).
  **STATUS 2026-07-28 (run 0072): `chartLocus` IS NOW DEFINED**, in
  `Picard/Pic0ChartLocus.lean`, in the (a-amendment) split form, over a general test, at
  the twisted class — sorry-free.  Three corrections this pass, all measured against the
  tree rather than inferred:

  * **The input list above was incomplete: there is a FOURTH input, prior to all three.**
    The predicate is a condition on *points of a general test*, and nothing in the tree
    converted a point of `T.left` into anything at which a class can be evaluated: every
    witness predicate is indexed by `q : PrimeSpectrum B` over an *affine* base, and every
    class is evaluated at a field point only through a morphism `overSpec k K ⟶ T` for an
    abstract `K`.  That conversion is `Over.testPoint` (`Picard/Pic0ChartTestPoint.lean`),
    built from mathlib's canonical `Scheme.fromSpecResidueField`, which makes
    chart-independence *free* rather than a well-definedness side condition.  (The affine
    -chart route — pick `U ∋ t`, use `IsAffineOpen.primeIdealOf` and
    `Over.fromSpecAffine` — was tried and abandoned: it needs an independence-of-`U`
    lemma before it can define anything.)
  * **The split predicate is `IsSplitWitness`**, and the amendment's "some (equivalently
    every)" is *not* symmetric in cost.  The ∃-form is the definition; the comparison of
    two splittings goes through a common separable extension
    (`exists_witness_of_separable_extension`, which rests on the co-owned
    `hasWitnessH1Vanishing_iff_of_separable`), not through a direct comparison.  The
    splitting itself is `Algebra.EtaleCover.exists_finiteSeparableField_algHom`
    (`Algebra/EtaleCover.lean:287`, landed) applied to the étale cover of the plus class.

    **The splitting is now its own theorem** (`Picard/Pic0ChartSplit.lean`, `9f5d2a3e6`,
    sorry-free): `exists_splitting_of_picEt` — *every* plus class over a field is `relPicMk`
    of an honest Čech class over some finite separable extension, unconditionally and with no
    witness clause; and `isSplitWitness_iff_exists_splitting_witness` says `IsSplitWitness`
    is exactly "some splitting carries a witness".  This matters for lane order rather than
    tidiness: `IsSplitWitness` is a twelve-component existential whose **first eight
    components exist for every class with no hypothesis**, and §1.2 of `w4-datb` needs the
    splitting fixed at step 1 so that `m` can be chosen at *that* field in step 3 (where the
    uniform bound provably does not exist) and the witness produced only at step 5.  As one
    existential the `m`-choice and the splitting choice are entangled.

    Two elaboration hazards are recorded in that file and should not be re-discovered: the
    derived `Algebra k L` must be `clear_value`d before closing the existential (otherwise a
    composite instance term is substituted and the `overSpec k L` carriers are re-checked
    against it — no convergence in 1600000 heartbeats), and **no positional introduction rule
    exists**, deliberately: `IsSplitWitness` spells the base-changed curve two ways, so
    handing its tuple to one anonymous constructor while `L` is a metavariable does not
    elaborate at any budget tried.  Use `Iff.rfl` plus `.mpr` at a site where `L` is fixed.
  * **The twist has a class-side avatar now**: `chartTwist`.  ~~with `degAt_chartTwist` giving
    fibre degree `deg Z − m·d₁`, matching `degAt_chartValue` at `n = 0`~~ — **that was a SIGN
    ERROR and it made the locus VACUOUS.  Fixed 2026-07-28, `8ef9493ff`, issue I-0514.**

    `chartTwist` must be the INVERSE of `chartValue`'s twist.  `chartValue` is
    `abelDiv · Σ · (θᵐ)⁻¹`, so recovering the Abel class means multiplying by `θᵐ` and dividing
    by `Σ`: `chartTwist := λ · θᵐ · Σ⁻¹`, with `degAt_chartTwist = m·d₁ − deg Z = +g` under the
    chart-index constraint.  The earlier version applied the `chartValue` twist itself, giving
    `−g`; since `Subsingleton H¹(𝒪(W))` forces `deg W ≥ g − 1`, **that locus was empty for every
    `g ≥ 1`** and CHART-U(b)'s openness of it was the openness of `∅`.  The comparison point is
    `degAt_chartValue` at **`n = g`** (where the chart index is calibrated and `chartValue` lands
    in `pic0`), not at `n = 0`.

    **Why no ledger caught it, and this is the transferable part:** the wrong-signed
    `degAt_chartTwist` was *internally consistent*.  It computed `−g` faithfully and its docstring
    said so out loud.  A degree ledger recomputes a sign error rather than detecting it.  The fix
    therefore ships an **inversion law** instead of just a corrected ledger:
    `chartTwist_chartValue : chartTwist C m Z T (chartValue C π n m Z T s) = abelDiv C π n T s`
    (by `group`), which is FALSE of the old definition.  Pin a direction with a round-trip law,
    not with a degree.

* **CHART-U(b) — openness of `chartLocus` (SHARED brick, DAT-B co-owner; honest new
  work, M→L).**

  **STATUS 2026-07-28 (run 0072): assembled CONDITIONALLY** in
  `Picard/Pic0ChartLocusIsOpen.lean`.  Every link of the (b-amendment) chain is landed
  except one, and the file's header table names each with its anchor.  The residue is
  **not** the point-set transports: it is the *shifted-datum presentation* — a
  `BasicOpenCocycleDatum` whose class is the twisted class — pinned as
  `IsChartDatumPresentation` and consumed by
  `isOpen_setOf_isSplitWitness_of_presentation`.

  **TWO CORRECTIONS TO THIS ROW, both later on 2026-07-28 (run 0072), both retracting
  claims made higher up in the same paragraph:**

  1. **The file is now sorry-free** (`e6a7b0582`).  The `sorry` at
     `isOpen_setOf_hasWitnessH1Vanishing_testPointField` was described here as
     "transcription", and the three goals recorded at it were correct — but it was stated
     with the `Algebra A` / `IsScalarTower k A` structures on `κ(t)` as explicit `alg`/`tow`
     ARGUMENTS, and in that form **the statement is unprovable**: an arbitrary regrading of
     `κ(t)` over `A` is not a legal reading of the fibre.  With the canonical instances of
     `Picard/Pic0ChartTestPoint.lean` the proof is three lines.  The carrier identification
     `↥(overSpec k A).left = PrimeSpectrum A` is *definitional* (so the topology agreement is
     free and the two loci are the same set of the same type), and the only content is
     `Spec.residueFieldIso` fed to `hasWitnessH1Vanishing_iff_of_fieldExtension` through the
     new `algebraMap_testPointFieldAffine_factors`.
  2. **"Producing it needs the mul/tensor half of GAP-1" is FALSE** (`a5da2f1a1`; see the
     retraction in §0.3).  The twist is ONE `thetaFamily` (`chartTwist_collapse`), so there
     is no datum product in the route; and `exists_cechPicClass_eq` presents any class
     including a product outright.  The residue of this row is therefore *only* the pointwise
     identification `IsChartDatumPresentation` — a `cechPicClass` base-change statement — and
     not any construction.

  **THIRD CORRECTION, 2026-07-29 (run 0072 r6, lane `ajcr-charts`): the residue's WITNESS half
  is discharged, so the row is now entirely a plus-class statement.**
  `IsChartDatumPresentation` is an `↔`; `Picard/Pic0ChartPresentationHalf.lean` proved the
  forward half by the trivial splitting and named the converse `hconv` (the descent direction:
  from a split witness at *some* `L_t/κ(t)`, produce the datum's predicate at `κ(t)`).  `hconv`
  is now proved — `hasWitnessH1Vanishing_of_isSplitWitness_at`,
  `Picard/Pic0ChartPresentationConverse.lean`.

  **The transferable content is which ingredient was missing.**  That file's docstring priced
  the obstruction correctly ("the witness received lies in `μ`'s class at `L_t` rather than
  visibly in `D`'s at `κ(t)`") and named two transport lemmas as the ingredients.  The step that
  makes the class *visible* is not a transport: it is `PicEtAff.unit_injective`
  (`Picard/CechKernelLemma.lean:361`, Kleiman 2.5(1) — the unconditional close of the ζ3
  campaign) together with `relPicMk_injective_of_subsingleton`, which force the presenting class
  to **equal** `D`'s fibre class at `L_t`.  Both have been in the tree for weeks and **no
  CHART-U row cites either**.

  So both halves of this row's residue are now witness-free, `H¹`-free and divisor-free, and
  what remains is exactly the `cechPicClass` base-change identity that correction 2 above
  predicted — at every extension of `κ(t)` rather than only at `κ(t)`, which is the one place
  the reduction is not tight (`isChartDatumPlusFibreAt_self` measures the gap: at `L := κ(t)`
  the two coincide by `Iff.rfl`).  Use `isChartDatumPresentation_of_plusFibre`.

  The datum-worksheet §2.3 chain, now fully landed except its last
  step: (1) extraction of the plus class to cocycle data on an étale carrier
  (`PicEtAff` + `exists_cechPicClass_eq`, `GluedSheafExtraction.lean:301`); (2) RE-5
  to a Noetherian stage (`DatumDescent.lean:514`); (3) the datum engine open on the
  stage (`GluedSheafEngine.lean:221`); (4) **the étale-image openness descent** —
  condition-on-the-cover ⟹ open image on `T` (étale maps are open; Kleiman tex
  2204-2244 pattern) — has NO landed avatar (grep this pass): pin
  `isOpen_chartLocus` as the brick's keystone, co-signed with DAT-B before either
  lane builds it.
* **CHART-U(c) — the universal element.**  On `U := chartLocus c λ` (affine pieces,
  RE-5 stages): the datum of `λθ^m(−Σ)` has invertible `H⁰` (N1-route at the shifted
  class); a local basis cuts a `LocalEquations` family (N4) with class
  `λθ^m(−Σ)` (DAT-A class law); **CERT-Σ** (§3.4) certifies it; `divRep.homEquiv.symm`
  (= the landed `divRepClassifyZar` through F6/F7) classifies it to `U ⟶ VOver`
  (in `V` since its class's fibre-h¹ vanishes by construction).  Fibre-product
  equality: forward by construction, uniqueness by §3.2 mono + `IsDivRepClassify`
  uniqueness (`DivRepClassifyZar.lean:168-200`).

  **CORRECTION 2026-07-29 (run 0072 r5, lane `ajcr-charts`): THE `hf` TARGET IS A
  CONJUNCTION OF TWO INDEPENDENT CLAUSES, AND THIS ROW — LIKE THE `c9b` ROADMAP ROW —
  PRICED IT AS ONE.**  Both said the residue is "relative GAP-2 plus the classifier,
  CERT-Σ-gated".  `IsOpenImmersion.presheaf` is `MorphismProperty.relative` at `yoneda`,
  whose *definition* (mathlib `MorphismProperty/Representable.lean:315`) conjoins

  1. **relative representability** — for every `g : yoneda.obj T ⟶ pic0SigmaSheaf`, the
     fibre product is representable **by a scheme**; and
  2. **the property clause** — every represented pullback is an open immersion.

  The construction+uniqueness story above is the input to (2).  It says nothing about (1),
  and (1) is where the whole CERT-Σ wait was being spent for no reason: supplying it needs
  only an OPEN OF THE TEST, and `chartLocus` is one, unconditionally.

  Landed this pass, both sorry-free and rooted:
  `Picard/Pic0ChartOpenImmersionCriterion.lean` states the elementwise datum
  (`ChartFibrePresented`: an open `W` of the test, a chart point `r` over it, the square,
  and a coverage clause `exists_factor`), proves it presents the fibre product
  (`ChartFibrePresented.isPullback` — pointwise pullbacks plus `Types.isPullback_iff`, with
  the joint-injectivity half FREE because `W.ι` is a monomorphism), and concludes
  `IsOpenImmersion.presheaf` from a family of such data.  Then
  `Picard/Pic0ChartUnivReduce.lean` instantiates at the Abel chart: `chartLocusOpens`
  supplies `W` by CONSTRUCTION, so **the datum a lane owes drops from four fields to
  three**, and `isChartUniv_of_isChartLocusFibre` composes with the already-landed
  composition half (`isOpenImmersion_presheaf_restrictChart`) to give `IsChartUniv` at any
  open.

  **The residue is genuinely moved, not renamed, and that is checked in both directions:**
  `isEmpty_forall_chartFibrePresented_of_not_injective` shows the datum cannot be
  *satisfied* by a chart map failing injectivity on even one test (so it is not vacuous, and
  in particular is unsatisfiable for the UNRESTRICTED Abel chart whose fibres are the linear
  systems `|D|`); and `injective_of_isChartUniv` shows `IsChartUniv` cannot be *reached*
  without that injectivity.  So relative GAP-2 remains a real gate — it now gates ONE FIELD
  (`exists_factor`) of ONE structure rather than the certificate.

  **Two by-products worth not re-deriving.**  (i) "The Abel map is not a monomorphism, hence
  `IsOpenImmersion.presheaf` fails unrestricted" is cited as a *reason* in three files
  (`Pic0AtlasFromDivRep.lean:54`, `Pic0ChartPair.lean:14`, and this row's own preamble); it
  is a **derivation** from mathlib's `presheaf_mono_of_le` at
  `IsOpenImmersion.le_monomorphisms`, now recorded as
  `mono_of_isOpenImmersion_presheaf`, not an independent obligation.  (ii) The open `V` in
  `restrictChart` is **arbitrary** for `hf` to hold — `IsOpenImmersion.presheaf` is stable
  under precomposition with an open immersion, so restricting to the chart locus is not what
  makes `hf` true.  The chart locus is where the *unrestricted* statement becomes true,
  which is a fact about `IsChartLocusFibre` and not about `V`.

Transition opens/isos between charts `(m,Σ) → (m',Σ')` need NO separate brick:
01JJ manufactures them from the certificates at `T := VOver`-tests
(`LocalRepresentability.glueData`, mathlib `Representability.lean:66-80`) — record
this to prevent scope creep.

### §3.4 CERT-Σ — the certificate for canonical-section families (GAP-4, THE heart)

**Statement pin** (over `[IsNoetherianRing S]`; `d :=` the family cut by a local
basis of the invertible `H⁰` of a datum `D` of fibre degree `g` on its h¹-vanishing
locus, with a CHOSEN finite basic-open adaptation `A` — the adaptation choice is part
of the brick):

```
theorem isCertified_sectionAdaptation … : A.IsCertified g
```

(`IsCertified` fields verbatim at `Picard/DivisorFamily.lean:426-441`.)  Per-clause
route — the CertUniv table (w4-g4 §3) rerun with the fibre inputs coming from
`deg = g` + `h⁰ = 1` instead of P-fib-N:

| clause | engine (landed) | fibre/relative input (this brick) |
|---|---|---|
| (c1) flat/proj | `flat/projective_colength_of_forall_tmul_residueField` (`Picard/SupportTube.lean:313/:329`) | fibrewise regularity of the basis components (N3 + `Scheme.germ_mem_nonZeroDivisors_of_ne_zero`, `Picard/SectionsToDivisors.lean:114`) |
| (c1) finite | `finite_colength_of_forall_fibre_closure_subset` (`Picard/SupportTubeFinite.lean:282`; closed-trace form `:263`) | **the no-leak clause** — NEW obligation (I-0244: not free!): choose the adaptation's basic opens so each fibre support point sits inside its piece with its branch; the fibre support is the witness divisor's finite support (deg g); the shrink freedom is the same Nakayama-neighbourhood move as the seed lane's |
| (c2) rank g | fibre count | fibre colength dim = deg of fibre divisor = g: `deg_divFamDivisor`/`deg_presentationDivisor` (`FieldCRT:376/:365`) + the CRT stalk-eval kit (`FieldCRT:85-190`) |
| (c2) fin/proj | from (c1)+(c3) as in the CertUniv table (Noetherian submodule + flat SES) | — |
| (c3)/(c4) | **SlicingFlatKernel** (`Picard/SlicingFlatKernel.lean`, I-0240: keystones 3/4/5/7 at `f := deltaLeft − deltaRight`) | `hle + hspan`: an f.g. `L ≤ ker f` of relative kernel elements spanning each residue fibre — for a canonical-section family the fibre kernel is the fibre glued colength (dim g); producing the relative spanning elements is the honest open core, THE SAME shape CertUniv must discharge for the universal family — **binding coordination: wait for CertUniv's discharge pattern and share it; do not invent a second mechanism** |

Consumers: CHART-U(c) here; DAT-B's coverage (its "local divisor presentation of an
arbitrary functor point" needs the identical brick at high twist — dat-worksheet
§2.2.3a); freeze this statement with DAT-B before building.

---

## §4 The Abel layer (consumption row 3)

### §4.1 The Abel transformation (launchable NOW — every name landed)

```
abelDivAff (S) : DivFamZar C S π g → picEt C (overSpec k S)
  F₀ ↦ relPicToPicEt C _ (relPicMk C _ (F₀.picClass))
```

(`DivFamZar.picClass` + `picClass_mapAlg` `Picard/DivisorFamilyZarMapAlg.lean:195-199`;
`relPicMk` `Picard/RelPic.lean:70`; `relPicToPicEt` `Picard/PicEtUnit.lean:126`, affine
consistency `:161`, naturality `:194`, functor form `picEtUnit` `:231`).  Naturality
along `A →ₐ[k] B`: `picClass_mapAlg` + `picEtMap_relPicToPicEt`.  Lift to the vehicle:
componentwise over affine opens (the `picEt` limit carrier, `Picard/PicEt.lean:105`),
compatibility from the same two laws — giving the natural transformation

```
abelDiv : divFunctor C π g ⟶ picEtTypeFunctor C     (and its DivFam-level avatar)
```

The `abelPicEt` assembly (`Picard/AbelElement.lean:82-96`) is the in-tree precedent
for exactly this composite — imitate its packaging.

### §4.2 The degree ledger: `abelDiv` lands in the degree-`g` layer

At a field point `t : overSpec k K ⟶ T`:

```
degAt (abelDiv F) t
  = relPicDeg K (relPicMap C t (relPicMk _ F.picClass))     -- degAt_relPicToPicEt, AbelElement.lean:69-75
  = classDeg K (fibre Čech class)                           -- relPicMk/relPicMap laws + relPicDeg_relPicMk, RelPicDegree.lean:75
  = deg K (divFamDivisor (fibre family))                    -- E-i classDeg_picClass, Degree.lean:157 + field presentation laws
  = g                                                       -- deg_divFamDivisor, FieldCRT:376
```

so `abelDiv` factors through `picDegLayerFunctor C g` (`Picard/ThetaShift.lean:162-186`)
— the shifted target of the dat-d Addendum, verbatim.  The chart shift composes with
DAT-5: `sigmaFamily` degree `m·d₁ − g` (§3.2), `thetaFamily^m` degree `m·d₁`
(`degAt_thetaFamily_pow` `ThetaShift.lean:149`; `degAt_pow`/`degAt_pic0_mul_pow`
`Picard/DegreeSeam.lean:135/:145`), sum `0` — `chartValue c` lands in
`pic0Subgroup` (`mem_pic0Subgroup_iff`, `Pic0Functor.lean:121`).  The final ε⁺
transport to `pic0` representability is DAT-J's `representableByOfShift`
(`ThetaShift.lean:225`) — NOT consumed here; DAT-C only feeds `picDegLayer`-shaped
data, per the Addendum's sharpened row.

---

## §5 File plan, lane order, launchability, honest risks

Memory discipline inherited in full (spec-w4-gates `:16-19`; ONE heavy lane;
single-module builds under the mkdir lock, `LEAN_NUM_THREADS=1`; ≤ 500 L; term-mode
over rw on glueData/cover-indexed composites — I-0236(c)/I-0237(a)/I-0238(a)/I-0242(a);
`include … in` for proof-only section variables — I-0236(b)/I-0244(a); pin
multipliers/carriers as defs before stating `*`-equations — I-0239(c); maxRecDepth
8000 near `divFamEps`/window defeq — I-0239(d)/I-0243(b); no `letI` two-level
`Algebra` towers over localizations — I-0243(a)).

| # | file (new) | contents | size | gated by | pre-divRep? |
|---|---|---|---|---|---|
| C0 | `Picard/DivisorDatumInverse.lean` | GAP-1: `BasicOpenCocycleDatum.inv` + `cechPicClass_inv`; `divisorDatum` + its class law (G-0a at 0 + `fiberTwist_zero`); the canonical section `canon` + (N2) | M | none | **YES — now** |
| C1 | `Picard/DivisorFamilyH1Locus.lean` | Σ-H1LOC (GAP-6): `IsH1VanishingAt`, (V1a)-(V1c), affine openness `isOpen_setOf_isH1VanishingAt` (§1.3) | M | C0 | **YES — now** |
| C2 | `Picard/DivisorDatumRankOne.lean` | Σ-RANK1 (GAP-3): rank-1 export on the locus, generator/fibrewise-nonzero kit, (N1)/(N3) | M | C0, C1 | **YES** |
| C3 | `RiemannRoch/EffectiveUniqueness.lean` | Σ-UNIQ-fld (GAP-2) | S→M | none | **YES — now** |
| C4 | `Picard/DivisorFamilyMonoH1.lean` | (N4)/(N5) + the §3.2 mono (incl. the base-twist Zariski-local route; the ONE named unit-injectivity wrapper) | M→L | C0–C3 | **YES** (class-level; no divRep) |
| C5 | `Picard/DivSchemeAbel.lean` | §4: `abelDivAff`/`abelDiv`, degree ledger, `sigmaFamily`, `chartValue` | M | none | **YES — now** |
| C6 | `Picard/DivSchemeH1Open.lean` | §1: GAP-5 open-immersion instance; `univFam`, `V`, `VOver`, `mem_V_iff`; chart traces vs DDR9-U | M | **divRep (F7)** + C1 (GAP-5 half: only F2/F3, landed) | GAP-5 + statements yes; the rest no |
| C7 | `Picard/DivSchemeChartFibre.lean` | §3.1 (hf-Div-a/b) — the BINDING row | M | C6 (divRep) | no |
| C8 | `Picard/DivSchemeChartCert.lean` | CERT-Σ (§3.4) | L | C2, C4; (c3)/(c4) pattern-gated on G-4 CertUniv | statement YES; heart pattern-gated |
| C9 | `Picard/DivSchemeChartHf.lean` | §3.3: `f_c`, mono packaging, CHART-U(a)/(c), `IsOpenImmersion.presheaf` given CHART-U(b) | L | C4–C8 + CHART-U(b) (shared w/ DAT-B) | no |

Lane order under the memory constraint: C0 ∥ C3 ∥ C5 (light, disjoint) → C1 → C2 →
C4 → C8-statement → [divRep lands] → C6 → C7 → [CertUniv pattern + CHART-U(b)
co-sign] → C8-proof → C9.  **Six of nine rows are fully launchable before divRep**;
C7 (the binding consumption row) is a bounded transcription the day F7 lands.

**AMENDMENT 2026-07-29 (run 0072 r5, lane `ajcr-charts`): the C9 ROW'S DEPENDENCY LIST IS
TOO LONG, and the lane order above therefore serialises more than it must.**  Row C9 lists
`C4–C8 + CHART-U(b)`, and the lane order puts C9 last, after C8's proof.  That is right for
the *whole* of C9 and wrong for the part of it that carries the `hf` obligation:

* the `IsOpenImmersion.presheaf` **plumbing** — the criterion, the fibre-product
  presentation, and the reduction of `IsChartUniv` to a three-field datum — depends on
  **none** of C4–C8 and is landed (`Picard/Pic0ChartOpenImmersionCriterion.lean`,
  `Picard/Pic0ChartUnivReduce.lean`);

  **CORRECTION 2026-07-29, later the same day** (`Picard/Pic0ChartCoverageAbel.lean`).  This
  bullet ended "Its only geometric input is CHART-U(b), already done".  CHART-U(b) is **not**
  done in the sense that sentence needs.  `isOpen_chartLocus_of_affineLocal'` is unconditional
  only in `IsSplitWitnessIsoInvariant`; it still takes the affine-local `haff`, and nothing in
  the tree discharges that — the affine case
  (`isOpen_setOf_isSplitWitness_of_presentation`) is conditional on
  `IsChartDatumPresentation`, i.e. on this row's own §3.3 CHART-U(b) residue, which the
  CHART-U(b) row above states correctly and this bullet contradicted.  The residue is now
  named in Lean (`ChartLocusAffineLocal`) and reduced to it
  (`chartLocusAffineLocal_of_presentation`), so the two readings agree and the plumbing's
  geometric input is B-4's presentation, not nothing;
* what genuinely waits on C6/C7/C8 is one field of one structure, `IsChartLocusFibre`'s
  `exists_factor` together with the classifier-produced `r`.

So the honest reading of the table is that C9 splits, and its *first* half was launchable
before divRep along with the "six of nine" already counted — making it seven.  A lane
picking up C9 after C8 lands should not re-derive the plumbing; it should supply
`IsChartLocusFibre` and call `isChartUniv_of_isChartLocusFibre`.

**DAT-B's B-6 is likewise off the critical path** (`Picard/Pic0ChartLocalSurjectivity.lean`,
`isLocallySurjective_sigmaDesc`): the local-surjectivity instance
`pic0RepresentableByOfCharts` consumes is now produced from B-5 alone, certificate-free and
divRep-free.  Nothing in the C-row chain gates it.

**Honest risks (expanding §0.4).**

1. **CERT-Σ (high — the only new mathematics wholly inside DAT-C's scope).**  The
   (c3)/(c4) `hspan` production and the (c1)-finiteness no-leak clause have no landed
   producer for section-cut families.  Mitigations: every abstract engine landed this
   week (I-0240/I-0244; `SupportTube:313/:329`); the fibre inputs are the CHEAP ones
   (`deg g` + `h⁰ = 1`, all landed laws); binding coordination row with the G-4
   CertUniv lane (share the discharge pattern, one mechanism).  Fallback: none needed
   for Stage-B statements (C8's statement freezes the boundary); if the pattern walls
   for BOTH CertUniv and CERT-Σ it is a spec-dd-r risk-1 escalation, orchestrator-owned.
2. **CHART-U(b) openness at arbitrary plus classes (medium-high, shared).**  The
   étale-image descent step is genuinely unlanded; steps 1–3 of its chain are done
   (§0.2.4/5 + engine).  Mitigation: the CHART-U interface freezes the statement so
   DAT-C's C9 and DAT-B's coverage consume one brick; co-sign before building.
3. **Class-transport plumbing in the mono (medium).**  The relPic base-twist coset
   (§3.2) is the Hilbert-90-class hazard; the unit-injectivity statement is spelled
   through a `hker` slot (`EtaleSeparatednessClose.lean:193`) whose discharge lives in
   the effectivity lane — DAT-C must consume ONE assembled wrapper (pin
   `relPicToPicEt_injective`-shaped; if the assembled form does not exist, that is a
   C4-file S-brick against `unit_injective_of_ker` + the (C2) `hker` discharge, and
   the worksheet flags it as the only unverified-assembly consumption in this design).
4. **Elaboration weight (medium).**  C4/C9 combine datum sheaves + Over + covers +
   classify vocabulary — the recorded 58 GB profile class.  Mitigations: the
   gotcha-list disciplines (header of §5), one heavy declaration per unit,
   characterizing-lemma style against every `Classical.choose` (the I-0243
   `IsDivRepClassify` precedent — quantified clauses over tower tests make
   refinement-stability definitional; imitate for `chartValue` fibre products).
5. **divRep slippage (externalized).**  F5–F7 pending (F4 landed, I-0243).  The
   §1.1 tautological spelling + DDR9-U keep the blast radius to C6/C7.
6. **Scope guard (recorded to prevent creep).**  NOT in DAT-C: joint local
   surjectivity / coverage (DAT-B), the 01JJ invocation itself and lft certificates
   (DAT-glue, via `pic0RepresentableByOfCharts` + `DivQProjBundle` — both landed),
   the ε⁺ shift consumption (DAT-J, `representableByOfShift`), any Galois descent
   (DAT-G), transition-iso bricks (§3.3 last paragraph), any second openness
   mechanism (dat-d §3.5 binding; every open in this design is a
   `datumRigidEngine_isOpen_vanishing` instance).

*End of worksheet.  The §0.3 gap list (GAP-1…6), the CHART-U and CERT-Σ interface
freezes (co-sign with DAT-B and the G-4 CertUniv lane), and the §0.2 stale-row
corrections (FieldCRT landed, DAT-2/DAT-6/RE-5/extraction landed, G-0a landed) should
be echoed to the orchestrator; C0/C1/C2/C3/C4/C5 can be handed to implementation
lanes cold, today.*
