# Lean Audit Report

## Slug
iter303

## Iteration
303

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (`maxHeartbeats` bump on a `rfl` lemma)
- **excuse-comments**: none
- **notes**:
  - L432: `set_option maxHeartbeats 1000000 in` on `pushPullMap_eq_raw`, whose proof is `:= rfl`.
    A `rfl` proof should cost ~0 elaboration heartbeats; needing 5× the default budget (200k → 1M)
    signals expensive `Over X`-packaging unification at elaboration time. The lemma is
    mathematically correct (holds by `rfl`), but the performance cost is a smell suggesting the
    `Over X` wrapping creates an elaboration diamond that the kernel must resolve slowly. Worth
    profiling before the next time `pushPullMap_comp` depends on it.
  - L189–321: ~135-line prose comment explaining the deferred `pushPullMap_comp` proof, including
    the iter-271 breakthrough and the current remaining obstacle. This is accurate documentation
    but extremely long for an inline comment block; it replicates content already in the blueprint
    and memory files. Minor code-smell — relevant content should live in the blueprint chapter, not
    inside the Lean file.
  - L438–477: Another ~40-line comment block for `pushPullMap_comp`. References "iter-271", which
    is 32 iterations old. Still accurate, but stale iteration numbers may mislead a future reader
    about the timeliness of the diagnosis.
  - `CechNerve`, `CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cech_flatBaseChange`:
    all `sorry` with honest, accurate explanations of what Mathlib ingredient is missing. These are
    not excuse-comments.
  - `coverArrow`, `coverCechNerve`, `relativeCechComplexOfNerve`, `pushPullObj`, `pushPullMap`,
    `pushPullMap_id`, `pushPull_unit_mate`, `pushPull_transport_cancel`, `pushPull_unit_comp`,
    `pushforwardComp_hom_app_id`, `rawPushPullMap`, `cechHigherDirectImage`: all well-formed,
    axiom-clean or correctly deferred.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 3 flagged (module header, multiple inline `iter-177+:` planning notes)
- **suspect definitions**: 1 flagged (`genericFlatness` missing coherence hypothesis)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L19 (module header)**: The `## Status` block says "iter-176 Lane E file-skeleton —
    re-dispatch" and "iter-177+: refinement". We are at iter-303; the status header is 127
    iterations stale. A reader cannot tell from the header whether this file is still a skeleton
    or has been substantially evolved since iter-176. Major stale comment.
  - **L287 `genericFlatness`**: The binder is `(F : X.Modules)` with no coherence condition.
    Generic flatness (Nitsure §4) is stated for a *coherent* sheaf; it is false for arbitrary
    quasi-coherent modules (e.g. the direct sum of all structure sheaves is quasi-coherent but
    not finitely presented, and need not satisfy generic flatness). The module docstring (L267–273)
    says "coherent `𝓞_X`-module" in prose but the Lean type imposes no such restriction. Since
    the body is `sorry`, no false theorem is currently proved, but any eventual proof must either
    weaken the conclusion, add `[IsCoherent F]` or equivalent, or remain unprovable. Suspect
    signature.
  - **Multiple `iter-177+:` comments** (e.g. L244–247, L282–285, L430–435, L514–516): Planning
    notes of the form "iter-177+: the body follows Nitsure §4 …" appear throughout. At iter-303
    these are 126+ iterations stale. They convey that the file was intended to be worked in an
    iter shortly after 176, but it has not been; a reader cannot tell if the `iter-177+` work
    has simply been deferred indefinitely. Minor stale-planning smell.
  - **`GenericFreeness` section (L160–212)**: Three lemmas with axiom-clean, non-sorry proofs.
    `exists_free_localizationAway_of_finite` uses `Module.FinitePresentation.exists_free_localizedModule_powers`
    with `nonZeroDivisors A` as the localization monoid and discards a fourth component (`_`); the
    proof is structurally plausible and Lean accepted it at commit. `exists_flat_localizationAway_of_finite`
    applies `Module.Flat.of_free` (standard) — sound. `exists_free_localizationAway_of_moduleFinite`
    reduces to the prior lemma via `Module.Finite.trans` — sound.
  - `flatLocusStratification`, `flatLocusReduction`, `flatLocusAssembly`, `flatteningStratification`,
    `flatteningStratification_universal`, `flatteningStratification.ofCurve`: all `sorry`, with
    accurate explanations of the missing Mathlib infrastructure. Not excuse-comments.
  - `CoherentSheafFlat`: Definition looks correct — affine-local flatness via `f.appLE`. No issue.
  - `IsProper π` as a stand-in for "projective" is documented intentionally and is actually correct
    for the Nitsure/Stacks 052H theorem (which is stated for proper morphisms). No issue.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 1 flagged (stale "iter-246" reference in planning comment)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (large planning-comment blocks embedded in proof bodies)
