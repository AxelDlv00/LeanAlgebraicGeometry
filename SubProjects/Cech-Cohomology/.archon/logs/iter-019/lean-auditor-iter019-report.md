# Lean Audit Report

## Slug
iter019

## Iteration
019

## Scope
- files audited: 8
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechAcyclic.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Line 109: `sorry` on `CechAcyclic.affine` — confirmed as the **only** sorry in the file, consistent with the known-issues note.
  - Line 17 (module docstring): "The proof body is `sorry`; filling it is the task of the P3 prover lane." — accurate, not an excuse-comment.
  - Lines 36–59 and 79–108: large strategy/planner comments inside `CechAcyclic.affine`. These document the L1/L2/L3 work and the current gap. Informational, not excuse-comments.
  - Lines 1065–1071: `private noncomputable def spanIdx` using `Exists.choose`; docstring says "kept opaque so the spanning-element rewrite … has a type-correct motive". Per known issues; expected.
  - All declarations in `CombinatorialCech`, `AwayComparison`, `CechLocalized`, `SectionCechModule` namespaces: no sorry, no suspect bodies.
  - No `axiom` declarations found.

---

### AlgebraicJacobian/Cohomology/CechBridge.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 29–31: Module docstring header reads "## Declarations (to be filled by the prover)" and line 30 lists "`cechComplex_hom_identification` (planned)". But `cechComplex_hom_identification` IS implemented in this file (line 241–244). The header has not been updated to reflect completion; a future planner reading it would believe this declaration is still missing.
  - Lines 34–42: `injective_cech_acyclic`, `ses_cech_h1`, `cech_eq_cohomology_of_basis`/`affine_serre_vanishing` are listed as "(planned)" but are not present in the file — these are legitimate future targets, but the same stale header comment obscures which is done vs. not.
  - Line 119: "…the planned identification" referring to `cechComplex_hom_identification` — mild staleness, since that identification is now proved.
  - All five present declarations (`homCechCosimplicial`, `homCechComplex`, `homCechSectionIsoApp`, `homCechSectionCosimplicialIso`, `cechComplex_hom_identification`): no sorry, no suspect bodies. Proof strategy in `homCechSectionCosimplicialIso` (lines 208–229) uses `erw` heavily for defeq-carrier matching; this is expected per the iter-019 memory note on this technique.

---

### AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 19–22: Module-level docstring lists two declarations this file "owns": `cechFreePresheafComplex` (present, implemented) and `cechFreeComplex_quasiIso` (NOT present in the file). This creates a false impression that `cechFreeComplex_quasiIso` is a missing sorry/hole when it simply hasn't been added yet. The actual file ends with `quasiIso_of_evaluation`, which is preparatory infrastructure for `cechFreeComplex_quasiIso` but is not that declaration.
  - Lines 60 and 84: "DEAD END — do NOT…" guidance notes are positive planner annotations, not excuse-comments.
  - All present declarations: no sorry, no suspect bodies. `cechFreeSimplicial` and `cechFreePresheafComplex` are clean simplicial constructions.

---

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- **outdated comments**: 1 flagged (major)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - Line 715: `sorry` on `cech_computes_higherDirectImage` — confirmed as the **only** sorry in the file. Consistent with the known-issues note; frozen protected signature.
  - **Lines 347–387: Stale "not yet closed" narrative (major stale comment).** The block comment starting at line 347 reads "**Composition law `pushPullMap_comp` — reduced to an explicit clean pentagon, not yet closed.**" and line 373 says "**Why it is not yet closed (next-prover dead-ends, all hit this iter):**" — but `pushPullMap_comp` IS proved at line 564 (three-line proof via `rawPushPullMap_comp`). This directly contradicts the accurate comment at lines 161–170 which says "Both laws are proved axiom-clean below (see `pushPullMap_id` and `pushPullMap_comp`)". A future prover reading line 373 would conclude the composition law is still an open problem, which is false, and could invest effort re-proving something that already exists.
  - Lines 341, 404, 470: `set_option maxHeartbeats 1000000`, `4000000`, `1600000` on `pushPullMap_eq_raw`, `rawPushPullMap_self_gen`, `rawPushPullMap_comp`. These are unusually high limits suggesting fragile kernel-evaluation proofs; minor concern, not a defect.
  - All other declarations (including `CechNerve`, `pushPullFunctor`, `CechComplex`, `pushPullMap_id`, `pushPullMap_comp`, `rawPushPullMap_comp`): no sorry, bodies are well-formed.

---

