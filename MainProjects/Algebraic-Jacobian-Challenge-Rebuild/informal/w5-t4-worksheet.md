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
at `R := k[ε]`, `R' := k` the instance ~~**`Algebra k[ε] k` does not exist**~~ **is not found by
synthesis** (LSP-confirmed: `failed to synthesize Algebra k[ε] k`) — **but it does exist upstream**:
`TrivSqZeroExt.algebraBase` (`Mathlib/Algebra/TrivSqZeroExt/Basic.lean:890`) is deliberately *not* an
instance. See the §6.19 retraction; do not repeat "absent" from a failed synthesis.
The reduction `fstRingHom : k[ε] →+* k` *is* a
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

**Why `scoped` and not global**, recorded so nobody promotes it: ~~a global `Algebra k[ε] k`
diamonds with `Algebra k k` and makes `algebraMap` ambiguous at every site that mentions both.~~
**That reason was invented (see §6.19; different types cannot clash).** Mathlib's actual reason for
keeping `algebraBase` a non-instance is the clash at `Algebra (tsze R' M) (tsze R' M)` with
`algebra'`. `scoped` costs a consumer one `open` and nothing else.

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

### 6.16 STEP 3 IS SMALLER THAN §6.15 SAID — the generator came from the sibling, not from geometry

*Run 0073 r3, after §6.15. This is a correction to §6.15's own sizing, made the same session.*

§6.15 called step 3 "where the geometry is, and the only genuinely open part". **Half of it was
not geometry at all**, and the sibling project proved that half while this session was running:
`ajc-pic0av` posted `Submodule.exists_sub_smul_mem_of_quotient_cyclic` on the cross-project
thread (`I-0495` C-0036, AJC commit `c1ed5be8b`).

**The content.** The "fixed `m` with `∀ x, ∃ r, x - r • m ∈ (ε)·M`" binder — which both projects
had been carrying as open work — **is cyclicity of `M ⧸ (ε)·M` written without naming the
quotient.** Producing `m` is `Submodule.Quotient.mk_surjective` on the generator plus
`mk_eq_zero`: take a preimage `m` of the generator `y`, pick `r` with `⟦x⟧ = r • y`, and
`⟦x - r•m⟧ = 0`. Arbitrary commutative ring, no finiteness, no scheme, no dual numbers. The
**converse** is included, so per `I-0571` it is a strict reduction rather than a restatement.

**Ported, not re-derived**: `Tangent/CyclicQuotientGenerator.lean`, with
`Opens.cechPicMap_ι_eq_one_of_dualNumberChart_of_cyclic` in `DualNumberChartPic.lean` consuming
cyclicity directly. This is what the cross-project thread exists for — two lanes had the same
obligation open on the same day and only one of them had to pay for it.

