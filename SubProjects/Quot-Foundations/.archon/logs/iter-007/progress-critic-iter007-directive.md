# Progress-critic directive — iter-007

Assess convergence of the two active prover routes (FBC-A, GF-alg) over the last K=4 iters
(iter-003 .. iter-006; iter-005 was a dag/blueprint stage with NO prover phase). Then sanity-check
the planner's iter-007 dispatch proposal.

## Route: FBC-A — AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- STRATEGY: phase ACTIVE; Iters-left estimate = 3–5; entered ACTIVE ~iter-002.
- Signals:
  - iter-003: sorry started ~3. Landed L1/L2/L3 axiom-clean + mate lemma assembled modulo L4. status PARTIAL.
  - iter-004: sorry 3→4. Closed L4-a core (`base_change_regroup_linearEquiv`) + L4-c (`generator_trace`). +2 helpers. status PARTIAL.
  - iter-005: NO prover (dag stage).
  - iter-006: sorry 4→4. Deployed the "separate-module one-liner" corrective for `map_smul'` — it FAILED and was found MATHEMATICALLY UNSOUND (A-module tensor-carrier type incompatibility, not a reducibility diamond). `generator_trace_eq` got an `ext x` structural reduction (axiom-clean) but the per-generator identity remains sorry. +0 net helpers, sorry unchanged. status PARTIAL.
  - Recurring blocker phrases: "Mathlib-absent mate-unwinding coherence over the generic pullback square"; "opaque-instance wall (letI inferInstanceAs ⇒ no SMulZeroClass synthesis)"; iter-006 refuted the 2-iter-carried "one-liner closes it" hypothesis.

## Route: GF-alg — AlgebraicJacobian/Picard/FlatteningStratification.lean
- STRATEGY: phase ACTIVE; Iters-left estimate = 3–5; entered ACTIVE ~iter-003.
- Signals:
  - iter-003: landed L1 (torsion) + L5 base case d=0 axiom-clean.
  - iter-004: sorry 5→4. Closed the full L3 chain (4 lemmas) axiom-clean. status PARTIAL.
  - iter-005: NO prover (dag stage).
  - iter-006: sorry 4→4. Landed the named CHURNING corrective — L5 restructured to `Nat.strong_induction_on generalizing N` (IH now in scope), axiom-clean skeleton. Generic-rank SES dévissage residue remains sorry. status PARTIAL.
  - Recurring blocker phrases: "generic-rank SES `0→A_g[X]^m→N_g→T→0` Mathlib-absent"; "denominator-clearing descent Mathlib-absent (L4)".

## Planner's iter-007 dispatch proposal (for dispatch-sanity check)
- DEFER both FBC-A and GF-alg prover lanes this iter. Reason: both residues are now monolithic
  Mathlib-absent constructions; both file/blueprint checkers this iter recommend EFFORT-BREAK into
  named sub-lemmas BEFORE re-dispatching a prover (FBC chapter carries a must-fix on the
  `base_change_mate_regroupEquiv` proof prescription; GF chapter is under-specified for both residues).
  Corrective being deployed THIS iter: dispatch blueprint-writers to decompose both cruxes into
  sub-lemma chains (FBC: fix regroupEquiv prescription + split generator_trace_eq into A/B/C;
  GF: extract L4 denominator-clearing + L5 generic-rank-SES + T-reindex sub-lemmas).
- Open a THIRD parallel prover lane on the QUOT-defs frontier (gate-cleared, blueprint complete+correct):
  2 lanes — `Picard/QuotScheme.lean` (build defs `Scheme.Modules.annihilator`,
  `SheafOfModules.IsLocallyFreeOfRank`, `sectionGradedRing`) and new `Picard/GrassmannianCells.lean`
  (build `Grassmannian.affineChart`), both `[prover-mode: mathlib-build]`.

## What I need from you
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the named corrective TYPE for any
CHURNING/STUCK. Specifically: is "defer prover + effort-break the blueprint cruxes this iter" the
right response to the FBC-A and GF-alg trajectories, or are you seeing a different failure mode
(e.g. a route that should pivot rather than decompose)? And is opening the QUOT scaffold lanes a
sound use of this iter's prover budget given FBC/GF are paused for blueprint work?
