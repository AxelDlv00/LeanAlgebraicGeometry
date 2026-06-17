# Iter-132 (Archon canonical) plan-agent run

## Headline outcome

Iter-131 closed plan-only with a refactor lane that reshaped the body
of `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` from `by`-tactic
`Classical.choice (Nonempty.intro X)` to a pure-term
`noncomputable def` using a `Classical.choose`-chain pattern, plus a
strong acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars`
that closes by `refine … rfl⟩`. Iter-132 is the **first
sorry-elimination dispatch on piece (i.a)** (after 4 iters of
body-shape interactions): scaffold + close the rank lemma
`cotangentSpaceAtIdentity_finrank_eq` against the iter-131 refactored
body. This is the 5th interaction with this declaration; per the
iter-130/131 review-phase audits, a 3rd structural-opacity-class defect
would arm the META-PATTERN TRIPWIRE.

**Iter-132 deliverables landed cleanly this plan phase**:

1. **3 mandatory critics (Wave 1, parallel) returned + absorbed**:
   - `strategy-critic-iter132` → CHALLENGE (5 must-fix + 4 alternatives
     + 3 sunk-cost flags + 2 SOUND on M3 + end-state).
   - `blueprint-reviewer-iter132` → 1 chapter `correct: partial`
     (`RigidityKbar.tex` with 3 narrow `\uses{}`/sentence cleanup
     items) + 1 chapter `correct: partial` (`Jacobian.tex` soft drift
     in C.2.a–C.2.e, informational not blocker); HARD GATE
     **GREEN-LIGHT-WITH-PARALLEL-WRITER** for the iter-132 prover lane
     on `Cotangent/GrpObj.lean`.
   - `progress-critic-iter132` → **CHURNING on Route 1** (`Cotangent/GrpObj.lean`).
     Primary corrective: enforce meta-pattern tripwire on iter-132 outcome
     with concrete iter-133 branch language in plan.md.

2. **Wave 2 (parallel) — blueprint writer on `RigidityKbar.tex`**:
   - `blueprint-writer-rigiditykbar-piecei-realign-iter132` → COMPLETE.
     Re-aligned § Piece (i) prose against iter-131 `Classical.choose`-chain
     body shape: rewrote rank-lemma proof with live (B) closure as Steps
     1+2 (chart-side Kähler rank from `smooth_locally_free_omega`
     existential + `Module.finrank_baseChange`); demoted 𝔪/𝔪² bridge
     to Step 3 (deferred alternative); added new mini-section
     "Iter-131 `Classical.choose`-chain body shape" documenting the
     rewrite handle `cotangentSpaceAtIdentity_eq_extendScalars`.

3. **Wave 3 (parallel-with-prover) — narrow blueprint writer cleanup**:
   - `blueprint-writer-rigiditykbar-uses-cleanup-iter132` (dispatched
     at end of plan phase, parallel with the iter-132 prover lane on
     `Cotangent/GrpObj.lean`). Three narrow `\uses{}` blocks and 2
     prose sentences updated per the iter-132 blueprint-reviewer's
     must-fix-this-iter list (line 88 paragraph "deferred to iter-130+"
     → "iter-132+ prover-lane target"; rank lemma `\uses{}` cleanup;
     `rem:piece_i_first_target` `\uses{}` cleanup + duo-collapse
     rewrite). Per the iter-132 blueprint-reviewer's "If parallel
     dispatch is chosen" guidance — explicitly authorised.

4. **Direct plan-agent Mathlib name verifications (iter-132)**:
   - `Module.finrank_baseChange` ✓ [verified iter-132,
     `Mathlib.LinearAlgebra.Dimension.Constructions`] — exact-match
     signature `Module.finrank R (TensorProduct S R M') = Module.finrank S M'`
     under `StrongRankCondition` on both rings + `Module.Free S M'` +
     `Algebra S R`.
   - `Module.finrank_eq_of_rank_eq` ✓ [verified iter-132,
     `Mathlib.LinearAlgebra.Dimension.Finrank`] — exact-match
     `Module.rank R M = ↑n → Module.finrank R M = n`.
   - `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
     ✓ [re-verified iter-132,
     `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`] — supplies
     `Module.rank S Ω[S⁄R] = ↑n` (consumed inside
     `Scheme.smooth_locally_free_omega`).
   - `Algebra.IsStandardSmooth.free_kaehlerDifferential` ✓
     [re-verified iter-132, same file] — supplies `Module.Free S Ω[S⁄R]`.
   - `Algebra.TensorProduct.instFree` ✓ [re-verified iter-132,
     `Mathlib.RingTheory.TensorProduct.Free`] — informational for
     downstream `omega_free` consumer.
   - `ModuleCat.ExtendScalars.obj'` ✓ [verified iter-132,
     `Mathlib.Algebra.Category.ModuleCat.ChangeOfRings`] — confirmed
     `(extendScalars f).obj M = ModuleCat.of S (TensorProduct R S M)`
     (the underlying type is the base-change tensor product).
   - `Scheme.smooth_locally_free_omega` (project,
     `AlgebraicJacobian/Differentials.lean`) ✓ — verified existential
     supplies `∃ U V e (hxV : x₀ ∈ V) (hU hV : IsAffineOpen)
     (hfree : Module.Free Γ(G,V) Ω[Γ(G,V)/Γ(Spec k, U)])
     (hrank : Module.rank Γ(G,V) Ω[…] = ↑n)`. The closure chain reads
     the freeness and rank witnesses directly from the existential.

