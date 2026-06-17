# iter-004 review (session_4)

## Overall Progress — this session
- **Prover lane**: one (P4 → `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`,
  `[prover-mode: mathlib-build]`). Model: sonnet. The lane that was mechanically noop'd in
  iter-003 actually ran this iter.
- **Global sorry**: 2 → 2 (unchanged). Both remaining sorries are in `CechHigherDirectImage.lean`
  (`CechAcyclic.affine` L774, `cech_computes_higherDirectImage` L811) — P3/P5, out of scope.
- **`AcyclicResolution.lean`**: 0 → 0 sorries; **5 new declarations added**, all axiom-clean
  (`{propext, Classical.choice, Quot.sound}`).
- **Named blueprint targets closed**: 0 of 3 (horseshoe / object-level shift / staircase all open).
- **Solved / partial / blocked / untouched** (per the 3 P4 targets): 0 / 1 / 2 / 0.
  - `rightDerivedShiftIsoOfAcyclic` (TARGET 2): **partial** — its resolution-level engine
    `rightDerivedShiftIsoOfSplitResolutionSES` is built and axiom-clean; only the object-level
    wrapper (which needs the horseshoe) is missing.
  - `InjectiveResolution.ofShortExact` (TARGET 1, horseshoe): **blocked** — sole remaining gap.
  - `rightDerivedIsoOfAcyclicResolution` (TARGET 3, staircase): **blocked** — downstream of 1+2.

## This session's analysis
Real, if not headline-closing, progress: the prover built **every consumer of the horseshoe** and
verified all Mathlib inputs present, collapsing the entire P4 lane to one remaining construction.
The standout discovery is that the dimension-shift step — which the strategy had budgeted as a
hand-rolled `homology_exact₁/₂/₃` LES chase — is a three-step `Iso.trans` off Mathlib's
`ShortComplex.ShortExact.δIso` (acyclic middle ⇒ connecting map is an iso). The resolution-level
engine, the degreewise-split → ShortExact machinery, the acyclic-vanishing transport, and the
per-stage horseshoe mono are all landed and axiom-clean. lean-auditor confirmed none are vacuous
(`rightDerivedShiftIsoOfSplitResolutionSES` genuinely consumes `[IsRightAcyclic J]` + `splits`).

The prover correctly declined the horseshoe itself: it is a monolithic ℕ-recursion (twisted
differential + resolves-B proof) with no `sorry`-free partial fragment beyond the per-stage mono it
already landed. That is the right call under `mathlib-build` — but it means the next iter must
**decompose** the horseshoe (effort-breaker) rather than re-dispatch the monolith.

### Headline finding — false `\leanok` on the horseshoe (DAG poisoning)
`lem:injective_resolution_of_ses` (`\lean{...InjectiveResolution.ofShortExact}`) carries `\leanok`
on both statement (chapter L190) and proof (L217), but the declaration **does not exist**
(`lean_verify`: "Unknown constant"). Root cause: a ``` ```-fenced `def InjectiveResolution.ofShortExact ...`
inside the `.lean` strategy comment (file L283) that the `sync_leanok` matcher reads as a real
sorry-free declaration (`sync_leanok-state.json` iter-004: `added: 3, removed: 0` on this chapter).
Because the horseshoe is the *sole* remaining P4 blocker, a false "done" on it could stop the planner
from ever dispatching its construction. Independently caught by lean-vs-blueprint-checker (3 must-fix).
I added a `% NOTE:` to the block (my domain); the actual fix is Lean-side (reformat the fence) and is
the top item in `recommendations.md` — once fixed, `sync_leanok` strips the markers automatically.
Captured as a reusable Known Blocker in PROJECT_STATUS.md so the trap is not reproduced.

## Subagent dispatches
- **lean-auditor** (`iter004`): dispatched (`.lean` modified this iter). Clean — 0 critical/major,
  3 minor (comment-only). Confirmed 5 decls sorry-free, axiom-clean, non-vacuous; L283 `def` is inert.
  Report: `task_results/lean-auditor-iter004.md`.
- **lean-vs-blueprint-checker** (`acyclic`): dispatched (file received prover work). 3 must-fix
  (false-`\leanok` root cause), 2 major (substantive new decls `rightDerivedShiftIsoOfSplitResolutionSES`
  and `mono_biprod_lift_factorThru_of_exact` lack `\lean{}` tags). Report:
  `task_results/lean-vs-blueprint-checker-acyclic.md`.

(No `## Subagent skips` — both highly-recommended review subagents dispatched.)

## Blueprint markers updated (manual)
- `Cohomology_AcyclicResolution.tex`, `lem:injective_resolution_of_ses`: added `% NOTE:` flagging the
  false-done `\leanok` (statement + proof), its root cause, and the Lean-side fix. (No `\leanok`
  touched.) No `\mathlibok` added (5 new decls are `lean_aux`, not Mathlib re-exports). No `\lean{}`
  correction (the `rightDerivedShiftIsoOfAcyclic` vs `...SplitResolutionSES` divergence is
  forward-pointing, not a rename — handed to planner).

## Coverage debt
`archon dag-query unmatched` = 15: 5 new this iter (all in `AcyclicResolution.lean`), 10 inherited
push-pull/Čech helpers. All enumerated in `recommendations.md` for the planner to blueprint.

## Pointers
- Session journal: `proof-journal/sessions/session_4/{summary,recommendations,milestones.jsonl}`.
- Doctor: `logs/iter-004/blueprint-doctor.md` (no structural findings).
- Plan sidecar: `iter/iter-004/plan.md` (D1 re-dispatch after iter-003 noop; D3 P3 narrowing teed up).
- `\leanok` sync state: `.archon/sync_leanok-state.json` (iter-004; the `added:3` includes the 2 false markers).
