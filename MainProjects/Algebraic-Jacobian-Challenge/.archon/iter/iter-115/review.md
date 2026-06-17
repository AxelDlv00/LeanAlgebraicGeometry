# Iter-115 (Archon canonical) — review

## Outcome at a glance

- **Single Phase B prover lane on `AlgebraicJacobian/Differentials.lean` L175** `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (post-edit L191).
- **Result**: **INCOMPLETE — neither Bar A nor Bar B met; Bar C did not literally fire but the iter-116 hard-gate trigger condition IS met**. The prover deliberately stopped short of spawning another sub-helper or reformulation wrapper, in compliance with the iter-115 hard rules ("no further reformulation rounds permitted"; "Soundness rule against universally-false helper signatures"). Two on-disk changes only: (a) a docstring rewrite at L148–167 propagating the iter-115 plan's two mandatory Mathlib-name corrections (`isLocalizedModule_map` → `isLocalizedModule`; `AlgebraicGeometry.Modules.tilde` → `AlgebraicGeometry.tilde`) and (b) a structural `intro ι U sf hcomp` exposing the existence-and-uniqueness goal at the residual sorry.
- **Sorry trajectory**: project total **16 → 16** (no closure; no structural advance closing any sub-lemma; only an `intro` advance that does not change the sorry inventory). Per-file: `Differentials.lean` 5 → 5.
- **Compile-verified**: yes. `lean_diagnostic_messages severity=error` on `Differentials.lean` returns `[]`; pre-existing cosmetic carry-overs unchanged (2 `IsSmoothOfRelativeDimension` deprecations + 1 line-length linter).
- **No new axioms**; no protected signatures touched; `archon-protected.yaml` unchanged (9 protected declarations).
- **Named-gap roster**: unchanged. 7 named Mathlib gaps + 1 budget-deferral; the unique-gluing sorry remains documented Bar-B-variant scaffolding (in the chapter as `[gap]`), not added to the named-gap roster.

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **16**, distributed:
  - `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **6** at L1120 PAUSED, L1212 / L1536 / L1564 substep-deferred, L1754 gated on L1120, L1846 budget-deferred (all off-limits this iter).
  - `AlgebraicJacobian/Differentials.lean`: **5** at:
    - L191 (was L175 pre-edit) — `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`; iter-115 INCOMPLETE; docstring rewritten + `intro` advance; inline `sorry` remains at the use-site (per Soundness rule).
    - L737 (was L798) — `cotangentExactSeq_structure case h_exact`; named gap #2. Off-limits.
    - L931 (was L880) — `smooth_iff_locally_free_omega`; signature corrected iter-113 plan-phase refactor. Off-limits this iter (Phase B prover-viable, scheduled iter-117+).
    - L947 (was L897) — `cotangent_at_section`; signature corrected iter-113 plan-phase refactor. Off-limits this iter.
    - L1091 (was L1039) — `serre_duality_genus`; named gap #7. Off-limits.
  - `AlgebraicJacobian/Modules/Monoidal.lean`: **1** at L173 (`instIsMonoidal_W`; Mathlib gap, off-limits).
  - `AlgebraicJacobian/Picard/LineBundle.lean`: **2** at L82 / L96 (named Mathlib gap pair, off-limits).
  - `AlgebraicJacobian/Picard/Functor.lean`: **1** at L181 (`representable`; gated on Phase C3).
  - `AlgebraicJacobian/Jacobian.lean`: **1** at L179 (`nonempty_jacobianWitness`; Phase C3 exit policy).
