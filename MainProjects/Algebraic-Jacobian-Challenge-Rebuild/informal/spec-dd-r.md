# SPEC DD-R — the relative endgame: `Z(♦)`, the universal family, `divRep` (`AJCR.w4-rep.datum.dat-d.ddr`)

*2026-07-17, Fable design lane. BINDING parent: `informal/dat-d-worksheet.md` §3.2–§3.6
(P-fib + the DD-R sketch + the mechanism discipline), §4 (certificate + consumer rows),
§5 DD-R row, §6 risks 2/4; sibling specs consumed: `informal/spec-dd-1.md` (carrier
spellings, the (c3)/(c4) recorded seam), `informal/spec-dd-3.md` (§1 audit verdict, the
port spellings); probe verdict `informal/dd-f-probe-verdict.md` (GREEN). Inbox absorbed:
I-0182 (inverse-law adjudication), I-0186 (the overlap obstruction, item 2 answered
below), I-0179 (the MV wall), I-0159 (DD-3 trailing map), I-0175 (DD-4 state + the
base-field-transport seam), I-0170/I-0166 (frozen W5/DAT-J interfaces). Every landed
spelling below was verified by direct source read this pass (file:line); the GRQ tree
was read as route map only (Discipline rule 5). No Lean edited; no build run.*

This spec makes the **two adjudications DD-R's design was gated on** (§1, §2), pins the
deliverables in Lean-ready form (§3), and decomposes the work (§4). Both verdicts are
evidence-based rulings on the landed tree, not preferences; deviations require
re-derivation from the worksheet and a note in the commit message.

## 0. Standing pack and landed inputs (all verified this pass)

Base pack as spec-dd-1 §0: `{k} [Field k]`, `C : Over (Spec (.of k))`, the standing
curve instances (`Curve/BaseChangeInstances.lean:64` — note `IsProper C.hom` is in the
standing pack, so the relative curve is universally closed over every test: the
support-tube input of DDR-4 is licensed), `π : C.left ⟶ P1 k` `[IsAffineHom π]`; tests
`R : Type u` `[CommRing R] [Algebra k R]`; `relCurve C R` (`Cohomology/RelativeTwoCover.lean:115`),
pinned charts via `relCover` (`:128` = `AffineTwoCover.pullbackProd`). Landed bricks
DD-R consumes verbatim:

- **DD-F (P-fib), LANDED**: `existsUnique_effective_divisor_of_carve`
  (`RiemannRoch/PFib.lean:241`) — carve pair `(K_M, K')` of corank exactly `g` over any
  field ⟹ unique effective `D`, `deg D = g`, both windows exact;
  `baseDivisorAt_normalization` (`PFib.lean:127`), `h0_normalization_sub_single_lt`
  (`:71`). Supporting kit: `RiemannRoch/BaseDivisor.lean` (`coeffAt_baseDivisor:99`,
  `exists_coeffAt_eq_baseDivisorAt:143`, `le_divisorSections_sub_baseDivisor:160`,
  `exists_achiever_baseDivisor_sub:178`), `mulSpan_eq_divisorSections_of_basepointFree`
  (`RiemannRoch/BpfSpan.lean:70`).
- **DD-0 ledger**: `rank_embedding_of_genus` (`RiemannRoch/WindowLedger.lean:371`),
  `rank_normalization` (`:396`), `two_mul_genus_le_M_mul_windowδ`
  (`RiemannRoch/WindowLedgerF3.lean:102`), `h0_divisorSheaf_le_max_of_h0_one`
  (`RiemannRoch/SectionBound.lean:248`), `h0_le_deg_add_one_of_pos` (`:258`).