5. **Iter-132 active prover lane on `AlgebraicJacobian/Cotangent/GrpObj.lean`**:
   scaffold + close the rank lemma `cotangentSpaceAtIdentity_finrank_eq`
   (50–100 LOC, per iter-129 analogist). See § "Iter-132 active prover
   objectives" in PROGRESS.md for the full directive.

## Subagent dispatches this iter (5 total)

| Wave | Subagent | Slug | Verdict | Outcome |
|---|---|---|---|---|
| 1 (parallel) | `strategy-critic` | iter132 | CHALLENGE — 5 must-fix + 4 alternatives + 3 sunk-cost flags | 3 ADOPTED via STRATEGY.md edits this iter; 2 DEFERRED with explicit STRATEGY.md scheduling (no-Frobenius analogist + ℙ¹-hedge analogist scheduled for iter-133+); 1 ADOPTED via prover directive clarification (rank-lemma `Classical.choose` parallel-extraction wrangling) |
| 1 (parallel) | `blueprint-reviewer` | iter132 | `RigidityKbar.tex` `correct: partial` (3 narrow items); `Jacobian.tex` `correct: partial` (soft drift, informational) | HARD GATE GREEN-LIGHT-WITH-PARALLEL-WRITER for `Cotangent/GrpObj.lean`. Must-fix items absorbed via Wave-3 writer dispatch this iter. `Jacobian.tex` C.2.a–C.2.e drift deferred to iter-133+ (informational, not blocker) |
| 1 (parallel) | `progress-critic` | iter132 | **CHURNING on Route 1**; Routes 2+3 UNCLEAR (deferred-by-design) | Primary corrective ADOPTED: § "Iter-133 branch (concrete fallback)" added below; iter-132 prover-directive includes explicit META-PATTERN TRIPWIRE acceptance test |
| 2 (parallel-with-prover) | `blueprint-writer` | rigiditykbar-piecei-realign-iter132 | COMPLETE | § Piece (i) prose re-aligned to iter-131 body shape; rank-lemma proof rewritten with Steps 1+2 on live closure path; bridge demoted to Step 3 (deferred alternative); new mini-section "Iter-131 `Classical.choose`-chain body shape" added |
| 3 (parallel-with-prover) | `blueprint-writer` | rigiditykbar-uses-cleanup-iter132 | DISPATCHED (parallel with prover lane this iter) | Closes the 3 narrow blueprint-reviewer must-fix items: `\uses{}` cleanup on rank lemma statement+proof, line 88 sentence update, `rem:piece_i_first_target` rewrite |

## Response to critics

### `strategy-critic-iter132` → CHALLENGE — addressed

