# Session 118 — Refactor + Blueprint iter (correctness fix on `smooth_iff_locally_free_omega`)

## Metadata

- Iteration / session: **iter-118** (Archon canonical) = `session_118` (review of iter-118).
- Sorry count before: **2** (Differentials.lean L81 [old] + Jacobian.lean L179).
- Sorry count after: **2** (Differentials.lean L93 [new line; same sorry, renamed declaration] + Jacobian.lean L179). Net unchanged.
- Target attempted by provers: **none** — no prover lane was dispatched this iter.
- Targets touched by other agents this iter:
  - `AlgebraicJacobian/Differentials.lean` — refactor agent (slug `differentials-iter118`) renamed and demoted the iff.
  - `blueprint/src/chapters/Differentials.tex` — blueprint-writer-differentials-iter118.
  - `blueprint/src/chapters/Jacobian.tex` — blueprint-writer-jacobian-iter118.
  - `.archon/STRATEGY.md` — plan-agent edits (Phase C closing slate + Mathlib-name corrections + Route C / upstream-status disclosures).
- Compile status: clean. `lake build` (post-refactor) succeeded with 0 errors and 1 expected `declaration uses sorry` warning at `Differentials.lean:87`.
- Mode: review of a no-prover iter (the previous `attempts_raw.jsonl` event log carries stale events from iter-115's prover round; the actual iter-118 work was performed by the plan-phase critics + writers + refactor, whose reports live under `.archon/logs/iter-118/`).

## What happened this iter (one paragraph)

The iter-117 trim left exactly two sorries in the project: a refactored
`smooth_iff_locally_free_omega` on the presheaf-form Kähler differential
module, and the single foundational hypothesis
`nonempty_jacobianWitness`. The iter-118 plan agent identified that the
iter-117 *iff* signature was mathematically **false** in its converse
direction (counterexample: the closed immersion `Spec k → Spec k[t]`
induced by `t ↦ 0` has `Ω_{k/k[t]} = 0` locally free of rank 0 but is not
flat, hence not smooth — the converse requires `Subsingleton (Algebra.H1Cotangent A B)`
which is not implied by local freeness alone). Per the iter-116 user
directive "no temporarily wrong statements", the plan agent demoted the
signature to a forward-only implication. The plan-phase dispatched three
mandatory critics (strategy / blueprint-reviewer / progress-critic), one
refactor agent (which renamed the theorem to `smooth_locally_free_omega`,
dropped the `LocallyOfFinitePresentation` premise, switched from the
deprecated `IsSmoothOfRelativeDimension` alias to `SmoothOfRelativeDimension`,
made `n` implicit, and pinned the body at `sorry`), and two
blueprint-writers (rewriting the Differentials chapter for the
forward-only direction with the verified 5-step Mathlib chain + a new
"Converse direction — out of autonomous-loop scope" section with three
remarks; and addressing the three iter-117 must-fix items on the Jacobian
chapter: `IsAlbanese_unique` prose-vs-Lean drift, new `def:JacobianWitness`
block enumerating all 7 fields, new subsection "Extracting the universal
morphism" with `\lean{...}` references for the three `IsAlbanese.*`
projection helpers). The blueprint-reviewer's hard-gate finding pushed
the prover lane to **iter-119**. The review phase dispatched three
read-only audits (lean-auditor + 2 lean-vs-blueprint-checkers); only one
must-fix-this-iter finding emerged (an already-self-admitted dead
`IsAffineHModuleHomFinite` chain in `StructureSheafModuleK.lean`,
unrelated to the active prover surface).

## Per-target detail

### Target 1: `Differentials.lean:87` `smooth_locally_free_omega` (was: `smooth_iff_locally_free_omega:74`)

Status: **partial (signature refactor + blueprint rewrite landed; proof body remains `sorry` scheduled for iter-119 prover lane).**

The iter-117 iff signature was mathematically false in the converse
direction. The refactor agent's edits (per `.archon/logs/iter-118/refactor-differentials-iter118.md`):

- L74 → L87: theorem renamed `smooth_iff_locally_free_omega` →
  `smooth_locally_free_omega`. Signature demoted from `↔` to `→` (forward
  direction only).
- Dropped `LocallyOfFinitePresentation f` premise (subsumed by
  smoothness in the forward direction).
- Switched from the deprecated `IsSmoothOfRelativeDimension` alias to the
  current Mathlib class `SmoothOfRelativeDimension` (resolves the
  deprecation warning previously emitted on the iter-117 file at L76).
- `n` made implicit (`{n : ℕ}`), inferred from the typeclass.
- Docstring rewritten (L66–86) to enumerate the 5-step Mathlib chain
  and to honestly disclose the converse-direction Mathlib gap with a
  pointer to `blueprint/src/chapters/Differentials.tex`'s new
  `\sec{Converse direction --- out of autonomous-loop scope}`.

The body remains `sorry` at L93. `lean_diagnostic_messages` on the file
returns `[]` errors. Sorry count unchanged.

Blueprint-writer-differentials-iter118 simultaneously rewrote
`blueprint/src/chapters/Differentials.tex`:

- Theorem renamed and demoted to forward implication (statement +
  `\lean{...}` hint).
- Proof sketch replaced with a 5-step Mathlib chain, each cited with
  source location:
  1. `AlgebraicGeometry.smoothOfRelativeDimension_iff` (mk_iff)
  2. `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth` (chart bridge)
  3. `Algebra.IsStandardSmooth.free_kaehlerDifferential` (instance)
  4. `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (rank pin)
  5. `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler` (project-local)
- New section `\sec{Converse direction --- out of autonomous-loop scope}`
  (`\label{sec:converse-out-of-scope}`) with three remarks:
  `rem:converse_counterexample` (the `Spec k → Spec k[t]` counterexample);
  `rem:converse_lemma_hypotheses` (`Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`
  hypotheses; `Algebra.H1Cotangent` reference); `rem:stacks_02G1` (Stacks
  tag cross-reference).

Both the lean-vs-blueprint-checker-differentials-review118 audit and the
lean-auditor-review118 audit return **0 must-fix / 0 major findings**
on this surface; the post-refactor Lean and post-rewrite blueprint are
in mutual agreement.

### Target 2: `Differentials.lean:93` `smooth_locally_free_omega` sorry (the actual proof body)

Status: **not_started** (no prover lane dispatched this iter; iter-118
was a refactor + blueprint iter under the blueprint-reviewer hard-gate
that required the iter-117 iff-vs-prose correctness gap to land before
any prover dispatch).

Iter-119 prover lane scheduled. The closing slate is fully pre-verified.

### Target 3: `Jacobian.lean:179` `nonempty_jacobianWitness`

Status: **not_started**. This is the single explicit foundational
hypothesis (existence of an Albanese variety for a smooth proper
geometrically irreducible curve). Strategy-critic-iter118 CHALLENGEd
with the suggestion to convert the `sorry` to an `axiom`; the plan
agent rebutted per the no-new-axioms hard rule
(`.archon/prompts/plan.md` L43). The blueprint-writer-jacobian-iter118
addressed the three iter-117 must-fix items on the surrounding
blueprint surface:

- **Fix 1**: `thm:IsAlbanese_unique` statement-vs-prose drift. Prose
  tightened to match the Lean's "unique morphism" return type; the
  iso-content remark `rem:IsAlbanese_unique_iso` documents the
  internally-computed-but-not-returned inverse.
- **Fix 2**: New `def:JacobianWitness` block enumerating all 7 fields
  + two remarks (`rem:JacobianWitness_quantifier_order` motivating the
  `∃ J, ∀ P` choice; `rem:JacobianWitness_smooth_redundancy` on the
  `smooth` vs `smoothGenus` redundancy).
- **Fix 3**: New subsection "Extracting the universal morphism" with
  three new blocks for `IsAlbanese.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}`,
  closing the blueprint-coverage gap that previously forced readers to
  open the Lean file to recover the projection-helper API.

Lean-vs-blueprint-checker-jacobian-review118 returns 0 must-fix / 0 major.
3 minor items recorded (see Notes below).

## Subagent reports (this review phase)

| Subagent | Slug | Verdict | Key findings |
|---|---|---|---|
| lean-auditor | review118 | 1 must-fix / 3 major / 6 minor | Dead `IsAffineHModuleHomFinite` chain in `Cohomology/StructureSheafModuleK.lean:458–520` (class + 3 consumers; iter-043 docstring at L530–543 self-admits "dead scaffolding"; should be deleted iter-119). 2 major scaffolding classes without producers (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover` in `MayerVietorisCover.lean`). 1 major redundant typeclass arguments on `Rigidity.lean:62-67 GrpObj.eq_of_eqOnOpen`. The two active-surface `sorry`s (`smooth_locally_free_omega`, `nonempty_jacobianWitness`) cleared: no must-fix, no excuse-comments. |
| lean-vs-blueprint-checker | differentials-review118 | 0 must-fix / 0 major / 0 minor | Lean and blueprint in full mutual agreement after iter-118 refactor + blueprint rewrite. 3/3 declarations referenced; 5/5 named Mathlib closure pieces verified to exist in the pinned snapshot. |
| lean-vs-blueprint-checker | jacobian-review118 | 0 must-fix / 0 major / 3 minor | 12/14 declarations referenced; 2 unreferenced (dead `geometricallyIrreducible_id_Spec` helper at L120, `jacobianWitness` extraction lacking its own `\lean{...}` block but mentioned in prose). Minor prose drift "morphism of group schemes" vs Lean's `J ⟶ A` — mathematically equivalent under classical rigidity. |

