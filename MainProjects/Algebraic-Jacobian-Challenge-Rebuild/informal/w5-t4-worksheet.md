# W5-T4 worksheet — the étale-plus/Zariski kernel crossing at `k[ε]` (risk R1)

**RATIFIED — BINDING (orchestrator, 2026-07-17 night session).** Route (ii) is adopted
as recommended below; route (i) remains the documented fallback. The pending t3 brick
(AJCR.w5-av.t3) is RE-SCOPED to T4-b (the coefficient-natural ε-kernel over finite
products of fields) — the roadmap item carries the amendment. The whole T/S cluster
(t1, t3/T4-b, t4-a..e, t5, s1, s2, s3) is assigned to the dedicated Wave-5 smoothness
session (third fleet); see `w5-worksheet.md` §3 addendum for the division of labor.

*Produced 2026-07-17 by the read-only design-probe lane w5-t4-probe (AJCR.w5-av.t4), per
w5-worksheet §1 D4 ("T4 WORKSHEET-FIRST") and w5-recon §3.1 G-W5-T4 / §5 R1 / §5 R3. No
file outside `informal/` touched; no build run; every claim below re-verified against the
pinned mathlib checkout (`.lake-packages/mathlib`, v4.31.0, `fabf563a7c9…`) and the landed
Lean tree at probe time. Mathlib paths are under `Mathlib/`, project paths under
`AlgebraicJacobian/`.*

---

## §0 Verdict in one line

**Recommend route (ii)** — the kernel-level cancellation over `k`, run at every field base
`K/k` uniformly — because the probe found that (a) the "Artin-local splitting" both routes
feared needs **no henselian machinery at all** (the thickening is square-zero, so mathlib's
`FormallyEtale`/`FormallySmooth` square-zero lifting plus the étale-over-a-field structure
theorem do the whole cover-refinement job), (b) the "Hilbert-90-flavoured" cancellation
**dissolves into the already-landed module-level Amitsur exactness** of `Descent/`
(after the T2 truncated-exp linearization the descent condition is additive, and degree-≤1
additive Amitsur exactness is `Module.DescentDatum.exact_mk_coactionSub`,
`Descent/ModuleDescent.lean:247` — no unit-cocycle cancellation, no Galois theory), and
(c) route (i)'s close of the frozen numeral is **structurally coupled to the R3 mathlib
gap** (no rel-dim descent exists; appendix §5), whereas route (ii) hands T5 the k-side
count `ker(pic0(k[ε]) → pic0(k)) ≃+ H¹(C,𝒪)` on the nose, with the `k̄`-side instance and
the tangent base-change square falling out of the same uniform statement. Route (i)
survives verbatim as the documented fallback: it is the separably-closed degenerate case
of route (ii)'s bricks.

The single hardest brick on the recommended route is **T4-b** (§3): the
coefficient-natural ε-kernel isomorphism
`ker(relPic C (A[ε]) → relPic C (A)) ≃+ H¹(C,𝒪) ⊗[k] A`, natural in a k-algebra `A`
ranging over finite products of fields — a re-scope of the pending t3 brick (t3 is
unstarted, so this is a scope amendment, not rework). **Orchestrator action needed:
ratify the t3 re-scope before the t3 lane launches.**

---

## §1 Probe evidence — mathlib inventory (all re-verified this session)

### 1(a) `HenselianLocalRing`: an island; nothing usable, and nothing needed

- `HenselianLocalRing` class: `RingTheory/Henselian.lean:108`; `HenselianRing R I`
  (:94); `HenselianLocalRing.TFAE` (:119, simple-root lifting forms only);
  `Field.henselian` (:114); quotient instance (:154);
  `IsAdicComplete.henselianRing` (:170).
- **Zero consumers**: `grep -rn Henselian` over the pinned checkout hits *no file other
  than `RingTheory/Henselian.lean` itself*. There is no étale-cover splitting, no
  "finite algebra over henselian local = product of local rings", no idempotent lifting
  stated over henselian rings, no section-existence statement. The R1 fear "the
  splitting brick is unverified in mathlib" is confirmed: **it is absent**.
- Adjacent structure theory that does exist: idempotent lifting along *nilpotent*
  kernels — `exists_isIdempotentElem_eq_of_ker_isNilpotent`
  (`RingTheory/Idempotents.lean:248`, plus the complete-orthogonal-family lifting
  machinery in the same file); reduced Artinian decomposition `IsArtinianRing.equivPi :
  R ≃ₐ[R] Π (I : MaximalSpectrum R), R ⧸ I.asIdeal` (`RingTheory/Artinian/Module.lean:623`).
- **Why none of this matters for T4**: the project's covers are
  `Algebra.Etale A B` = `FormallyEtale` + `FinitePresentation`
  (`RingTheory/Etale/Basic.lean:213`; project `Algebra/EtaleCover.lean:64-87`), and the
  test thickening `K[ε] → K` has square-zero kernel. So the entire "henselian lifting"
  content collapses to ONE application of the square-zero lifting API:
  `Algebra.FormallySmooth.comp_surjective (I : Ideal B) (hI : I ^ 2 = ⊥)`
  (`RingTheory/Smooth/Basic.lean:83`) / `Algebra.FormallyEtale.comp_bijective`
  (`RingTheory/Etale/Basic.lean:77`). No henselian induction, no idempotents.

### 1(b) Étale algebra structure: the field-level structure theory is a complete gift

- `Algebra.Etale.iff_exists_algEquiv_prod` (`RingTheory/Etale/Field.lean:271`): `A/K`
  étale ⟺ `A ≃ₐ[K] Π i, Ai i` finite product of finite separable field extensions.
  (Formally-étale version at :194; the project already consumes it:
  `Algebra.EtaleCover.exists_finiteSeparableField_algHom`, `Algebra/EtaleCover.lean:287`.)
- `Algebra.FormallyEtale.equivPiOfIsSepClosed` (`Etale/Field.lean:217`): over a
  separably closed `K`, an étale algebra is `≃ₐ[K] (PrimeSpectrum A → K)` — the
  **split** case; with `IsSepClosed.algebraMap_bijective`
  (`FieldTheory/IsSepClosed.lean:213`) and `IsSepClosed.of_isAlgClosed` (:72).
- Base change and composition: `Algebra.Etale.baseChange` instance
  (`Etale/Basic.lean:249`), `Algebra.Etale.comp` (:244) — so
  `(EtaleCover.ofField L).baseChange (K[ε])` is a legal cover of `K[ε]` with carrier
  `K[ε] ⊗[K] L` through the landed `EtaleCover.baseChange` (`Algebra/EtaleCover.lean:238`).
- Standard-étale presentations exist (`RingTheory/Etale/StandardEtale.lean`;
  `Algebra.IsEtaleAt.exists_isStandardEtale`,
  `RingTheory/Unramified/LocalStructure.lean:374`;
  fiber-splitting étale neighborhoods of finite algebras,
  `RingTheory/Etale/QuasiFinite.lean:378`) — all spectrum-local *constructions of covers*,
  none produces sections over a local base. **Not needed** on either route.
- "étale + local + henselian ⇒ has a section": **absent**; replaced by 1(a)'s
  square-zero observation.

### 1(c) Hilbert 90 / unit descent: mathlib has the wrong shape; the project has the right one

- Mathlib's Hilbert 90 is Galois-cohomological only:
  `groupCohomology.isMulCoboundary₁_of_isMulCocycle₁_of_aut_to_units`
  (`RepresentationTheory/Homological/GroupCohomology/Hilbert90.lean:84`, norm forms
  :134/:172). No Amitsur/étale-cover form, no Galois↔Amitsur bridge. Unusable here
  without a new bridge campaign — **do not route through it**.
- Mathlib faithfully-flat descent of ring-hom properties:
  injective/surjective/bijective (`RingTheory/Flat/FaithfullyFlat/Descent.lean:31-72`).
  No units-of-covers statements.
- **Project-landed (the decisive assets)**, `Descent/`:
  - `Module.DescentDatum.exact_mk_coactionSub` (`Descent/ModuleDescent.lean:247`):
    degree-≤1 **Amitsur exactness for an arbitrary `A`-module `N`** along faithfully
    flat `A → B`, i.e. exactness of `N → B ⊗[A] N → (coaction − 1⊗–)`; unit-of-descent
    iso `DescentDatum.unitEquiv` (:269).
  - `Module.FaithfullyFlat.existsUnique_tmul_one_eq` (`Descent/AmitsurEqualizer.lean:36`):
    the two-coprojection **face form** of degree-0 exactness — stated for an *algebra*
    coefficient `S₀`; the module-coefficient face form is a ~30-line transport of
    :247 in exactly the pattern this file already executes (brick T4-c).
  - Cocycle-level unit descent with the full `picClass` calculus incl.
    `picClass_eq_one_iff` (`Descent/UnitDescent.lean`) — available but **not needed**:
    route (ii) never descends a unit cocycle, only an additive H¹ element.
- Also landed and consumed by the close: `PicEtAff.unit_injective` — (C1), unconditional
  over every k-algebra test (`Picard/CechKernelLemma.lean:361-365`); the keystone
  `relPicAlgMap_congr` (`Picard/PicEtAff.lean:161`); `mapAlg` restriction with
  cover-base-change transport `descentBaseChange` (`Picard/PicEtAffMap.lean:275, :72`);
  the affine comparison `picEtAffineEquiv` (`Picard/PicEt.lean:235`);
  `Over.sectionsBaseChange` for any k-algebra coefficient
  (`Cohomology/SectionsBaseChange.lean`, docstring reserves `A = k[ε]` for this lane).

### 1(d) The R3 side probe — answered; details in appendix §5

`HasRingHomProperty.descendsAlong_flat` (`AlgebraicGeometry/Morphisms/FlatDescent.lean:156`)
does **NOT** instantiate at `Locally (IsStandardSmoothOfRelativeDimension n)` as-is: of
its three requirements, two are present and the third is a genuine mathlib absence
(`RingHom.CodescendsAlong (Locally (IsStandardSmoothOfRelativeDimension n))
RingHom.FaithfullyFlat`), though the probe found all raw material to build it as an [M]
brick. See §5.

