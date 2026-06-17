# Lean Audit Report

## Slug
review133

## Iteration
133

## Scope
- files audited: 14 (all `.lean` under project root and `AlgebraicJacobian/`, plus `references/challenge.lean`)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single top-level umbrella file with import declarations only.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three protected declarations (`Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) all present with signatures matching `archon-protected.yaml`. Bodies are honest one-line projections through `(jacobianWitness C).isAlbaneseFor P`.
  - Docstrings and Status block correctly describe the iter-073 reduction-to-witness pattern and the absorption of genus-0 rigidity into `nonempty_jacobianWitness`.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (minor)
- **excuse-comments**: none
- **notes**:
  - Two `set_option backward.isDefEq.respectTransparency false in` (L354, L523, L539, L565) — escape hatch for typeclass synthesis past structure-literal projection. The comments explain *why* (typeclass-search needs unfolded normal form past `@[simps]` projections); this is the standard Mathlib idiom for `@[simps]`-shielded targets, not a hack. Noted as minor only.
  - `Abelian.Ext.chgUnivLinearEquiv` (L101) is a clean Mathlib gap-fill (upgrades `Abelian.Ext.chgUniv` from `Equiv` to `LinearEquiv`); the cross-references to Mathlib source lines are precise.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The two carrier classes `HasCechToHModuleIso` (L490) and `HasAffineCechAcyclicCover` (L675) are honestly typed (no `Prop := True` etc.); existence content is explicit `Nonempty (∀ n, ...)` wrapping for the former and `∃ ι 𝒰, ⨆𝒰 = U ∧ ...` for the latter.
  - L504 has a parenthetical `axiom set ‘[propext, Classical.choice, Quot.sound]’` — this is a status-comment documenting that `Classical.choice` is already in the kernel-trusted set, not an `axiom` declaration. Honest framing.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (minor — `import Mathlib`)
- **excuse-comments**: none
- **notes**:
  - Whole-`Mathlib` import (L6) — heavyweight; could be narrowed but standard in the project's other files and the status comment correctly identifies this as a closed iter-003 file.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three short instances + one def, all honestly closed via `inferInstance` / `HasExt.standard` / `sheafCompose`. The `HasExt.{u+1}` universe pinning at L43 is justified by the docstring.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The iter-046 Mathlib gap-fills (`Functor.const_additive`, `Functor.const_linear`, `Adjunction.left_adjoint_linear`, `right_adjoint_linear`, `homLinearEquiv`) at L60–113 are all small, honest closures; the docstrings precisely cite the Mathlib lemmas being parallelled (`left_adjoint_additive`, `homAddEquiv`).
  - `module_finite_globalSections_of_isProper` (L548) is a substantive Stein-finiteness bridge with an explicit calc proof and no shortcuts; docstring correctly cites `finite_appTop_of_universallyClosed`.
  - The "abandoned per-affine-open variant" `IsAffineHModuleHomFinite` is mentioned in L36–48 of the module docstring and in L470–481 of `IsHModuleHomFinite`'s docstring as having been *removed*. Verified: no `IsAffineHModuleHomFinite` declaration remains in the file. Self-consistent.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 8 flagged (stale line-number anchors)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Module docstring + per-declaration docstrings reference outdated line numbers.** Every reference to "(line 149 below)" / "(line 198 below)" / "(line 244 below)" is off by ~12 lines after the iter-133 docstring refresh. Actual locations: `cotangentSpaceAtIdentity` at L161 (not 149), `cotangentSpaceAtIdentity_eq_extendScalars` at L210 (not 198), `cotangentSpaceAtIdentity_finrank_eq` at L256 (not 244). See "Major" below for the per-occurrence list.
  - The directive specifically asked: "Confirm the iter-132 stale-framing findings have been resolved and no new staleness has been introduced." The textual framing (Replacement (B) description, Status block) has been refreshed honestly, but the line-anchor staleness is *new* — introduced by the iter-133 docstring expansion that pushed declarations down without updating the anchors.
  - Bodies themselves are clean: `cotangentSpaceAtIdentity` (L161–200) uses the documented `Classical.choose`-chain on `smooth_locally_free_omega` with explicit `let`-bindings (no opaque `Classical.choice` head symbol); `cotangentSpaceAtIdentity_eq_extendScalars` (L210) and `cotangentSpaceAtIdentity_finrank_eq` (L256) reproduce the same chain in proof position, structurally matching the def body. No `sorry`, no `axiom`.
  - The three Cotangent/GrpObj declarations are NOT in `archon-protected.yaml` (only 9 protected sigs across Genus / Jacobian / AbelJacobi). The directive states they were added in iter-128/131/132; this is contradicted by the protected file's current content. Out of scope for the auditor to verify; flagged for the dispatching reviewer.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (minor — `first | exact A | exact B`)
- **excuse-comments**: none
- **notes**:
  - `relativeDifferentialsPresheaf` and `relativeDifferentialsPresheaf_obj_kaehler` are short and honest.
  - `kaehler_localization_subsingleton` and `kaehler_quotient_localization_iso` are well-documented; the second is named as a Mathlib contribution candidate.
  - `smooth_locally_free_omega` (L124) uses `<;> · ... ; first | exact A | exact B` to discharge two branches with two different lemmas. Slightly cryptic but the alternation is sound: branch 1 needs `Module.Free`, branch 2 needs `Module.rank = n`, and the two `exact`s deliver exactly those. Could be split into explicit `refine ⟨?_, ?_⟩` form for readability — minor.
  - The forward-only Jacobian-criterion framing is honest: the converse-direction caveat is explicit and accurate (`Spec k → Spec k[t], t ↦ 0` counterexample reference).

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (minor — `import Mathlib`)
- **excuse-comments**: none
- **notes**:
  - Single short definition with the honest body `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. Status block accurately describes iter-011 closure. `import Mathlib` (full) is heavyweight but the docstring states it was authorised on 2026-05-07.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none (the 2 sorry-bodied declarations are flagged as INFO scaffold per directive)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `IsAlbanese` (L71), `IsAlbanese.ofCurve` (L81), `comp_ofCurve` (L86), `exists_unique_ofCurve_comp` (L92), `IsAlbanese.unique` (L102), `geometricallyIrreducible_id_Spec` (L134) all closed with honest bodies.
  - `JacobianWitness` (L157) structure has explicit fields with docstrings; `isAlbaneseFor` field is `∀ P, IsAlbanese …` (uniform over marked points), matching the documented design.
  - **Sorry inventory (per directive — INFO only)**:
    - L192 `genusZeroWitness`: sorry, body closure deferred to iter-138+; docstring honestly labels it as iter-127 scaffold.
    - L213 `nonempty_jacobianWitness`: sorry, body closure post M2 + M3; docstring honestly labels it as Phase-C OFF-LIMITS sorry.
  - `jacobianWitness` (L218) uses `Classical.choice (nonempty_jacobianWitness C)` — this is the correct way to extract data from the sorry'd existence statement; no opaque cheat.
  - All four protected `Jacobian` instances (L244, L248, L252, L255) project from the witness directly — signatures match `archon-protected.yaml` verbatim.
  - The "Forbidden shortcut (sanity check)" block (L44–52) explicitly explains why `Jacobian C := 𝟙_ (Over (Spec (.of k)))` would be mathematically wrong in genus ≥ 1. Excellent documentation — this is the *opposite* of an excuse-comment: it documents a temptation that was correctly resisted.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` (L91) closed honestly; proof reduces to Mathlib's `ext_of_isDominant_of_isSeparated'` via four explicit steps that match the comments.
  - "Hypothesis history" block (L43–78) clearly documents the iter-003 strengthening (point-wise → scheme-level) with the Frobenius counterexample (`a ↦ a^p` vs `a ↦ a`), and the iter-125 unused-hypothesis cleanup. Strong mathematical hygiene — explains the *why* of every hypothesis tweak.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none (the 1 sorry-bodied declaration is flagged as INFO scaffold per directive)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Sorry inventory (per directive — INFO only)**:
    - L87 `rigidity_over_kbar`: sorry; closure gated on shared cotangent-vanishing pile (iter-129+); docstring honestly labels it as iter-126 scaffold and provides full decomposition references (C.2.b–C.2.e).
  - The "Encoding choice (iter-126 refactor agent note)" block (L31–46) honestly explains why Option B (abstract genus-0 curve) was chosen over the directive-offered Option A (literal `Spec(MvPolynomial …)`); the Option A counterexample (affine ≠ projective line) is mathematically correct.

### references/challenge.lean
- **outdated comments**: none
- **suspect definitions**: 6 (all `sorry`-bodied — INFORMATIONAL only; this is the challenge specification, not project source)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - This file is the **upstream challenge specification** (Christian Merten's reference snapshot, `commit b80f227`), not part of the project's working source tree. It contains 6 sorry-bodied declarations (`genus`, `Jacobian`, four `Jacobian`-namespace instances, `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) that the project is *implementing* in `AlgebraicJacobian/`. The sorries here are the **challenge to be solved**, not stale scaffolding.
  - Audit-wise: nothing to fix here — modifying this file would mean rewriting the challenge specification. Out-of-scope for any agent.

## Must-fix-this-iter

(none)

No excuse-comments, no weakened-wrong definitions, no parallel-API copies, no suspect bodies on substantive claims, no unauthorized axioms. The 3 scaffold sorries are intentional and pre-acknowledged by the directive.

## Major

The iter-133 docstring refresh in `AlgebraicJacobian/Cotangent/GrpObj.lean` introduced stale line-number anchors. All 8 references are off by +12 lines (declarations moved down as docstrings expanded; anchors were not re-targeted). The directive specifically asked to confirm "no new staleness has been introduced" — this is the new staleness.

- `AlgebraicJacobian/Cotangent/GrpObj.lean:28-29` — module docstring says `cotangentSpaceAtIdentity` is at "line 149 below"; actual location is **line 161** (defined on `noncomputable def cotangentSpaceAtIdentity`).
- `AlgebraicJacobian/Cotangent/GrpObj.lean:30` — module docstring says `cotangentSpaceAtIdentity_eq_extendScalars` is at "line 198 below"; actual location is **line 210**.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:31-32` — module docstring says `cotangentSpaceAtIdentity_finrank_eq` is at "line 244 below"; actual location is **line 256**.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:61` — Status block says `cotangentSpaceAtIdentity_finrank_eq` is at "(line 244 below)"; actual location is line 256.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:107` — `cotangentSpaceAtIdentity` def docstring says "line 244 below"; actual location is line 256.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:146-147` — `cotangentSpaceAtIdentity` def docstring says iter-132 rank lemma is at "(line 244 below)"; actual location is line 256.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:155` — `cotangentSpaceAtIdentity` def docstring says rank is "now pinned by `cotangentSpaceAtIdentity_finrank_eq` (line 244 below; closed iter-132)"; actual location is line 256.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:160` — `cotangentSpaceAtIdentity` def docstring closing line says shape-acceptance lemma is at "(line 198 below)"; actual location is line 210.

Severity rationale: these don't cause compilation issues or mathematical drift, but they actively mislead a reader navigating the file (you scroll to line 244 expecting the rank lemma, find the middle of the `cotangentSpaceAtIdentity` body instead). The fix is mechanical (s/149/161/g, s/198/210/g, s/244/256/g in docstrings only). The whole point of including line anchors is to provide stable navigation — when they drift, they are worse than absent.

## Minor

- `AlgebraicJacobian/Genus.lean:6` — `import Mathlib` (full). Standard in the project but slows incremental builds. The status block correctly notes this was authorised on 2026-05-07.
- `AlgebraicJacobian/Cohomology/SheafCompose.lean:6` — `import Mathlib` (full). Same as above; could be narrowed to `Mathlib.CategoryTheory.Sites.SheafCohomology.Basic` + related.
- `AlgebraicJacobian/Differentials.lean:134-142` — `smooth_locally_free_omega` proof uses `refine ⟨…, ?_, ?_⟩ <;> · … first | exact A | exact B`. The `first | exact` alternation discharges the two branches (Free / rank=n) by trial. Works correctly but a split `refine ⟨…, ?_, ?_⟩` followed by two separate sub-proofs would read more directly. Not a correctness issue.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:354, 523, 539, 565` — `set_option backward.isDefEq.respectTransparency false in` escape hatches. Necessary for `@[simps]`-projected targets, but each one is a small typeclass-synthesis crutch. Mathlib uses the same pattern; not a project bug.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` — Module docstring (L36–48) and the `IsHModuleHomFinite` docstring (L470–485) both narrate the same "abandoned `IsAffineHModuleHomFinite` variant" story. Slightly redundant — could be consolidated to a single mention if the file gets a future readability pass, but neither is incorrect.

## Excuse-comments (always called out separately)

None found. The project's documentation style is uniformly mathematical-justification-first ("the iter-130 fix-up replaced it with Replacement (B): affine-chart base change", "the converse direction is mathematically false as stated", "the per-open class … has been deleted as dead scaffolding"). No "TODO replace later" / "wrong but works" / "placeholder" admissions anywhere in the audited tree.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 8 (all stale line-number anchors in `Cotangent/GrpObj.lean` — iter-133 docstring-expansion drift)
- **minor**: 5
- **excuse-comments**: 0

**INFO (per directive)**: 3 known scaffold sorries (`Jacobian.lean:192` `genusZeroWitness`, `Jacobian.lean:213` `nonempty_jacobianWitness`, `RigidityKbar.lean:87` `rigidity_over_kbar`) — intentional, pre-acknowledged, not counted in severity totals.

Overall verdict: the project source is in good mathematical and Lean-hygiene shape — no excuse-comments, no weakened definitions, no dead-end proofs, no unauthorized axioms, protected signatures intact; the iter-133 docstring refresh in `Cotangent/GrpObj.lean` is textually clean but left 8 stale line-number anchors that should be re-targeted before they become navigation hazards.