**ONE REAL DEVIATION, and it is worth recording because "ports verbatim" was said and was very
nearly true.** The sibling's `free_of_quotient_eps_cyclic` is stated at `M : Type v` independent
of `A : Type u`. AJCR's `free_of_cyclic_mod_eps` is universe-**monomorphic** (`M : Type u`), so
the port had to be pinned to `Type u`. It cost one line and a `lake env lean` cycle. Rule:
*a cross-project port can be mathematically identical and still fail to elaborate on a universe
binder* — check the universe signature of the local lemma the port will consume, not only its
statement. (This is the same family as `I-0592`'s "a new type needs its old API", one level down.)

**WHAT (iii-c2-aff) NOW OWES, and it is one statement:** identifying *"`L` restricts trivially
along `ε ↦ 0`"* with *"the chart module's reduction `M ⧸ (ε)·M` is cyclic"*. That is freeness of
the **restriction** on the chart, and it is genuinely geometric — the trivialising section is
what makes the reduction cyclic. Untouched. Do not read either new file as closing the clause;
`ajc-pic0av`'s C-0034 makes exactly that point about a sorry-free census hiding binder content,
and it applies to this lane's files.

### 6.17 §6.16's "one statement" WAS TWO, and the algebraic half is now closed

*Run 0073 r3, after §6.16. Second correction to this lane's own sizing in one session — the
pattern is worth more than either correction.*

§6.16 said the remaining obligation is "freeness of the restriction, genuinely geometric". That
conflated two things:

> **(iii-c2-aff-alg)** freeness of the base change along `ε ↦ 0` ⟹ cyclicity of `M ⧸ (ε)·M`
> **(iii-c2-aff-geo)** the chart module of an `ε`-kernel class base-changes to the chart module
> of its restriction

**(iii-c2-aff-alg) IS CLOSED** — `Tangent/ReductionTrivialCyclic.lean` (sorry-free, `lake env lean`
exit 0), and it is not geometry either:
`Module.Invertible.quotient_smul_cyclic_of_free_baseChange` for an arbitrary ideal `I`, with
`DualNumber.free_of_free_baseChange_eps` as the instance. Two mathlib facts do it, and finding them
was the whole cost:

* `TensorProduct.quotTensorEquivQuotSMul M I : (R ⧸ I) ⊗[R] M ≃ₗ[R] M ⧸ I • ⊤` — the base change
  along `R → R ⧸ I` **is** the quotient by `I·M`. Found by `lean_leansearch` on the *statement*
  ("tensor with R/I is the quotient by I smul top"), not by name.
* `Module.Invertible.free_iff_linearEquiv : Module.Free R M ↔ Nonempty (M ≃ₗ[R] R)` — an invertible
  module is free exactly when it *is* the ring, hence cyclic on the preimage of `1`
  (`Module.Invertible.cyclic_of_free`).

**So the module-level chain of (iii-c2-aff) is COMPLETE:** free base change ⟹ cyclic reduction ⟹
generator ⟹ `Module.Free A[ε] M` ⟹ chart class `= 1` ⟹ `CechPic.map (V s).ι L = 1`, five steps,
every one landed and axiom-clean.

**WHAT IS LEFT IS EXACTLY (iii-c2-aff-geo), and it is a different kind of statement**: that
`Opens.cechPicClass` commutes with the `ε ↦ 0` pullback — i.e. the chart module of the base-changed
class is the base change of the chart module. It mentions no dual numbers, no freeness and no
cyclicity; it is a naturality square for the affine dictionary, of the same *shape* as the reduction
square §6.12 proved for the two-chart comparison — naturality of `Opens.cechPicClass` in the scheme,
where §6.12 gave naturality of `twoChartClassHom`.

**I checked the obvious homes and it is NOT there, so the next session builds it rather than
hunting.** Measured at HEAD:

* `Picard/CechPicToPicNaturality.lean` has exactly **two** declarations, `toPic_map` and
  `toPic_mapAlgebra`, both requiring `[IsAffine X] [IsAffine Y]` on the *whole scheme*. They are
  about `CechPic.toPic`, not about `Opens.cechPicClass` at an affine open of a possibly non-affine
  `Z`. The file name is suggestive and its content is not what is needed.
* Every other `cechPicClass` occurrence in `Picard/` is `BasicOpenCocycleDatum.cechPicClass` — a
  **different function**, on divisor data (`Pic0ChartLocusFibreField.lean`,
  `DivisorThetaFibreData.lean`, `Cohomology/GluedSheafClass.lean`). It *does* have a base-change
  lemma (`cechPicClass_baseChange`), which is exactly the trap: the shared suffix makes it look like
  the square is landed when it is about another object.
* `Picard/EffectivityMoving.lean` has `Opens.cechPicClass_of_le` — the *restriction* seam along
  `O' ≤ O` **inside one scheme**, nothing along a scheme morphism.

The shape to build: for `g : X ⟶ Z` and an affine open `O` of `Z` with affine preimage,
`(g ⁻¹ᵁ O).cechPicClass _ (CechPic.map g L) = Pic.mapRingHom (g.appLE O _ _) (O.cechPicClass _ L)`.
`Opens.cechPicClass_of_le`'s proof is the model: it chases an `appLE` square through
`CechPic.toPic_map` and `Pic.mapRingHom_mapRingHom`.

**I ATTEMPTED IT AND GOT PART-WAY — start from here, the statement typechecks and the reduction
works.** Measured on scratch (not committed, nothing to clean up):

1. The statement above **elaborates** as written, with `hO : IsAffineOpen O` and
   `hgO : IsAffineOpen (g ⁻¹ᵁ O)` as separate hypotheses (the preimage being affine is *not*
   automatic and must be assumed — at the thickened charts it comes from `relCover`, which carries
   `isAffineOpen₀/₁` for the base-changed cover).
2. The **whole Picard-side reduction goes through**, in this order:
   `Opens.cechPicClass` (twice) → collapse the two pullbacks with a `have` proving
   `CechPic.map (g ⁻¹ᵁ O).ι (CechPic.map g L) = CechPic.map ((g ⁻¹ᵁ O).ι ≫ g) L`
   (`CechPic.map_comp` then `rfl`) → `← Scheme.Hom.resLE_comp_ι g le_rfl` (this is the key
   factorisation: `(g⁻¹O).ι ≫ g = resLE ≫ O.ι`, and `Hom.resLE_comp_ι` **exists**) →
   `CechPic.map_comp`, `MonoidHom.comp_apply`, `CechPic.toPic_map` at the `resLE`, then
   `Pic.mapRingHom_mapRingHom` twice.
3. **What is left after that is a pure `CommRingCat` equality**, no Picard groups and no schemes'
   worth of structure:
   `O.ιTop ≫ (g.resLE O (g⁻¹O) le_rfl).appTop = g.appLE O (g⁻¹O) le_rfl ≫ (g⁻¹O).ιTop`
   — the `appLE`/`ιTop` square for the restriction of `g`. `exact?` does not find it and it is not
   in the tree under any spelling I searched.
4. **Where I stopped, and it is bookkeeping not mathematics:** both sides are `appLE` of the *same*
   composite morphism, so the intended proof is `Scheme.Hom.appLE_comp_appLE` on each side plus
   `appLE_congr_hom` (the `subst`-based congruence, `private` in
   `Cohomology/RelativeSectionsLinear.lean` and re-derivable in three lines) to identify the two
   composites via `resLE_comp_ι`. My attempt failed on the *inclusion-witness* argument of the
   intermediate `appLE` — the `⊤ ≤ ((g⁻¹O).ι ≫ g) ⁻¹ᵁ O` proof obligation, which has to be
   transported along `resLE_comp_ι` rather than built from `preimage_top`. That is exactly the
   elided-restriction-argument family of §6.10(3): **state the step as a `have` with the
   inequalities named and close with `exact`, do not let `rw` infer them.**
5. **AND A COST WARNING, measured:** I then applied that fix — naming `e1 : ⊤ ≤ ((g⁻¹O).ι ≫ g) ⁻¹ᵁ O`
   via `Hom.comp_preimage` + `ι_preimage_self` and feeding it to `appLE_comp_appLE` — and the *`have`
   alone* blew the default 200000 heartbeats on `isDefEq`, then did not finish inside 300 s at
   1600000. So this step is **elaboration-expensive, not conceptually hard**, and a session
   attempting it should (a) budget `set_option maxHeartbeats` on that declaration from the start with
   the required explanatory comment, (b) do it when the machine is not carrying eight concurrent
   lanes, and (c) consider proving the `CommRingCat` square as its own top-level lemma so the cost is
   paid once and in isolation rather than inside the `cechPicClass` proof.

**THE METHOD LESSON, since this lane has now mis-sized the same clause twice in one session.**
§6.15 said "the geometry is in step 3"; §6.16 said "the geometry is freeness of the restriction";
both were true only after removing another layer of algebra that already existed or was cheap. Rule:
*when you name the residue of a clause, state it as a Lean statement you could type, not as a phrase
like "the geometric part".* A phrase cannot be checked against the tree; a statement can, and both
times the check would have found the layer immediately.

### 6.18 REVIEWER CORRECTION: THE INTERTWINING HAS A THIRD GAP, AND I PRICED IT AT ZERO AGAIN

*Fresh-context reviewer pass, run 0073 r3, inbox `I-0630` and `I-0633`. Recorded here because
§§6.12–6.14 overstated what the square buys, and this is the third time this lane has made the
same class of error in one day.*

**The finding, and it is correct.** `map_twoChartClassHom` (§6.12) is naturality of
`twoChartClassHom` — the map **before** the quotient. The T2 engine's reduction
`TwoCover.unitsReduction` is a map between the Čech `H¹` **quotients**. Three things stand between
them, none in the tree:

1. **Naturality of the DESCENDED `twoChartClass`** (`TwoChartCechPic.lean:428`). That needs
   `Function.Surjective sel` at *both* ends (`sel` and `sel ∘ f.base`), plus the statement that
   `pullbackOverlapUnit` maps `cechCoboundaryUnits` into `cechCoboundaryUnits`. My "no
   `Function.Surjective sel`" is true of the hom-level lemma and **does not carry to the quotient
   level the engine works at**.
2. **That `Over.dualNumberSectionsUnits` carries `cechCoboundaryUnits (mapRingHom res₀) (mapRingHom res₁)`
   onto `cechCoboundaryUnits res₀ res₁`** at the thickened charts. `resHom_dualNumberSections`
   makes it provable; nobody proved it. So the two `H¹` carriers remain only *abstractly*
   isomorphic — the `I-0571` shape, in the file I wrote to fix an `I-0571` problem.
3. **A typing/transport seam.** `pullbackOverlapUnit` is typed at `f⁻¹V₀ ⊓ f⁻¹V₁` via `le_rfl`;
   `relSectionsMap` at `(fst C (overSpec k R)).left ⁻¹ᵁ W` via `le_of_eq relCurveMap_preimage.symm`.
   Nothing produces the `Bool`-indexed `V` plus selector from `relCover`; nothing identifies
   `(C ◁ overDualNumberZero).left` with `relCurveMap C k[ε] k`, nor `overSpec k k` with the monoidal
   unit that `overDualNumberZero`'s source is. **(b-coeff) is a real statement about
   `relSectionsMap`, but it is not yet the coefficient half of the `twoChartClass`/`unitsReduction`
   square.**

**The generality lesson (`I-0633`), which is the transferable half.** The binders of
`map_twoChartClassHom` *are* fully general — verified by reading them. But its **consumer** is the
quotient-level `twoChartClass`, whose existence needs `hsel`. So "no `Function.Surjective sel`" is
true of the declaration and false of the square the kernel computation needs. Likewise "steps 1–2
over an arbitrary commutative ring" in `DualNumberChartPic.lean` is true and buys **portability, not
progress**, since the class transported comes from an affine chart of a curve.

> **Rule: a generality claim is scoped to the declaration it is written on, not to the chain.** When
> reporting "this landed at full generality", ask which declaration the generality is a property of,
> and whether the consumer instantiates at that generality. A general lemma one level below a
> hypothesis-bearing consumer does not remove the hypothesis.

**Corrected accounting of T4, superseding §§6.12–6.17's summaries.** Landed: the five clauses, the
carrier translation (both halves), the reduction square at *hom* level, and the whole module-level
chain of (iii-c2-aff) bar one square. **Still owed for the T5 numeral:** (a) the three intertwining
items above, (b) (iii-c2-aff-geo), the `cechPicClass` naturality square of §6.17. Do not describe the
T4 residue as "one statement" again without naming which statement and checking its consumer.

### 6.19 RETRACTION: §6.14's PRICING LESSON RESTS ON A FALSE PREMISE — mathlib HAS the instance

*Reviewer finding, inbox `I-0634`, verified independently against the mathlib source before acting.*

§6.14 said the (b-coeff) obstruction was that *"`Algebra k[ε] k` does not exist in mathlib"*, and
built a pricing lesson on it ("an absent instance looks exactly like an absent theorem"). **The
premise is false.**

`Mathlib/Algebra/TrivSqZeroExt/Basic.lean:890` defines

```
abbrev algebraBase : Algebra (tsze R' M) R' where algebraMap := (fstHom R' R' M).toRingHom …
```

and `:897` is the matching `instance : IsScalarTower R' (tsze R' M) R'`. At `R' = M = k` those are
*exactly* `Algebra k[ε] k` via `fstHom` and *exactly* `IsScalarTower k k[ε] k`. Verified by reading
the file, not by search. `Tangent/DualNumberCarrierReduction.lean` now wraps
`TrivSqZeroExt.algebraBase k k` rather than rebuilding it from `fstHom.toAlgebra`.

**And the diamond justification was a rationalization.** Mathlib's own comment says why
`algebraBase` is not an instance: it "creates a different
`Algebra (TrivSqZeroExt R' M) (TrivSqZeroExt R' M)` instance from `TrivSqZeroExt.algebra'`". That is
a clash at `Algebra (tsze) (tsze)` — **not** the "diamond with `Algebra k k`" §6.14 asserted, which
is between different types and cannot clash at all. The `scoped` choice was right; the reason given
for it was invented.

**What survives, restated correctly.** The *shape* of the lesson holds but it is not a new family:
this is `I-0567`'s — **present upstream but deliberately not an instance**, exactly like a `private`
name whose proof is public. The operative rule is therefore the existing one: *when a landed lemma
"does not apply", check whether the missing piece exists upstream in a deliberately non-instance /
non-exported form before pricing new infrastructure* — and, added by this incident, **read the
upstream file, because instance search failing is not evidence of absence.** A `scoped`
re-exposure of an existing `abbrev` costs one line; deriving it from scratch cost me five and
produced a false claim in two documents.

*One caveat on the `IsScalarTower`: mathlib's is stated at `TrivSqZeroExt` level under
`attribute [local instance] algebraBase`, so it is not in scope for a `scoped` wrapper — the local
one is still proved by hand (`of_algebraMap_eq`, two lines). So "the tower needs no proof" as `I-0634`
put it is not quite right; it needs two lines, and only the algebra is a pure rename.*

### 6.20 THE THREE INTERTWINING ITEMS, PLANNED BEFORE THE LEAN (run 0073 r4)

*Worksheet-first, as T4 binds. §6.18 named the residue from the reviewer's `I-0630`; this section
is the plan, written before touching a file. Each item gets: the statement in Lean-ready form, the
inputs already in the tree, and what could go wrong.*

#### (1) Naturality of the DESCENDED `twoChartClass`

**Statement.** For `f : X ⟶ Y`, `V : Bool → Y.Opens`, `sel : Y → Bool`, `hmem`, and
`hsel : Function.Surjective sel`, `hsel' : Function.Surjective (sel ∘ f.base)`:

```
CechPic.map f (twoChartClass V sel hmem hsel q)
  = twoChartClass (f ⁻¹ᵁ V ·) (sel ∘ f.base) _ hsel' (pullbackOverlapQuot f q)
```

where `pullbackOverlapQuot f` is `QuotientGroup.map` of the monoid hom
`f.unitsAppLE (V false ⊓ V true) (f ⁻¹ᵁ V false ⊓ f ⁻¹ᵁ V true) le_rfl` — i.e. of
`pullbackOverlapUnit`, which is already a `MonoidHom` and not merely a function (this is the first
thing that makes the item cheap: no new map has to be built, only a containment proved).

**The containment to prove**, which is the mathematical content:

```
cechCoboundaryUnits (Y.resHom inf_le_left) (Y.resHom inf_le_right)
  ≤ (cechCoboundaryUnits (X.resHom inf_le_left) (X.resHom inf_le_right)).comap
      (f.unitsAppLE _ _ le_rfl)
```

**Predicted proof, and it should be four rewrites.** Take `u = ρ₀ˣ(v₀) · ρ₁ˣ(v₁)` from
`mem_cechCoboundaryUnits`. `map_mul` splits it; then for each factor, `Hom.map_unitsAppLE`
("pullback after restriction") turns `f.unitsAppLE (V₀ ⊓ V₁) T le_rfl (Units.map (Y.resHom h) v)`
into `f.unitsAppLE (V s) T _ v`, and `Hom.unitsAppLE_map` ("restriction after pullback") turns that
into `X.unitsRestrict inf_le_* (f.unitsAppLE (V s) (f ⁻¹ᵁ V s) le_rfl v)`. Since
`unitsMap_resHom` is `rfl`, `X.unitsRestrict` **is** `Units.map (X.resHom _)`, so the result is
literally in the range that `cechCoboundaryUnits` is the join of. **No cohomology, no cocycles** —
the whole item is the functoriality of `unitsAppLE` in the two directions the tree already has.

**What could go wrong.** The pulled-back chart unit is `f.unitsAppLE (V s) (f ⁻¹ᵁ V s) le_rfl v`,
which lives on `f ⁻¹ᵁ V s`, and the coboundary subgroup at the pulled-back cover is stated with
`X.resHom (inf_le_left : f ⁻¹ᵁ V false ⊓ f ⁻¹ᵁ V true ≤ f ⁻¹ᵁ V false)`. Those agree, but only if
the `⊓` on the `X` side is the *inf of preimages* and not the *preimage of the inf* — the same seam
`pullbackOverlapUnit` already navigates by `le_rfl`, so it is defeq. If instance-level unification
balks, state the lemma with `(fun s ↦ f ⁻¹ᵁ V s)` as the family, exactly as
`map_twoChartClassHom` does, rather than with `f ⁻¹ᵁ (V false ⊓ V true)`.

**Then the square itself is free**: `QuotientGroup.map_mk` + `twoChartClass_mk` reduce both sides to
`map_twoChartClassHom`, which is landed. So item (1) = one containment + one `induction q`.

#### (2) `dualNumberSectionsUnits` carries the thickened coboundary subgroup ONTO the base one

**Statement.** With `C : Over (Spec k)`, two affine opens `V : Bool → C.left.Opens`, and
`W := V false ⊓ V true`:

```
Subgroup.map (Over.dualNumberSectionsUnits C hW hW').toMonoidHom
    (cechCoboundaryUnits (mapRingHom (C.left.resHom inf_le_left))
                         (mapRingHom (C.left.resHom inf_le_right)))
  = cechCoboundaryUnits ((C ⊗ ε).left.resHom (preimage_mono _ inf_le_left))
                        ((C ⊗ ε).left.resHom (preimage_mono _ inf_le_right))
```

**Why `=` and not `≤`, and why that matters.** `I-0571`'s lesson is that an isomorphism of the two
ends is worth nothing to a kernel computation. Here the two ends are the two `Ȟ¹` carriers, and what
the kernel computation needs is that the **iso descends to the quotients**, which needs the image
subgroup to be *exactly* the target subgroup — not merely contained in it. Both inclusions come from
the same lemma applied to the equivalence and to its inverse, so proving `=` costs one extra
`le_antisymm` branch, and skipping it would leave precisely the gap the reviewer named.

**Inputs, both landed.** `Over.unitsMap_resHom_dualNumberSectionsUnits` (naturality of the carrier
translation in the open, unit form) at `h : W ≤ V s` is exactly the square that moves a chart
coboundary generator across. `unitsMap_resHom` identifies `Units.map (resHom _)` with
`unitsRestrict`. Nothing else is needed: the generators of the source subgroup are
`Units.map (mapRingHom (resHom _))` of chart units, the equivalence sends them to
`Units.map (resHom _)` of the *translated* chart units, and translation at a chart is again the
equivalence at that chart — so surjectivity onto the generators is `MulEquiv.surjective` chartwise.

**Consequence to record as its own declaration** (this is what a consumer will actually call): the
induced `MulEquiv` of the two `Ȟ¹` quotients,
`(Γ(C,W)[ε])ˣ ⧸ cechCoboundaryUnits … ≃* Γ(C_ε, fst⁻¹W)ˣ ⧸ cechCoboundaryUnits …`, via
`QuotientGroup.congr` (mathlib's name for the quotient of an equivalence matching subgroups).

**What could go wrong.** `Subgroup.map` of a `MulEquiv` needs the `toMonoidHom` coercion to be the
same one the naturality lemma is stated with. If `QuotientGroup.congr` wants
`Subgroup.map e.toMonoidHom S = T` in the opposite orientation, take the `symm` form; both
inclusions are proved anyway.

#### (3) The transport seam — the one that is bookkeeping, not mathematics

Three sub-items, in increasing order of what they cost:

* **(3a)** the `Bool`-indexed family + selector from `relCover`: `V := fun s ↦ if s then (relCover
  C R D).V₁ else .V₀`, `sel` from `relCover_sup` (a point of `⊤` lies in `V₀ ⊔ V₁`, so pick the
  chart), and `hsel` from both charts being nonempty — which needs an argument, since a chart of a
  cover can be empty in general. **Flagged: `hsel` (selector surjectivity) is a real side condition,
  not bookkeeping.** For a curve over a field with `V₀, V₁` a genuine two-chart cover both are
  nonempty, but that has to be said, and it is the same `hsel` clause item (1) needs at both ends.
* **(3b)** identify `(C ◁ overDualNumberZero).left` with `relCurveMap C k[ε] k`. This is an equality
  of *morphisms of schemes*, and `relSectionsMap` is defined from `relCurveMap`'s `appLE`, so the
  identification is what lets the (b-coeff) statement be read as the coefficient half of the square.
* **(3c)** `overSpec k k` vs the monoidal unit `Over.mk (𝟙 _)` that `overDualNumberZero`'s target
  is.

**Order of work, and the honest expectation.** (1) and (2) are self-contained, need no scheme
identifications, and are stated entirely in vocabulary already in the tree — take them first and in
that order. (3) is where a session can disappear: it is four identifications of *objects*, each of
which can produce a "motive is not type correct" of the family this lane has already recorded twice.
If (3b)/(3c) resist, the right move is to state the composed square with the identification as an
explicit hypothesis (`heq : (C ◁ overDualNumberZero).left = relCurveMap C _ _`) and discharge it
separately — the same discipline as `hcyc` in `DualNumberChartPic.lean`, and for the same reason.

### 6.21 ITEMS (1) AND (2) ARE CLOSED, AND §6.20 PREDICTED BOTH MECHANISMS CORRECTLY

*Run 0073 r4. First time in this lane that a §6.x prediction has held on both counts — recorded
because the previous four sections were all corrections of predictions.*

**Item (1), `Tangent/TwoChartQuotientNaturality.lean` (0 sorries).** Exactly as §6.20(1) said: one
containment, `cechCoboundaryUnits_le_comap_unitsAppLE`, provable from the two `unitsAppLE`
functoriality lemmas already in the tree, then the square by `induction q` + `map_twoChartClassHom`.
`hsel` appears at both ends, as `I-0630` requires. Also landed:
`map_twoChartClass_eq_one_iff`, the kernel form, which goes through `twoChartClass_injective` — so
the `CechPic`-level kernel really is computed by the `Ȟ¹`-level one.

**Item (2), `Tangent/DualNumberCarrierCoboundary.lean` (0 sorries).** Also as predicted: the
`Subgroup.map_sup` route means **no `Bool` case analysis appears anywhere**, and the whole statement
is two range identifications, each one application of the landed naturality square. Beyond the
subgroup equality, `dualNumberCechH1Equiv` is the `QuotientGroup.congr` a consumer calls.

**THE ONE THING §6.20 DID NOT PREDICT, and it cost both files a detour.** Both proofs hit the same
wall, and it is neither of the traps this lane has recorded before:

> `rw` fails with *"the target expression is not type-correct under the `instances` transparency
> level"*, with a `Full error` naming a `presheaf.obj` application mismatch — even though the two
> sides are `rfl`-equal and `exact` accepts them.

Two different faces of one seam:
* in item (1) the goal was stated with `Scheme.resHom` while the `@[simp]` lemmas that close it are
  stated with `presheaf.map`. **Fix: `simp [Scheme.resHom]`** — unfold the wrapper so the goal is in
  the library's spelling. `rfl` does *not* close it; neither does any hand-directed `rw` chain.
* in item (2) the landed square is stated with `Over.resAlgHom` coerced to a `RingHom`, while the
  coboundary subgroup is stated with `C.left.resHom`. **Fix: state the new lemma in the CONSUMER's
  spelling** (`resHom`), not in the spelling of the input lemma. Then the subgroup equality is one
  `rw` chain.

> **Rule: when two `rfl`-equal spellings of a restriction meet, `exact` is transparent and `rw` is
> not. Choose the spelling of the CONSUMER when stating a bridging lemma, and reach for
> `simp [<the wrapper def>]` rather than a `rw` chain when the goal is already fixed.** The
> diagnostic to recognise is "not type-correct under the `instances` transparency level" — it reads
> like a broken goal and it is not; it means `rw` is looking at a coercion it cannot see through.

**RESIDUE OF T4 AFTER THIS SECTION, and I am naming statements rather than counting them**
(the discipline §6.18 imposed after three mis-sizings):
1. **Item (3), the transport seam** — §6.20(3), three sub-items, unstarted. (3a)'s `hsel` is a real
   side condition; (3b)/(3c) are scheme-object identifications.
2. **(iii-c2-aff-geo)** — "L trivial along `ε ↦ 0`" ⟹ "the chart reduction is cyclic". Carried as the
   `hcyc` binder in `Tangent/DualNumberChartPic.lean`; the generator half is closed
   (`CyclicQuotientGenerator.lean`). The AJC sibling confirmed on 2026-07-28 that it does **not**
   have this in any spelling either, so it is genuinely open on both sides.

~~Nothing else stands between the two-chart comparison and the T2 engine at quotient level.~~ **WITHDRAWN (§§6.24–6.25): the arrow identification ((3c)) and the `hsel'` binder both stand between them.**

### 6.22 ITEM (3): (3a) IS MEASURED AND (3b) IS A `rfl` — THE SEAM WAS A SPELLING, NOT INFRASTRUCTURE

> **SUPERSEDED IN PART BY §6.23 (below).** (3a) and (3b) stand. The two closing claims of this
> section do **not**: (3c) is *not* the same `rfl`, so item (3) has three sub-items rather than
> two, and T4's residue is **two** named statements rather than one. Read §6.23 before acting on
> anything below.

*Run 0073 r4, continuing §6.21. §6.20(3) predicted this sub-item was "where a session can
disappear": four identifications of objects, each able to produce a "motive is not type correct".
Measured, that prediction was **wrong in the cheap direction** — but only after the right question
was asked, and it is the question this lane keeps having to be reminded of.*

**(3a): `hsel` IS A REAL SIDE CONDITION, AND NOW IT IS CHARACTERIZED.** `Tangent/TwoChartSelector.lean`
gives the `Bool`-indexed family and the canonical selector of a `Scheme.AffineTwoCover`, and proves

```
Function.Surjective D.selector  ↔  D.V₀ ≠ ⊥ ∧ D.V₀ ≠ ⊤
```

So the hypothesis every quotient-level two-chart result carries is exactly *"the cover is honestly
two-chart"*: `V₀ = ⊥` degenerates to the one-chart cover `V₁ = ⊤`, and `V₀ = ⊤` says `X` is covered
by one affine chart, i.e. `X` is affine. Both fail for the Wave-5 curve — it is non-empty, and a
proper positive-dimensional scheme over a field is not affine — but **neither is free**, and neither
is proved in that file: they are consumer inputs `h0 : V₀ ≠ ⊥`, `h1 : V₀ ≠ ⊤`. §6.20 was right to
flag this as content rather than bookkeeping, and characterizing it is better than carrying it: a
reader can now see what the cover has to satisfy without reading a proof.

The family is spelled with `cond` (`bif s then V₁ else V₀`) rather than a `match` so that
`boolFamily false ⊓ boolFamily true` is **syntactically** `V₀ ⊓ V₁`; that is what lets the landed
`isAffineOpen_inf` field apply at the overlap with no transport, and it is the whole reason the file
is short.

**(3b): THE IDENTIFICATION IS `rfl`, AND THE "MISSING" BRIDGE WAS A `scoped` INSTANCE.** §6.20(3b)
priced "identify `(C ◁ overDualNumberZero).left` with `relCurveMap C k[ε] k`" as an equality of
scheme morphisms to be built. It is neither built nor hard:

* `relCurveMap C R R'` is *by definition* `(C ◁ overSpecMap R R').left`;
* `overSpecMap k[ε] k` is `Over.homMk (Spec.map (ofHom (algebraMap k[ε] k)))`;
* `overDualNumberZero k` is `Over.homMk (Spec.map (ofHom TruncExpCech.fstRingHom))`;
* and under the `scoped` `epsAlgebra` of `Tangent/DualNumberCarrierReduction.lean`,
  `algebraMap k[ε] k` **is** `TrivSqZeroExt.fst` definitionally (`algebraMap_eps_eq_fst`).

So the two morphisms are equal by `rfl`, and the source objects agree for the same kind of reason
(`overSpec k k = Over.mk (Spec.map (ofHom (algebraMap k k)))` with `algebraMap k k = RingHom.id k`,
also `rfl`). Both defeq facts were confirmed standalone against mathlib before the file-level check.

> **The pattern, and it is the third time this lane has met it: a "missing identification" between
> two spellings that differ only across a deliberately-`scoped` instance is not missing
> infrastructure.** `I-0567` (present upstream but not an instance), `I-0634` (`algebraBase` exists;
> my diamond reason was invented), and now this. **Before pricing an object identification, unfold
> both sides to the `RingHom` they are built from and try `rfl` with the scoped instance open.** It
> costs one `#check`. In this lane the wrong answer has cost a session's worth of pricing three
> times.

**What (3c) turns out to be.** ~~§6.20 listed `overSpec k k` vs the monoidal unit `Over.mk (𝟙 _)`
separately. It is the *same* `rfl` as above and not an independent item, so the honest count for item
(3) is **two sub-items, not three**, and both are now closed modulo the kernel check.~~
**WITHDRAWN by §6.23** — the kernel refuted it: `overSpec k k` vs `Over.mk (𝟙 _)` needs
`Spec.map_id`, not `rfl`. Item (3) has three sub-items.

**T4's residue after §§6.21–6.22** — ~~and it is now ONE named statement~~ (**withdrawn; §6.23
gives TWO**, the object transport plus the following): **(iii-c2-aff-geo)** — "L
restricts trivially along `ε ↦ 0`" ⟹ "the chart module's reduction `M/(ε)M` is cyclic". Carried as
the `hcyc` binder in `Tangent/DualNumberChartPic.lean`, so a sorry census does not see it, and open
in the AJC sibling too (confirmed by `ajc-pic0av`, 2026-07-28). **Per §6.18's rule this is stated
with its consumer named**: the binder is consumed by
`Opens.cechPicMap_ι_eq_one_of_dualNumberChart_of_cyclic`, ~~and nothing else in the chain now stands
between the T2 engine and the two-chart comparison at quotient level.~~ **WITHDRAWN (§§6.24–6.25):
two further things do stand between them — the arrow identification (3c), and the `hsel'` binder,
which had no producer until §6.25.**

### 6.23 RETRACTION OF §6.22: (3c) IS NOT THE SAME `rfl`, AND THE KERNEL IS WHAT CAUGHT IT

*Run 0073 r4, self-caught by the kernel check before any reviewer saw it, but only after the claim
had already been committed (`ece8432d63`). Recorded in full because the shape of the error is the
one this lane keeps repeating.*

**What §6.22 claimed.** That `overSpec k k` versus the monoidal unit `Over.mk (𝟙 _)` "is the *same*
`rfl` as above and not an independent item", hence *"item (3) is **two sub-items, not three**, and
both are now closed modulo the kernel check"*.

**What the kernel said.** `lake build` refutes it with a type mismatch, not a proof failure:

```
Over.Hom.left (C ◁ overDualNumberZero k) has type
  (C ⊗ Over.mk (𝟙 (Spec (CommRingCat.of k)))).left ⟶ (C ⊗ overDualNumber k).left
but is expected to have type
  relCurve C k ⟶ relCurve C (DualNumber k)
```

**Why, measured to the exact step.** Two facts, and the distinction between them is the whole
finding:

* `CommRingCat.ofHom (algebraMap k k) = 𝟙 (CommRingCat.of k)` — **`rfl`**;
* `Spec.map (CommRingCat.ofHom (algebraMap k k)) = 𝟙 (Spec k)` — **NOT `rfl`**. It is `Spec.map_id`,
  a propositional lemma, because `Spec.map` is functorial only up to propositional equality.

So `overSpec k k` and the monoidal unit are *equal objects that are not definitionally equal*, the
whiskerings `C ⊗ (−)` of them are different objects, and `relCurveMap C k[ε] k` and
`(C ◁ overDualNumberZero k).left` therefore have **different types**. No amount of `congr` closes a
type mismatch. Item (3) is **three** sub-items, (3c) needs an honest object transport
(`eqToHom`/`Over.isoMk` along `Spec.map_id`, then a whiskering congruence), and it is **not built** —
`Tangent/TwoChartSelector.lean` states the two measurements instead and says so in its docstring.

**HOW I GOT IT WRONG, which is the part worth carrying.** §6.22's own rule was right and I applied
it one step too far. The rule says: *unfold both sides to the `RingHom` they are built from and try
`rfl`*. I did that, found `algebraMap k k = RingHom.id k` by `rfl`, and **transported that verdict
across `Spec.map` without re-testing it**. The ring level was defeq; the scheme level was not. And
(3b) — which really is `rfl` — sits one `Spec.map` away from (3c), which is not, so the successful
neighbour is exactly what made the false claim plausible.

> **Rule: a defeq verdict does not survive a functor.** Establishing `f = g` by `rfl` licenses
> nothing about `F f = F g` unless `F`'s action is itself definitional — and for `Spec.map`,
> `Scheme.map`, and most category-level constructions in mathlib it is not (`Spec.map_id` and
> `Spec.map_comp` exist precisely because they are theorems). **Re-run `rfl` at every level you
> intend to use it at.** One `#check` per level; the cost of skipping one is a committed false
> claim, as here.

**Second-order note, and it is the reason this section exists rather than a silent fix.** §6.21
celebrated §6.20's predictions holding "on both mechanisms — the first time in this lane". That
celebration was one section too early: the very next prediction in the same family was wrong. A
run of correct predictions is not evidence that the *next* one needs less checking, and writing down
that a streak has started is a good way to stop checking. The streak claim in §6.21 stands as
written for the two items it describes; it should not be read as a trend.

**T4's residue, corrected once more and this is the count that should be quoted:** **(3c)** the
object transport above, **plus (iii-c2-aff-geo)**. Two named statements, not one. §6.22's closing
line ("T4's residue is now ONE named statement") is hereby withdrawn.

### 6.24 THE LEVEL CHECK, RUN EXPLICITLY: do items (1)+(2) actually meet the engine?

*Run 0073 r4. §6.18's rule says a generality or closure claim must be checked at its CONSUMER, and
this lane has broken that rule four times in a day. So rather than assert that items (1) and (2)
"compose with the T2 engine", here is the carrier-by-carrier comparison, read off the declarations.*

**The engine** (`TwoCover.unitsReduction`, `Tangent/TruncExpCechH1.lean:133`) is

```
(Γ(X, U₀ ⊓ U₁)[ε])ˣ ⧸ cechCoboundaryUnits (mapRingHom (X.resHom inf_le_left))
                                          (mapRingHom (X.resHom inf_le_right))
  →*  Γ(X, U₀ ⊓ U₁)ˣ ⧸ cechCoboundaryUnits (X.resHom inf_le_left) (X.resHom inf_le_right)
```

**The comparison** (`Scheme.twoChartClass`, `Tangent/TwoChartCechPic.lean`) has source

```
Γ(X, V false ⊓ V true)ˣ ⧸ TruncExpCech.cechCoboundaryUnits (X.resHom inf_le_left)
                                                          (X.resHom inf_le_right)
```

**Verdict, and it is favourable.** The engine's **target** is *syntactically* the comparison's
source at `X` (same carrier, same subgroup, same two restriction maps). The engine's **source** is
the `DualNumber`-of-original-sections carrier, which is precisely what item (2)'s
`dualNumberCechH1Equiv` identifies with the comparison's source at the *thickened* curve. And item
(1)'s `map_twoChartClass` is the square for the induced map between the two comparison sources. So
the three pieces do line up at one level, which is what §6.18 said had to be checked and not
assumed.

**What is therefore still missing is exactly one link, stated sharply.** The engine's arrow is
`unitsFst` on the dual-number carrier; item (1)'s arrow is `pullbackOverlapQuot` along the `ε ↦ 0`
scheme morphism. Saying these are *the same arrow* across `dualNumberCechH1Equiv` is precisely
`(b-coeff)` composed with the (3c) object transport — which is why (3c) is not cosmetic bookkeeping:
**it is the step that turns two aligned diagrams into one commuting one.** Recorded here so no
successor reads §§6.21–6.22 as "the intertwining is done".

So the residue of §6.23 stands unchanged and is now justified rather than asserted: **(3c)** and
**(iii-c2-aff-geo)**.

### 6.25 REVIEWER FINDINGS ACCEPTED: a level check does not see BINDERS, and a retraction must reach the docstrings

*Fresh-context reviewer, inbox `I-0687` and `I-0688`. Both accepted in full; both point at the same
weakness from different sides, and one of them is a genuinely new failure mode for this lane.*

**`I-0688`, and it is the sharper of the two. §6.24's level check passed while an obligation was
being MOVED rather than discharged.** `Scheme.map_twoChartClass` takes **two** surjectivity binders:
`hsel` for `sel` on `Y`, and `hsel'` for `sel ∘ f.base` on `X`. I characterized the first
(`surjective_selector_iff`) and never asked who produces the second. Measured on the reviewer's
instruction: `grep -rn "hsel'"` returns **only occurrences inside my own declaration** — zero
producers anywhere in the project. A carrier-by-carrier comparison cannot detect this, because
**binders do not appear in carriers**.

> **Rule: "does this meet its consumer" is TWO passes, not one.** (1) do the carriers/types line up;
> (2) does every explicit hypothesis binder of the new lemma have a **producer** in the tree — grep
> the binder's statement and count occurrences *outside* the declaration itself. Zero means the
> consumer must invent it. Pass 2 is one grep, and it is the pass that catches an obligation being
> relocated rather than discharged. Corollary the reviewer states and I endorse: **characterizing
> one of two binders does not size the residue.**

**Acted on, not merely recorded.** `Tangent/TwoChartSelector.lean` now carries
`Scheme.surjective_selector_comp`: `hsel` plus `Function.Surjective f.base` gives `hsel'`. Stated as
the general composition fact on purpose — it relocates the obligation from a *combinatorial* fact
about charts to a *topological* fact about `f`, which is where it belongs and where the Wave-5
instance can discharge it (the `ε ↦ 0` map is a bijection on points, `Spec k → Spec k[ε]` being a map
of one-point spaces). That last step is named, not proved, exactly like `V₀ ≠ ⊥`/`V₀ ≠ ⊤`.

**`I-0687`: my §6.23 retraction did not reach the docstring of the theorem it was about.** The
sentence *"the source objects agree for the same reason: `overSpec k k` is
`Over.mk (Spec.map (ofHom (algebraMap k k)))` and `algebraMap k k = RingHom.id k`"* survived,
unstruck, in `overSpecMap_eps_eq_overDualNumberZero`'s docstring — **two declarations above the
theorem that refutes it.** So a reader of that docstring alone got the withdrawn claim with no
marker. Fixed in place: the docstring now says the lemma is about the two *morphisms only*, names the
sentence as withdrawn with its inbox reference, and points at
`specMap_algebraMap_self_eq_id`. Two stale worksheet lines ("nothing else stands between…", §§6.21
and 6.22) are struck likewise.

**This is "retract where the claim is" recurring in the file that records the lesson**, which is the
second time today, and the reason is worth naming: I struck the *worksheet* prose and treated the
Lean docstrings as a separate artifact. They are not — **a docstring is the copy a consumer actually
reads.** When retracting, grep the retracted sentence across `.lean` files too, not only the notes.

**Residue after this section, unchanged in substance and better sized:** ~~**(3c)** the object
transport~~ (**CLOSED, §6.26**), **(iii-c2-aff-geo)**, and — newly explicit — the two named consumer
inputs (`V₀ ≠ ⊥ ∧ V₀ ≠ ⊤`, and `Surjective f.base` at the `ε ↦ 0` map) which are satisfiable,
unwitnessed in the tree, and now each have a producer or a named owner.

### 6.26 (3c) IS CLOSED — the seam is an ISO, and the only obstacle was a spelling

*Run 0073 r5, `Tangent/DualNumberUnitTransport.lean`, `lake env lean` EXIT=0 with zero diagnostics.
Written after the Lean this once and saying so: §6.23 had already done the worksheet-first work —
it named the obligation, diagnosed it to the exact step, and prescribed a route. What follows
records where that prescription was right, where it over-priced, and where it under-priced.*

**THE STATEMENT.** With `unitIso k : Over.mk (𝟙 (Spec k)) ≅ overSpec k k`:

```
overDualNumberZero k = (unitIso k).hom ≫ overSpecMap k[ε] k          -- overDualNumberZero_eq
(C ◁ overDualNumberZero k).left = transportLeft C ≫ relCurveMap C k[ε] k
                                                     -- whiskerLeft_overDualNumberZero_left
IsIso (transportLeft C)                                     -- isIso_transportLeft
```

The second is *exactly* the identification §6.24 isolated as **"the step that turns two aligned
diagrams into one commuting one"** — the engine's arrow reaches the base through `relCurveMap`,
item (1)'s reaches it through the `ε ↦ 0` scheme morphism, and this is the equation between them.

**WHERE §6.23's PRESCRIPTION OVER-PRICED.** It said *"`eqToHom`/`Over.isoMk` along `Spec.map_id`,
then a whiskering congruence"*. **The `eqToHom` half is never needed.** The two source objects have
the *same underlying scheme* `Spec k` — that much **is** `rfl`, and `Over.isoMk (Iso.refl _)` takes
the left component. `Spec.map_id` is spent on one thing only: the structure-morphism triangle
`𝟙 ≫ Spec.map (ofHom (algebraMap k k)) = 𝟙`. And the whiskering congruence is `whiskerLeft_comp`
plus the landed **(3b)** reversed. Total: three short lemmas.

Worth naming because it is the *mirror* of this lane's usual error. The habitual failure is
under-pricing (a claimed `rfl` that isn't). Here the retraction that corrected an under-pricing
went on to over-price the repair — a diagnosis reached under the sting of being wrong reached for
the heaviest available tool. **A retraction is not automatically a correct re-estimate.**

**WHERE IT UNDER-PRICED, AND THIS IS THE USEFUL HALF.** §6.23 described (3c) as *a transport*, which
suggests a one-directional rewrite. It is an **isomorphism** (`isIso_transportLeft`): whiskering an
iso is an iso, and `Over.forget` carries that to schemes. So a consumer may travel the seam in
**either** direction — and a kernel comparison *must*, since "dies after pullback ⟺ dies before" is
a two-way statement. An `eqToHom`-shaped mental model would have obtained the forward rewrite and
left the reverse looking like new work.

**THE ONE REAL OBSTACLE, and it was not mathematics.** The composite with `relCurveMap` is
`rfl`-equal to the whiskering spelling, but `rw` refuses it:

```
Application type mismatch: relCurveMap C k[ε] k has type relCurve C k ⟶ relCurve C k[ε]
  but is expected to have type (C ⊗ overSpec k k).left ⟶ relCurve C k[ε]
Note: The target expression is not type-correct under the `instances` transparency level
```

`(C ⊗ overSpec k k).left = relCurve C k` **is** `rfl` (measured), so the goal is type-correct and
that message names a *spelling*, not a defect — inbox `I-0685`'s trap, met here for the first time
in this lane. Fixed by giving the transport a **definition whose declared type already ends in
`relCurve C k`**; both spellings then coexist, `_left'` (whiskering) proving `_left` (relCurveMap)
by term with no transport at all.

> **Rule, and it is the (3b)/(3c) pair read together.** §6.22's rule was *unfold to the `RingHom`
> and try `rfl` at every level*. Add: **when `rw` reports a type mismatch on terms you believe are
> `rfl`-equal, test that belief with `example : lhsType = rhsType := rfl` before concluding the goal
> is malformed.** Two `rfl` outcomes with opposite meanings live one line apart here — the objects
> `overSpec k k` vs the unit are genuinely **not** defeq (that is (3c)), while the *carriers*
> `(C ⊗ overSpec k k).left` vs `relCurve C k` **are** (that is the spelling). Confusing the two costs
> either a false claim or an invented obstacle.

**T4's residue after §6.26 — one statement plus two named consumer inputs.** ~~**(iii-c2-aff-geo)**
("L restricts trivially along `ε ↦ 0`" ⟹ "the chart module's reduction `M/(ε)M` is cyclic"), carried
as the `hcyc` binder of `Opens.cechPicMap_ι_eq_one_of_dualNumberChart_of_cyclic` and open in the AJC
sibling too; plus `V₀ ≠ ⊥ ∧ V₀ ≠ ⊤` and `Surjective f.base` at `ε ↦ 0`, both satisfiable and both
still unwitnessed.~~ **ALL THREE CLOSED — §6.27.**

### 6.27 (iii-c2-aff-geo) AND BOTH CONSUMER INPUTS ARE CLOSED — three items, three mis-pricings, one cause

*Run 0073 r6. Five new modules, all kernel-green on the lock-free scratch root and all rooted;
eleven headlines axiom-clean against in-file controls that fire `sorryAx`. Commits `93f84ed2`,
`2755a58e`, `80e6da8e`.*

**THE CAUSE, stated first because it is the transferable part.** Each of the three items had been
priced by a *correct* piece of reading, and each price was wrong for the same reason: **the
obligation was searched for in this project's own vocabulary.**

| item | priced at | what it was |
|---|---|---|
| the leftover square of (iii-c2-aff-geo) | >1 600 000 heartbeats, "elaboration-expensive" (§6.17(5)) | mathlib's `Hom.resLE_app_top` — three rewrites |
| `Surjective f.base` at `ε ↦ 0` | "a bijection of one-point spaces", over a field | `PrimeSpectrum.isHomeomorph_comap`, over an arbitrary ring |
| `V₀ ≠ ⊥ ∧ V₀ ≠ ⊤` | two geometric facts about the curve | one, `¬ IsAffine`; non-emptiness is not an input at all |

**(1) THE SQUARE — `Tangent/ChartClassNaturality.lean`.** §6.17 stated the target as a typeable
Lean statement (the rule it had just adopted), reduced it correctly, and landed on the pure
`CommRingCat` equality `O.ιTop ≫ (g.resLE …).appTop = g.appLE … ≫ (g⁻¹O).ιTop`. It reported `exact?`
failing on it, prescribed `appLE_comp_appLE` plus a congruence transported along `resLE_comp_ι`,
measured that route at over 1 600 000 heartbeats without finishing in 300 s, and filed the item as
expensive-but-not-hard.

That equality **is** `Scheme.Hom.resLE_app_top`, a `@[simp]` lemma at
`Mathlib/AlgebraicGeometry/Restrict.lean:796`. The only work is that mathlib says `topIso` where
this project says `ιTop`; they agree by `simp [ιTop, topIso]` then `rfl` — *not* syntactically, hence
`ιTop_resLE_appTop` as a named lemma rather than an inline rewrite. `Opens.cechPicClass_map` then
follows §6.17's own recipe verbatim, at the **default** heartbeat budget.

> **Rule: when you recognise a leftover goal as a known square, search the UPSTREAM vocabulary too.**
> §6.17 searched for "the `appLE`/`ιTop` square" — with `ιTop`, which is ours. A correct
> recognition plus a same-vocabulary search produced a 1.6M-heartbeat estimate for a three-line
> proof. The estimate was honestly measured; it was measuring the wrong route.

**(2) THE RING LINK — `Tangent/PicEpsKernelTrivial.lean`.** §6.17 named the residue as the square
alone. It was the square *plus* one composition that **three** module docstrings had described
without writing down: `DualNumberFstKernel` built `A[ε] ⧸ (ε) ≃+* A` "so a consumer can feed
`QuotSMulTop.equivQuotTensor`"; `ReductionTrivialCyclic` phrased its hypothesis on the quotient "so
that no ring identification is needed *here*"; `DualNumberChartPic` carried the gap as `hcyc`.
Nobody composed them. `quotientSpanEpsRingEquiv_comp_mk` is **`rfl`**, and
`pic_eq_one_of_mapRingHom_fst` is three rewrites on top of it.

**(3) THE ASSEMBLY — `Tangent/ChartTrivialityGeo.lean`.** Four lines, given (1) and (2). One thing
worth recording: the statement needs **two** ring equivalences. Asking only for
`e : Γ(Z,O) ≃+* A[ε]` with `g.appLE = fst ∘ e` does not typecheck — `g.appLE` lands in
`Γ(X, g⁻¹O)` and `fst ∘ e` in `A` — so `hsq` is a commuting **square** and the downstairs chart
needs its own presentation `e'`. A mis-stated intertwining announced itself as a type error naming
exactly the two rings that had been conflated.

**(4) `Surjective f.base` — `Tangent/EpsZeroSurjective.lean`.** §6.25 predicted "a bijection of
one-point spaces, `Spec k → Spec k[ε]`". True over a field, and the wrong proof: it pins the lemma
to `k` and needs re-deriving the moment the tangent computation is instantiated at a chart's section
ring. `PrimeSpectrum.isHomeomorph_comap` gives it over an **arbitrary commutative ring** from two
cheap inputs — `fst` is surjective, and `ker fst = (ε)` is nilpotent (`ker_fstRingHom_le_nilradical`,
one `rw`). *The general case was cheaper than the case we needed.*

**(5) `V₀ ≠ ⊥ ∧ V₀ ≠ ⊤` — `Tangent/TwoChartHonest.lean`; this had been two obligations for three
sessions.** Both conjuncts are symptoms of one fact: `V₀ = ⊤` makes `⊤` an affine open, `V₀ = ⊥`
makes `V₁ = ⊤` by `sup_eq_top`, and either way `Scheme.topIso` makes `Y` affine. So `¬ IsAffine Y`
supplies both, in four lines each. **And non-emptiness of the curve was never an input** — the empty
scheme *is* affine (`Spec 0`), so `¬ IsAffine` already excludes it. That is why the predicted "two
geometric facts" was one too many.

> **Rule: a hypothesis PAIR read off a characterization need not be two obligations.**
> `surjective_selector_iff` is an honest `↔` and its two conjuncts are genuinely different
> conditions *on `V₀`* — but they share a cause one level up, and that cause is what a consumer can
> actually supply. Before shipping "the consumer owes A and B", ask what A and B are both symptoms
> of.

**WHAT T4 OWES NOW.** No mathematical statement of the clause itself. Two *instantiation* items,
both named in the new docstrings, neither a wall:

1. **`¬ IsAffine C.left`** for the smooth proper positive-dimensional curve — a genuine geometric
   statement, and absent from this project, the sibling and mathlib (searched). One statement where
   §6.25 left two.
2. ~~**The two chart presentations and the square `hsq`** at the thickened charts:
   `e = Over.dualNumberSectionsOfIsAffineOpen`, `e'` its `ε ↦ 0` reduction, and the commuting square
   between them. The pieces exist (`Over.relSectionsMap_dualNumberSections` is `(b-coeff)`); the
   square is not assembled.~~ **CLOSED the same session — `Tangent/EpsChartSquare.lean`,
   `aaa4627bb`; see §6.28.** `relCover` supplies `hgO` (affine preimage) via `isAffineOpen₀/₁`.

**TWO TOOLING FINDINGS, one of which corrected a false claim I had already committed.**

* **A lock-free `lean -o` check must carry `lakefile.toml`'s `leanOptions`.** Without
  `-D maxSynthPendingDepth=3`, `PicEpsKernelTrivial` reports three hard elaboration errors that
  `lake` and the LSP both accept (`Pic.mapRingHom` at `Ideal.Quotient.mk` cannot synthesize the
  quotient's `CommRing`). I diagnosed that as *a conflict between import sets*, wrote it into the
  file as a structural constraint ("do not tidy these two files into one"), committed it, then
  refuted it by re-running with the option. **Retracted at both sites.** A tooling artefact can
  produce a precise, plausible, mechanism-shaped diagnosis.
* **But run the check anyway.** It caught a real error the LSP could not: the first split put
  `namespace TruncExpCech` inside `namespace AlgebraicGeometry` (it is top-level), and because the
  new modules had no oleans yet the LSP could only say `Imports are out of date`. Nine errors in
  twelve seconds. **A new module importing another NEW module is invisible to the LSP; one import
  complaint is not a pass.**

### 6.28 THE INSTANTIATION ITEM I HAD JUST FILED AS A SUCCESSOR'S TASK WAS THREE QUARTERS LANDED

*Run 0073 r6, `Tangent/EpsChartSquare.lean`, `aaa4627bb`. Kernel-green, rooted, both headlines
axiom-clean against a control that fires `sorryAx`. Written after the Lean and saying so: §6.27's
worksheet-first pass had already named the item precisely, which is exactly what makes what follows
worth recording.*

**WHAT LANDED.** `relSectionsMap_eq_fstRingHom_comp` is the `hsq` hypothesis of
`Opens.cechPicMap_ι_eq_one_of_map_eq_one`, instantiated at `g = relCurveMap C k[ε] k`,
`A = Γ(C.left, W)`, `e = (Over.dualNumberSectionsOfIsAffineOpen C hW).symm` and
`e' = epsChartDown C hW` (the new downstairs presentation, `sectionsBaseChange.symm` then
`Algebra.TensorProduct.rid`).

**WHY IT WAS NEARLY FREE, and none of this required new mathematics.** Two facts I did not check
before pricing it:

* `relSectionsMap` **is** `(relCurveMap C R R').appLE` at the two chart preimages —
  by *definition* (`Cohomology/RelativeSectionsLinear.lean:193`). So the `appLE` that
  §6.27's statement demands and the `relSectionsMap` the tangent layer already uses are the same
  arrow, with nothing to bridge.
* `Over.relSectionsMap_dualNumberSections` already *is* the square's content. Its own docstring
  calls it *"the statement the `ε`-kernel computation spends"*. The only gap was that its
  right-hand side is a base-changed **pure tensor** where the consumer wants an element of
  `Γ(C.left, W)` — and `Algebra.TensorProduct.rid` is that step, which is also all `epsChartDown`
  is.

**THE FAILURE, and it is mine and it is the session's own lesson recurring inside the session.**
§6.27 closed by naming two instantiation items and calling neither a wall. I then wrote that
assessment into the `.t3` and `.t4` roadmap rows and into memory `I-0729` as *"a successor should
START by assembling `hsq`"* — that is, I priced it at a session's opening work **without probing
it**, in the very session whose central finding was that this lane mis-prices obligations by not
probing them. Two `horizon search` calls and one 12-second kernel check would have caught it, and
they are what closed it.

> **Rule: a residue named accurately in a hand-off has not thereby been measured.** §6.27's naming
> was correct — right pieces, right shape, right consumer. Correct naming is what makes a residue
> *checkable*, not what makes it checked. Before writing "the successor should start here" into a
> roadmap row, spend the two searches; the cost of not doing so is a row that tells the next
> session to build what is already built (`I-0729` now carries the self-correction).

**THE TWO SPELLING COSTS, for the record.** Both scoped instances must be opened —
`attribute [local instance] Over.sectionsAlgebra` (else `Algebra k Γ(C.left, W)` fails) and
`open scoped TruncExpCech.EpsilonReduction` (else `Algebra k[ε] k` fails); neither absence is
missing infrastructure (`I-0567`/`I-0634`). And `sectionsBaseChangeOfIsAffineOpen` is
`sectionsBaseChange` at the affine witness by `rfl` while `rw` will not see through it, so that step
is an explicit `rw [show … from rfl]` — `I-0685` again, met for the third time in this lane.

**T4's residue after §6.28: exactly one statement, `¬ IsAffine C.left`.** Geometric, absent from
both projects and mathlib, and NOT to be priced as obvious — memory `I-0729` records the route
(`IsFinite.iff_isProper_and_isAffineHom`, whose last link, `SmoothOfRelativeDimension` against
fibre dimension or `IsFinite`, mathlib does not have).

### 6.29 `¬ IsAffine C.left` IS OFF THE CRITICAL PATH — it was a chosen sufficient condition, not the content

*Run 0073 r6, `Tangent/TwoChartHonestGenus.lean`, `2d46afeb3`. Kernel-green, rooted, three
headlines axiom-clean against a control that fires `sorryAx`.*

**THE SEQUENCE, because the useful part is the order in which the price fell.**

1. §6.27's `TwoChartHonest` reduced both chart-side inputs to `¬ IsAffine Y`, and I filed the route
   to it (`I-0729`): `IsFinite.iff_isProper_and_isAffineHom`, then quasi-finiteness against
   `SmoothOfRelativeDimension 1`.
2. A second probe **improved** the decomposition — `IsFinite.iff_isProper_and_locallyQuasiFinite`
   plus `Scheme.Hom.quasiFiniteAt` reduces it to *one* statement: relative dimension 1 excludes
   `QuasiFiniteAt`. Three mathlib names plus one brick.
3. A third probe **priced that brick honestly, by unfolding the definition**:
   `SmoothOfRelativeDimension n f` is `∀ x, ∃ U V e, IsStandardSmoothOfRelativeDimension n …`, and
   that is `∃ P : SubmersivePresentation …, P.dimension = n` — a **combinatorial count on a
   presentation**, not a fibre or Krull dimension. Connecting it to quasi-finiteness is the smooth
   dimension theory mathlib has not developed for `n ≠ 0`. Multi-session, and that verdict stands.
4. Then the question that should have come first: **what is `¬ IsAffine` used FOR?** To rule out a
   degenerate two-chart cover. And degeneracy is visible in `H¹` *directly*: if `U₀ = ⊤` the overlap
   `⊤ ⊓ U₁` **is** `U₁`, so every overlap section already extends to `U₁`, and the landed
   `TwoCover.h1Cok_mk_resHom_right` kills its class. Two `resHom` lemmas
   (`resHom_resHom`, `resHom_refl`). **No affineness, no quasi-coherence, and specifically not
   `affine_serre_vanishing`** (which would have needed `EnoughInjectives` and the whole
   quasi-coherent machinery — the tempting route, and the wrong one).

So `ne_top_of_h1Cok_ne_zero` gives both conditions `surjective_selector_iff` asks for, and since the
tree computes `h¹(𝒪_C) = g`, **`g ≠ 0` replaces `¬ IsAffine C.left` entirely.**

> **Rule: a predecessor's hypothesis is a chosen sufficient condition until you check.** Steps 1–3
> are three rounds of increasingly careful work on the wrong question, and each was *correct* — the
> route improved, the pricing became honest, and the definitional measurement is a real datum. What
> none of them asked is what the hypothesis was *for*. §6.27 already records the pair-of-conditions
> version of this ("what are A and B both symptoms of"); this is the single-hypothesis version, and
> it is the more expensive one because a single hypothesis looks like a fact rather than a choice.

`¬ IsAffine C.left` itself remains unproved, `I-0729` remains the record of how to get it, and
nothing in T3/T4 needs it.

**T4's RESIDUE AFTER §6.29: none.** Clause (iii) is complete, instantiated at the charts
(§6.28), and its last geometric input is replaced by a cohomological one the tree already computes.
What remains in the T-chain is T3's assembly and T5's numeral — consumers, not comparisons.

## §7 T3 — THE ASSEMBLY, measured before the Lean (run 0073 r7, task `ajcr-w5-av`)

*Worksheet-first, as §6 was. §6.29 closed T4 and handed T3 an assembly; this section asks what that
assembly actually consumes, and the answer corrects the `.t3` roadmap row.*

### 7.0 The row said T3 "waits on one geometric fact". It does not — it waits on the §6.24 link, which has ZERO consumers at either end

The `.t3` roadmap row at the start of this session read: *"WHAT T3 WAITS ON NOW is one geometric
fact, not a comparison: `¬ IsAffine C.left` … Every other input of the chain is landed, rooted and
axiom-clean. A successor should start there, or start assembling the ε-kernel statement itself over
that hypothesis — **the pieces no longer have gaps between them**."*

Two things are wrong with that, and the second is the one that matters.

1. **`¬ IsAffine C.left` is not an input at all** — §6.29 replaced it with `g ≠ 0` in the same
   session that wrote the row. The row's own sibling (`.t4`) says so. This is a stale sentence, not
   a mis-pricing.
2. **"the pieces no longer have gaps between them" is false, and §6.24 says so.** §6.24 ran the
   carrier-by-carrier level check and concluded: *"What is therefore still missing is exactly one
   link, stated sharply. The engine's arrow is `unitsFst` on the dual-number carrier; item (1)'s
   arrow is `pullbackOverlapQuot` along the `ε ↦ 0` scheme morphism. Saying these are the same arrow
   across `dualNumberCechH1Equiv` is precisely `(b-coeff)` composed with the (3c) object
   transport."* That link had never been built **at the time this section was written** (it is
   closed later the same session, §7.4 — and by `rfl`, which is its own lesson). §6.26 closed
   **(3c)**, which §6.24 named as one of its two *ingredients* — though §7.4 finds the arrow
   consumes neither — and §§6.27–6.29 closed the *chart-triviality* clause, a different leg.

**Measured, and this is the instrument that should have been run before the row was written**
(`I-0630`/`I-0687`/`I-0711` shape: a carrier with no consumers reads exactly like one with no
producers):

```
grep -rln 'pullbackOverlapQuot' AlgebraicJacobian/ --include=*.lean
  → TwoChartQuotientNaturality.lean (its own file), plus ONE DOCSTRING MENTION
grep -rln 'dualNumberCechH1Equiv'  → DualNumberCarrierCoboundary.lean   (its own file only)
grep -rln 'unitsReduction'         → TruncExpCechH1.lean, TwoChartNaturality.lean
grep -rln 'relSectionsMapUnits'    → DualNumberCarrierReduction.lean    (its own file only)
```

**Every one of the four objects §6.24 named as the two sides of the missing link is consumed by
nothing outside the file that defines it.** Three of the four are consumed by *nothing at all*.
(Fixed later the same session for two of them: `EpsArrowIdentification.lean` consumes
`pullbackOverlapQuot` and `dualNumberCechH1Equiv`, §7.4. `unitsReduction` and `relSectionsMapUnits`
are still island-shaped, and (T3-3) is what should consume them.) So
the honest reading of the T-chain at the start of this session is not "assembly over one geometric
hypothesis" but **"four landed carriers and the arrow between two of them is absent"** — the
`I-0711` island shape, in a lane that has now recorded that shape three times.

> **Rule: "the pieces no longer have gaps between them" is a claim about ARROWS, and the cheap test
> is a consumer grep on each piece.** A hand-off written from a level check (§6.24, carriers line up)
> plus a session's worth of closed leaves reads as "assembly remains" — but §6.24 had *itself*
> written down the missing arrow, in the same document, five sections earlier. The failure is not
> the measurement; it is that a closing session summarised its own worksheet by its last section
> rather than by its open items.

### 7.1 What the link decomposes into — three steps, and only one is new

Write `Z := (C ⊗ overDualNumber k).left` (the thickened curve), `X := relCurve C k`, and `U : Bool →
C.left.Opens` for an affine two-chart cover of `C.left`. The kernel statement T3 wants is

```
ker( CechPic(Z) → CechPic(C.left) )  ≃+  H¹(C, 𝒪_C)          (T3, absolute form, §6.0)
```

and the chain that computes it, right to left:

| step | statement | status |
|---|---|---|
| (T3-1) | `H¹(C,𝒪) ≃+ Additive (unitsReduction C.left U₀ U₁).ker` | **LANDED** — T2, `h1AddEquivTruncExpCechKernel` |
| (T3-2) | that kernel `≃` the kernel of `pullbackOverlapQuot (relCurveMap C k[ε] k)` | ~~THE MISSING LINK — §6.24; two ingredients landed, arrow absent~~ **CLOSED §7.4, `rfl`** — `EpsArrowIdentification.lean` |
| (T3-3) | that kernel `≃` `ker(CechPic(Z) → CechPic(X))` | ~~inputs LANDED, assembly NOT written~~ **CLOSED §7.5** — `TwoChartKernelComparison.lean`, a genuine `Equiv` with (iii-c2) as a satisfiable binder |
| (T3-4) | `CechPic(X) ≃ CechPic(C.left)` and the map matches | **NOT MEASURED before this session** — §7.2; **CLOSED**, `CechPicIsoTransport.lean` |

(T3-2) is the arrow §6.24 named. (T3-4) is a step **no section of this worksheet has ever named**,
and it is where the `ε ↦ 0` morphism's target lives: `twoChartClass`'s pullback lands on
`relCurve C k`, *not* on `C.left`, because the `ε ↦ 0` map of relative curves is
`relCurveMap C k[ε] k : relCurve C k ⟶ relCurve C k[ε]`. Something has to identify `relCurve C k`
with `C.left`.

### 7.2 (T3-4) is the (3c) seam again, and it is a `CechPic` transport nobody has stated

`Tangent/DualNumberUnitTransport.lean` built exactly the object that closes (T3-4) and stopped one
step short of the consumer. `transportLeft k C : (C ⊗ Over.mk (𝟙 (Spec k))).left ⟶ relCurve C k` is
an `IsIso` (`isIso_transportLeft`), and its docstring already says why that matters: *"a consumer may
transport a kernel or injectivity statement across the seam in either direction — which is what a
kernel comparison needs."*

**What is absent is the sentence that cashes that in: `CechPic.map` along an isomorphism is
injective.** Measured this session (`grep -rn 'IsIso' Picard/Pic.lean` → nothing;
`horizon search "CechPic map isIso bijective"` → only `classDeg_cechPicMap_of_isIso`, which is about
*degrees*, not injectivity). So the tree has:

* the iso (`isIso_transportLeft`), and
* `CechPic.map_comp` / `CechPic.map_id` (`Picard/Pic.lean:223,237`),

and does not have the two-line lemma that composes them.

**Probed, kernel-green on the scratch olean root** (four probes, ~8 s each; the probe file is
`.gitignore`d as `*Probe*.lean` and stays that way — `dont-commit-a-gitignored-probe`):

```lean
example {X Y : Scheme.{u}} (f : X ⟶ Y) [IsIso f] : Function.Injective (CechPic.map f) := by
  intro a b h
  have h2 := congrArg (CechPic.map (inv f)) h
  have e : ∀ L : Y.CechPic, CechPic.map (inv f) (CechPic.map f L) = L := by
    intro L
    rw [show CechPic.map (inv f) (CechPic.map f L) = CechPic.map (inv f ≫ f) L from
          by rw [CechPic.map_comp]; rfl,
      IsIso.inv_hom_id, CechPic.map_id]
    rfl
  rw [e, e] at h2; exact h2
```

**And the `rfl` I expected to make (T3-4) free is REFUTED.** Probe 1 of the same run:

```lean
example (V : C.left.Opens) :
    relCurveMap C k[ε] k ⁻¹ᵁ ((fst C (overSpec k k[ε])).left ⁻¹ᵁ V) = (fst C (overSpec k k)).left ⁻¹ᵁ V := rfl
-- error: type mismatch … ?m = ?m  vs  relCurveMap C k[ε] k ⁻¹ᵁ … = …
```

It is `relCurveMap_preimage` (`Cohomology/RelativeSectionsLinear.lean:179`), a **theorem**. So the
opens on the two sides of (T3-2)/(T3-4) are equal propositionally and not definitionally, and the
transport is load-bearing rather than cosmetic — the same shape as (3c) itself, one level down.
(Probe 2 confirms `h ⁻¹ᵁ (U ⊓ V) = h ⁻¹ᵁ U ⊓ h ⁻¹ᵁ V` **is** `rfl`, so the *overlap* costs nothing;
it is only the base-change leg that does.)

Probes A/B/D of the same run, all green and all worth recording because each removes a step somebody
would otherwise build: `overDualNumber k = overSpec k (DualNumber k)` is **`rfl`**;
`Subsingleton (Over.mk (𝟙 (Spec k))).left` is `inferInstanceAs (Subsingleton (PrimeSpectrum k))`, so
§6.0's `picFromBase = ⊥` collapse applies at the *monoidal unit* end too and not only at `k[ε]`;
and `CechPic.map (f ≫ g) L = CechPic.map f (CechPic.map g L)` needs `rw [CechPic.map_comp]` then
`rfl` (the `MonoidHom.comp` spelling does not reduce on its own).

### 7.3 Honest sizing of T3 after this measurement, and what NOT to conclude

| item | size | note |
|---|---|---|
| `cechPicMap_injective_of_isIso` | ~~[XS], probed green~~ **LANDED** | `CechPicIsoTransport.lean`; shipped as a `MulEquiv` (`cechPicMapEquivOfIso`) since a kernel needs both directions |
| (T3-4) instantiated at `transportLeft` | ~~[S]~~ **LANDED** | `cechPicMap_transportLeft_injective` / `cechPicTransportLeftEquiv`. The `relCurveMap_preimage` transport is still NOT `rfl` and is named in that file's Scope section |
| (T3-2), the §6.24 arrow | ~~[M], and it is the real residue~~ **RETRACTED — it is `rfl`, §7.4** | I priced it by "both ingredients are landed" and then wrote, in this same subsection, that the number was a guess. It was. `EpsArrowIdentification.lean`, `rfl`, and neither named ingredient appears in it |
| (T3-3) surjectivity leg wiring | ~~[S/M]~~ **LANDED §7.5** | and the residue I was about to ship (`chartTrivial_twoChartClass`) turned out not to be needed in either direction |

**What NOT to conclude, stated because this lane's failure mode is exactly this.** The above is a
*decomposition plus one probe*, not a discharge. In particular (T3-2) is priced [M] on the strength
of "both ingredients are landed", and §6.28 is the record of what that reasoning is worth when the
composite is not attempted: it under-priced by a factor of four in one direction, and §6.19/§6.26
over-priced in the other. **The [M] on (T3-2) is a guess until a session writes the statement down
and reads the leftover goals.**

And the transferable finding of this section is not any of the sizes — it is §7.0's rule. Three
prior sessions of this lane wrote a hand-off summarising the worksheet's *last* section; §6.24's
open arrow survived all three, and one of those hand-offs upgraded it to "the pieces no longer have
gaps between them".

### 7.4 RETRACTION OF §7.3: (T3-2) IS `rfl`, AND MY OWN CAVEAT PREDICTED THAT IT MIGHT BE

*Run 0073 r7, `Tangent/EpsArrowIdentification.lean`. Kernel-green on the scratch olean root, rooted,
three headlines axiom-clean against two controls that both fire `sorryAx`. Written the same session
as §7.3, one hour later.*

**§7.3 priced (T3-2) at [M] and called it "the real residue". It is `rfl`.** Two statements, both
`rfl`, and nothing between them:

* `cechCoboundaryUnits_preimage_eq` — `dualNumberCechH1Equiv`'s target subgroup (stated with
  `resHom (preimage_mono (fst …) inf_le_left)`) and `pullbackOverlapQuot`'s source subgroup (stated
  with `resHom inf_le_left` at the family `fun s => fst ⁻¹ᵁ U s`) are **the same term**. Preimage
  distributes over `⊓` definitionally, so `preimage_mono` at `inf_le_left` *is* `inf_le_left`.