---

## §2 Route assessment against the landed tree

Both routes cross the same bridge: the represented kernel lives in `picEt`/`PicEtAff`-land
(via `d.rep` + `picEtAffineEquiv`), T3's lives in `relPic`-land, and the landed dictionary
(`PicEtAff.unitEquiv_of_section`, `Picard/EffectivityClose.lean:186`) crosses only at
sectioned field tests. The crossing at a dual-number test = "the unit is bijective on the
ε-kernel". Injectivity is landed ((C1), any test). **Only surjectivity onto the ε-kernel
is open.**

A structural fact the probe surfaced, which reframes the comparison: **route (i) does not
avoid generalizing T3 beyond coefficient `k`.** Computing `ker(relPic(k̄[ε]) → relPic(k̄))`
is the T2/T3 engine with coefficient algebra `A = k̄` (section rings `B ⊗[k] k̄`, via
`Over.sectionsBaseChange`), not the currently-scoped `A = k` statement. Both routes
therefore amend t3; they differ only in *how far*.

### Route (i) — k̄-side splitting + comparison square. Enumerated needs:

| # | statement | status |
|---|---|---|
| i-1 | every `EtaleCover (K[ε])`, `K` sep. closed, admits a `K[ε]`-algebra section | to-build [S] — from `Etale.iff_exists_algEquiv_prod` (Etale/Field.lean:271) + `IsSepClosed.algebraMap_bijective` (IsSepClosed.lean:213) + `FormallySmooth.comp_surjective` (Smooth/Basic.lean:83) |
| i-2 | covers split ⇒ `PicEtAff.unit C (k̄[ε])`, `unit C k̄` bijective | to-build [S] — `relPicAlgMap_congr` (PicEtAff.lean:161) with `(j₁, j₂) = (id, taut ∘ section)` + C1 (CechKernelLemma.lean:361) |
| i-3 | ε-kernel of `relPic` at coefficient `k̄`: `ker ≃+ H¹(C_k̄,𝒪)` | to-build [M] — t3 amended to coefficient `k̄` (sectionsBaseChange landed) |
| i-4 | `H¹(C,𝒪) ⊗ k̄ ≃ H¹(C_k̄,𝒪)` | project in-flight — X3 (AJCR.w5-av.x3 active) |
| i-5 | pic0-kernel = picEt-kernel at dual numbers + affine collapse | to-build [S] — recon T1-note lemma + `picEtAffineEquiv` (PicEt.lean:235) |
| i-6 | close the **frozen numeral over k** from k̄-side data: either rel-dim descent along `Spec k̄ → Spec k` or a tangent base-change square `T₀(J)⊗k̄ ≃ T₀(J_k̄)` | to-build [M/L] — the descent instance is the **R3 mathlib absence** (§5: buildable [M] codescent brick); the base-change square at the pic0-kernel is *precisely route (ii)'s content at `k`* |

Hardest brick: **i-6** — it has no mathlib substrate and no project substrate, and every
version of it either builds the §5 brick or re-derives route (ii). Route (i) alone leaves
the T-chain's output stranded at `k̄`.

### Route (ii) — kernel-level cancellation over `k`, uniform in the base field. Enumerated needs:

| # | statement | status |
|---|---|---|
| ii-1 | **cover refinement at dual numbers**: every `EtaleCover (K[ε])` (`K/k` any field) is refined by `(ofField L).baseChange (K[ε])`, `L/K` finite separable | to-build [S/M] — `EtaleCover.baseChange` (EtaleCover.lean:238) to `K`; landed cofinality (:287); lift back through `FormallySmooth.comp_surjective` (Smooth/Basic.lean:83; kernel of `L[ε] → L` is square-zero); étale-ness of the refined cover by `Etale.baseChange` (Etale/Basic.lean:249) |
| ii-2 | **T3+ (= t3 re-scoped)**: `κ_A : ker(relPic C (A[ε]) → relPic C (A)) ≃+ H¹(C,𝒪) ⊗[k] A`, `A` a finite product of fields over `k`, **natural in `A`** | to-build [M/L] — T2 engine (t2 active) + `Over.sectionsBaseChange` [project-landed] + nilpotent unit lifting + `H¹ = coker` right-exactness; incl. the picFromBase collapse: `Pic` of a finite product of Artin local rings is trivial (see brick note, §3) |
| ii-3 | **module-coefficient Amitsur face form**: `A → B` f.flat, `N` an `A`-module, `x ∈ N ⊗[A] B` with equal coprojection faces in `N ⊗[A] (B ⊗[A] B)` ⇒ `∃! n, n ⊗ₜ 1 = x` | to-build [S] — transport of `exact_mk_coactionSub` [project-landed, ModuleDescent.lean:247] exactly as `AmitsurEqualizer.lean:36` did for algebra coefficients |
| ii-4 | **the close**: `PicEtAff.unit C (K[ε])` restricted to ε-kernels is bijective, every field `K/k` | to-build [M] — ii-1 + κ-naturality (ii-2) + ii-3 + landed mk-calculus (`mk_descentMap`, `mk_eq_mk_iff`, `descentBaseChange`); injectivity = C1 [project-landed] |
| ii-5 | **T4 output**: `ker(pic0(K[ε]) → pic0(K)) ≃+ H¹(C,𝒪) ⊗[k] K`, every field `K/k` | to-build [S/M] — i-5's collapse lemma + `picEtAffineEquiv` + ii-4 + `κ_K` |

Hardest brick: **ii-2** (T4-b below).

Proof plan for ii-4 surjectivity, checked against landed signatures: represent
`x ∈ ker(PicEtAff C (K[ε]) → PicEtAff C K)` on a cover; refine by ii-1 to carrier
`K[ε] ⊗[K] L`; triviality of the mod-ε class means triviality after a further finite
separable refinement `L → M` (landed cofinality + `mk_eq_mk_iff`), so after refining the
ε-side along `K[ε] ⊗[K] (L → M)` the representative `y'` dies mod ε **on the nose**:
`y' ∈ ker(relPic(M[ε]) → relPic(M)) = κ_M⁻¹(H¹ ⊗ M)`. The descent condition's two faces
live over `(K[ε]⊗[K]M) ⊗[K[ε]] (K[ε]⊗[K]M) ≅ K[ε] ⊗[K] (M ⊗[K] M)` ([S] tensor massage)
and are k-algebra maps of finite products of fields, so κ-naturality turns "equal faces"
into "equal faces of `κ_M y'` in `H¹ ⊗ (M ⊗[K] M)`"; ii-3 with `N = H¹ ⊗[k] K`
(`H¹ ⊗[k] A = (H¹ ⊗[k] K) ⊗[K] A` for K-algebras `A`, [XS]) produces the unique
`h ∈ H¹ ⊗ K`; `z := κ_K⁻¹ h ∈ ker(relPic(K[ε]) → relPic(K))` maps to `y'` by naturality
along `K → M`; `mk`-calculus (`tautological_mem_descentClasses` + `mk_descentMap`) gives
`x = unit z`. ∎-shape verified against every cited signature.

### Why (ii) over (i)

1. **Both** routes must re-scope t3 beyond coefficient `k`; (ii)'s extra generality
   (products of fields + naturality) buys the uniform-in-`K` output, while (i)'s
   (coefficient `k̄` only) buys a stranded-at-`k̄` output.
2. (ii)'s feared cancellation is **already landed** at module level
   (`ModuleDescent.lean:247`); only [S]-size transports remain. The R1 "Hilbert-90
   campaign" scenario is dead: the trunc-exp linearization (T2) happens *before* descent,
   so descent is additive.
3. (ii) hands **T5 the k-side scalar identity directly** (`finrank_k (H¹ ⊗ k) = genus C`
   with no base-change transport and no X3 dependency), hands **S1 its `k̄`-instance**
   (specialize `K := k̄`), and supplies the tangent base-change square
   `ker(K) ≃ ker(k) ⊗ K` that any future rel-dim argument wants — decoupling the T-chain
   from the R3 gap. X3 stays valuable for genus invariance elsewhere but exits T4's
   critical path.
4. (i) is contained in (ii): brick ii-1 specialized at sep-closed `K` + i-2 is the
   fallback close (§4). Nothing built for (ii) is wasted if we retreat.

---

## §3 Sub-brick decomposition (route (ii)) — sizes, gates, files

All statements against the standing curve bundle; nothing touches `Challenge.lean` or any
protected name; files chosen inside the D7 `Tangent/` allocation, away from every
never-touch lane. Lane protocol w5-worksheet §0 applies verbatim.