- **DD-1 carrier (stages a,b,d,f landed; c in flight; e unlanded)**:
  `FinCoverData` (`Picard/DivisorFamily.lean:158`), `DivisorAdaptation` (`:230`),
  `gluedSubmodule` (`:335`), `IsCertified` (`:358`), `CertifiedDivisorFamily` (`:384`),
  `DivEq` (`:71`), `DivFam` (`:404`); extraction `exists_divisorAdaptation`
  (`Picard/DivisorFamilyExtraction.lean:54`); field forward map `divFamDivisor`
  (`Picard/DivisorFamilyField.lean:126`, effectivity `:163`,
  `IsCertified.finrank_glued:152`); `divFamDivisor_injective`
  (`Picard/DivisorFamilyFieldEquiv.lean:178`), `divEq_of_presentationDivisor_eq` (`:90`),
  `divFamFieldEquivOfDegOfSurj` (`:200`); backward stages 1–2
  (`Picard/DivisorFamilyBackward.lean:88,:120`); separated degree kit
  (`Picard/DivisorFamilyFieldDegree.lean:122,:161,:191,:310,:372`). Tor pair:
  `Picard/FlatCokernel.lean` (`tensorKer_bijective_of_flat_coker:117`,
  `includeRight_mem_nonZeroDivisors_of_flat_coker:176`) and
  `Picard/FibrewiseRegular.lean` (`Module.Flat.mem_colon_smul_top_of_smul_mem_smul_top:106`,
  `Module.Flat.mem_nonZeroDivisors_of_forall_tmul_residueField:315`). **`DivFam.mapAlg`
  is NOT yet landed** (`Picard/DivisorFamilyPullback.lean` currently ends in the piece
  base-change plumbing; `:21` names `mapAlg` as its goal); the general-test vehicle
  `divFam`/`divFamAffineEquiv` (stage e) does not exist; DD-2 is `pending` on the roadmap.
- **DAT-A2 generators**: `exists_fibrewise_tmul_ne_zero_of_projective`
  (`Picard/LocalGenerators.lean:87`).
- **DD-3 (all mandatory stages + two of three trailing items LANDED)**: `grFunctorAff`
  (`Picard/GrassmannianFunctor.lean:53` = `Module.Grassmannian R (R ⊗[k] H) d`),
  `grFunctor` vehicle (`:61`), `grFunctorAffineEquiv` (`:128`); `entriesIdeal`
  (`Picard/EntriesIdeal.lean:166`), `baseChange_eq_zero_iff` (`:172`),
  `baseChange_entriesIdeal_quotient_eq_zero` (`:189`); `vanishingLocus`
  (`Picard/VanishingLocus.lean:43`, `vanishingLocusι:47`, closed-immersion instance `:53`);
  `grPair` (`Picard/GrassmannianPair.lean:36`, `grPairOver:57`, `grPairCover:62`,
  `grPairPatchIso:73`); tautological point `chartTautologicalPoint`
  (`Picard/GrassmannianTautological.lean:110`); **GL-cocycle compatibility LANDED**
  (`map_transitionMap_chartTautologicalPoint`,
  `Picard/GrassmannianTautologicalCocycle.lean:110`) — I-0159 trailing (i);
  **frame classification LANDED** (`matrixPoint_factors_chart_iff`,
  `Picard/GrassmannianChartFrame.lean:271`, with `matrixPoint`
  `Picard/GrassmannianMatrixPoint.lean:102`, `map_matrixPoint:199`,
  `exists_isUnit_mul_of_matrixPoint_eq` ChartFrame `:162`) — I-0159 trailing (iii).
  Trailing (ii), the glued `grPoint`, is NOT landed — adjudicated in §2.
- **DD-4 (Tasks 2–3 landed; 4–7 open, I-0175)**: `relThetaTwistSheaf`
  (`Cohomology/RelThetaTwist.lean:66`), `relThetaTwistH0BaseChange` (`:106`);
  `sectionMul` (`RiemannRoch/SectionMul.lean:73`), `relSectionMul` (`:95`), `carveArrow`
  (`:131`), `carveArrow_baseChange_eq_zero_iff` (`:141`). The **base-field-transport
  seam** (relCurve C k ≅ C.left + twist-package transport) is DD-4's named next
  unblocker and gates its Tasks 4–7.
- **Engine**: `rigidEngine_isOpen_vanishing` (`Cohomology/RigidEngine4Assembly.lean:441`),
  `relTwistRigidEngine` (`Cohomology/RigidEngine4Engine.lean:174`, Noetherian-licensed).
