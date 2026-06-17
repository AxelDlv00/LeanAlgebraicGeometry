# Progress Critic Report

## Slug
iter144

## Iteration
144

## Routes audited

### Route 1 — Piece (i.b) Step 2 (`AlgebraicJacobian/Cotangent/GrpObj.lean`)

- **Sorry trajectory**: 7 → 7 → 7 → 7 → 6 → 6 across iter-138 to iter-143 (post-decomposition baseline; net 1 closure in 6 iters).
- **Helper accumulation**: 2 helpers added across K=6 iters (iter-138 decomposition of the parent; iter-140 `isIso_of_app_iso_module`) plus 1 structural refactor (iter-143 Wave 2 extracting IsIso into a named theorem, net 0 inline). Strict-count closures: 1 (iter-142 d_map). Helpers ÷ closures over K = 2 ÷ 1 = 2:1, with iters 138/140/141/143 contributing setup without closure.
- **Recurring blockers**:
  - "categorical chase / factoring witness `h`" — appears iter-140, iter-141, iter-143 (3 iters; explicitly catalogued in `analogies/d-app-d-map-recipe-shape.md` Decision 2 NEEDS_MATHLIB_GAP_FILL).
  - "per-open IsIso identification" — appears iter-139, iter-140, iter-143 (3 iters; partially relieved iter-143 by Wave 2 extraction but still load-bearing for the d_app body).
  - "type-coercion via Pushforward.comp_eq + eqToHom" — NEW iter-143 (1 iter, but the explicit terminal failure node of the iter-143 PARTIAL).
