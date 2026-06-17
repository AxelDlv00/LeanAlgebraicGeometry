# Recommendations for the next plan-agent iteration (iter-145)

## CRITICAL / HIGH — none

Iter-144 is a clean plan-only chart-algebra-pivot iter. The PIVOT
discharge of the iter-140/141 mandatory re-evaluation gate is the
correct action: iter-144 plan agent absorbed the consequences in 5
substantive STRATEGY.md edits + 3 Wave 2 blueprint-writers. No
critical structural finding from either mandatory plan-phase critic.
No prover lane → no new audit / blueprint-checker findings.

## MAJOR

### Ma1 — Iter-145 mandatory re-verification of the iter-144 chart-algebra pivot

Source: iter-144 plan agent's Watch criterion #2 (per
`strategy-critic-iter144` ratification protocol).

- **What**: iter-141 strategy-critic (`strategy-critic-iter141`)
  previously rejected a "preservation-of-bundled vs pivot" route-pivot
  question as **wrong-question** (piece (i.b) Step 2 is
  base-independent over k vs k̄, so base-switching wouldn't help). The
  iter-144 chart-algebra pivot is **structurally different** — it
  doesn't switch base; it switches the *closure path* (chart-side
  vs bundled-side) for pieces (i.b) Step 2 + (i.c) + (iii). The
  iter-141 framing IS honestly reversible because the pivot answers a
  different question than the one iter-141 rejected.
- **Action for iter-145 plan agent**: dispatch the mandatory
  `strategy-critic-iter145` with explicit framing: "Verify the
  iter-144 chart-algebra pivot is internally consistent with the
  iter-141 strategy-critic findings (piece (i.b) Step 2 base-
  independence is preserved; chart-algebra is a closure-path change,
  not a base-change). Verify the iter-141 strategy-critic's
  'preservation-of-bundled' framing is honestly reversed in
  STRATEGY.md, not silently preserved."
- **Acceptance**: SOUND or CHALLENGE → ABSORB; REJECT → iter-145
  becomes another plan-only iter to reverse the pivot.

### Ma2 — Iter-145 mandatory `mathlib-analogist-m3-route-a-refresh-iter145` audit

Source: `strategy-critic-iter144` Must-fix #3 (iter-123 M3 Route A
audit is 21 iters stale).

- **What**: M3 was COMMITTED to Route A iter-144 per user-hint, but
  the underlying LOC estimates (Hilbert / QCoh / Coh / flattening
  ~4150 LOC; Quot post-A1 ~1400 LOC; identity-component ~1025 LOC;
  total ~6500 LOC midpoint) are from the iter-123 audit. 21 Mathlib
  snapshot iterations have passed since.
- **Action for iter-145 plan agent**: dispatch `mathlib-analogist` with
  scope "Re-price A1 (Hilbert / QCoh / Coh / flattening), A2 (Quot
  post-A1), A3 (identity-component) against current Mathlib snapshot.
  Confirm or update the iter-123 ~6500 LOC midpoint. Note any
  upstream PRs landed since iter-123 that reduce or increase the
  in-tree footprint."
- **Acceptance**: PROCEED at iter-123 estimate → no STRATEGY.md edit
  needed. Material change (±25%) → iter-145+ STRATEGY.md re-baseline.

### Ma3 — Iter-146+ piece (ii) PIN-path-(b) prover lane (chart-algebra envelope)

Source: iter-144 STRATEGY.md Edit-4 § Iter-144 chart-algebra pivot —
COMMITTED.