- **GRQ route map (read-only)**: `grPointOfRankQuotient`
  (`SubProjects/GR-Quot-Closure/.../GrassmannianQuot.lean:4984` — the *functor-value →
  scheme-map* gluing over chart loci), `grPointOfRankQuotient_rel` (`:4999`), the two
  inverse laws (`:5024–5588`), `represents` (`:5600`).

## 1. ADJUDICATION A — the dictionary consumption and the off-overlap question (I-0186 item 2 × I-0182)

**Question.** Does DD-R consume the one-sided field dictionary {backward map `hsurj` +
`divFamDivisor_injective`} with P-fib's divisor normalized off the chart overlap
`π⁻¹(Gm)`, or must the general-MV `hdeg` brick be funded?

**Verdict: NEITHER. (i) The off-overlap normalization is mathematically unavailable,
and (ii) DD-R consumes neither `hsurj` nor `hdeg` — the universal-family architecture
replaces the dictionary consumption entirely.** The I-0182 one-sided-dictionary route
is hereby SUPERSEDED for DD-R (it remains correct as a statement about the field
dictionary; its consumer is DAT-B, see the boundary flag below).

**(i) Evidence that off-overlap support cannot be arranged.** P-fib's `D` is the
modulus itself, not an auxiliary choice: in `existsUnique_effective_divisor_of_carve`
(`PFib.lean:241`) the divisor is *defined* as `D := Scheme.baseDivisor K KM (M•F)`
(`PFib.lean:282`) — the base divisor of the *given* window — and the uniqueness clause
pins it pointwise by `baseDivisorAt_normalization` (`:127`): the F1 "normalization"
normalizes the *window relative to `D`* (no residual base point), never `D`'s support.
As the carve point varies over `Z(♦)`, `D` ranges over **every** effective degree-`g`
divisor — the ⟸ direction (DD-4 §2.3) embeds `g·x` for every closed `x`, including
`x ∈ π⁻¹(Gm)` = the nonempty chart overlap (`relCover`/`pullbackProd`,
`RelativeTwoCover.lean:128`; nonemptiness per I-0186). There is no translation (the
curve has no group structure) and no rescale (unit rescaling of `K_M` fixes `bd`).
I-0186 item 2 is answered: **NO — P-fib's divisor cannot be arranged off-overlap.**

**(ii) Why DD-R nevertheless needs no dictionary.** DD-R's backward direction is
*pullback of a universal certified family* constructed over `Z(♦)`'s charts by local
generators from the universal carve pair (worksheet §3.4.1) — the equations are window
*achievers*, never `pointEquations` products; `divFamOfDivisor` appears nowhere. The
only degree identity DD-R needs is fibrewise, **for carve-certified families only**,
and it closes without Mayer–Vietoris by the **certified-degree pinch** (DDR-2 below):
at a field point, `K_M = H⁰(MF − D_F)` (the sections dictionary, DD-4 Task 5's field
content) with corank `g` in `H_M`; the section bound
(`h0_divisorSheaf_le_max_of_h0_one`, SectionBound:248) forces `deg D_F ≤ 2g` (the F1
move, exactly as `PFib.lean:294–303`); then the exact normalization window
(`rank_normalization`, WindowLedger:396, licensed at `deg ≤ 2g` by
`two_mul_genus_le_M_mul_windowδ`, WindowLedgerF3:102) gives
`r_M − g = h⁰(MF − D_F) = Mδ − deg D_F + 1 − g`, i.e. `deg D_F = g`. No adaptation
independence, no inclusion–exclusion, no `hdeg`. I-0179's wall is not touched.

**The EXACT hypotheses DD-R's bricks carry**: `adaptation.IsCertified g` plus carve
membership (the pair `ε(F)` satisfies `(♦)`, corank exactly `g`) — never a support
condition `supp D ∩ π⁻¹(Gm) = ∅`, never `hdeg`, never `hsurj`. Any DD-R prover writing
a support-separation hypothesis (`hsep`, `subsingleton_ovlColength_of_sep`) has left
the route: those belong to the *separated field kit* (DivisorFamilyFieldDegree), which
DD-R does not consume.