- **excuse-comments**: none
- **notes**:
  - **L415–516 (`sliceDualTransport` proof body)**: A ~100-line construction-plan comment block
    is embedded inside the proof body via `/- ... -/`. This describes what the proof *should*
    look like and why prior routes failed. Using a proof body as a documentation vehicle is an
    anti-pattern: a reader inspecting the goal state sees an enormous comment before reaching the
    actual code; Lean's elaboration must skip it. The content is valuable but belongs in the
    blueprint chapter, not inside the proof.
  - **L641–726 (`dual_restrict_iso` proof body)**: Similar anti-pattern. An ~86-line "Planner
    strategy" comment is embedded in the proof, describing steps 1–4 of the proof and their
    status. Again, accurate and useful, but misplaced inside a proof body.
  - **L1467–1497 (planning comment "D2' onward — handoff (iter-246)")** in TensorObjSubstrate:
    This comment references "iter-246" which is 57 iterations old. The content may be accurate
    but the iteration numbers mislead about recency.  *(Note: this comment appears in
    TensorObjSubstrate.lean near its D1'–D4' section; it is listed here because DualInverse.lean
    imports TensorObjSubstrate and the planning comment affects the same proof chain.)*
  - **`sliceDualTransportInv` (L298)**: Well-typed. The `hβ` hypothesis is correctly motivated
    (the β-compatibility identity is FALSE for arbitrary β, hence supplied by the caller). The
    `app` component is closed axiom-clean (iter-303). The `naturality` field is an honest `sorry`
    with accurate documentation.
  - **`unitRelabelSwap` (L274)**, **`isIso_ε_restrictScalars_presheafMap` (L262)**: New helpers,
    both well-formed and axiom-clean. `unitRelabelSwap` correctly uses `inv ε` of the relabel
    ring map; `isIso_ε_restrictScalars_presheafMap` correctly applies
    `restrictScalars_isIso_ε_of_bijective` fed by `bijective_of_isIso`. No issues.
  - **`sliceDualTransport` (L407)**: Four remaining `sorry` fields (naturality, invFun, left_inv,
    right_inv). All clearly documented. The `map_add'` and `map_smul'` proofs are closed and look
    structurally correct.
  - **`dual_isLocallyTrivial` (L836)**: The three-step chain compiles and is axiom-clean modulo
    the `dual_restrict_iso` Step-4 sorry. This transitive sorry inheritance is explicitly
    documented. The chain itself (`dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso`)
    is mathematically sound.
  - **`homOfLocalCompat` (L1017)**: CLOSED axiom-clean (iter-256). `set_option backward.isDefEq.respectTransparency false in`
    is correctly scoped (the `in` makes it affect only this definition). The ~170-line proof is
    elaborate but structurally sound (sheaf-hom gluing + linearity descent).
  - **`dualUnitRingSwap`, `dualUnitRingSwapInv`, `dualUnitRingSwapHom`**: All axiom-clean.
    The two `@[simp]` round-trip lemmas are correct (`IsIso.hom_inv_id`/`inv_hom_id`).
  - **`presheafDualUnitIso`, `dual_unit_iso`, `dualUnitIsoGen`**: All axiom-clean. The
    `left_inv` field in `unitDualSectionEquiv` correctly uses `naturality_apply` + `unit_map_one`.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 1 flagged (stale "iter-246" reference)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (`maxHeartbeats` bumps on two lemmas)