| brick | content | size | gate | file |
|---|---|---|---|---|
| **T4-a** | cover refinement at dual numbers (ii-1), + corollary: sep-closed base ⇒ section exists (= route (i)'s i-1, kept as the fallback's substrate) | S/M | none — launchable now (mathlib-only) | `Tangent/DualNumberEtaleCover.lean` |
| **T4-b** | ε-kernel with coefficients + naturality (ii-2); **absorbs t3** | M/L | t2 (trunc-exp engine, active) | `Tangent/RelPicEpsilonKernel.lean` (t3's D7 slot; splits if >500L) |
| **T4-c** | module-coefficient Amitsur face form (ii-3) | S | none — launchable now | `Descent/AmitsurEqualizerModule.lean` (new file; Descent/ is outside all frozen lanes) |
| **T4-d** | unit bijective on ε-kernels (ii-4) | M | T4-a + T4-b + T4-c | `Tangent/EtalePlusEpsilonKernel.lean` |
| **T4-e** | pic0-kernel export (ii-5): the T4 output statement consumed by T1's represented-kernel identification and T5 | S/M | T4-d | `Tangent/Pic0EpsilonKernel.lean` |

Brick notes (spelled here so no prover discovers them mid-brick, per D6):

- **T4-a**: state the refinement as an `EtaleCover (K[ε])`-refinement by
  `(EtaleCover.ofField L).baseChange (K[ε])` — never introduce a bespoke `L[ε]` cover
  object; dual-number carriers appear only through ONE pinned equiv
  `K[ε] ⊗[K] L ≃ₐ L[ε]` (coordinate the spelling with the t1 lane's `DualNumber` kit —
  inbox note on landing). The nontriviality of the mod-ε carrier is free (`ε` nilpotent ⇒
  `εB ⊆ nilradical B`, `B` nontrivial by `EtaleCover.nontrivial_carrier`).
- **T4-b interface (BINDING once ratified)**: `κ_A` for every k-algebra `A` that is a
  finite product of fields (each factor any extension of `k` — no finiteness), natural
  along all k-algebra maps of such `A`. This class contains everything ii-4 touches
  (`K`, `M`, `M ⊗[K] M` — the last is étale over the field `M` hence a finite product of
  fields by `Etale.iff_exists_algEquiv_prod`) and keeps the picFromBase correction
  trivial: `A[ε]` is then a finite product of Artin local rings, whose `Pic` vanishes —
  the "invertible over local is free" collapse; check `Descent/InvertibleModule.lean` /
  `Picard/PicAffine.lean` for the landed form before re-proving. The three iso steps
  (relPic-kernel → two-cover units-kernel → trunc-exp → `H¹ ⊗ A`) are each natural by
  construction **iff `A` is a variable from day one** — that is the whole re-scope.
- **T4-c**: copy the `AmitsurEqualizer.lean` transport with `S₀` demoted from algebra to
  module; the underlying exactness is already module-level.
- **T4-d**: the K-vs-k algebra towers are the known trap; use the
  `((algebraMap K L).comp (algebraMap k K)).toAlgebra` + low-priority-instance pattern
  documented in `Picard/DegreeZero.lean:229-239`.
- **T4-e**: the pic0→picEt kernel collapse is the one-lemma observation that any
  k-algebra map `K[ε] → F`, `F` a field, kills the nilpotent `ε`
  (`mem_pic0Subgroup_iff` + `degAt_picEtMap`, both landed, `Picard/Pic0Functor.lean:121/:87`).

Launch order: T4-a and T4-c now (parallel, no gates); T4-b on t2's close under the
re-scoped t3 lane; T4-d, then T4-e. T4-e's statement should be frozen (spec-doc-level)
before T1/T5 consume it.

---

## §4 Risk register

- **R-T4-1 (main): T4-b balloons.** Two internal cliffs: the `CechPic`-to-two-cover
  collapse for a variable coefficient (the landed refinement/injectivity files were
  written at fixed tests — check `Picard/CechPicSurjective.lean`/`RefinementInjectivity.lean`
  reusability early), and the picFromBase collapse if the Pic-triviality lemma is not
  cheaply available. **Mitigation**: the product-of-fields coefficient class (never
  general `A`); **fallback = route (i) degenerate**: T4-a's sep-closed corollary + i-2
  (unit bijective at `k̄[ε]`) + T4-b at the single coefficient `A = k̄` with NO naturality
  + X3 + queue the §5 codescent brick for S3. That fallback needs no T4-c and no
  naturality, keeps T4 ≤ [M], and moves the residual cost into S3 — acceptable, already
  R3-shaped.
- **R-T4-2: carrier-spelling drift** between T4-a, the t1 `DualNumber` port, and
  `Over.sectionsBaseChange` at `A = k[ε]`. Mitigation: ONE pinned equiv per pair, named
  in T4-a's spec; inbox note to the t1 lane.
- **R-T4-3: tower/instance diamonds** (`k ⊆ K ⊆ L` + `[ε]` everywhere). Known pattern
  (DegreeZero.lean precedent); budget line-count, not design.
- **R-T4-4: the ε-kernel's pic0-membership subtlety at non-reduced tests** (recon
  lower-order unknown): resolved by the probe — nilpotents die in fields, one lemma
  (T4-e note). No longer a risk.
- **R-T4-5: hidden dependence of T4-d on `Module.FaithfullyFlat K M`** for field
  extensions: trivial (nonzero vector spaces), [XS], but confirm the instance path
  before assuming `inferInstance`.
- Standing discipline: no `Classical.choose` extraction of representing objects (consume
  `d.rep` only — R5(i)); never register staged facts as instances; kernel-verify every
  port.

---

## §5 Appendix — the R3 side probe (feeds the future S3 worksheet)

**Question**: does `HasRingHomProperty.descendsAlong_flat`
(`AlgebraicGeometry/Morphisms/FlatDescent.lean:156`) instantiate at
`P := @SmoothOfRelativeDimension n`, `Q := Locally (IsStandardSmoothOfRelativeDimension n)`
(`Morphisms/Smooth.lean:154`)?

**Answer: NO as-is; YES after one buildable [M] mathlib-facing brick.** The lemma's three
requirements:

1. `[P.IsStableUnderBaseChange]` — **present** as the *lemma*
   `smoothOfRelativeDimension_isStableUnderBaseChange` (`Morphisms/Smooth.lean:166`), not
   an instance; a `haveI` suffices.
2. `[HasRingHomProperty P Q]` — **present**: the instance at `Morphisms/Smooth.lean:154`.
3. `h : RingHom.CodescendsAlong (Locally (IsStandardSmoothOfRelativeDimension n))
   RingHom.FaithfullyFlat` — **ABSENT**. The pinned mathlib provides
   `codescendsAlong_faithfullyFlat` only for FiniteType/FinitePresentation/Finite
   (`RingTheory/Finiteness/Descent.lean:120/:127/:134`) and
   Smooth/FormallyUnramified/Etale (`RingTheory/Etale/Descent.lean:95/:101/:108`) —
   exactly the five scheme instances of `Morphisms/LocalFlatDescent.lean:35-47`. No
   `Locally`-wrapped property has one, and `RingTheory/RingHom/Locally.lean` has no
   codescent lemma to lift one.

**The missing brick is genuinely buildable** — all raw material verified present:
via `RingHom.CodescendsAlong.mk` (`RingTheory/RingHomProperties.lean:246`), reduce to the
algebra-level statement "if `S ⊗[R] T` is locally-standard-smooth-of-rel-dim-`n` over `S`
faithfully flat over `R`, then `T` is so over `R`". Assemble from:
`RingHom.Smooth.codescendsAlong_faithfullyFlat` (Etale/Descent.lean:95) ⇒ `T/R` smooth ⇒
locally standard smooth; then pin the dimension chartwise by
`IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` — rel-dim `n` ⟺
`Module.rank S Ω[S⁄R] = n` on a standard-smooth chart
(`RingTheory/Smooth/StandardSmoothCotangent.lean:319`, rank lemma :313) — transported
along `Module.rankAtStalk` (`RingTheory/Spectrum/Prime/FreeLocus.lean:187`) with
`rankAtStalk_baseChange` (:326) and Kaehler base change
`KaehlerDifferential.tensorKaehlerEquiv` (`RingTheory/Kaehler/TensorProduct.lean:249`),
using surjectivity of `Spec (S ⊗[R] T) → Spec T` (faithful flatness) to see every prime.
Care point: bridge global `Module.rank` on a chart (free case) with `rankAtStalk`
(`rankAtStalk_eq_finrank_of_free`, FreeLocus.lean:254) and shrink to basic opens where
`Ω` is free (`FreeLocus` machinery, same file). Estimated [M], one file, genuinely
upstreamable to mathlib.

**Consequence for S3** (recorded, not decided here): with route (ii) landing the k-side
tangent count, S3 may never need this brick over `k̄→k`; but if S3's chart-dimension
uniformity argument prefers to live at `k̄` (translations by k̄-points), this brick is the
named [M] price of coming home, and `Spec k̄ → Spec k` is qc + flat + surjective, so the
`(@Surjective ⊓ @Flat ⊓ @QuasiCompact)` instance applies directly. Either way R3's
"[M]→[L] reshape" fear is bounded: the descent half is [M] with a full ingredient list;
what remains unprobed for S3 is only the *uniformity* half (rel-dim locally constant on
irreducible base), out of this lane's scope.

---

*End of draft. Ratification points for the orchestrator: (1) route (ii) adoption;
(2) the t3 re-scope to the T4-b interface (coefficient class = finite products of fields,
naturality); (3) the T4-a/T4-c immediate launches; (4) the fallback trigger (if T4-b's
collapse sub-brick exceeds [M] on its own, drop to the route-(i) degenerate and queue the
§5 brick).*

---

## §6 CLAUSE (iii) DECOMPOSED — worksheet-first pass, run 0073 r1 (task `ajcr-w5-av`)

*Added 2026-07-28 by the Wave-5 AV lane, discharging the WORKSHEET-FIRST obligation before
touching Lean. Both projects had converged on "clause (iii) alone" as the joint residue
(inbox I-0495) while describing it as a single opaque step. It is not one step. This
section splits it, and reports one **machine-verified simplification** that removes a
sub-cliff §4 named.*

### 6.0 The finding that changes the target statement: `picFromBase` is TRIVIAL at `k[ε]`

`R-T4-1` lists "the picFromBase collapse" as one of two internal cliffs of T4-b, to be paid
by finding or proving "`Pic` of a finite product of Artin local rings is trivial". **For the
dual-number test that entire brick is unnecessary, for a reason that has nothing to do with
Artin local rings.**

`relPic C T` is by definition `(C ⊗ T).left.CechPic ⧸ picFromBase C T`, and `picFromBase C T`
is the *range* of `CechPic.map (snd C T).left` — classes pulled back from `T`. Now
`AlgebraicJacobian/Picard/Pic.lean:257` already carries

```
instance CechPic.subsingleton_of_subsingleton (X) [Subsingleton X] : Subsingleton X.CechPic
```

and `T.left = Spec k[ε]` has a **one-point** underlying space (`PrimeSpectrum` of a local
ring with nilpotent maximal ideal). So `T.left.CechPic` is a subsingleton, its every element
is `1`, and the range of a group homomorphism out of it is trivial:

> **`picFromBase C T = ⊥` for every test object `T` with `Subsingleton T.left`** — in
> particular at `T = overDualNumber k` *and* at `T = 𝟙_`.

