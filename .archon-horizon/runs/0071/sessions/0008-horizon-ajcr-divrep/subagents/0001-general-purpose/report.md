The monitor is already armed for this. I'll report on the measurements now, and the build verdict when it arrives.

## Report — DDR9-U epsilon identity, measured at HEAD (AJCR)

**Headline: the epsilon-identity you describe as U2's content is ALREADY LANDED as a statement, in a file that is 40 minutes old, has no `.olean`, and is unreachable from the root aggregator.** `AlgebraicJacobian/Picard/DivRepChartClassUniv.lean` (219 lines, no `sorry` as a term) proves exactly the U2 epsilon half from ONE hypothesis (`IsCertified`). Verification build is still running; everything below is read from source.

### 1. `divFamEps`

Defined `AlgebraicJacobian/Picard/DivisorFamilyWindow.lean:260`. Takes `(g : ℕ) (F : DivFam C R π g)`, returns a pair of submodules of `R ⊗[k] H_M` and `R ⊗[k] H_{M+s}`. Body reads **only** `F.window` at the two pinned exponents:
```
(F.window (relThetaPairH1_windowM C π hπ g), F.window (relThetaPairH1_windowMS C π hπ g))
```
`DivFam.window` (`:139`) is `Quotient.lift` of `divisorWindow G.eqns` (`:104`), which reads **only** `d.vanishingSubmodule` — no adaptation, no certificate, no cover. So `divFamEps` of `DivFam.mk G` reads exactly one field, `G.eqns` (`divFamEps_mk`, `:268`, `rfl`).

Landed lemmas relating `divFamEps` to an explicitly-constructed pair:
- `divFamEps_mk` — `DivSchemeEps`-independent, `DivisorFamilyWindow.lean:268`.
- `divFamEps_mk_eq_of_le` — `Picard/DivSchemeEps.lean:282`. Given `(x₁, x₂)` contained in the two windows plus two `thetaGluedEval` surjectivities, `divFamEps = (x₁.toSubmodule, x₂.toSubmodule)`.
- `ThetaGeneratorSeed.divFamEps_certifiedFamily` — `Picard/DivSchemeEps.lean:312`. Same, for a seed-built family; first containment automatic from `le_vanishingSubmodule`, second (`hle₂`) threaded.
- `divFamEps_mapAlg` / `_awayMap` — `Picard/DivisorFamilyEpsNaturality.lean:441,463` (G-2 naturality).
- `divFamEps_carve` — `Picard/DivSchemeEpsCarve.lean:344`.
- `ThetaGeneratorSeed.divisorWindow_eq` — `DivSchemeEps.lean:221` (single-window form).

Full list of 49 declarations whose *statement* mentions `divFamEps` was enumerated; the epsilon-vs-explicit-pair ones are the five above.

### 2. THE CRUX — this is **NOT** "no such declaration"

`AlgebraicJacobian/Picard/DivRepChartClassUniv.lean` contains three theorems relating `divFamEps` over the chart ring to the universal windows:

- **`PointwiseAchiever.divFamEps_highWindow_eq_universal_pair`** (`:162`):
```
divFamEps hpi g (DivFam.mk ((univSeed …).certifiedFamily g … hc))
  = ((divUniversalFstWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule,
     (divUniversalSndWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule)
```
Hypotheses beyond ambient ledger data: `hb : 0 < windowBound pi hpi` and `hc : (… .divisorAdaptation …).IsCertified g`. Nothing else.
- **`exists_certifiedFamily_divFamEps_eq_universal_pair`** (`:192`) — existential form.
- **`divFamZarUniv`** (`:205`) — the `DivFamZar C RZ pi g` class itself, from the same `hc`, via `CertifiedDivisorFamily.isLocallyCertified` (trivial one-member cover; no Zariski shrinking).

