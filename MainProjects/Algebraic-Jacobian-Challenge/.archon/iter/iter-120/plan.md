# Iter-120 (Archon canonical) plan-agent run

## Headline outcome

Iter-119 returned PARTIAL on `smooth_locally_free_omega` with a real
**blueprint correctness defect** surfaced: the iter-118 Step-5 claim of
"definitional equality" between the project's presheaf-form section
module and the appLE algebra Kähler module is mathematically wrong at
the Lean level. The colimit ring
`A_colim := ((TopCat.Presheaf.pullback CommRingCat f.base).obj
  S.presheaf).obj (.op V)` is strictly larger than `Γ(S, U)` in
general, and `relativeDifferentialsPresheaf_obj_kaehler` lands the
section module against `Ω[B / A_colim]`, not `Ω[B / Γ(S, U)]`.

Iter-120 acts on this by:
1. **Refactoring the (non-protected) signature** of `smooth_locally_free_omega`
   to conclude on the appLE algebra Kähler module `Ω[Γ(X, V) ⁄ Γ(S, U)]`
   directly. Option (iii) per the iter-120 strategy-critic and
   mathlib-analogist (both ALIGN_WITH_MATHLIB / recommend this).
2. **Rewriting the blueprint chapter `Differentials.tex`** to match the
   new statement, removing the wrong "definitional equality" prose, and
   adding a new section `sec:bridge-out-of-scope` documenting the
   bridge as a Mathlib gap (with mathematical content captured but no
   Lean obligation).
3. **Fixing the broken `\ref{chap:Picard_Functor}` in `Jacobian.tex:6`**
   (must-fix from blueprint-reviewer-iter120, orthogonal to the
   prover lane but co-located).
4. **Scheduling the prover lane** against the new (simpler) signature.
   Expected COMPLETE in 1 prover iter via Steps 1–4.5 of the verified
   Mathlib chain.

**Expected sorry trajectory**: project 2 → 1 if the prover lane returns
COMPLETE. Remaining `sorry` would be `nonempty_jacobianWitness`,
putting the project in its declared end-state.

## What I consumed

- `task_results/AlgebraicJacobian_Differentials.lean.md` (iter-119
  prover report). Archived to `logs/iter-119/`. Cleared from
  `task_results/`.
- `USER_HINTS.md`: one substantive user hint —

  > I would like you to write complete blueprints for all the
  > components that you will need to build to achieve the end state.
  > This should allow you to ensure that there is no component that
  > may be blocking and that you did not think of.

  This iter acts on the hint via:
  - The blueprint-reviewer's whole-blueprint audit (finds 3 must-fix
    items including the Step-5 prose and the broken `\ref`).
  - The mathlib-analogist's design-decision audit
    (`analogies/cotangent-presheaf-design.md` is persistent for
    future iters; identifies no new latent risks beyond the
    already-cataloged ones).
  - The blueprint-writer's Differentials.tex rewrite (documenting
    the bridge as a Mathlib gap with a full mathematical proof
    sketch — the "completeness" criterion is met at the reasoning
    level, even though the iso is not formalized in Lean).
  - The blueprint-writer's Jacobian.tex cross-ref fix.

  USER_HINTS.md cleared after acting (header only).

- `STRATEGY.md`: read; **updated this iter** to reflect the Option
  (iii) Phase C path and the new Mathlib gap #3 (the bridge). The end-
  state framing is unchanged.
- `PROGRESS.md`: rewritten this iter for the iter-120 prover lane on
  the new signature.
