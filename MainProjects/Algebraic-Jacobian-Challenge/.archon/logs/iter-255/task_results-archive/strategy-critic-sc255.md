# Strategy Critic Report

## Slug
sc255

## Iteration
255

## Routes audited

### Route: A.1.c.sub — comparison iso on line bundles (loc-triv)

- **Goal-alignment**: PASS — `f^*(M⊗N)≅f^*M⊗f^*N` on loc-triv pairs feeds `IsInvertible.pullback`
  and `RPF.addCommGroup`; both are genuine prerequisites of the Pic⁰ group structure the goal needs.
- **Mathematical soundness**: PASS — the strong-monoidal δ-is-iso argument, reduced chart-wise to the
  unit pair via `pullbackUnitIso`, is correct. The "by-hand, not generic `Sheaf.monoidalCategory`"
  justification is also sound: `SheafOfModules` over a `RingCat`-valued structure sheaf is a
  varying-ring module category, so no fixed-`A` `MonoidalCategory` instance applies (verified:
  `PresheafOfModules.pullback` is the bare left adjoint of `pushforward`, no sectionwise/fixed-ring
  monoidal structure).
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The OVER_BUDGET overrun (21 vs 6–11)
  is honestly labeled, but the *named* root-fix (spelling-pin refactor) is held as a conditional
  while the per-lemma grind continues for a 5th iter.
- **Infrastructure-deferral detected**: no (for this route).
- **Effort honesty**: under-counted — `~120–240 LOC · ~8/it` against `Iters left ~4–8` is
  arithmetically inconsistent: 120–240 ÷ 8 ≈ 15–30 iters, not 4–8. Either the remaining LOC is
  overstated or iters-left is optimistic; given 4 consecutive iters of helpers-not-targets, the
  latter.
- **Verdict**: CHALLENGE — the route is mathematically right but the planner must resolve the
  "keep grinding vs. execute the named spelling-pin refactor" decision *this iter*. The reversing
  signal the strategy itself conditions the refactor on (recurring two-defeq-instance friction,
  OVER_BUDGET, helpers-not-targets) has already fired.

### Route: A.1.c.fun — relative Picard functor on `IsLocallyTrivial`
- **Verdict**: SOUND — modeled field-for-field on `CommRing.Pic.mapAlgebra`; the loc-triv carrier
  keeps inverse witnesses in-carrier. Authoring against a typed-sorry bridge in parallel is correct.

### Route: A.2.c — representability + Quot fork (engine)

- **Goal-alignment**: PASS — RR-free Quot/Hilbert engine is the only discharge of the `⟨sorry⟩`
  representability typeclasses under the permanent RR pause.
- **Mathematical soundness**: PASS.
- **Infrastructure-deferral detected**: yes — see Infrastructure-deferral findings (`Rⁱf_*`).
- **Effort honesty**: reasonable in isolation — `~3400–5500 · ~40/it (engine-active) ≈ 85–140 it`
  is internally reconciled. The dishonesty is positional, not arithmetic (see below).
