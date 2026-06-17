# Lean Audit Report

## Slug
review129

## Iteration
129

## Scope
- files audited: 13 (all project `.lean` files under `AlgebraicJacobian/`, the top-level aggregator, and `references/challenge.lean`)
- files skipped: 0 (multilane lane snapshots under `.archon/lanes/**` and `.archon/multilane/**` are working copies, not project source — out of scope)

## Per-file checklist

### AlgebraicJacobian.lean (top-level aggregator)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All 12 imports resolve to files that actually exist under `AlgebraicJacobian/`. Aggregator is coherent.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Status block (line 14) is rooted at iter-073 with an explicit reduction story; the three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) each open with four `letI`s that re-import the four witness fields. Body shapes match the docstring at lines 14–29. Pre-existing long-line warning at line 22 noted in directive as known.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Three theorems + one definition (`relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`, `kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`, `smooth_locally_free_omega`). Forward Jacobian-criterion theorem (line 124) is honestly stated with the converse-direction disclosure inline; this is the right level of care. No iter-126 excise residue detected.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Single `genus` definition. The body `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` is the honest math.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Phase A steps 2–4. Three closed declarations, status block coherent.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Single `HasSheafCompose` instance, closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Large file (~880 lines) with heavy iter-tagged annotations. No `sorry`. The historical-note block at line 463–486 documents an explicit removal of the abandoned `IsAffineHModuleHomFinite` carrier; this is appropriately scoped as documentation (not an excuse-comment, because the abandoned scaffold has been removed, not left in place under a TODO). The line-504 parenthetical "no new axiom introduced" claims hygiene I cannot verify from reading alone; non-blocking.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - MV LES core + Mathlib gap-fill (`Abelian.Ext.chgUnivLinearEquiv`, `HModule'_cohomologyPresheafFunctor`, `_toBiprod`, `_fromBiprod`, `_δ`, `_sequence`, `_sequence_exact`, `δ`-zero simp companions). No `sorry`. Two `set_option backward.isDefEq.respectTransparency false in` usages are technical but documented.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 2-affine cover MV + cover-totality bridges + `IsCechAcyclicCover`/`HasCechToHModuleIso` consumers + `HasAffineCechAcyclicCover` carrier. No `sorry`. `cechToHModuleIso` (line 506) uses `Classical.choice` honestly; the carrier class wraps `Nonempty` data, the extractor is `noncomputable`.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 2 (lines 65–81; lines 95–101)
- **suspect definitions**: 1 (`cotangentSpaceAtIdentity`, body documented as degenerate by sibling iter-129 mathlib-analogist — see "Known issues" in the directive)
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0 (no `-- TODO`, `-- temporary`, `-- placeholder` literals; the docstring drift below is a different category)
- **notes**:
  - Iter-129 refactor renamed `lieAlgebra` → `cotangentSpaceAtIdentity` and relaxed `[SmoothOfRelativeDimension 1 G.hom]` to `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`; the body is the unchanged iter-128 4-step `extendScalars` term.
  - Per the directive's "Known issues" block, the body is mathematically degenerate (computes the zero `k`-module) — out of scope here, do not re-derive. However: the docstring (line 65–81) still claims "this is a finitely-generated free `k`-module of rank equal to the relative dimension of `G.hom`", and the closing paragraph (line 99–101) still claims "The structural properties (`Module.Free k`, `Module.Finite k`, rank `= n`) are content for the iter-129+ rank lemma." Both claims contradict the analogist's finding and will mislead readers / iter-130's Replacement (B). See "Major" for the explicit flags.
  - The file-level status block (line 28–39) reads "is fully constructed (no `sorry`) via the pullback-along-section bridge described in the declaration's docstring." This is true at the Lean level (the term checks) but misleading at the mathematics level (the term is not the cotangent space). Flagged below.
  - Minor: the docstring still mentions "The Lie algebra `𝔤` of `G` … is the `k`-linear dual of this module; downstream consumers that need `𝔤` may take `Module.Dual k (cotangentSpaceAtIdentity G)`." (line 73–77). The directive notes the iter-129 refactor "rewrote the docstring to drop the dualisation convention." This snippet is residual dualisation-convention prose; mentioned as informational, not blocking.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 2 (line 195; line 226 — discussed below)
