# Iter 017 — Plan (Quot-Foundations)

## TL;DR

**Resumed after a mid-plan context reset** (like iters 009/012/015). The prior partial run had already:
processed the iter-016 prover results (FBC `pullbackPushforward_unit_comp` + GF
`free_localizationAway_of_away_tower`, both landed axiom-clean), dispatched **progress-critic
`iter017`** (FBC CHURNING, GF CONVERGING, QUOT UNCLEAR), and run the FBC blueprint round
(**blueprint-writer `fbc-seams2`** → **blueprint-clean `fbc-iter017`** → **blueprint-reviewer
`fbc-fastpath`**) which cleared the HARD GATE on the Seam-2/Seam-3 refactor (FBC chapter complete+correct,
0 must-fix, all 3 iter-016 gaps resolved). On resume I (1) verified the build/sorry state and the FBC
gate clearance from the persisted reports; (2) refreshed the FBC-A `Iters left` estimate per the
progress-critic OVER_BUDGET must-fix; (3) dispatched **3 import-independent prover lanes** — FBC
fine-grained (the CHURNING refactor corrective), GF prove (defuse the OreLocalization diamond, close L5),
QUOT mathlib-build (first Route-2 dispatch). strategy-critic skipped with rationale.

## State at entry (iter-016 outcomes, verified)

- **FBC 4→4** — `pullbackPushforward_unit_comp` NEW + axiom-clean, wired into Seam 2 as `have key`; the
  Seam-2 `sorry` persists on the dependent-leg-transport restructure (legs in dependent positions block
  `rw`). Active sorries: 1248 (Seam2), 1293 (Seam3), 1466 (affine), 1488 (FBC-B).
- **GF 4→4** — `free_localizationAway_of_away_tower` CLOSED axiom-clean (witness `f := g·a`). L5
  `exists_free_localizationAway_polynomial` blocked ONLY on the OreLocalization instance-presentation
  diamond between the IH output and the helper input. Active sorries: 516 (L4), 1517 (L5), 1597
  (genericFlatnessAlgebraic), 1664 (genericFlatness, OOS).
- **QUOT 4→4** — no lane iter-016 (structural Route-2 pivot). 4 downstream stubs static (126/165/201/228).
- GR / RegroupHelper: DONE (0 sorry).

## Critic dispositions

- **progress-critic `iter017` — FBC CHURNING (must-fix), GF CONVERGING, QUOT UNCLEAR; dispatch=OK (3/10).**
  - FBC **CHURNING + OVER_BUDGET**: Seam-2 sorry static across iters 014–016; two different closed
    helpers added (iter-015 scaffold, iter-016 reindex engine) without dissolving the structural wall.
    Primary corrective = **Refactor**: abstract `base_change_mate_codomain_read` with the two legs as
    explicit subst-able variables, then `subst` + Seam 1 + `pullbackPushforward_unit_comp` + the
    `pushforwardComp` coherences. The critic explicitly confirms "the planner's proposed iter-017 FBC
    objective already names this action correctly" and "must not be replaced with another helper round."
    OVER_BUDGET: 6 iters in a phase estimated 1–3 remaining → refresh STRATEGY (done).
  - GF **CONVERGING** with a **critical watch**: the OreLocalization instance diamond has appeared in 2
    consecutive prover iters (015, 016) and is the SOLE L5 blocker; if iter-017 does not resolve the
    instance alignment, GF flips to STUCK at iter-018. The proposed GF objective targets exactly this.
  - QUOT **UNCLEAR**: 0 Route-2 prover iters; iter-017 is the first dispatch. Entry constraint reminder:
    the directive must prohibit ANY quotient/subtype graded decomposition, not just the G2–G4 form.
- **blueprint-reviewer `fbc-fastpath` — FBC HARD GATE CLEARS.** All 3 iter-016 gaps resolved:
  `lem:pullbackPushforward_unit_comp` pinned + 3 `\mathlibok` anchors + wired into Seam-2 `\uses`; Seam-2
  proof now gives the (i) abstract-variable-legs / (ii) Γ-collapse / (iii) Seam-1-reduce decomposition
  as named sub-lemmas; Seam-3 proof names `homEquiv_counit` + the composed-adjunction counit-triangle.
  leandag: `isolated: 0`, `unknown_uses: 0`. `lean_verify` on the helper axiom-clean.

## Decision made