**Boundary flag (binding on DAT-B's spec, not resolved here).** The field dictionary
`divFamFieldEquiv` (and hence `hsurj` for arbitrary — including overlap-supported —
divisors) is DAT-B's consumption surface (worksheet §4.2 row), and I-0186's obstruction
lands there. Designed relief, recorded for DAT-B: DD-R's field-level instance supplies
a *window-route* `divFamOfDivisor` for ALL effective degree-`g` `D` — set
`K_M := H⁰(MF − D)`, `K' := H⁰((M+s)F − D)` (windows exact at `deg D = g`), run DDR-3/
DDR-4 at the field — because the certificate then comes from the second window, not
from colength sums, no support separation is needed. If that instance lands, I-0186's
stages 3–5 (and the off-overlap restriction) become moot for DAT-B; `hdeg` remains the
sole XL and remains UNFUNDED and UNCONSUMED by the campaign.

**Staged fallback.** If the relative bricks (DDR-4 or DDR-8) wall after two honest
sessions: the fallback is the worksheet §3.6(d) matrix-chart AMBER (DD-Φ), per the
DD-F probe-gate pattern — orchestrator informed. Funding general MV is explicitly NOT
the fallback: `hdeg` repairs the field dictionary, not the relative certificate or the
relative mono, so it cannot unblock DD-R. RED (Sym^g) stays orchestrator-owned.

## 2. ADJUDICATION B — the `grPoint` spelling (I-0159 trailing (ii))

**Question.** Does DD-R need the full glued `grPoint : (T ⟶ grOver) → grFunctor value`
(basic-open gluing of Grassmannian points), or does chart-local suffice?

**Verdict: CHART-LOCAL SUFFICES. The glued `grPoint` is NOT consumed by DD-R and stays
deferred (3c-iii-grade slack work).** Trace of the actual consumption:

- **Family → hom (the classify direction)** is the `grPointOfRankQuotient` pattern
  (GRQ `:4984`): over an affine test, frame the finite projective quotients of the pair
  on a basic-open cover, factor each framed piece through a chart by
  `matrixPoint_factors_chart_iff` (ChartFrame:271, landed), check overlap agreement by
  `exists_isUnit_mul_of_matrixPoint_eq` (`:162`) + the landed GL-cocycle compatibility
  (TautologicalCocycle:110), and glue MORPHISMS (mathlib `Cover.glueMorphisms`, the GRQ
  `openCoverOfIsOpenCover` pattern). Direction of data flow: functor value → hom. The
  glued `grPoint` is the OPPOSITE direction and is never invoked.
- **Hom → family (the recover direction)** pulls back the *universal certified family*
  (divisor side) — not the tautological Grassmannian point. Its gluing weight
  (assembling a `DivFam` over an affine from chart-straddling basic-open pieces, and
  the functoriality of the vehicle in `T`) sits on the DIVISOR side: DD-1 stage (c)
  `mapAlg` + stage (e) vehicle + DD-2's Zariski-sheaf gluing (the `PicEtMap` precedent,
  `Picard/PicEtAffMap.lean:275`). That work is needed for `divFunctor` to *be* a functor
  — i.e. for the `RepresentableBy` statement to even typecheck — regardless of any
  Gr-side gluing. Funding glued `grPoint` would not remove it; it would duplicate it.
- **The inverse laws** evaluate chart-locally. Hom-side law: equality of morphisms into
  `grPair`/`Z(♦)` is Zariski-local, and on a common chart piece a morphism into
  `Spec R^I` is an algebra map out of an `MvPolynomial` ring, determined by the images
  of the matrix entries = the pulled-back frame data (`MvPolynomial.algHom_ext` through
  `matrixPoint`; DDR-7). Family-side law: tested after ε on `grFunctorAff` values over
  affine opens — the vehicle's own components (`grFunctor` compat field,
  GrassmannianFunctor:61) — never through a glued point.