- `task_pending.md` / `task_done.md`: read for sorry inventory +
  protected status. `task_pending.md` updated for iter-120 entry.
  `task_done.md` unchanged (no new closures yet — those are review
  phase's domain).
- `archon-protected.yaml`: unchanged. 9 protected declarations.
- `iter/iter-117/{plan,review}.md`, `iter/iter-118/{plan,review}.md`,
  `iter/iter-119/{plan,review}.md`: read for context (injected by the
  recent-iter window).
- `proof-journal/sessions/session_119/recommendations.md`: read for
  iter-120 action items (CRITICAL #1 = bridge-helper helper lemma
  Option (i), which we override in favor of Option (iii); CRITICAL #2
  = blueprint rewrite of Step 5; HIGH #3 = dead chain cleanup,
  deferred to polish stage).

The session_119 recommendation CRITICAL #1 (build the helper-lemma)
is **overridden** by this iter's plan-phase analysis: strategy-critic
and mathlib-analogist both recommend Option (iii) instead, and the
progress-critic CONVERGING verdict explicitly does not constrain the
choice between Option (i) and Option (iii).

## Critic verdicts this iter

### strategy-critic-iter120 — CHALLENGE on Phase C, SOUND on rest

3 routes audited:

- **Route "end-state with single hypothesis"**: SOUND. Three-route
  documentation honest, Mathlib gaps named accurately, no sunk-cost
  reasoning.
- **Route "iff → forward demotion"**: SOUND. Counterexample correct;
  honest correctness fix.
- **Route "Phase C closure via the 6-lemma chain + presheaf-form
  conclusion"**: **CHALLENGE**. STRATEGY.md L99 calls
  `relativeDifferentialsPresheaf_obj_kaehler` "definitional, body
  `rfl`" and claims this provides the bridge to `Ω[Γ(X,V)/Γ(S,U)]`;
  it does not. The `rfl` lands at `Ω[B/A_colim]` with
  `A_colim = colim_{W ⊇ f V₀} O_S(W)`, strictly larger than
  `Γ(S, U)`. Helper-lemma soundness assessment (Q1): the helper is
  TRUE under the affine hypotheses (via cofinality of `U₀` in the
  colimit cone + Kähler-vanishes-under-localization), but is non-
  trivial, not `rfl`. Recommendation: **Option (iii) — restate the
  theorem on `Ω[Γ(X,V) ⁄ Γ(S,U)]` directly**, eliminating the
  bridge.

  Adopted. STRATEGY.md updated.

### blueprint-reviewer-iter120 — 3 must-fix items, GATE: DEFER (overridden)

Per-chapter checklist (9 active chapters per content.tex):

- `Cohomology_SheafCompose` / `Cohomology_StructureSheafAb` /
  `Cohomology_StructureSheafModuleK` / `Cohomology_MayerVietoris` /
  `Genus` / `Rigidity` / `AbelJacobi`: `complete: true, correct: true`
  (7 of 9).
- `Differentials`: `complete: partial, correct: partial` (3 must-fix
  items: Step-5 prose still claims "definitional equality"; missing
  blueprint block for the helper lemma; orphan-ref).
- `Jacobian`: `complete: partial, correct: true` (the Route A/B/C
  sub-steps are named but not individually blueprinted; user-directive
  concern, advisory).

The gate verdict (DEFER the Differentials prover lane until the
helper-lemma blueprint lands) was made under the assumption that the
iter-120 plan would take Option (i) (build the helper). Since iter-120
adopts Option (iii) (signature refactor instead), the must-fix items
1+2 are addressed differently: item 1 is satisfied by the
blueprint-writer rewriting Step 5 to match the new (no-bridge)
statement; item 2 is **transformed** — the bridge becomes a
`\begin{remark}` documenting the Mathlib gap, NOT a `\begin{lemma}`
we will formalize. This iter therefore proceeds with the prover
lane.

The Jacobian.tex:6 broken-ref item 3 is addressed by a co-located
blueprint-writer dispatch this iter.

### progress-critic-iter120 — CONVERGING on the single active route

5-iter window iter-115 → iter-119 audited. Verdict rules verbatim:

- CONVERGING: sorry-count strictly decreasing (5 → 5 → **1** → 1 → 1;
  net drop of 4). Helpers-added zero across the window. PARTIAL count
  1 of 5 (vs CHURNING threshold ≥3). No recurring blocker. **MATCHES.**
- CHURNING / STUCK / UNCLEAR: do not match.

The critic explicitly endorses "finish what's started" with a scoped
helper at a named gap — but this iter we adopt the cheaper Option (iii)
instead (no helper at all), which is also a valid form of "finish
what's started" (the proof body skeleton from iter-119 lands directly
on the new signature).

