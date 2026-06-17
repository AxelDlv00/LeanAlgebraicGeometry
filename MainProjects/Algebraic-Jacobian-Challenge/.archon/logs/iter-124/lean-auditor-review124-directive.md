# lean-auditor — iter-124 review

## Slug

review124

## Scope

Read-only whole-project audit of all `.lean` files under
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`
(excluding `.lake/` and `lake-packages/`).

This iter the prover made a single substantive edit to
`AlgebraicJacobian/Differentials.lean`: promoted the existing
`forward : Localization M →+* A_colim` to an explicit `AlgHom`
(`forwardAlg`) inside the `suffices AE` block of
`appLE_isLocalization`, closed the `commutes'` field in-body via
`RingHom.congr_fun h_fwd_comp`, and reduced the residual to
`AlgEquiv.ofBijective forwardAlg sorry`. The single residual `sorry`
moved L362 → L398 inside a substantially-expanded comment block
documenting the bijectivity-decomposition blocker analysis.

Also a plan-phase `refactor-deadcode-cleanup-iter124` ran this iter
and deleted:

- `class IsAffineHModuleHomFinite` + 3 consumers in
  `Cohomology/StructureSheafModuleK.lean:458–519` (per iter-123
  lean-auditor must-fix #1).
- The commented-out `OXAsAddCommGrpSheaf / H1OC` sketch + retitled
  the L15–29 status block in `Genus.lean:39–61` (per iter-123
  lean-auditor must-fix #3).

Pay particular attention to:

- `AlgebraicJacobian/Differentials.lean` — verify the new
  `forwardAlg` construction is well-shaped; the `commutes'` proof
  routes through `RingHom.congr_fun` + a definitional identification
  of `algebraMap Γ(S, U) A_colim` with `(appLE_colimRingHom f e).hom`;
  the residual `sorry` at L398 is on `Function.Bijective ⇑forwardAlg`
  inside `AlgEquiv.ofBijective`. Check the surrounding
  ~70-line comment block (L332-L397) — verify it is not an
  excuse-comment and does not invent Mathlib names.
- `Cohomology/StructureSheafModuleK.lean` — verify the
  refactor-deadcode-cleanup landed cleanly; flag any stale
  docstring cross-references to deleted declarations (the plan-agent
  flagged 2 such cross-refs at L494, L847 as left untouched).
- `Genus.lean` — verify the deletion landed cleanly and the
  status-block retitle is past-tense and accurate.

The iter-122 / iter-123 helper declarations remain in place:
`appLE_colimRingHom`, `appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`,
`isUnit_appLE_unitSubmonoid_in_colim`, `kaehler_localization_subsingleton`,
`kaehler_quotient_localization_iso`, `relativeDifferentialsPresheaf_equiv_kaehler_appLE`.

There are 2 sorry sites in the project:
- `Differentials.lean:398` — `AlgEquiv.ofBijective forwardAlg sorry`
  (M1.b body Steps 2 + 3 residual, packaged as bijectivity).
- `Jacobian.lean:179` — `nonempty_jacobianWitness` (project end-state;
  off-limits to the autonomous loop until M2 + M3 land).

Critical pushback is welcome:

- The Differentials L332-L397 comment block declares the Mathlib gap
  is the "filtered-colim bridge + basic-open cofinality" combination.
  Audit whether the cited Mathlib names (`IsPointwiseLeftKanExtensionAt`,
  `CommRingCat.FilteredColimits.colimitCocone`, `IsAffineOpen.exists_basicOpen_le`,
  `IsLocalization.lift_injective_iff`, `IsLocalization.lift_surjective_iff`)
  are actually inert documentation or whether they imply project-side
  bridge work the author has not yet started.
- The `forwardAlg.commutes'` proof closes via
  `exact RingHom.congr_fun h_fwd_comp r` after a `have h := ...`.
  Audit whether the routing is genuinely closed by `rfl`-equality or
  whether it depends on definitional unfolding of `appLE_colimAlgebra`.

## Files to read

Absolute paths:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/SheafCompose.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafAb.lean`

## Known issues (already known — skip)

- The iter-123 lean-auditor flagged 4 must-fix items. Items #1 + #3
  were resolved this iter by the refactor-deadcode-cleanup-iter124.
  Items #2 (`AffineCoverMVSquare` unused-affineness-fields) and #4
  (`Differentials.lean:239` `erw [hmc]` brittle spot) are
  discretionary carry-overs; re-flag only if the situation has
  worsened.
- The Differentials `appLE_isLocalization` residual `sorry` is a
  documented project state, NOT an excuse-comment. The surrounding
  comment block documents iter-125+ closure recipe alternatives;
  audit whether the block has bloated into excuse-territory.

## Output

Standard lean-auditor report at
`task_results/lean-auditor-review124.md`. Per-file checklist +
flagged-issues block grouped by severity.