**Residual DD-3 work under this verdict: ZERO mandatory.** I-0159's trailing (i) and
(iii) are already landed (`GrassmannianTautologicalCocycle.lean`,
`GrassmannianMatrixPoint.lean` + `GrassmannianChartFrame.lean`); trailing (ii) is
deferred indefinitely. The two small Gr-side plumbing lemmas DD-R still needs are OWNED
BY DD-R (DDR-6/DDR-7 below, S–M): the scheme-level chart-locus basic-open cover of an
affine test mapping to `grPair`, and the hom-ext lemma. For the record, the reversed
verdict was sized: glued `grPoint` = the sheaf property of `Module.Grassmannian` points
over basic-open covers, an honest M→L brick (GRQ's model is the `:2545–2680` locus lane
plus the L1–L3 module transport) — funded only if a future consumer (not in the §4.2
rows) demands functor-valued points of `grOver` at non-affine tests.

## 3. The pinned deliverables (Lean-ready statements)

Campaign instantiation: `d := g`, `r₁ := r_M`, `r₂ := r_{M+s}`, coordinate ambients
`H := Fin r → k` on the scheme side, abstract `H_A` entering via `Module.finBasis` at
the DD-4 boundary with the ONE recorded `TensorProduct.comm` orientation seam
(spec-dd-3 §0). All files `set_option autoImplicit false`, explicit binders, local
instances header `attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
Over.sectionsAlgebra`, ≤ 500 lines each.

1. **`Picard/DivCarveLocus.lean` (DDR-1).** The carve arrow over each `grPair` chart
   ring `R_{I,J} := R^I ⊗[k] R^J` (through `grPairPatchIso`, GrassmannianPair:73):
   `divCarveArrow I J : (H_s ⊗ K_taut^I) →ₗ[R_{I,J}] (H₂ ⊗ R_{I,J}) ⧸ K_taut^J` built
   from `sectionMul`/`carveArrow` (SectionMul:73,:131) and the tautological points;
   `DivScheme g := ` the glue of `vanishingLocus (divCarveArrow I J)`
   (VanishingLocus:43) over the pair atlas, with transition isos induced by
   entries-ideal transport along the landed GL-cocycle
   (`map_transitionMap_chartTautologicalPoint` + `baseChange_eq_zero_iff`);
   `divSchemeι : DivScheme g ⟶ grPair …` with `IsClosedImmersion divSchemeι`
   (chart-wise `isClosedImmersion_vanishingLocusι` VanishingLocus:53, glued);
   `divSchemeOver : Over (Spec (.of k))`. Keystones: the chart-wise universal property
   — a `k`-algebra map `R_{I,J} → S` kills `entriesIdeal (divCarveArrow I J)` iff the
   pulled-back pair satisfies `(♦)` over `S` (`carveArrow_baseChange_eq_zero_iff`
   SectionMul:141) iff it factors through the locus. Fallback spelling if the glue
   fights: `isClosedImmersion_equalizer_ι_left` (worksheet §3.1).
2. **`RiemannRoch/CarveDegree.lean` (DDR-2).** The certified-degree pinch (§1(ii)):
   `theorem deg_divFamDivisor_of_carve : … IsCertified g → (carve holds for ε-pair) →
   CurveDivisor.deg K (divFamDivisor F) = g`, field-level, via SectionBound +
   WindowLedger names only (discipline: no numeric windows). Corollary
   `baseDivisor_eq_divFamDivisor_of_carve` (feeds DDR-8 through
   `baseDivisorAt_normalization`).
3. **`Picard/DivSchemeFamily.lean` (DDR-3).** The relative local-generator
   construction, per `Z(♦)`-chart ring `R_Z` (Noetherian: finite type over `k`): from
   the universal pair with fibrewise P-fib data, a `LocalEquations (relCurve C R_Z)`
   with a `DivisorAdaptation` refining it — achiever choice fibrewise
   (`exists_coeffAt_eq_baseDivisorAt` BaseDivisor:143 at each `κ(p)` through P-fib),
   Nakayama neighbourhood (`exists_fibrewise_tmul_ne_zero_of_projective`
   LocalGenerators:87), germ regularity
   (`Module.Flat.mem_nonZeroDivisors_of_forall_tmul_residueField` FibrewiseRegular:315),
   basic-open refinement (`exists_divisorAdaptation` Extraction:54 pattern). This is
   Kleiman `lm:ctn` (ii)⟹(iii)⟹(i) exactly (worksheet §3.4.1).
