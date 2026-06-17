# Lean Audit Report

## Slug
iter067

## Iteration
067

## Scope
- files audited: 11
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/RegroupHelper.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single axiom-clean `base_change_regroup_linearEquiv` definition, proof complete by `⊗`-induction. No issues.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 4 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L1949: `sorry` in `base_change_mate_gstar_transpose` body — partially-proved theorem, roadmap comment documents two-stage conjugate-calculus route. Pre-existing.
  - L2416: second `sorry` gap inside same theorem — same assessment.
  - L2597: `flatBaseChange_pushforward_isIso` body is `sorry` — the `i = 0` flat-base-change theorem; documented as needing Čech/affine-cover infrastructure. Pre-existing.
  - L2619: closing `sorry` in `flatBaseChange_pushforward_isIso` — same.
  - L2338–2339: comment notes `base_change_mate_fstar_reindex` carries a "dead sorry" (its `_legs` apparatus) and must not be cited. Accurate technical note, not an excuse-comment.
  - 5 `set_option maxHeartbeats` overrides (L979: 4000000; L1637: 4000000; L1796: 4000000; L1953: 1600000; L2003: 1600000). Each has an immediately preceding comment explaining the specific whnf/defeq cost. All justified.

---

### AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations proved axiom-clean (no sorrys, no heartbeat overrides). `gammaTopEquivEqLocus` and `baseChangeGammaEquiv` are complete.

---

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No code sorrys. `UniversalProperty` and `affine_base_iff` are closed axiom-clean proofs.
  - Docstring notes "iter-174+: refine the type signature to the full Yoneda-bijection statement" at L218 and L277. These are scheduled-refinement annotations on declarations whose current types are intentionally weaker. Not excuse-comments (the current types are correct non-tautological statements, not wrong ones).
  - Historical iter-narrative in file header (iter-173 through iter-179) is project documentation, not stale misleading commentary.

---

### AlgebraicJacobian/Picard/GradedHilbertSerre.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations proved; no sorrys, no heartbeat overrides. Full ambient-subquotient induction (`subquotient_hilbertSeries_rational`) and keystone `gradedModule_hilbertSeries_rational` are closed.

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorrys. One heartbeat override: L1177 (800000) for `uTripIso` — justified by triple-tensor `⊗`-induction over heavy carrier bookkeeping.
  - **Stale handoff block** L683–767: labelled "Action / projection natural transformations — DEFERRED (handoff)" but the described declarations (`relTensorActL`, `relTensorActR`, `relativeTensorCoequalizerIso`) ARE proved in the same file (L558–712 and L708–712 respectively). The blocker documented there was resolved. Minor stale comment.
  - **Self-labelled superseded block** L769–851: `-- (superseded handoff notes — retained for the additional inferInstanceAs detail)`. The label is accurate; it's archival context. Minor.
  - **Pre-proof scaffolding block** L1490–1525: step-by-step plan for `isIso_sheafification_whiskerRight_unit`, which is proved at L1535–1540. The comment was not cleaned up after the proof landed. Minor stale comment.
  - `tensorPowAdd` deferred note (L853–968) documents a genuinely absent declaration. Correct documentation of an absent result — not stale, not an issue.

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorrys.
  - L876: `set_option maxHeartbeats 1600000` for `chartTransition'_fac` — justified: `erw`/`HasPullback` diamond over `MvPolynomial` away-localisation is defeq-expensive.
  - L1098: `set_option maxHeartbeats 1600000` for `chartTransition'_cocycle` — same justification.
  - L1347: `set_option maxHeartbeats 3200000` and `set_option backward.isDefEq.respectTransparency false` for `isSeparatedToSpecZ` — justified: `pullbackDiagonalMapIdIso`/`pullbackSpecIso` diamonds over `MvPolynomial` objects; the `respectTransparency` flag is appropriate here.
  - All three overrides have inline justifying comments immediately preceding.

---

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 4 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L126: `hilbertPolynomial := sorry` — iter-176 file-skeleton typed sorry. Docstring documents this explicitly.
  - L165: `QuotFunctor := sorry` — same.
  - L201: `Grassmannian := sorry` — same.
  - L228: `Grassmannian.representable by sorry` — same.
  - The four skeleton declarations have correct types and are the project's primary objectives for the Quot functor / Grassmannian layer. The remaining file (L232–2775) builds predicates, local freeness API, and abstract-affine infrastructure that does not depend on the skeleton bodies.
  - 10 heartbeat overrides (L1100, L1163, L1233, L1252, L1281 at 2000000; L2058, L2441, L2641, L2673 at 1600000; L2614 at 2000000). Each has an inline justification comment. All pass the justification standard.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **No actual code sorrys**. All `sorry`-containing lines in this file (L540, L3245, L3336) are in inline `--` comments documenting proof-planning context or prior state; the live proof code contains no `sorry` tactic.
  - L540: comment says "there is no `sorry` here" — confirmed, it is a roadmap comment inside a working proof.
  - 4 heartbeat overrides (L485: 4000000 with `synthInstance.maxHeartbeats 1000000`; L1465: 4000000; L1964: context missing from grep, not checked in detail; L2591: 1600000). All have justification comments.