Watch criteria committed for iter-121 (see PROGRESS.md).

### mathlib-analogist-cotangent-presheaf — ALIGN_WITH_MATHLIB on Option (iii)

4 design decisions analyzed:

- **D1 (presheaf-level `pullback` for the cotangent presheaf)**:
  NEEDS_MATHLIB_GAP_FILL (informational; forced by Mathlib gap, not a
  project choice to correct). Mathlib `b80f227` has no scheme-level
  cotangent presheaf/sheaf, so the project's
  `pullback ⊣ pushforward + relativeDifferentials'` path is the only
  off-the-shelf option.
- **D2 (algebra-side relationship `A → A_colim`)**: the iso of Kähler
  modules holds via `KaehlerDifferential.isLocalizedModule_map`. The
  colimit `A_colim` is the **localization** `A_M` of `A = Γ(S, U)` at
  `M := {g ∈ A : appLE(g) ∈ B^×}`. Crucial mathematical clarification:
  the directive's "image(A) = image(A')" framing was wrong (false in
  general; counterexample `Spec ℚ → Spec ℤ`), but the iso holds
  anyway because `d(g^{-1}) = -g^{-2} dg` lives in the B-submodule
  generated by `d(image(A))`.
- **D3a (Option (i) helper lemma)**: DIVERGE_INTENTIONALLY (acceptable
  but high-risk; 200–400 LOC).
- **D3b (Option (ii) sheafified-pullback refactor)**: NOT RECOMMENDED
  (hits the same affine-basis-sheaf-bridge Mathlib gap already declared
  out-of-scope).
- **D3c (Option (iii) statement refactor)**: **ALIGN_WITH_MATHLIB**.
  ~5–10 LOC body, leaf theorem, no protected-signature conflict.
- **D4 (latent design risks elsewhere)**: PROCEED. No new
  parallel-API or signature-mismatch pattern found.

Adopted Option (iii). The persistent
`analogies/cotangent-presheaf-design.md` captures the design rationale
+ full bridge recipe for future iters.

## Subagent dispatches this iter (7 total)

Plan-phase, in two waves:

**Wave 1 (4 read-only critics, parallel)**:

1. `strategy-critic-iter120` — CHALLENGE; recommend Option (iii).
2. `blueprint-reviewer-iter120` — 3 must-fix items; GATE: DEFER
   (overridden by Option (iii) adoption).
3. `progress-critic-iter120` — CONVERGING.
4. `mathlib-analogist-cotangent-presheaf` — ALIGN_WITH_MATHLIB on
   Option (iii); persistent analogy file written.

**Wave 2 (1 refactor + 2 blueprint-writers, parallel)**:

5. `refactor-differentials-algebra-kahler` — signature refactor of
   `smooth_locally_free_omega` to algebra-Kähler form. COMPLETE; file
   compiles with the expected `sorry` warning.
6. `blueprint-writer-differentials-iter120` — rewrite `Differentials.tex`
   to match the new statement + add `sec:bridge-out-of-scope`. COMPLETE.
7. `blueprint-writer-jacobian-iter120` — fix broken
   `\ref{chap:Picard_Functor}` in Jacobian.tex:6. COMPLETE.

All 7 reports archived to `.archon/logs/iter-120/`.

## What lands this iter (verified)

- `AlgebraicJacobian/Differentials.lean` (post-refactor): single
  `sorry` at L99 inside the new algebra-Kähler-form
  `smooth_locally_free_omega`. `lean_diagnostic_messages` returns only
  the expected `declaration uses sorry` warning at L91.
- `blueprint/src/chapters/Differentials.tex`: rewritten to match the
  new statement; `sec:bridge-out-of-scope` section documents the
  bridge as a `\begin{remark}` with a 200–400 LOC Mathlib gap estimate;
  iter-119 `% NOTE:` block removed.
- `blueprint/src/chapters/Jacobian.tex:6`: orphan `\ref` replaced with
  descriptive prose pointing at the in-scope
  `thm:nonempty_jacobianWitness`.
