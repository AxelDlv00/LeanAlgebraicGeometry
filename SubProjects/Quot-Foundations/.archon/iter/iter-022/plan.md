# Iter 022 — Plan (Quot-Foundations)

## TL;DR

A **corrective-then-dispatch** iter. Entry: iter-021 closed the GF L4 finiteness leaf axiom-clean
(vindicating the iter-021 GF-STUCK→pivot rebuttal) and landed the FBC `gstar_transpose` route +
structure (PARTIAL). The progress-critic returned **GF CHURNING** + **FBC STUCK** — and named the
**same primary corrective for both**: a Mathlib analogy consult on the lane's load-bearing lemma
*before* any prover round. I executed that corrective via one `mathlib-analogist` dispatch
(`iter022-bridges`), which **confirmed both lemmas in current Mathlib with their precision traps**, then
dispatched the two converging frontier lanes with the verified recipes baked into the directives — not
reworded re-dispatches. Both verdicts are metric artifacts on genuinely-advancing routes; I rebut the
pivot readings explicitly below. Also fixed the GF-checker MAJOR (step-2 prose of the now-closed L4
lemma) myself, updated STRATEGY.md (GF-alg/FBC realism + SNAP-S2 keystone → Completed), and folded the
lean-auditor MF1 (stale @531 comment) into the GF prover objective.

## State at entry (iter-021 outcomes, verified)

- **GF 3→2 sorries** — L4 finiteness leaf `exists_localizationAway_finite_mvPolynomial` CLOSED
  axiom-clean (`g:=g0·g1` + `IsIntegral.exists_multiple_integral_of_isLocalization`).
  `genericFlatnessAlgebraic` B/𝔭 cascade @2021 PARTIAL — prover left a precise 4-step assembly route;
  the ONLY open gap is step (4), the ring↔module localisation bridge. GF-geo @2109 untouched.
- **FBC 4 sorries (live=1)** — `gstar_transpose` @1551 PARTIAL: 2-rw reframing isolated the two
  Γ-factors; route pinned to `conjugateEquiv_counit_symm` (dual of proven Seam-1); 3-step recipe left.
  Dead-code @1421 + deferred @1724/@1746 unchanged.
- Build GREEN all modules (iter-021 verified).

## Subagents dispatched (2; all returned)

- **progress-critic `iter022`** — GF **CHURNING** (sorry rate 3→3→3→2 below the 0.5/2-iter threshold; 4
  PARTIAL iters; OVER_BUDGET 8 elapsed vs 1–2 est) "but genuinely advancing — L4 closure iter-021 was
  real." FBC **STUCK** (sorry flat 4 across 4 iters, zero elimination; "partly an artefact of the
  dead-code @1421 sorry" inflating live-count 1→4; gstar crux ON_SCHEDULE, 1 attempt). Same primary
  corrective for both: Mathlib analogy consult before prover dispatch. Dispatch sanity OK (2 lanes).