- **Prover status pattern**: PARTIAL (138), plan-only (139), PARTIAL (140), plan-only (141), PARTIAL-with-strict-closure (142), PARTIAL (143). Four PARTIALs out of 6 iters, with two plan-only iters (139, 141) where CHURNING-trigger deferral was preemptively invoked.
- **Verdict**: **CHURNING**.
- **Primary corrective**: **Mathlib analogy consult** (sixth on this route) narrowly scoped to the iter-143 terminal-failure pattern — `Pushforward.comp_eq` + `eqToHom`-quotiented identification of `(pushforward (f ≫ g)).obj M` with `(pushforward g).obj ((pushforward f).obj M)` on the `d_app` sub-sorry. The verbatim CHURNING rule fires twice (helper-vs-residual clause partially mitigated by iter-143 Wave 2 structural refactor, but the PARTIAL ≥3-of-K clause fires cleanly with 4-of-6 PARTIAL). Of the candidate corrective types, this one is uniquely matched to iter-143's narration: the recipe is empirically validated (iter-141 ALIGN_WITH_MATHLIB `pushforward_obj_map_apply'` + `NatTrans.naturality_apply` recipe closed d_map iter-142 substantively), so a further blueprint sub-decomposition would re-budget LOC against an already-validated proof shape (wrong tool); a route pivot would invalidate the 600 LOC + 5 consults already invested in the validated recipe (premature given iter-142 strict-count signal); a structural refactor of the kind iter-143 did (extract-to-named-theorem) does not address `eqToHom` token-level Lean type-coercion, which is intrinsically a Mathlib-idiom question, not a Mathlib-API question. The iter-143 prover's narration narrows the consult's scope precisely.
- **Secondary correctives**: Conditional. *If* the consult returns NEEDS_MATHLIB_GAP_FILL or NO_KNOWN_IDIOM (i.e., Mathlib does not standardly handle this `Pushforward.comp_eq` type-coercion pattern), then iter-144's prover round must NOT be issued; instead promote to **structural refactor** (extract a `change`-free per-step lemma `d_app_of_comp_pushforward` named alongside the iter-143 IsIso extraction). *Only if* the consult returns NEEDS_USER_ESCALATION should escalation occur — premature now.

### Route 2 — Piece (i.b) Step 2 IsIso `basechange_along_proj_two_inv_app_isIso` (extracted iter-143)

- **Sorry trajectory**: extracted iter-143 (1 named-decl sorry); no prior data.
- **Helper accumulation**: 0 closure attempts.
- **Recurring blockers**: none yet — single iter.
- **Prover status pattern**: not yet attempted (extracted-then-deferred).
- **Verdict**: **UNCLEAR** (fresh route, < K iters of data; the rules explicitly tag a single data point as UNCLEAR).
- Watch on iter-144+: the iter-143 Wave 2 refactor moved this from an inline letI-sorry into its own named declaration with bundled Route (b'2) items 2–4 (~195–365 LOC). First prover attempt iter-144 (if scheduled) will produce the first signal. No corrective needed yet.

### Route 3 — All other files (off-critical-path)

- **Sorry trajectory**: stable scaffold-only.
- **Helper accumulation**: 0.
- **Recurring blockers**: none on these files; both `Jacobian.lean` `genusZeroWitness` / `positiveGenusWitness` and `RigidityKbar.lean` `rigidity_over_kbar` are gated downstream (M2.a + M3) on Route 1's resolution, by design.
- **Prover status pattern**: no attempts in K iters (correctly deferred).
- **Verdict**: **CONVERGING** (SCAFFOLD-trivially; no prover dispatches expected until upstream unblocks).

## Must-fix-this-iter

- Route 1 (Piece (i.b) Step 2 d_app sub-sorry): **CHURNING** — primary corrective: **Mathlib analogy consult on `Pushforward.comp_eq` / `eqToHom` type-coercion pattern**, narrowly scoped per the iter-143 prover's terminal-failure narration. Why: PARTIAL ≥3-of-K verbatim clause fires (4/6 PARTIAL), and Wave 2 structural refactor (iter-143) addressed IsIso but did not touch the d_app type-coercion blocker, so the route entering iter-144 still has its load-bearing failure node un-investigated by Mathlib-idiom search. The iter-142 strict-count closure on d_map (recipe-validated) blocks the STUCK verdict but not CHURNING.

### On the sub-question (does iter-143's narration matter for CHURNING/STUCK threshold?)

It matters substantively, not just narratively. The K-iter signal trajectory says "PARTIAL ≥3-of-K" → CHURNING. But the corrective TYPE depends on *what kind* of PARTIAL: a strategy-level PARTIAL would call for route pivot, a math-level PARTIAL for blueprint expansion, a Mathlib-API-level PARTIAL for analogy consult on the API, and a Lean-type-coercion-level PARTIAL for analogy consult on the **idiom**. Iter-143 narrows it to the last category — which is why a 6th consult is not duplicative (the prior 5 consults targeted API/recipe alignment, not `eqToHom` token-level coercion). If the narration were absent, my recommendation would default to either a 6th consult or a structural sub-decomposition; the narration disambiguates to the consult with a precise prompt.

### On the iter-143 pre-committed CHURNING-CONFIRMED corrective sufficiency

Wave 2 (IsIso extraction + blueprint +285 LOC) was **structurally sufficient for the IsIso route** (audit transparency restored, Route 2 now separately trackable) but **not sufficient for the d_app residual**. The d_app failure node is orthogonal to the IsIso extraction's structural goal. Iter-144 needs additional corrective action — specifically the type-coercion-focused consult named above, not a further structural refactor.

## Acceptance signal pre-commitment

If the planner accepts this CHURNING verdict and dispatches the corrective:

- **PASS arm** (consult returns concrete `eqToHom` / `Pushforward.comp_eq` idiom + iter-144 prover attempt closes d_app substantively): counter 3→2; route returns to CONVERGING; iter-145+ resumes on Route 1 mainline.
- **PARTIAL arm** (consult returns idiom + iter-144 prover attempt makes the d_app type-coercion compile but a new sub-blocker surfaces inside the closure): counter 3→4; one more iter of margin before breakeven-5; flag for STUCK pre-commitment iter-145.
- **FAIL arm** (consult returns NO_KNOWN_IDIOM, i.e., Mathlib does not handle this `Pushforward.comp_eq` pattern with a clean idiom): counter 3→5; **breakeven fires**. Mandatory route pivot iter-145 — extract `d_app_of_comp_pushforward` as a separate named obligation and pursue it as an isolated proof-engineering sub-route, OR widen the strategy envelope (mid-iter strategy-critic) to consider whether the `basechange_along_proj_two_inv_derivation` derivation construction should be re-routed through a `Module.HasDerivation`-style API instead of the current `pushforward`-composite shape.

## Informational

- Route 2 (IsIso extracted iter-143): UNCLEAR; watch for first prover attempt iter-144.
- Route 3 (Jacobian.lean / RigidityKbar.lean): CONVERGING-SCAFFOLD-trivially; no action this iter.

## Overall verdict

One CHURNING route (Route 1 — Piece (i.b) Step 2 d_app), one UNCLEAR route (Route 2 — IsIso extracted iter-143), one CONVERGING-trivially route (Route 3 — off-critical-path scaffolds). The iter-144 plan should commit to a Mathlib-analogist consult narrowly scoped to the iter-143-identified `Pushforward.comp_eq` / `eqToHom` type-coercion pattern on the d_app sub-sorry **before** dispatching a prover round on Route 1; if consult-output validates a known idiom, then bundle Route 1's d_app retry with Route 2's first IsIso attempt; if consult-output reports NO_KNOWN_IDIOM, pre-commit iter-145 route pivot per the FAIL arm above. The K=6 PARTIAL-dominant trajectory means the planner cannot silently issue another prover round without the corrective without falling foul of the CHURNING gate.