* `pullbackOverlapQuot_dualNumberCechH1Equiv_mk` — the §6.24 square itself, on generators.

**WHAT MADE IT `rfl`, and this is the reusable half: stating the target in the PULLED-BACK opens.**
The first attempt asked for the right-hand side as `Units.map (relSectionsMap …)` landing in
`Γ(relCurve C k, fst ⁻¹ᵁ (U₀ ⊓ U₁))` — the spelling the engine's downstairs side uses. That does not
typecheck, and the error names exactly the two opens `relCurveMap_preimage` relates:

```
has type      (Γ(relCurve C k, fst ⁻¹ᵁ (U false ⊓ U true)))ˣ ⧸ ?m
but expected  (Γ(relCurve C k, relCurveMap ⁻¹ᵁ fst ⁻¹ᵁ U false ⊓ relCurveMap ⁻¹ᵁ fst ⁻¹ᵁ U true))ˣ ⧸ …
```

Restated with `Scheme.Hom.unitsAppLE` **into** the pulled-back overlap — which is what
`pullbackOverlapQuot` actually produces — the whole square closes by `rfl`. This is workspace memory
`restrict-into-the-type-dont-rewrite-the-type` for the third time in this directory, and the first
time on a *base-change preimage* rather than a `≤`-restriction. The tell was identical both times: a
**type mismatch naming two opens**, not a failing tactic.