Full reports: `.archon/task_results/lean-auditor-review118.md`,
`.archon/task_results/lean-vs-blueprint-checker-differentials-review118.md`,
`.archon/task_results/lean-vs-blueprint-checker-jacobian-review118.md`.

## Key findings / proof patterns discovered

- **Iff signatures need converse-direction sanity-checking when refactored.**
  The iter-117 trim refactored a sheaf-form signature into a presheaf-form
  signature and preserved the iff shape; the converse direction had been
  validated against the *sheafified* Kähler differential module but the
  refactored converse (presheaf-form, basis-localised) silently lost a
  flatness / H¹-cotangent-vanishing premise. The lesson: when refactoring
  a quantified shape change (sheaf → presheaf, global → basis-localised),
  re-derive each direction independently, not just transport the shape.
- **No-axiom hard rule beats no-deferral user directive at the
  declaration boundary.** The user's iter-116 "nothing deferred"
  directive applies to scope of *content* (orphan-to-protected-chain
  declarations the loop cannot close), not the *form* of declaration
  (`sorry` vs `axiom`). The plan agent's rebuttal correctly identifies
  axiomization as a different form of deferral — it hides the gap from
  `sorry_analyzer` rather than removing it. The conflict resolution
  records the rebuttal in the iter-118 plan sidecar per
  strategy-critic dispatcher_note.