- **Parallelism under-exploited**: yes — the engine is the project's dominant pole AND is explicitly
  stated to be independent of the group law ("`Rⁱf_*`, Relative Proj … do NOT depend on the group
  law"), yet it sits HELD at `~0/it` while the 21-iter A.1.c.sub spelling lane runs alone.
- **Verdict**: CHALLENGE — the largest, logically-independent pole is being serialized behind the
  substrate. See Must-fix.

### Route: A.4 — Albanese UP (Route 1 primary, Route 2 contingent)
- **Verdict**: SOUND — Route 1 (RR-free, in-tree rigidity + rational-map extension) as primary with
  Route 2 gated on a cheap Milne §III.6 RR-freeness check is a well-hedged contingency.

### Route: Genus-0 arm
- **Verdict**: SOUND — (a) transits A.2.c, (b) `J:=Spec k` USER-paused; no goal gap.

## Format compliance

- **Size**: 152 lines / 13446 bytes — **over budget** (~12 KB / 12288 B ceiling; ~9% over).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — `"(tscmp254, iter-254)"`, `"homOfLocalCompat UNBLOCKED
  iter-254 (the hf-protection block was self-imposed …)"`, `"progress-critic STUCK iter-244"`. These
  belong in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: no.
- **Table discipline**: FAIL — the A.1.c.sub Status cell is a multi-clause paragraph (D2' CLOSED /
  D1' recast / dual chain / hf-protection), not "one short line per cell". The LOC cells correctly
  carry both figures.
- **Format verdict**: DRIFTED.

## Infrastructure-deferral findings

### Deferred: `Rⁱf_*` (higher direct images, i≥1) — project Čech build

- **Required by goal**: yes — the RR-free FGA Quot/Hilbert engine (the only A.2.c discharge under the
  permanent RR pause) needs cohomology-and-base-change; `Rⁱf_*` is its deepest root.
- **Current plan for building it**: a default decision exists ("project Čech build, ~800–1200 LOC")
  — a concrete, decomposable, externally-unblocked construction.
- **Timeline**: vague — gated to "decided at A.2.c entry", i.e. behind A.1.c, despite being logically
  independent of the group law. No iter is assigned to starting it.
- **Verdict**: CHALLENGE — this is deferral-by-inaction of the single largest sub-construction. The
  "engine is BLOCKED not throttled" defense legitimately covers `FlatBaseChange` (defeq wall) and
  `HigherDirectImage` (needs the absent `Rⁱf_*`), but it does NOT cover *starting* the `Rⁱf_*` Čech
  build as a fresh file — nothing blocks that except the choice to serialize it behind A.1.c. Either
  open a parallel Čech lane or record an explicit rebuttal naming why the dominant independent pole
  stays idle.

## Sunk-cost flags

- `"reversing signal → refactor-subagent restatement of the comparison defs"` — Why this is
  sunk-cost: the strategy has already identified the spelling-pin refactor as the *root* fix yet keeps
  it as a not-yet-triggered conditional after 21 iters / 4 helpers-not-targets, continuing the
  per-lemma `erw` grind on merits-of-momentum rather than merits-of-route. Recommendation: treat the
  OVER_BUDGET + recurring-two-instance friction as the trigger having fired; dispatch the refactor to
  restate `pullbackTensorMap` / the comparison defs on the pinned `X.presheaf ⋙ forget₂ CommRingCat
  RingCat` spelling from the start, then re-attempt D1'/D3'/D4' on the clean spelling.

## Prerequisite verification

- `PresheafOfModules.pullback` / `pullbackPushforwardAdjunction` / `pullbackComp`: VERIFIED (bare
  left-adjoint, no fixed-ring monoidal structure — corroborates the by-hand justification).
- `Sheaf.monoidalCategory`: not found by loogle under that exact name, but the strategy's claim is
  *negative* (it does not apply to varying-ring tensor), which the `PresheafOfModules.pullback`
  signature independently confirms; no phantom-dependency risk.

## Must-fix-this-iter

- Route A.1.c.sub: CHALLENGE — commit the keep-grinding-vs-refactor decision. Either dispatch the
  spelling-pin refactor (the strategy's own named root-fix) this iter, or record an explicit rebuttal
  in plan.md naming why a 5th per-lemma iter beats the refactor. Also reconcile the
  `~120–240 · ~8/it` vs `Iters left ~4–8` arithmetic.
- Route A.2.c / `Rⁱf_*`: infrastructure-deferral CHALLENGE — the dominant, group-law-independent pole
  is serialized behind A.1.c with no iter assigned. Open a parallel Čech-build lane or rebut the
  serialization explicitly.
- Format: DRIFTED — strip per-iter narrative (`tscmp254/iter-254`, `STUCK iter-244`, `hf-protection
  self-imposed`) into the iter sidecar, collapse the A.1.c.sub Status cell to one line, trim under
  12 KB. Restructure in-place this iter.

## Overall verdict

The strategy is mathematically sound and goal-aligned on every route, and the by-hand chart-chase
justification holds up under verification (varying-ring tensor genuinely defeats the generic
`Sheaf.monoidalCategory` path). The two live concerns are throughput, not correctness. First, the
A.1.c.sub lane has the right route but the wrong tactic-cadence: the strategy has already named the
spelling-pin refactor as the root fix yet defers it as a conditional through a 5th iter of the friction
it predicts — the planner must commit. Second, **the strategy defers `Rⁱf_*` (the project Čech build),
which is required for the stated goal** under the permanent RR pause, behind A.1.c despite stating it
is independent of the group law — serializing the project's dominant pole behind a 21-iter
spelling-friction lane is a 2–3× throughput risk that should be parallelized or explicitly rebutted.
Format has drifted (over-size, per-iter narrative, paragraph table cells) and should be restructured
in-place. No REJECT: nothing is broken, but two CHALLENGEs and one infrastructure-deferral must be
addressed before committing this iter's plan.