**WHY THE [M] WAS WRONG, stated precisely, because "I under-priced again" is not the useful
description.** §7.3's reasoning was *"[M] on the strength of 'both ingredients are landed'"* — i.e. I
priced the composite of `(b-coeff)` and `dualNumberCechH1Equiv` by the fact that both exist. That is
exactly the reasoning §6.28 was written to warn against, and §7.3 **says so in its own text**: *"the
[M] on (T3-2) is a guess until a session writes the statement down and reads the leftover goals."*
The caveat was correct and it was mine; what it did not do is stop me writing [M] into the sizing
table as though it were a measurement. **A caveat next to a number does not make the number a
measurement — and a reader takes the number.**

> **Rule: if you can write "this is a guess until someone writes the statement", write the statement.**
> §7.3's honest hedge cost one paragraph; discharging what it hedged cost twenty minutes, and the
> hedge would otherwise have been carried into a roadmap row and a hand-off as [M]. The distance
> between "I know this needs probing" and "I probed it" is where this lane's mis-pricings live —
> §6.28 recorded the same gap from the same side (a residue *named accurately* is not thereby
> measured).

**And `(b-coeff)`/(3c) were NOT consumed by the link they were built for.** §6.24 predicted the
arrow would be *"`(b-coeff)` composed with the (3c) object transport"*. Neither appears in
`EpsArrowIdentification.lean`. They are not thereby useless — (3c) is what
`Tangent/CechPicIsoTransport.lean` consumes for **(T3-4)**, a different step of the same chain, and
`(b-coeff)`'s unit form is what (T3-3) will read when it computes the *kernel* rather than the
square. But §6.24's decomposition of the arrow into those two pieces was wrong about the arrow, and
right that the pieces were needed *somewhere*.

