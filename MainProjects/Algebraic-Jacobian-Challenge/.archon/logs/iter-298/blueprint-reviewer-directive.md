# Blueprint Reviewer Directive

## Slug
wireup-298

## Task
Standard whole-blueprint audit (per-chapter completeness + correctness checklist), PLUS a
focused dependency/isolation analysis. The user has flagged that the dependency graph is NOT one
cone: it has 74 weak components — 1 main goal cone (768 nodes), 54 isolated lean-aux singletons,
and **19 secondary multi-node clusters** that are not wired into the goal cone.

## Priority: the `### Dependency & isolation findings` section
This iteration's primary need is your authoritative **wire-up map**. For each isolated node and
each disconnected cluster, tell me the concrete missing `\uses{}` edge: which DOWNSTREAM consumer
declaration (by label) should `\uses` the cluster's exit declaration, so the cluster connects into
the goal cone. Tag each `wire-up` (add the edge), `remove` (dead scaffolding), or `keep`.

The 5 chapters whose declarations are **entirely off the goal cone** (0 nodes reach the goal) are
the most important — for each, name the consumer in another chapter that should depend on it:
- **Cohomology_FlatBaseChange** (flat base change of `R^0 f_*`, `pushforward_base_change_map`,
  `gammaPushforwardIso`, `base_change_map_affine_local`) + **Cohomology_HigherDirectImage**
  (`higher_direct_image`) — which Picard / cohomology theorem consumes these?
- **Cohomology_CechHigherDirectImage** (`cech_higher_direct_image`, `push_pull_map`,
  `relative_cech_complex_of_nerve`) — consumer?
- **Picard_RelativeSpec** (`relspec_*`, `qc_sheaf_of_algebras`) — consumed by FGAPic
  representability / RelPicFunctor?
- **Picard_SheafOverEquivalence** (`sheafofmodules_over_equivalence`, `chart_over_iso`,
  `restrict_over_iso`, `unit_over_iso`, `phi_over`, `psi_over`, the continuity defs) — consumed by
  the TensorObjSubstrate dual / `dual_restrict_iso` / `chartOverIso` route?
- **The relative cotangent presheaf** (`kaehler_localization_subsingleton`,
  `kaehler_quotient_localization_iso`) — consumer?

For each, give the exact consumer label and the exact `\uses{}` line to add. If a chapter's
results genuinely feed nothing in the goal cone (true dead scaffolding), say `remove` and justify.

## Also report (standard)
- Per-chapter `complete` / `correct` verdict and must-fix-this-iter findings.
- Your `## Unstarted-phase blueprint proposals` if any strategy phase lacks coverage.

## Context
- Goal declarations: `AlgebraicGeometry.Jacobian` (+ instances), `AlgebraicGeometry.genus`,
  `AlgebraicGeometry.Jacobian.ofCurve` (these are the roots of the goal cone).
- Note: chapters `Picard_TensorObjSubstrate`, `Albanese_CodimOneExtension`,
  `AbelianVarietyRigidity`, `Rigidity`, `Albanese_AuslanderBuchsbaum`, `RiemannRoch_OCofP` are being
  wired this iteration by dag-walkers — you may still report their state but they are in flight.