4. **`Picard/DivSchemeCertificate.lean` (DDR-4 — THE seam brick).** The certificate for
   free: `(universalAdaptation).IsCertified g`, mechanism = fibrewise P-fib h¹-data +
   the rigid engine (`relTwistRigidEngine` Engine:174) on the constructed family's
   twisted glued sheaf, identifying `gluedSubmodule ≅ (H₂ ⊗ R_Z) ⧸ K'_taut` (the
   ambient projective quotient) — (c2)+finiteness from the ambient; per-piece (c1) by
   the slicing criterion (fibrewise-regular + flat base ⟹ flat quotient; FlatCokernel/
   FibrewiseRegular homes) + the support tube (family support is closed over the base:
   `IsProper C.hom` standing + closed-in-proper, giving piece-isolation Zariski-locally
   on `Spec R_Z`); **(c3)/(c4) discharged here from the ambient splitting** — the
   recorded DD-1 §1c seam, spelled as: the certified equalizer is a kernel of a map of
   finite projectives split by the engine's on-the-nose base change. NOTE the
   anti-circularity order: fibrewise inputs come from P-fib on the CARVE PAIR (landed,
   certificate-free); the engine upgrades; the certificate is the OUTPUT.
5. **`Picard/DivSchemeEps.lean` (DDR-5).** The projection identity
   `ε (universalDivFam) = tautological pair`: containment `K_taut ⊆ H⁰(Θ^M − d_univ)`
   by fibrewise-divisibility → relative divisibility
   (`Module.Flat.mem_colon_smul_top_of_smul_mem_smul_top` FibrewiseRegular:106);
   equality by the rank-`g`-quotient surjection argument (a surjection of finite
   projectives of equal `rankAtStalk` is an iso — kernel projective of rank 0).
6. **`Picard/DivSchemeClassify.lean` (DDR-6 + DDR-7).** `divClassifyAff :
   (certified family over S with carve) → (Spec S ⟶ DivScheme g)` — frame loci,
   `matrixPoint_factors_chart_iff`, morphism gluing (GRQ `:4984` pattern), factoring
   through `divSchemeι` by DDR-1's universal property; and `divScheme_hom_ext` /
   `grPair_hom_ext_of_frame` — two morphisms from an affine agreeing on pulled-back
   frame data agree (`MvPolynomial.algHom_ext` + `exists_isUnit_mul_of_matrixPoint_eq`
   + hom-equality-is-local + `Mono divSchemeι` from the closed immersion).
7. **`Picard/DivSchemeMono.lean` (DDR-8).** The relative mono / Law-1 core:
   `divFam_divEq_of_eps_eq` — two certified families over `R` (Noetherian) with equal
   ε-pairs are `DivEq`. Route: fibrewise both present `bd(K_M ⊗ κ(p))` (DDR-2 +
   `baseDivisorAt_normalization` PFib:127 + `coeffAt_eq_toAdd_ordZ_eqn`
   FieldDegree:161), so equation ratios are fibrewise units; colon-Tor divisibility
   both ways + residue-nonvanishing ⟹ relative unit ⟹ `DivEq`. (This subsumes DD-4
   Task 6's mono at the relative level; coordinate with the DD-4 lane — one home,
   whichever lands first, per the FlatCokernel/FibrewiseRegular precedent.)
8. **`Picard/DivRep.lean` (DDR-9).** Assembly:
   `divRep : (divFunctor g).RepresentableBy (divSchemeOver g)` — homEquiv forward =
   pullback of the universal family (`DivFam.mapAlg` + vehicle), backward =
   `ε` + `divClassifyAff` glued over `T.left.affineOpens`; Law 1 = ε-naturality (DD-4
   Task 7) + DDR-5 + DDR-8; Law 2 = DDR-7 chart-locally; naturality from `mapAlg`
   comp laws. Computation lemmas `divRep_homEquiv_apply`/`_symm_apply` at affine tests
   through `grFunctorAffineEquiv`/`divFamAffineEquiv`.