**T3's RESIDUE AFTER §7.4: one step, (T3-3).** The kernel computation proper — combine T2's
`h1AddEquivTruncExpCechKernel` with `map_twoChartClass_eq_one_iff`, `twoChartClass_injective` and the
(iii-c2) surjectivity leg. Every input is landed; (T3-2) and (T3-4) are now the arrows between them,
so this is genuinely assembly. **And that sentence is subject to §7.4's own rule** — it is a
decomposition, not a measurement, and the next session should write the statement before pricing it.
(Done immediately, §7.5.)

### 7.5 (T3-3) IS LANDED, AND THE RESIDUE I WAS ABOUT TO SHIP DISSOLVED WHEN THE OBLIGATION MOVED TO A BINDER

*Run 0073 r7, `Tangent/TwoChartKernelComparison.lean`. Kernel-green, rooted, five headlines
axiom-clean against two firing controls, and the load-bearing binder checked satisfiable.*

**WHAT LANDED.** `twoChartKernelEquiv` — `twoChartClass` is a **bijection**

```
ker( pullbackOverlapQuot f )  ≃  ker( CechPic.map f )
```

for an arbitrary morphism `f : X ⟶ Y` and two-chart cover, plus the two legs
(`map_eq_one_of_pullbackOverlapQuot_eq_one`, `exists_unique_pullbackOverlapQuot_eq_one`) and the named
preimage `chartSection` with its defining equation.