Consequences, all three checked by machine this session (`lean_run_code`, four probes, all
green — the statements are reproduced in §6.4):

1. `relPicMk C T` is **injective** as well as surjective, so `relPic C T ≃* (C ⊗ T).left.CechPic`
   at both ends of the ε-restriction. The quotient bookkeeping disappears from T3/T4's target.
2. T3/T4's target restates as a statement about **absolute** Čech Picard groups:
   `ker( CechPic(C_ε) → CechPic(C) ) ≃+ H¹(C, 𝒪_C)`. No coset calculus, no
   `relPicMk_eq_relPicMk_iff` range condition anywhere in the ε-kernel argument.
3. The `picFromBase` cliff of `R-T4-1` is **retired at the dual-number test**. It survives
   only for route (ii)'s general coefficient `A` (where `A[ε]` genuinely is a product of
   Artin local rings and `Spec A` is not a point) — so if the lane ever needs coefficient
   naturality it comes back, but the *numeral* does not wait on it.

**Why nobody had noticed**, worth recording because it is a recurring shape: the collapse was
being sought as a statement about `Pic` of a *ring* (Artin local ⟹ trivial Picard), which is
true but needs commutative algebra. The cheap route is topological and was already in the tree
— a one-point space has no nonconstant cover, hence no Čech `H¹` at all. The lemma had been
sitting in `Pic.lean` since the Picard-group file was written, with an `example` for `Spec` of
a field two lines below it, and the T4 worksheet (this document, §3 brick note T4-b) had asked
a *different* question of a *different* file (`Descent/InvertibleModule.lean` /
`Picard/PicAffine.lean`). Search for the shape of the object, not the shape of the argument.

### 6.1 What is actually left of clause (iii), in three parts

With §6.0 the residue is a statement about a two-chart cover of `C_ε`. Fix
`D : C.left.AffineTwoCover` (exists: `AffineTwoCover.nonempty_of_curve`) and write
`ρ₀, ρ₁ : Γ(X, V_i) →+* Γ(X, V₀ ⊓ V₁)` for the restrictions. The T2 engine already owns
everything on the right of

```
Γ(X,V₀⊓V₁)ˣ ⧸ cechCoboundaryUnits ρ₀ ρ₁   ←?→   X.CechPic
        ↑ (T2, LANDED: truncExpCechKernelAddEquiv, h1AddEquivTruncExpCechKernel)
      H¹(X, 𝒪)
```

so clause (iii) *is* the `←?→` arrow, at `X = C_ε`. It splits:

| part | statement | status / route |
|---|---|---|
| **(iii-a)** | the comparison map `twoChartClass : Γ(V₀⊓V₁)ˣ ⧸ cechCoboundaryUnits → X.CechPic` exists and is a group hom | **to build [M]** — §6.2. Pure Čech bookkeeping, no geometry, no dual numbers, any scheme |
| **(iii-b)** | it is **injective** | **[S], and the input is LANDED** — `CechPic.mk_eq_one_iff` (`RefinementInjectivity.lean:195`) is exactly refinement injectivity, so a two-chart cocycle dying in `CechPic` dies on the two-chart cover itself |
| **(iii-c)** | it is **surjective onto the ε-kernel** | **[M], gated on clause (i)** — §6.3. This is where `free_of_cyclic_mod_eps` is consumed, and it is the *only* part that is about dual numbers |

**The structural point, and the reason this split is worth the document:** (iii-a) and (iii-b)
are *not* about dual numbers, curves, or `H¹`. They are the general statement "the two-chart
Čech `Ȟ¹` of units embeds in the Picard group", true for any scheme with a two-open cover.
Only (iii-c) needs the thickening — and it needs clause (i), which is why clause (i) was the
right first clause to port even though its role was described only as "chart triviality".

**A correction to how both projects have been describing the residue.** The cross-project
thread (I-0495) says clause (iii) is "a kernel element goes to its transition unit under the
chart identifications", which reads as one map to be exhibited. Two thirds of it is a
cover-comparison that has no dual numbers in it, and the third that remains is a
*surjectivity* statement rather than the construction of a map. Sizing it as one step is how
it stayed opaque on both sides for a day.

### 6.2 (iii-a): the two-chart comparison map — construction, spelled out

`CechPic` is built on **pointed** covers (one open per point, `PointedCover`), so a two-open
cover enters through a selector.

* **Selector.** `σ : X → Bool` with `x ∈ V_{σ x}`, from `hcov : V₀ ⊔ V₁ = ⊤` by
  `by_cases x ∈ V₀`. Precedent for the pattern, including the `_of_mem` / `_of_notMem`
  rewrite pair: `thetaFieldChartIndex` (`Picard/DivisorFamilyFieldDictionaryCore.lean:196ff`)
  and `BasicOpenCocycleDatum.pieceIndex` (`Cohomology/GluedSheafClass.lean:250`). The pointed
  cover is then `opens x := V_{σ x}`.
* **Cocycle from one overlap unit.** For `u : Γ(X, V₀⊓V₁)ˣ` define the pair unit
  `pairUnit s t : Γ(X, V_s ⊓ V_t)ˣ` by `1, 1` on the diagonal, `u` at `(0,1)`, and the
  `inf_comm`-transport of `u⁻¹` at `(1,0)`; then
  `ev i j a b := restrict (T ≤ V_{σ i} ⊓ V_{σ j}) (pairUnit (σ i) (σ j))`.
* **Cocycle law** `ev i j * ev j k = ev i k`: eight `Bool` cases, each a restriction-compat
  computation; the four with `σ i = σ k` cancel `u·u⁻¹`, the four others are `1·u = u`.
  Checked by hand this session, all eight close.
  *Note the shape that does NOT work:* the slick spelling `u ^ (δ(σ j) − δ(σ i))` with
  `zpow_add` closing the law for free is **not available**, because on the diagonal `T` need
  only be `≤ V_s`, where `u` cannot be restricted at all. The exponent trick requires a unit
  living on the union; there isn't one. Case-bash is the honest route — budget lines, not
  design.
* **Descent to the quotient.** A chart unit `v ∈ Γ(V_s)ˣ` restricts to a coboundary: the
  `0`-cochain `α x := (v or 1 by σ x)` exhibits it. So `cechCoboundaryUnits ≤ ker`, and
  `QuotientGroup.lift` gives `twoChartClass`.

Everything cited above is landed and re-checked at HEAD this session.

### 6.3 (iii-c): surjectivity onto the ε-kernel is exactly where clause (i) is spent

Let `E ∈ CechPic(C_ε)` with `E|_C = 1`. Then on each thickened chart `V_{i,ε}`:
`V_{i,ε}` is affine, so `CechPic(V_{i,ε}) ≃* CommRing.Pic Γ(V_{i,ε})`
(`cechPicEquivPic`, `CechPicSurjective.lean:283` — the full affine dictionary, **landed**),
and `Γ(V_{i,ε}) ≅ Γ(V_i)[ε]` (clause (ii), `DualNumber.baseChangeAlgEquiv`,
`Tangent/DualNumberBaseChange.lean:119`, landed since 2026-07-17). The hypothesis says the
invertible `Γ(V_i)[ε]`-module is trivial mod `ε`; **clause (i)**
(`DualNumber.free_of_cyclic_mod_eps`, `Tangent/DualNumberChartTriviality.lean:132`) makes it
free. So `E` is trivial on both thickened charts, hence representable on the two-chart cover,
hence in the range of `twoChartClass`. ∎-shape.

**Gate, stated so no session mistakes it:** (iii-c) needs clause (i) *and* the affine
dictionary *and* clause (ii) — all three landed — plus the bookkeeping that turns "trivial on
each chart of a pointed cover refined by the two-chart cover" into "representable on the
two-chart cover". That last bookkeeping is the honest remaining cost and is **not** [S].

### 6.4 Probe record (so a later session does not redo it)

Four `lean_run_code` probes this session, all green, against the pinned checkout and HEAD:

1. `Subsingleton (overDualNumber k).left` — closes by
   `inferInstanceAs (Subsingleton (PrimeSpectrum (DualNumber k)))`.
2. `picFromBase C T = ⊥` for `[Subsingleton T.left]` — five lines, via
   `CechPic.eq_one_of_subsingleton`.
3. `Function.Injective (relPicMk C T)` under the same hypothesis — from 2 via
   `QuotientGroup.eq` + `Subgroup.mem_bot`.
4. `Function.Surjective (relPicMk C T)` — already landed as `relPicMk_surjective`.

Negative result worth keeping: the `zpow` spelling of the two-chart cocycle (§6.2) does not
typecheck, for the stated reason. Do not retry it.

### 6.5 Revised sizing of the lane

| item | old size | new size |
|---|---|---|
| picFromBase collapse at `k[ε]` | [S/M], listed as a T4-b cliff | **[XS] — DONE this session** |
| (iii-a) two-chart comparison hom | inside one opaque clause (iii) | [M], scheme-general, **transferable to AJC verbatim** |
| (iii-b) injectivity | " | [S], input landed |
| (iii-c) surjectivity on the ε-kernel | " | [M], gated on clauses (i)+(ii)+affine dictionary — all landed |

The lane's honest bottom line is unchanged in direction but sharper: after §6.0 the numeral
waits on **(iii-a) + (iii-b) + (iii-c)** and on nothing else, and two of those three are
dual-number-free general Čech theory that AJC can import rather than re-derive.

### 6.6 (iii-c) SPLITS AGAIN — and only the smaller half touches dual numbers

*Added later in the same session, after (iii-a)/(iii-b) landed (commits `428d0d4f7`,
`fb34e89f0`, `381a8050a`) and the probing of (iii-c) began. Recorded before writing its Lean,
per the same WORKSHEET-FIRST rule.*

The statement I first wrote for (iii-c) was

> `L : X.CechPic` restricting trivially to both charts ⟹ `L` is in the range of
> `twoChartClassHom`,

and probing it showed it is **two** statements, exactly as clause (iii) was three:

