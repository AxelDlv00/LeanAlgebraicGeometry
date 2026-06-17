# Iter-218 (Archon canonical) — review

## Outcome at a glance

- **The "predicted INCOMPLETE-gate landing" iter.** iter-217 broke a 6-iter stall by closing the
  substrate linchpin `tensorObj_restrict_iso` (81→80). iter-218 pushed the next critical-path step
  — the ⊗-dual `exists_tensorObj_inverse` (PRIMARY) — and it **hit the pre-committed INCOMPLETE gate**:
  genuinely Mathlib-absent infrastructure (no `SheafOfModules`-level internal-hom/dual/eval at
  `b80f227`), blocked at step 1 (cannot even name `Linv`). This is exactly the cheapest-reversal-signal
  the iter-218 planner wrote ("INCOMPLETE citing a Mathlib-absent primitive ⇒ run a mathlib-analogist
  round, don't re-prove"). Not a surprise stall — a planned probe that returned its disconfirming answer.

- **Sorry trajectory:** iter-217 **80** → iter-218 **80** (net **0**). TS-file code sorries **3 → 3**
  (no new sorries; the only Lean edits were docstring/comment corrections + an in-code blocker note).

- **Build GREEN; 0 `axiom` decls; blueprint-doctor clean.** The two iter-217 `\leanok`-inside-`\uses{}`
  corruptions are RESOLVED (writer ts218 reflowed them; doctor now reports no broken cross-refs).
  `sync_leanok` ran (iter-218, sha `101077e7`, +0/−6).

- **HARD-BAR landing:** the assigned PRIMARY (close `exists_tensorObj_inverse`, 80→79) is **NOT met**;
  the bonus SECONDARY (assoc re-route + vestigial deletion) is also blocked. But the iter produced the
  decisive forward knowledge it was designed to: the exact missing primitive is named and decomposed
  (`informal/exists_tensorObj_inverse.md`), and both review subagents independently confirmed that the
  lane now bottoms out on **two Mathlib-absent infrastructure families**, not on proof search.

## The two findings the iter-219 planner must internalize

1. **The Lane-TS critical path is now infrastructure-bound, on two fronts.**
   - **(A) object-level** internal-hom/dual + evaluation for `SheafOfModules` — blocks the inverse,
     hence the iso-class `CommGroup`, hence `addCommGroup_via_tensorObj` (the RPF consumer).
   - **(B) morphism-level** descent (glue local isos into a global one) / stalk-⊗ d.2 — blocks the
     assoc re-route, the vestigial-deletion −1, and closing L632.
   Neither is a proof-fill task. Re-dispatching `prove` on either sorry is guaranteed churn — the
   recommendations explicitly forbid it. The next move is the progress-critic-scheduled
   **mathlib-analogist** (api-alignment) on primitive (A), passing `informal/exists_tensorObj_inverse.md`.

2. **`tensorObj_assoc_iso` is NOT axiom-clean** — corrected by BOTH review subagents. It has no literal
   `sorry` but transitively depends on the L632 `isLocallyInjective_whiskerLeft_of_W` sorry through the
   live `W_whiskerLeft/Right_of_W` chain. The iter-214 "associator ASSEMBLED, no sorry in body" framing
   obscured this; the existence-of-associator the group law consumes is still gated on L632. Treat the
   associator as not-yet-closed for planning purposes.

## Process correctness

- **The gate worked as designed.** This is the second consecutive iter where a pre-committed reversal
  signal fired and was answered honestly (iter-216 make-or-break NEGATIVE; iter-218 INCOMPLETE gate).
  The prover did NOT push a forbidden `dual`-shaped helper-sorry (the iter-214 d.1 anti-pattern it was
  warned against) and instead produced a source-derived blocker report. Honest non-progress, correctly
  gated, is the right outcome here.

- **One planner gap to note (not a fault, a watch):** the iter-218 plan recorded an environment caveat
  — the HARD-GATE fast-path blueprint-reviewer (ts218fp) verdict had not surfaced when objectives were
  set, and the planner proceeded on the reasoned grounds that the must-fix items were mechanical
  dependency-graph fixes. The review-phase backstop (this lvb ts218 dispatch) confirms the chapter is
  structurally sound for 10/14 pinned groups, BUT surfaces a NEW blueprint MUST-FIX the fast-path did
  not catch: `lem:tensorobj_inverse_invertible`'s proof prose describes the dual construction as
  executable while it is infrastructure-blocked. I added a `% NOTE` flagging it; the iter-219 planner
  must dispatch a writer to rewrite that prose (the HARD GATE will re-flag the chapter until then).

- **Strategy-critic skipped iter-217 AND iter-218** on "intra-route bookkeeping" grounds. That was
  defensible while the work was "close the inverse." It is no longer: the route's character has shifted
  to "fund a Mathlib internal-hom/descent build." Once the analogist returns an infra-cost estimate,
  **re-dispatch strategy-critic** and weigh it against the standing (unresolved) USER RR-fork.

## Review-phase subagents
- **lean-auditor ts218** — 3 must-fix (the 3 sorries, all load-bearing, accurately documented), 6 major
  (stale docstrings `tensorObjOnProduct`/`tensorObj_assoc_iso`/module-header; `@[implicit_reducible]`-
  over-sorry hygiene; two confirmed dead-code clusters), 2 minor. Critically: the closed-work docstrings
  (L990/L1005) and the inverse blocker comment are ACCURATE — no laundering. Report:
  `task_results/lean-auditor-ts218.md`.
- **lean-vs-blueprint-checker ts218** — 2 must-fix (the inverse-prose adequacy failure; + the
  whiskering route), 3 major, 3 minor. Report: `task_results/lean-vs-blueprint-checker-ts218.md`.
- Both confirmed the `tensorObj_assoc_iso` transitive-sorry fact independently.

## Subagent skips
(none — both highly-recommended review subagents dispatched; one `.lean` file received prover edits.)
