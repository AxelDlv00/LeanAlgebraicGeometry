# progress-critic directive — iter-247

Assess convergence per active route. Two routes are under consideration for this iter's prover dispatch.

## Route 1 — Lane TS: `Picard/TensorObjSubstrate.lean` (A.1.c.sub, critical path)

Goal of the route: build the pullback–tensor comparison iso on locally-trivial line bundles
(`f^*(M⊗N) ≅ f^*M ⊗ f^*N`), the substrate prerequisite for `IsInvertible.pullback`. Since iter-245 the
route funnels every remaining target through one reduction brick to a single goal shape
`IsIso (a_Y.map δ)`.

Phase entry (loc-triv chart-chase route): iter-245. STRATEGY `Iters left` for A.1.c.sub: ~7–15.

Last 5 iters' signals:
- iter-242: status PARTIAL. 2 axiom-clean decls (presheaf lax/oplax monoidal instances). Blocker phrase: "concrete-P pullbackTensorIso confirmed Mathlib-scale".
- iter-243: status PARTIAL. Pivot to local-trivialization route. Helpers landed (loc-triv preservation bricks).
- iter-244: status PARTIAL. 7 axiom-clean decls (D1 `pullbackLanDecomposition` + carriers/adjunctions). Blocker phrase: "general strong-monoidal build D2/D3 Mathlib-scale (20–38 iters)".
- iter-245: status PARTIAL. 2 axiom-clean decls (reduction brick `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` + helper). Effect: collapses all remaining targets to one goal `IsIso (a_Y.map δ)`.
- iter-246: status PARTIAL. 4 axiom-clean decls (D2' δ-wrapping `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`, assembly, converse W-lemma, `sheafifyUnitIso`). Residual: the η-bridge `IsIso (a_Y.map (η (pullback φ')))`, REDUCED to a precise concrete transposed pushforward-side mate identity with all Mathlib glue lemmas named. Prover states the residual is "API mate-calculus, the unit-side analog of the PROVEN `pullbackObjUnitToUnit_comp`, NOT a new Mathlib-absent blocker".

Sorry count in file: flat at 2 across all 5 iters (two deferred sorries `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`, untouched by guardrail).

ts246 pre-set diagnostic for THIS iter: "did a named D2'→D4' brick land?" (CONVERGING) vs "did D2' produce a NEW Mathlib-absent blocker?" (CHURNING). Evaluate against the iter-246 outcome above.

This iter's proposed objective: continue Lane TS — build the η-bridge (the named concrete residual, ~60–120 LOC mate chase), then D3'/D4' as reachable.

## Route 2 — Lane RPF: `Picard/RelPicFunctor.lean` (A.1.c.fun)

Goal of the route: build `PicSharp.addCommGroup` (the relative-Picard group law on locally-trivial
iso-classes) + upgrade `functorial`.

Phase entry: iter-246 (route opened last iter). STRATEGY `Iters left` for A.1.c.fun: ~7–12.

Last 1 iter's signals:
- iter-246: status PARTIAL. Opened in parallel. The dispatched recipe ("cite TensorObjSubstrate decls") was INFEASIBLE — `TensorObjSubstrate.lean` imports `RelPicFunctor` (import cycle), so the substrate is downstream and unreachable. Prover built a genuine `AddCommGroup` from a LOCAL pure-Mathlib copy modulo 4 named typed-sorry bridges. Sorry count 1→4. Prover's own assessment + iter-246 review: "the wrong fix — fragile downstream-duplication; correct sequencing is architecture-first (relocate the substrate upstream), then RPF."

This iter's proposed objective: the planner intends to FIRST break the import cycle via a refactor
(split the core tensor substrate into an upstream `Core.lean`, flip the import so RPF is downstream and
can cite the real Core decls), THEN dispatch the RPF prover to rebuild `addCommGroup` citing real
upstream decls (bridges collapse to one project-deferred sorry `exists_tensorObj_inverse` + a typed
bridge on the not-yet-landed D4' comparison iso).

## What I need from you
- Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the signals you base it on.
- For Lane TS: is the "bricks land every iter but file sorry-count is flat for 8 iters" pattern genuine
  convergence or disguised churn? Is the η-bridge residual a real next step or another rotation?
- For Lane RPF: is the planner's architecture-first sequencing (refactor THEN re-dispatch, same iter) the
  right corrective, or does the 1-iter-old route need a different call?
- Dispatch-sanity: 2 files (TensorObjSubstrate.lean, RelPicFunctor.lean) gated behind a same-iter refactor.