| part | statement | dual numbers? |
|---|---|---|
| **(iii-c1)** | every class *representable on the two-chart cover* is in the range of `twoChartClassHom` | **NO** — general Čech theory, like (iii-a)/(iii-b) |
| **(iii-c2)** | an `ε`-kernel class *is* representable on the two-chart cover | **YES** — this is where clause (i) is spent |

**(iii-c1) is a normalization statement, and the obstacle is genuine.** A general
`γ : X.unitsCocycle (twoChartCover V sel hmem)` is *not* of the form `twoChartCocycle u`: its
value at a pair `(x, x')` with `sel x = sel x'` lives on `V s ⊓ V s = V s` and is an arbitrary
unit there, whereas `twoChartPairUnit` is `1` on such pairs. Note carefully **why `ev_refl`
does not help**: it forces the value to `1` only when the two *indices* coincide, not when
their *opens* do — and on a pointed cover many points share a chart. So the same-chart values
are real data that must be normalized away.

The normalization is by an explicit `0`-cochain. Choose base points `base s` with
`sel (base s) = s` (this is where `Function.Surjective sel` is used a *second* time), and set

```
β x := γ.evInf x (base (sel x))    ∈ Γ(X, V (sel x))ˣ
```

— the type works out because `V (sel x) ⊓ V (sel (base (sel x))) = V (sel x) ⊓ V (sel x)` is
`V (sel x)` by `inf_idem`. **Type-checked by machine this session** (the `rw [twoChartCover_opens,
twoChartCover_opens, hbase, inf_idem]` chain elaborates). Conjugating `γ` by `β` kills the
same-chart values by the cocycle law, leaving a cocycle determined by its value at
`(base false, base true)`, which is the `u` wanted.