- **suspect definitions**: 0 in this file's own bodies (the two `sorry`s are tracked, intentional, and called out in the directive's "Known issues")
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Header (line 14–53) accurately enumerates the two `sorry`-bodied declarations: `genusZeroWitness` (iter-127 scaffold, line 188) and `nonempty_jacobianWitness` (Phase-C OFF-LIMITS, line 208). Verified against `grep \bsorry\b`: exactly two `sorry` bodies in this file at lines 192 and 211.
  - However, two per-declaration docstrings have NOT been updated alongside the iter-129 header rewrite:
    - Line 194–207 (`nonempty_jacobianWitness` docstring) opens "This is the single remaining mathematical sorry of the Phase-C Jacobian scaffolding". With `genusZeroWitness` having joined the file at iter-127, "single remaining" is no longer literally correct.
    - Line 222–230 (`Jacobian` docstring) closes "the existence of such a witness is the single remaining mathematical sorry of the Phase-C scaffolding." Same issue.
  - These do not mislead about *correctness*, only about *count*; flagged as Major (docstring/header disagreement after a deliberate header rewrite). Compare to the file header at line 19: "This file currently contains TWO `sorry`-bodied declarations".
  - The "Forbidden shortcut (sanity check)" block at line 44–53 is a useful design note that survives the rewrite cleanly; not flagged.
  - The four protected instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) project cleanly from the witness; no suspect bodies.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - The "Hypothesis history" block (line 44–79) explicitly documents the iter-003 strengthening of the rigidity hypothesis (from topological to scheme-level equality on `U`) and the iter-125 unused-hypothesis cleanup. Both are factual records, not excuse-comments. `Scheme.Over.ext_of_eqOnOpen` is honestly closed via `ext_of_isDominant_of_isSeparated'`.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 0
- **suspect definitions**: 0 in body shape; one tracked `sorry` (iter-126 scaffold) called out in directive's "Known issues"
- **dead-end proofs**: 1 (`rigidity_over_kbar`, line 75–87, `sorry` body) — tracked
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Signature unchanged since iter-126. The "Encoding choice" block (line 31–46) documents the directive-recommended Option B (abstract genus-0 curve over `kbar`) and notes the Option A literal is mathematically wrong (`Spec(MvPolynomial)` is affine, not projective). Historical / informational.
  - The `(_hgenus : genus C = 0)` and `(_hf : p ≫ f = η[A])` underscore-prefixed binders explicitly document that the body is `sorry` (so the hypotheses are not yet consumed). This is appropriate.
  - No drift since iter-126: the `iter-129+` references in the docstring (line 27, 73) match the directive's tracking of the cotangent-vanishing pile.

### references/challenge.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: n/a (this is the upstream challenge spec, not project source)
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Pinned to Mathlib `b80f227` (20 April 2026). Five `sorry`-bodied declarations + three protected instance `sorry`s. This is the *reference statement file* the project is formalizing against; the `sorry`s here are not project debt.

## Must-fix-this-iter

(Empty.) Nothing in this audit meets the must-fix bar:
- No literal excuse-comment tokens (`-- TODO replace`, `-- temporary`, `-- placeholder`, `-- wrong but works`) were found anywhere in project source.
- No `axiom` declarations were introduced.
- No `:= True` / `:= rfl`-on-substantive-claim / `:= Classical.choice _` shortcuts on non-trivial claims (the one `Classical.choice` use, `cechToHModuleIso` in `MayerVietorisCover.lean:506`, is an honest extractor for a `Nonempty`-wrapped class field, the standard pattern).
- The three live `sorry`s (`Jacobian.lean:192`, `Jacobian.lean:211`, `RigidityKbar.lean:87`) are all intentional, tracked in the directive's "Known issues", and surrounded by docstrings that disclose their status.
- The `cotangentSpaceAtIdentity` body's mathematical degeneracy is an out-of-scope finding by the sibling iter-129 mathlib-analogist agent; the iter-130 Replacement (B) is staged to swap the body. Per directive, I do not re-flag the existence of that finding.

