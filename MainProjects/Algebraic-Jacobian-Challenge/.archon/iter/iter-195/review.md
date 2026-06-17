# Iter-195 (Archon canonical) — review

## Outcome at a glance

- **The "Lane H `Scheme.IsFlasque.shortExact_app_surjective` CLOSED
  axiom-clean via 1 new instance `sheafCompose_preservesFiniteLimits` +
  `Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono` packaging
  (H1V 4 → 3 −1; closes the 3-iter STUCK on `SAb.Exact`; the iter-194
  plan's anticipated `PreservesHomology` chain was OVERSHOT — LEFT-half
  preservation suffices for `S.ShortExact` inputs) + Lane I 1 NEW
  kernel-clean Finsupp helper `sum_max_zero_eq_sum_filter_pos` + 3-step
  body push on `degree_positivePart_principal_eq_finrank` to canonical
  Hartshorne II.6.9 starting form +
  `instIsRegularInCodimOneProjectiveLineBar` body opened via
  `refine ⟨fun Y => ?_⟩` (WD 4 → 4 net 0; substantive structural advance;
  HARD BAR MET; Mathlib gaps reconfirmed) + Lane A OCofP 6 axiom-clean
  sub-steps on `exists_nonconstant_rational_from_dim_eq_two` substrate
  helper (linear-algebra extraction chain from `_hdim = 2`; OCofP 3 → 3
  net 0; HARD BAR MET) + Lane RCI structural lift via NEW file-private
  helper `localParameterAtInfty_uniformiser_witness` (1:1 inline → named
  swap; consumer body now sorry-free; RCI 3 → 3 net 0; HARD BAR
  technically NOT MET but substrate-blocked tactic-experiments exhausted
  per `Classical.arbitrary` / `tauto` / `exact?`) + Lane F Stage 1 of 6
  Beck-Chevalley intertwining axiom-clean inline + (N1)-(N4) named
  substrate gaps documented for iter-196 refactor (QuotScheme 12 → 12
  net 0; HARD BAR NOT MET; **plan-phase LOC estimate off by ~5×**) +
  Lane G n=k+1 inductive step carved into typed helper
  `auslander_buchsbaum_formula_succ_pd` + 4-piece iter-196+ slice
  ordering (AB 1 → 1 net 0; HARD BAR MET via Option (b)) +
  **2 lanes ERRORED on API 529** (Lane BareScheme after ~25 min of
  Mathlib scouting; Lane E after ~3.5 min) — both committed NO edits;
  re-dispatch iter-196 is mandatory" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per `meta.json`
  `prover.status: done`; 8361/8361 jobs replayed; **87 sorries**
  (counted directly from `lake build`'s `declaration uses 'sorry'`
  warnings via regex extraction).

- **0 → 0 project axioms** — **15th consecutive zero-axiom build
  streak**.

- **planValidate**: 8 objectives dispatched. **6 of 8 lanes returned
  `done`; 2 lanes returned `error` (API 529 Overloaded mid-session)**.
  Per-lane outcomes — see below.

- **Plan-predicted band** (entering 88):
  - Best 88 → ~76-80 (−8 to −12).
  - Realistic 88 → ~81-85 (−3 to −7).
  - Worst 88 → ~85-88 (0 to −3).

  Landing **87** sits at the **worst-case lower bound** (worst minus 1).
  The 2 errored lanes were precisely the two highest-leverage scheduled
  closures (BareScheme cascade-unlocks Lane I + RCI; Lane E
  analogist-confirmed close on 1-2 sorries). Net delta is −1 with all
  closure coming from Lane H. **The iter delivered substantive structural
  advance across 4 PARTIAL lanes (I, A, F, G) + 1 closure (H) but lost
  the realistic-band closure path to API exhaustion, not mathematics.**

- **Reviewer-phase subagents dispatched** — see `## Subagent dispatches`.

- **sync_leanok iter=195**: 12 added / 3 removed / 4 chapters touched
  (`Albanese_AuslanderBuchsbaum.tex`, `RiemannRoch_H1Vanishing.tex`,
  `RiemannRoch_OCofP.tex`, `RiemannRoch_RationalCurveIso.tex`).

- **Blueprint doctor**: NO structural findings (every chapter `\input`'d
  by `content.tex`; every `\ref` / `\uses` resolves; no `axiom`
  declarations).

## Subagent dispatches (review phase)