**Cost note, honest:** the *type* of `β` needs a `rw`-transport, and transporting it inside
*proofs* will meet the same `motive is not type correct` wall as
`twoChartCoboundary_of_pairRelation` (§6.2 / the file's docstring). The fix is the same —
abstract the chart index as a variable and `subst` — but it has to be done for each
same-chart case, so (iii-c1) is **[M]**, not [S]. Anyone starting it should write the
`subst`-shaped helper *first* and only then the normalization.

**(iii-c2) is the genuinely geometric half** and its route is §6.3 unchanged: on each
thickened chart `V_{i,ε}` — affine — the dictionary `cechPicEquivPic` plus clause (ii)
`baseChangeAlgEquiv` turn the class into an invertible `Γ(V_i)[ε]`-module, trivial mod `ε`;
clause (i) `free_of_cyclic_mod_eps` makes it free; so `L` is trivial on both thickened charts
and therefore representable on the two-chart cover. `Picard/EffectivityMoving.lean`
(`Opens.cechPicClass`, `cechPicMap_ι_eq_one_of_cechPicClass_eq_one`,
`Opens.cechPicClass_of_le`) is the landed bridge between "trivial in `CommRing.Pic` of the
chart sections" and "`CechPic.map (V s).ι L = 1`" — found this session, and it is the piece
that makes (iii-c2) assembly rather than construction.

**Revised residue of the whole lane:** (iii-c1) [M, dual-number-free, portable to AJC] +
(iii-c2) [M, all three inputs landed]. *(Amended 2026-07-28: this paragraph also ended "nothing
else stands between AJCR and the numeral". Incomplete for the same reason as §6.10's version —
the T2-to-comparison intertwining square is owed too. See the box in §6.10.)*

### 6.7 State of (iii-c1) at the end of run 0073 r1 — read this before starting it

What is **landed** towards it (`Tangent/TwoChartCechPic.lean`, sorry-free, commit
`e691846c1`):

* `mixedValue` — transport of an overlap unit along the chart indices by `subst`;
* `twoChartCandidate` — the candidate overlap unit `γ.evInf x₀ x₁` at points of the two
  charts;
* `twoChartCandidate_twoChartCocycle` — **it inverts**: the candidate of `twoChartCocycle u`
  is `u`. This pins the target, so (iii-c1) will be an inverse, not just a surjection.

What is **machine-checked but not yet committed as Lean** (probed this session, reproduce with
`lean_run_code`): the normalizing `0`-cochain

```
normCochain … x := γ.evInf x (base (sel x))   :  Γ(X, (twoChartCover V sel hmem).opens x)ˣ
```

constructs, via `rw [twoChartCover_opens, twoChartCover_opens, hbase, inf_idem]`. So the
*definition* is not the obstacle.

What remains is the **cohomology relation** itself:

```
normCochain x  *  γ.evInf x y  =  twoChartPairUnit (twoChartCandidate …) (sel x) (sel y)  *  normCochain y
```

restricted to `opens x ⊓ opens y`. The route is the cocycle law `unitsEvInf_trans` (landed)
plus `OneCocycle.ev_symm` to reverse a pair, in four `Bool` cases. The reason it was not
finished this session is not a mathematical obstruction but the case-by-case `subst`
bookkeeping the §6.6 cost note predicted: each of the four cases needs the chart indices
abstracted before the pair values can be compared, and the same-chart cases additionally need
`inf_idem` to line up two spellings of the same open.

**Advice to the next session, concretely:** prove the relation first as a statement about
*abstract* chart indices `s, t` with the pair values passed in as arguments (the shape of
`twoChartCoboundary_of_pairRelation`, which worked), and only then instantiate at
`sel x, sel y`. Do **not** try to `rw` inside the goal's types — that is the documented
`motive is not type correct` wall, and it will appear four more times here than it did in
(iii-b).

### 6.8 (iii-c1) IS CLOSED — and the cost §6.6/§6.7 predicted was **not** paid

*Run 0073 r2, `Tangent/TwoChartNormalize.lean` (267L, sorry-free, `lake env lean` exit 0).*

**The prediction was wrong in the cheap direction, and the reason is worth more than the
lemma.** §6.6 sized (iii-c1) as [M] because the normalizing `0`-cochain's *type* needed a
`rw [… inf_idem]` transport, and each of four `Bool` cases would then need the chart index
abstracted and `subst`ed — "it has to be done for each same-chart case". Neither cost exists:

* **Restrict along an inequality, not along an equality of opens.** `γ.evInf x (base (sel x))`
  lives on `V (sel x) ⊓ V (sel (base (sel x)))`. §6.6 proposed to *rewrite that type* down to
  `V (sel x)` via `hbase` and `inf_idem`. Instead **restrict** it along
  `V (sel x) ≤ V (sel x) ⊓ V (sel (base (sel x)))`. The result is `Γ(X, V (sel x))ˣ` **on the
  nose**: an inequality of opens is a `Prop`, so all the index bookkeeping moves inside
  `Prop`, where it is free. `hbase` is still needed — but only to *build* that inequality.
* **The conjugation identity is uniform in whether the charts agree.** `normCochain_conj` is
  three applications of one chart-level cocycle law (`cocycleValueOn_trans`) and holds for any
  `x, y` with no case split at all. The four-case `Bool` split survives only in
  `cocycleValueOn_base_eq_twoChartPairUnit`, where it is *identifying* the base values with
  `twoChartPairUnit` — two cases are `cocycleValueOn_self`, one is the candidate by definition,
  one its inverse by `cocycleValueOn_symm`. No case needs a transport.

**Generalisable rule, and it is the same lesson as §6.0 from the other side:** when a
`0`-cochain's type is *almost* right, look for a restriction map into the type you want before
reaching for a rewrite of the type. `rw`/`▸` inside a type is what produces the
`motive is not type correct` wall; a restriction along a `≤` never can, because `≤` is
proof-irrelevant.

**What landed** (all `Scheme`-namespaced, scheme-general, no dual numbers, portable to AJC):

| declaration | content |
|---|---|
| `cocycleValueOn` | a pair value restricted to any open below both charts |
| `cocycleValueOn_trans` | the cocycle law there — `unitsEvInf_trans` off the triple overlap |
| `cocycleValueOn_self`, `_symm` | trivial diagonal (landed `unitsRestrict_unitsEvInf_self`), antisymmetry |
| `normCochain` | the conjugating `0`-cochain, typed on the nose |
| `normCochain_conj` | the conjugation identity, uniform in `sel x = sel y` |
| `unitsRestrict_mixedValue`, `cocycleValueOn_eq_candidate` | the mixed base value **is** `twoChartCandidate` |
| `cocycleValueOn_base_eq_twoChartPairUnit` | the four-case identification with `twoChartPairUnit` |
| **`twoChartCocycle_isCohomologous`** | **(iii-c1) at cocycle level**: `γ ~ twoChartCocycle (candidate γ)` |
| **`twoChartClassHom_mk_range`**, **`twoChartClass_mk_range`** | **(iii-c1)**: every class represented on the two-chart cover is in the range |

With `twoChartClass_injective` (iii-b) this makes `twoChartClass` a **bijection** onto the
classes representable on the two-chart cover. `twoChartCandidate_twoChartCocycle` (the landed
left inverse) now has its right-inverse partner, so the pinning §6.7 wanted is complete.

**The residue of the whole lane is now exactly (iii-c2)**, and it is the geometric half:
an `ε`-kernel class is representable on the two-chart cover. Route unchanged from §6.6 — the
thickened charts are affine, `cechPicEquivPic` + clause (ii) `baseChangeAlgEquiv` present the
class as an invertible `Γ(V_i)[ε]`-module trivial mod `ε`, clause (i) `free_of_cyclic_mod_eps`
makes it free, and `Picard/EffectivityMoving.lean` is the landed bridge to
`CechPic.map (V s).ι L = 1`. All inputs landed; it is assembly, not construction.

**One thing NOT claimed.** (iii-c1) says *representable on the cover ⟹ in the range*. It says
nothing about which classes are representable — that is (iii-c2) and it is where every
dual-number hypothesis is spent. Do not read `twoChartClass_mk_range` as surjectivity of
`twoChartClass` onto `X.CechPic`; it is surjectivity onto the image of
`CechPic.mk (twoChartCover …)`, which for a general scheme is a proper subgroup.

### 6.9 (iii-c2) SPLITS, and the Zariski half needs NO affineness and NO dual numbers

*Worksheet-first pass, run 0073 r2, written before the Lean per the binding rule on T4.*

A scoped read of the tree (subagent, read-only) established one negative and one positive fact
that together change the shape of (iii-c2).

**The negative, and it is the honest crux.** *Nothing in the tree — at any generality — says
"a `CechPic` class trivial on every member of a cover is `CechPic.mk` of a class on that
cover".* Six search phrasings, plus a direct audit of `EffectivityMoving.lean`,
`EffectivityTrivialization.lean` and `CechPicSurjective.lean`. In particular
`EffectivityMoving.lean` is *one-directional*: `Opens.cechPicClass … = 1 ⟹ CechPic.map O.ι L = 1`
and nothing back. §6.6 called that file "the landed bridge that makes (iii-c2) assembly rather
than construction" — **that reading was too generous**, and I am retracting it here rather than
letting a later session discover it. `EffectivityMoving` bridges *into* the chart-triviality
hypothesis; the step *from* chart triviality to representability is unbuilt.

**The positive: chart triviality is exactly the right hypothesis, and it is Zariski.** Write
the target as

> **(iii-c2-Zar)** `L : X.CechPic` with `CechPic.map (V s).ι L = 1` for both `s : Bool`
> ⟹ `L` is representable on `twoChartCover V sel hmem`.

*No `IsAffine`, no `k[ε]`, no curve.* The proof:

1. `L = mk 𝒩 γ.class` (`CechPic.ind`).
2. For each `s`, feed `CechPic.map (V s).ι L = 1` to the **landed**
   `exists_trimmed_trivializing_of_cechPicMap_ι_eq_one` (`EffectivityTrivialization.lean:75`,
   *no affineness hypothesis*): a family `t s b : Γ(X, 𝒩.opens b ⊓ V s)ˣ` with
   `t s b · γ(b,b') = t s b'` on trimmed overlaps.
3. **The overlap unit.** The family `b ↦ t false b · (t true b)⁻¹`, on the opens
   `𝒩.opens b ⊓ V false ⊓ V true`, is **independent of `b`**: from step 2 at both `s`,
   `t s b' = t s b · γ(b,b')`, so the ratio picks up `γ(b,b')⁻¹ · … · γ(b,b')` — which cancels
   because *sections of a scheme are commutative rings and their units commute*. The opens
   cover `V false ⊓ V true`, so the landed `exists_unitsRestrict_eq`
   (`RefinementInjectivity.lean:76`) glues them to `u : Γ(X, V false ⊓ V true)ˣ`.
4. **The comparison.** On the common refinement `𝒲 := 𝒩 ⊓ twoChartCover`, whose member at `b`
   is `𝒩.opens b ⊓ V (sel b)` (`PointedCover.inf_opens`), the `0`-cochain
   `β b := t (sel b) b` conjugates `γ` into `twoChartCocycle u`:
   `β b · γ(b,b') = t (sel b) b' `, and `twoChartPairUnit u (sel b) (sel b') · β b'` is the same
   by the glue property of `u` at the point `b'`. Then `mk_unitsRes` on both sides.

**Two typing notes, both the §6.8 lesson again.** (a) `t` is indexed by `s : Bool`, so
`t (sel b) b : Γ(X, 𝒩.opens b ⊓ V (sel b))ˣ` typechecks **on the nose** at the `𝒲`-member — the
`Bool` index is instantiated, never transported. (b) The four-case split in step 4 is again an
*identification* of `twoChartPairUnit` values, not a transport: diagonals are `t s b' · (t s b')⁻¹`,
the mixed pair is the glue property, the reversed pair its inverse.

**What this buys, and it is the real point.** (iii-c2) is now
**(iii-c2-Zar) [M, scheme-general, dual-number-free, portable to AJC] + (iii-c2-aff)**, where

> **(iii-c2-aff)** for `L` in the `ε`-kernel, `CechPic.map (V s).ι L = 1` — i.e. the class is
> trivial on each *thickened* chart.

and **(iii-c2-aff) is where every geometric input goes**: the thickened chart is affine, so
`cechPicEquivPic` + clause (ii) `baseChangeAlgEquiv` present the class as an invertible
`Γ(V_i)[ε]`-module trivial mod `ε`, clause (i) `free_of_cyclic_mod_eps` makes it free, and
`Opens.cechPicMap_ι_eq_one_of_cechPicClass_eq_one` (`EffectivityMoving.lean:101`) converts that
back to `CechPic.map (V s).ι L = 1` — *this* is what `EffectivityMoving` is for, and pointed the
right way it does exactly the job §6.6 wanted from it.

So the affineness and the dual numbers are confined to (iii-c2-aff), and the cohomological
bookkeeping — the part that was sized "not [S]" — is Zariski and general. Doing (iii-c2-Zar)
first is strictly better than attacking (iii-c2) whole: it is the larger half, it needs none of
the curve hypotheses, and AJC can take it.

### 6.10 (iii-c2-Zar) IS CLOSED — the whole Zariski half, same session

*`Tangent/TwoChartRepresentable.lean` (327L, sorry-free, `lake env lean` exit 0).*

`Scheme.twoChartClassHom_surjOn_of_chartTrivial`:

> `L : X.CechPic`, `∀ s : Bool, CechPic.map (V s).ι L = 1`
> ⟹ `∃ u, twoChartClassHom V sel hmem u = L`.

**No `IsAffine`, no dual numbers, no curve, no `Function.Surjective sel`.** The §6.9 plan went
through unchanged; the supporting declarations are `IsTrimmedTrivializing` /
`exists_isTrimmedTrivializing` (the landed affineness-free trimmed cochain, renamed),
`ratio_agree` + `exists_overlapUnit` (steps 2–3), `pairCochain` /
`isTrimmedTrivializing_pairCochain` / `selCochain`, `pairCochain_pairUnit_at` (the four-case
core), `pairCochain_conj` and `pairCochain_conj_inv`.

Three things worth recording for the next session in this file:

1. **`group` does not use commutativity.** Every unit group here is abelian, but `group`
   normalises only in the free group, so the cancellations need `mul_comm` /
   `mul_inv_cancel_left` / `inv_mul_cancel` written out. Several apparent dead ends this session
   were only this.
2. **The coboundary convention fixes the orientation, and getting it wrong costs a rewrite of
   three statements.** `unitsCocycle_isCohomologous` wants `α b · γ₁(b,b') = γ₂(b,b') · α b'`
   with `γ₁` the *normalized* cocycle. With `u := t₀ · t₁⁻¹` the conjugating cochain is
   therefore `t⁻¹` (`selCochain` returns the inverse), and `pairCochain_conj_inv` is the
   orientation the consumer takes. Decide `u`'s orientation *before* writing the four cases.
3. **`rw` under an elided restriction argument fails** with a spurious `X.presheaf` type
   mismatch, because the two sides carry different (proof-irrelevant, hence displayed as `⋯`)
   inequality proofs. The fix is never to fight it: state the step as a `have` with the
   inequalities named, and close with `exact` / `congrArg`. Same family as the §6.8 lesson.

**A SECOND OBLIGATION, found by applying inbox `I-0571`'s safeguard to my own split — record
this before anyone treats the T4 chain as "(iii-c2-aff) and then arithmetic".**

`I-0571`'s rule is: *a restatement is only a reduction if you prove the converse*, and the
adjacent trap is the one my own lane shipped in run 0073 r1 — an isomorphism at each end of a
map says nothing about the map, and the consumer computes a **kernel**. Checked at HEAD, and it
applies here:

* **T2's engine** (`h1AddEquivTruncExpCechKernel`) computes `ker(unitsReduction X U₀ U₁)`, where
  `unitsReduction` is a map **between the two Čech unit quotients** —
  `Γ(U₀⊓U₁)[ε]ˣ/coboundaries → Γ(U₀⊓U₁)ˣ/coboundaries`.
* **My comparison** (`twoChartClass`) maps *each* such quotient into its own `X.CechPic`.
* **What is NOT in the tree:** any statement that these commute — i.e. that
  `twoChartClass` at `C_ε` followed by `CechPic.map` (restriction along `ε ↦ 0`) equals
  `unitsReduction` followed by `twoChartClass` at `C`. Searched by name and by shape;
  `grep` for `twoChartClass` outside its three home files returns **nothing**, so no consumer
  has yet needed it and nothing supplies it.

**AND A SECOND ABSENT STEP, found by the reviewer pass and NOT by me (inbox `I-0573`): the
carrier translation at `C_ε`.** T2's engine computes `Ȟ¹ˣ` of `Γ(X, U₀ ⊓ U₁)[ε]` — the
`DualNumber` of the **original** sections (`TruncExpCechH1.lean:134`). `twoChartClassHom`
consumes `Γ(X_ε, V₀ ⊓ V₁)ˣ` — the **thickened** sections. *Nothing identifies them.* The bridge
would be `Over.sectionsBaseChange` (`Cohomology/SectionsBaseChange.lean:287`) composed with
`DualNumber.baseChangeAlgEquiv` (`Tangent/DualNumberBaseChange.lean:119`), plus
`sectionsBaseChange_naturality` (:337) for the two restrictions — but **no declaration composes
them**; only a docstring at `DualNumberBaseChange.lean:116` asserts the composite. So "clause (ii)
is landed" is true of the *algebra* equivalence and false of the *cover-level* translation the
comparison needs.

**Consequence for sizing, stated plainly:** (iii-c2-aff) is the last *geometric* clause, but it
is **not** the last clause. The chain from `H¹(C,𝒪)` to `ker(relPic(k[ε]) → relPic(k))` also
needs that **intertwining square**. It should be cheap — both sides are induced by restriction
of overlap units, so it ought to reduce to `unitsRestrict` functoriality on representatives via
`twoChartClass_mk` and `CechPic.map_mk` — but *cheap is not landed*, and pricing it at zero is
exactly the error `I-0571` names. Do not claim T5's numeral until it exists.

**Residue of the entire T4 lane after this: (iii-c2-aff) alone** — an `ε`-kernel class is
trivial on each thickened chart. That is the geometric statement, with all three inputs landed
(clause (i) `free_of_cyclic_mod_eps`, clause (ii) `baseChangeAlgEquiv`, the affine dictionary
`cechPicEquivPic`) and `Opens.cechPicMap_ι_eq_one_of_cechPicClass_eq_one` as the exit. It is the
last clause needing *geometry*; **two further steps are owed and both are bookkeeping rather
than mathematics** — the carrier translation at `C_ε` and the reduction square, both boxed
above. Reviewer-confirmed absent at HEAD (`I-0573`). **Corrected 2026-07-28: an earlier
draft of this line said "nothing else stands between AJCR and the T5 numeral" — that was wrong
by exactly the omission the box above documents.**

### 6.11 Start-of-session checklist for (iii-c2-aff) — the import graph is clear

*Measured at the end of run 0073 r2, so the next session need not re-check.*

**The statement to prove**, phrased to plug straight into `twoChartClassHom_surjOn_of_chartTrivial`:

```
L : (C ⊗ overDualNumber k).left.CechPic,   L restricting trivially to C   ⊢   ∀ s : Bool,
  Scheme.CechPic.map (V s).ι L = 1
```

for `V` the two *thickened* charts. Then (iii-c2-Zar) gives the overlap unit, (iii-c1) pins it,
(iii-b) makes the assignment injective, and the T2 engine converts to `H¹(C, 𝒪)`.

**No import cycles stand in the way** — a new module may import `Tangent/TwoChartRepresentable`
together with *all five* inputs. Transitive closures measured at HEAD: `TwoChartRepresentable`
(57), `Picard/EffectivityMoving` (54), `Tangent/DualNumberChartTriviality` (3),
`Tangent/DualNumberBaseChange` (2), `Picard/CechPicSurjective` (21),
`Tangent/RelPicPointTest` (13) — **none of them imports `TwoChartRepresentable`**, and none is
already in its closure. So the assembly module is a fresh leaf; no import inversion to
negotiate (contrast the `rr.principal` situation, which was blocked by exactly that).

**Order to work in**, cheapest diagnostic first:
1. ~~Confirm each thickened chart `V s` of `C_ε` is an **affine open**.~~ **ALREADY LANDED — do
   not build it.** `relCover C R D : (relCurve C R).AffineTwoCover`
   (`Cohomology/RelativeTwoCover.lean:128`) is the base-changed two-cover for *any* test ring
   `R`, defined as `D.pullbackProd R`, with `relCover_isAffineOpen₀ / ₁` and `relCover_sup`
   beside it. Instantiate at `R := DualNumber k`; note `relCurve C R` is *by definition*
   `(C ⊗ overSpec k R).left`, which is the carrier the ε-kernel already lives on. The
   `AffineTwoCover` structure also carries `isAffineOpen_inf`, so the **overlap** is affine
   too — which the affine dictionary needs and which a hand-rolled cover would have owed.
2. `cechPicEquivPic` at `V s` to land in `CommRing.Pic Γ(V_{s,ε})`, then clause (ii)
   `baseChangeAlgEquiv` to rewrite `Γ(V_{s,ε}) ≅ Γ(V_s)[ε]`.
3. Clause (i) `free_of_cyclic_mod_eps` for freeness. **Note its shape before planning:** it wants
   a generator `m` and the hypothesis `∀ x, ∃ r, x - r • m ∈ span{ε} • ⊤`, i.e. cyclic *mod* `ε`
   — that is where "trivial after restriction to `C`" is spent, and it is a module statement, so
   expect a sheaf→module step (the sibling project was flagged for eliding exactly this, inbox
   `I-0533`; do not repeat it silently).
4. `Opens.cechPicMap_ι_eq_one_of_cechPicClass_eq_one` to exit back to
   `CechPic.map (V s).ι L = 1`.

### 6.12 THE REDUCTION SQUARE IS **NOT** A COHOMOLOGY ARGUMENT — the cocycles are equal

*Worksheet-first pass, run 0073 r3, written before the Lean per the binding rule on T4.
LSP-measured on scratch before anything was committed; every claim below is machine-checked,
not predicted.*

§6.10's box owed step (c), "the reduction square intertwining `twoChartClass` with
`unitsReduction`", and priced it *cheap but not landed*. Cheap was right. **The reason it is
cheap is not the one §6.10 gave**, and the difference decides how to state it.

§6.10 guessed the square would "reduce to `unitsRestrict` functoriality on representatives via
`twoChartClass_mk` and `CechPic.map_mk`" — i.e. an argument at the level of *classes*, where the
two sides would agree up to a coboundary. Measured: the two sides agree **on the nose, as
cocycles**, before any quotient is taken. So the square is a `OneCocycle.ext` and four `Bool`
cases of `simp`, with no cohomology and no coboundary bookkeeping anywhere.

**The three facts that make it collapse, all confirmed by LSP probe:**

1. **`(twoChartCover V sel hmem).pullback f = twoChartCover (f ⁻¹ᵁ V ·) (sel ∘ f.base) _`
   holds by `rfl`.** Both sides are `fun x ↦ f ⁻¹ᵁ V (sel (f.base x))` after unfolding
   `PointedCover.pullback` and `twoChartCover`; the `mem_opens` fields are proof-irrelevant.
   *This is the whole reason there is no transport.* The predicted difficulty — "the pulled-back
   cover is a different cover, so the classes live in different `unitsH1` groups and must be
   compared along a refinement" — does not arise: they are the *same* cover.
2. **`f ⁻¹ᵁ V false ⊓ f ⁻¹ᵁ V true = f ⁻¹ᵁ (V false ⊓ V true)` holds by `rfl`** (not merely by
   `Scheme.Hom.preimage_inf`), so the pulled-back overlap unit is typed on the nose at the
   preimage-chart overlap and needs no `Opens` rewrite either.
3. **The four-case core is one `simp only`.** With `pbUnit f u := f.unitsAppLE (V₀ ⊓ V₁) (f⁻¹V₀ ⊓ f⁻¹V₁) le_rfl u`,
   the identity `f.unitsAppLE _ _ _ (twoChartPairUnit u s t) = unitsRestrict _ (twoChartPairUnit (pbUnit f u) s t)`
   closes by `cases s <;> cases t <;> simp only [twoChartPairUnit, map_one, map_inv,
   Hom.unitsAppLE_map, Hom.map_unitsAppLE]`. Diagonals are `map_one`; the `(1,0)` case is
   `map_inv` plus the two `unitsAppLE` commutation lemmas, which already handle the `inf_comm`
   restriction inside `twoChartPairUnit`.

**One trap, and it is §6.8/`I-0554`'s again in a new place.** In the cocycle-level lemma the
pair indices are `sel (f.base x)` and `sel (f.base y)` — *terms*, not variables. Writing
`cases h : sel (f.base x)` fails with **`generalize failed: result is not type correct`**,
because the type `Γ(X, V (sel (f.base x)) ⊓ …)ˣ` mentions the term being generalized. The fix is
not `subst` this time: state the four-case identity as a **standalone lemma in `s t : Bool`**
(where they *are* variables, so `cases` is free) and apply it at the instantiated indices. Rule,
now twice-confirmed in this lane: *never case-split on a `Bool` that a dependent type mentions —
factor the split into a lemma quantified over that `Bool` first.*

**What this changes about the shape of the residue.** The square is scheme-general: it is a
statement about an arbitrary `f : X ⟶ Y` and an arbitrary two-open family on `Y`, with **no
dual numbers, no affineness, no curve, and no `Function.Surjective sel`**. So it belongs beside
(iii-a)/(iii-b) in `TwoChartCechPic`-land, not in the dual-number files, and AJC can take it as
directly as it can take the other four clauses. In particular it is *not* specific to the `ε ↦ 0`
map, which is only the instance the T2 engine consumes.

**Consequence for §6.10's box, stated plainly.** Step (c) is discharged by a general naturality
lemma rather than by an `ε`-specific one; what remains owed of the intertwining is only the
*carrier* half, step (b) — identifying `Γ(X_ε, f⁻¹(V₀ ⊓ V₁))` with `Γ(X, V₀ ⊓ V₁)[ε]` so that
`pbUnit` along `ε ↦ 0` becomes `unitsFst`. That is genuinely a different statement: (c) is about
covers and cocycles and is now general; (b) is about *rings* and needs `sectionsBaseChange ∘
baseChangeAlgEquiv`. Do not let the two be conflated again — the reason §6.10 could believe (c)
was `unitsRestrict` functoriality is that it was half-thinking of (b).

**LANDED**: `Tangent/TwoChartNaturality.lean` (204L, sorry-free, `lake env lean` exit 0) —
`pullbackOverlapUnit`, `twoChartCover_pullback`, `unitsAppLE_twoChartPairUnit`,
`map_twoChartCocycle`, `map_twoChartClassHom`, `map_twoChartClassHom_eq_one_iff`.

### 6.13 STEP (b) SPLITS, AND ONLY THE COEFFICIENT HALF IS LEFT

*Worksheet-first pass, run 0073 r3, LSP-measured before the Lean.*

Step (b) — the carrier translation — is **two** statements, and the split is not the one §6.10
implied ("compose `sectionsBaseChange` with `baseChangeAlgEquiv`, plus
`sectionsBaseChange_naturality` for the two restrictions"). That description covers the
**open** direction only. The `ε`-kernel computation also needs the **coefficient** direction:
the map induced by `ε ↦ 0` must become `TrivSqZeroExt.fst`. Naming them:

> **(b-open)** `Γ(C, W)[ε] ≃+* Γ(C_ε, fst⁻¹ W)`, naturally in `W ≤ W'`.
> **(b-coeff)** across that equivalence, the section map induced by `overDualNumberZero`
> **is** `fstHom` — equivalently, `unitsFst` on units.

**(b-open) IS LANDED** — `Tangent/DualNumberCarrier.lean` (sorry-free, `lake env lean` exit 0):
`Over.dualNumberSections` and its affine form, `Over.resHom_dualNumberSections`, and the unit
forms `Over.dualNumberSectionsUnits` / `Over.unitsMap_resHom_dualNumberSectionsUnits`. The
composite the §6.10 box found *asserted in a docstring and absent as a declaration* now exists.
Cost was as predicted, and one factorization paid for itself: the coefficient naturality of the
algebra comparison, `TruncExpCech.baseChangeAlgEquiv_symm_map`, was proved **for an arbitrary
`f : A →ₐ[k] B]`** rather than just for the restriction — so (b-coeff)'s algebra half is
already in hand.

**(b-coeff) IS NOT LANDED, and here is the concrete obstruction — measure it before pricing.**
The tree's coefficient-direction tool is `AlgebraicGeometry.relSectionsMap`
(`Cohomology/RelativeSectionsLinear.lean:193`), with `relSectionsMap_resHom`,
`relSectionsMap_smul`, `relSectionsMap_overAlgebraMap` beside it — exactly the right shape. It
does **not** apply off the shelf: its binders are `[Algebra R R'] [IsScalarTower k R R']`, and
at `R := k[ε]`, `R' := k` the instance **`Algebra k[ε] k` does not exist** (LSP-confirmed:
`failed to synthesize Algebra k[ε] k`). The reduction `fstRingHom : k[ε] →+* k` *is* a
`k`-algebra map, but it is not registered as an algebra *structure*, and registering it globally
would collide with `Algebra k k`.

So (b-coeff) has three honest routes, and a session should pick deliberately rather than
discover this again:

1. **Generalize `relSectionsMap` from `[Algebra R R']` to a bare `f : R →ₐ[k] R'`.** The
   cleanest, and the file's own proofs look like they only use `algebraMap R R'` through
   `overSpecMap`, which is `Spec` of a ring map — but this edits a file other lanes consume, so
   check consumers first. Note `Over.overSpecMap` already takes an `AlgHom` in one spelling
   (`ThetaShift.lean:88`'s `toBaseTest_overSpec` mentions `Over.overSpecMap (Algebra.ofId k A)`),
   so the generalized form may already be available under another name — **search before
   editing**.
2. **A local `letI : Algebra k[ε] k := fstRingHom.toAlgebra` at the use site**, with
   `IsScalarTower k k[ε] k` proved by hand. Cheap, contained, and it is a `letI` so it cannot
   leak into instance search elsewhere. Risk: the `IsScalarTower` may not hold on the nose with
   the `Algebra k k[ε]` that `overDualNumber` uses — check that *first*, it is one probe.
3. **Bypass the coefficient square entirely.** `overDualNumberZero` is a morphism of test
   objects, so `C ◁ overDualNumberZero` gives the scheme morphism directly, and its `appLE` on
   the preimage opens is the map wanted; identify *that* with `fstHom` through
   `sectionsBaseChange_one_tmul` / `_tmul_one` rather than through `relSectionsMap`. Most
   elementary, most bookkeeping.

**Do not restate (b-coeff) as landed on the strength of (b-open).** This is `I-0571`'s rule at
one remove: the equivalence exists at each `W`, and *that says nothing about the reduction map*
— which is the whole content, and the third time this lane has had to write that sentence.

### 6.14 (b-coeff) IS CLOSED — route 2 won, and the obstruction was an INSTANCE not a theorem

*Same session (run 0073 r3), written after the Lean because §6.13's three routes were the
worksheet-first pass for it; this section records which one paid and why.*

**Route 2 wins outright.** `Tangent/DualNumberCarrierReduction.lean` (sorry-free, `lake env
lean` exit 0): `Over.relSectionsMap_dualNumberSections` and its unit form
`Over.relSectionsMapUnits_dualNumberSectionsUnits`. So all three steps §6.10 owed — (iii-c2-aff)
aside — are landed, and **(iii-c2-aff) is now genuinely the last statement in the T4 chain.**

Two `scoped` instances in `namespace TruncExpCech.EpsilonReduction` — `epsAlgebra` (from
`fstHom.toAlgebra`) and `epsIsScalarTower` — and then the **entire** landed `relSectionsMap`
calculus applies unchanged. `relSectionsMap_pullback` handles the curve-pullback factor,
`relSectionsMap_overAlgebraMap` the structure factor, and the identification is *`rfl`*: with
`epsAlgebra` in scope, `algebraMap k[ε] k` **is** `TrivSqZeroExt.fst`, so the reduction computes
itself and the `ε` component dies because `fst ε = 0`. Zero new geometry.

**The generalisable point, and it is a pricing lesson not a Lean one.** §6.13 named the
obstruction correctly (`Algebra k[ε] k` absent) but implicitly treated it as a *mathematical*
gap in the tree's coefficient layer — the three routes were all about restructuring something.
It was neither: it is a **missing instance for a theorem that already existed**, and a `letI`-
scale fix unlocks a whole landed API. Rule, and it generalises past this file: *when a landed
lemma "does not apply", check whether what is missing is an instance rather than a hypothesis —
an absent instance looks exactly like an absent theorem in the error message, and costs three
orders of magnitude less.* Compare `I-0555` (side conditions that were instance keying) and
`I-0570`'s converse; this is the same family from the coefficient side.

**Why `scoped` and not global**, recorded so nobody promotes it: a global `Algebra k[ε] k`
diamonds with `Algebra k k` and makes `algebraMap` ambiguous at every site that mentions both.
`scoped` costs a consumer one `open` and nothing else.

**Two `rw` walls, both the elided-restriction family of §6.10(3), both closed as terms** — the
standing rule in this lane is *never fight that wall, restate and `exact`*:

1. `map_add` of `relSectionsMap` will not `rw` into a goal spelled `(C ⊗ overSpec k R).left`
   when the lemma is stated at `relCurve C R`. They are `rfl`, not syntactically equal, and
   `rw` matches syntactically. Apply `RingHom.map_add` as a **term** and chain with `.trans`.
2. The residual `a + 0 = a` likewise resists `rw [add_zero]`; `exact add_zero _` closes it.

**And one diagnostic trap that cost two wrong line numbers.** `open CategoryTheory` **shadows
`Algebra`**, so `instance foo : Algebra (DualNumber k) k` elaborates against the wrong constant
— and the resulting *"typeclass instance problem is stuck"* error is reported at the **next**
declaration, not at the shadowed one. Spell it `_root_.Algebra` in any file that opens
`CategoryTheory`, and when a stuck-instance error names a declaration that looks fine, suspect
the one above it.

### 6.15 (iii-c2-aff): the sheaf→module step is ALREADY IN THE TREE, and the risk was mis-sited

*Worksheet-first pass, run 0073 r3, written before the Lean per the binding rule on T4.
Every claim LSP-measured on scratch.*

§6.11 step 3 flagged the honest risk: *"it is a module statement, so expect a sheaf→module step
(the sibling project was flagged for eliding exactly this, inbox `I-0533`; do not repeat it
silently)."* Measured, **that step does not have to be built** — it is
`Scheme.Opens.cechPicClass` (`Picard/EffectivityMoving.lean:83`) together with mathlib's
`CommRing.Pic.AsModule`, and the two compose without a gap:

* `Opens.cechPicClass hO L : CommRing.Pic Γ(Z, O)` is the class of `L` on an affine open,
  already defined and already the *ring*-level object;
* mathlib's `CommRing.Pic.AsModule` turns any `Pic R` element into an invertible `R`-module,
  with `CommRing.Pic.mk_eq_self : Pic.mk R M.AsModule = M` as the round trip and
  `CommRing.Pic.mk_eq_one_iff_free : Pic.mk R M = 1 ↔ Module.Free R M`;
* `Opens.cechPicMap_ι_eq_one_of_cechPicClass_eq_one` (`:101`) is the exit back to
  `CechPic.map (V s).ι L = 1`.

So the risk `I-0533` names is real *in general* but **not sited here**: this project's affine
dictionary was built ring-level from the start, and `EffectivityMoving`'s own
`cechPicClass_basicOpen_eq_one_of_free` (`:159`) already consumes `.AsModule` in exactly this
way — i.e. the pattern is not merely available, it is **in use**. Do not re-derive it and do not
carry the risk forward.

**The chain, decomposed into three steps, all three measured on scratch:**

1. **[XS, MEASURED]** the algebra core. For `M : CommRing.Pic (DualNumber A)` with a generator
   `m` of `M.AsModule` cyclic mod `(ε)`, `M = 1`:
   `rw [← Pic.mk_eq_self, Pic.mk_eq_one_iff_free]; exact free_of_cyclic_mod_eps A M.AsModule m h`.
   Two lines. Clause (i) plugs straight in.
2. **[XS, MEASURED]** transport along a ring **equiv**. Triviality of
   `Pic.mapRingHom (e : Γ(Z,O) →+* A[ε])` implies triviality of the original class: apply
   `mapRingHom e.symm`, then `mapRingHom_mapRingHom` + `e.symm_apply_apply` + `mapAlgebra_self_apply`.
   This is `EffectivityMoving`'s `private pic_eq_one_of_mapRingHom` specialised to an equiv —
   *and it re-derives from public API in three lines*, so `private` is not a wall here either
   (the standing lesson of `I-0567`; do not price a PR for it).
3. **[the real work]** produce the generator and its cyclicity from *"`L` restricts trivially to
   `C`"*. This is where the geometry is, and it is the only genuinely open part: steps 1 and 2
   are transport, step 3 is the hypothesis `hL : CechPic.map (ι of C_ε ← C) L = 1` being spent.

**What (b-open) buys step 2 concretely.** The ring equiv `e` that step 2 needs at the thickened
chart `V s` is exactly `Over.dualNumberSectionsOfIsAffineOpen`
(`Tangent/DualNumberCarrier.lean`), landed earlier this session. Before that file existed, step
2 had no `e` to transport along — which is why §6.10 was right that (b) blocks the chain even
though it is bookkeeping.

**Sizing after this measurement: (iii-c2-aff) = [XS] + [XS] + step 3.** The earlier sizing
priced the whole clause as the geometric block; two of its three steps are transport that
already exists. Step 3 remains, and *it should be sized on its own* rather than inheriting the
old estimate.