**THE ONE HYPOTHESIS:** `hchart : ∀ L, CechPic.map f L = 1 → ∀ s, CechPic.map (V s).ι L = 1`. That is
clause **(iii-c2)** verbatim, it is the chain's *only* geometric input, and it has a producer at the
Wave-5 instance (`Opens.cechPicMap_ι_eq_one_of_map_eq_one` + `EpsChartSquare`). Checked satisfiable
with a junk witness (`f = 𝟙 Y`, `V s = ⊤`: the `𝟙`-kernel is trivial and `1` restricts to `1`), so
the `Equiv` is not a theorem about nothing.

**THE FINDING, and it is a shape worth naming.** My first draft of this file **had a `sorry` and was
vacuous at the same time**, and the two faults had one cause. I stated the bijection against

```
{L // (∀ s, L|_{V s} = 1) ∧ ∃ q, twoChartClass … q = L ∧ pullbackOverlapQuot f q = 1}
```

because `toFun` could not produce chart-triviality of a `twoChartClass` value — nothing in the tree
says a comparison class is trivial on each chart. So I widened the target to *include* the
existential, which made `toFun` typecheck and made the statement say **a set is in bijection with its
own image**. I then wrote a paragraph naming `chartTrivial_twoChartClass` as (T3-3)'s residue, and was
one commit from shipping "two thirds landed, one statement owed".

