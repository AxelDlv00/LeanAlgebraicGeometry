# Iter-131 (Archon canonical) plan-agent run

## Headline outcome

Iter-130 closed with the prover lane on `cotangentSpaceAtIdentity` shipping a kernel-clean body that **passed the iter-130 progress-critic's literal acceptance test** but was flagged by iter-130 review-phase audits (`lean-auditor-review130` must-fix, `lean-vs-blueprint-checker-cotangent-grpobj-review130` major × 2) as **structurally opaque past `Nonempty (ModuleCat k)`**. The iter-130 body's outer `Classical.choice (α := ModuleCat k) ⟨X⟩` wrapping discards the chart-base-changed Kähler module's accessibility for the deferred rank lemma `cotangentSpaceAtIdentity_finrank_eq`.

**Iter-131 is the second-corrective-iter for piece (i.a)** (after iter-129 corrected iter-128's zero-collapse defect, iter-131 corrects iter-130's opaque-witness defect). The pattern is iter-128 prover (wrong) → iter-129 plan (diagnose+rename+relax) → iter-130 prover (opaque) → iter-131 plan (refactor body shape). Both `strategy-critic-iter131` and `progress-critic-iter131` flagged this 4-iter run on the same declaration as a meta-pattern requiring corrective subagent dispatches before any further body-shape attempt.

**Iter-131 deliverables landed cleanly**:

1. **3 mandatory critics dispatched + returned in Wave 1**:
   - `strategy-critic-iter131` → **CHALLENGE** (3 routes CHALLENGE'd + 1 critical alternative + 2 minor alternatives + 3 sunk-cost flags + 1 SOUND M1/M3). Must-fix items all absorbed this iter: budget revision for piece (i.a), iter-131 deliverable testability, pre-commit to body-shape analogist, trio → duo collapse, 1-iter slip propagation, alternative (B′) scoping, iter-130 close reframed as 0 deliverables.
   - `blueprint-reviewer-iter131` → **2 chapters `correct: partial`**: (a) `RigidityKbar.tex` § Piece (i.a) bridge proof Step 1 + rank proof Step 1 + line 203 closure-path paragraph carry iter-128/iter-130-era prose drift; (b) `AbelJacobi.tex` Galois-descent prose drift at lines 82, 87, 89. Hard-gate-check: passes for the iter-131 refactor lane (no prover dispatch this iter). The `AbelJacobi.tex` writer ran this iter; the `RigidityKbar.tex` writer is deferred to iter-132 per directive-override authorisation (the refactor lane changes the body shape, so the writer needs the post-refactor body to align prose in a single pass).
   - `progress-critic-iter131` → **CHURNING on Route 1** (`Cotangent/GrpObj.lean`). Verdict rule "delivers `COMPLETE` then has it pulled back" is canonical churn. Primary corrective: mathlib-analogist consult BEFORE the refactor lane runs. Both other routes (RigidityKbar.lean, Jacobian.lean) UNCLEAR in the benign deferred-by-design sense.

2. **Wave 2 (parallel)**: mathlib-analogist + blueprint-writer.
   - `mathlib-analogist-cotangent-body-shape-iter131` → **ALIGN_WITH_MATHLIB on iter-130 body (critical) + PROCEED on iter-131 `Classical.choose`-chain proposal (major) + DIVERGE_INTENTIONALLY from (B′) chart-level pivot (informational)**. Verified:
     - The iter-130 body's outer `Classical.choice (Nonempty.intro X)` discards structural access (kernel-level fact at `Init/Classical.lean:19-32`).
     - The iter-131 `Classical.choose`-chain proposal restores structural access (Mathlib precedent: `Polynomial.SplittingFieldAux` in `Mathlib.FieldTheory.SplittingField.Construction:126-138`).
     - The rank-lemma closure chain (Decision 2 in `analogies/cotangent-body-shape.md`) is fully `[verified]` end-to-end under the refactored body; `Module.finrank_baseChange` exact-match at `Mathlib.LinearAlgebra.Dimension.Constructions` (upgraded from `[expected]` iter-129).
     - Replacement (B′) chart-level `m_V / m_V²` shares the **same regular-local bridge [gap]** with (A) (500–1000 LOC of "smooth-over-field-at-prime ⇒ IsRegularLocalRing of dim n"). The "intermediate" framing from strategy-critic-iter131 was misled by skipping the geometric-stalk identification (~100–200 LOC saving on a 500–1000 LOC bridge). (B′) is **not** a separate class from (A) — both pay the same gap. Decision: stay on (B); defer (B′)/(A) until trigger (a') fires.
   - `blueprint-writer-abeljacobi-galois-iter131` → **COMPLETE** (three prose realignments to `AbelJacobi.tex` removing Galois-descent framing on the genus-0 sub-case per iter-127 over-k commitment).

3. **Wave 3 (refactor lane)**: `refactor-cotangent-grpobj-body-shape-iter131` → **COMPLETE**. Replaced the iter-130 `by`-tactic body of `cotangentSpaceAtIdentity` with a pure-term `noncomputable def` using `let`-bindings on `Classical.choose` / `.choose_spec` of `smooth_locally_free_omega`. Added new theorem `cotangentSpaceAtIdentity_eq_extendScalars` (the **strong** acceptance-test form) which closes by `refine … rfl⟩` — the strategy-critic-iter131's must-fix "testable deliverable" requirement. Refreshed three docstring blocks (Status, "Caveat on canonicity", closing paragraph) to describe the iter-131 body shape accurately. Piggybacked the two stale `Jacobian.lean` docstrings (L195 + L226: "single remaining sorry" → "one of the two open sorries"). `lake build` passes (8330 jobs); `lean_verify` on both `cotangentSpaceAtIdentity` and `cotangentSpaceAtIdentity_eq_extendScalars` returns `{propext, Classical.choice, Quot.sound}` — kernel-only. Sorry count unchanged at 3.

**Iter-131 verdict on the META-PATTERN tripwire** (per iter-130 review.md's "not yet armed" condition): iter-131's fix-up **delivered a testable accessible body**, so the tripwire **does NOT arm**. The strategy-critic's empirical re-estimate of piece (i.a) (3+ iters / 200+ LOC for definition alone — the iter-129 analogist's "50–100 LOC / 1–2 iter" budget is empirically broken by ~3×) is absorbed into STRATEGY.md this iter; iter-132 is the natural follow-up prover lane on the rank lemma.

## Subagent dispatches this iter (6 total)

| Wave | Subagent | Slug | Verdict | Outcome |
|---|---|---|---|---|
| 1 (parallel) | `strategy-critic` | iter131 | CHALLENGE — 3 routes CHALLENGE, 1 critical alternative, 3 sunk-cost flags | All must-fix items addressed via STRATEGY.md edits this iter + the Wave-2 analogist + Wave-3 refactor's testable acceptance lemma |
| 1 (parallel) | `blueprint-reviewer` | iter131 | 2 chapters `correct: partial` (RigidityKbar.tex Piece (i.a) + AbelJacobi.tex Galois descent) | AbelJacobi.tex addressed via Wave-2 writer this iter; RigidityKbar.tex deferred to iter-132 per directive-override (refactor lane must land first) |
| 1 (parallel) | `progress-critic` | iter131 | **CHURNING on Route 1** (`Cotangent/GrpObj.lean`) + 2 UNCLEAR deferred-by-design | Primary corrective dispatched this iter (mathlib-analogist Wave 2 before refactor) |
| 2 (parallel) | `mathlib-analogist` | cotangent-body-shape-iter131 | ALIGN_WITH_MATHLIB (iter-130 body) + PROCEED (iter-131 proposal) + DIVERGE_INTENTIONALLY ((B′) pivot) | Concrete Lean shape passed to Wave-3 refactor; (B′) rejected for iter-131 (regular-local [gap] shared with (A)); persistent file `analogies/cotangent-body-shape.md` written |
| 2 (parallel) | `blueprint-writer` | abeljacobi-galois-iter131 | COMPLETE | Three prose realignments to `AbelJacobi.tex` removing Galois-descent framing (lines ~82, ~87, ~89) per iter-127 over-k commitment |
| 3 | `refactor` | cotangent-grpobj-body-shape-iter131 | COMPLETE | Body refactored to pure-term `Classical.choose`-chain; strong acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars` closes by `rfl`; docstrings refreshed; `Jacobian.lean` docstrings piggybacked; kernel axioms preserved |

## Response to critics

### `strategy-critic-iter131` → CHALLENGE — addressed

| Must-fix | Adoption status |
|---|---|
| **Q1: Replacement (B) budget revision** — piece (i.a) cost is empirically 4 iter / ≥ 200 LOC vs. iter-129 analogist's 1–2 iter / 50–100 LOC estimate | **ADOPTED** in STRATEGY.md § Sequencing: piece (i.a) row revised to "5 iter / 250–500 LOC (definition iter-128, signature relax iter-129, vacuous body iter-130, opaque body iter-130, body-shape refactor iter-131; rank lemma iter-132+)"; the iter-129 "50–100 LOC / 1–2 iter" framing struck as empirically broken |
| **Q2: Iter-131 testable deliverable** — refactor must produce a stub that the rank lemma can type-check against | **ADOPTED**: refactor lane directive included the **strong** acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars` as the testable acceptance criterion. Lemma closed by `refine … rfl⟩` per refactor report — the iter-131 refactor's deliverable is testable AND tested |
| **Q3: Pre-commit to piece-(i.b) feasibility analogist before iter-133+ prover dispatch** | **ADOPTED**: § Sequencing piece (i.b) row updated to "iter-133+ piece (i.b) prover lane MUST be preceded by a mathlib-analogist consult on whether the shear iso composes with the iter-131 `Classical.choose`-chain body of `cotangentSpaceAtIdentity` (chart-dependent fibre) or requires constructing the (B)→(A) bridge (~300–600 LOC) inline" |
| **Q4: Trio (definition + bridge + rank) is vestigial under (B)** — bridge piece exists in RigidityKbar.tex but does NOT need to be on the live build path under (B) | **ADOPTED in STRATEGY.md prose**, deferring the corresponding RigidityKbar.tex re-alignment to the iter-132 blueprint-writer dispatch (already authorised by blueprint-reviewer-iter131's directive override). The "bridge piece is vestigial under (B); only relevant if trigger (a') fires" framing is added to STRATEGY.md § M2.body-pile piece (i) entry |
| **Q5: 1-iter slip propagation** — piece (i.b) iter-133+, piece (i.c) iter-137+, piece (ii) iter-141+, piece (iii) iter-144+, M2.a body iter-151+, M2.b body iter-153+, M2 closure iter-157+ | **ADOPTED**: STRATEGY.md § Sequencing table updated with iter-131 slip; honest M2 closure window shifts 152+ → 153+ to 173+ |
| **Q6: Sunk-cost flag on iter-130 close** — reframe in STRATEGY.md sequencing table as 0 piece-(i.a) deliverables | **ADOPTED**: STRATEGY.md § Sequencing piece (i.a) row revised — iter-130 close is now "shipped Lean-type-correct but opaque body requiring iter-131 refactor before downstream work; net iter-130 progress on piece (i.a): 0 deliverables" |
| **Critical alternative (B′) chart-level `m_V / m_V²`** | **SCOPED + REJECTED iter-131**: `mathlib-analogist-cotangent-body-shape-iter131` Decision 3 verified that (B′) shares the regular-local bridge [gap] with (A) (500–1000 LOC of "smooth-at-prime ⇒ IsRegularLocalRing of dim n"); (B′) is NOT intermediate between (A) and (B). The strategy-critic's "intermediate" framing was misled by counting only the ~100–200 LOC savings from skipping geometric-stalk identification. Decision: stay on (B); defer (B′)/(A) until trigger (a') fires |
| **Minor alternative: fibre-free piece (i) reformulation** — elevate to iter-132+ evaluation at rank-lemma close | **PARTIALLY ADOPTED**: STRATEGY.md § Sequencing entry "Standalone scheme-level cotangent sheaf — iter-129 re-evaluation engaged AND returned" extended with iter-131 entry: "Fibre-free reformulation is now elevated from `Option 3 backup` to `evaluate at iter-132 rank-lemma close` with explicit criterion: if (B)'s rank lemma closes in ≤ 100 LOC at iter-132, evaluate fibre-free for (i.b)+(i.c) before continuing on (B)'s (i.b)" |
| **Minor alternative: skip piece (i.a) entirely, fold into rigidity proof's local term-mode** | **NOT ADOPTED**: the iter-131 refactor already produced a structurally-accessible body; folding into `rigidity_over_kbar`'s term-mode would lose the documentation surface (rank lemma as a named theorem). Recorded informational |
| **Sunk-cost flag 2: iter-131 framed as "fixing the body shape"** — should be reframed as "the second tactical recovery iter on piece (i.a)" | **ADOPTED**: iter-131 plan.md (this file) frames it as "second-corrective-iter for piece (i.a)" with the cumulative iter count called out |
| **Sunk-cost flag 3: iter-131 refactor presumes the body's math is right** — should explicitly cite analogist file recommendation | **ADOPTED**: refactor-cotangent-grpobj-body-shape-iter131 directive cites `analogies/cotangent-body-shape.md` § Recommendation as the body sketch source-of-truth; refactor agent's report confirms the strong acceptance lemma closes |

### `progress-critic-iter131` → CHURNING on Route 1 — addressed

| Critic finding | Action this iter |
|---|---|
| **Route 1 (`Cotangent/GrpObj.lean`) verdict: CHURNING** — 4 body-shape interventions on one declaration across 4 consecutive iters, each cycle catching a different upstream defect class while the same downstream lemma (`cotangentSpaceAtIdentity_finrank_eq`) stays blocked | **PRIMARY CORRECTIVE EXECUTED**: dispatched `mathlib-analogist-cotangent-body-shape-iter131` BEFORE the refactor lane. Analogist verified that `Classical.choose`-chain pattern fixes the accessibility defect (Mathlib precedent `Polynomial.SplittingFieldAux`); refactor lane subsequently landed the body with the strong acceptance lemma closing by `rfl`. CHURNING corrective fired this iter; META-PATTERN tripwire does NOT arm (the fix-up delivered a testable accessible body, not yet another opaque body) |
| **Secondary correctives** (priority order, if analogist negative): re-dispatch strategy-critic mid-iter; route pivot to (A)/(C) or fibre-free | **NOT ENGAGED** — analogist returned PROCEED. Secondary correctives are dormant; will re-engage at iter-132+ rank-lemma close if the rank lemma fails to close cleanly |
| Routes 2/3 (`RigidityKbar.lean`, `Jacobian.lean`): UNCLEAR (deferred-by-design) | No action — planner's "no work this iter" is appropriate |

### `blueprint-reviewer-iter131` → 2 partial chapters — addressed

| Chapter / finding | Action |
|---|---|
| `AbelJacobi.tex` `correct: partial` — 3 prose locations (lines ~82, ~87, ~89) still describe Galois descent | **DISPATCHED `blueprint-writer-abeljacobi-galois-iter131` this iter**; returned COMPLETE; chapter now `correct: true` per the writer's validation step |
| `RigidityKbar.tex` `correct: partial` — bridge proof Step 1 (~line 151) + rank proof Step 1 (~line 191) + line 203 closure-path paragraph carry iter-128/iter-130-era prose drift | **DEFERRED to iter-132 blueprint-writer dispatch** per the reviewer's explicit directive-override authorisation. Rationale: the iter-131 refactor lane changes the body shape; the iter-132 blueprint-writer pass on `RigidityKbar.tex` re-aligns the Piece (i.a) `\notready` lemmas' proof sketches against the iter-131 refactored body in a single coherent pass |
| `Jacobian.lean` docstring staleness at L195+L226 ("single remaining sorry") — Lean-side staleness, not blueprint | **ADDRESSED in the refactor lane piggyback** (refactor agent rewrote both lines) |

## Lean Mathlib name verifications this iter (plan-agent direct)

No new `[expected]`→`[verified]` upgrades this iter — the iter-130 plan agent already verified `Module.finrank_baseChange` and `Algebra.TensorProduct.instFree`. The iter-131 `mathlib-analogist-cotangent-body-shape-iter131` confirmed all 8 closure-chain steps (`analogies/cotangent-body-shape.md` § Bridge lemma list) are `[verified]` in Mathlib `b80f227`.

## STRATEGY.md edits this iter

5 substantive edits, all in response to `strategy-critic-iter131`:

1. **§ "Standalone scheme-level cotangent sheaf — iter-129 re-evaluation engaged AND returned"** — extended with iter-131 entry documenting the (B′) chart-level analogist verdict (DIVERGE_INTENTIONALLY; (B′) shares regular-local bridge gap with (A)) and the fibre-free reformulation elevation criterion (evaluate at iter-132+ rank-lemma close).

2. **§ "Over-k re-defense on revised numbers"** — additional ground (iv) recorded: the iter-131 corrective dispatch (analogist consult + refactor) is positive evidence that piece (i.a) is tractable under (B); reframing the iter-130 close as "0 deliverables" preserved.

3. **§ Sequencing table piece (i.a) row** — revised honest cost from "iter-128 / 1 iter" to "**5 iter / 250–500 LOC** (iter-128 vacuous body, iter-129 signature relax, iter-130 opaque body, iter-131 body-shape refactor + acceptance lemma, iter-132+ rank lemma)". The iter-129 analogist's "50–100 LOC / 1–2 iter" framing is empirically broken by ~3× and is struck as a budgetary anchor.

4. **§ Sequencing table M2.a/M2.b/M2 closure rows** — 1-iter slip propagated: piece (i.b) iter-133+, piece (i.c) iter-137+, piece (ii) iter-141+, piece (iii) iter-144+, M2.a body iter-151+, M2.b body iter-153+, M2 closure iter-157+; honest M2 closure window 152+ to 172+ → **153+ to 173+**.

5. **§ M2.body-pile piece (i) entry** — "(i.a-bridge)" piece marked as **vestigial under (B); only relevant if trigger (a') fires**, per Q4. Trio framing collapsed to duo (definition + rank lemma) on the live (B) path; the bridge is now documented as contingent (iter-132 RigidityKbar.tex blueprint-writer will reflect this in the chapter prose).

## PROGRESS.md edits this iter

- ## Current Objectives is set with marker `(no prover dispatch this iter — see iter/iter-131/plan.md for rationale)` per the strategy-critic-iter131's must-fix on iter-131 testability and the progress-critic-iter131's CHURNING corrective. NO prover dispatch this iter; the iter-131 deliverables are the refactor lane (already landed) + the AbelJacobi.tex writer (already landed) + the iter-131 strategy/blueprint/progress critics + the body-shape analogist.
- Iter-132 prover-lane staging is documented under § "Iter-132 staged objectives": scaffold + close the rank lemma `cotangentSpaceAtIdentity_finrank_eq` against the iter-131 refactored body. Closure chain is in `analogies/cotangent-body-shape.md` § "Rank-lemma closure chain end-to-end" — 6 steps + bridge list, all `[verified]`. Use `cotangentSpaceAtIdentity_eq_extendScalars` as the load-bearing rewrite handle.

## Blueprint edits this iter (via `blueprint-writer-abeljacobi-galois-iter131`)

Three prose realignments to `blueprint/src/chapters/AbelJacobi.tex`:

- **Proof of `thm:exists_unique_ofCurve_comp`, "Classical description" half** (formerly line ~82): replaced the over-`k̄` rigidity + Galois descent narrative with the over-`k` route via `\cref{thm:rigidity_over_kbar}`. Explicit `\textbf{DROPPED}` note for sub-step C.2.f (Galois descent of morphism equality back to `k`). Rewrote the `C(k) = ∅` vs `C(k) ≠ ∅` branching to match the over-`k` flow (`C(k) ≠ ∅`: marked point feeds the pointing hypothesis directly; `C(k) = ∅`: `isAlbaneseFor` field vacuously true).

- **"Implementation route via the Albanese framework" first paragraph** (formerly line ~87): trailing route enumeration's genus-0 entry rewritten as "rigidity for $C \to A$ established directly over $k$ (genus-$0$ sub-case, via `\cref{thm:rigidity_over_kbar}` per the iter-127 over-k commitment; no base-change to $\bar k$ and no Galois descent of morphism equality enter)".

- **Same section, second paragraph** (formerly line ~89): parenthetical genus-0 classical-comparison clause rewritten in the same way as #2. The surrounding "classical proof via line bundles" framing was preserved verbatim.

Writer flagged a soft strategy concern: the chapter's "Implementation route" section still enumerates Route A / Route B / genus-0 rigidity as parallel options; the writer notes this is consistent with `Jacobian.tex` Layer I and `RigidityKbar.tex` framing but does not call out genus-0 rigidity as the canonical project route. Recorded informational; the planner does NOT escalate this to a strategy-modifying finding because the enumeration is correct historically — the genus-0 route is the active path, while Route A / Route B are honest fallback documentation.

## Refactor edits this iter (via `refactor-cotangent-grpobj-body-shape-iter131`)

Two-file refactor:

- **`AlgebraicJacobian/Cotangent/GrpObj.lean`** — body shape refactor on `cotangentSpaceAtIdentity` from `by`-tactic (iter-130) to pure-term `noncomputable def` (iter-131); new theorem `cotangentSpaceAtIdentity_eq_extendScalars` (the **strong** acceptance-test form) closes by `refine … rfl⟩`; three docstring blocks refreshed.
- **`AlgebraicJacobian/Jacobian.lean`** — two stale "single remaining sorry" docstrings rewritten (L195 + L226).

`lake build` passes (8330 jobs). `lean_verify` on both refactored declarations returns kernel-only `{propext, Classical.choice, Quot.sound}`. Sorry count unchanged at 3 (Jacobian.lean:192, Jacobian.lean:213, RigidityKbar.lean:87).

Refactor agent flagged 3 informational items for the iter-132+ plan agent:
- `Scheme.Hom.mem_preimage` rewrite quirk in the `htop` proof inside the acceptance lemma's tactic context (worked around with a single `change` line; no semantic divergence). Potentially worth flagging upstream as a Mathlib `rw`-firing edge case but out of scope for iter-131.
- Long-line warning at `Jacobian.lean:234` on the protected `Jacobian` def signature is pre-existing; refactor agent could not touch a protected signature. Plan agent may flag to mathematician; the line break is purely cosmetic.
- Mid-docstring stale reference at line 87 of `Cotangent/GrpObj.lean` (mentions "iter-129+ companion rank lemma" while the new closing paragraph at lines 144–148 correctly says "iter-132+"). Minor staleness in a section the refactor directive didn't scope; piggyback in a future iter.

## What the iter-132 prover lane will see

Iter-132 is the natural follow-up prover lane: scaffold + close the rank lemma `cotangentSpaceAtIdentity_finrank_eq` against the iter-131 refactored body. The closure chain is verified end-to-end in `analogies/cotangent-body-shape.md` § "Rank-lemma closure chain end-to-end":

1. `unfold cotangentSpaceAtIdentity` exposes the `let`-bound `Classical.choose` extractions.
2. `obtain ⟨_, _, _, _, hfree, hrank⟩` (or similar nested-pair destructuring) on `h.choose_spec.choose_spec.choose_spec.2.2.2` (or the corresponding projection chain for the `smooth_locally_free_omega` existential's tuple).
3. `cotangentSpaceAtIdentity_eq_extendScalars` provides the rewrite handle to a `(ModuleCat.extendScalars _).obj _`-form.
4. `rank_kaehlerDifferential` gives rank `n` over `Γ(G, V)`.
5. `Module.finrank_baseChange` brings the rank down to `k`.
6. `Module.finrank_eq_rank'` connects `Module.rank` to `Module.finrank` under `FiniteDimensional`.

Estimated iter-132 prover-lane LOC: 50–100 (per iter-129 analogist; preserved as the original estimate). Per the iter-131 strategy-critic's Q5 honest revision, the cumulative piece (i.a) iter count enters iter-132 at 4 already, so iter-132's outcome is the **5th** body-shape interaction with this declaration. If iter-132 closes cleanly, piece (i.a) is closed (definition + rank lemma); if iter-132 returns PARTIAL, the META-PATTERN TRIPWIRE arms (per iter-130 review.md's "third corrective cycle" condition).

## Fallback if no user response

(No user escalation is being raised this iter. The iter-131 deliverables are all routine subagent dispatches plus the refactor lane; no user input is required. If iter-132 returns PARTIAL on the rank lemma, the iter-132 plan agent should evaluate the fibre-free piece (i) reformulation per the strategy-critic-iter131's elevation criterion, and may then re-dispatch strategy-critic with a route-pivot question.)

## Watch criteria committed for iter-132

1. **Iter-132 mandatory progress-critic**: Route 1 (`Cotangent/GrpObj.lean`) signal trail will be 4 iters (iter-128 prover COMPLETE-vacuous, iter-129 plan-only refactor, iter-130 prover COMPLETE-opaque, iter-131 plan-only refactor-with-acceptance-lemma). The verdict depends entirely on iter-132 prover outcome:
   - **If iter-132 prover lane on `cotangentSpaceAtIdentity_finrank_eq` returns COMPLETE**: Route 1 flips to CONVERGING. Cumulative piece (i.a) iters: 5 (iter-128 + iter-129 + iter-130 + iter-131 + iter-132); revised piece (i.a) cost in STRATEGY.md is empirically realized. Proceed to piece (i.b) scaffold iter-133+.
   - **If iter-132 returns PARTIAL** (rank lemma scaffold lands but body not closed): Route 1 verdict shifts to "third corrective cycle"; META-PATTERN TRIPWIRE arms. Mandatory mathlib-analogist consult on whether the chosen body shape supports the rank lemma closure path BEFORE iter-133+ prover work; if analogist verdict is negative, re-dispatch strategy-critic for route pivot to (A) or fibre-free reformulation.
   - **If iter-132 returns INCOMPLETE**: Route 1 → STUCK. STOP this route; trigger strategy-critic mid-iter with explicit route-pivot question.

2. **Iter-132 mandatory blueprint-reviewer**: the iter-132 blueprint-writer on `RigidityKbar.tex` (re-aligning Piece (i.a) `\notready` proofs to the iter-131 refactored body) is a parallel-with-prover dispatch. The blueprint-reviewer iter-132 confirms the writer's edits + the post-refactor coherence.

3. **Iter-132 mandatory strategy-critic re-verification**: confirms the 5 iter-131 STRATEGY.md edits absorbed correctly + the iter-132 outcome on Route 1 closes or escalates.

4. **Trigger (a') iter-130 strengthening remains live** for iter-133+ piece (i.b). If iter-133+ piece (i.b) closure under (B) requires inline (B)→(A) bridge construction (~300–600 LOC), revert to (A) + reintroduce M2.c. The iter-131 mathlib-analogist's regular-local-bridge [gap] confirmation reinforces this trigger (the bridge cost is real and matches the iter-129 estimate).

5. **Fibre-free reformulation evaluation criterion** (per strategy-critic-iter131 alternative): if iter-132 rank lemma closes in ≤ 100 LOC, evaluate fibre-free for (i.b)+(i.c) before continuing on (B)'s (i.b) path. The decision is made at iter-132 close.

6. **META-PATTERN check**: iter-128 prover-wrong / iter-129 plan-correct / iter-130 prover-wrong / iter-131 plan-correct / iter-132 prover-? — the pattern would flip to CHURNING if iter-132 again produces a non-deliverable rank lemma. Per the iter-130 review.md's "tripwire arming" condition, this requires a third consecutive cycle on the same declaration; iter-132 is the test.
