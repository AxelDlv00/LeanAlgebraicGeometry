# LeanAG — Scope Roadmap (condensed)

A high-level, mathematical checklist across the scope's member projects.

**Legend:**

- [x] proved / sorry-free (or, for a theme, its keystone declarations are sorry-free)
- [~] in progress (declarations exist, residual `sorry`)
- [ ] not started (no Lean yet — blueprint only, or theme not begun)

**Status snapshot** *(open `sorry` counts over each project's `AlgebraicJacobian/` source
tree, comments/docstrings excluded; last full hand-measure 2026-06-22. The two active loops
move these between pushes — the **[live dashboard](https://axeldlv00.github.io/LeanAlgebraicGeometry/)**
holds the authoritative per-node counts):*

| Project | Stage | Open `sorry` |
| --- | --- | --- |
| Algebraic-Jacobian-Challenge | prover | 86 ✨ |
| Cech-Cohomology | ✅ complete | 0 ✨ |
| Line-Bundle-Comparison-Iso | prover | 4 ✨ |
| Albanese | prover | 17 ✨ |
| RiemannRoch | prover | 25 ✨ |
| Quot-Foundations | ⏸️ deferred | 21 |
| GR-quot_closure | ✅ complete · merged → AJC | 0 ✨ |
| FBC-B_SNAP-chain | ⏸️ paused (mate route superseded; reusable salvaged → AJC) | 20 (preserved) ✨ |
| MR0555258-compactifying-picard | prover | 5 ✨ |
| 35 related-paper projects | 📝 blueprint only | 0 Lean (stub aggregators) |

> **Which related papers can be formalized now (or almost)?** See the
> [Related-Papers roadmap → Formalization-readiness ordering](SubProjects/RelatedPapersFormalisation/roadmap.md#formalization-readiness-ordering--what-can-be-formalized-now-or-almost):
> five papers are **`R0` (ready now)** — `MR2223407` (Picard scheme), `MR2223407`
> (Hilbert/Quot), `MR3267585` (cohomology & base change), `MR1432198`, `MR1681097` — because
> their core obligation reduces to scope interfaces already proved sorry-free; five more are
> **`R1` (almost)**, waiting on the in-progress Albanese leg or Picard-functor close. This
> readiness axis is orthogonal to the `AJC #N` overlap ordering and follows the colleague's
> audit report (`SubProjects/RelatedPapersFormalisation/lean_mathlib_formal_audit_report.pdf`).

---

## Dependency spine

### Core algebraic-geometry engine

- `Line-Bundle-Comparison-Iso` → `Algebraic-Jacobian-Challenge` (largest leverage: unblocks the Picard / comparison-iso substrate; merges back the `A.1.c.sub` package)
- `Albanese` → `Algebraic-Jacobian-Challenge` (extracted Albanese / abelian-variety leg — Albanese universal property, codim-one & Thm 3.2 rational-map extension, Auslander–Buchsbaum/coheight bridge; merges back) ✨ 2026-06-20
- `RiemannRoch` → `Algebraic-Jacobian-Challenge` (extracted Weil-divisor / Riemann–Roch core — `O(D)`/`O(P)`, skyscraper SES, `H¹`-vanishing, RR formula, rational-curve iso; merges back) ✨ 2026-06-20
- `Cech-Cohomology` ↔ `Algebraic-Jacobian-Challenge` (the Čech `Rⁱf_*` engine is the cohomological substrate; proved sorry-free here, **merged sorry-free into the AJC tree** ✨ 2026-06-19 — all Čech MERGE-STUBs restored with the working proofs, AJC's full `lake build` is green and the capstone `cech_computes_higherDirectImage` is axiom-clean)
- `GR-quot_closure` → `Algebraic-Jacobian-Challenge` (Grassmannian-quotient representability H⁰ leg — `Grassmannian.represents`, SNAP section graded ring/module, cell-chart/glue-descent atlas; **merged sorry-free into the AJC tree** ✨ 2026-06-22 via a `union` merge, AJC `lake build` green) — originally extracted from `Quot-Foundations`
- `FBC-B_SNAP-chain` → `Quot-Foundations` (extracted work package of the Quot/Picard-representability cone; shares the SNAP section-graded-ring foundation `Picard/SectionGradedRing.lean` with `GR-quot_closure`)
- `Quot-Foundations` → `Algebraic-Jacobian-Challenge` (the H⁰ Picard-representability cone — flat base change, Grassmannian, Quot — merges back; **deferred**, active work now lives in the `GR-quot_closure` / `FBC-B_SNAP-chain` extractions)

### Related papers → AG base

The 35 related-paper formalisations all depend on the core AG engine (schemes, cohomology,
curves, Picard) and are **blueprint-stage only**. Their per-paper `Requires` / `New infra`
breakdown, the shared-infrastructure vocabulary, coverage tiers, and the formalization-readiness
ordering now live in the dedicated **[Related-Papers roadmap](SubProjects/RelatedPapersFormalisation/roadmap.md)** ✨,
so this scope roadmap stays focused on the Jacobian-challenge critical path.

---

## Algebraic-Jacobian-Challenge  *(core engine — prover stage, 86 open `sorry`)* ✨

**Goal:** the Jacobian of a smooth proper geometrically-irreducible curve — smooth of
relative dimension = genus, proper, geometrically irreducible, and the Albanese variety
(`exists_unique_ofCurve_comp`). Spine = pointed vs. unpointed; 0 project axioms.

- [x] **Kähler-differential / cotangent substrate** — `Cotangent/GrpObj`, `Cotangent/ChartAlgebra`, `Differentials` (cotangent iso, chart algebra) **sorry-free**
- [x] **Rigidity & Abel–Jacobi scaffolding** — `Rigidity`, `RigidityLemma`, `Genus`, `AbelJacobi` **sorry-free**
- [x] **Line-bundle coherence substrate** — `Picard/LineBundleCoherence`, `Picard/LineBundlePullback`, `Picard/RelPicFunctor`, `Picard/RelativeSpec` **sorry-free** (local triviality, pullback-tensor compatibility)
- [x] **Čech higher-direct-image engine (A.2.c)** — the comparison theorem `cech_computes_higherDirectImage` and `pushPull` functoriality (`pushPullFunctor`, `pushPullMap_comp`) are **proved sorry-free in `Cech-Cohomology`** and merged in **sorry-free** ✨; `cechHigherDirectImage` is sorry-free in the AJC tree. *(The Čech theorem itself has no open mathematical gap.)*
- [x] **Čech merge-back RESTORED** ✨ *(2026-06-19)* — the former **7 MERGE-STUBs** (`CechSectionIdentificationLeg` ×5, `CechToHigherDirectImage` ×2, `sorry`-ed during the merge to dodge build-time elaboration blow-ups) are now **replaced with the working proofs from `Cech-Cohomology` and build clean**: the monolithic `…Leg` was split to match the subproject (`…Mid1/Mid2/Top/Aux`) and the `cechAugmented_to_acyclicResolutionInput` iso proof was given a term-shrinking rewrite. AJC's full `lake build` is green; the AJC capstone `cech_computes_higherDirectImage` depends only on `[propext, Classical.choice, Quot.sound]`.
- [~] **Flat base change (Stacks 02KH)** ✨ *(2026-06-24, Čech route)* — `cech_flatBaseChange` (`CechHigherDirectImageUnconditional`): the top-level assembly **and all homology machinery are now sorry-free** (separated case — **no spectral sequence**: `mapHomologicalComplexHomologyIso`, flat-pullback `PreservesHomology` derived via `preservesHomologyOfExact`, `pullback_mapHC_homologyIso`). **Two** genuine open leaves remain: `pullback_preservesFiniteLimits` (flat ⇒ `g^*` left-exact — verified-reduced to presheaf-pullback left-exactness; `forget`+`sheafification` already preserve finite limits in Mathlib) and `cechComplex_baseChange_iso` (Stacks 02KG, the termwise affine base change, via the still-open `affineBaseChange_pushforward_iso` in `FlatBaseChange`). Reusable FBC-B foundations salvaged in-tree sorry-free (`Cohomology/RegroupHelper`, `Cohomology/FlatBaseChangeGlobal` prefix: `gammaTopEquivEqLocus`, `baseChangeGammaEquiv`). *(Not a gap in the Čech engine itself; full general/qcqs 02KH would additionally need the Čech-to-cohomology spectral sequence — present only abstractly in Mathlib.)*
- [~] **Group schemes** — `Ga`, `Gm`, `ProjectiveLineBar` (ℙ¹) **defined**; `Genus0BaseObjects` carries **2 residual `sorry`** (`BareScheme`, `GmScaling`) *(was previously mismarked "not started")*
- [~] **Tensor/dual comparison substrate + Picard group (A.1.c.sub)** — `Picard/TensorObjSubstrate` defines `PicGroup`/`picCommGroup` and the slice-dual transport; **3 residual `sorry`** *(shared with `Line-Bundle-Comparison-Iso`)*
- [~] **Weil divisors & Riemann–Roch core** — order valuation, degree homomorphism, principal divisors, skyscraper SES (`RiemannRoch/*`, **15 `sorry`**: `RationalCurveIso`, `OcOfD`, `OCofP`, `WeilDivisor` ×3 each; `H1Vanishing` ×2; `RRFormula` ×1)
- [~] **Albanese / abelian-variety leg** — `Albanese/*` (**12 `sorry`**: `AlbaneseUP` ×7, `CodimOneExtension` ×3, `Thm32RationalMapExtension` ×2; `AuslanderBuchsbaum`, `CoheightBridge` sorry-free)
- [x] **GR/Quot representability merged from `GR-quot_closure`** ✨ *(union merge 2026-06-22)* — the relative-Grassmannian representability deliverable is now in-tree **sorry-free**: `Grassmannian.represents` (rank-`d` quotient-functor representability), `tautologicalQuotient_epi`, the section graded **ring** (`sectionGradedRing_gcommSemiring`, Stacks 01CV) and graded **module** (`sectionGradedModule_gmodule`) lanes, graded Hilbert–Serre rationality, and the Grassmannian cell-chart / glue-descent atlas. Five new sorry-free files (`Picard/GrassmannianCells`, `GlueDescent`, `GrassmannianQuot`, `GradedHilbertSerre`, `SectionGradedRing`). `QuotScheme.lean` was reconciled as a *union* (AJC's base-change cohomology lane kept; the subproject's quasi-coherent descent machinery appended). Three same-name/different-meaning collisions with the existing `TensorObjSubstrate` were resolved by renaming the imported copies (`sheafTensorObj`, `IsInvertibleGr`, `gr_pullbackObjUnitToUnit_comp`) — both implementations kept. Full `lake build` green; **0 new `sorry`**.
- [~] **Picard representability cone** — `Picard/QuotScheme` (×12: the χ-blocked `hilbertPolynomial`/`QuotFunctor`/`Grassmannian.representable` stubs + Quot endgame), `IdentityComponent` (×9), `FGAPicRepresentability` (×7), `FlatteningStratification` (×7), `Pic0AbelianVariety` (×5) *(the Grassmannian-representability substrate `Grassmannian.represents` is now sorry-free in-tree — see above)*
- [~] **Flatness & generic flatness** — flat-locus open → Noetherian stratification (`FlatteningStratification`; shared root with `Quot-Foundations`)
- [ ] **Smooth proper curves** — projectivity, normalization iso, function-field equivalence *(held: classically RR-dependent; Route C paused)*
- [ ] **Top goal: `Pic_{C/k}` representability + Jacobian = Albanese** *(once the substrate + engine themes close)*

## Cech-Cohomology  *(✅ complete — 0 open `sorry`; merged back sorry-free into AJC ✨ 2026-06-19)*

**Goal:** `cech_computes_higherDirectImage` — for a separated quasi-compact `f : X ⟶ S`,
a quasi-coherent `F`, and a finite affine open cover, the cohomology of the relative Čech
complex computes `Rⁱf_* F`. Unconditional (no enough-injectives appeal).

- [x] **Combinatorial / free Čech engine** — alternating coface complex, homotopy contraction, exactness
- [x] **Section Čech complex & localization comparison** — `AwayComparison`, `phi/phiL` naturality
- [x] **Affine acyclicity (Serre vanishing)** — tilde-vanishing ⇒ affine Čech vanishing
- [x] **Cover/nerve combinatorics** — Čech nerve, wide pullbacks, `pushPull` sigma iso, finitary-extensive distributivity
- [x] **Quasi-coherence on opens** — over-equivalences, restrict-to-basic-open, modules-over-opens equivalence
- [x] **Higher direct image & acyclicity** — injective resolutions, horseshoe lemma, pushforward acyclicity
- [x] **PushPull functoriality** — `pushPullMap` composition, leg coherence, pentagon
- [x] **Comparison theorem `cech_computes_higherDirectImage`** *(proved iter-079, 0 sorries)*

## Line-Bundle-Comparison-Iso  *(prover stage — extraction hub → Jacobian, 4 open `sorry`)* ✨

**Goal:** the comparison-isomorphism substrate giving `Pic♯_{C/k}` its abelian-group
structure (the A.1.c.sub package; merges back into the Jacobian challenge).

- [x] **Stalk-tensor / internal-hom machinery** — `TensorObjSubstrate/StalkTensor`, `PresheafInternalHom` **sorry-free**
- [x] **Slice-dual transport iso (DUAL route)** — `TensorObjSubstrate/DualInverse`, `DualInverse/SliceTransport` **sorry-free**
- [x] **Line-bundle pullback / relative Pic functor** — `LineBundlePullback`, `RelPicFunctor` **sorry-free**; seed `pullback_tensor_iso_loctriv` delivered ✨
- [x] **Bridge B2 terminal blocker** — `TensorObjInverse.restrictFunctorIsoPullback_comp_compat` is closed axiom-clean; `TensorObjInverse.lean` builds green with the blocker gone ✨
- [~] **Terminal comparison inverse** — `TensorObjInverse` (×4): B1 crux, immersion-compatibility squares, and final trivialisation restriction compatibility ✨

## Albanese  *(prover stage — extraction → Jacobian, 17 open `sorry`)* ✨

**Goal:** the Albanese universal property of `Pic⁰` (Milne III §6 Prop 6.1, seed
`thm:albanese_universal_property`) and the rational-map-extension machinery feeding the
abelian-variety leg of the Jacobian challenge. Extracted from `Algebraic-Jacobian-Challenge`
on 2026-06-20; merges back. *(Full `lake build` green — the carve had dropped load-bearing
`Genus0BaseObjects/BareScheme` grading / `Over` / standard-smooth instances, restored from
the parent ✨ 2026-06-20.)*

- [x] **Auslander–Buchsbaum / coheight bridge** — `Albanese/AuslanderBuchsbaum`, `Albanese/CoheightBridge` **sorry-free**
- [x] **Rigidity lemma + structure-sheaf module substrate** — `RigidityLemma`, `Cohomology/StructureSheaf*` **sorry-free**
- [~] **Albanese universal property** — `Albanese/AlbaneseUP` (×7): the headline `Pic.albaneseUP` + universal-map descent
- [~] **Codim-one & Thm 3.2 rational-map extension** — `Albanese/CodimOneExtension` (×3), `Albanese/Thm32RationalMapExtension` (×2)
- [~] **FGA Picard representability slice** — `Picard/FGAPicRepresentability` (×2)
- [~] **Genus-0 base + Weil-divisor riders** — `Genus0BaseObjects/BareScheme` (×1, `projectiveLineBar_geomIrred` scaffold), `Genus0BaseObjects/GmScaling` (×1), `RiemannRoch/WeilDivisor` (×1)

## RiemannRoch  *(prover stage — extraction → Jacobian, 25 open `sorry`)* ✨

**Goal:** the Weil-divisor / Riemann–Roch core for a smooth proper curve — order valuation,
degree homomorphism, `O(D)`/`O(P)`, the skyscraper SES, `H¹`-vanishing, and the RR formula.
Extracted from `Algebraic-Jacobian-Challenge` on 2026-06-20; merges back. *(Full `lake build` green.)*

- [x] **Structure-sheaf module substrate + rigidity** — `Cohomology/StructureSheaf*`, `RigidityLemma` **sorry-free**
- [x] **`O(D)` carrier-stalk chain** — the S3 binding leaf `carrierSheaf_stalk_eq` is closed axiom-clean; `OcOfD` dropped from 11 to 6 sorries ✨
- [~] **Weil divisors and smooth-regular substrate** — `RiemannRoch/WeilDivisor` (×2), `RiemannRoch/SmoothRegular` (×1): divisor arithmetic plus the smooth-stalk regularity bridge
- [~] **`O(D)` / `O(P)` line bundles** — `RiemannRoch/OcOfD` (×6), `RiemannRoch/OCofP` (×3): carrier, cokernel, and skyscraper SES bridges
- [~] **`H¹`-vanishing & RR formula** — `RiemannRoch/H1Vanishing` (×1), `RiemannRoch/RRFormula` (×5)
- [~] **Rational-curve iso + abelian-variety rigidity** — `RiemannRoch/RationalCurveIso` (×3), `AbelianVarietyRigidity` (×1)
- [~] **Genus-0 base riders** — `Genus0BaseObjects/BareScheme` (×1), `Genus0BaseObjects/GmScaling` (×2)

## Quot-Foundations  *(⏸️ deferred — 21 open `sorry`; active work moved to subproject extractions)*

**Goal:** the Čech-independent (i = 0) leg of FGA Picard representability — flat base
change, generic flatness, and Quot/Grassmannian foundations. The Grassmannian-quotient
representability endgame and the flat-base-change/SNAP legs are carved into the sibling
extractions `GR-quot_closure` and `FBC-B_SNAP-chain` (below); proofs merge back here.
**Deferred:** the directory is parked as `Quot-Foundations-[deferred_to_subprojects]` while
the two extractions carry the active proving.

- [x] **Grassmannian construction & gluing** — `GrassmannianCells`, `GlueDescent` **sorry-free** (rank-quotient setoid, charts, transition cocycle, effective descent)
- [x] **RelativeSpec / flattening stratification** — `RelativeSpec`, `FlatteningStratification` **sorry-free**
- [x] **Graded Hilbert–Serre helper** — `GradedHilbertSerre`, `RegroupHelper` **sorry-free**
- [~] **Flat base change (degree 0)** — `Cohomology/FlatBaseChange` (×4), `FlatBaseChangeGlobal` (×1); pushforward Mayer–Vietoris / finite-generation criteria
- [~] **Tautological / universal quotient** — `GrassmannianQuot` (×3): `represents` done, `tautologicalQuotient_epi` closing
- [~] **Quot scheme** — `QuotScheme` (×4): `RepresentableBy` upgrade + Quot-representability core
- [~] **Section graded ring (SNAP)** — `Picard/SectionGradedRing` (×9): cast coherence → Hilbert polynomial *(shared with the sibling extractions)*

## GR-quot_closure  *(✅ complete — 0 open `sorry`; core deliverable merged back sorry-free into AJC ✨ 2026-06-22)*

**Goal:** representability of the relative Grassmannian — the Čech-independent (H⁰) leg that
builds `Grass(V, d)` from affine charts via the `GL_d` cocycle and proves it represents the
rank-`d`-quotient functor. Extracted from `Quot-Foundations`. **Merged back into
`Algebraic-Jacobian-Challenge` ✨ 2026-06-22** (union merge): the five sorry-free files +
`Grassmannian.represents` + the SNAP graded ring/module lane are now in the AJC tree, AJC
`lake build` green. *(The configured `enrich` scope was a no-op — all shared declarations
were identical or target-stronger — so the merge ran as a `union` to carry the real,
non-shared deliverable; three `Scheme.Modules.*` name collisions resolved by renaming the
imported copies.)*

- [x] **Grassmannian cells, gluing & descent** — `GrassmannianCells`, `GrassmannianQuot`, `GlueDescent`, `GradedHilbertSerre`, `RelativeSpec` **sorry-free** *(now also in AJC)*
- [x] **Section graded ring (SNAP)** — `Picard/SectionGradedRing` **sorry-free** through the graded ring and module stretch ✨ *(now also in AJC)*
- [x] **Quot scheme** — `QuotScheme` **sorry-free** ✨ *(2026-06-22)*: the four χ-blocked endgame stubs (`hilbertPolynomial`, `QuotFunctor`, the `Grassmannian` functor def, `Grassmannian.representable` — the Hilbert-polynomial/χ formulation, distinct from the proved `Grassmannian.represents`) were **removed** from this leg, since they need the cohomology / Euler-characteristic engine that is out of scope for the H⁰ Grassmannian deliverable; the file's sorry-free quasi-coherent-descent machinery is retained and `lake build` is green (8317 jobs). *(The same stubs still live in the AJC tree's own `Picard/QuotScheme` copy — see the AJC §"Picard representability cone" line — and remain open there.)*

## FBC-B_SNAP-chain  *(⏸️ PAUSED 2026-06-24 — dir renamed `…-[paused-superseded-by-cech-route]`)* ✨

**Status:** **PAUSED.** The FBC adjoint-mate route to `affineBaseChange_pushforward_iso` /
`flatBaseChange_pushforward_isIso` walled (~30 iters; kernel timeouts; missing
`tilde ↔ extendScalars` bridge). Stacks 02KH is now pursued via the **Čech route in AJC**
(see AJC §"Flat base change (Stacks 02KH)"). Work is preserved (files on disk + pushed to
GitHub); reusable sorry-free pieces were **salvaged into AJC** (`Cohomology/RegroupHelper`
whole, `Cohomology/FlatBaseChangeGlobal` sorry-free prefix). Pausing also dormanted the SNAP
leg (bundled in the same subproject). See the subproject's `PAUSED.md`.

- [x] **Regroup helper** — `Cohomology/RegroupHelper` **sorry-free** *(salvaged → AJC ✨)*
- [x] **FBC ring-square mate legs** — geometric and algebraic mate legs in `Cohomology/FlatBaseChange` are closed axiom-clean *(preserved; route superseded)*
- [⏸️] **Flat base change (FBC-B)** — mate route walled; superseded by the AJC Čech route. The sorry-free `FlatBaseChangeGlobal` equalizer/flat-tensor foundation salvaged → AJC ✨
- [⏸️] **Section graded ring (SNAP)** — `Picard/SectionGradedRing` (×11) + `SectionGradedRingLocalized` (sorry-free): paused with the subproject (preserved, not merged)

---

## Related papers  *(📝 blueprint stage — moved to a dedicated roadmap ✨ 2026-06-30)*

The 35 related-paper projects now live in their own roadmap to keep this file readable:
**[SubProjects/RelatedPapersFormalisation/roadmap.md](SubProjects/RelatedPapersFormalisation/roadmap.md)**.

They are blueprint-only (Lean targets are stub aggregators, 0 real declarations) and do **not**
directly contribute to the Jacobian challenge. Five are formalization-ready *now* (`R0` —
`MR2223407` Picard scheme, `MR2223407` Hilbert/Quot, `MR3267585` cohomology & base change,
`MR1432198`, `MR1681097`); the readiness ordering (`R0`–`R3`) and full per-paper catalogue are
in that roadmap.
