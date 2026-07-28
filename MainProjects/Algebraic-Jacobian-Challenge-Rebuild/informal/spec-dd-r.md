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

---

## ADDENDUM 1 (2026-07-17, late evening) — DDR-9 restated against `DivFamZar` (BINDING; consumes I-0213 / spec-dd-2 Addendum 2)

The DD-2 adjudication I-0213 (spec-dd-2 Addendum 2, commit c9aaf2c94) proves the
globally-certified `DivFam` is not a Zariski sheaf (diagonal-over-`Γ(C∖pt)`
counterexample; Z-clopen principle) — the §3 item 8 statement
`divRep : (divFunctor g).RepresentableBy (DivScheme g)` as pinned against the
globally-certified functor is **unprovable** and is hereby RESTATED:

1. **The functor.** `divRep` is stated against DD-2's S6 functor over
   **`DivFamZar g`** values (`IsLocallyCertified` carrier, DivEq quotient — DD-2's
   pinned vocabulary `IsLocallyCertified` / `DivFamZar` / `DivFam.toZar` /
   `mapAlgZar` / `DivFamZar.exists_glue_of_away_compat` / `eq_of_away_eq`,
   consumed VERBATIM; no parallel coinage, I-0190/I-0196 discipline). The S6
   spelling freeze remains a two-lane coordination point (spec-dd-2 §6): the DD-R
   lane must sign off before S6 freezes.