## 4. Sub-bricks — sizes, gating, order, delegability

Sizes per recon convention (S ≤ ~150, M ~150–350, L ~350–500, XL = own campaign).

| brick | size | gated by | delegable |
|---|---|---|---|
| DDR-1 carve locus + `DivScheme` + `ι` | L | DD-3 (landed) only — **launchable NOW** | Opus from this spec |
| DDR-7 hom-ext lemmas (Gr side) | S→M | DD-3 (landed) only — **launchable NOW** | Opus |
| DDR-2 certified-degree pinch | S→M | DD-4 Task 5 field content (sections dictionary + corank) | Opus |
| DDR-3 relative local generators | L | P-fib (landed) + the **DD-4 base-field-transport seam** (I-0175: window constants at `κ(p)`; `RiemannRoch/DegreeBaseFieldInvariance.lean` is the transport kit) | Opus from a tight route note |
| DDR-4 certificate transport | **L→XL, the heart** | DDR-3 + engine (landed) + DD-4 Task 4 mechanism | **Fable holds the pen** (the seam); sub-lemmas delegable |
| DDR-5 ε-projection identity | M | DDR-3/4 + DD-4 ε (Task 5) | Opus |
| DDR-6 classify + factor | M→L | DD-4 ε + DDR-1 + DDR-7 | Opus |
| DDR-8 relative mono | L | DDR-2 + Tor pair (landed) + `baseDivisorAt_normalization` (landed) | Opus from Fable route |
| DDR-9 `divRep` assembly | M→L | ALL above + **DD-1(c) `mapAlg`** (in flight) + DD-1(e) vehicle + **DD-2** (pending) | Opus |

**Order.** `{DDR-1 ∥ DDR-7} → DDR-3 → DDR-4 → {DDR-2, DDR-5, DDR-6} → DDR-8 → DDR-9`,
with DDR-2 startable any time after DD-4's field-level Task 5. **Gating summary**: the
ε-mono/mapAlg landings gate exactly {DDR-5, DDR-6, DDR-9(mapAlg)}; nothing else waits
on DD-4. DD-2 gates only DDR-9's general-test statement — the affine-level homEquiv
(the mathematical content) is deliverable without it, and the spec mandates landing it
first as `divRepAff` if DD-2 trails. **Probe rule** (worksheet §6.4 pattern): DDR-4
begins with a half-session elaboration probe of the engine-bridge statement before any
structure is frozen; if DDR-4 walls after two honest sessions → §1's staged fallback.

## 5. Openness-mechanism audit (worksheet §3.5 discipline)

DD-R introduces **zero openness mechanisms**. The carve is the single CLOSED condition
`(♦)` (entries ideal, DDR-1); frame/chart loci used in DDR-3/6 are basic opens of test
rings — chart PLUMBING under the §3.5 ruling (on a par with DAT-1's trivializing
covers), defining no moduli-theoretic subfunctor. No semicontinuity locus, no Fitting
ideal, no rank-jump open appears anywhere in §3. The first genuine open remains
DAT-C's `V`, cut by `rigidEngine_isOpen_vanishing` (RigidEngine4Assembly:441) on the
universal family this spec delivers — the one licensed mechanism.

## 6. Consumer rows (binding; frozen-interface pointers)