How the three inputs other than `hc` are discharged (I verified each producer exists and its hypotheses):
- generator: `isGenerator_highWindowPointwiseGeneratorSeed`, `Picard/DivSchemeHighWindowPointwiseGenerator.lean:89` — from `hO, hchi, hb` only, routing `pointwiseSeedRDN_of_highWindow` (`DivSchemeHighWindowQuotientBridge.lean:119`). This is **not** `seedUniv'`, so it does **not** consume `SeedUnivRDN`.
- `hle₂`: `divUniversalSndWindow_le_highWindow_divisorWindow`, `Picard/DivSchemeHighWindowSecondContainment.lean:114` — same three hypotheses, for this very seed.
- both surjectivities: `DivisorAdaptation.IsCertified.thetaGluedEval_surjective`, `Picard/DivisorThetaFibreData.lean:271` — from `hc` itself.

Type-correctness with no transport is real: `divUniversalSeedK` (`Picard/DivSchemeSeedUniv.lean:186`) is *syntactically* `Submodule.map (relThetaWindowEquiv … (relThetaPairH1_windowM …)).toLinearMap (divUniversalFstWindow …).toSubmodule`, i.e. verbatim the `K` binder of `divFamEps_certifiedFamily` at `x₁ = divUniversalFstWindow` (`DivSchemeEps.lean:318-321`).

**Three defects in this file, all measured:**
1. **No `.olean`.** `.lake/build/lib/lean/…/DivRepChartClassUniv.olean` does not exist; the LSP reports "Imports are out of date". Its two key inputs *do* have `.olean`s. So the file has never been kernel-verified in this tree. Build in flight.
2. **Unreachable from the root aggregator.** I computed the import closure of `AlgebraicJacobian.lean`: 624 of 693 files reachable; this file is NOT, nor are its two inputs. Of the 44 `DivSchemeHighWindow*.lean` files, **only 6 are reachable**. No file in the tree imports `DivRepChartClassUniv`. Its own docstring (`:44-49`) diagnoses exactly this for its inputs — and then reproduces it.
3. **Basis-argument mismatch blocks the consumer.** The crux file's `RZ` (`:120`) is `DivCarveChartRing … b1 b2 i j` with `b2 : Basis … ((S•F) + (M•F))`. Every U2 consumer (`DivRepChartRange.lean:110`, `DivRepAffPullClause.lean:101`) uses `ChartRing i j := DivCarveChartRing … b1 (b2.map (windowShiftEquiv hpi g).symm) i j` with `b2 : Basis … ((M+S)•F)`. Same underlying mathematics, but the chart ring is keyed on a *different term*, so `divFamZarUniv` is not literally a `DivFamZar C (ChartRing i j) pi g`. This is the reindexing that must be reconciled before `isChartClause_iff_forall_classify_eq` (`DivRepChartRange.lean:172`) can consume it. Note `seedWindowShiftEquiv` (`DivSchemeSeedUniv.lean:149`) and `windowShiftEquiv` (`DivSchemeClassifyBridge.lean:86`) have **identical bodies** (`LinearEquiv.ofEq` of the same `add_nsmul`/`add_comm` proof), so the bridge is bookkeeping, not content. There is NO landed lemma relating the two chart rings.

**Also: nothing consumes any of the three.** `grep` for `divFamZarUniv`, `divFamEps_highWindow_eq_universal_pair`, `univSeed` outside the file: zero hits.

Beyond this file, the answer to your question as posed is **NO SUCH DECLARATION**: no other declaration in either project relates `divFamEps` to `pairTautFst/Snd`/`divUniversalFst/Snd`/`divUniversalSeedK`. The 14 declarations mentioning `divFamEps` together with `pairTaut` (`DivSchemeClassifyGlobal.lean:104`, `DivSchemeClassifyAff.lean:82`, `DivRepClassifyZarKit.lean:433`, etc.) all take the framing as a *hypothesis*. AJC has zero occurrences of `divFamEps`, `pairTautFst`, `divUniversalSeedK`.