2. **What is UNAFFECTED (adjudicated in I-0213 itself):** DDR-1 through DDR-8.
   The universal family of DDR-3/4 is honestly certified over each `Z(♦)`-chart
   ring, hence locally certified a fortiori (`DivFam.toZar` after `mapAlg`); all
   field-level material (DDR-2 pinch, DDR-8's fibrewise inputs, DD-4 ε/mono)
   operates where `DivFamZar K ≅ DivFam K` (trivial cover). No landed DD-R
   statement changes.
3. **The homEquiv directions, restated shape.** Forward (T-point → family):
   pullback of the universal certified family along the chart atlas, exported to
   `DivFamZar` via `mapAlgZar`-compatible `toZar` — the chart-atlas
   ill-definedness noted in I-0213 is cured because local certifiability only
   requires the atlas-preimage base cover. Backward (family → T-point):
   classify each local certified part by DDR-6, glue the classifying morphisms
   over the base cover by scheme-morphism Zariski descent, uniqueness by DDR-7
   `divScheme_hom_ext` + DD-2 `eq_of_away_eq`; the two laws then check locally
   (per certified part), where the DDR-8 mono and the §3 item 8 routes apply
   unchanged.
4. **Gating update.** DDR-9 now additionally gates on DD-2's **S5b + S6**
   (DivFamZar + the Zar vehicle) landing with frozen names. The `divRepAff`
   staging rule (§4) stands: if S6 trails, land the affine-level RepresentableBy
   against `DivFamZar` on affine tests first.

*Filed by the DD-R orchestrator lane; roadmap comment + I-0213 acknowledgement
posted in the same pass.*

---

## ADDENDUM 2 (2026-07-25, run 0048) — the certificate lane's satisfiability verdict (BINDING)

ADDENDUM 1 restated DDR-9 against `DivFamZar` and asserted, as item 2, that "the universal
family of DDR-3/4 is honestly certified over each `Z(♦)`-chart ring". That assertion has never
been proved, and this addendum records what is now known about it — three theorems, all
kernel-checked warning-free, all in the default build.

### 1. The per-piece clause is a chart statement

`Picard/DivSchemeCertZarChartTrace.lean` (commit `49866bdd1`). A `FinCoverData` carries a
partition of unity on **each** pinned chart, so the chart-`b` pieces cover all of `V_b` and

  `supportLocus ∩ V_b = ⋃_j (supportLocus ∩ pieces_b j)`.

A finite union of closed sets is closed, hence the assembler's `hnoLeak`
(`isCertified_of_noLeak_kernel_spanning`) implies that **both chart traces are closed in the
relative curve** — a statement in which neither the adaptation nor its pieces appear
(`isClosed_supportLocus_inter_chart_of_forall_noLeak`). Contrapositive
`not_forall_noLeak_of_not_isClosed_chart₀`.

Two consequences bind future work. Refining the cover cannot help: the union of the traces is
the fixed set `supportLocus ∩ V_b`, so a finer cover only imposes more closed-trace
constraints on the same union. And shrinking the base does not move the condition; it restates
it over the smaller base.

### 2. The shape that works: swallow or miss

`Picard/DivSchemeCertZarSwallow.lean` (commit `206967379`). If every piece either contains the
whole support or misses it, `hnoLeak` and clause (c1)-finite follow at every piece with no
fibre, no tube and no packet idempotent. A missing piece has a **unit** equation, so its
colength module vanishes and needs no fibrewise regularity input either.

### 3. The verdict

`Picard/DivSchemeCertZarConn.lean` (commit `40f357de8`). Leak-freeness makes a piece trace
closed and the piece is open, so the trace is **clopen in the support**; a preconnected support
therefore forces it to be empty or total. Hence, for a connected divisor, swallow-or-miss is
not an extra hypothesis — it is what leak-freeness already says — and with `relCover_sup`:

> `supportLocus_subset_chart_of_isPreconnected` : a connected divisor whose adaptation is
> leak-free at every piece satisfies `supportLocus ⊆ V₀` **or** `supportLocus ⊆ V₁`.

So `IsCertified`, whose clause (c1) forces leak-freeness, is satisfiable for a connected
divisor **only** if that divisor avoids `π⁻¹(0)` or avoids `π⁻¹(∞)`. Base localization cannot
repair this, because it does not disconnect the divisor: `Spec (R[x]/(x²−t))` over `R = k[t]`
is connected over every basic open of `Spec R`. The I-0209 clopen-packet programme is therefore
available exactly when the divisor is already chart-confined.

### 4. What this obliges the DD-R design to decide

Exactly one question, and it is a design question, not a lemma hunt:

**Does the `Z(♦)` chart confine its divisors to a single pinned chart of `π`?**

* **If yes** — then ADDENDUM 1 item 2 is correct and the remaining certificate work is
  bookkeeping: build the two-piece-per-chart adaptation (a swallowing piece plus its comaximal
  complement, via `DivisorAdaptation.ofAnchors`), and the Čech complex then has at most one
  nontrivial piece per chart, so clauses (c2)/(c3)/(c4) — hence `hinj`, which is *provably*
  clause (c4) — should be free rather than proved. That is roadmap leaf
  `…certificate.cert-collapse`, and it is the single highest-value experiment in the lane: if
  it lands, `away-kerspan` is retired, not solved.
* **If no** — then the atlas must add the avoidance as a carve (it is an open condition, so a
  carve is legitimate), **or** `IsCertified`/`DivFamZar` must be redesigned, because a functor
  that cannot see chart-crossing divisors is not the divisor functor and `divRep` against it
  would represent the wrong thing.

The theta side is the tractable half of the yes-case: `K ⊆ H⁰(Θᵃ)` with `Θ = π⁻¹(∞)`, and a
generator of exact pole order `a` has no zero on `Θ`, so `supportLocus ∩ π⁻¹(∞) = ∅` should
follow from the seed's own exactness data.

Roadmap leaves: `…certificate.chart-avoid` (the decision), `…certificate.swallow-adapt` (the
construction), `…certificate.cert-collapse` (the collapse), `…certificate.cert-assemble` (the
composition, plus four missing Away-transport bricks). Memory: I-0327.

---

## ADDENDUM 3 (2026-07-25, run 0048 round 1) — chart-avoid is ANSWERED: NO. The repair, and what it costs (BINDING)

ADDENDUM 2 §4 left exactly one question and called it a design decision an agent should not take
alone (inbox I-0333). It is now answered, negatively, on three independent grounds, and the
consequence is a determinate repair with a costed work breakdown. This addendum supersedes
ADDENDUM 2 §4 and ADDENDUM 1 item 2.

### 1. The answer: the `Z(♦)` chart does NOT confine its divisors

**(a) The seed carries no exactness datum, and cannot be given one honestly.**
`ThetaGeneratorSeed` (`Picard/DivSchemeFamily.lean:74`) has exactly five fields — `side`, `h`,
`mem_basicOpen`, `sec`, `sec_mem` — and `IsGenerator` (:129) exactly two — `dvd`,
`fibre_regular`. None mentions Θ, pole order or a chart. Every universal instantiation of
`side` picks an ARBITRARY chart containing the point (`seedUniv`,
`Picard/DivSchemeSeedUnivGen.lean:283`, `side := (exists_seedPoint …).choose`; `seedUniv'`,
`Picard/DivSchemeRedesignSeedUniv.lean:180`; `pointwiseSide`,
`Picard/DivSchemeSeedUnivPointwise.lean:88`), so a point of `π⁻¹(∞)` is legal everywhere.

**(b) ADDENDUM 2 §4's "tractable half" is not a half, and its argument is circular.**
Θ = `fiberWeilDivisor π` is supported on `V₀ ∖ V₁` (`RiemannRoch/FLVFiberToolkit.lean:292`,
:311, :254), i.e. set-theoretically **Θ = V₁ᶜ**. So "`supportLocus ∩ π⁻¹(∞) = ∅`" IS the
disjunct `supportLocus ⊆ V₁` of the verdict — a whole side of the conclusion, not a tractable
half of it. And the route is circular: `IsGenerator.dvd` forces `eqn z` to generate `K·𝒪` on
its piece, so `supportLocus` is the base locus of `K`, and "a generator of exact pole order `a`
exists at `y ∈ Θ`" holds iff the base locus misses `y`. Premise = conclusion.

**(c) There is an explicit counterexample, and no Zariski shrink of the base evades it.**
Over `k[t]`, on `C = P¹`, `π = id`, take the degree-2 form

  `F = t·X² + X·Y + t·Y²`,   `D = Z(F) ⊆ P¹ × A¹_t`.

The coefficients `(t, 1, t)` generate the unit ideal, so `D` is a relative effective Cartier
divisor, finite flat of degree 2. `F(1,0) = F(0,1) = t`, so the fibre `D₀ = Z(XY) = {0, ∞}`
meets BOTH vertical fibres. In the chart `Y = 1`, `F = t(x²+1) + x` is degree 1 in `t` with
coprime coefficients, hence irreducible in `k[x,t]`; the only point over `Y = 0` is `(∞, 0)`,
which lies in the closure (`t = -x/(x²+1) → 0` as `x → ∞`). So `D` is IRREDUCIBLE. `D → A¹_t`
is finite surjective, so over every nonempty open `U ⊆ Spec k[t]`, `D_U` is a nonempty open of
an irreducible space, hence irreducible, hence preconnected. Every Zariski cover of `Spec k[t]`
has a member containing `t = 0`, and over that member `D` is connected and meets both vertical
fibres. By `supportLocus_subset_chart_of_isCertified` (`Picard/DivSchemeCertZarC1.lean:131`)
it therefore has no certified adaptation there, so **`D` is not `IsLocallyCertified`**.

Correction to the record: ADDENDUM 2 §3 and the `chart-avoid` roadmap leaf justify "base
localization cannot help" with `Spec R[x]/(x²−t)` over `R = k[t]`. That divisor's points are
`x = ±√t`, always finite, so it never meets `π⁻¹(∞)` and is chart-confined — it is not a
witness. The conclusion stands; the witness above is the correct one.

**(d) The obstruction survives the quotient the functor is built from.** New this round,
kernel-checked: `Scheme.LocalEquations.DivEq.supportLocus_eq`
(`Picard/DivSchemeCertZarConfine.lean`) — the support locus is a `DivEq` invariant, because the
unit locus is a germ-invertibility locus and `DivEq` only rescales germs by units. Hence
`not_isCertified_of_divEq_of_isPreconnected_of_witnesses`: **no representative** of the class
admits a certified adaptation. `DivFamZar` is a `DivEq` quotient, so this closes the last
escape hatch. `DivFamZar` is not the relative-divisor functor, and `divRep` stated against it
represents the wrong object.

### 2. The binding constraint is `FinCoverData`, not `π`, not the cover, not `L`, not the base

`FinCoverData` (`Picard/DivisorFamily.lean:160-176`) hardwires `h₀ : Fin m₀ → Γ(V₀)`,
`h₁ : Fin m₁ → Γ(V₁)` with a partition of unity on EACH pinned chart; `pieces` (:186) are
therefore basic opens of `V₀`/`V₁`, and they cover the whole curve. Clause (c1)-finiteness IS
leak-freeness (`supportLeak_eq_empty_iff_finite_colength`, `DivSchemeCertZarC1.lean:123`), so
every piece trace is clopen in the support; a connected support then lies in one piece, hence
in one pinned chart. Consequently:

* refining the cover cannot help (more pieces, same union of traces);
* shrinking the base cannot help (it re-states the condition, and does not disconnect);
* a cleverer submodule `L` cannot help (the `L`-free form is already the general one);
* re-spelling the equations cannot help (§1(d)).

Any repair must introduce an adaptation piece that is **not contained in a single pinned
chart**. That is the whole content of the decision.

### 3. Two admissible repairs, and one that does not work

**R1 — vary the P¹ coordinate.** Every declaration in the chain is generic in `π`, constrained
only by `[IsFinite π]` / `[IsAffineHom π]` (+ `[IsDominant π]`) and
`hπ : π ≫ P1.structureMap k = C.left ↘ Spec (.of k)` (`DivSchemeSeedUnivFields.lean:58`). So
replacing `π` by `γ ∘ π` for `γ ∈ Aut(P¹_k)` costs NOTHING in the landed material: every lemma
applies verbatim to the twisted map, and the twisted charts `π⁻¹(P¹ ∖ {c})` are affine because
`π` is affine. `IsLocallyCertified` (and the atlas) then quantify over `γ` as well as over the
base cover. COST, and it is the reason this is not free: **`Aut(P¹)` does not exist in this
project.** `P1 k` is a `Proj` (`Curve/P1.lean:135`) with `chartOpen : Fin 2 → Opens` (:200) and
no `PGL₂` action anywhere. R1 owes the `GL₂(k)`-action on `Proj (k[X₀,X₁])` and transitivity on
`P¹(k)`.

**R2 — generalize `FinCoverData` to σ-charts.** For `σ ∈ H⁰(bΘ)` let `U_σ` be its
non-vanishing locus; `V₀` and `V₁` are the cases `σ = t₀ᵇ`, `t₁ᵇ`. A divisor avoiding `Z(σ)` is
swallowed by the single piece `U_σ`. This stays inside the existing `relThetaSections`
vocabulary, but owes affineness of `U_σ` (complement of an ample divisor) and a wide refactor
of `FinCoverData`/`DivisorAdaptation`/`chartProd`.

**REJECTED — delete clause (c1) from `IsCertified`.** Tempting, because `Module.Flat R
(colength j)` is free from fibrewise regularity alone
(`flat_colength_of_forall_tmul_residueField`, `SupportTube.lean:313` — no finiteness, no
no-leak), while `Module.Finite` is exactly the culprit. But the (c2)/(c3)/(c4) keystones
(`SlicingFlatKernel.lean`, variable block at :221-224) all carry `[Module.Finite R M]` with
`M = chartProd`, which IS finite colengths. Dropping (c1) leaves `projective_glued`,
`rankAtStalk_glued` and both flat-cokernel clauses with no landed route. Do not re-propose this
without first supplying a finiteness-free replacement for `SlicingFlatKernel`.

### 4. Why a repair of this shape is legitimate at all

§Discipline (2) forbids a support-separation hypothesis, and it is right to: assuming
`supp D ∩ π⁻¹({0,∞}) = ∅` about an arbitrary divisor assumes the conclusion. The repair does
something different — the ATLAS RECORDS which vertical fibres its divisors avoid — and that is
legitimate because the recorded condition is **open on the base**. New this round,
kernel-checked (`Picard/DivSchemeCertZarConfine.lean`):

* `isOpen_setOf_fibre_subset_chartInter` — the base points whose support fibre lies in
  `V₀ ⊓ V₁` form an OPEN subset of `Spec R`;
* `exists_opens_supportLocus_subset_chartInter` — confinement at one fibre spreads to a
  Zariski neighbourhood (the chart instance of the landed support tube);
* `supportLocus_subset_of_forall_fibre` — fibrewise confinement at every base point IS the
  global hypothesis `forall_finite_colength_of_pieces_eq_chart` wants.

So a chart of the atlas may carve by avoidance without losing points. What the repair still
owes is that the carved opens **cover** — and with the two pinned charts fixed once and for all
they provably do not (§1(c)). Covering is exactly what R1/R2 buy.

### 5. The covering obligation, stated

For a relative divisor whose support is finite over `Spec R`, and any `s ∈ Spec R`: the fibre
`D_s` is finite, so `π(D_s)` is a finite subset of `P¹` over `κ(s)`; if `k` is infinite,
`P¹(k)` is infinite, so two distinct `c₀, c₁ ∈ P¹(k)` avoid `π(D_s)`; `relCurve C R ↘ Spec R`
is proper (`instIsProperRelCurveHom`, `SupportTube.lean:194`), hence closed, so the image of
`supportLocus ∩ π⁻¹({c₀,c₁})` is closed and misses `s`; over the open complement the divisor is
confined to `π⁻¹(P¹ ∖ {c₀,c₁})`, i.e. to `V₀ ⊓ V₁` for the `γ`-twist carrying `{c₀,c₁}` to
`{0,∞}`. Then `chartPairCoverData` / `ofChartPair` and
`forall_finite_colength_of_pieces_eq_chart` (`Picard/DivSchemeCertZarChartPair.lean`) give
clause (c1) FREE, with no fibre, no tube and no idempotent.

Two hypotheses to watch. (i) **`k` infinite.** `Challenge.lean` states the Jacobian over an
arbitrary field; a finite-field route needs `|P¹(k)| > deg D`, i.e. a base change to `k(T)` or
a degree-`d` point, and must be scheduled, not assumed. (ii) **Finiteness of the support over
the base** must come from the seed's own degree data, NOT from the certificate — otherwise the
argument is circular.

### 6. Work breakdown (roadmap leaves)

* `certificate.chart-avoid` — ANSWERED (this addendum); becomes the record, not a task.
* `certificate.confine-open` — LANDED (`DivSchemeCertZarConfine.lean`).
* `certificate.p1-aut` — the `GL₂(k)` action on `P1 k` and transitivity on `P¹(k)` (R1's cost).
* `certificate.fibre-avoid` — §5's avoidance lemma, over an infinite `k`.
* `certificate.cert-relocalize` — restate `IsLocallyCertified`/`DivFamZar` to quantify over the
  twist; check every consumer of the frozen S6 names.
* `certificate.swallow-adapt` — ungated once `fibre-avoid` lands; only the chart-principality
  datum remains.
* `certificate.cert-collapse`, `certificate.cert-assemble` — unchanged.

*Nothing downstream of `chart-avoid` is blocked on a human any more; it is blocked on
`p1-aut` + `fibre-avoid`, both of which are ordinary mathematics.*

**RETRACTED IN PART by the CORRIGENDUM below (C4 iii).** `chart-avoid` itself is indeed
answered and needs no human. But a DIFFERENT question does, and it gates `p1-aut`: over a small
finite field, where `|P¹(k)| = q + 1 < n + 2`, no admissible pair of pinned points exists at
all, and the counterexample of §1(c) is field-independent, so the obstruction is real there.
That is roadmap leaf `certificate.field-size` and inbox I-0346. Read the corrigendum before
acting on §5 or §6.

### ADDENDUM 3 — SECOND CORRIGENDUM (2026-07-26, run 0048 round 2, from the round's ground review)

**The counterexample is off-stratum, and the record should say so.**  `F = tX² + XY + tY²`
over `k[t]` is a degree-2 divisor with `C = ℙ¹`, `π = id` — i.e. **genus 0**.  But the
campaign's functor is `DivFamZar C S π g` with `g` pinned to the genus by the standing
`hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 − g`, and `IsCertified n`'s clause (c2) fixes the
glued colength's fibre rank to `n = deg D` (`Picard/DivisorFamily.lean:426-437`).  On-stratum:
`g = 0` is vacuous (empty support), and `g = 1` is a section whose support locus is all of
`Spec R`, so a base shrink evades it.  **The no-go bites at `g ≥ 2`, and no witness has been
exhibited there.**

The *structural* argument of §1 is degree-agnostic — every piece of `FinCoverData` is a basic
open of one of the two pinned charts (`Picard/DivisorFamily.lean:166`, `:168`, `:186`), and
per-piece swallow-or-miss needs only openness — so the conclusion is very probably right at
every genus.  But ADDENDUM 3 claims an *explicit counterexample* on the campaign's own
stratum, and it does not have one.  Either exhibit a genus-≥2 witness or downgrade the claim
to the structural argument alone.  Filed as I-0356.

Unaffected by this: the DivEq-invariance of the obstruction, the base-openness of
confinement, and the rejection of the joint-covering repair (which is a typing fact about
`FinCoverData`, not a degree fact).

### ADDENDUM 3 — CORRIGENDUM (same round, after an adversarial pass)

The negative half above (§1, §2, §4) survived refutation. The positive half (§3, §5) did not
survive intact. Four corrections, all binding; the last one is a question for the human.

**C1. The counterexample is FIELD-INDEPENDENT, and it is not new.** `s(x²+1) + x` is degree 1
in `s` with coprime coefficients over *any* field, so `Z(sX₀² + X₀X₁ + sX₁²)` is irreducible
over `𝔽₂` just as over `ℚ`. §1(c)'s appeal to an infinite `k` is superfluous — and that is bad
news, not good: it means the obstruction cannot be escaped by enlarging the field. Also, the
example is already recorded in the tree, as the model in the docstring of
`not_forall_supportLeak_eq_empty_of_isPreconnected` (`Picard/DivSchemeCertZarConn.lean:170-175`);
this addendum supplies the flatness, irreducibility and shrink-stability it did not. It remains
a *paper* argument: no Lean declaration instantiates it. The three transport bricks to make it
kernel-checked are landed (`supportLocus_pullback`, `DivEq.supportLocus_eq`, `IsLocallyCertified`
unfolding to a span-⊤ family), but building the concrete `LocalEquations` on
`relCurve (P1.asOver k) k[s]` is real work (~500 lines).

**C2. There are TWO constraints, not one; §2 named only the second.**
 * **(β1) per-piece.** (c1)-finite ⟺ leak-free ⟹ every piece trace is clopen in the support
   ⟹ a connected support lies inside a SINGLE PIECE. This holds for *any* cover by opens and
   therefore survives every reshaping of `FinCoverData`. §2's "the binding constraint is
   `FinCoverData`" is wrong as stated.
 * **(β2) chart-wise covering.** `partition₀`/`partition₁` (`DivisorFamily.lean:174,176`) make
   the chart-`b` pieces cover all of `V_b`, which upgrades (β1)'s *one piece* to *one chart*.
 The sharp statement is therefore: **no repair keeping the pieces inside the preimages of a
 FIXED PAIR of points of `P¹` can work** — which is why moving the points is the only structural
 way out. A CHEAPER OPTION §3 MISSED: relaxing (β2) alone, to a single joint covering condition
 `⨆ pieces = ⊤`, drops the requirement from "avoid two points" to "avoid ONE point". That is a
 small local edit to `DivisorFamily.lean` + `DivSchemeCertZarChartTrace.lean:80,92`; check first
 whether `Cohomology/GluedSheafEngine.lean:78,85,89`, which consumes the partitions as
 `Ideal.span_range_eq_top`, really needs them chart-wise. Try this before building `PGL₂`.

**C3. R1's genericity is confirmed exhaustively; its price is higher than §3 said.** The only
constraints on `π` anywhere are `[IsFinite π]` (286×), `[IsDominant π]` (176×),
`[IsAffineHom π]` (75×) and the propositional triangle `hπ` (148×) — no flatness, separability
or degree bound — and all are stable under `π ↦ π ≫ γ`. Better still, **`DivScheme` is π-free**
(`Picard/DivScheme.lean:144` takes two abstract `CurveDivisor`s; `π` enters only at the
instantiation), so the γ-family needs NO gluing over γ for the representing object — only the
predicate changes. But: mathlib has `Proj.map` for graded ring homs and no `Proj.mapIso`, so
`γ`, `IsIso γ` and `γ ≫ P1.structureMap k = P1.structureMap k` are all new work; and this
project has **no `k`-rational points of `P¹` at all** (`Curve/P1Points.lean` has
`P1.fromSpecChart`, never instantiated at `A := k`). The predicate change touches
`IsLocallyCertified` and 24 dependent files.

**C4. §5's avoidance argument relocates the geometric input; it does not remove it — and it
fails over small finite fields.** Three defects:
 (i) `ofChartPair` is the wrong constructor for the general case. It needs chart *principality*
     (`Picard/DivSchemeCertZarChartPair.lean:116-127`). That holds for the seed's own family
     `D ∈ |mΘ|`, but for an arbitrary degree-`n` divisor on a curve of genus ≥ 1 it is false:
     `Cl(V_b) = Cl(C)/⟨components of π⁻¹(c_b)⟩ ≠ 0`, and shrinking `Spec R` does not change a
     fibre class. The `swallow-adapt` shape (`σ_b + τ_b = 1`) is the correct adaptation, and it
     needs "`D` is principal on some open containing its support, inside one cover member" over
     a possibly non-Noetherian test ring. The docstring licence at `ChartPair.lean:44-47` is
     wrong for the backward (classify-an-arbitrary-family) direction.
 (ii) "the support is finite over the base" is NOT available and is implied by nothing a
     `LocalEquations` carries: `d.eqn ≡ r` for a non-unit `r ∈ R` is germ-regular and has
     `supportLocus` containing a whole fibre curve, which no `γ` avoids. So the repaired
     predicate still needs fibrewise-finite support as an input. It is not circular — it is
     true for honest relative Cartier divisors — but it is unproved for the DD-R seed, and it
     is the input §Discipline (2) forbids writing as a hypothesis. **The repair moves the
     forbidden input into the atlas; it does not make it free.**
 (iii) **`k` infinite is INADMISSIBLE, and this is the real blocker.** There is no hypothesis
     on `k` stronger than `[Field k]` anywhere in `Picard/` or `RiemannRoch/` (510 `Field k`,
     zero `Infinite`/`IsAlgClosed`/`PerfectField`), and `Challenge.lean:96-99` states the
     Jacobian over an arbitrary field. The repair needs two `k`-rational points of `P¹` off
     `π(supp_s)` at every base point, i.e. `|P¹(k)| = q + 1 ≥ n + 2`; for `k = 𝔽_q` with small
     `q` and `n ≈ 2g` no such pair exists, and by C1 the obstruction is real there. Replacing
     the pinned points by a closed point of degree `d ≥ 2` destroys the two facts the design
     rests on: `Γ(P1 k, chartOpen k i) ≃+* Polynomial k` (`Curve/P1Charts.lean:234,239`) and
     `isPrincipalIdealRing_chartSections` (`Curve/P1Points.lean:64`), since `Cl(P¹∖{c}) = ℤ/d`.

**THE QUESTION THAT GOES BACK TO THE HUMAN** is therefore not "chart-avoid: yes or no" — that is
answered — but: *over a small finite field, what is `DivFamZar` supposed to be?* Three options:
 (a) accept a hypothesis `|P¹(k)| ≥ n + 2` and record that `Challenge.lean:96-99` is then
     unreachable for small `q`, i.e. the challenge as stated is not solved;
 (b) plan a descent lane — `divQProj` (`Picard/DivSchemeQProj.lean`) is the right lever for
     fpqc descent from `k'/k`;
 (c) generalize the pinned charts to complements of degree-`d` closed points, paying
     `Curve/P1Charts.lean:234,239`, `Curve/P1Points.lean:64` and all the `Γ ≅ k[t]` machinery.

**Revised order of work.** (1) `confine-open` — LANDED, including the connectivity-free form
`isClosed_supportLocus_inter_chart_of_isCertified`. (2) Try the (β2) relaxation (C2) before
`p1-aut`; it may halve the requirement for a local edit. (3) Settle the finite-field question
(C4 iii) BEFORE building `PGL₂` — it decides whether `p1-aut` is worth building at all.
(4) Only then `p1-aut` → `fibre-avoid` → `cert-relocalize`, with `swallow-adapt` (not
`ofChartPair`) as the adaptation and fibrewise-finite support as an explicit seed obligation.

---

## ADDENDUM 4 (2026-07-26, run 0048 round 4) — the on-stratum witness EXISTS, and R1 is correct exactly when `|P¹(k)| ≥ g + 2` (BINDING; closes I-0356 and answers I-0346)

ADDENDUM 3's second corrigendum left one question: the no-go's argument is degree-agnostic, but
its only exhibited witness (`F = tX² + XY + tY²` over `k[t]`, `C = P¹`, `π = id`) has degree 2 on a
curve of genus 0, off the stratum the functor pins. At `g = 0` the no-go is vacuous, at `g = 1`
the base can be shrunk to confine, and at `g ≥ 2` nobody had exhibited anything. This addendum
settles it, corrects the argument ADDENDUM 3 used for shrink-stability, and — the part that
actually decides the route — gives a sharp iff for R1.

### 4.1 First, the criterion ADDENDUM 3 used is the wrong one

ADDENDUM 3 argued shrink-stability as "the divisor stays irreducible over every nonempty open of
the base, so no Zariski shrink evades the no-go". That is true of the exhibited family and it is
not the right criterion, because `IsLocallyCertified` (`Picard/DivisorFamilyZar.lean:71`) asks for
a **span-⊤ family**, i.e. a *cover* — and a cover cannot delete a point. The correct criterion is

> (★) there is a point `s ∈ Spec R` such that for **every** open `U ∋ s`, some connected component
> of `supp(D|_U)` meets both `π⁻¹(p₀)` and `π⁻¹(p₁)`.

Under the criterion ADDENDUM 3 actually stated, the campaign's own genus-0 example would be
*evaded*: the two witness points of `tX² + XY + tY²` are `([1:0], 0)` and `([0:1], 0)`, both lying
over `t = 0`, and over `t ≠ 0` the roots are `(−1 ± √(1−4t²))/2t`, which are never `0` or `∞`. So
`D` restricted to `𝔸¹ ∖ {0}` misses *both* pinned fibres. It is a genuine counterexample only
because a cover must contain `t = 0`. The conclusion was right; half the reason was missing.

### 4.2 The reduction (general — no hypotheses on `k`, `C`, `π`, `n`)

Let `S = supp D ⊆ C ×_k Spec R`. Since `D` is finite flat of degree `n` over `R`, `S → Spec R` is
finite, hence closed. For `c ∈ P¹(k)` set `W_c :=` the image in `Spec R` of `S ∩ (π⁻¹(c) × Spec R)`
— a closed subset. Then for `s ∈ Spec R`:

* `s ∉ W_c` ⟹ `U := Spec R ∖ W_c` is an open neighbourhood of `s` on which `supp(D|_U)` misses
  `π⁻¹(c)` entirely, i.e. `D|_U` is confined to the chart complementary to `π⁻¹(c)`;
* `s ∈ W_c` ⟹ *every* `U ∋ s` has `supp(D|_U)` meeting `π⁻¹(c)`.

And `s ∈ W_c ⟺ supp(D_s)` meets `π⁻¹(c)`, a purely **fibrewise** condition. Since `D_s` is finite
of degree `n` over `κ(s)`, the image of `supp(D_s)` in `|P¹_k|` has **at most `n` closed points**.

Two consequences worth stating separately.

**(A) Necessity of `g ≥ 2`.** A witness needs one `s` whose fibre meets both `π⁻¹(p₀)` and
`π⁻¹(p₁)`, hence `n ≥ 2`. At `n = g = 1`, `W_{p₀} ∩ W_{p₁} = ∅`, so
`{Spec R ∖ W_{p₀}, Spec R ∖ W_{p₁}}` is a *confining cover*. That is I-0356's `g = 1` verdict, now
with a proof rather than an observation.

**(B) Connectedness is the second half.** The two witness points must lie in the same connected
component of `supp(D|_U)` for every `U ∋ s` — equivalently in the same connected component of
`S ×_R O_{R,s}`, idempotents of a finite algebra descending to a finite level. Reducible
constructions therefore fail: if `S = Δ ∪ ({b} × T)`, a certifier just shrinks until the
components separate.

### 4.3 The witness, over an arbitrary field

Hypotheses: `k` **any** field; `C/k` smooth proper geometrically irreducible of genus `g ≥ 2`;
`π : C → P¹` any finite dominant map; `p₀ ≠ p₁ ∈ P¹(k)` the pinned pair.

1. `Div^g_{C/k} ≅ Sym^g C =: T` exists over `k` — smooth projective, geometrically irreducible of
   dimension `g` — carrying a universal relative effective Cartier divisor `D_univ ⊆ C ×_k T`,
   finite flat of degree `g` over `T` (Kleiman, *The Picard scheme*, FGA Explained §9.3; BLR
   §8.2/9.3). Every degree-`g` relative divisor over every `R` is a pullback of `D_univ`, so this
   analysis is exhaustive rather than a lucky example.
2. **`supp D_univ` is irreducible over any `k`**: it is the image of the finite surjection
   `C × Sym^{g−1}C → C × Sym^g C`, `(x, ξ) ↦ (x, x + ξ)`, and `C × Sym^{g−1}C` is irreducible
   because `C` is geometrically irreducible. No monodromy argument and no `k = k̄` is used.
3. **The straddling point.** `π` finite dominant gives closed points `q₀ ∈ π⁻¹(p₀)`,
   `q₁ ∈ π⁻¹(p₁)`. Let `L` be a residue field of `κ(q₀) ⊗_k κ(q₁)`, so `L/k` is finite and admits
   `k`-embeddings of both; get `Q₀, Q₁ ∈ C(L)` over `p₀, p₁`. Since `g ≥ 2`,
   `ξ := (g−1)Q₀ + Q₁` is effective of degree exactly `g`, i.e. an `L`-point of `T`; let `s` be
   the underlying closed point. **No rational-point hypothesis is used anywhere** — the padding is
   by multiples of `Q₀`, so no "an effective divisor of degree `m` exists over `k`" problem arises,
   and `s` is in general not `k`-rational.
4. `T` is quasi-projective; choose an affine open `Spec R ⊆ T` containing `s` and put
   `D := D_univ|_{Spec R}`. This is on-stratum: degree `g = n`, finite flat over `R`.
5. **Non-confinability.** Let `{D(g_i)}` be any span-⊤ family. Some `D(g_i)` contains `s`. Then
   `supp(D|_{D(g_i)})` is a nonempty open of the irreducible `supp D_univ`, hence irreducible,
   hence preconnected, and it contains points over `p₀` and over `p₁` (the images of `Q₀, Q₁`,
   which lie over `s`). By `not_isCertified_of_isPreconnected_of_witnesses`
   (`Picard/DivSchemeCertZarVerdict.lean:62`), together with `supportLocus_pullback`
   (`DivSchemeCertZarTransport.lean`) and `DivEq.supportLocus_eq` (`DivSchemeCertZarConfine.lean:110`),
   no certified family exists over `Localization.Away (g i)` divisor-equal to the pullback. So
   `D ∉ DivFamZar(R)` while `D ∈ Div^g_{C/k}(R)`. ∎

**Field dependence: none.** It works over `F₂`, over imperfect fields, over non-closed fields.
Enlarging `k` does not escape it and neither does descent from a large field — the witness is
already there over the small field.

### 4.4 The sharp iff for R1, which is the decision this addendum is for

The reduction in §4.2 gives, with the pinned pair allowed to vary per cover member (which is
exactly what R1 buys):

> **R1 is correct if and only if `|P¹(k)| ≥ n + 2`.**
>
> *If.* For any `D`, `R`, `s`, the image of `supp(D_s)` in `P¹` has at most `n` closed points;
> choose `c ∈ P¹(k)` outside it and any `c' ≠ c`. Then `U := Spec R ∖ W_c` confines `D|_U` to the
> chart complementary to `π⁻¹(c)`. Doing this at every `s` gives a Zariski cover on which the
> divisor is confined, with the pair varying per member.
>
> *Only if.* If `Σ_{c ∈ P¹(k)} e_c ≤ n`, where `e_c` is the minimal degree of a closed point of `C`
> over `c` (e.g. `q + 1 ≤ g` when `C` has a rational point over each `c`), take
> `ξ_s = Σ_c q_c + padding`. Then `s ∈ W_c` for **every** `c ∈ P¹(k)`, and no pinned pair confines.

This **answers I-0346 exactly, in both directions**; the bound there was a sufficient guess and is
now known to be sharp. Consequences for the route:

* `p1-aut` / R1 is **not dead**: it is correct over every infinite `k`, and over `F_q` whenever
  `q ≥ g + 1`. It is dead exactly over small finite fields.
* Because `Challenge.lean:96-99` states the Jacobian over an **arbitrary** field and
  `archon-protected.yaml` forbids adding a hypothesis, R1 alone cannot discharge the challenge. It
  must be paired with descent (`dat-g`) or replaced.
* **R2 is the only field-uniform fix, and it has a short justification**: `supp D` is finite over
  `R`, hence contained in a single affine open of `C ×_k Spec R` (avoidance for families, Stacks
  0B8B), so a cover with one straddling piece always exists. Generalising `FinCoverData`'s piece
  type to arbitrary affine opens of the relative curve is therefore not a gamble; it is the
  statement the geometry already supports.

### 4.5 What to do in Lean, and what not to

**Do not formalise the witness.** It needs `Sym^g C` / `Hilb^g` with its universal flat divisor.
Mathlib has no Hilbert schemes, no symmetric products of schemes and no Picard scheme, and this
tree constructs no curve other than `P¹` (`C` is always a variable carrying hypotheses). A concrete
genus-2 hyperelliptic witness is not cheaper — it still requires building a non-rational proper
curve as a scheme, which has never been done here. The payoff would be a negative statement that
changes no theorem.

**Do this instead (≈40 lines, and it is the honest statement of the no-go):** strengthen
`supportLocus_subset_chart_of_isCertified` (`Picard/DivSchemeCertZarC1.lean:131`) and
`not_isCertified_of_isPreconnected_of_witnesses` (`DivSchemeCertZarVerdict.lean:62`) from
`IsPreconnected d.supportLocus` to the per-connected-component form. The clopen-trace proof at
`DivSchemeCertZarConn.lean:98` already gives it, and the general analysis in §4.2 is stated in
those terms.

Also: `DivSchemeCertZarConn.lean:170-175`'s docstring model is genus 0 — annotate it as
off-stratum and point here.

---

## ADDENDUM 5 (2026-07-28, run 0070) — R2 IS EXECUTED: the widened carrier is landed (BINDING; closes the design question of I-0346/I-0492)

The human decision of 2026-07-28 (protection I-0492) chose R2 and closed the design question.
This addendum records what was built, in Lean, and what remains. Everything below is
kernel-checked and sorry-free; the full root build (`lake build AlgebraicJacobian`, 9136 jobs)
is green.

### 5.1 The decomposition, which is the whole design

The old `FinCoverData` conflated three independent things. Separating them is what made R2
mechanical rather than a rewrite:

1. an open cover of the relative curve by **affine** pieces — all the certificate layer uses;
2. a **chart assignment** of each piece to one of the two pinned charts — only the Θ-layer
   needs this (the theta cocycle lives on `V₀ ⊓ V₁`);
3. the **chart-wise partitions of unity** — the (β2) upgrade, and the obstruction itself.

(1) becomes `AffCoverData` (`Picard/DivisorFamilyAffCover.lean`): `m : ℕ`,
`pieces : Fin m → Opens`, `isAffineOpen`, and the **joint** cover `(⨆ j, pieces j) = ⊤`. It
takes no `π` argument — nothing in it refers to a chart. (2) becomes the separate optional
`ChartTyping`, required by no certificate clause. (3) is **deleted**.

### 5.2 The one new commutative-algebra input, and it is unconditional

Widening costs exactly one lemma, `flat_sections_of_flat_hom`. The old flatness route
(`flat_sections_basicOpen ∘ flat_sections_relPinnedChart`) rested on
`Γ(V_bᴿ) ≅ R ⊗_k Γ(C, V_b)` being **free**, which an arbitrary affine open does not give.
Replacement: `Scheme.overAlgebraMap` factors as `ΓSpecIso.inv` then the structure morphism's
`appLE ⊤ V`; `AlgebraicGeometry.Flat` is a `HasRingHomProperty` for `RingHom.Flat`, so the
`appLE` is flat on an affine open, the iso half is flat, and `RingHom.Flat` composes. And
`relCurve C R ↘ Spec R` is flat because `snd` is the base change of `C.hom` along
`overSpec k R` (`Over.isPullback_left`) and a morphism to a field spectrum is flat. No
Noetherian, no finiteness, no hypothesis on `R`.

### 5.3 The claim of I-0492 clause 3, in its sharpest form

Per-piece swallow-or-miss and the clopen-trace argument turned out to mention neither the
adaptation nor the cover. They are now stated for a **bare open set** `U` of the relative
curve (`Picard/DivisorFamilyAffPerPiece.lean`):

  `supportLeak_eq_empty_of_subset_or_disjoint (U)`,
  `subset_or_disjoint_of_isPreconnected_of_supportLeak (U)`

i.e. `DivSchemeCertZarConn.lean:98` with the chart structure deleted. Clause (c1)-finiteness
uses only **affineness**, through the landed
`IsAffineOpen.finite_quotient_span_singleton_of_isClosed`. So the entire per-piece layer
transports, and the covering hypothesis enters in exactly ONE place
(`iSup_basicOpen_eqn_eq_unitLocus`), in its weaker joint form.

### 5.4 What died, deliberately

`subset_chart₀_or_disjoint_chart₀` / `…chart₁…` (`DivSchemeCertZarSwallow.lean:156,171`) and
`supportLocus_subset_chart_of_isPreconnected` (`DivSchemeCertZarConn.lean:149`) consume the
partitions and are the (β2) upgrade. They remain in the tree as the RECORD of the refutation;
no widened declaration may depend on them, and none does.

### 5.5 The two relocated obligations, and where they now live VISIBLY

* **(i) fibrewise-finite support** is not a field of `AffCoverData`, `AffAdaptation` or
  `IsCertified`. Its per-piece form enters `isCertified_of_swallowedBy` as the explicit
  hypothesis `hfib`. **(No longer an obligation — see ADDENDUM 7: it is discharged from the
  seed by `ThetaGeneratorSeed.affAdaptation_fibre_regular`, and does not appear in the
  endpoint's signature at all. The sentence above still correctly describes where it enters
  `isCertified_of_swallowedBy`, which remains a hypothesis of that lower-level assembler.)**
* **(ii) the fixed-pair confinement's silent contributions** were exactly two:
  `exists_mem_pieces` (now the joint cover field) and `flat_sections_pieces` (now §5.2).
* The Stacks `0B8B` input is the named Prop `AffCoverData.SwallowedBy` — one piece contains
  `supp D`, all others are disjoint from it — used and not re-derived per I-0492 clause 2.
  Mathlib has no `0B8B` and this tree constructs no curve but `P¹`, so formalising it is out
  of the certificate lane's scope. It is a hypothesis in every signature that needs it.

### 5.6 The asymmetry that makes R2 work and the pinned pair fail

`V₀ ⊓ V₁` is the complement of a FIXED PAIR of vertical fibres, and §4.3 exhibits a
straddling divisor at every genus `≥ 2`, so it cannot always be arranged. An affine open
containing a support finite over `R` always exists. That is the entire difference, and it is
why the widened `DivFamZarAff` carries no hypothesis on `|P¹(k)|` anywhere.

### 5.7 What remains on this lane

1. **The reindexing transport is LANDED**, and the estimate first written here (~100 lines of
   equalizer transport commuting with `deltaLeft`/`deltaRight` plus `rankAtStalk` invariance)
   was wrong by an order of magnitude — corrected in `Picard/DivisorFamilyAffReindex.lean`.
   Define the reindexed cover so its pieces are *definitionally* `D.pieces (e j)`; then
   `colength`, `ovlColength`, `toOvlLeft` and `toOvlRight` are all `rfl` at `(e i, e j)`,
   because reindexing acts **diagonally** on the pair index. `mem_gluedSubmodule_reindex_iff`
   then follows from the existing `mem_gluedSubmodule_iff` with no intertwining lemma, and
   `chartProdCongr` is just `LinearEquiv.piCongrLeft`. `FinCoverData.toAffCoverData` already
   has that shape (`pieces := D.pieces (finSumFinEquiv.symm j)`).
   Generalisable lesson: before writing a transport lemma for a kernel or equalizer along an
   index bijection, check whether the reindexed data can be made definitionally the original
   at the relabelled index. One negative result recorded in the file: the `Submodule.comap`
   spelling does NOT elaborate, since `Submodule R (A.reindex e).chartProd` needs the
   section-ring algebra instances to unfold through the reindexed cover and instance search
   does not get there; use the membership-iff form.
   What is still *not* assembled is the full `CertifiedDivisorFamily → CertifiedDivisorFamilyAff`
   packaging on top of it — the pieces are all present and it is now bookkeeping, not
   mathematics. Nothing downstream needs it; it matters only for REUSING a chart-typed
   certificate.
2. **`away-kerspan` is CONFIRMED a real obligation, not an artifact.** `cert-collapse` was
   tried first, as its node instructed, and the answer is negative: `deltaSub_apply_diag`
   shows every diagonal component of the difference arrow vanishes identically, so (c4)
   always forces flatness of the diagonal overlap colengths. It stays blocked, not rejected,
   and the flattening-fallback lead in its node is now the live one.
3. The Θ-layer keeps its two-chart structure via `ChartTyping` and was not rewritten.

## ADDENDUM 6 (2026-07-28, run 0070 session 0006) — the widened carrier is now a FUNCTOR value, and it has its own producer (BINDING)

ADDENDUM 5 recorded R2 as executed and listed, as leftover bookkeeping, only the
`CertifiedDivisorFamily → CertifiedDivisorFamilyAff` packaging.  That list was incomplete in a
way worth recording, because the omission was structural rather than clerical.

**1. `DivFamZarAff` had NO base-change layer, and two passing audits did not see it.**
The chart-typed `DivFamZar` owns an entire S5b layer (`Picard/DivisorFamilyZarMapAlg.lean`):
`IsLocallyCertified.pullback`, `DivFamZar.mapAlg` with `mapAlg_id`/`mapAlg_comp`,
`picClass_mapAlg`, and the Zariski separation keystone `eq_of_away_eq`.  The widened value had
none of them, so nothing could transport a widened class along `R → R'` — it was a *type*, not a
functor value.  Every check run on it (true / sorry-free / non-vacuous / clause-for-clause
identical to its predecessor) passes on an island; the missing property is an **absence**, and
a green sorry-free build cannot see it.  Recorded as inbox memory I-0563.

Now landed, all sorry-free and axiom-clean:
`Picard/DivisorFamilyAffSections.lean`, `…AffBaseChange.lean`, `…AffCert.lean`,
`…AffMapAlg.lean` (commits `2e295a587`, `ed45211537`, `2118e90e6`, `107cd5581`), giving
`AffCoverData.baseChange`, `AffAdaptation.pullback`, `isCertified_pullback` (**all seven
clauses**), `CertifiedDivisorFamilyAff.mapAlg`, `IsLocallyCertifiedAff.pullback`,
`DivFamZarAff.mapAlg` with the functor laws and `eq_of_away_eq`, and `DivFamZar.toAff_mapAlg`
— so `toAff` is a map of **functors**, not merely of values.

> **CORRECTED IN PART by ADDENDUM 8 (same day, session 0010).** Every declaration listed above
> exists and the paragraph's diagnosis is right, but the closing clause over-reads it. All of
> them are spelled at the **instance-parameterized** face `mapAlg`; the vehicle and functor
> layer — and hence every consumer — is spelled at the **explicit-map** face `mapAlgHom`, which
> the widened carrier did not have. So `toAff` was a map of values compatible with `mapAlg`, and
> not yet a map of anything a consumer could receive: outside the thirteen `DivisorFamilyAff*`
> files, `DivFamZarAff` appeared nowhere in the tree. This paragraph's own moral — *the missing
> property is an absence, and a green build cannot see it* — applied once more to the fix for it.
> Landed in ADDENDUM 8 §8.2.

**2. The widening makes base change CHEAPER, and the reason generalises.**
The chart-typed route reaches a piece *through* its chart: `relTermBaseChange` is freeness-based
(over the base curve) and `pieceTermBaseChangeAlg` then localises at a generator.  An arbitrary
affine open of `relCurve C R` has neither a generator nor a base-curve presentation, so both
steps die.  Three replacements, none of them work:

* the section keystone at an arbitrary affine open was **already in the tree**, from an
  unrelated lane: `Over.pieceRingEquiv` (`Picard/EffectivityPieces.lean`), hypothesis
  `IsAffineOpen` only, out of mathlib's *affine* `pushoutSection` — no flatness, no freeness.
  Its cover map is `rfl`-equal to `relCurveMap`;
* defining the base-changed cover by **preimage** makes `pieces_baseChange` `rfl`, and makes the
  base-changed overlap `rfl`-equal to the preimage of the overlap.  The whole
  `ovlGen` / `basicOpen_ovlGen` / `isAffineOpen_chart_inf` apparatus — which existed only to
  re-present a piece overlap as a basic open of a *chart* overlap — has no widened analogue, and
  `relQuotBaseChangeAff` serves both the (c1) and the overlap transport as one declaration;
* `FinCoverData.baseChange` had two partition-of-unity obligations.  `AffCoverData.baseChange`
  has none, because the partitions are exactly what R2 deleted.

**3. The one cost of the R2 shape, and it is free where it matters.**  `AffCoverData` demands
affineness of the *pieces* only, so the certificate transport needs the *overlaps* affine.  That
is `AffCoverData.HasAffineOverlaps`, deliberately **not** a field — bundling it would quietly
re-strengthen the widened structure.  It is free for proper `C`
(`hasAffineOverlaps_of_isProper`, via `Over.isAffineOpen_inf` on the separated relative curve)
and propagates along a tower, so no such hypothesis appears from
`IsLocallyCertifiedAff.pullback` onward.

**4. The widened predicate now has a producer that does not route through the charts**
(`Picard/DivisorFamilyAffExtraction.lean`, `321af6cb6`).  This was the standing complaint of
I-0539: the only way to obtain an `AffAdaptation` was `FinCoverData.toAffCoverData` followed by
`DivisorAdaptation.toAff`, i.e. through the very predicate R2 exists to avoid.

  `exists_affAdaptation_of_isProper (d : LocalEquations) : ∃ D : AffCoverData C R, Nonempty (AffAdaptation D d)`

with no hypothesis on `d`, no `π`, no chart, no partition of unity.  Short for the same reason as
(2): the chart-typed `exists_divisorAdaptation` runs the basic-open refinement on *each* pinned
chart and glues with a per-chart partition of unity, whereas widened there is nothing to glue —
affine opens are a basis of any scheme, so choose one inside `d.cover.opens z` at each `z` and
take a finite subcover.  Compactness is not a hypothesis either:
`instQuasiCompactRelCurveHom` (`IsProper ⟹ QuasiCompact`, stable under base change) then
`QuasiCompact.compactSpace_of_compactSpace`.

**5. What is still owed, and it is now the whole residue of the lane: the CERTIFICATE half.**
The two obligations I-0492 clause 4 relocated — fibrewise-finite support (`hfib`) and
`SwallowedBy` — remain obligations that nothing in the tree constructs, and a cover produced by
the extraction of (4) has no reason to carry a straddling piece.  Arranging one is precisely
where the Stacks `0B8B` input enters.  Obligation 4(i) is at least now readable by the layer that
owes it: `AffAdaptation.eqn_tmul_one_mem_nonZeroDivisors_iff` (`09396353c`) restates the tensor
condition as regularity of the pulled equation **on the fibre curve over `κ(p)`**, which is the
vocabulary the seed layer speaks.

> **SUPERSEDED IN PART by ADDENDUM 7 (same day):** obligation 4(i) is no longer owed — it is
> discharged from the seed. Read item 5 as history for `hfib`; the `SwallowedBy` half stands.

## ADDENDUM 7 (2026-07-28, run 0070 session 0008) — obligation 4(i) is DISCHARGED, and the residue is ONE statement (BINDING)

ADDENDUM 6 item 5 listed two owed obligations. One of them was never an obligation of the
*widened* layer at all, and the reason is worth stating because it generalises past this lane.

### 7.1 The discharge, and why it was available

`ThetaGeneratorSeed.affAdaptation_fibre_regular` (`Picard/DivisorFamilyAffFibre.lean`,
`5e77976f4`) supplies `hfib` for **every** `AffCoverData` and **every** `AffAdaptation` over it:

```
affAdaptation_fibre_regular (hD : D.IsGenerator) (Dc : AffCoverData C R)
  (A : AffAdaptation Dc (D.localEquations hD)) (j) (p) :
  A.eqn j ⊗ 1 ∈ nonZeroDivisors (Γ(Dc.pieces j) ⊗_R κ(p))
```

The chart-typed lane discharges its own `hfib` through
`DivisorAdaptation.eqn_tmul_one_mem_nonZeroDivisors_of_seed`, and the natural reading is that
this is chart machinery. **It is not.** Trace what it consumes: it bottoms out at
`ThetaGeneratorSeed.germ_self_pullbackEqn_mem_nonZeroDivisors`, whose *statement* mentions the
local-equation system `d`, the fibre curve over `κ(p)`, and nothing else — no cover, no pieces,
no chart, no partition of unity. It says: *the pulled system equation is regular at its own
point*. That is a property of the seed and the fibre.

Everything the chart-typed layer adds on top of it is the comparison

> pulled *piece* equation = unit × pulled *system* equation,

and `eqn_rel` — a field of `AffAdaptation` just as much as of `DivisorAdaptation` — is the whole
content of that comparison. So the piece enters only through `eqn_rel` and the affine germ seam,
and an arbitrary affine open supplies both. Obligation 4(i) was never chart-typed; it merely
*looked* it, because the only existing discharge sat in a chart-typed file.

### 7.2 The orientation asymmetry, which is why the existing lemma could not be reused

`AffAdaptation.germ_pullbackEqn_mem_nonZeroDivisors` (`…AffBaseChange.lean`) runs the same
decomposition and is **useless here**, because it takes the pulled piece equation as an *input*
and therefore costs `Module.Projective R (A.colength j)` — which is (c1)-projectivity, i.e. what
`hfib` is supposed to produce. Reversed
(`AffAdaptation.exists_germ_pulledEqn_eq_unit_mul_pullbackEqn`) the piece equation is the
*conclusion's* subject and no projectivity is needed. Generalisable form: when a comparison
lemma is stated in the direction that consumes the datum you want to produce, re-prove it in the
other orientation rather than trying to satisfy its hypotheses.

### 7.3 The rank datum reduced too, and this was not planned

`hrank` was stated about the **glued** module over the whole cover, while a degree statement is
about the divisor — which on a straddling cover lives inside the swallowing piece. On such a
cover the difference arrow vanishes identically, so `Glued ≃ chartProd`
(`gluedEquivChartProd_of_swallowedBy`); `Module.rankAtStalk_pi` splits the product; and every
non-swallowing colength is **subsingleton**
(`subsingleton_colength_of_disjoint_supportLocus`), hence free, hence flat, with empty
`Module.support`, hence rank `0`. `finsum_eq_single` finishes:

```
rankAtStalk_glued_eq_of_swallowedBy : rankAtStalk A.Glued p = rankAtStalk (A.colength j₀) p
isCertified_of_swallowedBy_of_c1_of_rank_piece   -- the assembler with the one-piece datum
```

(`Picard/DivisorFamilyAffRank.lean`, `81c17f256`.) Non-vacuity is *checked* — trap (c) of
`I-0442` — by `rankAtStalk_colength_eq_zero_of_supportLocus_empty`, not assumed.

One technical note: `rw` cannot rewrite under `Module.rankAtStalk A.chartProd`, because the
target is not type-correct at `instances` transparency (`chartProd` unfolds through the
section-ring algebra instances — the same shape as the `Submodule.comap` trap recorded in
`Picard/DivisorFamilyAffReindex.lean`). Assemble the equalities as `have`s and close with
`.trans`.

### 7.4 The endpoint, COMPOSED rather than asserted

`exists_isCertified_of_seed_of_swallowing_affineOpen`
(`Picard/DivisorFamilyAffSeedEndpoint.lean`, `46d751465`):

```
(hD : D.IsGenerator) (hW : IsAffineOpen W) (hsub : supp d ⊆ W)
  (hWle : W ≤ d.cover.opens z₀) (hrank : rank of the SWALLOWING colength = n)
  : ∃ Dc A, A.IsCertified n
```

`hfib` is gone; `hproj` is gone as a hypothesis and **derived** inside, since the discharged
fibrewise datum feeds `projective_colength_of_forall_tmul_residueField`. The file exists rather
than a prose note precisely because ADDENDUM 6's session learned that a producer and a consumer
can each be correct and still not compose — `AffAdaptation` needs *subordination*, and bare
containment does not give it. Composition is checked by the elaborator here.

### 7.5 What is left

> **SCOPE CORRECTED by ADDENDUM 8 (same day, session 0010):** "exactly one statement" is a claim
> about the **certificate**, and as such it stands. It is not true of the lane, which also owed
> the widened carrier's explicit-map face and its vehicle/functor layer — measured absent, now
> landed (§8.2) except for `divFamZarAff.map` along an arbitrary test morphism. Read §8.3 for
> the two-item residue.

**Exactly one statement:** the subordinate Stacks `0B8B` input — an affine open `W` containing
`supp D` and contained in one member of `d.cover`. I-0492 clause 2 directs the lane to USE it,
not re-derive it; mathlib has no form of `0B8B` and this tree constructs no curve but `P¹`. The
degree datum `hrank` is not a *missing* input in the same sense: it is the honest content of
"the divisor has degree `n`", and it is now stated at the one affine open where the divisor is.

## ADDENDUM 8 (2026-07-28, run 0070 session 0010) — the widened carrier had NO EXPLICIT-MAP FACE, so nothing could consume it (BINDING; corrects ADDENDUM 5 §5.7, ADDENDUM 6 item 1 and ADDENDUM 7 §7.5)

ADDENDUM 6 item 1 recorded, correctly and self-critically, that `DivFamZarAff` had no
base-change layer, listed the four files that fixed it, and concluded "so `toAff` is a map of
**functors**, not merely of values". ADDENDUM 7 §7.5 then reported the lane's residue as
**exactly one statement**, the subordinate `0B8B` input.

Both were measured on the certificate side and both are correct there. Neither was measured on
the **consumer** side, and on that side the situation was this:

> Outside the thirteen `Picard/DivisorFamilyAff*.lean` files, the string `DivFamZarAff` appeared
> **nowhere in the tree**.

### 8.1 The defect: one operation, two faces, and the consumers use the other one

A carrier that base-changes in this project has *two* faces of the same operation:

* the **instance-parameterized** face `mapAlg`, taking `[Algebra R R'] [IsScalarTower k R R']`;
* the **explicit-map** face `mapAlgHom`, taking a bare `(φ : A →ₐ[k] A')`.

`DivFamZarAff` had the first and not the second. The two are interderivable in a few lines
(`mapAlgHom` is `mapAlg` at `RingHom.toAlgebra` of the map; the bridge back is one
`Algebra.algebra_ext`), which is exactly why the gap survived: every audit of the widened
base-change layer compared it to the chart-typed one **by name**, and by name the S5b list was
complete.

The consumers cannot use the instance face. `divFamZar` (`Picard/DivisorFamilyZarVehicle.lean`)
indexes its compatibility condition by the section-restriction maps `Over.resAlgHom T h`, which
are bare `AlgHom`s carrying **no** tower instance; `divFunctor`
(`Picard/DivisorFamilyZarFunctor.lean`) is built on that vehicle, and `DivRepGlobalData`
(`Picard/DivRepKit.lean`) is stated against `divFamZar` and `divFamZar.map`. So the entire
consumer stack is spelled at `mapAlgHom`, and until the widened carrier had that face there was
no widened vehicle, no widened functor, and no statement a consumer could be given.

**The honest reading of `cert-assemble` before this session:**
`divFamZarAff_of_forall_prime_certified_adaptation` produced a class **at an affine test**, and
nothing carried it to a general one.

### 8.2 What landed

* `Picard/DivisorFamilyAffFace.lean` (`ed13f29a1`) — `DivFamZarAff.mapAlgHom` with
  `mapAlgHom_id`, `mapAlgHom_comp`, the face-change bridge `mapAlg_congr` /
  `mapAlgHom_eq_mapAlg` (usable in both directions), `picClass_mapAlgHom`, `congr`, and
  `DivFamZar.toAff_mapAlgHom`.
* `Picard/DivisorFamilyAffVehicle.lean` (`2a1e05623`, `a5c5ca3e9`) — the widened affine-opens
  limit `divFamZarAff C n T` with its section API, the affine comparison
  `divFamZarAffAffineEquiv C n R : divFamZarAff C n (overSpec k R) ≃ DivFamZarAff C R n`, and
  the vehicle-level comparison `divFamZarToAffVehicle` with
  `divFamZarAffAffineEquiv_toAffVehicle`.

All sorry-free, axiom-clean against a `sorryAx` control, rooted, `lake env lean` exit 0.

The affine comparison is the load-bearing one: the certificate lane's endpoint lands in its
right-hand side, so it is the step that carries a widened certificate into a vehicle.

`[IsProper C.hom]` is carried on both files rather than hidden. The widened `mapAlg` needs it
(§ADDENDUM 6 item 3: an arbitrary affine open's overlaps are not affine by fiat), and it is a
hypothesis this lane has everywhere, so it costs no generality — but it is one of the things
I-0492 clause 4(ii) warns the old typing supplied silently, so it is stated.

### 8.3 The residue, restated honestly

ADDENDUM 7 §7.5's "exactly one statement" was a claim about the **certificate**, and it stands
as such. The lane's residue as a whole is now **two** items, of quite different kinds:

1. the subordinate Stacks `0B8B` input, unchanged, out of scope per I-0492 clause 2;
2. `divFamZarAff.map` along an **arbitrary morphism of test objects**, plus the functor
   packaging `divFunctorAff` on top of it. This is what `DivRepGlobalData.pull_comp` consumes,
   and it is *not* a restatement of (1): it is the widened analogue of
   `Picard/DivisorFamilyZarMap.lean`, whose input is the widened Zariski **gluing** keystone
   (`DivFamZar.exists_glue_of_away_compat`, `Picard/DivisorFamilyZarGlue.lean`) at the widened
   carrier. That keystone's argument is entirely about the Zariski cover of the **base**, which
   R2 did not touch — the cover datum appears only inside the opaque `mapAlg` — so it should
   port the way `IsLocallyCertifiedAff.pullback` ported. Priced as a port, not as mathematics;
   not yet measured.

### 8.4 The generalisable lesson

**Diff a replacement type's API by FACE, not only by name**, and measure the absence *outside*
the new type's own cone. The cheap check is one grep: the name of the new carrier, outside the
files that define it. Zero hits means the replacement is an island however complete its own
layer looks, and a green sorry-free build cannot see it — the missing thing is an absence.

Recorded as inbox memory `I-0617`. This is `I-0592` ("a new type needs its old API") with a
sharper edge: `I-0592` says diff the API, and this says a *name-level* diff reads as complete
precisely when one **face** is missing, because the two faces live under different names.

### 8.5 Why residue item (b) is blocked by a STATEMENT SHAPE, not by mathematics (measured)

Item (b) of §8.3 was priced as "a port of the base-side gluing keystone, because R2 left the base
side alone". That pricing is right about the *mathematics* and was incomplete about the *types*,
and the difference is worth stating because it is the same lesson as ADDENDUM 7's `hfib`
transport read from the other side.

**What the assembly consumes versus what it demands.** `awayGluedEquations`
(`Picard/DivisorFamilyZariskiGlue.lean:454`) is the actual divisor assembly. Measured over its
whole body, the only projections of its input `E` that appear are `.eqns` (eight occurrences) and
`.cover` — which is `eqns.cover` — seven. It never touches `.adaptation` and never touches
`.certified`. It returns a bare `(relCurve C R).LocalEquations` and mentions `π` zero times.
Its *declared* input, however, is

```
variable {n : ℕ} (E : ∀ i, CertifiedDivisorFamily C (S i) π n)
```

the full **chart-typed certified family**. Likewise `DivFamZar.exists_glue_of_certified_away_compat`
(the certified-input core) names no cover or adaptation type anywhere in its signature; its only
two occurrences of the word "chart" are comments, and they refer to the *base* localization
restriction rather than to a `P¹` chart.

**So the blocker is precisely this mismatch, and it is not removable by being clever at the call
site.** A widened class over `S i` has no chart-typed certificate at all — *that failure is the
content of R2* — so the chart-typed assembly cannot be instantiated at widened input however
carrier-free its proof happens to be. The fix is to restate the assembly at the datum both
carriers actually have: bare local-equation systems `E : ∀ i, (relCurve C (S i)).LocalEquations`,
with the pullback regularity that the certificate used to supply carried explicitly. Naming that
side-condition is itself necessary rather than cosmetic: a *family* of `hreg`s has to be
quantified over in the compatibility hypothesis, and the anonymous `∀ y z hz, …` spelling cannot
be. Hence `Scheme.LocalEquations.PullRegular`, with
`pullRegular_of_isOpenImmersion` discharging it in the case every away localization is in.

**Status, stated exactly.** `PullRegular` and `pullRegular_of_isOpenImmersion` are landed and
elaborate. The restated assembly on top of them is **not** landed. So item (b) is now decomposed
rather than closed, and its price is a repackaging at a weaker input type — no new mathematics,
but more than a substitution of names.

**Generalisable, and it is the converse of ADDENDUM 7's lesson.** There, an obligation looked
chart-typed because it *lived* in a chart-typed file, and transported once its leaf input's
statement was read. Here an assembly is carrier-free in its *proof* and chart-typed in its
*statement*, and the port is blocked by the statement alone. Same underlying question in both
directions: **read what the declaration consumes, not what its signature demands** — and when the
two differ, the fix is to weaken the signature to what the body actually uses.

### 8.6 The widened gluing keystone IS proved, and §8.5's prescription is what proved it

§8.5 diagnosed residue item (b) as blocked by a statement shape and prescribed the fix: restate
the assembly at bare local-equation systems, weakening the signature to what the body actually
consumes. That was executed the same session, and it worked.

```
DivFamZarAff.exists_glue_of_away_compat
  (g : ι → R) (S : ι → Type u) (T : ι → ι → Type u) …
  (hg : Ideal.span (Set.range g) = ⊤)
  (F : ∀ i, DivFamZarAff C (S i) n)
  (hcompat : ∀ i j, mapAlg (T i j) n (F i) = mapAlg (T i j) n (F j)) :
  ∃ F₀ : DivFamZarAff C R n, ∀ i, mapAlg (S i) n F₀ = F i
```

Uniqueness is `DivFamZarAff.eq_of_away_eq`, already landed. **So the widened value is a Zariski
sheaf value, not merely a functor value**, and no hypothesis on `|P¹(k)|` occurs in the statement
or anywhere on its route — which is the entire purpose of R2.

Landed in `Picard/DivisorFamilyAffGlueZar.lean` on the kit of `…AffGlueZarKit.lean`, which now
carries the restated assembly in full: `AwayCompatPullDivEq` (with the regularity witnesses
existentially bound — the `∀` spelling would be a vacuous obligation),
`germ_awayTransportLoc_mem_nonZeroDivisors`, `exists_res_awayTransportLoc_eq_unit_mul`,
`awayGluedEquationsLoc`, `divEq_pullback_awayGluedEquationsLoc`,
`CertifiedDivisorFamilyAff.isLocallyCertifiedAff` / `.toZarAff`, and
`DivFamZarAff.exists_glue_of_certified_away_compat`. All sorry-free; `lake env lean` exit 0;
`lake build` 8838 jobs; axiom-clean against a `sorryAx` control.

**One defect found by checking rather than counting, and it is the transferable part.** The
keystone file was **red with zero `sorry`s**. `DivFamZarAff.eq_of_away_eq` takes `n : ℕ` as an
**explicit leading argument**, where the chart-typed `DivFamZar.eq_of_away_eq` has it implicit at
that position; a port that copies the chart-typed call site therefore feeds the away-cover family
where `n` is expected, and the error surfaces far away as an unresolvable `l.down` on a `ULift`
binder — a message naming neither `n` nor `eq_of_away_eq`. One argument. A `sorry` census and a
job count both report such a file as healthy; only elaborating it does not. Cf. inbox `I-0624`
(advertised-but-absent versus present-but-unreachable) — this is a third variety: *present,
reachable, and red*.

**What residue item (b) still owes.** `divFamZarAff.map` along an arbitrary morphism of test
objects, and `divFunctorAff` on top of it. The keystone above was that construction's *input*
(the chart-typed `map` is built from `DivFamZar.exists_glue_of_away_compat` via the basic-cover
gluing kit), so item (b) is now one packaging layer from done rather than one keystone plus a
packaging layer.
