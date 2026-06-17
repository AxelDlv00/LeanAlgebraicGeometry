# Recommendations — for the iter-163 plan agent

## 0. Headline: the Rigidity-Lemma chain is CLOSED — do NOT re-open it
`rigidity_lemma` and its entire dependency cone (`rigidity_core`, `rigidity_eqOn_dense_open`,
`rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqAt_closedPoint_of_proper_into_affine`,
`morphism_eq_of_eqAt_closedPoints`, `eq_comp_of_isAffine_of_properIntegral`, `isIntegral_of_retract`,
`snd_left_isClosedMap`, `rigidity_snd_lift`) are **sorry-free and axiom-clean**
(`{propext, Classical.choice, Quot.sound}`, independently re-verified). No prover lane on AVR's chain
is warranted. The route-independent Rigidity-Lemma infrastructure (Milne Cor 1.5 additivity) that
Route A's Albanese UP needs is now in place.

## 1. HIGH — proof-block `\leanok` laundering on the 3 deferred scaffold nodes (sync-owned; surface to user/developer)
The blueprint proof blocks of `prop:morphism_P1_to_AV_constant` (tex ~666), `prop:genusZero_curve_iso_P1`
(tex ~742), and `thm:rigidity_genus0_curve_to_AV` (tex ~802) carry **proof-level `\leanok`** while
their Lean bodies are `:= sorry` (`morphism_P1_to_grpScheme_const` L804, `genusZero_curve_iso_P1` L828,
`rigidity_genus0_curve_to_grpScheme` L857). Worse: `prop:morphism_P1_to_AV_constant`'s proof
`\uses{thm:theorem_of_the_cube}`, so the dependency graph renders the **entirely-unbuilt theorem of
the cube as PROVEN** — a false-progress signal that could mislead the base-case route decision (item 2).
- This is **recurring** (flagged iter-157 L184/260/320, iter-160 AVR.tex:340, now iter-162). No
  marker-sync log exists under `logs/iter-162/`. Strong signal of a persistent `sync_leanok` defect:
  it is not stripping proof-`\leanok` from `:= sorry` declarations.
- `\leanok` is NOT the review agent's domain (cannot edit). **Action for the plan agent:** confirm the
  `sync_leanok` phase is actually running and stripping these; if it ran and they survived, escalate to
  the developer as a sync defect. Do NOT trust the blueprint dependency graph's "proven" status for the
  cube/RR/headline nodes when weighing the base-case route.

## 2. BINDING (carried from iter-162 plan) — genus-0 base-case route decision
The iter-162 plan re-opened `ℙ¹→A const` among (c-cube)/(c-hybrid: cube-free df=0-on-ℙ¹+Frobenius)/(b:
via Pic⁰) after the OVER_BUDGET re-estimate (~18–32 iters, cube ~8–15 + RR ~5–10, both unstarted). The
gating verification is **whether the theorem of the cube is actually on Route A's mandatory Albanese-UP
path (Milne §III.6, Prop 6.1/6.4)** — read the source before committing the cube blueprint. This is the
binding iter-163 task; it is now fully decoupled from the (closed) Rigidity-Lemma chain.
- Do NOT start a cube blueprint until that read confirms the cube is on Route A's path. (Per the
  iter-162 plan Decision (C) override of the progress-critic's "parallelize cube kickoff now".)
- Beware item 1: the blueprint graph currently (falsely) shows the cube as proven — do not let that
  laundered marker substitute for the actual Milne §III.6 verification.

## 3. MEDIUM — stale `.lean` docstrings / comments overstating residual `sorry`s (prover/refactor cleanup)
The lean-auditor flagged 10 majors, all stale status comments (none affect soundness):
- **AVR** (7): module docstring (L29-31), `rigidity_eqAt_closedPoint_of_proper_into_affine` docstring
  still reads "Status (iter-160): `sorry`" (L255-257), `rigidity_eqOn_saturated_open_to_affine`
  (L408-411), inline "this `sorry` … left for the prover phase" above the now-proven `JacobsonSpace`
  `haveI` (L458), `rigidity_eqOn_dense_open` (L485-486), `rigidity_core` (L643-645, L669-672),
  `rigidity_lemma` (L757-759) — all still call the closed Step 1 "the lone residual `sorry`".
- **`Cotangent/GrpObj.lean`** (3, pre-existing, flagged since iter-145/155): `shearMulRight` docstring
  L346 tagged `NEEDS_MATHLIB_GAP_FILL` on a fully-proven decl; orphaned section doc-blocks L428-451 +
  L465-525 describe iter-145-EXCISED declarations.
These are `.lean` comments → prover/refactor domain (review cannot edit). Recommend a single cheap
docstring-refresh pass (no proof work). Low-priority but they actively mislead readers/agents.

## 4. MEDIUM — blueprint prose refresh for `AbelianVarietyRigidity.tex` (blueprint-writer)
Two items, both routed to a blueprint-writer (review added `% NOTE`s flagging both but prose rewrite is
the writer's domain):
- **`lem:isIntegral_of_retract_of_integral` reduced-half (tex ~537-541):** the prose argues reducedness
  via global-sections split-injectivity, which is **mathematically insufficient** (reducedness is local).
  The Lean correctly proves it per-stalk. Align the prose to the stalk route (or note global-sections is
  insufficient).
- **Stale "single genuinely-deep residual `sorry`" prose** (tex ~176 decomposition remark, ~338, ~410,
  ~592): refresh to "Step 1 proven; Rigidity-Lemma chain closed & axiom-clean (iter-162)".

## 5. Reusable proof patterns landed (now in PROJECT_STATUS Knowledge Base)
- **Slice/retract identities over a monoidal `Over (Spec k̄)`: lift to `Over.homMk` + `CartesianMonoidalCategory.hom_ext`, NOT scheme-level `pullback.hom_ext`** (which fails on the defeq-not-syntactic middle-object mismatch). The keystone technique that closed Step 1.
- **`isIntegral_of_retract`** (generic retract-of-integral-is-integral) — reducedness PER-STALK with the `haveI hstalk : ∀ x, …` instance-arg pin + the `inferInstanceAs (IsIso (… ≫ 𝟙 _))` shape-hint.

## Do NOT
- Do not re-assign any AVR chain lemma to a prover (all closed).
- Do not start the cube blueprint before the Milne §III.6 gating read (item 2).
- Do not trust the blueprint's "proven" status on `prop:morphism_P1_to_AV_constant` /
  `prop:genusZero_curve_iso_P1` / `thm:rigidity_genus0_curve_to_AV` until item 1's `\leanok` laundering
  is resolved.
