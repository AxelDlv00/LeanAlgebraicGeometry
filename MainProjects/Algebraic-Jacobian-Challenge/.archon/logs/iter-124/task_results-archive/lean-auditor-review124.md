# Lean Audit Report

## Slug

review124

## Iteration

124

## Scope

- files audited: 10
- files skipped: 0

The 10 `.lean` files under `AlgebraicJacobian/`:

1. `AbelJacobi.lean`
2. `Differentials.lean`
3. `Genus.lean`
4. `Jacobian.lean`
5. `Rigidity.lean`
6. `Cohomology/MayerVietorisCore.lean`
7. `Cohomology/MayerVietorisCover.lean`
8. `Cohomology/SheafCompose.lean`
9. `Cohomology/StructureSheafAb.lean`
10. `Cohomology/StructureSheafModuleK.lean`

## Per-file checklist

### AlgebraicJacobian/AbelJacobi.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is clean. Three protected declarations `Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` are all closed via projection from `(jacobianWitness C).isAlbaneseFor P`. Status block at L13-29 accurately describes the iter-073 refactor and the absorption of genus-0 rigidity into `nonempty_jacobianWitness`.

### AlgebraicJacobian/Differentials.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 1 (L398 `:= sorry` packaged as `AlgEquiv.ofBijective forwardAlg sorry`)
- **bad practices**: 1 carry-over (L239 `erw [hmc]`, unchanged from iter-123)
- **excuse-comments**: 0 (the L332-L397 block is documentary, not an excuse-comment; see notes)
- **notes**:
  - L398: residual `sorry` on `Function.Bijective ⇑forwardAlg`. Packages Steps 2+3 of the M1.b bridge proof. Per the directive, this is the documented project state of `appLE_isLocalization`, not a "TODO replace later" excuse.
  - L322-L398: the surrounding comment block is ~75 lines. I audited it against the excuse-comment rule and conclude it does NOT meet the must-fix bar — the content is substantive (it describes a concrete mathematical plan for closing the bijectivity claim, naming the inductive structure of the INJECTIVITY/SURJECTIVITY arguments and the precise Mathlib gap). However, the block has bloated significantly in iter-124 and contains iter-loop narrative that does not belong in production Lean: the phrases "Strategy this iter (iter-124)" (L334), "Mathlib b80f227" commit-hash citation (L335), "the iter-125+ prover lane would need to assemble" (L395), and "the iter-125 pivot to M2.a fires per the strategy-critic-iter124 sharpened commitment" (L396-397) leak prover-loop and review-loop context into the source. These will read as stale or meaningless to anyone outside iter-124, and the strategy-critic reference is a particularly tight coupling between Lean source and ephemeral planning state. Flagged as **major**: not must-fix, but should be trimmed when the sorry resolves (or in a follow-up cleanup pass).
  - L379-L397: the BLOCKER block cites the Mathlib names `IsPointwiseLeftKanExtensionAt`, `Functor.LeftExtension.IsPointwiseLeftKanExtensionAt`, `CommRingCat.FilteredColimits.colimitCocone`, `IsAffineOpen.exists_basicOpen_le`. Each is cited as inert documentation describing what *would be required* to close the bijectivity, not as a name the code actually invokes. The names are accurate (I verified that `IsPointwiseLeftKanExtensionAt` and `CommRingCat.FilteredColimits` exist in current Mathlib namespaces). The block does NOT imply unstarted project-side bridge work has been invented — the author correctly identifies the gap as "Neither (a) nor (b) has an off-the-shelf Mathlib closer" (L392).
  - L345-L354: `forwardAlg` AlgHom construction. Routing of the `commutes'` proof via `RingHom.congr_fun h_fwd_comp r` (L351-L354) is well-shaped. The proof closes because `appLE_colimAlgebra := (appLE_colimRingHom f e).hom.toAlgebra` (L106-L110) is `@[reducible]`, which lets the `algebraMap Γ(S, U) A_colim` definitionally unfold to `(appLE_colimRingHom f e).hom`. This routing is genuinely closed by definitional equality of `RingHom.toAlgebra`'s `algebraMap`, not by any non-trivial transport. The closure is honest.
  - L239: `erw [hmc]` (iter-123 carry-over). The brittleness is real (using `erw` instead of `rw`/`simp only` makes the proof sensitive to definitional unfolding of the pullback functor `map_comp`), but the situation is unchanged from iter-123. Per directive instructions, not re-flagging unless worsened.
  - L451-L484 `relativeDifferentialsPresheaf_equiv_kaehler_appLE`: substantive docstring is accurate; cites `appLE_isLocalization` as having "the remaining open work item" — this is honest project-state documentation, not an excuse.
  - L519-L572 `smooth_locally_free_omega`: long docstring including a converse-direction disclosure ("the reverse direction... is mathematically false"). This is mathematically scrupulous and well-placed — it warns consumers that the named theorem is genuinely one-directional.