**It was zero statements owed.** Taking `hchart` as a *hypothesis* instead of trying to prove
chart-triviality of `twoChartClass` values:

* `toFun` needs no chart-triviality at all — only `map_twoChartClass_eq_one_iff`;
* the target becomes the honest `ker(CechPic.map f)`;
* `invFun` is `chartSection` at `hchart L L.2`;
* and the named residue is **not needed**, in either direction.

> **Rule: when a construction needs a fact nothing provides, check whether the CONSUMER could supply
> it before you weaken the statement to avoid needing it.** Widening the target to dodge a missing
> lemma is the move that produces a vacuous theorem, and it announces itself the same way an honest
> one does — it typechecks. The diagnostic question is *"does my conclusion mention my hypothesis's
> own construction?"* Here it did. Moving the obligation to a binder the Wave-5 instance already
> discharges made the statement stronger, shorter, and `sorry`-free at once.

Related and distinct: `isolating-a-residue-as-a-class` is the same failure with a `Nonempty` field;
`I-0571` is the "two ends of a map" version. This is the **subtype-target** version, and the tell is
specifically that the target's defining predicate names the source's map.

**T3's RESIDUE AFTER §7.5: the composition, and nothing else.** (T3-1)…(T3-4) are four landed
statements; `H¹(C,𝒪) ≃+ ker(CechPic(C_ε) → CechPic(C))` is the composite and is written nowhere. Per
§7.4's rule this is a decomposition rather than a measurement — but note what changed: it is now four
*arrows* to compose, not four carriers with gaps between them, which is what §7.0 found at the start
of this session. **Measured immediately, §7.6 — and there is a fifth seam nobody had named.**