- `lean-auditor iter195` — **complete** (1177s; cost $10.90). Report at
  `task_results/lean-auditor-iter195.md` (archived to `logs/iter-195/`).
  43 files audited; **3 must-fix-this-iter** (`WeilDivisor.lean:746`
  instance with sorry body propagating `sorryAx`;
  `Thm32RationalMapExtension.lean:194` in-proof `haveI := sorry`;
  `AlbaneseUP.lean:183` `:= sorry` def propagating to 4 typeclass
  instances), 7 major, 6 minor, 7 excuse-comments. Verdict: iter-195
  edits themselves are *clean and well-carved*; the 3 must-fix items
  are pre-iter-195 substrate state that the iter-194 IC.lean template
  (`instance → private theorem` demotion) handles mechanically.
  Findings folded into the CRITICAL section of
  `proof-journal/sessions/session_195/recommendations.md`.

## Subagent skips

- `lean-vs-blueprint-checker`: not dispatched per-file this iter. The
  per-file dispatch is highly recommended for files that received prover
  work; **6 files** received edits this iter (AuslanderBuchsbaum, H1Vanishing,
  QuotScheme, OCofP, RationalCurveIso, WeilDivisor). With
  `loop.max_parallel: 1` enforced by config, sequential dispatch of 6
  checker subagents would consume significant budget against an API
  environment that already exhibited 529 Overloaded failures earlier in
  the iter. The lean-auditor's whole-project sweep covers the same surface
  (per-file checklist + flagged issues) at lower cost, and the
  blueprint-reviewer ran during iter-195 plan-phase (twice — initial +
  fastpath, both PASS) so chapter-side adequacy is currently audited.
  Iter-196 plan agent should re-evaluate this trade-off after lean-auditor
  returns.

## Per-lane verification

### Lane H — `RiemannRoch/H1Vanishing.lean` — done

- File status: 4 sorries → **3 sorries** (net −1).
- Closure: `Scheme.IsFlasque.shortExact_app_surjective` axiom-clean per
  `lean_verify` (kernel only: `propext`, `Classical.choice`, `Quot.sound`).
- New instance `sheafCompose_preservesFiniteLimits` (~L340) axiom-clean.
- HARD BAR **MET** (closure); PUSH-BEYOND NOT MET (substrate-blocked on
  `IsFlasque.injective_flasque` Tier-3).
- Remaining sorries: `IsFlasque.constant_of_irreducible` (L138),
  `IsFlasque.injective_flasque` (L572),
  `skyscraperSheaf_eq_pushforward_const` (L760) — all Tier-3 substrate
  gaps unrelated to Lane H's iter-195 critical path.

### Lane BareScheme — `Genus0BaseObjects/BareScheme.lean` — error (API 529)

- File status: 4 sorries → 4 sorries (no edits).
- Session: ~25 min, ~140 turns, terminated by API 529 mid-substrate-
  scouting. The prover had been actively reading
  `RingHom.IsStandardSmoothOfRelativeDimension`,
  `Proj.awayι_toSpecZero`, `RingHom.Locally` — building toward the
  `SmoothOfRelativeDimension 1` lift via `D₊(X 0)` / `D₊(X 1)` chart
  cover. No edit committed.
- Verified via `grep -c "tool_call.*Edit\|tool_call.*Write"` on the prover
  jsonl: **0 edits**.
- **Lane re-dispatch iter-196 is mandatory.** Blueprint coverage is in
  place; HARD GATE cleared via fastpath; the substrate is genuinely
  closeable per the plan recipe.

### Lane E — `AbelianVarietyRigidity.lean` — error (API 529)

- File status: 3 sorries → 3 sorries (no edits).
- Session: ~3.5 min, 1 session turn, terminated by API 529 before any
  meaningful action.
- Verified via grep: **0 edits**.
- The analogist's confirmed `Proj.awayι_app_basicOpen` 3-helper recipe
  remains viable; persistent at `analogies/lane-e-proj-appiso-pivot.md`.
- **Lane re-dispatch iter-196 is mandatory.**

### Lane I — `RiemannRoch/WeilDivisor.lean` — done (PARTIAL)

- File status: 4 sorries → 4 sorries (unchanged).
- NEW kernel-clean Finsupp helper `sum_max_zero_eq_sum_filter_pos` at
  L684-709 (~10 LOC).
- Body push on `degree_positivePart_principal_eq_finrank` (L787-890):
  3 axiom-clean sub-steps (Y₀ destructure → sum-max → filter-pos →
  per-Y `principal_apply` rewrites); residual goal now in canonical
  Hartshorne II.6.9 starting form.
