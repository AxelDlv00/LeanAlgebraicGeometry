# Lean Audit Report

## Slug
iter171

## Iteration
171

## Scope
- files audited: 17 (every `.lean` under the project tree, excluding `.archon/` snapshots and `.lake/`)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure-import aggregator (16 lines). Imports in topological order; no orphan modules in the import chain.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three protected declarations are honest one-line projections of `(jacobianWitness C).isAlbaneseFor P`. The `letI` chain to expose the witness's bundled instances is the canonical idiom. Status block at L14-29 is accurate (iter-073, still factually correct as of iter-171).

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L245-247, L311-314, L288-289: docstring "Status (iter-166)" / "Status (iter-167)" tags are time-stamped — fine as historical anchors but rot as the project advances. Minor.
  - L196: `haveI hιDom : IsDominant iotaGm.left := iotaGm_isDominant` — the `hιDom` name is unused (haveI only needs the typeclass effect). Minor cosmetics.
  - Two known sorries (`iotaGm_isDominant` L86-89, `genusZero_curve_iso_P1` L290-296) both have honest docstrings documenting WHY the body is open and what the closure path is. Not excuse-comments — load-bearing genuine deferrals tracked in the directive.
  - Refactor (`refactor avr-split`) result is clean: the file is a focused 354 LOC "genus-`0` final layer" wrapper that consumes the upstream `RigidityLemma` chain. Namespace boundaries are correct (`namespace AlgebraicGeometry` throughout). All three imports (`Genus`, `Genus0BaseObjects`, `RigidityLemma`) are USED.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 627 LOC of MV-LES infrastructure; all theorems closed (no sorries). The `set_option backward.isDefEq.respectTransparency false in` decorations at L354, L523, L539, L565 are load-bearing (documented). Mathlib gap-fills (`chgUnivLinearEquiv`, `ModuleCat_free_isLeftAdjoint`, `ModuleCat_free_preservesMonomorphisms`, `Functor.const_additive`, `Functor.const_linear`, `Adjunction.left_adjoint_linear`, `Adjunction.right_adjoint_linear`, `Adjunction.homLinearEquiv`) are clearly labelled "iter-NNN Mathlib gap-fill" with citations to the upstream files they mirror.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 711 LOC; no sorries. Three carrier classes (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover`, the existing `IsCechAcyclicCover` consumer) deliberately defer the Čech-to-derived comparison theorem to a typeclass field — the `instance` for `HasAffineCechAcyclicCover (toModuleKSheaf C)` is the actual project obligation (currently unsupplied; not a sorry, just an instance gap). This is honest design, not an excuse-comment.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 49 LOC; single instance, honestly closed. Status block at L19-23 is factually accurate.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 63 LOC; three honest instances/definitions. Status block accurate.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 877 LOC; no sorries. The L41-50 "abandoned attempt" note documents the deletion of `IsAffineHModuleHomFinite` (an honest postmortem, not an excuse). The deep instance chain through iter-046 (`instIsHModuleHomFinite_toModuleKSheaf`) is a real producer instance based on Stein finiteness.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none (all theorems proved)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L37-79: file-level docstring still markets the file as "scaffolds the five sub-pieces of the iter-144 chart-algebra pivot route for piece (ii)." Per the project memory KB and per `AbelianVarietyRigidity.lean`'s own header (L41-42: "differential/chart route demoted to off-path fallback (a)"), the chart-algebra pivot was DECOMMITTED at iter-163 (Route C committed) and again at iter-164 (gᴍ-scaling shortcut). The file is **NOT** on the live critical path. The directive describes this file as "intentionally minimal (a thin placeholder)" — that description doesn't match the file's 459 LOC of substantive (proven) lemmas. The directive may itself be stale; the file content is correct but mismarketed. Severity: **major** (misleading status framing, but no live correctness issue; theorems are proved cleanly).
  - L20-27, L88-92 import notes are factually accurate (Mathlib path correction + local-instance re-enabling of `Algebra.TensorProduct.rightAlgebra`).
  - The KDM proof (`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, L197-287) is a long but honest reduction through the H1Cotangent / Jacobi-Zariski route; well-commented.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - L428-451 docstring still tracks "Step 3 closed iter-136 (no sorry); Step 2 PARTIAL iter-137" + L465-525 "iter-138 PARTIAL with substantive Route (b) skeleton landed" — but the L552-560 EXCISE block then says the Route (b) skeleton (`basechange_along_proj_two_inv_*`) was DELETED in iter-145. So the L428-525 docstring block describes EXCISED code; it should be trimmed to reflect what is actually present (only Step 3 closure + a `shearMulRight` iso). Severity: **major** (long docstring blocks describe code that no longer exists in the file).
  - L172-181 / L262-280: the `Classical.choose`-chain construction is intentional (the iter-131 prover-lane fix-up to escape `Classical.choice` opacity, well-documented). Not a code smell; honest design.
  - L544-550 `isIso_of_app_iso_module` is a sound Mathlib gap-fill, marked `private`.
  - L613-622 `iter-145 EXCISE` block notes are historical; mildly clutters the file but cleanly tagged. Minor.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 144 LOC, no sorries. `smooth_locally_free_omega` correctly documents the forward direction only (with an explicit pointer to the converse-direction counterexample). The `kaehler_quotient_localization_iso` proof has a slightly long `Subsingleton`-on-tensor-product manual induction at L98-109 — would simp+aesop more tersely, but it is correct as written.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 45 LOC; single one-line `noncomputable def` matching `dim_k H¹(C, O_C)`. Status block accurate. Imports the heavy `Mathlib` wholesale — acceptable here given the single tiny declaration.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged (build hygiene)
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - L237: `push Not at h`. The standard Mathlib tactic is `push_neg`. `push Not at h` is suspicious syntax — in current Mathlib `push` is a generic tactic and `Not` is being passed as its target. If the build is green this is functionally fine, but it is not the idiomatic spelling and is fragile against Mathlib refactors. Severity: **minor** (probable typo for `push_neg`; verify in build).
  - L262-263 / L265: `@[simp] private lemma otherFin_zero/_one` — `@[simp]` on a `private` lemma is unusual; `private` controls API visibility but `@[simp]` still registers globally, which may confuse readers. Severity: **minor**.
  - L1196 (Lane B comments earlier): the docstrings on `projGm_geomIrred`, `projGm_isReduced`, `gm_geomIrred` correctly classify their sorries as "Mathlib gap" with concrete substantive reasons (no `Smooth → GeometricallyReduced` at scheme level, no GI bridge from `Spec(domain)`). These are honest scaffolds — directive-listed as known.
  - The 10 sorries match the directive's known list exactly. None have suspect bodies (no `:= True`, no fake `rfl`); each is at a named top-level declaration with a documented closure path.
  - `algebraKbarAway` (L91-95, new this iter): genuine `Algebra.compHom` instance bridging the `kbar → 𝒜 0 → Away 𝒜 f` chain. Sound.
  - `mvPolyToHomogeneousLocalizationAway_surjective` (L372-375, new this iter): honest typed `sorry` with concrete closure recipe in the docstring (`Away.adjoin_mk_prod_pow_eq_top` at `d=1, ι'=Fin 2`); directive-tracked.
  - `homogeneousLocalizationAwayIso_aux_left` (L384-395, new substantive body this iter): the "cancel surjective" route is properly implemented. Body is honest.
  - `pointOfVec` chain (L424-507): the three `k̄`-points (`zeroPt`, `onePt`, `inftyPt`) are constructed kernel-clean via `pointOfVec` (verified per memory KB iter-166).
  - L552-573 file-comment block on `gmScalingP1_chart` honestly explains that chart-1 sends `u ↦ u⊗λ` and chart-0 sends `t ↦ t⊗λ⁻¹` and the body is `sorry`. Documented gating.
  - The file-level docstring at L9-56 is accurate (route C committed, gᴍ-scaling shortcut, no theorem of the cube).

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 flagged
- **notes**:
  - **L237-263 (under `genusZeroWitness.isAlbaneseFor.key`)**: long comment block stating that the `key` sorry **CANNOT** be discharged due to three independent gates: (1) "import cycle" (`Jacobian → RigidityKbar → Rigidity → Jacobian`); (2) "char-p logical gap" ([CharZero] requirement of `rigidity_over_kbar`); (3) "base-change functor missing." All three gates are **NO LONGER VALID** under the iter-163 committed Route C:
    - The route-C replacement `rigidity_genus0_curve_to_grpScheme` lives in `AbelianVarietyRigidity.lean`, which imports only `Genus`, `Genus0BaseObjects`, `RigidityLemma` — NONE of which imports `Jacobian`. So `Jacobian.lean` importing `AbelianVarietyRigidity` introduces **no cycle**.
    - `rigidity_genus0_curve_to_grpScheme`'s signature **drops `[CharZero kbar]`** explicitly (L300, AVR.lean: "char-free"). So the char-p gap doesn't apply.
    - Route C doesn't require a base-change functor (the iso through `genusZero_curve_iso_P1` plays the role).
    This is an **excuse-comment**: the prose explains why a load-bearing sorry "cannot close" in a way that masks an available path. Severity: **critical** (per the strict-severity rubric, every excuse-comment is must-fix; this one in particular hides a now-available closure for the headline `genusZeroWitness` sorry).
  - **L182-208 (`genusZeroWitness` docstring)**: still references the OLD CharZero-fallback strategy (`rigidity_over_kbar`, base-change to k̄, "faithfully-flat descent C.2.f", "CharZero requirement of rigidity_over_kbar"). Should be rewritten to reference `rigidity_genus0_curve_to_grpScheme` and a (route-C) plan. Severity: **major** (stale strategy framing for a load-bearing declaration).
  - The two genuine sorries (`genusZeroWitness.key` body L264-265, `positiveGenusWitness` L303) match the directive's known list. `nonempty_jacobianWitness` itself is **not** a sorry (it dispatches to the two helpers via `by_cases h : genus C = 0`).
  - The `IsAlbanese.unique` proof L100-128 is a clean classical-uniqueness chase.
  - The "Forbidden shortcut (sanity check)" comment at L44-52 is informative, not an excuse-comment.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 123 LOC; single theorem `Scheme.Over.ext_of_eqOnOpen` honestly closed via `ext_of_isDominant_of_isSeparated'`. The "Hypothesis history" docstring block (L44-79) is an excellent piece of self-documentation explaining (1) why the original point-wise hypothesis was strengthened to scheme-level (Frobenius counterexample in char p), (2) why `[IsReduced X.left]` is added explicitly (Mathlib gap), (3) the iter-125 unused-hypothesis cleanup. Not stale.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L21-30: status block calls this an "iter-126 scaffold" with a strategic narrative gated on the "shared cotangent-vanishing Mathlib pile (iter-129+)." Per the project memory KB, this entire strategic frame was **superseded at iter-156 ("RED HERRING") and iter-163 (Route C committed, cube/cotangent/Serre framework EXCISED)**. The single `sorry` at L88 is now superseded by `rigidity_genus0_curve_to_grpScheme` (in `AbelianVarietyRigidity.lean`) modulo two AVR known sorries; this file is acknowledged in `AbelianVarietyRigidity.lean` L16-17 as "the fallback route (a) artifact." The status block should reflect that role. Severity: **major** (stale status framing; the `sorry` itself is honestly the [CharZero] fallback).
  - Directive note: the directive says "1 sorry on RigidityKbar.lean (`[CharZero]` fallback `rigidity_genusZero_charZero_real`)" but the actual declaration name in the file is `rigidity_over_kbar`. Name mismatch is in the directive, not the file.
  - The encoding-choice block at L32-46 is a useful explanatory note (Option A vs Option B); not stale.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **NEW 902-LOC file (created by `refactor avr-split` this iter).** Audit confirms:
    - Single namespace `AlgebraicGeometry`; clean and consistent.
    - Single import (`AlgebraicJacobian.Genus`); minimal and correct.
    - **No sorries** — searched via `grep`, only docstring mentions of "sorry-free" appear (positive claims).
    - All declarations are claimed axiom-clean per the per-theorem status blocks (consistent with the memory KB's iter-162 closure record).
    - The big proofs (`rigidity_eqAt_closedPoint_of_proper_into_affine` L254-391, `rigidity_eqOn_dense_open` L499-606, `rigidity_lemma` L757-776, `hom_additive_decomp_of_rigidity` L806-861, `av_regularMap_isHom_of_zero` L876-900) are long but well-commented; no fake-tactic-chain smells.
    - No orphan declarations.
  - Implementation note: `rigidity_core` (L671-704) replicates inline the proof of `Scheme.Over.ext_of_eqOnOpen` (downstream in `AlgebraicJacobian.Rigidity`) because that wrapper isn't yet importable here. Honestly documented at L685-690. Acceptable, but a future cleanup could move `Scheme.Over.ext_of_eqOnOpen` upstream to remove the duplication.
  - The chain status blocks (iter-157 → iter-162) are time-stamped but factually correct. Minor.

## Must-fix-this-iter

- `AlgebraicJacobian/Jacobian.lean:237-263` — multi-paragraph excuse-comment block under the `key` sorry asserting the proof "CANNOT be wired" due to three gates (import cycle, char-p, base-change functor). Why must-fix: every listed gate is **invalid** under the iter-163 committed Route C; the `rigidity_genus0_curve_to_grpScheme` lemma is import-clean (no cycle: `AbelianVarietyRigidity` does not import `Jacobian`), char-free (no [CharZero]), and doesn't need a base-change functor. The comment is documenting a wrong rationale and (per the strict-severity rubric) every excuse-comment is must-fix at minimum; here it is **critical** because the comment claims unrepairability on a headline load-bearing sorry whose closure path is actually now available.

## Major

- `AlgebraicJacobian/Jacobian.lean:182-208` — `genusZeroWitness` docstring frames the `key` content via the OLD CharZero `rigidity_over_kbar` + faithfully-flat-descent strategy. Should be rewritten to reference the route-C replacement `rigidity_genus0_curve_to_grpScheme`.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:36-79` — file-level docstring sells the file as the "iter-144 chart-algebra pivot route" — that pivot was decommitted iter-163/iter-164. The file's theorems are proved cleanly (no live correctness issue) but the framing is misleading; the directive's "intentionally minimal" descriptor doesn't match the 459 LOC of substantive content either. Reconcile: either trim the file to a placeholder or refresh the docstring to "off-path artifact retained for possible char-0 sub-case."
- `AlgebraicJacobian/Cotangent/GrpObj.lean:428-525` — long docstring blocks describe code (`basechange_along_proj_two_inv*`, `relativeDifferentialsPresheaf_basechange_along_proj_two`) that was EXCISED at iter-145 (L552-560 of the same file). The narrative is internally contradictory.
- `AlgebraicJacobian/RigidityKbar.lean:21-46` — status block frames this as an "iter-126 scaffold" gated on the cotangent-vanishing pile; the project superseded that frame iter-156 and iter-163. The file's role is now (per AVR.lean L16-17) the route-(a) [CharZero] fallback artifact; the docstring should say so.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:245-247, 311-314, 288-289` — iter-166 / iter-167 status time-stamps in docstrings are valid history but rot; consider switching to "status: open / partial / closed" rather than time-stamping.

## Minor

- `AlgebraicJacobian/Genus0BaseObjects.lean:237` — `push Not at h` is suspicious; standard Mathlib tactic is `push_neg at h`. Verify build; likely typo.
- `AlgebraicJacobian/Genus0BaseObjects.lean:262, 263` — `@[simp]` on `private lemma otherFin_zero`/`otherFin_one`; `private` only controls API visibility, `@[simp]` registers globally, mildly inconsistent.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:196` — `haveI hιDom : ... := iotaGm_isDominant`; the name `hιDom` is unused. Drop or use `haveI : ... := iotaGm_isDominant`.
- `AlgebraicJacobian/RigidityLemma.lean:685-690` — `rigidity_core` inlines a copy of `Scheme.Over.ext_of_eqOnOpen` because the wrapper lives downstream. A future structural cleanup could promote that wrapper upstream and let `rigidity_core` consume it.
- Many files use iter-NNN time-stamped status blocks. They are honest history but rot — consider a one-line "status:" convention separated from the narrative.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Jacobian.lean:237-263`: 28-line block attached to the `genusZeroWitness.isAlbaneseFor.key` `sorry`, listing "three independent gates, all out-of-file / plan-level" and asserting "no honest in-file term closes this; a speculative base-change scaffold would be unconsumable... so the gate is recorded rather than papered over." Severity: **critical**. The named declaration `genusZeroWitness` is load-bearing (consumed by `nonempty_jacobianWitness` via the `by_cases h : genus C = 0` split, which in turn is the sole producer for `jacobianWitness C` and hence all four `Jacobian C` instances), and all three claimed gates are invalid under the iter-163 Route C: `AbelianVarietyRigidity.rigidity_genus0_curve_to_grpScheme` is import-clean (no cycle through `Rigidity`), char-free (no `[CharZero]`), and the consumer doesn't need a base-change functor. The block is exactly the "lying to itself" pattern the rubric warns against.

## Severity summary

- **must-fix-this-iter**: 1 — Jacobian.lean L237-263 excuse-comment block.
- **major**: 5 — stale strategic framings in Jacobian.lean / ChartAlgebra.lean / Cotangent/GrpObj.lean / RigidityKbar.lean; iter-tagged status drift in AVR.lean.
- **minor**: 5 — `push Not` syntax, `@[simp]` on private, unused `haveI` name, code duplication, time-stamp convention.
- **excuse-comments**: 1 (counted under must-fix-this-iter; called out separately because it documents the project lying to itself about an unrepairability that no longer holds).

Overall verdict: One critical excuse-comment in `Jacobian.lean` blocks the headline `genusZeroWitness.key` sorry from being closed via the now-committed Route C path; a handful of major stale-narrative blocks in legacy strategy files should be reconciled with the iter-163 Route C commitment, but no theorem body has a suspect/fake-content sorry and the new `RigidityLemma.lean` refactor lands clean.