### 1. FBC — fine-grained mode IS the CHURNING refactor corrective (not another helper round)
- **Why fine-grained, not a `refactor` subagent:** the blueprint now decomposes Seam 2 into exactly 3
  atomic named lemmas (i/ii/iii), each characterised as "extracts as a named lemma" — this is the
  textbook fine-grained trigger (complex theorem, sorry static ≥2 prover iters, blueprint now provides
  the atomic decomposition). fine-grained both CREATES the abstract-variable-legs `codomain_read` variant
  (step i — the structural refactor the critic demands) AND proves it + (ii)+(iii) in one iter. A
  `refactor` subagent would only insert the abstract def + sorry, costing an extra iter to fill — the
  autonomous-no-waste directive favours the one-iter fine-grained path. The directive explicitly forbids
  adding an opaque helper without the subst-able-legs restructure, which is the precise non-response the
  CHURNING verdict exists to catch. **The concrete CHURNING correctives taken this iter:** (a) the
  blueprint chapter was rewritten (blueprint-writer `fbc-seams2`) to specify the refactor as named
  lemmas; (b) the prover is dispatched on that structural restructure, not a reworded helper recipe.
- **Reversal signal:** if the fine-grained prover returns with the Seam-2 sorry still static AND no
  abstract `codomain_read` variant landed, escalate iter-018 to a dedicated `refactor` subagent that
  performs the def surgery, then a prover.

### 2. GF — close L5 by emitting canonical OreLocalization instances from gf_torsion_reindex
- The prover report pins the fix precisely: `gf_torsion_reindex`'s 6th existential component currently
  resolves to a `DistribMulAction`-wrapped `Module A_g T_g` rather than `OreLocalization.instModule`;
  emit the canonical instances (lines ~1245–1252) and rebuild `htower` consistently, OR restate `hfree`
  over the `CommRing.toCommSemiring`/`hmod2` presentation. This is structural-instance + proof work in
  one file — prove mode, the prover owns the file and can modify `gf_torsion_reindex`. CONVERGING, so no
  subagent obligation; the critical-watch trigger is defused by closing the diamond this iter.

### 3. QUOT — first Route-2 mathlib-build, with the hard no-quotient-grading constraint
- Route-2 (ambient subquotient induction) was decided iter-016 (mathlib-analogist; STRATEGY SOUND per
  strategy-critic `iter016`). The HARD GATE clears: iter-016 full reviewer gave Route-2 a conditional
  PASS (5 blocks complete+correct; sole finding = the unrelated `thm:grassmannian_representable` pin, far
  downstream), chapter unchanged since. mathlib-build mode creates the `GradedModule.*` chain
  axiom-clean. The entry constraint (no `DirectSum.Decomposition`/`IsInternal` on quotient/subtype
  carriers) is the documented `isDefEq` dead-end guard.

## Subagent skips

- **strategy-critic**: STRATEGY.md edited this iter ONLY to refresh the FBC-A `Iters left` (1–3 → 2–3)
  and Risks cells per the progress-critic OVER_BUDGET must-fix — no route swap, no phase split/merge, no
  decomposition change, no new Mathlib gap. iter-016 strategy-critic verdict was **SOUND** with all 4
  must-fix addressed and no live CHALLENGE. Re-running on substance-unchanged strategy would be a hollow
  dispatch (the exact failure the skip affordance exists to avoid).

## Tool substitutions

- None. `archon-informal-agent.py` remains unavailable (no LLM API key in env); not needed this iter
  (all three lanes have concrete in-blueprint / in-code recipes).

## Disproof / soundness checks

- None newly required. The three targets are not new statements: Seam 2 is a proved-modulo-restructure
  categorical identity (the engine `pullbackPushforward_unit_comp` is axiom-clean); L5's assembly is
  mathematically complete (blocked only on instance presentation, not truth); QUOT Route-2 soundness was
  checked against verbatim Stacks 00K1 by strategy-critic `iter016` ("cleaner-than-canonical").

## Gate / sequencing notes

- All 3 lanes are import-independent (each imports only Mathlib + own deps; the 3 files do not import
  one another), so they fan out in parallel with no blocked-deps filtering.
- Frontier coverage: the leandag-injected "ready" frontier listed `lem:gf_polynomial_core` /
  `lem:gf_noether_clear_denominators` (GF lane), `def:graded_subquotientHilb` (QUOT lane) — all
  dispatched. The remaining frontier-ready nodes (`def:sectionGradedRing`, `lem:qcoh_section_localization_basicOpen`,
  `def:gr_glued_scheme`) are deferred: their consumers are BLOCKED 6–12 iters out and their chapters need
  additional sub-builds (SheafOfModules monoidal / QCoh bridge) not yet written. Focusing budget on the
  3 live lanes over marginally-ready downstream nodes.
- Did NOT list `GrassmannianCells.lean` (0 sorry — the standing plan-validate warning; it is DONE).