- `instIsRegularInCodimOneProjectiveLineBar` body opened with
  `refine ⟨fun Y => ?_⟩` (L720-746); two viable routes documented in
  body comments (Route 1: full Smooth chain ~200-300 LOC; Route 2:
  affine-chart `k̄[t]` PID transfer ~50-80 LOC).
- HARD BAR **MET** (substantive structural advance + new helper); PUSH-
  BEYOND NOT attempted (Mathlib gaps reconfirmed: no
  `Smooth ⟹ IsRegularLocalRing` bridge, no
  `Hom.ofFunctionFieldEmbedding`, no coheight↔KrullDim bridge).

### Lane F — `Picard/QuotScheme.lean` — done (PARTIAL)

- File status: 12 sorries → 12 sorries (unchanged).
- Stage 1 of 6 Beck-Chevalley intertwining landed axiom-clean as inline
  `have stage1 := _step2_apply x` at L999-1080.
- (N1)-(N4) named substrate gaps documented in body comments:
  - (N1) `baseMap` naturality (~20-30 LOC).
  - (N2) `baseMap` ∘ `pullbackComp` (~30-40 LOC).
  - (N3) `baseMap` ∘ `pullbackCongr` (~10-20 LOC).
  - (N4) `step3` inversion identity (~20-30 LOC).
- HARD BAR NOT MET (no closure); substantive structural advance via
  Stage 1 + 4 precisely-typed substrate naming. **iter-196 plan agent:
  dispatch refactor subagent to land (N1)-(N4) BEFORE prover dispatch.**
- CRITICAL: plan-phase LOC estimate "~10-30 LOC" was off by ~5×.

### Lane A — `RiemannRoch/OCofP.lean` — done (PARTIAL)

- File status: 3 sorries → 3 sorries (unchanged).
- 6 axiom-clean substeps on `exists_nonconstant_rational_from_dim_eq_two`
  (L1323): `htF_zero`, `htF_smul`, `htF_add`, `hs₁_ne` derivation,
  `Module.Finite kbar H⁰`, `finrank_span_singleton` chain, extraction
  of `s : H⁰` via `Submodule.exists_of_finrank_lt`, definition of
  candidate `f := toFunctionField s`.
- Remaining 3 sub-claims documented: (a) `f ≠ 0` via
  `toFunctionField` injectivity LinearEquiv chain (~30-50 LOC); (b)
  mechanical `globalSections_iff_mpr`; (c) Stacks 02P0.
- L1209 NOT TOUCHED per directive (OcOfD.lean substrate-blocked).
- L1147 NOT TOUCHED (cascade target on Lane H landing; Lane H did
  close `shortExact_app_surjective` but `HModule_flasque_eq_zero` body
  remains gated by `injective_flasque` Tier-3).
- HARD BAR **MET** (substantive structural advance on L1323).

### Lane RCI — `RiemannRoch/RationalCurveIso.lean` — done (PARTIAL)

- File status: 3 sorries → 3 sorries (1:1 inline → named-helper swap).
- NEW file-private helper `localParameterAtInfty_uniformiser_witness`
  at L463 with typed sorry + 3-step closure path docstring (witness via
  `Proj.basicOpenIsoAway` chart; order via DVR uniformiser; uniqueness
  via opposite-pole at `D₊(X 0)`).
- Consumer `Hom.poleDivisor_degree_eq_finrank` body now sorry-free at
  the body level (delegates via `exact ... kbar`).
- Tactic-level closure attempts on `?hLPUnif` confirmed dead:
  `Classical.arbitrary _` (no `Nonempty PrimeDivisor` instance), `tauto`,
  `exact?` — all returned negative.
- HARD BAR **technically NOT MET** ("axiom-clean closure" required);
  the structural lift is a no-regression substrate-improvement
  particularly suitable for iter-196 targeted close. Per progress-
  critic iter-194 STUCK protocol the helper budget (1/1) was spent on
  the structural lift after tactic-experiments confirmed dead.

### Lane G — `Albanese/AuslanderBuchsbaum.lean` — done (PARTIAL)

- File status: 1 sorry → 1 sorry (1:1 inline → named-helper swap).
- NEW private helper `auslander_buchsbaum_formula_succ_pd` (L1106-1124)
  with typed sorry at L1115 + 4-piece iter-196+ slice ordering
  documented in docstring (depth-drops-by-one → minimal-resolution
  carving → snake lemma → "what is exact"; ~350-500 LOC across iters
  196-200+).
- Main theorem n=k+1 branch dispatches via
  `exact auslander_buchsbaum_formula_succ_pd k _hpd`.