- **mathlib-analogist `iter022-bridges`** (api-alignment; THE named corrective) — **BOTH lemmas
  CONFIRMED, both ALIGN_WITH_MATHLIB (no gap-fill):**
  - GF: `IsLocalizedModule.iso (Submonoid.powers g) (IsScalarTower.toAlgHom A C C_g).toLinearMap`
    gives `LocalizedModule (powers g) C ≃ₗ[A] Localization.Away (algebraMap A C g)` in one step
    (instance `instIsLocalizedModuleToLinearMapToAlgHom…` auto-supplied via `Submonoid.map_powers` +
    the `A→C→C_g` tower). Precision trap: `.iso` is A-linear; the descent consumer needs A_g-linearity →
    `LinearEquiv.extendScalarsOfIsLocalization`. → `analogies/gf-localizedmodule-localization-away-bridge.md`.
  - FBC: `conjugateEquiv_counit_symm` exists verbatim (`Mates.lean:287`, dual of `unit_conjugateEquiv_symm`
    the proven Seam-1 used); splitter `Adjunction.comp_counit_app` exists. Precision trap: `.symm α` is
    the `.inv` morphism (outer `.symm` in `pullback_spec_tilde_iso`'s def @696) — pin by `rfl` à la
    Seam-1 `hpullinv`. → `analogies/fbc-conjugateequiv-counit-symm.md`.

## Decision made

### Both CHURNING/STUCK verdicts honored via the named corrective; pivot readings rebutted

The protocol obliges a concrete corrective THIS iter (a dispatched subagent or structural edit, not a
reworded lane re-dispatch). I executed the critic's **explicitly named** corrective for BOTH routes — a
Mathlib analogy consult (the `mathlib-analogist` dispatch). The subsequent prover lanes are therefore
informed by a *Mathlib-confirmed lemma + a resolved direction/linearity trap* the prior attempts
lacked — this is the sanctioned "execute corrective, then dispatch on its finding" pattern, not "another
round of the same recipe."

I rebut only the STUCK/CHURNING → *pivot-the-route* implication, on these signals:

- **GF (CHURNING).** The critic itself states the route is "genuinely advancing": the @754 leaf stuck
  iters 018–020 closed axiom-clean iter-021, and the residual @2021 is pure §4-dévissage assembly. The
  CHURNING verdict fires on a mechanical sorry-rate rule over a 4-iter window that straddled the hard L4
  work — NOT a conceptual stall. With step (4) now Mathlib-confirmed one-step, there is a plausible
  single-iter close. Pivoting a route one assembly node from completion would be the actual waste.
- **FBC (STUCK).** The verdict is "partly an artefact of the dead-code @1421 sorry" (live-count is 1,
  not 4) and the 4-flat-window rule. The route swap iter-020 was a genuine structural advance; the new
  crux has had exactly ONE attempt and is ON_SCHEDULE (2 elapsed vs 2–3 est). The pinned lemma is now
  confirmed verbatim with its direction trap resolved. This is a textbook "first real attempt on a fresh
  confirmed route," not a stuck route needing a pivot.

**Secondary correctives addressed:**
- GF stale @531 comment (lean-auditor MF1 must-fix + critic secondary) → folded into the GF prover
  objective (planner can't edit `.lean`).
- FBC dead-code @1421 removal (critic secondary): **NOT folded into the prove lane** — removing those
  Lean decls is coupled to removing their 5 superseded blueprint blocks atomically, and interleaving
  that with the deep gstar prove in the *same file* risks the prove (the iter-021 deferral rationale
  still holds). Concretely **scheduled** for a dedicated FBC-no-prover refactor iter-023 (no longer
  vaguely "queued"). Count-inflation concern addressed by tracking the honest live-sorry count (1) in
  STRATEGY.md + PROGRESS.md.
- GF OVER_BUDGET: STRATEGY.md GF-alg/FBC-A rows now state the elapsed overrun explicitly and revise
  iters-left to credible values (GF 1 = final assembly node with confirmed API; FBC 2).

## Blueprint work (planner-domain)

- **GF chapter step-2 of `lem:gf_noether_clear_denominators`** (GF-checker MAJOR) — corrected the prose
  + `% NOTE` to describe the landed per-generator collapsing-lemma route
  (`IsIntegral.exists_multiple_integral_of_isLocalization`, `g1 := ∏ a_x`), not the per-coefficient
  `gf_clear_one_denominator` fold. This block is the now-CLOSED L4 lemma — a faithfulness fix, not a
  live prover target. (Pure informal-prose correction = planner domain.)
- The FBC-checker minor (`lem:base_change_mate_regroupEquiv` `\uses` divergence) needs a `% NOTE:`
  semantic annotation = **review agent's marker domain**, not mine — flagged in task_pending for review.

## Subagent skips

- **strategy-critic**: SKIP. STRATEGY.md edits this iter are bounded status updates only (GF-alg/FBC-A
  realism cells, SNAP-S2 keystone MOVED to Completed, two resolved/closed bullets pruned) — no route
  swap, no fork, no new phase, no decomposition change. The last meaningful strategy-critic (iter-016)
  governs the still-current decomposition; nothing it would re-examine has moved. Re-running it on
  unchanged routes is the hollow dispatch the skip affordance exists to avoid.
- **blueprint-reviewer**: SKIP. The only chapter edit this iter is the GF step-2 prose correction to the
  already-CLOSED L4 lemma `lem:gf_noether_clear_denominators` — NOT either live prover target
  (`thm:generic_flatness_algebraic`, `lem:base_change_mate_gstar_transpose`), whose blueprint is
  untouched. The iter-021 blueprint-reviewer PASSED the HARD GATE for both live targets; the iter-021
  GF/FBC lean-vs-blueprint-checkers reported must-fix:0 for both files. My edit does not degrade the
  live targets' completeness/correctness, so the gate stays satisfied. A whole-blueprint re-audit for
  one closed-lemma prose fix is the hollow dispatch the skip exists to avoid.
- **blueprint-clean**: SKIP. No new source material added; the single edit is a prose correction matching
  landed Lean (no Lean leakage, no missing quotes, no project-history verbosity introduced).

## Tool substitutions

None. `archon-informal-agent.py` not needed (no LLM key in env); the Mathlib existence/type questions
were answered by the in-catalog `mathlib-analogist` (the sanctioned equivalent).

## What shaped iter-023 (live frontiers)

1. **GF**: if the cascade closes, GF-alg is COMPLETE → open GF-geo `genericFlatness` (owes a
   finite-affine-cover blueprint section) + de-private the 11 GF Nagata helpers (M1 remainder).
2. **FBC**: if `gstar_transpose` closes, run the dedicated FBC-no-prover dead-code refactor
   (`fstar_reindex` apparatus + 5 superseded blueprint blocks, atomically), then affine @1724 → FBC-B.
3. **QUOT**: file-split done; QUOT-defs P2 + SNAP-S1 `def:sectionGradedRing` openable in parallel
   (each needs a sub-build + blueprint round) once GF/FBC budget frees.
