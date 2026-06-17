# Lean Audit Report

## Slug
iter127

## Iteration
127

## Scope
- files audited: 11 (`AlgebraicJacobian.lean` + 10 files under `AlgebraicJacobian/`)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Pure aggregator file (11 `import` lines, no declarations).

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - The three declarations (`Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) all project cleanly through `(jacobianWitness C).isAlbaneseFor P`. Signatures and docstrings line up with the file-level "Phase E closes by reduction" status note. The repeated four-line `letI` instance-restamp pattern on each declaration is the small wart of the witness-bundling encoding; not a bug.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 628 lines, all closed. `Abelian.Ext.chgUnivLinearEquiv` Mathlib gap-fill + the full iter-016/017/018/019/020/021/022/023/026 MV LES infrastructure. Two `set_option backward.isDefEq.respectTransparency false in` decorations on `HModule'_shortComplex_f_mono`, `HModule'_biprodAddEquiv_…` and `HModule'_sequenceIso` — these are deliberate transparency-budget overrides documented in the docstring, not anti-patterns. No suspect bodies.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 711 lines, all closed. `AffineCoverMVSquare` structure + the iter-028→iter-053 cover-totality / `IsCechAcyclicCover` / `HasCechToHModuleIso` / `HasAffineCechAcyclicCover` ladder.
  - The `Classical.choice` use inside `cechToHModuleIso` (L514) is sanctioned: the docstring on L500–505 explicitly notes "no new axiom introduced" since `Classical.choice` is already in the kernel-only axiom set. Pattern is the standard Nonempty-bundling-of-data trick.
  - `HasAffineCechAcyclicCover` (L675–682) bundles existence of a basic-open Čech-acyclic cover per affine open — substantive instance is acknowledged as "iter-054+ work" in the docstring; the iter-053 producer of `IsAffineHModuleVanishing` (L699–709) is honestly closed assuming that future instance.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 49 lines, single instance, honestly closed.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 63 lines, three declarations, all honestly closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 877 lines, all closed. The file mixes iter-005 prerequisites, iter-006 helpers, the iter-009/010/013/015 `HModule`/`HModule'` carriers, the iter-038/039/040/043/044/045/046/047/048 Module.Finite ladder, and the iter-012/047 Čech machinery. The iter-046 `instIsHModuleHomFinite_toModuleKSheaf` is a real `instance` (typeclass producer) honestly closed via the documented four-step bridge.
  - Pre-existing structural blemish: the file is genuinely large (~877 lines) and bundles many namespaces; not a defect by itself but ripe for a future split.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 144 lines, standalone, kernel-clean. Three substantive declarations (`relativeDifferentialsPresheaf`, `kaehler_quotient_localization_iso`, `smooth_locally_free_omega`) plus the auxiliary `relativeDifferentialsPresheaf_obj_kaehler` (rfl) and `kaehler_localization_subsingleton`. No sorries, no axioms. The deliberately scoped converse-disclosure in `smooth_locally_free_omega`'s docstring (L120–123) honestly admits the converse is false without extra hypotheses; this is the correct kind of negative-result documentation, not an excuse-comment.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 46 lines, single definition `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. Honest mathematical body. The single `import Mathlib` (rather than a targeted import) is a code smell project-wide but consistent with other top-level files.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 1 flagged
- **excuse-comments**: 0
- **notes**:
  - L120–126 `geometricallyIrreducible_id_Spec`: declared but **unused** anywhere in the project (grep is empty outside its own line). Docstring claims it is "a small helper needed for the genus-0 case of `Jacobian`", but the iter-127 refactor absorbed the genus-0 case into the witness — there is no genus-0 `dite` left to consume this lemma. See Minor block.
  - L86–87 `IsAlbanese.unique` docstring: claims "unique up to a unique isomorphism" but the conclusion `∃! e, h₂.ofCurve = h₁.ofCurve ≫ e` is only unique-morphism, not unique-iso. The proof body (L94–113) does compute the inverse `h : J₂ ⟶ J₁` and the round-trip identities `hgh : g ≫ h = 𝟙` and `hhg : h ≫ g = 𝟙`, but they are never used in the returned triple (`⟨g, hg_eq, fun g' hg' => hg_unique g' hg'⟩`). The blueprint `rem:IsAlbanese_unique_iso` (`Jacobian.tex:90–100`) explicitly acknowledges this discrepancy as a *known* signature-tightening deferral. The Lean docstring should mirror that disclosure. See Minor block.
  - L162–178 `genusZeroWitness`: iter-127 scaffold (single `sorry` body) recognised by the directive — NOT flagged. Signature is honest (takes `h : genus C = 0` explicitly). Docstring is long but factual: it states the underlying scheme is `Spec k`, that the universal morphism is `toUnit C`, that the substantive content is the rigidity statement `rigidity_over_kbar`, and that the body closure is gated on iter-138+. No excuse-comment language ("temporary", "will fix later"); honest status note. The `(h : genus C = 0)` hypothesis is presently unused in the `sorry` body but is the correct mathematical signature.
  - L181–197 `nonempty_jacobianWitness`: iter-127 known scaffold — NOT flagged. Docstring is long but honest about the deferral and identifies the classical construction (Sym^g + Abel–Jacobi or Picard scheme).
  - L208–219 `Jacobian` + L227, 231, 235, 238 protected instances: clean projections from the witness; honest one-liners.
  - L143–160 `JacobianWitness` structure: honest field-level documentation. The `isAlbaneseFor` field's uniformity over `P : 𝟙_ _ ⟶ C` is the load-bearing design choice (the Lean docstring on L131–142 explains the rationale).

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 123 lines. The "Hypothesis history" docstring (L43–79) is long but is a legitimate design-decision record (point-wise hypothesis was mathematically wrong; corrected to scheme-level via Frobenius counterexample). The named lemma `Scheme.Over.ext_of_eqOnOpen` is honestly closed via the Mathlib bridge to `ext_of_isDominant_of_isSeparated'`.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Re-audited per directive. Single declaration `rigidity_over_kbar` (L75–87) is the iter-126 scaffold with single `sorry` body — NOT flagged per directive. No new callers landed in `Jacobian.lean` this iter (only the docstring of `genusZeroWitness` *references* `rigidity_over_kbar` in prose; the witness body is itself `sorry`, so there is no actual code-level dependency yet — the body-closure path will introduce it later).
  - Module-level docstring "Encoding choice (iter-126 refactor agent note)" (L31–46) explains why Option B (abstract genus-0 curve) was chosen over Option A (literal `Spec(MvPolynomial …)`); this is a legitimate design-decision record. The iter-126 lean-auditor's three flagged majors on this file are deferred per the directive.

## Must-fix-this-iter

(none)

The three active sorry sites are explicitly recognised iter-126/iter-127 scaffolds with honest docstring status notes. Per directive instruction, they are not classified must-fix.

## Major

(none)

## Minor

- `AlgebraicJacobian/Jacobian.lean:118–126` — `geometricallyIrreducible_id_Spec` is declared but not referenced anywhere in the project, and its docstring claim ("needed for the genus-0 case of `Jacobian`") is stale: iter-127 absorbed the genus-0 case into `(jacobianWitness C).geomIrred`. The lemma may still be useful when the body of `genusZeroWitness` is closed (since the genus-0 witness's underlying scheme is `Spec k` and its structure morphism is `𝟙 (Spec (.of k))`), in which case the docstring should be updated to "queued for the future body-closure of `genusZeroWitness`" rather than the past-tense "genus-0 case of `Jacobian`". Either remove the lemma or update the docstring + add a `@[reducible]`-style breadcrumb to its future consumer.
- `AlgebraicJacobian/Jacobian.lean:86–87` — `IsAlbanese.unique` docstring oversells the conclusion. The statement `∃! e, h₂.ofCurve = h₁.ofCurve ≫ e` is unique-morphism, not unique-iso, even though the proof body computes (and discards) the inverse and the two round-trip identities. The blueprint's `rem:IsAlbanese_unique_iso` (`Jacobian.tex:90–100`) honestly acknowledges this is a deferred signature-tightening. The Lean docstring should mirror that disclosure with a one-liner like "Conclusion is morphism-unique; the inverse computed inside the proof is intentionally not exposed in the return type — see blueprint Remark IsAlbanese\_unique\_iso." This is documentation drift, not a correctness issue.

## Excuse-comments (always called out separately)

(none)

## Severity summary

- **must-fix-this-iter**: 0 — no new sorries on load-bearing decls introduced this iter; the three scaffolds are honestly framed.
- **major**: 0
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: iter-127 is honest — the `genusZeroWitness` scaffold landed cleanly with truthful docstring framing and no excuse-comment regressions, and the only audit findings are stale-comment / docstring-oversell residue around `geometricallyIrreducible_id_Spec` and `IsAlbanese.unique`.