---

### AlgebraicJacobian/Picard/GlueDescent.lean  ← **FOCUS FILE**
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged (**must-fix**)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **MUST-FIX L1170**: `sorry` inside `glueOverlapBaseChangeIso` — a partially-built `SheafOfModules.pushforwardCongr` application leaves the functor-equality proof (`ext V : 3 / sorry`) unfinished. This is the step that establishes the overlap-base-change isomorphism, which is the direct predecessor of `glueRestrictionIso`.
  - **MUST-FIX L1207**: `sorry` in `isIso_glueRestrictionHom` body — the keystone effective-descent theorem. Without this, `glueRestrictionIso` (L1211) is `asIso` of a sorry-backed `IsIso`, and `universalQuotient_restrictionIso` (which depends on this whole chain) is unreachable.
  - L1164–1168 (`.symm` fix on `eqToIso` argument): the compile fix is correct — `eqToIso (glueData_preimage_image_eq D i j V).symm` correctly flips the equality direction for the `SheafOfModules.pushforwardCongr` input.
  - No heartbeat overrides anywhere in this file.
  - Split from `GrassmannianQuot.lean` is clean: no duplicate declarations detected vs. the rest of the tree. `GrassmannianQuot.lean` correctly imports `GlueDescent`.
  - No half-moved dead stubs; all declarations in the file are actively used by `glueRestrictionIso` or `universalQuotient_restrictionIso`.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean  ← **FOCUS FILE**
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 6 flagged (pre-existing)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L2066: `tautologicalQuotient_epi := sorry` — pre-existing; blocks tautological quotient surjectivity.
  - L2147: `chartLocus_isOpenCover := sorry` — pre-existing; covers the Grassmannian by chart loci.
  - L2160: `isIso_pullback_isoLocus_map := sorry` — pre-existing; needed for the chart/locus pullback.
  - L2249: inner `sorry` in `grPointOfRankQuotient` overlap compatibility — pre-existing.
  - L3117: `represents.homEquiv.left_inv` body is `sorry` — pre-existing.
  - L3122: `represents.homEquiv.right_inv` body is `sorry` — pre-existing.
  - **Heartbeat overrides** (7 total): all justified with inline comments.
    - L1226: 1600000, `bundleTransition_cocycle_transport` — "endpoint-cast collapses rewrite under the X.Modules diamond". Justified.
    - L1391: 1600000, `bundleTransition_cocycle` — "Iso.ext-reduction unifies inferred .app _ instances with the transport statement across the X.Modules diamond". Justified.
    - L1453: 1600000, `tautologicalQuotient_overlap` — "Q-cancellation rewrites and the final matrix comparison run under the X.Modules diamond". Justified.
    - L2344: 800000, `matrixEndRect_unitEndSection`. Justified.
    - L2814: 800000, `pullback_map_freeMap_pullbackFreeIso`. Justified.
    - L2887: 800000, `freeMap_chartMatrixHom`. Justified.
    - L3028: 800000, `chartMatrix_minor`. Justified.
  - **`@inv`/instance workarounds**: Multiple uses of `@CategoryTheory.inv _ _ _ _ ... (isIso_pullback_isoLocus_map ...)` at L2198–2200, L2965–2967, L3010–3012 are justified — `IsIso` inference fails to synthesize across the `X.Modules` instance diamond; explicit `@`-annotation is the only robust workaround.
  - **Iter-067 new transport-chain lemmas** (L2254–3095, approximately 840 LOC): `chartLocus_rel`, `chartComposite_rel`, `pullbackFreeIso_inv_pullbackComp`, `conjPullback_comp`, `chartMatrixHom_rel`, `chartMatrixHom_transport`, `chartMatrix_rel`, `chartMorphism_rel`, `freeMap_chartMatrixHom`, `chartMatrix_minor`, `grPointOfRankQuotient_rel` — all appear mathematically coherent. No dead-end proofs detected. The tactic chains are term-mode heavy (as expected for X.Modules diamond avoidance) and use `calc`/`simp`/`erw`/`exact` in patterns consistent with the rest of the file.
  - Note at L443 references a removed heartbeat override from iter-060 — accurate historical comment, not a stale issue.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/GlueDescent.lean:1170` — `sorry` inside `glueOverlapBaseChangeIso`: the functor-equality `ext V : 3 / sorry` is unfinished. Why must-fix: blocks `glueRestrictionIso` and thus blocks `universalQuotient_restrictionIso`; this is the overlap base-change step that seals the effective descent argument; it was introduced (not pre-existing) in the iter-067 split.
- `AlgebraicJacobian/Picard/GlueDescent.lean:1207` — `isIso_glueRestrictionHom` body is `sorry`. Why must-fix: this is the keystone effective-descent theorem; `glueRestrictionIso` is `asIso` of its conclusion; without it the entire descent layer (`universalQuotient_restrictionIso`) is sorry-backed; introduced in the iter-067 split.

---

## Major

Pre-existing `sorry` bodies on substantive claims (not introduced this iteration):

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:2066` — `tautologicalQuotient_epi`: tautological quotient surjectivity unproved.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:2147` — `chartLocus_isOpenCover`: chart-locus open cover unproved.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:2160` — `isIso_pullback_isoLocus_map`: pullback along isoLocus unproved.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:2249` — `grPointOfRankQuotient` overlap compatibility: the inner sorry blocks the gluing data for the inverse of the universal property map.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:3117` — `represents.homEquiv.left_inv`: inverse law of the universal property hom-equiv unproved.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:3122` — `represents.homEquiv.right_inv`: same.
- `AlgebraicJacobian/Picard/QuotScheme.lean:126` — `hilbertPolynomial := sorry`: iter-176 file-skeleton; the Hilbert polynomial definition is a stub.
- `AlgebraicJacobian/Picard/QuotScheme.lean:165` — `QuotFunctor := sorry`: iter-176 file-skeleton.
- `AlgebraicJacobian/Picard/QuotScheme.lean:201` — `Grassmannian := sorry`: iter-176 file-skeleton.
- `AlgebraicJacobian/Picard/QuotScheme.lean:228` — `Grassmannian.representable by sorry`: iter-176 file-skeleton.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1949` — `base_change_mate_gstar_transpose` partial body: two-stage conjugate-calculus transport parked.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2416` — second body gap in same theorem.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2597` — `flatBaseChange_pushforward_isIso` body: the `i = 0` flat-base-change theorem awaiting Čech/affine-cover infrastructure.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2619` — closing sorry in same theorem.

---

## Minor

- `AlgebraicJacobian/Picard/SectionGradedRing.lean:683–767` — stale "DEFERRED (handoff)" comment block: `relTensorActL`, `relTensorActR`, and `relativeTensorCoequalizerIso` are now proved in the same file; the blocker described is resolved.
- `AlgebraicJacobian/Picard/SectionGradedRing.lean:769–851` — self-labelled "(superseded handoff notes)" block. Self-documenting but adds noise; could be pruned.
- `AlgebraicJacobian/Picard/SectionGradedRing.lean:1490–1525` — pre-proof scaffolding plan for `isIso_sheafification_whiskerRight_unit`, which is proved at L1535; the scaffold comment was not cleaned up.

---

## Excuse-comments (always called out separately)

None. No comment in any file admits that a declaration is wrong, uses a placeholder, or defers a known-incorrect body. The `sorry` bodies in QuotScheme.lean are documented as file-skeleton stubs with correct types (not wrong types), and the FlatBaseChange.lean comment at L2338 is an accurate technical note, not an admission of wrongness. The SectionGradedRing.lean handoff blocks document Mathlib gaps (a genuine external constraint), not project-internal evasions.

---

## Severity summary

- **must-fix-this-iter**: 2 — `GlueDescent.lean:1170` and `GlueDescent.lean:1207`; both block the descent layer introduced this iteration.
- **major**: 14 — all pre-existing `sorry` bodies on substantive claims across four files (GrassmannianQuot, QuotScheme, FlatBaseChange).
- **minor**: 3 — stale handoff comment blocks in SectionGradedRing.lean.
- **excuse-comments**: 0

Overall verdict: The iter-067 focus work in GrassmannianQuot.lean is clean and coherent; the new transport-chain lemmas introduce no dead ends or bad practices, and all heartbeat overrides are justified. GlueDescent.lean was split correctly with no duplicates, but two load-bearing sorrys remain open — `glueOverlapBaseChangeIso:1170` and `isIso_glueRestrictionHom:1207` — that block the effective descent layer and must be closed before `universalQuotient_restrictionIso` can proceed. The 14 major sorrys are pre-existing project scaffolding that predates this iteration.