- **What**: the iter-145+ critical-path prover lane is chart-algebra
  piece (ii) PIN-path-(b) (in `RigidityKbar.tex` per iter-144 Wave 2
  writer's INFLATE block at L99–area):
  - α-helper `Algebra.IsPushout`-from-affine-product (~80–150 LOC).
  - β chart-translation-invariance argument (~150–300 LOC) carrying
    the load-bearing iter-144 `df = 0` three-layer chain.
  - Algebra-level core `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
    (~200–350 LOC).
  - Integrally-closed-constants helper (~50–100 LOC).
  - Scheme-level lift via `Scheme.Over.ext_of_eqOnOpen` (~100–150 LOC).
  - Total envelope ~600–1050 LOC.
- **Action for iter-145+ plan agent**: iter-145 lands the chart-algebra
  envelope blueprint write-up + iter-145 mandatory strategy-critic
  re-verification (Ma1); iter-146+ first prover lane on a narrowly-
  scoped sub-piece (recommend starting with the integrally-closed-
  constants helper or the α-helper — smallest LOC, isolated).
- **Acceptance**: iter-146+ prover lane PASS/PARTIAL/FAIL acceptance
  matrix to be pre-committed in iter-145 plan-phase.

## MEDIUM

### Me1 — Iter-145 blueprint-reviewer re-confirms the iter-144 Wave 2 chapter updates

Source: iter-144 Wave 2 writers landed mid-iter but the iter-145
mandatory blueprint-reviewer is the first independent confirmation.

- **What**: 3 chapters edited iter-144 Wave 2:
  - `RigidityKbar.tex` — 5 edits including the new `\begin{lemma}`
    block at L1628 + chart-algebra disposition prose at L88,99 +
    Rule-4 iter-143 empirical block at L852 + Step-3 status refresh.
  - `Jacobian.tex` — 4 edits including Route A COMMITTED reframing
    on `def:positiveGenusWitness` proof body + § Route B header
    reframing.
  - `AlgebraicJacobian_Cotangent_GrpObj.tex` — 5 edits including
    NEW iter-143 IsIso theorem entry.
- **Action for iter-145 plan agent**: standard mandatory
  blueprint-reviewer dispatch with the three chapters explicitly
  surfaced for verification. Watch for residual stale-status text in
  ancillary places.

### Me2 — Stale Route B summary in `Jacobian.tex` `thm:nonempty_jacobianWitness` ~L370–377

Source: `blueprint-writer-jacobian-iter144` § Notes for Plan Agent.

- **What**: the Mathlib-infrastructure summary at end of
  `thm:nonempty_jacobianWitness` proof (~L370–377) still presents
  Route A (α) and Route B (β) as parallel "Mathlib build-outs each
  unlock[ing] one route". The β bullet says "unlocks Route B"; the
  trailing summary at L377 says "discharged by any one of the three
  routes above". Mathematically correct but contradicts the iter-144
  Route B → historical-only reframing of the rest of the chapter.
  Iter-144 writer left it untouched (strictly within directive scope).
- **Action for iter-145 plan agent**: optional follow-up
  blueprint-writer pass to re-frame (β) as "historical alternative (β)"
  parallel to the § Route B header change. Low priority; cleanup-class.

### Me3 — `def:positiveGenusWitness` theorem statement still mentions Route A or Route B

Source: `blueprint-writer-jacobian-iter144` § Notes for Plan Agent.

- **What**: `def:positiveGenusWitness` theorem statement at
  `Jacobian.tex:425` says "supplied by the chosen construction
  (Route A or Route B per `thm:nonempty_jacobianWitness`)". The
  statement is passive description of witness data; technically
  Route B is a valid construction that supplies it. Iter-144 writer
  left it untouched (preserve mathematical content rule).
- **Action**: optional follow-up tightening to "(Route A per the
  iter-144 disposition; see `thm:nonempty_jacobianWitness`)" in a
  cleanup blueprint-writer pass. Low priority; cleanup-class.

### Me4 — `\fst{...}` / `\snd{...}` macros undefined in common.tex

Source: `blueprint-writer-pointer-iter144` § Macros needed.

- **What**: the iter-144 pointer chapter writer used `\fst{G\,G}` and
  `\snd{G\,G}` macros in new prose at chapter L65–79. Neither is
  defined in `blueprint/src/macros/common.tex`. Several other
  pre-existing macros (`\app`, `\map`, `\PresheafOfModules`,
  `\pullback`, `\obj`, `\pr_1`, `\mu`) are also undefined and used in
  pre-existing prose, per the writer's note. Not a regression from
  iter-144 alone, but the iter-144 additions extend the surface.
- **Action for iter-145 plan agent**: cleanup-class blueprint-writer
  follow-up on `blueprint/src/macros/common.tex` to add minimal
  definitions (e.g.,
  `\newcommand{\fst}{\mathrm{fst}}` /
  `\newcommand{\snd}{\mathrm{snd}}` /
  similar for the others). Required before next blueprint compile
  if the chapter is rebuilt.

## LOW

### L1 — `sync_leanok` mis-mark carry-over at `RigidityKbar.tex:406, 524, 1152`

Source: iter-143 + iter-144 carry-over (deterministic-script domain).

- Three `\leanok` markers persist where the deterministic
  `sync_leanok` script's intended state is "no marker". Out of agent
  scope per CLAUDE.md (sync_leanok deterministic-domain rule).
- **Action**: optional `archon-lean4:doctor` consult. Pure-blueprint
  cosmetic; does not block iter-145+ work.

### L2 — Iter-150 over-k vs over-`k̄` sunk-cost guardrail (pre-committed)

Source: `strategy-critic-iter144` Must-fix #5 → iter-144 STRATEGY.md
absorption.

- **What**: pre-committed fresh-context strategy-critic dispatch at
  iter-150 with the one-question prompt: "If a fresh mathematician
  audited the over-k vs over-`k̄` choice with iter-150 empirical
  data, would the choice still be made?"
- **Action for iter-150 plan agent**: schedule this dispatch as
  mandatory iter-150 critic alongside the iter-150 RelativeSpec
  scaffold trigger.

### L3 — Iter-150 RelativeSpec scaffold trigger (preserved)

Source: STRATEGY.md § Iter-150 RelativeSpec trigger (preserved
through iter-144 restructure).

- **What**: trigger arm preserved at "M2.body-pile cumulative > 925
  LOC OR M2.a body not landed by iter-160". Under iter-144
  chart-algebra pivot the M2.body-pile envelope is ~600–1050 LOC
  piece (ii) — well under 925 LOC even at upper bound, so the
  trigger likely fires on the "iter-160 M2.a body" arm rather than
  the LOC arm.
- **Action**: monitor; iter-150 mandatory plan-phase check.

### L4 — STRATEGY.md size compaction opportunity (~641 lines)

Source: iter-144 plan agent's "STRATEGY.md size note".

- STRATEGY.md at 641 lines vs ~250 target. Iter-145+ chart-algebra
  pivot settles in; cleanup window opens. Cleanup-class follow-up.

## Do NOT retry without structural change (carry-over + iter-144 additions)

These remain in force from iter-143; iter-144 adds the chart-algebra
DESCOPE rule:

1. **Bundled-route piece (i.b) Step 2 d_app body closure** — DESCOPED
   iter-145+. Per the iter-144 chart-algebra pivot, the d_app sub-
   sorry at `Cotangent/GrpObj.lean:663` is no longer on the
   critical path. Plan agents must NOT dispatch a prover lane on
   this sub-sorry without first reversing the iter-144 pivot (which
   requires a strategy-critic SOUND or CHALLENGE verdict reversing
   the iter-144 STRATEGY.md Edit-4 — see Ma1).

2. **Bundled-route IsIso `basechange_along_proj_two_inv_app_isIso`
   body closure** — DESCOPED iter-145+ per same rule as #1.

3. **Bundled-route `mulRight_globalises_cotangent` body composition**
   — DESCOPED iter-145+ per same rule as #1.

4. **Iter-143 anti-patterns** carry forward verbatim (Knowledge Base
   entries):
   - `cat_disch` / `aesop_cat` / `refine ... d_map ?_` on the raw
     post-`change` d_app goal — does NOT synthesize the factoring
     witness.
   - Blind `simp only [Adjunction.homEquiv_*_symm]` without first
     lifting `hw` to c-component level via
     `PresheafedSpace.comp_c_app` — leaves the goal structurally
     identical.
   - Placeholder `_` in `change` blocks crossing
     `pushforward₀`-annotated definitions — re-confirmed iter-143
     deterministic `whnf` cap at 200k heartbeats.

## Reusable proof patterns discovered iter-144

**None in-Lean** (no prover lane). One reusable **strategic pattern**
is codified in PROJECT_STATUS.md Knowledge Base this iter:

- **The pre-committed conditional-fallback chart-algebra pivot**:
  when an iter-N mathlib-analogist surfaces a chart-algebra
  alternative with a CONTINUE_BUNDLED criterion (e.g., "pivot unless
  ≥M sub-sorries closed iter-N+k"), and the bundled route does NOT
  mechanically meet the criterion in the budgeted K iters, the
  pivot must be honored even if a strategy-critic in a downstream
  iter rejects a related-but-different "route-pivot" question. The
  iter-141 strategy-critic's rejection of a base-change pivot did
  NOT pre-clude the iter-144 closure-path pivot — different
  question, different answer. The mechanical CONTINUE_BUNDLED gate
  is the authoritative trigger.

## Pre-committed acceptance matrix for iter-145

(No matrix yet — iter-145 is a plan + re-verification iter. Iter-146+
is where the first chart-algebra prover lane fires; iter-146 plan
agent will pre-commit the acceptance matrix for that lane based on
iter-145's chart-algebra envelope blueprint + strategy-critic
re-verification.)