## Major

- `AlgebraicJacobian/Cotangent/GrpObj.lean:70` — Docstring asserts "this is a finitely-generated free `k`-module of rank equal to the relative dimension of `G.hom`; the iter-129+ companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (in a follow-up declaration) pins the rank to `n`". Per the directive's "Known issues" block, the iter-129 mathlib-analogist found the body is degenerate (zero `k`-module). The docstring claim is now stale and will mislead the iter-130 Replacement (B) lane. Refresh to disclose the degeneracy before the body swap, or refresh together with the body swap.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:99` — "This compiles to a `ModuleCat k` with no `sorry`. The structural properties (`Module.Free k`, `Module.Finite k`, rank `= n`) are content for the iter-129+ rank lemma." Same stale-claim category as the preceding finding — the structural properties listed cannot hold for the current degenerate body.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:28` — File-level status block: "is fully constructed (no `sorry`) via the pullback-along-section bridge described in the declaration's docstring." True at the Lean level, but the implication ("the bridge gives the right `k`-module") is the iter-129 analogist's reported failure. Worth refreshing to "compiles via the pullback-along-section bridge, but the underlying `k`-module is currently degenerate; replacement scheduled for iter-130" or equivalent, so a future reader doesn't have to cross-reference the analogist report.
- `AlgebraicJacobian/Jacobian.lean:195` — `nonempty_jacobianWitness` docstring opens "This is the single remaining mathematical sorry of the Phase-C Jacobian scaffolding". After iter-127 introduced `genusZeroWitness` (also `sorry`-bodied), the count is two, not one. The iter-129 header rewrite (line 19, "TWO `sorry`-bodied declarations") corrects the top-level prose but missed this per-declaration claim. Refresh to "one of two remaining mathematical sorries" or similar.
- `AlgebraicJacobian/Jacobian.lean:226` — `Jacobian` docstring closes "the existence of such a witness is the single remaining mathematical sorry of the Phase-C scaffolding." Same issue as the preceding finding.

## Minor

- `AlgebraicJacobian/Cotangent/GrpObj.lean:73–77` — Residual dualisation paragraph ("The Lie algebra `𝔤` of `G` … is the `k`-linear dual of this module; downstream consumers that need `𝔤` may take `Module.Dual k (cotangentSpaceAtIdentity G)`"). The directive notes the iter-129 refactor "rewrote the docstring to drop the dualisation convention" — this surviving paragraph is partial cleanup. Low-impact; not blocking.

## Excuse-comments (always called out separately)

None found. No literal `-- TODO replace with real def`, `-- temporary`, `-- placeholder`, `-- wrong but works`, `-- will fix later`, or equivalent tokens occur in project source. (The `sorry` bodies in `Jacobian.lean` and `RigidityKbar.lean` are accompanied by long, *substantive* docstrings that explain the gating dependencies on future iterations — those are status documentation, not excuse-comments.)

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5 — all five are docstring/status-block drift in `Cotangent/GrpObj.lean` and `Jacobian.lean` after iter-127/iter-129 refactors that updated bodies + headers but missed the per-declaration prose.
- **minor**: 1 — residual dualisation paragraph in `Cotangent/GrpObj.lean`.
- **excuse-comments**: 0

Overall verdict: The project's `.lean` code is structurally clean — no excuse-comments, no `axiom`, no suspect short-cut bodies on substantive claims — but the iter-129 refactor of `Cotangent/GrpObj.lean` and the iter-127 header rewrite of `Jacobian.lean` each left per-declaration docstrings out of sync with the file-level status; refresh these prose blocks before iter-130's body swap so a fresh reader doesn't take the stale rank-`n` / "single remaining sorry" claims at face value.