- HARD BAR **MET** via Option (b) (carving + concrete iter-196+
  timeline) per directive; OFF-CRITICAL-PATH per session-194 R7 +
  iter-195 plan.

## Carrier-soundness status (iter-195 plan-phase commitment)

The iter-195 plan-phase committed to pulling the carrier-soundness
refactor forward to iter-196 (per `mathlib-analogist
carrier-soundness-design` ALIGN_WITH_MATHLIB Option A
`Functor.IsRepresentable`). This commitment carries into iter-196:

- 7+ load-bearing typed-`:= sorry` carriers across Pic0Scheme,
  PicScheme, QuotScheme, picSharp, divFunctor, abelMap, PicSharp,
  presheaf, PicSharp.etSheaf silently propagate `sorryAx` through
  typeclass synthesis.
- iter-196 plan-phase should dispatch the refactor subagent on the
  FGAPicRepresentability slice first (per analogist's "6-10 iters /
  ~600-950 LOC total" estimate; FGAPicRepresentability is the smallest
  independently-refactorable slice).

## Key signals for iter-196 plan agent

1. **API 529 cost iter-195 the realistic-band closure path.** Two
   lanes errored mid-session with NO edits. Iter-196 re-dispatch of
   BareScheme + Lane E is the highest-priority action — neither is a
   mathematical failure.

2. **Plan-phase LOC estimates systematically undershoot on
   compositional-closure lanes.** Lane F's "~10-30 LOC" vs actual
   ~100-150 LOC is the iter-195 instance. Iter-196 rule: any lane
   requiring ≥3 sequenced identities should be preceded by a refactor
   subagent landing each substrate naming separately.

3. **Lane I `instIsRegularInCodimOneProjectiveLineBar` Route 2 is
   recommended** (per prover report). Pursue affine-chart `k̄[t]` PID
   transfer (~50-80 LOC) NOT full Smooth chain (~200-300 LOC, Mathlib
   gap too wide).

4. **`Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono`** is
   the canonical packaging for SES exactness preservation — `S.ShortExact`
   inputs do NOT require full `PreservesHomology`, only LEFT-half
   limit preservation. **Document in PROJECT_STATUS Knowledge Base.**

5. **Lane G OFF-CRITICAL-PATH discipline held this iter.** Iter-196
   plan agent should NOT re-elevate Lane G to a closure target without
   explicit phase-change rationale.

## What did NOT happen

- No lane regressed in sorry count.
- No new project axioms.
- No protected-signature edits.
- No blueprint structural issues from doctor.
- No `\leanok` markers were added or removed by me (review agent); the
  deterministic sync_leanok handled 12 added / 3 removed across 4
  chapters.
- No `\mathlibok` markers added this iter (no Mathlib re-exports
  introduced).
- No `\lean{...}` corrections needed (no prover-side renames).
- No `% NOTE:` annotations added (no translation gaps in prover reports
  this iter).
- No stale `\notready` to remove (the iter-195 prover reports did not
  flag any).

## Iter-196 preliminary commitments (carried forward)

1. **CRITICAL** (NEW iter-195 auditor): dispatch 3 instance-demotion
   refactor subagents — `WeilDivisor.lean:746` instance
   `instIsRegularInCodimOneProjectiveLineBar`, `Thm32RationalMapExtension.lean:194`
   `haveI`, `AlbaneseUP.lean:183` `bundle` + 4 instance projections.
   The iter-194 IC.lean template (`instance → private theorem` +
   explicit `haveI` threading at call sites) applies mechanically.
   These MUST land BEFORE any iter-196 prover dispatch on the affected
   files.
2. **CRITICAL**: re-dispatch BareScheme + Lane E (both errored API 529).
3. **CRITICAL**: dispatch carrier-soundness refactor on
   FGAPicRepresentability slice (Option A `Functor.IsRepresentable`).
4. **HIGH**: dispatch Lane F refactor (N1)-(N4) substrate naming
   BEFORE re-engaging Lane F prover.
5. **HIGH**: Lane I `instIsRegularInCodimOneProjectiveLineBar` via
   affine-chart Route 2 (gated on BareScheme cascade + the demotion
   refactor above — the demotion + the body-close work compose).
6. **MED**: Lane A OCofP finalization via `toFunctionField` injectivity
   LinearEquiv chain (~30-50 LOC).
7. **MED**: Lane A.3.i USER escalation OR Mathlib upstream PR draft
   (~350 LOC Route B per iter-194 analogist).