### AlgebraicJacobian/Genus.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is clean post-cleanup. L14-29 status block ("Status (closed iteration 011 — `genus`)") is past-tense and accurate. The commented-out `OXAsAddCommGrpSheaf / H1OC` sketch that iter-123 flagged for deletion is gone — verified by reading the full file (46 lines).
  - L40-43 `genus` body `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` is the honest mathematical definition.

### AlgebraicJacobian/Jacobian.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 1 (L179 `nonempty_jacobianWitness := sorry`)
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L179: `sorry`. Per directive, this is the project end-state sorry, off-limits to the autonomous loop. The L162-L175 docstring is honest about this: classifies the sorry as packaging "all five protected sorries... into a single existence hypothesis" and explicitly defers to "a future iteration" pending Mathlib infrastructure (quotients of schemes by finite group actions; FGA representability). This is documented architectural deferral, not an excuse-comment.
  - L31-39 forbidden-shortcut block correctly documents why `Jacobian C := 𝟙_ _` would force `genus C = 0`, which is mathematically wrong. Good defensive comment.

### AlgebraicJacobian/Rigidity.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is clean. L38-69 hypothesis-correction block explains why the original point-wise hypothesis was wrong (Frobenius counterexample), then states the correction. This is mathematically substantive and accurate — exactly the kind of "why" comment that justifies its existence.
  - L62-67 carry-over: the unused `[GrpObj X]`, `[GrpObj Y]`, `[SmoothOfRelativeDimension n/m _]`, `[IsProper X.hom]`, `[GeometricallyIrreducible Y.hom]` typeclass hypotheses on `GrpObj.eq_of_eqOnOpen` are kept "to preserve the declaration's 'abelian-variety' intent and forward-compatibility". This is borderline: those hypotheses are explicitly noted as redundant. Carrying redundant typeclasses adds a small synthesis cost at every call site. Flagged as **minor** — keep an eye on whether downstream callers actually exercise the abelian-variety intent, and if not, remove these on a future cleanup pass.