### 3. `ThetaGeneratorSeed` / `localEquations`

Structure at `Picard/DivSchemeFamily.lean:74`: fields `side`, `h`, `mem_basicOpen`, `sec`, `sec_mem`. `IsGenerator` (`:129`) has two fields: `dvd` (Nakayama-neighbourhood) and `fibre_regular`.

`D.localEquations hD` (`Picard/DivSchemeFamily.lean:349`) produces a `(relCurve C R).LocalEquations` with `cover.opens = D.piece`, `eqn = D.eqn` (the side component of the chosen generator), `regular` from `germ_eqn_mem_nonZeroDivisors`, `ratio_isUnit` from `exists_ratioUnit`. So `divisorWindow (D.localEquations hD)` reads only the pieces and side components.

Landed lemmas computing `divFamEps`/`divisorWindow` of a `ThetaGeneratorSeed` family:
- for **`seedUniv'`**: **NO SUCH DECLARATION.** `seedUniv'` (`DivSchemeRedesignSeedUniv.lean:180`) and `isGenerator_seedUniv'` (`:205`) exist but no epsilon/window computation is stated for them anywhere.
- for a general seed at a given pair: `ThetaGeneratorSeed.divFamEps_certifiedFamily` (`DivSchemeEps.lean:312`), `divisorWindow_eq` (`:221`).
- for the **high-window pointwise seed** (a *different* seed over the same `RZ` at the same `K`): the crux file's `:162`, plus the containment half `DivSchemeHighWindowSecondContainment.lean:79,114`.

`DivSchemeSeedUnivFacts.lean` and `DivSchemeCertSeed.lean` contain **no** `divFamEps` or `divisorWindow` occurrence at all.

### 4. Hypotheses to produce a `DivFamZar` over the chart ring

The `seedUniv'` route you name is **the wrong route** — it is strictly harder than the landed one. Both are recorded.

`ThetaGeneratorSeed.divFamZar_of_forall_away_certified` (`DivSchemeCertZarSeed.lean:132`) needs `hD : D.IsGenerator` plus a span-⊤ family with per-member away certificates. Via `seedUniv'` + `isGenerator_seedUniv'` (`DivSchemeRedesignSeedUniv.lean:205`) the propositions with no producer are:

(a) **`SeedUnivRDN`** — `abbrev`, `Picard/DivSchemeRedesignSeedUniv.lean:130`:
```
∀ z : relCurve C (seedChartRing …),
  (isAffineOpen_relPinnedChart … ((seedUniv …).side z)).primeIdealOf ⟨z, seedUniv_mem_chart … z⟩
    ∉ Module.support Γ(relCurve C (seedChartRing …), relPinnedChart … ((seedUniv …).side z))
        ↥(seedUnivColength C hπ g r₁ r₂ b₁ b₂ i j hO hχ z)
```
Reducible to `seedUnivRDN_of_forall_germ_mem_span` (`DivSchemeRedesignKappaZSeed.lean:113`) from a germ-divisibility premise, which itself has no producer.

(b) **`hfib`** of `isGenerator_seedUniv'` (`DivSchemeRedesignSeedUniv.lean:206-218`) — the achiever's fibrewise-nonzero reading on the ann-cutter neighbourhood, quantified over all `z` and all `p : PrimeSpectrum RZ`. No producer.

(c) the away-certificate family itself.

**Both (a) and (b) are bypassed** by the high-window pointwise seed: `isGenerator_highWindowPointwiseGeneratorSeed` needs only `hO, hchi, hb`, and `pointwiseSeedRDN_of_highWindow` discharges RD-N from `flat_chartReadIdeal_divUniversalSeedK` (`DivSchemeHighWindowQuotientBridge.lean:86`), unconditional given `hb`.

So on the live route the residue is exactly **two** propositions:

(i) **`hc : (… .divisorAdaptation …).IsCertified g`** — the seven-field `DivisorAdaptation.IsCertified` (`Picard/DivisorFamily.lean:426`: `finite_colength`, `projective_colength`, `finite_glued`, `projective_glued`, `rankAtStalk_glued`, `flat_coker_incl`, `flat_coker_diff`) at the universal point. Assemblers exist (`DivSchemeCertUniv.lean:71,166`; `DivSchemeCertZarKerSpan.lean:63,123`) whose remaining inputs are `hnoLeak` (globally FALSE, I-0209 — must go through `Localization.Away`, `DivSchemeCertZarTube.lean:176`, `DivSchemeCertZarPointwise.lean:141/181`) and `hinj` (residue-fibre injectivity of the injectivized Čech difference; the generic criterion is `liftQ_rTensor_injective_of_conjugate_boundary`, `DivSchemeHighWindowConjugacy.lean:93`). The degree gate IS discharged for this seed: `deg_presentationDivisor_pulledEquations_pointwiseGeneratorSeed` (`DivSchemeSeedUnivPulledDegree.lean:484`). **Caveat:** the crux file's `divFamZarUniv` takes `hc` *globally* over `RZ`, which is the shape `DivSchemeCertZarSeed.lean`'s header calls the strictly-stronger-than-needed one. The widened endpoint `exists_isCertified_of_seed_of_swallowing_affineOpen` (`DivisorFamilyAffSeedEndpoint.lean:78`) produces an `AffAdaptation.IsCertified`, and I found **no** bridge from `AffAdaptation.IsCertified` to `DivisorAdaptation.IsCertified`, nor from `IsLocallyCertifiedAff` to `IsLocallyCertified` — `DivFamZar.toAff` (`DivisorFamilyAffCompare.lean:262`) runs the other way only.

(ii) **`hb : 0 < windowBound pi hpi`** — a scalar side condition, and it is *not* a real gate: `genus_eq_zero_of_windowBound_nonpos` (`RiemannRoch/WindowLedgerF3.lean:68`) gives `g = 0` in the other branch, and the by-cases pattern is already used twice (`DivisorThetaFibreData.lean:148`, `DivSchemeSeedUnivFibre.lean:327`).

### 5. `seedChartRing` vs `DivCarveChartRing`

`abbrev`, `Picard/DivSchemeRedesignCarvePin.lean:57`:
```lean
abbrev seedChartRing : Type u :=
  DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
    (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j
```
It is a **reducible abbreviation**, so `seedChartRing C hπ g r₁ r₂ b₁ b₂ i j` is **definitionally** `DivCarveChartRing` at exactly the campaign windows `A = windowS_choice • fiberWeilDivisor π`, `B = windowM_choice • fiberWeilDivisor π`. The seed lives over precisely the chart ring in the sense of the `A`/`B` arguments — this half is clean.

The residual mismatch is **not** in `A`/`B` but in the `b₂` argument, as in (3) item 3: the seed lane (`DivSchemeSeedUniv.lean:141`, `DivSchemeRedesignCarvePin.lean:51`) types `b₂` at `(S•F) + (M•F)` and passes it raw; the U2 consumers type `b₂` at `(M+S)•F` and pass `b₂.map (windowShiftEquiv hpi g).symm`. Same ring mathematically (the two shift equivalences are body-identical), different term. No landed lemma bridges them.

### What I verified by reading vs. inferred

Read from source: every file:line above, all signatures, all hypothesis lists, the `divUniversalSeedK` syntactic match, the two shift-equivalence bodies, the absence of consumers, the absence of an Aff→chart-typed certificate bridge. Machine-computed: the 693/624 import closure and the 44/6 HighWindow reachability; the enumeration of declarations by statement content; absence of `sorry` as a term. **Not yet verified:** that `DivRepChartClassUniv.lean` elaborates — it has no `.olean`, the build is in flight, and no error has appeared through 8842/8897 jobs. Its correctness is the single thing standing between this measurement and "the U2 epsilon half is landed."
