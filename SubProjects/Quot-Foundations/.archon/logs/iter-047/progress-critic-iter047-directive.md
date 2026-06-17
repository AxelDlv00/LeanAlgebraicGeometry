# Progress critic — iter-047

Per-route convergence verdict. Routes the planner is considering for THIS iter's prover dispatch.

## Route A — GF G1 base case (Picard/FlatteningStratification.lean) [NEW prover lane]
Strategy phase: GF-geo. Entered current (base-case) phase at iter-046. Iters-left estimate: 2–4.
Signals (last 5 iters):
- iter-042..044: QUOT gap2 work (different file; unblocks GF by import).
- iter-045: GF locality half DONE — +2 axiom-clean defs (`gf_finite_sections_of_basicOpen_finite_cover`,
  `finite_localizedModule_of_isLocalizedModule`); first cross-leaf import landed. PARTIAL (base case blocked).
- iter-046: GF base case effort-broken into 3 seams in blueprint (no Lean — blueprint-prep only). 0 prover.
- Proposed iter-047: build seam 1 `gf_finiteType_affine_finite_cover_generated` (decl does NOT exist yet;
  mathlib-build), as far as it goes. sorry count in file: 1 (`genericFlatness`, downstream, untouched).

## Route B — SNAP section-graded-ring (Picard/SectionGradedRing.lean — NEW file) [NEW scaffold lane]
Strategy phase: SNAP-S1/S3. Entered current phase: blueprint authored iter-046. Iters-left: 3–6.
Signals: iter-046 = new chapter `Picard_SectionGradedRing.tex` authored (blueprint-prep). File does not
exist. Proposed iter-047: scaffold the file (decls + sorry bodies) from the 3-layer chapter.

## Route C — FBC keystone (FlatBaseChange.lean) [PARKED — NOT dispatching]
Strategy phase: FBC-A1. Entered: iter-037. Iters-left: parked. Signals: iter-044 adjL/hunitL landed;
iter-045 keystoneAdjR/keystoneBeta/huce built axiom-clean (structural unknowns resolved) but keystone NOT
closed → PARKED per armed kill-criterion (off critical path). iter-046: untouched. NOT proposed for dispatch.

## Route D — QUOT annihilator (QuotScheme.lean) [JUST COMPLETED iter-046]
Signals: iter-046 +2 axiom-clean decls (`annihilator_map_basicOpen`, `annihilator_ideal`); 0 new sorry;
objective delivered. Route closing out (P2 residue remains, small). NOT a churn concern.

## Planner's proposed `## Current Objectives` for iter-047 (pending blueprint-reviewer gate clear)
2 files: `Picard/FlatteningStratification.lean` (build GF seam 1, mathlib-build) +
`Picard/SectionGradedRing.lean` (scaffold new file). FBC parked, QUOT annihilator done.

Verdict per route + dispatch-sanity check on the 2-file proposal. Is opening GF + SNAP as
the two lanes (vs more, vs fewer) sound, or is either route churning/under-prepared?