### AlgebraicJacobian/Cohomology/SheafCompose.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Single instance file, cleanly closed.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Three instances, all honestly closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - The iter-124 deletion of `class IsAffineHModuleHomFinite` + 3 consumers landed cleanly. I grep'd the project for `IsAffineHModuleHomFinite` and got ONE hit: L45 of this file, which is the historical-note paragraph (file header) explicitly documenting the deletion. That's intentional — it's a "dead-scaffolding rationale" note, not a stale cross-reference. The directive's claim that "the plan-agent flagged 2 such cross-refs at L494, L847 as left untouched" appears inaccurate — L494 is the docstring of `module_finite_HModule_zero_of_isHModuleHomFinite` and contains no reference to the deleted class, and L847 does not exist (file has 877 lines, but L847 is inside a curve-specialization `theorem` that references only the (still-extant) classes `IsCechAcyclicCover` and `HasCechToHModuleIso`). No action needed; the deletion is clean.
  - L43-48 file-header historical note about the deleted variant is mathematically substantive: it explains *why* the per-affine-open variant was abandoned (on a proper smooth curve, $\Gamma(U_i, O_{\mathbb{P}^1}) = k[t]$ is infinite over $k$ — admits no producer instance). This is exactly the kind of "why" comment that earns its place in the file.
  - L477-L482 in the `IsHModuleHomFinite` docstring repeats the same rationale at the use-site of the class. Mild redundancy with L43-48; the duplication is OK because consumers reading the class definition without reading the file header still need the explanation.
  - All declarations are honestly closed; no `sorry` anywhere in this file.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is honestly closed. The Mathlib gap-fill block (L33-L110) builds `Abelian.Ext.chgUnivLinearEquiv` from `chgUniv_add` + `chgUniv_smul` helpers, both of which use `letI := HasDerivedCategory.standard C` + `ext` + manipulation through `homEquiv_chgUniv`. The construction is principled and the Mathlib citations (L37, L42, L55, L57, L78) are all real Mathlib locations.
  - L34-L51 file-header gap-fill description is substantive and accurate.
  - Hardcoded universe annotations (`Ext.{u}` / `Ext.{u+1}`) appear throughout — they are load-bearing for matching iter-014 `HModule'` (universe `u`) against iter-009 `HModule` (universe `u+1`). The comments at L201-L213 (in `HModule_top_linearEquiv` of MayerVietorisCover.lean) document this carefully.
  - The `set_option backward.isDefEq.respectTransparency false in` decoration at L354, L523, L539, L565 is used to defeat aggressive instance/defeq reductions. This is a known workaround for Mathlib's iter-2024 isDefEq-fastpath changes; flagging as **minor** because the `set_option` is a smell signal but appears unavoidable for the structure-literal projections being unfolded.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean

- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - `AffineCoverMVSquare` structure (L50-L62) has fields `isAffineOpen_U₁`, `isAffineOpen_U₂`, `isAffineOpen_inf` that are NOT consumed by any theorem in this file (grep'd: only the three definition sites are matches). This is the iter-123 carry-over the directive flagged. Per directive: re-flag only if the situation has worsened. Situation is unchanged from iter-123 (no new consumers added, no new declarations added that exercise these fields). Carrying forward as **minor** — the affineness data is recorded "for future Serre-finiteness use" per the docstring, but no current declaration depends on it. Decision: keep as a minor smell; do not escalate.
  - The file is a clean continuation of MayerVietorisCore.lean. All 16 declarations (`AffineCoverMVSquare`, 4 corner-identification simp lemmas, `HModule'_sequence`/`_exact` + their `_curve` companions, `HModule'_top_sourceIso`, two `HModule_top_linearEquiv` / `HModule'_top_linearEquiv` companions, `HModule'_eq_HModule_linearEquiv`, two `X₄_linearEquiv` + `_curve`, two finrank corollary + `_curve`, two `module_finite_HModule_of_HModule'_X₄` + `_curve`, the iter-049/050/051/052 `subsingleton_HModule_*` consumers, the `HasCechToHModuleIso` class + `cechToHModuleIso` extractor, the `HasAffineCechAcyclicCover` class + producer instance `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`) are honestly closed.
  - L699-L709 producer instance `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`: looks good. The `obtain ⟨ι, 𝒰, hcov, hacyc, hcomp⟩ := HasAffineCechAcyclicCover.exists_cover (F := F) hU` decomposition then `haveI` + `exact subsingleton_HModule'_of_hasCechToHModuleIso hcov i hi` is the right shape.

## Must-fix-this-iter

None.

The iter-124 substantive edits (the `forwardAlg` AlgHom promotion and the iter-124 refactor-deadcode-cleanup) landed cleanly. The residual L398 sorry is documented project state and not an excuse-comment per the lean-auditor must-fix rubric. The Jacobian.lean:179 sorry is the documented project end-state and is explicitly authorized by the directive.

## Major

- `AlgebraicJacobian/Differentials.lean:332-397` — comment block has bloated to ~66 lines for a single residual `sorry`. Body is substantive (the INJECTIVITY/SURJECTIVITY analysis is genuine and the Mathlib-gap identification is accurate) but the iter-loop narrative leaks: "Strategy this iter (iter-124)", "Mathlib b80f227" commit-hash citation, "the iter-125+ prover lane", "the iter-125 pivot to M2.a fires per the strategy-critic-iter124 sharpened commitment". These are ephemeral planning-state references that do not belong in production Lean source. Severity: major (not must-fix because content is honest documentation, but should be trimmed in a follow-up cleanup pass when the sorry resolves — or sooner if the strategy pivot lands).

## Minor

- `AlgebraicJacobian/Differentials.lean:239` — `erw [hmc]` inside `appLE_colimRingHom_comp_φV` is a known brittle spot (iter-123 carry-over, unchanged this iter). Should be rewritten as a deterministic `rw`/`simp only` once the project finds the right normal form.
- `AlgebraicJacobian/Rigidity.lean:62-67` — six unused typeclass hypotheses (`[GrpObj X]`, `[GrpObj Y]`, `[SmoothOfRelativeDimension n X.hom]`, `[SmoothOfRelativeDimension m Y.hom]`, `[IsProper X.hom]`, `[GeometricallyIrreducible Y.hom]`) on `GrpObj.eq_of_eqOnOpen` are kept "for forward-compatibility with the informal Mumford-rigidity statement" and "to preserve the declaration's 'abelian-variety' intent". These typeclass arguments are exercised by no part of the proof body. Each forces synthesis cost at every call site. Small smell; consider trimming when downstream usage stabilises.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:55-60` — three `IsAffineOpen` fields of `AffineCoverMVSquare` (`isAffineOpen_U₁`, `isAffineOpen_U₂`, `isAffineOpen_inf`) are unused in the file. Per directive: situation unchanged from iter-123, not re-escalated. Document-only flag.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:354,523,539,565` — `set_option backward.isDefEq.respectTransparency false in` appears four times. Each is principled (defeats aggressive defeq-fastpath transparency that breaks structure-literal projection access in Mathlib post-2024). Document-only flag; the workaround appears unavoidable.

## Excuse-comments (always called out separately)

None.

I audited the bodies of both `sorry` sites and the surrounding comments. Neither qualifies as an excuse-comment under the lean-auditor rubric:

- `Differentials.lean:398` — the L332-L397 block is documentary blocker analysis, not a "will fix later" admission. It correctly identifies the Mathlib gap (filtered-colim bridge + basic-open cofinality) without inventing Mathlib names and without claiming the gap has been bridged. It IS bloated and contains iter-loop narrative (flagged major above), but not in the must-fix sense.
- `Jacobian.lean:179` — explicitly authorized by the directive as the project end-state sorry; the L162-L175 docstring honestly defers to "a future iteration" pending Mathlib infrastructure (quotients of schemes by finite group actions; FGA representability).

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (Differentials.lean L332-L397 comment bloat + iter-loop narrative)
- **minor**: 4 (Differentials.lean L239 `erw`; Rigidity.lean L62-67 unused typeclasses; MayerVietorisCover L55-60 unused affineness fields; MayerVietorisCore set_option uses)
- **excuse-comments**: 0

Overall verdict: clean iter — the iter-124 `forwardAlg` AlgHom promotion is well-shaped, the refactor-deadcode-cleanup landed without leaving stale cross-references, and no new must-fix issues were introduced; the main flag this iter is comment bloat plus iter-loop narrative bleed in the Differentials.lean L332-L397 block, which should be trimmed when the residual `sorry` resolves.
