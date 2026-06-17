# Iter-120 (Archon canonical) — review

## Outcome at a glance

- **COMPLETE prover lane on `Differentials.lean:91` `smooth_locally_free_omega`.** The iter-120 algebra-Kähler signature refactor (plan phase) eliminated the iter-119 colimit-source bridge gap from the statement; the prover then closed the body in a single Edit using Steps 1–4.5 of the verified 6-lemma Mathlib chain. Body: 11 LOC. Diagnostic state post-close: `[]` errors, `[]` warnings — file is fully clean (no `sorry` warning remains anywhere in `Differentials.lean`).
- **Sorry trajectory: 2 → 1** (project sorry count crosses into intended end-state). Per-file: `Differentials.lean` 1 → **0**; `Jacobian.lean` 1 → 1 (`nonempty_jacobianWitness` unchanged; off-limits).
- **No new axioms.** `lean_verify` on `AlgebraicGeometry.Scheme.smooth_locally_free_omega` returns the three standard Lean axioms only (`propext`, `Classical.choice`, `Quot.sound`). No new custom axioms anywhere this iter.
- **No protected signatures touched.** `archon-protected.yaml` unchanged (9 protected declarations at original paths with unchanged signatures). `smooth_locally_free_omega` is non-protected; the iter-120 plan-phase signature refactor was on a leaf theorem with no downstream consumers.
- **Meta**: `meta.json planValidate.status: ok / objectives: 1`; `prover.durationSecs: 229` (3.8 min — the shortest prover-phase duration in the project's recent history); `provers.AlgebraicJacobian_Differentials.status: done`; `plan.durationSecs: 2609` (43 min, 7 plan-phase subagent dispatches: 4 critics + 1 refactor + 2 blueprint-writers).
- **Stage advancement signal**: Watch criterion 1 from PROGRESS.md fires verbatim — "iter-120 prover lane returns COMPLETE → CONVERGING ratified; advance stage `prover` → `polish`." The iter-121 plan agent should set stage to `polish` and pick up the polish-stage backlog inherited from session_118 / session_119 recommendations.

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **1**, distributed:
  - `AlgebraicJacobian/Jacobian.lean:179` — `nonempty_jacobianWitness` (the project's single explicit foundational existence hypothesis; off-limits to the autonomous loop by design).
- **Solved this iter**: **1** — `AlgebraicGeometry.Scheme.smooth_locally_free_omega`. Full closure (Bar A achieved). Body 11 LOC. Closure structurally one-shot (single Edit event in `attempts_raw.jsonl`).
- **Partial this iter**: **0**.
- **Blocked this iter**: **0**.
- **Untouched (deferred / out-of-scope)**: **1** (`nonempty_jacobianWitness`).

## What the iter-120 prover got right

- **Read the strategic context, then chose the shortest path through it.** Instead of replaying the iter-119 prover's ~45 LOC against the new signature, the iter-120 prover used the field accessor `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension` (one step shorter than the `mk_iff`-generated `smoothOfRelativeDimension_iff` because the field's binder order matches the existential we're refining into). The resulting body is 11 LOC instead of 45 LOC, with identical mathematical content.
- **Exploited the shared-prelude structure.** Both conjuncts (`Module.Free …` and `Module.rank … = n`) share an identical setup: algebraize the appLE hom, install `IsStandardSmooth`, install `Nonempty V` so `Scheme.component_nontrivial` fires automatically. Only the closing lemma differs. The prover used `refine ⟨…⟩ <;> · <shared_prelude>; first | exact <closer_a> | exact <closer_b>` to keep the body tight, rather than `refine ⟨…⟩; · <prelude>; <closer_a>; · <prelude>; <closer_b>` which duplicates the prelude.
- **Honest task result with concrete watch-criterion mapping.** The prover's report at `task_results/AlgebraicJacobian_Differentials.lean.md` explicitly maps the outcome to "criterion (1) fires: CONVERGING ratified; advance stage `prover` → `polish`." Specific, no overclaim.
- **No incidental edits.** Only the body of `smooth_locally_free_omega` was touched. Surrounding declarations (`relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`) are unchanged; the file's L1–L90 surface (imports, docstrings, infrastructure definitions) is byte-identical to the iter-120 plan-phase refactor output.

## What the iter-120 plan got right

- **Heeded the strategy-critic CHALLENGE and the mathlib-analogist ALIGN_WITH_MATHLIB verdict.** Both fresh-context audits independently converged on Option (iii) (signature refactor of a non-protected leaf theorem) over the session_119 recommendation CRITICAL #1 (Option (i): build a 200–400 LOC bridge helper). The plan's rebuttal section explicitly names why the session_119 recommendation was overridden — the analogist's design rationale persisted at `analogies/cotangent-presheaf-design.md`. This is the workflow the dispatcher_notes call for ("either update STRATEGY.md to address the challenge, or record an explicit rebuttal in iter/iter-NNN/plan.md").
- **Pre-verified the Mathlib closing slate.** All 6 lemma names in PROGRESS.md L118–L152 were marked `[verified]` in `b80f227` before the prover lane started. The prover did not waste any time hunting for a name that did not exist.
- **Co-located the orthogonal Jacobian.tex orphan-`\ref` fix in the same iter** rather than queueing it for a separate iter. Both blueprint-writer dispatches (`blueprint-writer-differentials-iter120`, `blueprint-writer-jacobian-iter120`) returned COMPLETE in parallel.
- **Persisted the design rationale in a non-iter-bound file.** `analogies/cotangent-presheaf-design.md` is a permanent file that future iters (or downstream users wanting to build the bridge) can read for the full mathematical content. This is exactly the surface the mathlib-analogist's dispatcher_notes prescribe.

## What's load-bearing this iter (Knowledge Base candidates)

- **Signature-refactor of a leaf theorem to dissolve a bridge gap.** When a sorry's residual is a real Mathlib bridge gap (~200+ LOC of cofinality / Kan-extension machinery) **and** the declaration is a non-protected leaf, restating the theorem on the algebra side (eliminating the presheaf side from the conclusion) is often cheaper than building the bridge. The iter-117 sheaf→presheaf refactor and the iter-120 presheaf→algebra-Kähler refactor are two instances of the same pattern: **prefer signature simplification over auxiliary infrastructure construction when no downstream consumer requires the more general form.** Recorded in `PROJECT_STATUS.md § Proof Patterns` (the "Signature-form refactor … to sidestep a missing Mathlib bridge" entry has an iter-120 addendum to add).
- **One-attempt closure as a CONVERGING signal.** A target whose body lands in a single Edit event (vs. the iter-119 target's ~16 edits) on a strategy-critic-endorsed signature is the cleanest CONVERGING signal possible. Treat one-attempt closures on a previously-PARTIAL target as ratifying the iter-N–1 plan-phase strategic call, not as luck.
- **`mathlib-analogist` proactive dispatch on a blueprint-reviewer soft finding.** Iter-119's hindsight was that the analogist should have been called proactively when the blueprint-reviewer flagged Step-5 as a soft finding; iter-120 acted on that hindsight by dispatching `mathlib-analogist-cotangent-presheaf` in the plan phase, even though the gate was not "must-fix." This produced the persistent `analogies/cotangent-presheaf-design.md` file and identified Option (iii) as the canonical move. **Pattern**: dispatch `mathlib-analogist` proactively when the blueprint-reviewer marks a definition or bridge as "could be tighter" / "soft finding," not only on must-fix.

## What the iter-120 plan got slightly wrong (in hindsight)

- The plan's `PROGRESS.md L154–L168` proof skeleton listed 9 steps; the actual landing was 11 LOC (5 effective lines once setup is collapsed). The skeleton was over-cautious — Steps 4 and 5 collapse to one `haveI`, Steps 6 and 7 collapse to one `haveI`, the shared prelude lets Steps 8 and 9 share the first three lines. A slightly tighter skeleton (matching the `<;> · … first | … | …` shape the prover actually used) would have been more accurate, though this had zero cost on the outcome.
- Marginal observation; no corrective needed.

## TO_USER.md

No user-facing escalation. Iter-120 had a prover dispatch (not an intentional skip); `planValidate.status: ok` and `objectives: 1`; `prover.status: done`; COMPLETE outcome. `TO_USER.md` cleared (empty).

## Files I changed in this review

- `.archon/proof-journal/sessions/session_120/milestones.jsonl` (created; 1 milestone for the solved target, 1 placeholder for `nonempty_jacobianWitness`).
- `.archon/proof-journal/sessions/session_120/summary.md` (created).
- `.archon/proof-journal/sessions/session_120/recommendations.md` (created).
- `.archon/iter/iter-120/review.md` (this file).
- `.archon/PROJECT_STATUS.md` (Knowledge Base only — pattern additions under § "Proof Patterns"; "Last Updated" timestamp bumped; no Overall Progress section touched per policy).
- `.archon/TO_USER.md` (cleared / left empty).

## Files I did NOT change

- Any `.lean` file (review-agent boundary).
- `.archon/PROGRESS.md`, `.archon/task_pending.md`, `.archon/task_done.md`, `.archon/STRATEGY.md` (plan agent's domain).
- `\leanok` markers (deterministic `sync_leanok` phase owns those; the chapter `Differentials.tex` already has `\leanok` on `thm:smooth_locally_free_omega`'s statement and proof block as planted by `blueprint-writer-differentials-iter120` in plan phase, and the sync_leanok run before this review will have confirmed/corrected as needed).
- `archon-protected.yaml` (user-owned).
- Any blueprint `\mathlibok` (this iter's closed declaration is project-side, not a Mathlib re-export; `\mathlibok` would be wrong).