| DD-R deliverable | consumer |
|---|---|
| `DivScheme g` + universal certified family + `divRep` | **DAT-C**: chart scheme + the engine-open `V` on its affine atlas; `LocalEquations.picClass` of the universal family → `picDegLayerFunctor` (ThetaShift:170) composition |
| `divRep.homEquiv` naturality + `mapAlg` | **DAT-C**: 01JJ open-fibre-product certificates |
| `divSchemeι` closed immersion + `grPairCover` finiteness (GrassmannianPair:62,:68) | **DD-Q**: the `divQProj` bundle (qc free, lft, separated via DD-3's `isSeparated_grStructMap`); **DAT-glue** lft rows; **Wave-5** qc inputs toward `AbelSourceData.isProper` (I-0170 — DD-R feeds via DD-Q, no direct row) |
| `divRep` at field tests + DDR-2 + the §1 window-route note | **DAT-B**: coverage/injectivity bookkeeping; the `hsurj` boundary flag of §1 is BINDING on DAT-B's spec (I-0186 obstruction lives there, with the designed relief recorded) |
| the §1/§2 verdicts | **orchestrator**: echo on the roadmap; `hdeg` stays unfunded; glued `grPoint` stays deferred; DAT-J consumes nothing of DD-R directly (`JacobianData`, I-0166, is downstream of DAT-C/DAT-glue) |

## 7. Honest risks

1. **⚠⚠ DDR-4 (certificate transport) is the design's riskiest brick** — the honest
   flattening residue (worksheet §6.2), now with a designed anti-circular route
   (fibrewise P-fib → engine → certificate) but an unprobed seam: the bridge between
   DD-1's `gluedSubmodule` equalizer and the engine's Čech `H⁰` of the constructed
   glued sheaf. Mitigations: the probe rule (§4); the support-tube input is licensed
   (`IsProper C.hom` standing); the fallback is designed (§1).
2. **⚠ DD-4's base-field-transport seam (I-0175) gates ε and the fibrewise window
   constants** (DDR-3's P-fib-at-`κ(p)` instantiation). Mitigation: DDR-3 states its
   fibrewise hypotheses through named transport lemmas so only one boundary moves if
   DD-4's spelling shifts; `DegreeBaseFieldInvariance` is the landed kit.
3. **⚠ DDR-1's glue weight** (closed subschemes over the pair atlas). Mitigation:
   mirrors the landed `GrassmannianGlue` architecture; the equalizer-gift fallback
   spelling is sanctioned (worksheet §3.1); heartbeat raises legitimate only where GRQ
   raised (glue/patch computations).
4. **DD-1(c)/(e) + DD-2 are unlanded** and gate only DDR-9's final form. Mitigation:
   `divRepAff` first (§4); the vehicle statement is frozen in spec-dd-1 §1e; DD-2's
   interface is pinned by the worksheet (DAT-2/PicEtMap pattern) — if DD-2 stalls,
   negotiate ownership before building gluing inside DDR-9.
5. **Tor arguments over nonreduced Noetherian chart rings** (DDR-3/5/8): fibrewise
   containment does NOT imply relative containment over nonreduced bases (checked this
   pass: `R = k[ε]` kills the naive direction) — every relative containment in §3 is
   routed through divisibility/colon-Tor or through projective-quotient rank
   arithmetic, never through "vanishes in all fibres ⟹ zero". Provers must not
   "simplify" to the false lemma.
6. **Verified-vs-assumed mathlib**: `Cover.glueMorphisms`/`openCoverOfIsOpenCover`
   pattern (GRQ-proven shape), `MvPolynomial.algHom_ext` (spec-dd-3 §6 verified),
   closed-immersion mono instance; assumed S-size: hom-equality-is-local plumbing.

## Discipline

Worksheet §Discipline verbatim + spec-dd-1 §5 (local-instance header, lake mkdir-mutex,
private-index+CAS commits with `show --stat HEAD`, keystone `lean_verify` with axioms
exactly `[propext, Classical.choice, Quot.sound]`, files ≤ 500 lines, root-import edits
minimal and re-read first). DD-R additions, binding: (1) every window fact through
WindowLedger/WindowLedgerF3 names; (2) no support-separation hypotheses (§1); (3) no
rank/Fitting/pencil spellings of the carve (worksheet Discipline (3)); (4) the GRQ tree
stays read-only route map; (5) DDR-4 probe-first (§4).

*End of spec. The §1 and §2 verdicts are the deliverable of record for the two DD-R
gate adjudications; the DAT-B boundary flag and the `grPoint` deferral are to be echoed
on the roadmap by the orchestrator.*