- **Blueprint-reviewer hard-gate cleanly defers a single prover lane by
  one iter.** The iter-118 iff-is-false finding was a hard-gate trigger
  on the only active prover lane this iter. Rather than dispatch the
  prover against a false statement, the plan agent dispatched the
  refactor + writer pair this iter and scheduled the prover for iter-119.
  Net cost: 1 iter latency; net benefit: prover reads correct material.

## Recommendations for next session (iter-119)

See `recommendations.md`. Headline: dispatch a prover lane on
`Differentials.lean:87` `smooth_locally_free_omega` against the
pre-verified 5-step Mathlib chain. Watch criteria committed by
progress-critic-iter118 (COMPLETE → CONVERGING, PARTIAL+new-blocker →
CHURNING + escalate to mathlib-analogist, PARTIAL+no-blocker →
UNCLEAR-trending-CONVERGING). Concurrently (or in iter-120), execute
the lean-auditor's must-fix on the dead `IsAffineHModuleHomFinite`
chain (4 declarations to delete in `StructureSheafModuleK.lean`).

## Blueprint markers updated (manual)

None this iter. `\leanok` / `\mathlibok` placement is the deterministic
`sync_leanok` phase's responsibility; the review-phase manual marker
work is limited to `\mathlibok` adds, `\lean{...}` corrections, and
`% NOTE:` annotations driven by prover task results, of which there
are none this iter (no prover ran). Two pre-existing observations
flagged in the previous session (`Jacobian.tex` L249 stale-`\leanok` on
the `\begin{proof}` block of `thm:nonempty_jacobianWitness`; `Differentials.tex`
L62 stale-`\leanok` on the `\begin{proof}` block of `thm:smooth_locally_free_omega`)
remain pending the next `sync_leanok` run after the iter-119 closure
attempt; no review-agent action this iter.

## Notes

- The `.archon/proof-journal/current_session/attempts_raw.jsonl` file
  carries 41 events all dated `2026-05-16T00:26:40` onward, but the
  events themselves refer to the iter-115 prover round on
  `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (a
  declaration that iter-117 trim deleted; not in the current Lean
  source). This is residual from a prior iter's prover run that was
  not cleared before iter-118 began. The substantive iter-118 work
  is recorded in `.archon/logs/iter-118/` (plan + critic + refactor +
  writer JSONL + report files). Treat the `attempts_raw.jsonl` events
  as stale and not reflective of any iter-118 prover activity.
- The pre-existing `\leanok` on `Differentials.tex` L62 (proof block
  for `thm:smooth_locally_free_omega`) is incorrect — the Lean proof
  body is `sorry`. The deterministic `sync_leanok` phase should strip
  it; if it does not after the iter-119 attempt, the review agent
  may need to intervene. The pre-existing `\leanok` on `Jacobian.tex`
  L249 (proof block for `thm:nonempty_jacobianWitness`) is similarly
  incorrect for the same reason but is the project's authorised
  foundational hypothesis (proof body intentionally `sorry`).
