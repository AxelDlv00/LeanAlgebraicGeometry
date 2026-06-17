# Progress-critic directive — Route C (genus-0 rigidity), iter-164

Assess convergence of the single active route. Fresh-context: do NOT assume the
strategy is sound — only judge whether the route is making forward progress or
churning.

## Active route: Route C genus-0 base case — file `AbelianVarietyRigidity.lean`

The Rigidity Lemma chain closed axiom-clean (iter-162). Since then the route has been
building the Milne §I.3 corollary chain toward "ℙ¹ → A is constant".

### Last 5 iters' signals (this file / route)

| iter | prover status | sorry count (global) | named decls landed (axiom-clean) | helpers added | blocker phrases |
|---|---|---|---|---|---|
| 159 | COMPLETE | (chain) | `hfib` closed (rigidity_eqOn) | 1 | — |
| 160 | COMPLETE | 7 | `morphism_eq_of_eqAt_closedPoints` (Step 2); surfaced signature gap | 1 | "signature gap: needs LocallyOfFiniteType" |
| 161 | COMPLETE | 7 | `eq_comp_of_isAffine_of_properIntegral` (deep algebra); Step-1 reduced | 1 | — |
| 162 | COMPLETE | 6 | `rigidity_eqAt_closedPoint_of_proper_into_affine` (Step 1) + `isIntegral_of_retract`; **whole Rigidity chain DONE** | 2 | — |
| 163 | COMPLETE | 6 | `hom_additive_decomp_of_rigidity` (Cor 1.5) + `av_regularMap_isHom_of_zero` (Cor 1.2) | 2 | — |

Notes for your read:
- Global sorry count has been flat at 6 for iters 162→163 (the 3 deferred genus-0
  scaffolds + 2 in Jacobian.lean + 1 in RigidityKbar.lean). The unit of progress over
  this window is "+N proven named theorems / depth", not sorry-count reduction.
- iter-163 was a route-DECISION iter (committed Route C / Milne §I.3, excised the
  theorem of the cube) AND landed the first 2 corollaries.
- The NEXT frontier (`morphism_Ga_to_av_const`, Prop 3.9 core) depends on an unbuilt,
  Mathlib-unsupported deep lemma `rationalMap_to_av_extends` (Milne Thm 3.2, the
  codim-1 rational-map-extension on a surface, no Mathlib Weil divisors) AND on missing
  infrastructure (a concrete ℙ¹, 𝔾_a/𝔾_m group schemes). Neither `morphism_Ga_to_av_const`
  nor `rationalMap_to_av_extends` exists in Lean yet (blueprint-only).

### Strategy estimate for this route (verbatim from STRATEGY.md "Phases & estimations")

- genus-0 rigidity row: **Iters left ~15–30**; LOC `~3000–5500 · chain done, base-case 0/it`.
- This route entered its current Route-C phase at **iter-163** (1 iter of base-case
  trajectory so far; the Rigidity-chain sub-phase ran iters ~157–162).

### This iter's proposed objective (for your dispatch-sanity check)

The planner proposes NOT to throw a prover at `morphism_Ga_to_av_const` (gated on the
unbuilt riskiest lemma + missing infrastructure + a too-thin blueprint incompatibility
step). Instead: de-risk Thm 3.2 (mathlib-analogist cross-domain consult, in flight),
deepen the blueprint for `lem:hom_from_Ga_trivial` + `lem:rational_map_to_av_extends`,
and run a modest no-regret prover lane on the SAME file (drop auditor-flagged unused
instance hyps from Cor 1.5/Cor 1.2; refresh stale docstrings). 1 file in objectives.

## What I need from you

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with reasons grounded in
the signals above. In particular: is the "+2 proven theorems, flat sorry count" pattern
genuine forward motion or helper-churn? Is the planner's choice to de-risk + deepen the
blueprint THIS iter (rather than push a prover at the gated deep target) the right
response, or is it avoidance? Name the corrective TYPE if CHURNING/STUCK.