| Must-fix | Status |
|---|---|
| **M1: Strike ground (iv)** from over-k defense (iter-131 corrective tractability is bootstrap circularity) until iter-132 rank lemma closes | **ADOPTED**: STRATEGY.md § "Over-k re-defense on revised numbers" edit — ground (iv) STRUCK with explicit `~~strikethrough~~` and note that it may be reinstated as iter-132 (not iter-131) tractability evidence ONLY if iter-132 rank lemma closes cleanly. The over-k commitment now rests on (ii) cleanliness + (iii) revert wiring + the quantitative parity (lower-bound zero LOC savings). |
| **M2: Clarify rank-lemma closure path** — `_eq_extendScalars` is necessary-not-sufficient; ~20–50 LOC of `Classical.choose` parallel-extraction wrangling required | **ADOPTED**: PROGRESS.md § "Iter-132 active prover objectives" includes explicit `Classical.choose` parallel-extraction guidance (re-destructure `smooth_locally_free_omega` to read `hfree`/`hrank` directly from the existential; the def's `let h := …` and the rank lemma's `let h := …` are definitionally equal). |
| **M3: Dispatch no-Frobenius mathlib-analogist** for piece (iii) before iter-143+ commits 800–1500 LOC to scheme-level absolute Frobenius | **DEFERRED with explicit scheduling**: STRATEGY.md updated with a scheduled iter-140+ analogist consult on the no-Frobenius / higher-Kähler-vanishing alternative for piece (iii). Rationale (rebuttal to "dispatch this iter"): (a) piece (iii) is iter-144+ on the sequencing table; (b) iter-132 dispatch budget is committed (3 critics + 2 writers + 1 prover); (c) buffer is 8 iters; (d) the scheduling is explicit in STRATEGY.md so a future planner CANNOT silently skip it. **NOT silently ignoring** — the analogist is named, scheduled, and tracked. |
| **M4: Re-state fibre-free criterion as unconditional evaluation** at iter-132 close (the "if rank lemma closes ≤ 100 LOC" trigger is logically inverted) | **ADOPTED**: STRATEGY.md § Sequencing "Fibre-free reformulation evaluation criterion" rewritten — the criterion now fires UNCONDITIONALLY at iter-132 close, comparing projected (i.b)+(i.c) LOC under (B) (300–800 LOC) vs projected fibre-free cost (~400–800 LOC). The "≤ 100 LOC trigger" framing is struck. The evaluation makes the merits-based decision regardless of (B) rank-lemma LOC. |
| **M5: Elevate ℙ¹-specific rigidity hedge** — pile's upper-bound (3600) already exceeds 2000-LOC trigger | **DEFERRED with explicit scheduling**: STRATEGY.md § "C(k) ≠ ∅ branch ℙ¹-specific rigidity hedge" updated with a scheduled iter-140+ analogist consult on the "weak ℙ¹ identification" claim. Rationale: same as M3 (piece (iii) is iter-144+; M2.a body iter-151+; iter-132 dispatch budget is committed). **NOT silently ignoring** — scheduled. |
| **Minor: Scaffold `positiveGenusWitness` now** (~30 LOC) to unlock the genus-stratified body restructure precondition | **DEFERRED with explicit scheduling**: queued for iter-133+ as a quick refactor lane. Rationale: iter-133+ schedule is currently piece (i.b) prover-lane prep (per STRATEGY.md sequencing). The scaffold is genuinely cheap but is best done in a quiet iter; explicit schedule prevents loss. |

### Alternative routes — adoption status

| Alternative | Status |
|---|---|
| **No-Frobenius rigidity via higher Kähler vanishing** (replace piece (iii)) | DEFERRED iter-140+ (see M3 above); scheduled mathlib-analogist consult before piece (iii) work begins iter-144+. |
| **Fibre-free piece (i) unconditional evaluation** | ADOPTED iter-132 (see M4 above); criterion fires at iter-132 close (post-prover-lane). |
| **ℙ¹-specific rigidity hedge — elevate from hedge to active path** | DEFERRED iter-140+ (see M5 above); scheduled analogist consult before M2.a body iter-151+. |
| **Scaffold `positiveGenusWitness` now** | DEFERRED iter-133+ (see Minor above); explicit schedule in STRATEGY.md. |