- **excuse-comments**: none
- **notes**:
  - **L1745: `set_option maxHeartbeats 1600000 in` on `pullbackSheafifyUnitEtaTriangle`**:
    8× the default (200k → 1.6M). The comment documents the reason (heavy sheafification
    machinery unification between `𝟙_Yp` and `(unit Y).val` defeq). Acceptable but should be
    noted.
  - **L1787: `set_option maxHeartbeats 3200000 in` on `pullbackEtaUnitSquare`**: 16× the
    default (200k → 3.2M). The comment documents the reason (mate-calculus telescope + syntactic
    `restrictScalars (𝟙)` strip). The proof itself is closed axiom-clean (iter-250). The
    heartbeat requirement is an ongoing technical debt: future refactors that simplify the `φ'`
    letI-spelling may reduce it.
  - **`exists_tensorObj_inverse` (L698)**: `sorry`. Body comment gives a precise decomposition
    into two remaining bridges (C: `dual_isLocallyTrivial`; A: `homOfLocalCompat`, now CLOSED).
    Bridge A is done; only the C-bridge blocks. Not an excuse-comment — the documentation is
    accurate and specific.
  - **`pullbackObjUnitToUnit_comp` (L915)**: New axiom-clean lemma. The proof uses `erw`
    throughout because `Scheme.Modules.pullback f` and `SheafOfModules.pullback` are defeq-not-
    syntactic. Structurally sound; the erw usage is documented and warranted.
  - **D1'–D4' proof section (L1320 onward)**: All the new bricks
    (`isIso_pullbackTensorMap_of_isIso_sheafifyDelta`, `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`,
    `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`, `sheafifyUnitIso`,
    `presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`, `compHomEquivFactor`,
    `sheafificationCompPullback_eq_leftAdjointUniq`, `leftAdjointUniqUnitEta`,
    `leftAdjointUniqUnitEta_app`, `restrictScalarsId_map`, `epsilonPresheafToSheafUnit`,
    `pullbackSheafifyUnitEtaTriangle`, `pullbackEtaUnitSquare`) are all axiom-clean or
    correctly structured. The `sheafificationCompPullback_comp` (D3' Sq1) still has one `sorry`;
    it is clearly identified.
  - **Planning comment L1467–1497** ("D2' onward — handoff (iter-246)"): References iter-246, now
    57 iterations old. The content is likely accurate, but the stale iteration number may mislead.
  - `tensorObj`, `tensorObj_functoriality`, `IsInvertible`, `dual`, `dualIsoOfIso`,
    `tensorObjIsoOfIso`, `tensorObj_unit_iso`, `tensorObj_left_unitor`, `tensorObj_right_unitor`,
    `tensorObj_braiding`, `tensorObj_assoc_iso`, `restrictIsoUnitOfLE`, `tensorObj_restrict_iso`,
    `tensorObj_isLocallyTrivial`, `isIso_of_isIso_restrict`, `homMk`, `picCommGroup`, etc.:
    All previously closed and unchanged in this iter. No new issues identified.

---

## Must-fix-this-iter

None. No excuse-comments, no weakened-wrong definitions with non-sorry bodies, no parallel APIs, and no axioms on load-bearing non-trivial claims were found. All sorry bodies are genuinely deferred with honest documentation.

---

## Major

- `FlatteningStratification.lean:19` — Module header says "iter-176 Lane E file-skeleton — re-dispatch"; we are at iter-303. The status comment is 127 iterations stale and gives a false impression of the file's age and progression. A future maintainer cannot tell from the header whether this file is still a skeleton or has evolved.

- `FlatteningStratification.lean:287` — `genericFlatness` takes `(F : X.Modules)` with no coherence or finite-presentation hypothesis. Generic flatness (Nitsure §4) requires the sheaf to be *coherent* (finitely presented); it is false for arbitrary quasi-coherent modules. The module docstring says "coherent `𝓞_X`-module" in prose but the Lean type imposes no such restriction. Any eventual proof must add `[IsCoherent F]` or equivalent, or remain unprovable as stated. The sorry body prevents a false theorem from being proved now, but the signature is suspect.

- `CechHigherDirectImage.lean:432` — `set_option maxHeartbeats 1000000 in` on `pushPullMap_eq_raw`, documented as proved by `rfl`. A genuine `rfl` proof should not require 5× the default heartbeat budget; this signals an expensive elaboration unification in the `Over X`-packaging. The lemma is correct, but the cost is a smell indicating the API design around `rawPushPullMap`/`pushPullMap` may create inadvertent elaboration work.

- `DualInverse.lean:415–516` — ~100-line construction-plan comment block embedded inside the `sliceDualTransport` proof body. Using a proof body as a documentation vehicle is a Lean anti-pattern: it clutters the proof state inspection experience, is not typechecked, and is hard to search. The content is valuable but belongs in the blueprint chapter.

- `DualInverse.lean:641–726` — ~86-line "Planner strategy" comment block embedded inside the `dual_restrict_iso` proof body. Same anti-pattern as above. In both cases the blocks should be moved to the blueprint or to a dedicated comment file and the proof body should contain only Lean code (and at most a brief status note).

- `TensorObjSubstrate.lean:1787` — `set_option maxHeartbeats 3200000 in` on `pullbackEtaUnitSquare` (16× the default). The lemma is axiom-clean, but the heartbeat cost is an ongoing performance debt. If this proof's elaboration exceeds 3.2M heartbeats in a more optimised build environment the CI will break silently (the option is per-declaration, so it overrides rather than warns). The `φ'`-letI spelling chain is the known culprit; the fix is a dedicated spelling-normalisation lemma.

---

## Minor

- `FlatteningStratification.lean` (multiple lines) — `iter-177+:` planning notes appear throughout (e.g. L244, L282, L430, L514). At iter-303 these are 126 iterations stale. They convey intent but misrepresent the recency of the deferred work.

- `CechHigherDirectImage.lean:189–321` — 135-line prose comment describing the deferred `pushPullMap_comp` proof, including the iter-271 breakthrough. Accurate content but excessively long for an inline comment; it replicates material in the blueprint and memory files.

- `CechHigherDirectImage.lean:438–477` — Planning comment for `pushPullMap_comp` references "iter-271" (32 iterations old). Still accurate, but stale iteration numbers reduce readability.

- `TensorObjSubstrate.lean:1467–1497` — Planning comment "D2' onward — handoff (iter-246)" is 57 iterations old. Content appears accurate; stale iteration number is misleading.

- `TensorObjSubstrate.lean:1745` — `set_option maxHeartbeats 1600000 in` on `pullbackSheafifyUnitEtaTriangle` (8× the default). The reason is documented. Less severe than the 16× case; noted for completeness.

- `TensorObjSubstrate.lean` (multiple) — `set_option backward.isDefEq.respectTransparency false in` appears twice (`homOfLocalCompat` in DualInverse.lean, `epsilonPresheafToSheafUnit` in TensorObjSubstrate.lean), both correctly scoped with `in`. Non-default defeq behaviour changes are notable but the scoping prevents bleed.

---

## Excuse-comments (always called out separately)

None found. Every `sorry` body carries an accurate explanation of the genuine mathematical or infrastructure obstacle; no declaration admits its own wrongness.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 6
- **minor**: 6
- **excuse-comments**: 0

Overall verdict: The four files are structurally sound — no axiom abuse, no wrong-definition excuse-comments, and all sorrys are honestly documented — but accumulate significant documentation debt: the `genericFlatness` signature is likely missing a coherence hypothesis, two proof bodies carry large planning-comment anti-patterns, the FlatteningStratification header is 127 iterations stale, and two lemmas carry heartbeat budgets (8× and 16× default) that may become CI liabilities.
