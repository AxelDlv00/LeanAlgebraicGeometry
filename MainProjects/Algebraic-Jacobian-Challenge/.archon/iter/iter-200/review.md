# Iter-200 (Archon canonical) — review

## Outcome at a glance

- **The "second iter under USER 2026-05-28 standing directive (ROUTE
  C PAUSE permanent / Route A bottom-up / reference-driven
  mathlib-build) following the iter-200 plan agent's option-(c)
  honest-framing commit on A.2.c REJECT-level finding + 3 Route A
  substrate-only prover lanes (WD-A4a Sub-build 1; AB-gap1-HasPdLT
  ALIGN_WITH_MATHLIB pivot; COE-stage6-iiB Stacks 00OE 3-step
  Krull-dim formula) + 19 axiom-clean substrate declarations
  landed across the 3 files + 2 of 3 HARD BARs MET via substantive
  structural advance (WD: 8 substrate decls + IsRegularInCodimensionOne
  open-immersion descent instance; COE: 7 substrate decls + Step 1+2
  fully + Step 3 partial; AB: Steps (i)+(ii) closed axiom-clean but
  Step (iii) blocked on Stacks 00MF — 4 helpers landed, body
  scaffolded ending trailing sorry) + iter-200 plan-phase 5
  subagents returned (progress-critic / strategy-critic / blueprint-
  reviewer / blueprint-writer tensorobj-substrate-chapter /
  mathlib-analogist coe-stacks00oe) + iter-200 review-phase 4
  subagents dispatched in parallel (lean-auditor iter200 + 3
  lean-vs-blueprint-checker {wd,ab,coe}-iter200) + sync_leanok iter
  =200 ran (3 added / 6 removed, chapters_touched =
  Albanese_AuslanderBuchsbaum / Picard_TensorObjSubstrate /
  RiemannRoch_WeilDivisor)" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per
  `logs/iter-200/meta.json` `prover.status: done`,
  `planValidate.objectives: 3`. **3/3 prover lanes returned `done`
  clean (no API 529 errors)**. **20th consecutive zero-axiom build
  streak** (0 → 0 project axioms).

- **Sorry trajectory**: iter-199 baseline **78** → iter-200 exiting
  **78**. **Net delta 0** (substrate-only iter, no top-level sorry
  closures). Per-file sorries: WD 3 → 3, AB 1 → 1, COE 3 → 3.

  The iter lands in the **worst-case band** of the iter-200 plan
  agent's projection ("Worst case: 78 → 77-78"). The substrate-only
  outcome was anticipated; the 3 lanes are structurally homogeneous
  (mathlib-build substrate-build) and no headline closure was
  expected. The cascade opportunity (Lane COE (ii.B) →
  `isRegularLocalRing_stalk_of_smooth` L1061 → Lane T32 derivative)
  did not fire because Step 3 of the Krull-dim formula is partial
  (additive substrate landed; the Jacobian-regular-sequence witness
  is the iter-201+ Lane COE main effort).

- **HARD BAR landings**: 2 of 3 lanes met HARD BAR via substantive
  structural advance.
  - Lane WD-A4a Sub-build 1: **MET**. 8 axiom-clean substrate decls
    (PrimeDivisor.ext, restrictToOpen, ofOpen, +2 simp helpers,
    equivOpen, stalkIso, IsRegularInCodimensionOne.instOpen) +
    PUSH-BEYOND step 4 met. +120 LOC realized (analogist budget 150-
    250 LOC); analyst recipe followed verbatim with one-line
    `noncomputable` friction.
  - Lane COE-stage6-iiB: **MET**. 7 axiom-clean private substrate
    theorems (Step 1+2 fully + Step 3 partial additive form).
    Capstone `ringKrullDim_localization_atMaximal_MvPolynomial`
    collapses Steps 1+2 into a single consumer call. Substantive
    proof of the iter is the `MvPolynomial.maximalIdeal_height_eq_card`
    induction on `Fin n` via `finSuccEquiv` +
    `Polynomial.height_eq_height_add_one` + Jacobson contraction.
  - Lane AB-gap1-HasPdLT: **NOT MET**. ALIGN_WITH_MATHLIB pivot per
    `ab-natrecursive` analogist Path A delivered Steps (i)+(ii)
    closed axiom-clean (4 helpers landed: `…_succ_of_…_eq`,
    `…_ker_of_surjection`, `…_succ_of_…_ker`, `depth_ker_ge_min_…`).
    Body of `auslander_buchsbaum_formula_succ_pd` scaffolded ending
    in trailing sorry; Step (iii) inductive assembly blocked on
    Stacks 00MF base case (`pd M > 0 ⟹ depth M < depth R`) + ℕ∞
    arithmetic that itself depends on the AB formula being proven.

