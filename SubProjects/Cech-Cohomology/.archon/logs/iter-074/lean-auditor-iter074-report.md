# Lean Audit Report

## Slug
iter074

## Iteration
074

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 2 flagged
- **excuse-comments**: 0
- **notes**:
  - **Line 15** (module header): "Carries the residual sorry `coreIso_comm_leg`." The `sorry` is directly in `pushPull_interLegHom_sections` (line 1012); `coreIso_comm_leg` is only tainted *transitively* via its call to that lemma (line 1074). The description is misleading for anyone reading the header to understand the proof gap.
  - **Line 1012**: `sorry` in `pushPull_interLegHom_sections` — this is the known authorized residual named in the directive. No issue with its presence.
  - **Line 33**: `private lemma abHom_finsetSum_apply` — documented as "(Local copy of the `CechAcyclic` private helper `ab_hom_finsetSum_apply`.)". One of four private-helper duplicates across the three files (see Major section).
  - **Line 246-258**: `private lemma overSigmaHomEq` — documented as "(local copy of the `CechSectionIdentificationBase` private helper)". `CechSectionIdentificationBase.lean` has `overSigma_hom_eq` in `CategoryTheory.FinitaryPreExtensive`; this is a re-proof inside the `WPCIproj` section in `AlgebraicGeometry`. Fourth private-helper duplicate.
  - **Lines 957-998**: `private noncomputable def pushPullLegIso` and `private lemma pushPull_leg_coherence` — scaffolding prepared for the intended proof of `pushPull_interLegHom_sections`, but that lemma is currently `sorry`. Neither `pushPullLegIso` nor `pushPull_leg_coherence` is referenced anywhere else in the file. They are orphaned until the sorry is closed; a reader would find them surprising.
  - **Lines 1102, 1137**: `set_option maxHeartbeats 6400000` on `coreIso_comm_coface` and `coreIso_comm_sum` — 6.4× the project default. The proofs close correctly (no `sorry`), so this is a performance observation, not a correctness issue. Potential proof-golf target.
  - **Lines 109-115**: `set_option maxHeartbeats 1600000` on `cechNerve_drop_δ` whose proof is `:= rfl`. The comment explains the `whnf` depth of the augmented-cosimplicial packaging. This is legitimate: the kernel must unfold the packaging even for `rfl`.
  - `eqToHom`/`Subsingleton.elim` fusions (e.g. `map_op_eqToHom_swap` line 1017-1025): correct thin-category pattern — no unsound `rfl`-terms detected.
  - No `have key := … ; exact key` patterns detected.
  - No axioms or `Classical.choice _` on substantive claims.

---

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 2 flagged
- **excuse-comments**: 0
- **notes**:
  - Module-level docstring (lines 8-22): accurately states "0 sorries" with the caveat about upstream `sorryAx` taint. Correct.
  - **Lines 215-228**: `private lemma stubRestrTrans` — "(local copy of the `CechBridge` private helper `restr_trans`.)". **Lines 226-230**: `private lemma stubRestrUnique` — "(local copy of the `CechBridge` private helper `restr_op_unique`.)". Two more private-helper duplicates (see Major section).
  - **Lines 80-122**: Long inline planner-strategy block inside the body of `cechSection_complex_iso`. Accurately describes the proof approach and is not an excuse-comment. However it is lengthy code-internal planning prose that belongs in the blueprint or proof journal, not in the production proof body.
  - **Lines 1059-1106**: Similar planner strategy block inside `cechSection_contractible`. Same observation.
  - `set_option maxHeartbeats` bumps at lines 52, 561, 847, 926, 1107 all have accompanying comments explaining the source of increased `whnf` cost. All proofs close; no sorry.
  - `set_option maxRecDepth 8000` at line 1107 on `cechSection_contractible`: required by the coinductive depth of `Homotopy.mkCoinductive`. Legitimate.
  - `erw` at line 61 (`erw [coreIso_comm 𝒰 F V 0 1 rfl]`): the comment at lines 53-54 explains why `rw` stalls. Legitimate use.
  - No `have key := … ; exact key` patterns or `Classical.choice _` on substantive claims.
  - No axioms introduced.

---

### AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean
- **outdated comments**: 1 flagged (major)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 1 flagged
- **excuse-comments**: 0
- **notes**:
  - **Lines 9-42 (module-level docstring)**: Declares this file contains items 5 and 6 of the Sub-brick A chain — `cechSection_complex_iso` and `cechSection_contractible` — and includes a "SIGNATURE FIX (iter-067)" note referencing those declarations. **After the iter-074 file split**, both declarations now live in `CechSectionIdentification.lean`. This docstring was not updated and actively misrepresents the file's contents. (See Major section.)
  - **Lines 703-708**: "**Status: L2 DONE.**" inline tracking block. Accurate (the proofs are closed), but workflow/status commentary belongs in the proof journal, not in production source. Minor.
  - `private lemma overSigma_hom_eq` (line 293, `CategoryTheory.FinitaryPreExtensive` namespace): this is the original copy that `CechSectionIdentificationLeg.lean:246` re-proves. Not stale within this file.
  - **Lines 590-618, 1190-1228**: Long inline planner strategy comments inside `cechBackbone_left_sigma` and `pushPull_sigma_iso`. Same observation as in Rest: accurate but lengthy.
  - `pcd_hom_fst` proof (line 241) uses `simp` after `simp only` and `congr 1`. Fragile style but functional.
  - `set_option maxHeartbeats` and `synthInstance.maxHeartbeats` bumps all accompanied by explanatory comments. All proofs close.
  - No `sorry`, no axioms, no `Classical.choice _` on substantive claims.
  - No `have key := … ; exact key` kernel-defeq tricks detected.

---

## Must-fix-this-iter

*None.* The single `sorry` in scope (Leg:1012, `pushPull_interLegHom_sections`) is the authorized residual identified in the directive. No wrong definitions, no excuse-comments on load-bearing declarations, no unauthorized axioms.

---

## Major

- `AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean:9-42` — Module-level docstring lists items 5 (`cechSection_complex_iso`) and 6 (`cechSection_contractible`) as contents of this file, and carries a "SIGNATURE FIX (iter-067)" note referencing `sectionCechAugV`/`sectionCechAugV_comp_d`. After the iter-074 split all four declarations now live in `CechSectionIdentification.lean`. The docstring was not updated and misleads a reader about the file's scope.

- `AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean:33`, `Leg:246`, `CechSectionIdentification.lean:215`, `CechSectionIdentification.lean:226` — Four documented private-helper duplicates across three files: `abHom_finsetSum_apply` (copy of `CechAcyclic` private), `overSigmaHomEq` (copy of Base's `overSigma_hom_eq`), `stubRestrTrans` (copy of `CechBridge`'s `restr_trans`), `stubRestrUnique` (copy of `CechBridge`'s `restr_op_unique`). Each copy is clearly documented, but the pattern indicates the originals should eventually be made non-private or moved to a shared location. Until then, any change to an original requires manual propagation to all copies.

---

## Minor

- `AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean:15` — Module header says "Carries the residual sorry `coreIso_comm_leg`"; the `sorry` is directly in `pushPull_interLegHom_sections` (line 1012). `coreIso_comm_leg` is only tainted transitively. Should read "Carries the residual sorry `pushPull_interLegHom_sections` (consumed by `coreIso_comm_leg`)."

- `AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean:957-998` — `pushPullLegIso` and `pushPull_leg_coherence` are private, currently unreferenced within the file (orphaned while `pushPull_interLegHom_sections` is sorry). They are scaffolding for the intended proof; not removable, but a reader would be confused by their presence.

- `AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean:1102` and `Leg:1137` — `set_option maxHeartbeats 6400000` on `coreIso_comm_coface` and `coreIso_comm_sum`. Proofs are correct, but 6.4× the default is a notable performance mark. These should be revisited for proof-golf once the sorry is closed upstream.

- `AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean:703-708` — "Status: L2 DONE" inline tracking comment. Accurate but belongs in the proof journal, not in production source.

- `CechSectionIdentificationBase.lean:590-618, 1190-1228`; `CechSectionIdentification.lean:80-122, 1059-1106` — Long inline planner-strategy blocks embedded in proof bodies. Not excuse-comments (all accurately describe closed or nearly-closed proofs), but they add several hundred lines of planning prose to the source. These should migrate to blueprint chapter annotations or the proof journal after the remaining sorry is closed.

---

## Excuse-comments (always called out separately)

None found. No declaration in any of the three files carries a comment admitting the code is wrong, placeholder, or will be fixed later — beyond the authorized `sorry` with its geometrically precise statement of what remains to be proved.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: The three files are structurally sound after the iter-074 split; the sole `sorry` is the known authorized residual `pushPull_interLegHom_sections`; the main actionable finding is an unupdated module-level docstring in `CechSectionIdentificationBase.lean` that still lists `cechSection_complex_iso` and `cechSection_contractible` as in-this-file contents.
