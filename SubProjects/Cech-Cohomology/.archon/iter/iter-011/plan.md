# Iter-011 plan — P3b realigned to bypass two expensive bricks; file-split; two parallel mathlib-build lanes

## Context entering the iter
P4 closed (iter-009). iter-010 caught + repaired a circular P3b blueprint. Entering iter-011 the
consolidated Čech chapter had been bridge-repaired and an `injcech-recheck` had cleared it; the
leandag frontier was the Čech side. The plan from iter-010 called for: re-confirm the gate, effort-break
`injective_cech_acyclic`, file-split for parallelism, then dispatch P3 + the bridge.

## What I found / did, in order

1. **Processed the in-progress iter-011 subagent state.** The session had already run
   blueprint-reviewer (`iter011` → must-fix: `injective_cech_acyclic` referenced undeclared presheaf
   sub-lemmas), strategy-critic (`iter011` → SOUND, format DRIFTED), blueprint-writer (`injcech`, added
   the sub-lemmas) + clean + `injcech-recheck` (CLEARED), and a mathlib-analogist (`p3b-presheafcech`).
   I read all of these.

2. **Acted on the strategy-critic format must-fix**: tightened STRATEGY.md table cells (bare status
   tags, one-line cells). The flagged iter-009 narrative phrase was already gone in the current file.

3. **The analogist finding changed the plan (STRATEGY-MODIFYING).** `p3b-presheafcech` (api-alignment)
   showed the freshly-cleared P3b machinery was (a) mis-aligned — it would author a bespoke `j_!`
   duplicating Mathlib's `PresheafOfModules.free`; (b) over-engineered — `injective_cech_acyclic` was
   routed through presheaf enough-injectives + a Čech δ-functor universality, BOTH Mathlib-absent and
   expensive (no `IsGrothendieckAbelian (PresheafOfModules)`, no functor-category transfer, no AB5,
   `rightDerived` gated on enough-injectives). The direct Stacks route (`lemma-injective-trivial-cech`)
   bypasses both: injective sheaf ⟹ injective presheaf via `Injective.injective_of_adjoint`
   (`sheafificationAdjunction`); then `Hom(-,I)` exact on the free-presheaf resolution gives the
   vanishing. The api-alignment "ALIGN WITH MATHLIB" verdict is a refactor obligation, not a suggestion
   — so I treated this as a must-fix-before-prover, NOT something to send a prover into.

4. **Realigned the blueprint** (blueprint-writer `p3b-realign` → blueprint-clean `p3b-realign` →
   blueprint-reviewer `p3b-realign-recheck`): rewrote `cechFreePresheafComplex` as `free(yoneda)`
   (no `j_!`), added `def:section_cech_complex` (distinct from the relative `CechComplex`), restated
   `cechComplex_hom_identification`, rewrote `injective_cech_acyclic` to the direct route, added 2
   `\mathlibok` anchors (`injective_of_adjoint`, `sheafificationAdjunction`), and REMOVED 4 off-path
   blocks. Recheck: **HARD GATE CLEARS for P3 and the P3b machinery**; one residual must-fix (a stale
   δ-functor sentence in the P5a `higher_direct_image_presheaf` proof) I fixed myself in-place.

5. **Executed the file-split** (standing directive; lean-scaffolder `p3-split` + `p3b-skeleton`):
   `CechAcyclic.lean` (P3 re-signed to the spanning bundle) + `PresheafCech.lean` (P3b roadmap
   skeleton), both under one `% archon:covers`; frozen `cech_computes_higherDirectImage` kept in place.
   Full `lake build` GREEN; blueprint-doctor clean (`covers_problems: []`).

6. **Captured the P5a design for next iter** (analogist `p5a-01xj`, NEEDS_GAP_FILL): the four P5a
   lemmas funnel into the P4 acyclic-resolution engine; reuse sheafification-preserves-(co)limits +
   `PreservesInjectiveObjects`; avoid a bespoke module-valued cohomology (fork risk). Persistent
   `analogies/p5a-01xj.md`. Its blueprint realign + scaffold is next iter (a third parallel lane, since
   the 01XJ leaf is P3/P3b-independent).

## Decision made

### D1 — Dispatch TWO parallel mathlib-build lanes this iter (P3 + P3b), not one.
Both are blueprint-gated complete+correct (recheck), both have compiling files, both have a precise
Mathlib-aligned recipe (`p3-localisation.md`, `p3b-presheafcech.md`). `mathlib-build` is the right mode
for both: each needs from-scratch infrastructure built (P3: L1/L3 around the native `exact_of_isLocalized_span`;
P3b: the whole presheaf-Čech chain on native `PresheafOfModules.free`/`sheafificationAdjunction`), not a
recipe-of-existing-lemmas one-shot. This honors the standing parallelism directive without sending a
prover at a mis-aligned blueprint. **Reversal signal**: if the P3b lane returns "blocked at
`cechFreePresheafComplex` because `ChainComplex X.PresheafOfModules` / `free(yoneda)` won't assemble",
that is the first genuinely novel block — effort-break it (sentence-level) before re-dispatch rather than
re-running the same lane.

### D2 — Defer the P5a/01XJ lane one iter (realign its blueprint first).
The P5a analogist returned this iter; its blueprint still describes the obsolete δ-functor route. Sending
a prover before realigning would repeat exactly the mistake D1 avoided. Cheapest path: realign next iter,
then open the (independent) 01XJ lane.

## Subagent skips
- progress-critic: the prior iter (iter-010) ran NO prover phase (plan-only transition iter) — there is
  no new prover trajectory to assess. The two lanes dispatched this iter are a fresh route (first prover
  contact for the Čech side), so there is nothing to extrapolate from yet. Matches the descriptor's
  "prior iter ran no prover phase" skip condition.

## Open items for next planner
- The P3b lane is the project's hardest from-scratch infrastructure (floor ≥ P4's 965 LOC across a
  multi-lemma chain). Expect multiple iters; watch for the `cechFreePresheafComplex` assembly being the
  real bottleneck (effort-break if so).
- `ses_cech_h1`, `cech_eq_cohomology_of_basis`, `affine_serre_vanishing` still live in the consolidated
  chapter, not yet scaffolded — open them after `injective_cech_acyclic` lands.
- Remaining file-split: `HigherDirectImagePresheaf.lean` (01XJ + P5a inputs) + trimming
  `CechHigherDirectImage.lean` to P1/P2 + P5b.
