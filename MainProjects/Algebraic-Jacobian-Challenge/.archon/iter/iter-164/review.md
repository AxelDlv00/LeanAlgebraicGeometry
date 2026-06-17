# Iter-164 (Archon canonical) — review

## Outcome at a glance
- **The "base-case route RESOLVED + no-regret hygiene" iter.** The plan phase resolved a multi-iter
  misconception (`ℙ¹ → A` constant was thought to need Milne Thm 3.2 / theorem of the cube /
  Auslander–Buchsbaum / `Hom(𝔾ₐ, A) = 0`) and committed the **𝔾ₘ-scaling shortcut** as the
  primary proof of `prop:morphism_P1_to_AV_constant`. Three plan-phase consults landed it:
  mathlib-analogist `thm32-extend`, strategy-critic `basecase-reopen → CHALLENGE` (the circularity
  was illusory — conflated the base case with Milne's general Thm 3.4), and the writer's
  scaling-shortcut finding. The blueprint was rewritten (2 writer passes) and re-cleared the HARD
  GATE via `avr-fastpath2`.
- The prover lane was a hygiene-only round on `AbelianVarietyRigidity.lean`: docstring refresh +
  unused-instance drop. **Dispatch MATCHED the plan — 7th consecutive iter** with no plan/dispatch
  contradiction.
- **Global bare-sorry 6 → 6 (unchanged, by design).** Unit of progress is route correction, not
  sorry-count reduction. Per-file inventory unchanged: AVR L927/951/976 (3 deferred genus-0
  scaffolds), `Jacobian.lean` L265/L303, `RigidityKbar.lean` L88. No new `axiom`; no protected
  signature touched; `lake env lean AVR.lean` → exit 0.

## The advance, independently verified
1. **Routes that are GONE from the genus-0 critical path** (struck from STRATEGY.md, demoted off
   the prover queue): theorem of the cube; Milne Thm 3.2 / Lemma 3.3 / Auslander–Buchsbaum; the
   `Hom(𝔾ₐ, A) = 0` / 𝔾ₐ-additive route. None blocks `morphism_P1_to_grpScheme_const` under the
   committed scaling shortcut. Thm 3.2's codim-1 half is retained as a Route-A scaffold for the
   Albanese UP, not a genus-0 prerequisite.
2. **`morphism_P1_to_grpScheme_const` docstring (L909–926)** — rewrote to describe the scaling
   shortcut: σ_× : ℙ¹ × 𝔾ₘ ⟶ ℙ¹ fixes 0, Cor 1.5 applied with `V = ℙ¹` proper, `W = 𝔾ₘ` (base
   points 0, 1) collapses the W-axis at the fixed point, giving `f(λx) = f(x)`; at `x = 1`,
   `f|_𝔾ₘ` is constant; density + `A` separated (`ext_of_eqOnOpen`, proven) force `f` constant.
   Char-general. Body stays `sorry` pending the concrete ℙ¹/𝔾ₘ/σ_× infra (iter-165).
3. **Cor 1.5 / Cor 1.2 signatures lightened.** Dropped A-side `[Smooth A.hom]` and
   `[GeometricallyIrreducible A.hom]` from `hom_additive_decomp_of_rigidity`; dropped knock-on
   B-side from `av_regularMap_isHom_of_zero`. `lean_verify` re-confirmed both axiom-clean
   (`{propext, Classical.choice, Quot.sound}`). Both lemmas now require only `[GrpObj _]
   [IsProper _.hom]` on the target — strictly more general than the blueprint prose ("Let A be
   an abelian variety"). The checker (this review) confirmed the chapter remains correct under
   the wider Lean signature and that the existing NOTE blocks already authorize this pattern.

## Is this iter-157 laundering again? No.
Explicitly checked. `_hf` / base-point hypotheses are genuinely consumed across the chain
(`rigidity_eqOn_dense_open` L580–591 via `hcomp`/`hfx`; `hom_additive_decomp_of_rigidity` `hh` in
`hvf`/`hwg` L844–845; `av_regularMap_isHom_of_zero` `hα` directly in `one_hom := hα` L907). No
`sorryAx` propagation through any apparently-closed proof. The 3 remaining `sorry`s are
declared scaffolds with `**Status**:` markers in their docstrings.

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix introduced)
| Subagent | Slug | mf / maj / min | Headline |
|---|---|---|---|
| `lean-auditor` | iter164 | 0 / 5 / 3 | iter-164's two-spot hygiene edit is sound; AVR file is clean. 5 majors are STALE-NARRATIVE DEBT in 4 fallback-route files: `Cotangent/GrpObj.lean:297-327` (announces excised iter-145 plan), `Cotangent/GrpObj.lean:428-525` (Step-2/excised helpers), `Cotangent/ChartAlgebra.lean:36-79` (iter-144 chart-algebra pivot framed as live, demoted to off-path iter-156+), `RigidityKbar.lean:20-29,70-74` (now-fallback artifact still framed as "the keystone classical input"), `Jacobian.lean:237-263` (3-gate IMPORT CYCLE / CHAR-`p` / BASE-CHANGE analysis partially superseded). The minors: 1 stale "this `sorry`" comment in AVR L462-463 + 1 pre-existing dead-instance hyp on source A-side of `av_regularMap_isHom_of_zero` (lean-auditor minor follow-up, not introduced this iter) + 1 stale `Jacobian.lean:29` header reference. |
| `lean-vs-blueprint-checker` | avr-iter164 | 0 (regression) / 0 / 3 | iter-164 edits faithful, sound; instance generalization is documented as Lean strictly more general than blueprint prose (sound); no laundering, no axiom introductions, no protected-signature touches. 3 pre-existing scaffold `sorry`s flagged by the strict severity rules but **explicitly classified as not regressions** by the checker. Recommended NOTE amendments on Cor 1.5 / Cor 1.2 — **applied this review**. |

Reports: `logs/iter-164/{lean-auditor-iter164,lean-vs-blueprint-checker-avr-iter164}-report.md`.

## Actions taken this review
- Added `% NOTE: (iter-164 review)` to `lem:hom_additivity_over_product` documenting the A-side
  `[Smooth A.hom]` / `[GeometricallyIrreducible A.hom]` drop (Lean strictly more general than the
  prose; axiom-clean preserved).
- Added `% NOTE: (iter-164 review)` to `lem:av_regular_map_is_hom` documenting the B-side drop +
  the lean-auditor's pending source-A-side cleanup follow-up.
- Did NOT touch any `\leanok`. Wrote journal (summary / milestones / recommendations).
- Updated PROJECT_STATUS.md Last Updated with a bounded iter-164 entry (no Knowledge Base entry
  added — no new proof patterns landed).
- TO_USER.md banner: route resolution decision + iter-165 next step.
- Memory: refreshed with iter-164's route resolution + sorry landscape.

## For the next plan agent (see recommendations.md)
1. **HIGH** — Convert iter-164's route correction into depth. Dispatch the api-alignment
   consult FIRST (mathlib-analogist proactive trigger on concrete ℙ¹/𝔾ₘ/σ_× idiom); then
   scaffold + prove the scaling shortcut. Another hygiene round would CHURN per the iter-164
   progress-critic verdict.
2. **HIGH** — Confirm the `sync_leanok` keyword-stripping fix from iter-164's `.debug-feedback`
   report (was the iter-163 CRITICAL recommendation; persistent false `\leanok` on the 3 genus-0
   scaffold props).
3. **MEDIUM** — Single stale-narrative purge pass on the 4 fallback-route files before debt
   accumulates further. Each file's code is sound; only the "live work plan" framing is stale.

## Subagent skips
- (none) — both highly-recommended review subagents dispatched (`lean-auditor`,
  `lean-vs-blueprint-checker`).