### Sunk-cost flags — response

| Flag | Response |
|---|---|
| **SC1: Ground (iv) bootstrap circularity** (iter-131 corrective tractability is itself corrective evidence) | ADOPTED: ground (iv) STRUCK from over-k re-defense (see M1 above). May be reinstated iter-132+ ONLY based on iter-132 (not iter-131) rank-lemma close evidence. |
| **SC2: Qualitative grounds carry decision after quantitative parity erosion** — recommend formal re-open of over-k vs over-`k̄` if iter-132 piece (i.a) cost > 50% above counterfactual over-`k̄` baseline | ADOPTED partially: STRATEGY.md § Sequencing piece (i.a) row already records empirical 5-iter / 250–500 LOC cost. **Added iter-132**: a re-open criterion noting that if iter-132 returns PARTIAL/INCOMPLETE on the rank lemma (piece (i.a) cumulative cost would then exceed 6 iters), the over-k decision is formally re-opened with strategy-critic re-dispatch (different question class than this iter). |
| **SC3: User-hint citation discipline NOT applied to piece (iii) scheme-level Frobenius** (800–1500 LOC commitment without local trade-off justification) | ADOPTED: see M3 above. The scheduled iter-140+ no-Frobenius analogist consult IS the local trade-off justification. STRATEGY.md note added: piece (iii) 800–1500 LOC commitment is **provisional**, pending the iter-140+ analogist's verdict on whether an alternative (higher-Kähler vanishing) is materially cheaper. |

### `progress-critic-iter132` → CHURNING on Route 1 — addressed

| Critic finding | Action this iter |
|---|---|
| **Route 1 CHURNING** — 4 iters of body-shape work, 2 critic-flagged defect classes (degenerate body iter-128, opaque body iter-130), 0 project-sorry elimination | **PRIMARY CORRECTIVE EXECUTED**: iter-132 is structurally the RIGHT escalation (first sorry-elimination dispatch — rank lemma — not a 5th body reshape). Iter-131 refactor delivered the structural tractability evidence (`_eq_extendScalars` closes by `rfl`); iter-132 rank lemma is the closure-readiness test. |
| **Iter-133 branch language must be CONCRETE, not promise-language** — if iter-132 PARTIAL or 3rd defect class surfaces, MUST NOT assign 4th body reshape | **ADOPTED**: § "Iter-133 branch (concrete fallback)" below names the explicit branch tree with no body-reshape option. |

### `blueprint-reviewer-iter132` → 1 chapter `correct: partial` — addressed

| Chapter / finding | Action |
|---|---|
| `RigidityKbar.tex` `correct: partial` — 3 narrow items: rank-lemma `\uses{}` cleanup × 2, line 88 sentence, `rem:piece_i_first_target` cleanup | **ABSORBED via Wave-3 narrow writer** dispatched parallel with the prover lane this iter |
| `Jacobian.tex` `correct: partial` — soft drift on C.2.a–C.2.e (still over-`k̄` historical scaffolding) | **DEFERRED to iter-133+** as a soft cleanup writer pass. Rationale: not a blocker (no prover route consumes the sub-step prose; the chapter is internally consistent because C.2.f explicitly DROPs the descent step). Explicitly scheduled in STRATEGY.md as iter-133+ soft cleanup. |
| `RigidityKbar.tex` subsection header "Piece (i): sub-lemma decomposition for iter-128+ build" — soft mis-narration (header still says iter-128+ but prose has caught up to iter-131/iter-132) | **DEFERRED informational**, not a blocker; the header is cosmetic. |

## STRATEGY.md edits this iter (4 substantive edits)

1. **§ Over-k re-defense on revised numbers**: ground (iv) (iter-131 corrective tractability) STRUCK with explicit strikethrough; note added that ground (iv) may be reinstated as **iter-132 tractability evidence** (NOT iter-131) ONLY if iter-132 rank lemma closes cleanly. Plus a re-open criterion: if iter-132 PARTIAL/INCOMPLETE on rank lemma, formal re-open of over-k vs over-`k̄` is triggered.

