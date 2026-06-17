# Iter-217 (Archon canonical) — review

## Outcome at a glance

- **The "stall-breaker" iter.** After 6 consecutive net-zero window-iters (211–216) — each landing
  real axiom-clean bricks while the critical-path residual stayed a `sorry` — iter-217 **CLOSED the
  substrate linchpin `tensorObj_restrict_iso`** (`Picard/TensorObjSubstrate.lean:1259`). Project sorry
  **81 → 80**: the **first sorry elimination in 7 iters**.
- **The bet that paid off.** The iter-217 planner explicitly REBUTTED a `progress-critic` STUCK verdict
  ("H1 bottoms out, same churn as iter-214 d.1") on the strength of a `mathlib-analogist` on-disk
  de-risking (H1 buildable ~70-90 LOC, every sub-step present, `pullbackPushforwardAdjunction` already
  exists), and dispatched a **fine-grained** round structured to DROP the count, not add a helper. The
  rebuttal is now **vindicated**: the linchpin closed exactly per the analogist's recipe.
- **Build GREEN; axiom-clean.** `tensorObj_restrict_iso` `#print axioms` = `{propext,
  Classical.choice, Quot.sound}` — no `sorryAx`, no project axiom (review re-verified first-hand;
  same for `pushforwardPushforwardAdj` and `restrictScalarsMonoidalOfBijective`). The L1301 `lean_verify`
  "opaque" warning is the known docstring comment-scan false positive.
- **Two independent confirmations of genuineness.** lean-auditor ts217 (no `sorry`/`admit`/`native_decide`/
  axiom-weakening anywhere in the closure; all 5 new decls real) AND lean-vs-blueprint-checker ts217
  (exact 4-step blueprint match, no mathematical divergence).
- **Sorry trajectory:** iter-216 **81** → iter-217 **80** (net **−1**). TS-file code sorries **4 → 3**.
  `sync_leanok` ran (iter 217, sha `7d935493`), **+9 / −1**, `Picard_TensorObjSubstrate.tex` only.
- **HARD BAR landing:** the assigned target (build de-risked H1, close `tensorObj_restrict_iso`, drop
  81→80) is **MET**. The PRIMARY GOAL (A.2.c via the group law) is not reached but the path to it is now
  concrete and ungated (associator re-route → vestigial-sorry deletion → inverse → group law → RPF).

## What actually closed it (the math)

The blueprint's 4-step composite, all verified first-hand against the raw attempt log:
1. `restrictFunctorIsoPullback f` (Mathlib) — reduce `restrict` to the abstract pullback.
2. `SheafOfModules.sheafificationCompPullback` (Mathlib) — pullback inside sheafification.
3. `sheafification.mapIso` — strip outer sheafification → presheaf goal
   `(pullback φ).obj (M.val ⊗ₚ N.val) ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`.
4. **H1** (sole Mathlib-absent piece): three de-sheafified presheaf helpers (`pushforwardNatTrans`,
   `pushforwardCongr`, `pushforwardPushforwardAdj`) + `leftAdjointUniq` against the EXISTING
   `pullbackPushforwardAdjunction`. **H2**: `β` sectionwise-bijective ⇒ `restrictScalars β` strong
   monoidal (`restrictScalarsMonoidalOfBijective`) ⇒ `μIso` of the composite.

5 new reusable axiom-clean decls (3 upstream-PR candidates). Full recipe + the three load-bearing
gotchas (hand-rolled triangle lemma fails; `set`/`have` opacity breaks the `congr` defeq; local
`MonoidalCategory` on `ringCatSheaf.obj` ⇒ kernel-rejected diamond → build `μIso` over the syntactic
`⋙ forget₂` form and `exact` by defeq) are recorded in PROJECT_STATUS Knowledge Base + memory
`[[ts-assoc-flatness-gap]]` + `analogies/ts217.md`.

## The defining tension — was this "stall #7 with one more brick", or a genuine break?

The mechanical pattern matches the prior six iters (axiom-clean bricks land each time). The
distinction this iter is **the count actually moved, on the critical path**, and the residual that
moved was the named linchpin the whole window had been circling — not a side lemma. The
`progress-critic`'s STUCK signal was correct on the raw history but wrong on the forward technical
claim (H1 feasibility), and the planner's deeper-think gate (cheapest disconfirming consult before
funding the build) is exactly the process that caught it. **This is a clean instance of the loop's
self-correction working as designed**, not a lucky helper. The lane should be read as **CONVERGING**
going into iter-218.

Counterweight to keep honest: the closure ungates *concrete* next steps but the PRIMARY GOAL is still
several lemmas away (associator re-route, vestigial deletion, `exists_tensorObj_inverse`, the group
law, the RPF consumer), and two of those (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`)
are scaffold sorries that have carried "will fix in iter-203+/204+" excuse-comments since iter-202 and
have never been touched. The momentum is real but the group law is not yet in hand.

## Process findings the next planner must see

1. **`sync_leanok` corrupted the blueprint dependency graph.** It inserted `\leanok` INSIDE two
   multi-line `\uses{...}` blocks (tex ~L1377-79, ~L2044-46) — spurious proof markers on `sorry`
   bodies that break 7 dependency edges. Confirmed by blueprint-doctor + lvb ts217 + first-hand
   review. **MUST-FIX iter-218** (reflow the `\uses{}`; delete the stray `\leanok`). Review did NOT
   touch it — `\leanok` is sync's domain; the fix is a prose reflow for a blueprint-writer. This is a
   sync-script defect (offset collides with multi-line `\uses{}`) worth a maintainer guard.
2. **Docstring debt.** lean-auditor ts217: `tensorObj`/`tensorObj_functoriality` docstrings falsely
   claim "typed sorry" bodies; module Status block 15 iters stale; `assoc_iso` docstring says
   "iter-212 status (typed sorry)" but it's closed. Fold into the next prover directive.
3. **Soundness watch.** `@[implicit_reducible]` sits on the sorry-body `addCommGroup_via_tensorObj`
   (L1414). A `def` (not auto-synthesized) so bounded, but reducible-on-a-sorry should be closed or
   the attribute dropped until the body lands.
4. **17× deprecated `Sheaf.val`** — mechanical sweep owed.

## Subagent dispatches this iter
| Subagent | Slug | Verdict |
|---|---|---|
| lean-auditor | ts217 | Work GENUINE; `tensorObj_restrict_iso` axiom-clean, 5 new decls real, 0 errors. 3 must-fix (all PRE-EXISTING scaffold sorries: L600/L1375/L1415), 8 major (stale docstrings ×4, `@[implicit_reducible]`-on-sorry, deprecated `Sheaf.val` ×17), 7 minor. Report: `task_results/lean-auditor-ts217.md`. |
| lean-vs-blueprint-checker | ts217 | Closed proof = EXACT 4-step blueprint match, no divergence. 2 must-fix (the `\leanok`-in-`\uses` bugs), 4 major (5 new decls unpinned; prose/pin inconsistency). Report: `task_results/lean-vs-blueprint-checker-ts217.md`. |

(The auditor's 3 "must-fix" sorries are the project's known open obligations on this file — not
regressions from this iter's work; the next planner has them queued, not as new blockers.)

## Net
A genuine, independently-verified critical-path advance that breaks a 7-iter stall and demonstrates
the deeper-think gate doing its job. Knowledge Base + memory updated with the full reusable recipe.
The one real defect introduced this iter is mechanical (sync mis-placed `\leanok` in `\uses{}`) and is
flagged must-fix for iter-218.
