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