2. **§ Fibre-free piece (i) reformulation — ELEVATION CRITERION iter-131**: criterion rewritten — unconditional evaluation at iter-132 close (comparing projected (i.b)+(i.c) LOC under (B) vs projected fibre-free cost); the "≤ 100 LOC trigger" framing is struck.

3. **§ Mathlib gap inventory** — "Gap (scheme-level absolute Frobenius)": 800–1500 LOC commitment now marked **PROVISIONAL** pending iter-140+ no-Frobenius mathlib-analogist consult.

4. **§ C(k) ≠ ∅ branch ℙ¹-specific rigidity hedge**: schedule moved from "iter-145+ if pile blows past 2000 LOC" to **iter-140+ scheduled mathlib-analogist consult on the "weak ℙ¹ identification" claim** (independent of pile budget; the strategy-critic-iter132 noted the pile upper-bound 3600 already exceeds the 2000-LOC trigger).

Plus a new sub-bullet under § Roadmap M2 about scheduling `positiveGenusWitness` scaffold for iter-133+.

## Iter-133 branch (concrete fallback per progress-critic-iter132 META-PATTERN TRIPWIRE)

If the iter-132 prover lane returns COMPLETE on `cotangentSpaceAtIdentity_finrank_eq`:
- Route 1 flips to **CONVERGING** (5th body-shape interaction closes with sorry elimination).
- Iter-133 dispatches: piece (i.b) `mulRight_globalises_cotangent` mathlib-analogist consult (per `strategy-critic-iter131` Q3 must-fix on piece (i.b) feasibility before any prover lane); fibre-free reformulation unconditional evaluation (per strategy-critic-iter132 M4); + 3 mandatory critics.
- Iter-133 piece (i.a) cost finalised at 5 iter / 250–500 LOC (matches iter-131 revised STRATEGY.md estimate).
- Over-k ground (iv) reinstated as **iter-132 tractability evidence** (not iter-131).

If the iter-132 prover lane returns PARTIAL (rank lemma scaffold lands but body has `sorry` or fails to close on a Mathlib-name-resolution issue):
- Route 1 stays **CHURNING** (3rd defect class would arm META-PATTERN TRIPWIRE).
- **NO 4TH BODY RESHAPE.** Iter-133 dispatches a strictly novel mathlib-analogist with a question targeting **shape-for-rank-access** — specifically: "What is the canonical Mathlib pattern for defining the cotangent space at the identity of a smooth group scheme such that its rank is immediately accessible via `Module.finrank` rewriting, without an intermediate `Classical.choose`-chain or `extendScalars` rewrite step?" This is strictly different from prior consults (chart base change, body opacity).
- If the analogist returns ALIGN_WITH_MATHLIB on a different Mathlib idiom, iter-134 dispatches a refactor lane to that idiom.
- If the analogist returns DIVERGE_INTENTIONALLY, escalate to user with: cumulative piece (i.a) cost (now 6+ iters), three documented defect classes (degenerate iter-128, opaque iter-130, rank-access-blocked iter-132), and concrete proposal-set: (a) swap to direct quotient construction; (b) invert abstraction so rank is exposed at definition time; (c) re-open over-k vs over-`k̄` decision.

If the iter-132 prover lane returns INCOMPLETE (rank lemma not scaffolded; e.g. Mathlib name resolution catastrophe):
- Route 1 → **STUCK**.
- STOP route, dispatch strategy-critic mid-iter with explicit route-pivot question.

**No fourth body reshape on `cotangentSpaceAtIdentity`** is on the iter-133 menu under any of these branches. This is the explicit non-promise commitment.

## PROGRESS.md edits this iter

- Iter-132 active prover objective set: scaffold + close
  `cotangentSpaceAtIdentity_finrank_eq` in `AlgebraicJacobian/Cotangent/GrpObj.lean`.
- Closure chain documented end-to-end with all Mathlib names tagged
  [verified iter-132].
