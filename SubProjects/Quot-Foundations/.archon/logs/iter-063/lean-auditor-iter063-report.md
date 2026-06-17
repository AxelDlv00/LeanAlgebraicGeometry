# Lean Audit Report

## Slug
iter063

## Iteration
063

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`ιFree_matrixEnd` (lines 966–974)**: Clean helper. `rfl` close after biproduct simp chain. No issues.
  - **`matrixEnd_pullback` (lines 983–1033)**: Complete axiom-clean proof. The repeated `erw` calls (lines 1017–1032) are the documented workaround for the `Scheme.Modules`/`SheafOfModules` instance diamond; each is accompanied by an accurate explanatory comment. `hQhom : … := rfl` (line 999–1000) is valid: `pullbackFreeIso` is defined by `exact SheafOfModules.pullbackObjFreeIso …` so the `.hom` equality is definitional. `haveI := opensMap_final p` (line 989) is load-bearing — it supplies the `Final` instance consumed by `isColimitCofanMkObjOfIsColimit (Scheme.Modules.pullback p)` on line 994. No issues.
  - **`pullbackBaseChangeTransport_matrixToFreeIso` (lines 1543–1587)**: Complete axiom-clean proof. The `erw [← Scheme.Modules.pullbackFreeIso_comp a p (Fin d)]` on line 1561 is the documented `free`/`∐`-value-diamond bridge (memory `grquot-matrixEnd-pullback-and-transport-core`). `hfront`/`hback` coherences correctly assemble the two comparison legs; `rfl` at line 1587 closes the residual associativity defeq. No issues.
  - **`bundleTransition_cocycle` (line 1045–1099, sorry at 1099)**: Honest sorry. The NOTE block (lines 1042–1098) accurately documents what remains (L3 matrix-to-module transport) and explicitly records that L1 (`bundleTransition_cocycle_matrix`) and L2 (`matrixToFreeIso_mul`) are done. The sorry is not silently load-bearing: `universalQuotient` (which consumes it) also has its own sorry, so no hidden transitivity. Well-documented and correctly labelled.
  - **`universalQuotient` (lines 1118–1119, sorry)**: Honest. NOTE correctly identifies the sole blocker (bundle cocycle) and distinguishes it from `glue` (already clean).
  - **`tautologicalQuotient` (lines 1128–1130, sorry)**: Honest. NOTE accurately chains the dependency: rides on `universalQuotient`, which rides on the cocycle.
  - **`represents` (lines 1677–1679, sorry)**: Honest. NOTE accurately states that `functor` and `glue` have landed; the sole blocker is `tautologicalQuotient`.
  - **Line 621–627** (`bundleTransition_self` body, "Resource note (iter-060)"): Historical iteration-specific comment explaining the OOM fix. Not misleading — the design decision (ISO-level proof, `pullbackFreeIso_trans_symm_eqToIso`) is still the actual proof in place. Minor clutter.

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: 2 flagged (one major, one minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`relTensorActL_proj_eq` (lines 672–675)**: Clean proof. `ext U : 2` peels the natural-transformation and carrier layers; `RelativeTensorCoequalizer.coeq_condition` closes the objectwise goal. Correct.
  - **`relativeTensorCoequalizerIso` (lines 702–706)**: Clean term-mode proof. `evaluationJointlyReflectsColimits` is the Mathlib colimit version of `evaluationJointlyReflectsLimits`; since the file type-checks axiom-clean the name resolves. `isColimitMapCoconeCoforkEquiv` is the cofork-specialised map-cone equivalence; again confirmed by type-checking. The proof structure (lift objectwise colimits via joint-reflection) is the correct pattern for functor-category coequalizers.
  - **Line 683 (in planner-strategy block comment `/- Planner strategy … -/`, lines 677–693)**: The note "NOTE (iter-063): leansearch only finds `evaluationJointlyReflectsLimits` (limits), not the colimit version; the colimit analogue may be `PresheafOfModules.evaluationJointlyReflectsColimits` or `CategoryTheory.Limits.combinedIsColimit` — verify before use." was written as planning context *before* the proof was completed in the same iteration. The proof immediately following it (lines 702–706) resolves the question — `evaluationJointlyReflectsColimits` exists and type-checks. The residual "verify before use" uncertainty in the comment is stale and could mislead a future reader into doubting the validity of `relativeTensorCoequalizerIso`. **Major finding** (see below).
  - **Lines 763–845** ("### (superseded handoff notes — retained for the additional `inferInstanceAs` detail)"): 82 lines of comment explicitly marked as superseded. While not misleading (the superseded label is clear), this is significant noise. **Minor finding**.
  - **Lines 847–962** (deferred `tensorPowAdd` planning block): Long historical planning block with iter-specific references (iter-052, iter-053, iter-063). Informative and not misleading — it accurately describes what remains open (`isIso_sheafification_whiskerRight_unit`, `tensorPowAdd`) and why. The declaration it describes (`tensorPowAdd`) is correctly absent from the file rather than sorry-ed. Fine.
  - **`relTensorActL` (lines 552–585), `relTensorActR` (lines 594–624), `relTensorProj` (lines 632–666)**: These landed in iter-060 per memory. Proofs are complete, correct, and no new issues. The `objRestrict` helper fixes the carrier-gap that previously blocked naturality. No issues.

---

## Must-fix-this-iter

None.

---

## Major

- `AlgebraicJacobian/Picard/SectionGradedRing.lean:683` — The planner-strategy block comment (lines 677–693) contains "NOTE (iter-063): leansearch only finds `evaluationJointlyReflectsLimits`… verify before use." This expressed uncertainty was resolved in the same iteration: `relativeTensorCoequalizerIso` (lines 702–706) uses `evaluationJointlyReflectsColimits` and type-checks axiom-clean. The stale note now sits directly above the declaration it doubts, potentially causing a future reader to second-guess whether the proof is valid. The uncertainty it documents no longer exists — the comment should be updated to record that `evaluationJointlyReflectsColimits` was confirmed to exist and the proof closed.

---

## Minor

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:621–627` — "Resource note (iter-060)" in `bundleTransition_self` body is an iteration-specific historical annotation. The information is accurate (the OOM fix is still in place) but the iteration reference adds clutter to a permanent theorem body.
- `AlgebraicJacobian/Picard/SectionGradedRing.lean:763–845` — 82 lines of block comment explicitly marked "superseded handoff notes". The superseded label prevents active misleading, but the volume of dead text is noise.
- `AlgebraicJacobian/Picard/SectionGradedRing.lean:890–958` — Long deferred planning block (the `tensorPowAdd` handoff) contains iter-specific status markers ("ITER-052 STATUS", "ITER-053 PROGRESS") that will become increasingly stale. The mathematical content is accurate, but periodic pruning of obsolete iter references would improve readability.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Clean iteration — all new declarations (`matrixEnd_pullback`, `ιFree_matrixEnd`, `pullbackBaseChangeTransport_matrixToFreeIso`, `relativeTensorCoequalizerIso`, `relTensorActL_proj_eq`) are honest, axiom-clean, and structurally sound; the four known-open sorries in GrassmannianQuot.lean are properly documented with accurate dependency chains; the only actionable finding is a stale "verify before use" planning note in SectionGradedRing.lean that should be updated to reflect the successful resolution.
