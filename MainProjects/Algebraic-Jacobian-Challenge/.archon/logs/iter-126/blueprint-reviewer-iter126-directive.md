# Blueprint Reviewer Directive

## Slug
iter126

## Strategy snapshot

The iter-126 plan-agent is dispatching:
- **1 refactor** (`m2a-scaffold-iter126`) — creates new Lean file
  `AlgebraicJacobian/RigidityKbar.lean` with named declaration
  `AlgebraicGeometry.rigidity_over_kbar` (sorry body; reduces to
  C.2.d cotangent-vanishing keystone). This is the M2.a scaffold
  step per STRATEGY.md § Sequencing.
- **1 mathlib-analogist** (`cotangent-vanishing-pile-iter126`) —
  scopes the shared cotangent-vanishing Mathlib pile. Output is a
  build directive for iter-129+; does NOT add a Lean declaration
  this iter.
- **NO prover dispatch this iter** — the refactor IS the deliverable.
  PROGRESS.md `## Current Objectives` carries the no-prover marker.

The blueprint side-edit this iter (already landed by the plan-agent
inline):
- **NEW chapter `RigidityKbar.tex`** (~110 LOC of prose) — names
  the project's `AlgebraicGeometry.rigidity_over_kbar` Lean
  declaration with full proof decomposition (C.2.b reduction +
  C.2.c image-dimension dichotomy + C.2.d keystone Mathlib gap +
  C.2.e promotion). References the shared cotangent-vanishing pile
  with the four-piece (i)-(iv) decomposition and per-piece LOC
  estimates. Use sites: M2.b genus-0 witness (iter-127+).
- **`content.tex`** updated to include the new chapter.

The iter-126 plan-agent ALSO revised STRATEGY.md:
- Removed M1 iter-128 exit (c) "named-axiom escalation".
- Resolved M3 escalation in favor of "do the work, no axioms" per
  user hint.
- Pulled iter-130 analogist consult to iter-126.
- Sequencing table re-formatted (iter-range tightened 10–20 → 8–12
  for the shared pile; M2 closure estimate iter-162+ → iter-151+).

## Routes

Single critical-path route (with parallel parked M1):

- **M2.a scaffold → M2.a body → M2.b → M2.c (or skip via over-k
  rigidity alternative) → M2.d-alt (shared cotangent pile) → M2
  closure**. The active iter-126 deliverable is the M2.a scaffold;
  the M2.b scaffold lands iter-127; the shared cotangent-vanishing
  pile is the multi-iter bottleneck (iter-129+).

- **Parked**: M1 bridge in `Differentials.lean` (the iter-128 hard
  trigger forces close or excise).

- **Off-loop**: M3 (positive-genus witness) — Route A vs Route B
  decision per iter-123 audit, but user-hint absorbed in iter-126
  selects "do the work" path; M3 lanes are post-M2.

## References
- `references/summary.md` — the single source (`challenge.lean` by
  Christian Merten).

## Focus areas

- **`RigidityKbar.tex` (NEW this iter)** — verify the proof
  decomposition is correct + the `\lean{AlgebraicGeometry.rigidity_over_kbar}`
  reference is a clean target for the iter-126 refactor. The chapter
  cross-refs `Rigidity.tex` (for the refactored ext_of_eqOnOpen
  lemma) and `Jacobian.tex § C.2.a–C.2.g`. Confirm the cross-refs
  are consistent and the four-piece shared-pile description is
  honest (e.g. piece (iv) Serre duality is NOT used by C.2.d itself,
  only by M2.d-alt — make sure that's correctly disclosed).
- **`Jacobian.tex § C.2.g`** — verify the iter-125-landed phantom-gap
  framing still tracks; specifically the new `RigidityKbar.tex`
  formalization should NOT contradict any C.2 claim. The
  `AbelianVariety.constant_of_P1_map` phantom statement in Jacobian.tex
  C.2.g is referenced from RigidityKbar.tex as the C.2.d Mathlib gap;
  confirm naming consistency.
- **`Rigidity.tex` § "Use in the project"** — the iter-125-landed text
  named M2.a as one of the consumers of `Scheme.Over.ext_of_eqOnOpen`.
  With the new `RigidityKbar.tex` chapter, verify that cross-reference
  still points correctly (now it should reference the new chapter as
  well as the old C.2.b use site in Jacobian.tex).

## Known issues

- Five `\lean{...}`-only references in `Differentials.tex` proof prose
  (`appLE_unitSubmonoid` etc.) still lack dedicated `\begin{lemma}` /
  `\begin{definition}` blocks. With M1 PARKED, this stays carry-forward
  (lower urgency than iter-124 originally framed). The iter-128 hard
  exit decision may resolve this by either excising the helpers (exit b)
  or formalizing them at PR-quality (exit a).
- Legacy label `thm:GrpObj_eq_of_eqOnOpen` in `Rigidity.tex` not yet
  renamed to `thm:Scheme_Over_ext_of_eqOnOpen` (cross-refs still
  resolve; soon item).
- Four orphan chapters (`Modules_Monoidal.tex`,
  `Picard_{LineBundle,Functor,FunctorAb}.tex`) describe Lean files no
  longer in the tree; not in `content.tex`; informational carry-forward.

Per the HARD GATE rule: iter-126 has NO prover dispatch, so no chapter
needs to be "complete: true + correct: true" for an iter-126 prover.
But please confirm:

- `RigidityKbar.tex` is "complete: true + correct: true" so iter-127's
  potential prover lane on `rigidity_over_kbar` body (if scheduled) is
  not blocked by a blueprint gap. (iter-127 is scheduled for M2.b
  scaffold per current STRATEGY, but the iter-127 plan-agent might
  redirect to M2.a body if the iter-126 analogist consult finds
  rapid-build piece options.)