- `STRATEGY.md`: Phase C section rewritten for the algebra-Kähler form;
  new Mathlib gap #3 (the bridge) added.
- `analogies/cotangent-presheaf-design.md`: persistent design-rationale
  file.
- `PROGRESS.md`: rewritten for iter-120 prover lane on the new sorry.
- `task_pending.md`: updated to iter-120 entry status.
- `USER_HINTS.md`: cleared (user hint acted on).
- 7 subagent reports archived to `.archon/logs/iter-120/`.

## Project state after iter-120 plan phase

- Sorry count: 2 (Differentials.lean L99; Jacobian.lean L179) —
  unchanged at file count, but `Differentials.lean` sorry sits inside
  a fresh body on a refactored signature.
- Project compiles clean (per-file `lean_diagnostic_messages` returns
  only the expected `sorry` warning on Differentials).
- No new axioms.
- `archon-protected.yaml` unchanged (signature refactor is on a
  non-protected leaf theorem).
- USER_HINTS.md: empty (cleared this iter; iter-119 hint acted on).

## Why I did not act on session_119 recommendations as proposed

`proof-journal/sessions/session_119/recommendations.md` proposed:

- **CRITICAL #1**: build the bridge helper
  `relativeDifferentialsPresheaf_iso_kaehler_appLE`.
- **CRITICAL #2**: rewrite Step 5 prose to acknowledge the
  source-ring mismatch and route the transfer through the helper.

This iter's plan-phase critic + analogist convergence overrides
CRITICAL #1: the helper-lemma path (Option (i)) is feasible but
expensive (200–400 LOC); Option (iii) (statement refactor) achieves
the same end-state at ~5% the cost on a non-protected leaf
declaration with no downstream consumers. The blueprint-writer
addresses a generalised form of CRITICAL #2 (rewriting Step 5 *and*
adding the bridge as a Mathlib-gap remark, not as a helper-lemma
obligation). The CRITICAL #1 helper is permanently documented in the
analogy file `analogies/cotangent-presheaf-design.md` for any future
iteration or downstream user that needs the bridge.

The other recommendations (HIGH #3 dead `IsAffineHModuleHomFinite`
chain; HIGH #4 anti-recurrence framing; MEDIUM polish-stage items)
remain deferred to polish stage — if the iter-120 prover lane returns
COMPLETE, the project advances to polish stage at iter-121, and these
items become polish-stage tasks.

## Fallback if no user response

Not applicable — no user-escalation this iter. The iter-119 user hint
was acted on in full. No request to the user is pending.

## Notes for iter-121 plan agent

If iter-120 prover round returns COMPLETE:

1. Migrate `smooth_locally_free_omega` closure to `task_done.md`.
2. Advance stage in `PROGRESS.md`: `prover` → `polish`.
3. **Polish-stage backlog** (run in order of severity, inherited from
   session_118 / session_119 recommendations):
   - Delete the dead `IsAffineHModuleHomFinite` chain in
     `StructureSheafModuleK.lean` (must-fix from
     lean-auditor-review118; ~70 LOC).
   - Decide on `HasCechToHModuleIso` / `HasAffineCechAcyclicCover`
     scaffolding-class fate in `MayerVietorisCover.lean` (downgrade to
     explicit-arg theorems per lean-auditor's preferred option (a), OR
     delete if no live callers).
   - Trim redundant typeclass arguments on
     `Rigidity.lean:62-67 GrpObj.eq_of_eqOnOpen`.
   - Tighten `Jacobian.tex` `thm:IsAlbanese_unique` statement-vs-prose;
     `thm:Jacobian_smooth_genus` math paragraph; etc.
   - Minor: stale status-line headers; commented-out historical
     sketches.
4. The Mathlib gap-fill clusters (CategoryTheory in
   StructureSheafModuleK, ModuleCat_free in MayerVietorisCore, the
   bridge in Differentials) stay parked as future upstream-PR effort.

If iter-120 prover returns PARTIAL or INCOMPLETE, follow the four
watch rules in PROGRESS.md § "Watch criteria committed for iter-121"
to choose the iter-121 corrective.
