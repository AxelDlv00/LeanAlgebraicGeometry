# Blueprint Reviewer Directive

## Slug
iter162

## Iteration
162

## Scope
Whole-blueprint audit (all chapters under `blueprint/src/chapters/`), per your standing rule — do
NOT scope-limit. The cross-chapter view is the point.

## This iter's context (for your per-chapter checklist + HARD GATE)
- The ONLY chapter edited since your iter-161 dispatch is `AbelianVarietyRigidity.tex` (plus the
  iter-161 review agent's `% NOTE`). This iter a blueprint-writer (`avr-helpers`) made TWO additive
  edits to it:
  1. Added `\begin{lemma}\label{lem:eq_comp_of_isAffine_of_properIntegral}\lean{AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral}` — the PROVEN axiom-clean algebraic-core helper ("two k̄-points of a proper integral l.f.t. k̄-scheme into an affine compose equally"). This resolves your iter-161 lean-vs-blueprint-checker MAJOR (the helper previously had no node).
  2. Added `\begin{lemma}\label{lem:isIntegral_of_retract_of_integral}` (deliberately NO `\lean{}` yet — the prover has not landed the named helper; a `% NOTE:` flags the cross-ref to fill later) — "a retract of an integral scheme is integral."
  3. Wired the proof of `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` with forward `\uses{lem:eq_comp_of_isAffine_of_properIntegral, lem:isIntegral_of_retract_of_integral}`.
- I am about to send a prover lane to `AlgebraicJacobian/AbelianVarietyRigidity.lean` to close the
  lone Step-1 residual `rigidity_eqAt_closedPoint_of_proper_into_affine`. The HARD GATE requires a
  fresh `complete:true` + `correct:true` verdict on `AbelianVarietyRigidity.tex` with no must-fix
  before that lane runs.

## What I need from you
- Your usual per-chapter completeness + correctness checklist for every chapter.
- Specifically confirm whether `AbelianVarietyRigidity.tex` is now `complete:true` + `correct:true`
  with the two new nodes wired (forward-acyclic `\uses`, no new backward edge / 2-cycle like the
  iter-160 incident, no headline laundering, the new project-bespoke nodes well-formed and faithful
  to the on-disk Lean signatures where a `\lean{}` is present).
- Flag any chapter that is `partial | false`, any broken `\uses`/`\ref`, any laundering vector, and
  any must-fix-this-iter finding.