### 7.6 THE COMPOSITION HAS A DOWNSTAIRS SEAM NO SECTION OF THIS WORKSHEET HAS EVER NAMED

*Run 0073 r7, closing measurement. Not a proof attempt: two `#check`s, printing the two types the
composition must join, and reading them.*

Applying §7.4's own rule to §7.5's residue before pricing it. The two arrows the composite has to
join, printed verbatim (opens abbreviated):

```
-- the ENGINE's reduction (TwoCover.unitsReduction C.left U₀ U₁), target:
   Γ(C.left, U₀ ⊓ U₁)ˣ ⧸ cechCoboundaryUnits (C.left.resHom …) (C.left.resHom …)

-- pullbackOverlapQuot (relCurveMap C k[ε] k), target:
   Γ(relCurve C k, relCurveMap ⁻¹ᵁ fst ⁻¹ᵁ U₀ ⊓ relCurveMap ⁻¹ᵁ fst ⁻¹ᵁ U₁)ˣ
     ⧸ cechCoboundaryUnits ((relCurve C k).resHom …) ((relCurve C k).resHom …)
```

**These are sections of different schemes.** The engine's downstairs side lives on `C.left`; the
geometric arrow's downstairs side lives on `relCurve C k`. (T3-2) matched the two *sources* — that is
what its `rfl` says, and §7.4's finding stands — but the composite also needs the **targets** matched,
and that is a `k → k` base-change carrier translation, the downstairs analogue of
`dualNumberCechH1Equiv`.

**WHAT EXISTS — and I almost wrote this seam down as absent.** The first draft of this section said
the only candidate was `epsChartDown` (`Tangent/EpsChartSquare.lean`), a **ring** equivalence at
**one affine** open, and concluded that the downstairs side has one of the three ingredients the
upstairs side needed. Then I searched in the *upstream* vocabulary rather than this lane's, and found

```
sectionsCollapse : Γ(C.left, V) ≃ₗ[k] Γ(relCurve C k, fst ⁻¹ᵁ V)
    -- Cohomology/RelThetaTransportCore.lean:41
sectionsCollapse_mul     -- multiplicative, so it induces a map of UNIT groups   (:116)
sectionsCollapse_resHom  -- naturality in the open                              (:235)
```

at **arbitrary** `V` with only compact/quasi-separated hypotheses, **no affineness**, landed since the
relative-theta work and used by four declarations there. That is the same two lemmas
(`dualNumberSectionsUnits` needs multiplicativity, `resHom_dualNumberSections` needs
naturality-in-the-open) from which the *upstairs* chain built its `Ȟ¹` equivalence in
`Tangent/DualNumberCarrierCoboundary.lean` — and per that file's own docstring the subgroup step is
then `Subgroup.map_sup` plus one range identification per chart, "no `Bool` case analysis".

**So the honest statement of T3's residue is two items, and the first is smaller than the draft of
this very section said:**

| item | what | size |
|---|---|---|
| (T3-5) the downstairs `Ȟ¹` translation | the `k → k` analogue of `dualNumberCechH1Equiv`, over `sectionsCollapse` (**not** `epsChartDown`) | ~~[S/M], not measured~~ **LANDED, §7.7** — `Tangent/CollapseCechH1.lean` |
| (T3-6) the composite proper | chain (T3-1) → (T3-2) → (T3-5) → (T3-3) → (T3-4) into `H¹(C,𝒪) ≃+ ker(CechPic(C_ε) → CechPic(C))` | **T3's only residue.** Unmeasured, including whether it comes out additive |

> **Rule, third occurrence in this lane and the reason the §7.0 grep is not enough:** the consumer
> grep tells you an arrow is missing; it does not tell you the arrow is *unbuilt*. `epsChartDown` is
> the object **this lane** made for this job, so searching my own vocabulary found it and stopped.
> `sectionsCollapse` is the same mathematics, built for a different purpose in a different directory,
> stronger (arbitrary opens), and with both auxiliary lemmas already proved. **Search the object's
> shape across the whole project, not the name your lane coined for it.**

**AND THE `≃+` IS A THIRD THING.** Every arrow in the chain is a `MulEquiv` or a bare `Equiv`; the
statement T5 consumes is **additive**, and `Additive`-wrapping a multiplicative kernel is what
`h1AddEquivTruncExpCechKernel` already does on the (T3-1) leg. Whether the composite comes out
additive without extra work is unmeasured. The `.t5` row's standing trap applies with full force here:
T5 needs the **semilinear** comparison, so even a perfect additive composite leaves the intertwining
across `κ(e) ≃+* k` to be supplied.

> **Rule, and it is §7.4's rule applied one level up.** §7.5 wrote "the residue is the composition,
> and nothing else" — a decomposition stated as if it were complete. Two `#check`s refuted it in
> ninety seconds. **When you name a composition as the residue, print the types of the arrows you
> intend to compose and read them**, because a composition's cost is entirely in the seams, and a
> seam is invisible in a list of the pieces. This is the same instrument as §7.0's consumer grep,
> pointed at types instead of names.

**T3's RESIDUE AFTER §7.6: (T3-5) then (T3-6)** — and §7.7 closes (T3-5) the same session, so read on
before pricing anything.

### 7.7 (T3-5) IS LANDED, AND "FAILED TO SYNTHESIZE INSTANCE" WAS NOT ABOUT AN INSTANCE

*Run 0073 r7, `Tangent/CollapseCechH1.lean`. Kernel-green, rooted, seven headlines axiom-clean
against two firing controls. Six declarations; five of the six were green on the first attempt.*

**WHAT LANDED.** `collapseCechH1Equiv` — the two-chart Čech `Ȟ¹`-of-units groups of `C.left` and of
`relCurve C k` agree, built exactly as §7.6 predicted: `collapseRingEquiv` (from
`sectionsCollapse` + `sectionsCollapse_mul`), `collapseUnits`, `unitsMap_resHom_collapseUnits`
(from `sectionsCollapse_resHom`), `range_collapseUnits_comp`,
`map_cechCoboundaryUnits_collapseUnits`, then `QuotientGroup.congr`. §7.6's route was right and its
[S/M] was, for once, not an over- or under-price — it was simply untested, and testing it took
twenty minutes.

**THE ONE WALL, AND THREE WASTED ATTEMPTS AT IT.** Copying `Over.dualNumberCechH1Equiv`'s spelling
`QuotientGroup.congr _ _ e he` fails here with

```
failed to synthesize instance of type class
  (cechCoboundaryUnits ((relCurve C k).resHom ⋯) ((relCurve C k).resHom ⋯)).Normal
```

I read that as a missing instance and tried three fixes, all of which failed and **none of which was
addressing the problem**: a `haveI` at the use site; a project-local
`Subgroup.normal_of_isMulCommutative` instance at matched universes; and dropping
`Scheme.overModule` from the file's local instances (on the theory that two `CommRing` paths were
competing — the keying trap this lane has recorded before).

**The measurement that ended it.** In a standalone probe, `inferInstance` produces that exact
`Normal` instance, and the quotient *type* elaborates too — for the `relCurve C k` spelling, the
`(C ⊗ overSpec k k).left` spelling, and the dual-number spelling alike. So the instance was never
absent. The failure came from the two positional `_`s: with the subgroups left as **metavariables**,
elaboration reaches the `[Normal]` instance argument before they are solved, and instance search
cannot key on a metavariable. **Naming both subgroups explicitly in the `congr` call closes it with no
instance work at all.**

> **Rule: "failed to synthesize instance" is not always about the instance — check whether the
> instance's own arguments are still metavariables.** The message names a fully-elaborated-looking
> subgroup (`⋯` hides the `≤` proofs), which is exactly what makes it read as an absence. The
> discriminating test is one `#check (inferInstance : …)` in a standalone file with the arguments
> spelled out: if it succeeds there, the problem is elaboration order at your call site, not the
> instance graph. This is the inverse of `measure-the-instance-surface`, and it cost three fixes to
> a non-problem.
>
> Corollary, since it is why I copied the failing spelling in the first place: **a spelling that
> works in a sibling file is not thereby a spelling.** `dualNumberCechH1Equiv` gets away with `_ _`
> because its own elaboration happens to solve them first.

**T3's RESIDUE AFTER §7.7: (T3-6) alone — the composite.** Five landed arrows
((T3-1)…(T3-5)); `H¹(C,𝒪) ≃+ ker(CechPic(C_ε) → CechPic(C))` is their composition and is written
nowhere. Unmeasured, **including whether it comes out additive**: every arrow in the chain is a
`MulEquiv` or a bare `Equiv`, `Additive`-wrapping happens only on the (T3-1) leg, and T5 needs the
**semilinear** form on top of that. Per §7.6's own rule, print the types before pricing it.
