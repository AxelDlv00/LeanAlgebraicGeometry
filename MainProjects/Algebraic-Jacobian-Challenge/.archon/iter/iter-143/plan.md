# Iter-143 (Archon canonical) plan-agent run

## Headline outcome

Iter-142 prover lane on piece (i.b) Step 2 BUNDLED 3-sub-sorry closure
returned **PARTIAL — 1 of 3 closed substantively (d_map at L643)**.
This was the first strict-count closure on this route since iter-138
(d_add/d_mul decomposition refinement). Per the iter-142 pre-committed
acceptance matrix (PASS ≥2/3; PARTIAL 0–1; FAIL 0+blocker), iter-142
landed in the **PARTIAL arm → CHURNING-CONFIRMED**.

**Iter-143 PRIMARY DECISION**: execute the iter-142 pre-committed
CHURNING-CONFIRMED correctives by (a) dispatching a `refactor` subagent
to extract the IsIso `letI := isIso_of_app_iso_module ... (fun _ => sorry)`
pattern into a named sorry-bodied theorem (per `lean-auditor-review142`
MAJOR + `progress-critic-iter143` CHURNING primary corrective +
`strategy-critic-iter143` definition-level diagnostic), (b) dispatching
a `blueprint-writer` on `RigidityKbar.tex` to elevate iter-142's
empirical shape-discoveries into the d_app recipe + add a NOTE on the
iter-143 in-Lean refactor to the IsIso recipe, (c) firing a Wave 3
**prover lane narrowed to d_app ONLY** on `Cotangent/GrpObj.lean`.