### AlgebraicJacobian/Cohomology/HigherDirectImage.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single declaration `higherDirectImage` — clean, one-line definition using `rightDerived`. No issues.

---

### AlgebraicJacobian/Cohomology/HigherDirectImagePresheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All six declarations (`mapHomologyIso'`, `sheafificationAdditive`, `counitComplexIso`, `homologyIsoSheafify`, `pushforwardResolutionPresheafComplex`, `higherDirectImage_iso_sheafify_presheafHomology`): implemented, no sorry, no suspect bodies.
  - The `## Why I stopped` reference in the module docstring is a note about the scope boundary of the presheaf-homology identification. This is informational, not an excuse-comment.

---

### AlgebraicJacobian/Cohomology/PresheafCech.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All present declarations (`injective_toPresheafOfModules`, `freeYonedaHomEquiv`, `freeYonedaHomAddEquiv`, `sectionCechCosimplicial`, `sectionCechComplex`): implemented, no sorry.
  - Long planner strategy block (lines 33–196): contains the step-by-step plan for steps 1–5 of the P3b bridge. This is a planning document, not an excuse-comment.

---

### AlgebraicJacobian/Cohomology/AcyclicResolution.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 26–35 (module docstring): "The following declarations are outlined in the strategy block below and **will be constructed by the prover** in `mathlib-build` mode:" lists `InjectiveResolution.ofShortExact`, `Functor.rightDerivedShiftIsoOfAcyclic`, `Functor.rightDerivedIsoOfAcyclicResolution`. All three ARE constructed and proved in this file. Stale documentation.
  - Line 924: `/-! ### P4 complete — rightDerivedIsoOfAcyclicResolution is proved axiom-clean above. -/` — accurate status marker.
  - All major declarations (`quasiIso_τ₂`, `Functor.IsRightAcyclic`, `ofShortExact`, `rightDerivedShiftIsoOfAcyclic`, `rightDerivedOneIsoCokerOfAcyclic`, `cosyzygyShortExact`, `rightDerivedIsoOfAcyclicResolution`, etc.): no sorry. The `classical` at lines 693 and 1083 invokes standard `Classical.propDecidable`, not a suspect axiom.
  - Line 68: "an explicit Mathlib TODO" — references a Mathlib gap that we work around. Acceptable.

---

## Must-fix-this-iter

None. No sorry on load-bearing claims beyond the two authorized ones (known issues), no parallel API definitions, no unauthorized axioms, no weakened-wrong definitions, no excuse-comments.

---

## Major

- `CechHigherDirectImage.lean:347–387` — Stale "not yet closed" narrative on `pushPullMap_comp`. The block comment says the composition law is unproved and enumerates dead-ends "all hit this iter", but `pushPullMap_comp` (line 564) and `rawPushPullMap_comp` (line 473) are both proved. This comment contradicts line 168 ("Both laws are proved axiom-clean below") and will actively mislead any future agent or prover that reads it without consulting the actual proof at line 564. Should be replaced with a completion note.

- `CechBridge.lean:29–44` — Module docstring header "Declarations (to be filled by the prover)" labels `cechComplex_hom_identification` as `(planned)` despite it being implemented. Stale header will confuse plan/prover agents into treating an already-proved declaration as still open.

- `FreePresheafComplex.lean:19–22` — Module docstring lists `cechFreeComplex_quasiIso` as a file-level declaration. The declaration is not present; only its preparatory infrastructure is. This falsely implies a hole inside the file rather than a future task.

- `AcyclicResolution.lean:26–35` — Module docstring says named declarations "will be constructed by the prover" but all of them are constructed in the file. Stale status claim at the module level.

---

## Minor

- `CechHigherDirectImage.lean:341,404,470` — Three `set_option maxHeartbeats` values of 1M, 4M, and 1.6M. Very high heartbeat budgets indicate expensive defeq-eval proofs; not incorrect, but flagged as potentially fragile under Lean/Mathlib version changes.
- `CechAcyclic.lean:17` — Module docstring says "The proof body is `sorry`; filling it is the task of the P3 prover lane." Accurate and informative; slightly unusual as a module header description, but not problematic.

---

## Excuse-comments (always called out separately)

None found. The "stale status comments" above are outdated progress notes, not admissions that existing code is wrong.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 4
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: All 8 files are axiom-clean (sorry count matches the two known authorized holes); the four major findings are stale documentation comments — most dangerously `CechHigherDirectImage.lean:347–387`, which claims `pushPullMap_comp` is unproved when it is fully proved at line 564.