- Acceptance test (per progress-critic-iter132 META-PATTERN TRIPWIRE)
  named: rank-lemma body must close with no `sorry`; must reference
  `Module.finrank_baseChange` AND `Module.finrank_eq_of_rank_eq`;
  closing proof must consume `cotangentSpaceAtIdentity_eq_extendScalars`
  (or equivalently `unfold` the def directly with a parallel
  `Classical.choose`-chain destructuring).
- `Classical.choose` parallel-extraction guidance included per
  strategy-critic-iter132 M2.

## Mathlib name verifications this iter (plan-agent direct)

5 names re-verified via `lean_run_code` + `lean_leansearch`:
`Module.finrank_baseChange`, `Module.finrank_eq_of_rank_eq`,
`Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`,
`Algebra.IsStandardSmooth.free_kaehlerDifferential`,
`Algebra.TensorProduct.instFree`, `ModuleCat.ExtendScalars.obj'`.
All [verified iter-132]; closure chain for the rank lemma is fully
`[verified]` end-to-end.

## Blueprint edits this iter

Two parallel blueprint-writer dispatches:
1. `blueprint-writer-rigiditykbar-piecei-realign-iter132` — substantive
   re-alignment of § Piece (i) prose (rank lemma proof Steps 1+2 on
   live closure path; bridge to Step 3 deferred; new body-shape mini
   section).
2. `blueprint-writer-rigiditykbar-uses-cleanup-iter132` — narrow
   cleanup of 3 `\uses{}` blocks + 1 line-88 sentence per
   blueprint-reviewer-iter132 must-fix list.

## Refactor / prover edits this iter

- No refactor lane this iter.
- Prover lane on `AlgebraicJacobian/Cotangent/GrpObj.lean` (rank lemma
  scaffold + close). See PROGRESS.md § "Iter-132 active prover
  objectives" for the full directive.

## What the iter-133 plan agent will see

The iter-132 prover lane outcome on `cotangentSpaceAtIdentity_finrank_eq`
determines the iter-133 dispatch tree (see § "Iter-133 branch" above).
The three branches are explicit and the no-body-reshape commitment is
binding.

## Fallback if no user response

(No user escalation is being raised this iter. Iter-132 is routine
critics + writers + prover; no user input needed. If iter-132 returns
PARTIAL or INCOMPLETE on the rank lemma, the iter-133 plan agent
executes the explicit § "Iter-133 branch" tree — either novel analogist
question or user escalation per the tree — and writes a fresh
TO_USER.md banner if escalating.)

## Watch criteria committed for iter-133

1. **Iter-133 mandatory progress-critic**: Route 1 trajectory enters
   iter-133 with: iter-128 prover COMPLETE-but-degenerate, iter-129
   plan-only refactor, iter-130 prover COMPLETE-but-opaque, iter-131
   plan-only refactor, iter-132 prover ?. The verdict shifts per the
   § "Iter-133 branch" tree.

2. **Iter-133 mandatory strategy-critic**: re-verify the 4 iter-132
   STRATEGY.md edits — ground (iv) strike, fibre-free unconditional
   evaluation, piece (iii) provisional flag, ℙ¹-hedge analogist
   schedule. Plus the iter-133 reinstatement-or-strike-decision on
   ground (iv) based on iter-132 outcome.

3. **Iter-133 mandatory blueprint-reviewer**: confirm
   `RigidityKbar.tex` re-flips to `correct: true` after the iter-132
   parallel writers landed. Expected: PASS.

4. **No second helper round on Route 1** under any branch (per
   progress-critic-iter132 META-PATTERN TRIPWIRE non-promise
   commitment).

5. **Fibre-free unconditional evaluation** (per strategy-critic-iter132
   M4) fires at iter-132 close, regardless of rank-lemma LOC. The
   evaluation: projected (i.b)+(i.c) under (B) = 300–800 LOC; projected
   fibre-free = 400–800 LOC. If the evaluation tips fibre-free, iter-133
   plan agent considers a route pivot to fibre-free for (i.b)+(i.c).
