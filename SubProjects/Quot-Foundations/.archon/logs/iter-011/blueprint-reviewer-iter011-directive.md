# Blueprint review — iter 011 (whole-blueprint audit, prover-gate)

You are the whole-blueprint reviewer. Audit the ENTIRE blueprint under
`blueprint/src/chapters/` (do NOT scope to one chapter — the cross-chapter view
is the point). Run `leandag build --json`, `leandag show isolated`, and
`archon blueprint-doctor --json` and report their summaries.

## Context (why this dispatch)

The blueprint was re-elaborated by the iter-010 DAG agent and by two iter-009
blueprint-writers (`fbc-routeswap`, `quot-bridge-snap`). The prior whole-blueprint
verdict (iter-009) is therefore stale. This iter (011) is a prover iter; I intend
to dispatch prover lanes on up to four files. I need a fresh HARD-GATE verdict per
chapter so I know which files may receive a prover.

## Files I am considering for prover dispatch this iter

1. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
   → chapter `Cohomology_FlatBaseChange.tex`
   Target frontier node: `lem:base_change_mate_section_identity`
   (plus the residual FBC-A sorries the section identity unblocks).
2. `AlgebraicJacobian/Picard/FlatteningStratification.lean`
   → chapter `Picard_FlatteningStratification.tex`
   Target frontier nodes: `lem:gf_torsion_annihilator`,
   `lem:gf_nagata_monic_lastVar`, `lem:gf_mvPolynomial_quotient_finite_monic`,
   `lem:gf_noether_clear_denominators` (the GF effort-broken chain).
3. `AlgebraicJacobian/Picard/QuotScheme.lean`
   → chapter `Picard_QuotScheme.tex`
   Target frontier nodes: `lem:qcoh_section_localization_basicOpen`,
   `def:sectionGradedRing`. These were BLOCKED at iter-009 (the QCoh→IsLocalizedModule
   bridge had no `% LEAN SIGNATURE`); the iter-009 `quot-bridge-snap` writer + the
   iter-010 DAG were supposed to author them. **Confirm explicitly whether each now
   carries a complete, formalizable `% LEAN SIGNATURE` + proof sketch** — this is the
   gate decision for the QuotScheme lane.
4. `AlgebraicJacobian/Picard/GrassmannianCells.lean`
   → chapter `Picard_GrassmannianCells.tex`
   Node `def:gr_transition`. NOTE: I am separately effort-breaking this node THIS
   iter because the prover has produced zero output on it for 2–3 iters. So for
   GrassmannianCells, just report the chapter's current completeness/correctness;
   I do not need a "ready now" verdict (the effort-break supersedes it for next iter).

## What I need from you

For EVERY chapter, the standard `complete: <true|partial|false>` /
`correct: <true|partial|false>` verdict block, plus:
- The per-chapter checklist of which blocks are formalizable (have `% LEAN SIGNATURE`
  where the Lean decl does not yet exist, a rigorous proof sketch, resolved `\uses{}`).
- For each of the four files above, an explicit **gate verdict**: may a prover be
  dispatched at the named frontier node(s) this iter, or is there a must-fix blueprint
  gap blocking it? Name the specific must-fix item if so.
- Your `## Unstarted-phase blueprint proposals` section (FBC-B, etc.) as usual.

Reminder: a chapter whose only "incompleteness" is that some Lean targets are still
sorry-bearing (the prose is complete and formalizable) is `complete: true` for gate
purposes — the open sorries are the prover's job, not a blueprint defect. Reserve
`partial`/`false` for genuine prose/signature/`\uses{}` defects that would make a
prover formalize a broken or under-specified statement.

Write your report to `task_results/blueprint-reviewer-iter011.md`.
