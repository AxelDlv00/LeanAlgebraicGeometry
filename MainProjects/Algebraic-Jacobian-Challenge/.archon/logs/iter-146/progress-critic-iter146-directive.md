# Progress Critic Directive

## Slug
iter146

## Iter
146

## Active routes / files under review

### Route: chart-algebra piece (ii) — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

- **Started at iter**: 145 (file scaffolded by `refactor-chart-algebra-skeleton-bundled-excise-iter145`)
- **Iters audited**: iter-141 to iter-145 (chart-algebra prep + iter-144 commitment + iter-145 scaffold). Note: pre-iter-144 the route did not exist; iters 141–143 carry signal from the bundled-route precursor that the chart-algebra route REPLACES (those are folded in for trajectory context).

#### Sorry counts per iter
- iter-141: 5 (project-wide); 0 on this route (the route didn't exist)
- iter-142: 6 (project-wide); 0 on this route
- iter-143: 6 (project-wide); 0 on this route (Wave 2 named-theorem extraction landed in `Cotangent/GrpObj.lean` but on the bundled route)
- iter-144: 6 (project-wide); 0 on this route (plan-only iter; chart-algebra pivot COMMITTED)
- iter-145: 8 (project-wide); 5 on this route (NEW `Cotangent/ChartAlgebra.lean` file with 5 `: True := sorry` placeholders authorised by the iter-145 refactor directive)

#### Helpers added per iter
- iter-141: 0 on this route
- iter-142: 0
- iter-143: 1 on the bundled-route precursor (extracted named theorem `basechange_along_proj_two_inv_app_isIso`; NOT on this route)
- iter-144: 0 (plan-only)
- iter-145: 5 NEW sorry-bodied scaffolds (`algebra_isPushout_of_affine_product`, `df_zero_factors_through_constant_on_chart`, `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, `constants_integral_over_base_field`, `ext_of_diff_zero`) in a NEW file; +0 helpers on the existing piece (i.a) DONE trio

#### Prover statuses per iter
- iter-141: N/A on this route (route didn't exist)
- iter-142: N/A
- iter-143: N/A
- iter-144: N/A (plan-only iter, no prover)
- iter-145: N/A (plan-only iter at the prover level; refactor subagent landed Lean file structure)

#### Recurring blocker phrases
- None on this route — route is brand-new iter-145. The bundled-route precursor (iter-138 → iter-143) carried phrases like "`Pushforward.comp_eq` + `eqToHom` type-coercion", "Step 3.b → 3.d chase blocked"; those do NOT carry forward to the chart-algebra route (chart-algebra works per-chart on affine ring data, structurally avoiding the categorical type-coercion chase).

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** for this route: piece (ii) chart-algebra envelope **600–1050 LOC over ~5–7 iter** (iter-146→iter-152 expected per the iter-144 pivot commitment in § Sequencing).
- **Elapsed iters in current phase**: 1 (iter-145 was the scaffold-landing iter; iter-146 is the first prover-attempt iter).
- **Phase started at iter**: 145.

#### Planner's current proposal for this iter

Iter-146 plans to dispatch a single prover lane on `Cotangent/ChartAlgebra.lean`
scoped to the **3 blueprint-adequate sub-pieces** per
`lean-vs-blueprint-checker-chart-algebra-review145`:
1. `algebra_isPushout_of_affine_product` (α) — smallest +
   foundational, ~80–150 LOC.
2. `constants_integral_over_base_field` — standalone, ~50–100 LOC.
3. `Scheme.Over.ext_of_diff_zero` — scheme-level packaging, ~100–150
   LOC.

The other two sub-pieces (`df_zero_factors_through_constant_on_chart`
β-core and `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
algebra-level core) defer to iter-147+ pending a blueprint-writer
absorption of the iter-145 lean-vs-blueprint-checker's two majors on
the char-`p` (p1)+(p3) substeps of KDM (Q-major #1+#2 in that report).

The first prover iter on `Cotangent/ChartAlgebra.lean` will need to
refine the `: True` placeholder signatures to the real shapes per the
blueprint sketches; this is a deliberate iter-145 choice (the
iter-128–iter-131 cotangent body-shape refactor cautionary tale on
committing wrong signatures).

### Route: off-critical-path scaffolds — `Jacobian.lean` + `RigidityKbar.lean`

- **Started at iter**: scaffold ages: `rigidity_over_kbar` iter-126,
  `genusZeroWitness` iter-127, `positiveGenusWitness` iter-134.
- **Iters audited**: iter-141 to iter-145.

#### Sorry counts per iter
- iter-141..iter-145: 3, 3, 3, 3, 3 (`Jacobian.lean` L197 + L223 +
  `RigidityKbar.lean` L87; UNCHANGED).

#### Helpers added per iter
- None of these scaffolds changed in iter-141..iter-145.

#### Prover statuses per iter
- N/A — all three scaffolds are OFF-LIMITS during this period
  (gated on M2.a body / chart-algebra piece (ii) for `rigidity_over_kbar`
  and `genusZeroWitness`; gated on M3 Route A for `positiveGenusWitness`).

#### Recurring blocker phrases
- None.

#### Strategy estimate vs reality
- **`Iters left`** per STRATEGY.md § Sequencing: `rigidity_over_kbar` body
  iter-149+ revised; `genusZeroWitness` body iter-151+ revised;
  `positiveGenusWitness` body iter-160+ (off-critical-path; bounded by
  M3 Route A multi-tens-of-iters).
- **Elapsed iters in current phase** (since the iter-144 chart-algebra
  pivot reset the M2.a target from iter-145 to iter-149): 1 (iter-145).
- **Phase started at iter**: 144 (chart-algebra pivot landed; M2.a body
  iter target revised from earlier framings).

#### Planner's current proposal for this iter
NONE — all three scaffolds remain OFF-LIMITS iter-146 (their bodies
depend on chart-algebra piece (ii) closure, which is iter-146+ in flight).

## PROGRESS.md proposal (this iter)

The planner's `## Current Objectives` list it is about to commit:

- **File count**: 1
- **Files**: `Cotangent/ChartAlgebra.lean`
- **Dispatch cap (from --max-objectives)**: 10

The single-file dispatch reflects the strict "1 file = 1 prover" rule:
all 5 ChartAlgebra sub-pieces live in one Lean file, so the prover
lane is 1 lane with 3 of 5 sub-piece sorries listed as ready (the
other 2 defer to iter-147+ blueprint-writer absorption).

## Out of scope

- M3 Route A — committed iter-144 but iter-146+ scheduling is "behind
  M2 critical path"; not iter-146 work.
- Bundled-route piece (i.b)+(i.c)+(iii) — DESCOPED iter-145; deleted
  from `Cotangent/GrpObj.lean` via excise; explicitly NOT a route
  under review here.
- The 5 orphan helpers in `Cotangent/GrpObj.lean` (`shearMulRight` +
  `_hom_fst`/`_hom_snd`, `schemeHomRingCompatibility`,
  `isIso_of_app_iso_module`, `relativeDifferentialsPresheaf_restrict_along_identity_section`).
  These are housekeeping; not a route under review.
- STRATEGY.md compaction (Q5 deferred from iter-145).