- **Plan trajectory** entering iter-200 (per iter-200 plan): best
  78 → ~75-76, realistic 78 → ~77-78, worst 78 → ~77-78. iter-200
  lands a **0-net (worst-case)** outcome with substantive HARD BAR
  landings on 2 of 3 lanes — canonical substrate-vs-closure
  trade-off; substrate forward-compatible toward iter-201+ closures.

- **Reviewer-phase subagents** — see `## Subagent dispatches`
  section below.

- **`sync_leanok` iter=200**: 3 added / 6 removed / 3 chapters
  touched (`Albanese_AuslanderBuchsbaum.tex`,
  `Picard_TensorObjSubstrate.tex`, `RiemannRoch_WeilDivisor.tex`).
  The net-negative removals reflect deterministic stripping where
  the Lean side either lost or never had the `\leanok`-eligible
  state (the iter-200 plan agent created a fresh
  `Picard_TensorObjSubstrate.tex` chapter; the writer's draft
  included candidate `\leanok` markers the sync phase pruned because
  the corresponding decls don't exist yet).

## Per-lane outcomes

### Lane WD-A4a Sub-build 1 — `RiemannRoch/WeilDivisor.lean`

**Outcome**: HARD BAR MET + PUSH-BEYOND step 4 MET. 8 axiom-clean
substrate decls landed at L153–L305 (+120 LOC). Trailing sorries at
L535/L843/L1413 untouched per SCOPE FENCE. `Scheme.PrimeDivisor.ext`,
`restrictToOpen`, `ofOpen`, simp helpers, `equivOpen`, `stalkIso`
(wrapper around Mathlib's `Scheme.Opens.stalkIso`),
`IsRegularInCodimensionOne.instOpen` (open-immersion descent
instance via `IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing`).

**What was learned**: `IsLocallyNoetherian U.toScheme` is automatic
from typeclass propagation; `IsIntegral U.toScheme` is NOT — threaded
explicitly. Analogist `wd-stacks02iz` recipe followed verbatim with
zero dead-ends.

**Iter-201+ handoff**: Sub-build 2 is `Ring.ordFrac` transport
across stalk iso (~30-50 LOC, Mathlib gap candidate); Sub-build 3
is `Scheme.RationalMap.order` naturality across `stalkIso U Y hYU`
(conditional on Sub-build 2). Cascade: closing all 3 Sub-builds
closes L535 `rationalMap_order_finite_support` non-zero branch.

### Lane AB-gap1-HasPdLT — `Albanese/AuslanderBuchsbaum.lean`

**Outcome**: HARD BAR NOT MET. ALIGN_WITH_MATHLIB pivot per
`ab-natrecursive` mathlib-analogist Path A produced 4 axiom-clean
substrate helpers in `RingTheory.Module` namespace (L1290, L1311,
L1340, L1376). Body of `auslander_buchsbaum_formula_succ_pd`
modified to set up the SES-descent path; ends in trailing sorry at
L1574-area. Sorries 1 → 1.

**Substrate landed** (~45 LOC, analogist budget 25-40 LOC for
Steps (i)+(ii)):
- `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq` — bridge
  from `Module.projectiveDimension R M = (n : WithBot ℕ∞)` to
  `HasProjectiveDimensionLT (ModuleCat.of R M) (n + 1)` via
  `CategoryTheory.projectiveDimension_lt_iff`.
- `hasProjectiveDimensionLT_ker_of_surjection` — syzygy descent via
  `LinearMap.shortExact_shortComplexKer` +
  `ModuleCat.projective_of_free` +
  `ShortComplex.ShortExact.hasProjectiveDimensionLT_X₁`.
- `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker` —
  companion ascent via `hasProjectiveDimensionLT_X₃`.
- `depth_ker_ge_min_of_surjection_finite_localRing` — depth lower
  bound via `depth_of_short_exact (3)` +
  `depth_pi_const_eq_depth_of_nonempty`.

**Why HARD BAR NOT MET**: Step (iii) closure requires (a) base case
substrate Stacks 00MF (`pd M > 0 ⟹ depth M < depth R`, ~150-200 LOC
Mathlib gap candidate); (b) ℕ∞ arithmetic that depends on
`depth R ≥ pd M` — itself part of AB. Approach 2 (LES analysis
proving `depth K ≤ depth M + 1` directly via Ext connecting-map
injectivity, ~obviating 00MF) NOT attempted; approach 3 (Stacks
090V induct-on-depth, classical) explicitly rejected per directive.

**Iter-201+ handoff**: dispatch mathlib-build lane for Stacks 00MF
(~150-200 LOC, candidate Mathlib upstream PR). Alternative LES-
analysis route remains a viable iter-201+ exploration. The
ChainComplex `ℕ` literal carrier route is now **doubly confirmed
DEAD** (iter-199 first-step substrate + iter-200 SES-descent pivot
both align away from it).

### Lane COE-stage6-iiB — `Albanese/CodimOneExtension.lean`

**Outcome**: HARD BAR MET. 7 axiom-clean private substrate theorems
landed at lines ~688–~790 (+~165 LOC) under
`namespace AlgebraicGeometry.Scheme`. Sorries 3 → 3 (unchanged at
L1061 / L1258 / L1333).

**Substrate landed**:
- Step 1: `ringKrullDim_localization_eq_height_atPrime` (L~688) —
  re-export of `IsLocalization.AtPrime.ringKrullDim_eq_height` under
  a project-local name.
- Step 2 lower: `MvPolynomial.maximalIdeal_height_ge_card_of_field`
  (L~696) — **substantive proof of the iter**, induction on `Fin n`
  via `MvPolynomial.finSuccEquiv` +
  `Polynomial.height_eq_height_add_one` +
  `Polynomial.isMaximal_comap_C_of_isJacobsonRing` (Jacobson
  contraction).
- Step 2 upper: `MvPolynomial.maximalIdeal_height_le_natCard_of_field`
  (L~717) — composition of `Ideal.height_le_ringKrullDim_of_ne_top`
  + `MvPolynomial.ringKrullDim_of_isNoetherianRing` +
  `ringKrullDim_eq_zero_of_field`.
- Step 2 combined: `MvPolynomial.maximalIdeal_height_eq_card`
  (Fin n, L~727) + `MvPolynomial.maximalIdeal_height_eq_natCard`
  (general via `MvPolynomial.renameEquiv` + `RingEquiv.height_map`,
  L~738).
- Capstone: `ringKrullDim_localization_atMaximal_MvPolynomial`
  (L~767) — Steps 1+2 in a single consumer call.
- Step 3 additive: `ringKrullDim_quotient_add_eq_of_regular_sequence`
  (L~790) — via `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`.

**Why L1061 push-beyond NOT attempted**: requires (a) explicit
`SubmersivePresentation` extraction from `Algebra.IsStandardSmooth
(Γ(Spec, U)) (Γ(X.left, V))` (Stage 3 gives
`IsStandardSmoothOfRelativeDimension`, not the presentation
directly); (b) maximal-ideal-at-z identification; (c) Jacobian-
regular-sequence witness (Stacks 00SW / 00OW; substantive iter-201+
residual). Each is multi-LOC project-side work.

**Iter-201+ handoff**: build Jacobian-regular-sequence witness
`Algebra.SubmersivePresentation.relations_isRegular_in_localization`
(~30-60 LOC project-side) via existing Mathlib pieces:
`Algebra.SubmersivePresentation.jacobian_isUnit` (EXISTS),
`RingTheory.Sequence.isRegular_cons_iff` (EXISTS),
`IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`
(EXISTS). Then bridge scheme-to-algebra for L1061 inline closure.
Cascade: Lane T32 re-engagement (binding trigger met when COE Stage
6.B closes).

## Mathlib readiness audit (iter-200 actual API state at b80f227)

Per Lane COE prover report — newly confirmed EXISTS in iter-200
substrate build:
- `IsLocalization.AtPrime.ringKrullDim_eq_height`
- `IsLocalRing.maximalIdeal_height_eq_ringKrullDim`
- `Ideal.height_le_ringKrullDim_of_ne_top`
- `MvPolynomial.ringKrullDim_of_isNoetherianRing`
- `ringKrullDim_eq_zero_of_field`
- `Polynomial.height_eq_height_add_one`
- `Polynomial.isMaximal_comap_C_of_isJacobsonRing`
- `MvPolynomial.finSuccEquiv` / `MvPolynomial.renameEquiv`
- `RingEquiv.height_map` / `RingEquiv.height_comap`
- `Ideal.map_isMaximal_of_equiv`
- `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`
- `Algebra.SubmersivePresentation` (structure) +
  `Algebra.SubmersivePresentation.isStandardSmoothOfRelativeDimension`
  + `Algebra.SubmersivePresentation.jacobian_isUnit`
- `RingTheory.Sequence.IsRegular` + `RingTheory.Sequence.isRegular_cons_iff`
- `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`

Per Lane WD prover report — newly confirmed EXISTS:
- `Scheme.Opens.stalkIso`
- `IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing`
- `Order.coheight_eq_of_isOpenEmbedding` (project-local, iter-183
  CoheightBridge substrate)

Per Lane AB prover report — newly confirmed EXISTS:
- `CategoryTheory.projectiveDimension_lt_iff`
- `LinearMap.shortExact_shortComplexKer`
- `ModuleCat.projective_of_free` + `Pi.basisFun`
- `ShortComplex.ShortExact.hasProjectiveDimensionLT_X₁` / `_X₃`
- `hasProjectiveDimensionLT_of_ge`
- `depth_of_short_exact` (3 parts) + `depth_pi_const_eq_depth_of_nonempty`

Confirmed MISSING in iter-200 (substrate gaps the lanes named):
- `Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`
  — packaged form Mathlib doesn't ship; iter-200 capstone covers the
  polynomial-ring side, regular-sequence witness for quotient side
  iter-201+.
- Stacks 00MF substrate (`pd M > 0 ⟹ depth M < depth R`) — Mathlib
  gap; AB inductive-case closure depends on it.
- `Ring.ordFrac` naturality across stalk iso — Mathlib gap; WD
  Sub-build 2.

## Subagent dispatches (review phase)

Dispatched 4 in parallel:

| Subagent | Slug | Status | Headline |
|---|---|---|---|
| lean-auditor | `iter200` | COMPLETE (487s, $1.67) | 19 new iter-200 substrate decls clean; 2 carry-over must-fix UNRESOLVED |
| lean-vs-blueprint-checker | `wd-iter200` | COMPLETE (1085s, $0.67) | 0 broken pins; 5 of 8 new decls lack pins; `soon` |
| lean-vs-blueprint-checker | `ab-iter200` | COMPLETE (1309s, $0.76) | 4 new HasPdLT helpers absent; gap (3) marked OBVIATED in Lean but listed "absent" in chapter; **private/public mismatch on succ_pd** carried from iter-199 (2-iter stale) |
| lean-vs-blueprint-checker | `coe-iter200` | COMPLETE (792s, $0.73) | 0 broken pins; 7 new decls absent from blueprint; Stage 6.A description stale |

Outcomes:

- **lean-auditor**: confirms the 19 new iter-200 substrate decls have
  **no headline-laundering patterns** (no constant PUnit, no zero
  morphism, no `⟨sorry⟩` constructor — all genuine bodies). Two
  persistent must-fix carry-overs (RelPicFunctor:266-269 + AlbaneseUP:179-183)
  remain unresolved; iter-200 plan agent did not address them.
  Recommend the iter-201 plan agent either act or document why
  action is impossible.

- **per-file checkers (collective)**: all 3 prover-touched chapters
  have substantive Lean→Blueprint gaps from iter-200 substrate
  (the 16 new substantive decls across WD/AB/COE that lack `\lean{...}`
  pins). All rated `soon` (not must-fix-this-iter). Action: see
  `recommendations.md` MED-3 / MED-4 / MED-5 + new **MED-5a** on the
  `auslander_buchsbaum_formula_succ_pd` private/public mismatch.

- **No must-fix-this-iter findings from any review-phase subagent.**
  The substrate-only iter pattern was the correct discipline; the
  iter-201 plan agent's blueprint-writer pass on WD / AB / COE
  chapters is the proper response to the `soon`-rated chapter
  gaps.

## Knowledge Base additions (iter-200 Archon canonical)

4 new entries appended to PROJECT_STATUS.md `## Knowledge Base` /
`### Proof Patterns`:

1. **HasProjectiveDimensionLT SES descent (Mathlib-aligned syzygy
   descent for AB-style pd/depth arithmetic)** — Lane AB
   `hasProjectiveDimensionLT_{ker_of_surjection, succ_of_…_ker,
   succ_of_…_eq}` + `depth_ker_ge_min_…` recipe, ~45 LOC axiom-
   clean. Replaces literal `ChainComplex ℕ` carrier with abstract
   syzygy descent via `hasProjectiveDimensionLT_X₁` / `_X₃`.
   Obviates gap (3) (snake lemma on minimal resolution) entirely.
   Recipe pivot from `ab-natrecursive` analogist.

2. **MvPolynomial maximal-ideal height = n via `finSuccEquiv` +
   `Polynomial.height_eq_height_add_one` + Jacobson contraction** —
   Lane COE `MvPolynomial.maximalIdeal_height_eq_card` (Fin n)
   recipe, ~25 LOC core induction. Induction on `Fin n` (NOT generic
   `Finite ι`) is the cleanest route; `renameEquiv` transports to
   the general `[Finite ιx]` form. Reusable for ANY smooth-algebra
   Krull-dim formula whose polynomial-ring side needs height
   computation.

3. **`Scheme.Opens.stalkIso` thin-wrap pattern for prime-divisor
   open-immersion descent** — Lane WD `Scheme.PrimeDivisor.stalkIso`
   + `equivOpen` + `IsRegularInCodimensionOne.instOpen` recipe.
   Wraps Mathlib's `Scheme.Opens.stalkIso` for the project's
   `PrimeDivisor` bundle. `IsLocallyNoetherian U.toScheme` is
   automatic from typeclass propagation; `IsIntegral U.toScheme` is
   NOT (threaded explicitly). Reusable for ANY codim-1 regularity
   descent across open immersion.

4. **MvPolynomial Step 3 additive form for regular-sequence dim
   drop** — Lane COE `ringKrullDim_quotient_add_eq_of_regular_sequence`
   recipe. `WithBot ℕ∞` has NO `HSub` instance; the additive form
   `ringKrullDim (R' ⧸ Ideal.ofList rs) + b = a` is the natural API
   for any Krull-dim quotient-by-regular-sequence assertion.

(Anti-pattern reminders also added in KB if subagent reports
surface fresh ones — see PROJECT_STATUS.md update for canonical text.)

## Open items for iter-201 plan agent

1. **CRIT-0**: Lane WD Sub-build 2 (`Ring.ordFrac` transport across
   stalk iso) — dispatchable as mathlib-build lane; ~30-50 LOC
   project-side; clean upstream PR candidate. The Lane WD-A4a
   parent L535 closure requires both Sub-build 2 AND Sub-build 3
   landing.
2. **CRIT-1**: Lane COE iter-201+ main effort — Jacobian-regular-
   sequence witness + scheme-to-algebra bridge for L1061 inline
   closure. Substrate Step 1+2 + Step 3 additive form are in place
   this iter; the substantive residual is the regular-sequence
   construction (Stacks 00SW / 00OW, ~30-60 LOC project-side per
   prover report).
3. **CRIT-2**: Lane AB iter-201+ — Stacks 00MF base case substrate
   (`pd M > 0 ⟹ depth M < depth R`, ~150-200 LOC Mathlib gap
   candidate). Alternative: LES analysis proving `depth K ≤
   depth M + 1` directly via Ext connecting-map injectivity
   (obviates 00MF for the AB use case). Both routes need iter-201+
   exploration.
4. **MED-3**: Lane COE blueprint expansion — add `\subsec:stage6_iib_substrate_iter200`
   pinning the 7 new substrate decls (per Lane COE prover handoff);
   update Stage 6.A description to note Step 2 polynomial-side now
   landed axiom-clean.
5. **MED-4**: Lane WD blueprint expansion — add new section /
   subsection for `Scheme.PrimeDivisor.{restrictToOpen, ofOpen,
   equivOpen, stalkIso}` + `IsRegularInCodimensionOne.instOpen`
   citing Stacks 02IZ + iter-183 CoheightBridge substrate.
6. **MED-5**: Lane AB blueprint expansion — reflect ALIGN_WITH_MATHLIB
   pivot (gap (1) "full chain complex" cost reduced to 4 axiom-clean
   per-syzygy helpers); reclassify gap (3) (snake lemma) from "open"
   to "OBVIATED" via SES-descent path.
7. **LOW-6**: STRATEGY.md aggressive format-compliance pass — bring
   ≤250 lines / ≤12 KB (iter-200 strategy-critic must-fix carried
   over per iter-200 plan).
8. **LOW-7**: IsEtale functor-of-points alternative for Pic⁰ pivot
   — mathlib-analogist `pic0-isetale-fop` dispatch (iter-200 plan
   item 8).

## Decisions made by review agent

- **`% NOTE: ...` markers**: deferred to plan-agent expansion in
  blueprint chapters (the new substrate decls aren't sketched in
  prose yet; adding `\lean{...}` pin without prose context is the
  plan agent's job; review agent's `% NOTE` markers go where prose
  exists but Lean diverged).
- **`\mathlibok` markers**: no candidates this iter (no decls are
  pure Mathlib re-exports without project-side wrapping).
- **`\lean{...}` corrections**: none required — the iter-199 plan-
  agent additions to AB / COE chapters (the
  `exists_minimalSurjection_finite_localRing` block; the
  `isRegularLocalRing_stalk_of_smooth` pin) still resolve.
- **`\notready` strip**: none required — no blocks have stale
  `\notready` (project has not used `\notready` recently).

These are review-agent decisions made within scope; the heavier
chapter-expansion work (adding new `\lean{...}` pins for the iter-
200 substrate, new subsections sketching iter-201+ residuals) goes
to the iter-201 plan agent per `recommendations.md` MED-3 / MED-4 /
MED-5.

## Notes from blueprint doctor

`logs/iter-200/blueprint-doctor.md` reports **no structural
findings** — every chapter is `\input`'d, every `\ref` / `\uses`
resolves, every annotation has a non-empty argument, no `axiom`
declarations.