- **Solved this iter**: **0**.
- **Partial this iter**: **0**. (The session's structural `intro` advance is genuinely sub-PARTIAL — no sub-lemma closed, no recipe step landed.)
- **Blocked this iter**: **1** — `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`. The honest classification is INCOMPLETE under the iter-115 hard rules; from the journal-status enum, `blocked` is the closest fit because the prover identified a concrete repeated structural blocker (affine-basis-to-Scheme sheaf bridge missing from Mathlib b80f227) and stopped to respect the soundness rule rather than emit a Bar-C-trigger reformulation.
- **Untouched (deferred)**: 15.

## What the iter-115 plan got right

- **Mathlib name re-verification before the prover lane**: the iter-115 plan agent's `lean_loogle` + Mathlib source grep caught two chapter-prose slips (`isLocalizedModule_map` should drop `_map`; `AlgebraicGeometry.Modules.tilde` should be `AlgebraicGeometry.tilde`). The prover's docstring rewrite at L148–167 propagated the correct names, leaving the docstring authoritative even where the chapter still drifts. This is the third iter in a row where pre-prover Mathlib name re-verification meaningfully helped (iter-112 caught `forget AddCommGrpCat` namespace slip; iter-113 carried forward; iter-115 catches the two new ones).
- **Hard iter-116 gate committed in the plan sidecar before dispatch**: the iter-115 plan agent agreed with the progress-critic-iter115 STUCK verdict, did not write a rebuttal, and committed an explicit gate language for iter-116. That gate now fires deterministically against the iter-115 prover outcome with no further policy judgement needed from the iter-116 plan agent — exactly the design intent.
- **Bar trajectory definition**: the Bar A / Bar B / Bar C decomposition with explicit "Bar C: another reformulation without substantive closure" gave the prover a clean reason-to-stop. The prover's task result explicitly cites Bar C avoidance as the reason no third sub-helper was introduced.
- **Strategy-critic CHALLENGE addressed in-iter**: both Phase B must-fix items (aggregate decomposition arithmetic + L880-converse hypothesis description with correct closing lemma) landed in STRATEGY.md before dispatch.

## What the iter-115 plan could have done differently (minor)

- **Hard-gate trigger language could have included INCOMPLETE explicitly**: the gate literal says "if iter-115 returns PARTIAL with file-level sorry count unchanged". The prover honest-reported as INCOMPLETE, which is strictly worse on the closure dimension. The gate's intent is clearly that BOTH PARTIAL-with-unchanged-count AND INCOMPLETE-with-unchanged-count trigger; this is a documentation-clarity nit, not a semantic gap. Iter-116 plan agent should treat the gate as fired regardless.
- **Plan-phase Mathlib name corrections did not flow into the chapter this iter**: a pre-emptive iter-115 thin blueprint-writer dispatch on the 2 cosmetic name slips in `Differentials.tex` (L59 / L73) would have been cheap (prose-only, 2 small edits). The plan agent committed the dispatch to iter-116 instead, which is reasonable but means the chapter prose remains drifted for one more iter. Non-blocking.
- **No `lean-vs-blueprint-checker` dispatch was scheduled for iter-115 review**: the iter-114 review skipped it (deeper-think iter), and the iter-115 plan agent inherited a clean blueprint-reviewer PASS. Given the chapter now drifts on 2 Mathlib names AND the iter-116 hard-gate decision turns on chapter-vs-Lean alignment, a `lean-vs-blueprint-checker` on `Differentials.tex`/`Differentials.lean` would have helped frame the iter-116 strategic choice. Logged for iter-116 to consider.

## What the iter-115 prover got right

- **Compliance with the iter-115 hard rules**: the prover (a) did NOT introduce a third sorry-bodied sub-helper (the literal Bar-C trigger language demands ≥2 new helpers; the prover stayed at 0 new helpers); (b) did NOT pivot to yet another equivalent sheaf condition (`IsSheafEqualizerProducts`, `IsSheafPairwiseIntersections`); (c) did NOT emit a universally-false-signature helper. The session's only changes are the docstring rewrite and a single structural `intro`. This is the correct response when the recipe's load-bearing missing piece cannot be displaced through a sound-signatured wrapper.
- **Honest status reporting**: the task result reports INCOMPLETE rather than dressing up the `intro` advance as Bar B. The "Why Bar B was not achieved" section gives a falsifiable mathematical analysis of why no sound-signature single-step helper exists (Step 1 / Step 2 / Step 3 analysis with the explicit circularity / size / hand-roll-required dispositions).
- **Propagation of the iter-115 plan's naming corrections**: the docstring rewrite is the right level for these corrections (the prover does not edit `.tex` files, but they CAN keep the Lean docstring authoritative on Mathlib-name truth).

## What the iter-115 prover could have done differently (minor / informational)

- **Could have spent a search budget probing for a tilde-level Mathlib API** before reporting INCOMPLETE: `Mathlib.AlgebraicGeometry.Modules.Tilde` is a 414-line file (per the iter-115 plan-phase grep) — the prover's `lean_local_search` and `lean_loogle` queries focused on `PresheafOfModules.IsSheaf` and `DifferentialsConstruction` namespaces, which returned empty. A search on `Tilde.isSheaf`, `tilde_isSheaf`, or `IsAffineOpen.isLocalization_basicOpen` (already on the docstring recipe) might have surfaced a partial bridge usable for Step 1 alone. Non-blocking — the iter-114 mathlib-analogist already did this audit; this is at most a redundant double-check.
- **Could have left a `% NOTE: stale Mathlib name` comment in `Differentials.tex`**: the prover task result correctly flags the 2 chapter prose slips for the iter-116 plan agent, but a `% NOTE:` in the chapter would have been a defense-in-depth signal. Not in the prover's allowed write-domain (prover does not edit blueprint).

## Hard iter-116 gate — fires

The iter-115 plan committed:

> if iter-115 returns PARTIAL with file-level sorry count unchanged AND any recurrence of the affine-basis-bridge blocker phrase ..., the iter-116 plan agent does NOT dispatch another helper round on this route. At that point either:
> 1. Route pivot — revise STRATEGY.md to defer all of Phase B by 2+ iters and pull forward a different strategic phase. Re-dispatch `strategy-critic` mid-iter.
> 2. User escalation — pause autonomous loop work on this route and write to `USER_HINTS.md` requesting user input.

Both conditions are met (sorry unchanged; affine-basis-bridge blocker recurred; the prover's task result names the blocker verbatim in its "Why Bar B was not achieved" section). Reporting INCOMPLETE rather than PARTIAL fires the gate a fortiori (strictly worse outcome). See `proof-journal/sessions/session_115/recommendations.md` for the iter-116 action items (Option A vs Option B; recommendation = Option B user escalation).

## Verification

| Check | Status |
|---|---|
| Sorry count per file | BasicOpenCech 6, Differentials 5, LineBundle 2, Modules/Monoidal 1, Picard/Functor 1, Jacobian 1 = **16 total**. Verified via `sorry_analyzer.py --format=summary` post-session. |
| File compilation (Differentials.lean) | `lean_diagnostic_messages severity=error` → `[]` post-session. |
| `archon-protected.yaml` | unchanged (9 protected declarations). |
| New axioms | none (only doc-comment mentions in `MayerVietorisCover.lean:506–507`). |
| Edits this iter | 2 (docstring at L148–167; body at L175–233 with `intro` + comment block; both prose-only on docstring + tactic-trivial on body). |
| Subagent dispatches (review phase) | 0 — see § "Subagent dispatches this review" in `summary.md` for rationale. |
| Hard iter-116 gate trigger | fired (file count unchanged + blocker phrase recurred + INCOMPLETE worse than PARTIAL fires a fortiori). |
| Blueprint markers manually adjusted | 0 — see § "Blueprint markers updated (manual)" in `summary.md` for rationale. |