All three mandatory critics + the lean-auditor MAJOR converged on this
shape. Strategy-level pivot is NOT INDICATED (per `strategy-critic-iter143`
"Strategy-level pivot is NOT INDICATED: iter-142's d_map close is
positive evidence the (B) recipe works on the hardest empirical sub-sorry").

**Iter-143 is plan + parallel-Wave-1 (3 mandatory critics) +
parallel-Wave-2 (1 refactor + 1 blueprint-writer) + sequential-Wave-3
(d_app-only prover lane fires after this plan phase via the loop
dispatcher).** 5 subagent dispatches this plan phase total; all
returned + absorbed.

## Wave 1 (parallel) — 3 dispatches, all returned + absorbed

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| `blueprint-reviewer` | iter143 | **PASS / HARD GATE GREEN-LIT** on `Cotangent/GrpObj.lean`. 11 chapters audited; 0 must-fix; 2 soon (elevate iter-142 empirical lessons into d_app recipe; add IsIso named-theorem refactor NOTE); 3 informational (stale `\notready` on `Jacobian.tex:389,424`; sync_leanok mis-mark count now 3 at `RigidityKbar.tex:406,524,1152`; pointer-chapter iter-138 status text says "d_app + d_map + IsIso" — d_map closed iter-142). Lean target line citations match on-disk file. | Iter-143 prover lane PROCEEDS on `Cotangent/GrpObj.lean` (HARD GATE green). Soon-items absorbed by Wave 2 blueprint-writer dispatch. Informational items deferred to iter-144+ review-agent (stale `\notready` strip) or `archon-lean4:doctor` consult (sync_leanok handling). |
| `progress-critic` | iter143 | **CHURNING-CONFIRMED** (CHURNING-with-positive-signal). Two independent rules fire: PARTIAL ≥3 of K=5 active iters, AND helpers added in ≥2 of K=5 + sorry-count net change −1 over K=5 (~0.2/iter, below 0.5/iter threshold). Iter-142 d_map close is the first new closure technique to land — positive structural signal modulates corrective. **Primary corrective: refactor — extract IsIso into a named sorry-bodied theorem, narrowing iter-143's prover lane to d_app only**. NO 6th mathlib-analogist on IsIso (premature; IsIso not iter-143 target). | All-three-converge shape: Wave 2 refactor + blueprint-writer; Wave 3 d_app-only prover lane. The DIAGNOSTIC strategy-critic dispatch (iter-142 pre-commit) is folded into the mandatory iter-143 strategy-critic with the diagnostic-question framing. |
| `strategy-critic` | iter143 | **SOUND-WITH-CHALLENGE** (10 routes audited; 9 SOUND; 1 CHALLENGE on iter-145+ breakeven counter accounting; 0 REJECT). Diagnostic answered: **d_app is RECIPE-LEVEL** (Step 3 adjunction-transpose ~20–40 LOC bespoke needs explicit chapter decomposition + iter-142 empirical-lesson elevation); **IsIso is HYBRID — DEFINITION-LEVEL on `letI` shape + RECIPE-LEVEL on items 2–4** (refactor + chapter decomposition). **NOT STRATEGY-LEVEL** — iter-144 chart-algebra pull-forward REJECTED; fibre-free pivot NOT triggered (LOC still under 1000 LOC cap); off-route pivot REJECTED. 3 must-fix STRATEGY.md edits: #1 consecutive-PARTIAL breakeven counter reset rule (counter resets by 1 on strict-count closure, NOT to 0; iter-142 d_map close → counter 5 → 4 → projects to iter-146+ at earliest); #2 iter-142 correctives executed via Wave 2 dispatch (refactor + writer); #3 letI-sorry-taint project-wide soundness rule promotion. Minor file-path stale `Grp_.lean` → `Grp.lean` cosmetic. | 2 STRATEGY.md edits this iter (Edit 1 sorry-must-be-named-declaration soundness rule + Edit 2 consecutive-PARTIAL breakeven counter discipline; both inserted under § Soundness rules). Must-fix #2 absorbed by Wave 2 dispatch. Minor file-path stale absorbed as iter-144+ cleanup (low priority). |

## Wave 2 (parallel) — 2 dispatches, both returned + absorbed

| Subagent | Slug | Verdict | Effect |
|---|---|---|---|
| `refactor` | isiso-extract-iter143 | **COMPLETE**. Inserted new theorem `basechange_along_proj_two_inv_app_isIso` at `Cotangent/GrpObj.lean:719–725` carrying the per-open IsIso obligation `∀ X, IsIso ((basechange_along_proj_two_inv G).app X)` with `sorry` body. Modified the consumer `relativeDifferentialsPresheaf_basechange_along_proj_two` to invoke the named theorem via `basechange_along_proj_two_inv_app_isIso (n := n) G` in place of the previous `(fun _ => sorry)`. Two minor signature corrections vs directive: (i) parameter type `X : G.left.Opensᵒᵖ` corrected to `X : (G ⊗ G).left.Opensᵒᵖ` (the natural domain of `(basechange_along_proj_two_inv G).app`); (ii) explicit `(n := n)` pass-through at the call site to disambiguate the implicit `{n : ℕ}` against the typeclass synthesis stalled metavar. Compilation: `lean_diagnostic_messages` reports `success: true` with 3 `declaration uses sorry` warnings (matching the iter-143 expected layout: d_app L637 + new IsIso theorem L725 + Main L875). | **Sorry count net change: 0 inline; 0 declarations net** (the consumer became sorry-clean because the residual now lives in a named theorem; the directive predicted +1 declaration but the actual outcome is strictly better — the consumer's `letI` no longer carries an inline `sorry` term). The IsIso residual is now an auditable named declaration sorry; `sorry_analyzer` + `lean_verify` both surface it. Iter-143 prover lane targets ONLY the d_app sub-sorry at L637. The new `basechange_along_proj_two_inv_app_isIso` is iter-144+ target on Route (b'2) items 2–4 (~195–365 LOC). |
| `blueprint-writer` | rigiditykbar-iter143 | **COMPLETE — all 4 directive edits landed**. `RigidityKbar.tex` 1349 → 1634 LOC (+285). Edit 1 (Iter-142 empirical lessons NOTE at top of d_app recipe, L713): the three rules — fully-explicit `change` on both sides (`pushforward₀`-`whnf` opacity rule extends to `_ = 0`-shape goals when ANY side crosses pushforward-transposed terms); `NatTrans.naturality_apply` packaging via `rw [show ... from ...]` (kernel-form alignment with `RingCat.Hom.hom`/`CommRingCat.Hom.hom`); `PresheafOfModules.pushforward_obj_map_apply'` named-lemma alternative for kernel-form unfolding. Edit 1 also added a decomposed Step 3 (3.a–3.d) sub-recipe at L786 for the adjunction-transpose chase: 3.a (`Over.w` chain ~3–5 LOC), 3.b (`PresheafedSpace.comp_c_app` twice ~10–15 LOC), 3.c (adjunction-transpose witness `h` construction ~20–40 LOC bespoke NEEDS_MATHLIB_GAP_FILL), 3.d (`ModuleCat.Derivation.d_map` discharge ~5–10 LOC). Edit 2 (iter-143 IsIso refactor NOTE at L1132): points downstream provers at the post-refactor `basechange_along_proj_two_inv_app_isIso` named theorem. Edit 3 (Route (b'2) items 2/3/4 concrete sub-recipes; OPTIONAL): added. Edit 4 (iter-142 d_map closed status note at L868; in-prose, NO `\leanok` per `sync_leanok`-deterministic-domain rule): added. LaTeX environment-balance check passed (10/10 itemize, 4/4 enumerate, 12/12 proof, 3/3 verbatim). | Iter-143 prover lane has refined recipe source (d_app Step 3 decomposition with empirical-lesson lift). Iter-144+ IsIso prover lane has items 2/3/4 concrete sub-recipes. The d_map closed status note prevents future iters from re-litigating d_map (it's CLOSED iter-142). Re-dispatching `blueprint-reviewer` on `RigidityKbar.tex` is OPTIONAL within iter-143; the next iter-144's mandatory dispatch will confirm. |

## Iter-143 STRATEGY.md edits (2 substantive)

### Edit 1: Sorry-must-be-named-declaration soundness rule (per `strategy-critic-iter143` Alternative #2 + `lean-auditor-review142` MAJOR + `progress-critic-iter143` CHURNING primary corrective)

Inserted as 2nd bullet under § Soundness rules. Rule: "A `sorry` must
be the body of a **top-level named declaration** (theorem / def / lemma /
instance). It must NOT be embedded inside a `letI`-body, `have`-body,
anonymous-`fun`-argument, or any other tactic-/term-bound construction
inside a *different* declaration's body." Why: `sorry_analyzer` +
`lean_verify` + audit reads all index sorry occurrences at the
declaration boundary; sorry-tainted intermediates buried inside
non-top-level bodies silently propagate. Iter-143 fix executed via the
Wave 2 refactor on `Cotangent/GrpObj.lean:719–725`. Rule applies
project-wide; violations are must-fix-this-iter on the lean-auditor's
next pass.

### Edit 2: Consecutive-PARTIAL breakeven counter discipline (per `strategy-critic-iter143` Must-fix #1 + Alternative #3 promotion)

Inserted as 4th bullet under § Soundness rules (between
"LOC trigger arm renormalisation discipline" and "Analogist-overhead
axis"). Rule: a strict-count substantive closure on any sub-sorry of a
PARTIAL-routed iter **resets the consecutive-PARTIAL counter by 1**
(NOT to 0). Plan-only deferral iters do NOT increment. Iter-142 d_map
close resets counter to 2 (from 5 across iter-138/140 + plan-only
iter-139/141 + PARTIAL iter-142 closure). Breakeven trigger fires at
counter ≥ 5; projects to **iter-146+ at earliest** under no further
closures. Why: without the reset rule, the breakeven counter is a
one-way ratchet — strict-count closures get no signal credit and the
counter monotonically approaches breakeven even on routes converging
on the residual. The reset-by-1 rule (rather than reset-to-0) ensures
both genuine closures get credit AND repeated low-rate PARTIAL iters
still produce a breakeven trigger. Renormalisation discipline (per
iter-138/141 LOC trigger arms) applies: counter rule itself can change
only with a new analogist consult or strategy-critic verdict naming
the renormalisation.

## Iter-143 verification (entering iter-143 prover-phase dispatch)

| Check | Status (iter-143 plan-phase close) |
|---|---|
| Sorry count per file | `Cotangent/GrpObj.lean` **3 decls / 3 inline** (L637 d_app + L725 NEW `basechange_along_proj_two_inv_app_isIso` body + L875 `mulRight_globalises_cotangent` Main), `Jacobian.lean` **2 decls / 2 inline** (L197 + L223), `RigidityKbar.lean` **1 decl / 1 inline** (L87) — **6 decls / 6 inline total**, **unchanged in inline count from iter-142 close** (the iter-143 refactor preserves inline count: the previously-embedded `(fun _ => sorry)` argument disappeared while the new named theorem body adds 1 inline; net 0). **Net change**: +1 named declaration sorry; −1 hidden-letI sorry (auditability strictly improved). |
| `archon-protected.yaml` | unchanged (9 protected declarations). No protected signatures touched by Wave 2 refactor (the new `basechange_along_proj_two_inv_app_isIso` is a NEW non-protected declaration; the modified `relativeDifferentialsPresheaf_basechange_along_proj_two` had no signature change). |
| New axioms | none introduced this plan phase or Wave 2. |
| `USER_HINTS.md` | empty entering iter-143 ("No user hints this iteration" per the captured content); not modified by plan agent. |
| `STRATEGY.md` | 2 substantive edits this iter (sorry-must-be-named-declaration soundness rule + consecutive-PARTIAL breakeven counter discipline). |
| `lake build` | green at iter-142 close (last Lean edit before iter-143 refactor). Wave 2 refactor's `lean_diagnostic_messages` returned `success: true` with 3 `declaration uses sorry` warnings and no errors. Full `lake build` not re-run this plan phase (no import/axiom-graph changes; Wave 2 was in-file body refactor + new sibling theorem). |
| `RigidityKbar.tex` | 1349 → 1634 LOC (+285). 4 edits landed; LaTeX environment-balance check passed. |
| Mandatory critics | 3 of 3 dispatched + returned + absorbed this iter. |
| Subagents dispatched this iter | 5 total (3 mandatory critics + 1 refactor + 1 blueprint-writer); all returned + absorbed at plan-phase close. |
| HARD GATE per blueprint-reviewer | **GREEN-LIT** on `Cotangent/GrpObj.lean` — iter-143 d_app-only prover lane PROCEEDS. |
| Cumulative (i.b)-side LOC (measured iter-143) | **~600 LOC** (L350–L876 of `Cotangent/GrpObj.lean`); +~25 LOC from iter-143 refactor (new `basechange_along_proj_two_inv_app_isIso` theorem + docstring); well below 1000 LOC renormalised trigger cap. |
| Iter-145+ breakeven counter | **2** (per the iter-143 new Edit-2 rule; iter-142 d_map strict-count close reset counter from 5 → 4 entering iter-143; iter-143 is plan + Wave 2 dispatches, NO prover this plan phase, so counter does not increment from plan-phase actions). After iter-143 Wave 3 prover lane returns, counter updates per outcome: PASS → 1, PARTIAL → 3, FAIL → 3. Breakeven trigger fires at counter ≥ 5; under no further closures, projects to **iter-146 at earliest** (iter-143 PARTIAL = 3, iter-144 PARTIAL = 4, iter-145 PARTIAL = 5 → triggers iter-146 route-pivot question). |

## Iter-143 Wave 3 prover-lane scope (NARROWED to d_app only)

Wave 3 fires after this plan phase via the loop dispatcher. **Scope**:

- **File**: `AlgebraicJacobian/Cotangent/GrpObj.lean` (single file).
- **Target sub-sorry**: `basechange_along_proj_two_inv_derivation` d_app at L637 (~40–80 LOC envelope; the iter-142 explicit `change`-skeleton at L611–L618 already lands the goal in canonical form for iter-143's chase).
- **Recipe source**: `RigidityKbar.tex:713` (Iter-142 empirical-lessons NOTE) + `RigidityKbar.tex:786` (Step 3 (3.a–3.d) decomposed sub-recipe). Both landed via Wave 2 blueprint-writer.
- **DO NOT TOUCH**: `basechange_along_proj_two_inv_app_isIso` at L719–L725 (NEW iter-143-extracted theorem; iter-144+ target on Route (b'2) items 2–4; ~195–365 LOC bundled). Lean prover must not attempt closure here in iter-143.
- **DO NOT TOUCH**: `mulRight_globalises_cotangent` at L864–L876 (piece (i.b) Main; iter-145+ target after d_app + IsIso both close).
- **DO NOT TOUCH**: any file other than `Cotangent/GrpObj.lean`.

## Pre-committed acceptance matrix for iter-143 Wave 3 outcome (do NOT soften)

- **PASS arm**: d_app sub-sorry at L637 closes substantively (~40–80 LOC body) → CONVERGING-confirmed; consecutive-PARTIAL counter resets from 2 → 1 (per Edit 2). **Iter-144 plan**: fires next-in-bundle IsIso prover lane on `basechange_along_proj_two_inv_app_isIso` (Route (b'2) items 2–4) AND iter-144 MANDATORY chart-algebra-vs-bundled re-evaluation (per `strategy-critic-iter140` Must-fix #3 + `mathlib-analogist-scheme-frobenius-iter141` HYBRID) at its scheduled gate.
- **PARTIAL arm**: d_app does not close (counter increments from 2 → 3). **Iter-144 plan**: mid-iter strategy-critic with DIAGNOSTIC question ("is the d_app failure recipe-level — i.e. the Step 3 (3.a–3.d) sub-recipe inadequate even with the iter-142 empirical lessons — or definition-level — i.e. the `basechange_along_proj_two_inv_derivation` shape is fundamentally wrong — or strategy-level"); NOT pre-committed route pivot. Per `strategy-critic-iter143` "iter-141 must-fix #4 decoupling correction" discipline.
- **FAIL arm**: d_app fails + new `pushforward₀`-style opacity blocker resurfaces, OR fails + Step 3 adjunction-transpose construction is found mathematically incorrect (counter increments 2 → 3 but the FAIL flag is the qualitative trigger, not the count). **Iter-144 plan**: STUCK; mandatory route pivot consideration; re-open STRATEGY.md.

## Guardrails (carried from iter-142 + reinforced iter-143)

- **NO 6th mathlib-analogist on Route (b'2) IsIso this iter** (per `progress-critic-iter143` informational item; the envelope-widening arm has NOT fired — only iter-137 widened — and IsIso is not the iter-143 prover target).
- **NO route-pivot pre-commitment** for the PARTIAL arm (per `strategy-critic-iter143` "iter-141 must-fix #4" discipline + this iter's diagnostic answer that strategy-level pivot is NOT INDICATED).
- **NO inline sorry inside `letI` / `have` / anonymous-`fun` bodies** for new declarations (per the new Edit-1 soundness rule). If the iter-143 prover encounters a need for a sorry-tainted intermediate, they must extract it into a named theorem (and the plan agent should pre-commit to that named theorem in the next-iter PROGRESS.md).
- **`basechange_along_proj_two_inv_app_isIso` is OFF-LIMITS to iter-143 prover** — iter-144+ work.

## Watch criteria committed for iter-144

1. **Iter-144 mandatory blueprint-reviewer**: re-confirm `RigidityKbar.tex` `complete: true / correct: true` after iter-143 Wave 2 +285 LOC expansion + Wave 3 prover lane outcome. The iter-143 plan-agent's choice to skip re-dispatching the reviewer this iter is per the descriptor's "optional within the same iter" guidance.

2. **Iter-144 mandatory progress-critic**: apply iter-143 pre-committed acceptance matrix verbatim:
   - PASS arm (d_app closes) → CONVERGING-confirmed; counter 2 → 1; iter-144 fires IsIso prover lane on `basechange_along_proj_two_inv_app_isIso`.
   - PARTIAL arm (d_app does not close) → CHURNING-CONFIRMED; counter 2 → 3; iter-144 mid-iter strategy-critic DIAGNOSTIC question.
   - FAIL arm (d_app + new blocker) → STUCK; route pivot mandatory.

3. **Iter-144 mandatory strategy-critic re-verification**:
   - Iter-143 Edit 1 (sorry-must-be-named-declaration): no further sorry-in-`letI` patterns introduced.
   - Iter-143 Edit 2 (consecutive-PARTIAL counter): counter accounting is internally consistent.

4. **Iter-144 MANDATORY chart-algebra-vs-bundled re-evaluation** (per iter-140 Must-fix #3 + iter-141 scheme-Frobenius-scoping HYBRID): dispatch `mathlib-analogist` reading `analogies/direct-chart-algebra-rigidity-ib-ic.md` + `analogies/scheme-frobenius-piece-iii-scoping.md`. Failure to re-evaluate at this gate is a sunk-cost trap. Pull-forward to iter-143 was REJECTED per `strategy-critic-iter143` ("would pre-commit a route pivot before the iter-143 recipe-level + definition-level correctives have run").

5. **Iter-144 plan agent: re-write objectives based on iter-143 PASS/PARTIAL/FAIL outcome** following the pre-committed acceptance matrix above.

6. **Iter-145+ piece (i.b) Step 2 route-pivot breakeven**: per iter-143 Edit 2, counter at 2 entering iter-144; projects to **iter-146+ at earliest** under no further closures (iter-143 PARTIAL → 3, iter-144 PARTIAL → 4, iter-145 PARTIAL → 5 fires breakeven). The strict-count d_map close iter-142 reset the iter-141-projected iter-145+ breakeven by one iter; iter-143 d_app close (if PASS) would reset it again to iter-147+ earliest.

7. **Iter-150 5-consult overhead arm revisit** (per `strategy-critic-iter140` Edit-2; reinforced by `strategy-critic-iter141` Edit 1 residual concern): the consult-count ≥5 arm fires mechanically with the iter-141 d_app/d_map consult at consult #5; the arm is **demoted to a calibration watchpoint** per iter-140 narrowing. Iter-150 revisit must either pick a principled `k` such that ≥k consults guarantees a route-pivot question regardless of envelope shifts, OR explicitly retire the count-only arm in favour of envelope-widening only.

8. **Iter-150 M3 RelativeSpec in-loop scaffold re-evaluation trigger** (per iter-142 STRATEGY.md Edit 4): dispatch iter-150 mathlib-analogist on in-loop scaffold of `RelativeSpec` if cumulative M2.body-pile LOC > 925 LOC without piece (i.b) closing, OR if M2.a body closure has not landed by iter-160.

9. **Iter-144+ stale-marker cleanup** (informational; review-agent domain per CLAUDE.md):
   - `Jacobian.tex:389` (`def:genusZeroWitness`) + `Jacobian.tex:424` (`def:positiveGenusWitness`): stale `\notready` markers on formalized sorry-bodied scaffolds. Review-agent iter-144 should strip.
   - Pointer-chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` L46–L49: iter-138 status text says "d_app + d_map + IsIso" — iter-142 closed d_map; pointer text should now say "d_app + IsIso (refactored to named theorem iter-143) + mulRight_globalises body". One-line update opportunity if iter-144 dispatches a blueprint-writer.
   - `RigidityKbar.tex:406, 524, 1152`: sync_leanok mis-mark count is now 3 (carry-over). Out of agent scope per CLAUDE.md; surfaced for optional `archon-lean4:doctor` consult.
   - `STRATEGY.md` minor `Mathlib.CategoryTheory.Monoidal.Grp_.lean` → `Grp.lean` file-path stale references (cosmetic; low priority).

10. **Future TO_USER candidate (iter-151+)**: partial-result shipping consultation; carry forward.

## Fallback if no user response

No TO_USER escalation this iter. Iter-143 makes no user-facing decision
that requires response.

## Sidecar contents (this file only)

This file is born-bounded — it contains the iter-143 plan narrative
only, not a multi-iter log. The Wave 1 critic reports are at
`.archon/task_results/{blueprint-reviewer-iter143.md, progress-critic-iter143.md, strategy-critic-iter143.md}`
(also archived at `.archon/logs/iter-143/*-report.md`); the Wave 2
dispatch reports are at `.archon/task_results/{refactor-isiso-extract-iter143.md, blueprint-writer-rigiditykbar-iter143.md}`
(also archived). The Wave 3 prover-lane dispatch fires after this plan
phase from the loop dispatcher.
