# Lean Audit Report

## Slug
iter033

## Iteration
033

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File is 93 lines with 3 declarations; all have genuine proof bodies — no `sorry`.
  - `Scheme.exists_finite_affineCover_inter_isQuasiCompact` (lines 37–46): proof uses `isCompact_iff_finite_and_eq_biUnion_affineOpens` and `quasiSeparatedSpace_iff_forall_affineOpens`. Both names are project-local claims about Mathlib API; **build verification is required** to confirm these names exist and have the stated signatures. Mathematical argument is correct if the API names resolve.
  - `Modules.gammaIsLimitSheafConditionFork` (lines 64–67): body is `((isSheaf_iff_isSheafEqualizerProducts M.presheaf).mp M.isSheaf U).some`. The expression `M.presheaf` and the field `M.isSheaf` for `M : X.Modules = SheafOfModules X.ringCatSheaf` rely on an API path not independently verifiable without a build. If `SheafOfModules` does not expose `.presheaf` and `.isSheaf` directly (Mathlib's `SheafOfModules` accesses the underlying presheaf via `.val.presheaf`), this line would fail to type-check. **Build verification required.** Mathematical intent is sound.
  - `Modules.exists_finite_affineCover_isLimit_sheafConditionFork` (lines 78–91): proof combines the two preceding lemmas. Universe instantiation `ι := ↥s` is correct (`X : Scheme.{u}` ⟹ `X.Opens : Type u` ⟹ `s : Set X.affineOpens` ⟹ `↥s : Type u`). The two remaining goals (cover equation, quasi-compactness of intersections) are dispatched genuinely via `iSup_subtype'` and `hqc`.
  - Overall: new file appears genuine and well-structured. No excuse-comments. No placeholder proofs.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: 4 sorries (all carry comments; assessed below)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:

**Sorry at line 1495** (`base_change_mate_fstar_reindex_legs`):
  - Genuine in-progress sorry. The long comment (lines 1427–1494) accurately describes:
    - what has been achieved (steps i–iii-a: `subst`, four-factor Γ-distribution, `keyPFC` collapse), and
    - what remains: the cross-layer cancellation of factors living in different functor images (`(Spec φ)_* ⋙ Γ_R` vs. `Γ_R' → gammaPushforwardIso → restrictScalars`) across the `gammaPushforwardIso ψ` codomain layer.
  - The comment is technically accurate, not laundering.
  - **No excuse-comment.** The comment is a progress report, not an admission that the code is structurally wrong.

**Sorry at line 1867** (`base_change_mate_gstar_transpose`):
  - Genuine in-progress sorry. Comment (lines 1764–1866) is detailed and accurate.
  - The "REPROVEN INLINE" note at lines 1791–1793 is accurate: it correctly states that `base_change_mate_fstar_reindex` is sorry-backed (via `base_change_mate_fstar_reindex_legs`) and so **cannot** be cited here without laundering the sorry. This is self-aware and correct.
  - The "recipe step 1 COMPLETE" in the `huce` scaffold comment (line 1844) is accurate within its own scope: step 1 (`huce` derived) is done; steps 2–3 (inline reindex + generator close + dictionary cancellation) remain open. The sorry closes the open steps.
  - **No laundering.** The transitive sorry-backing chain is not hidden.

**Sorry at line 2048** (`affineBaseChange_pushforward_iso`):
  - Genuine in-progress sorry inside a partial proof. The `apply base_change_map_affine_local` step is genuine progress; the per-`U` goal then carries a sorry.
  - Comment (lines 2028–2047) accurately describes the remaining obstacle: the restriction-compatibility of `pushforwardBaseChangeMap` (naturality of the adjunction transpose under restriction to affine opens), which is "itself Mathlib-absent and is the remaining multi-hundred-LOC build."
  - **No laundering.**

**Sorry at line 2070** (`flatBaseChange_pushforward_isIso`):
  - Skeleton sorry on the top-level Stacks 02KH theorem. Comment accurately describes the proof plan (Čech complex + flatness argument) and the missing infrastructure.
  - **No laundering.**

**Transitively sorry-backed declarations — disclosure check:**
  - `base_change_mate_section_identity` (line 1896): proof delegates to `base_change_mate_gstar_transpose` (which carries the line-1867 sorry). Doc comment (lines 1887–1895) explicitly states "body has no inline `sorry`" and "transitively `sorry`-backed through `base_change_mate_gstar_transpose`." **ACCURATE.**
  - `base_change_mate_generator_trace` (line 1925): uses `rw [base_change_mate_section_identity]` + `infer_instance`; transitively sorry. Doc comment (lines 1959–1964) explicitly states the same. **ACCURATE.**
  - `pushforward_base_change_mate_cancelBaseChange` (line 1966): uses `base_change_mate_generator_trace`; transitively sorry. Doc comment (lines 1960–1964) explicitly states the same. **ACCURATE.**
  - No declaration marked "proved" / "axiom-clean" is found to be undisclosed-transitively-sorry-backed.

**Outdated comment flags:**
  - Line 845: "STATUS (iter-011, route (a) executed): the def is **fully proved, no `sorry`**" — this is an old progress note from iter-011, attached to `base_change_mate_regroupEquiv`. The declaration IS fully proved (no sorry in its body, confirmed by grep). The comment is historically accurate but **stale** in style: it references a past iteration number and is now dead prose. Low-severity staleness.
  - Line 224–246 (the long "UPDATE (resolved)" comment): accurate description of how `pushforward_spec_tilde_iso` was proved. No inaccuracy, but it is iteration-narrative prose embedded in source code. Minor staleness concern.

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (zero sorries)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File has zero `sorry` occurrences. All new declarations have genuine proof bodies.
  - **`pullbackιIso` (lines 1267–1271):** Genuine noncomputable definition using `(Limits.limit.isLimit _).conePointUniqueUpToIso ((theGlueData d r).vPullbackConeIsLimit i j)`. This uses the universal property of the limit cone from the `GlueData` structure. Correct and non-vacuous.
  - **`Grassmannian.isSeparated` is ABSENT.** The `/-! ### Separatedness ... -/` section comment at lines 1273–1289 refers to it as a "blueprint target" and describes the proof strategy, then explicitly notes "The remaining geometric assembly ... is the remaining work for the next iteration." No declaration `Grassmannian.isSeparated` exists in the file. No doc comment falsely claims the result is proved. **CLEAN.**
  - **Heartbeat overrides:**
    - Line 876: `set_option maxHeartbeats 1600000 in` before `chartTransition'_fac` — carries explanatory comment: "The `erw` through the `HasPullback` instance diamond on the heavy `MvPolynomial` localisation objects is defeq-expensive; the raised limit covers it." **ACCEPTABLE.**
    - Line 1098: `set_option maxHeartbeats 1600000 in` before `chartTransition'_cocycle` — carries explanatory comment: "The `simp`/`Iso.inv_hom_id_assoc` cancellation of the conjugating pullback isomorphisms over the heavy `MvPolynomial` away-localisation objects is defeq-expensive; raised limit." **ACCEPTABLE.**
  - New ring-theoretic helpers (`transitionPreMap_minorDet_swap_mul`, `diagonalRingMap`, `diagonalRingMap_left`, `diagonalRingMap_right`, `diagonalRingMap_surjective`, `pullbackιIso`): all have genuine proofs. The `diagonalRingMap_surjective` proof correctly uses `IsLocalization.surj` + a witness `a ⊗ₜ (P^J_I)^n`, matching the blueprint strategy.
  - `chartTransition'_cocycle`: proof uses `h6` (six `Spec.map` composition = identity via `cocyclePhiId`) + `simp only [chartTransition', ..., Iso.inv_hom_id_assoc]` + `reassoc_of% h6, Iso.hom_inv_id`. Looks correct.
  - `theGlueData` (lines 1141–1152): correct assembly of the `Scheme.GlueData` fields from proved building blocks.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none
- **suspect definitions**: 4 flagged (skeleton sorry-bodies on blueprint-pinned declarations)
- **dead-end proofs**: 4 skeleton sorries
- **bad practices**: none
- **excuse-comments**: 4 flagged
- **notes**:

**4 skeleton sorry declarations with excuse-comments:**
  - `hilbertPolynomial` (line 123–126): body is `:= sorry`. Comment at lines 119–122: "iter-177+: the body unfolds to the graded-Euler-characteristic construction once ... **For the iter-176 file-skeleton the body is a typed `sorry`.**" — "for the iter-NNN file-skeleton the body is a typed sorry" is equivalent to "-- placeholder" or "-- will fix later." **Excuse-comment pattern; sorry on a substantive claim.**
  - `QuotFunctor` (line 161–165): body is `:= sorry`. Comment at lines 156–160: "iter-177+: the body packages... **For the iter-176 file-skeleton the body is a typed `sorry`.**" — same pattern. **Excuse-comment.**
  - `Grassmannian` (line 198–201): body is `:= sorry`. Comment at lines 193–197: same pattern. **Excuse-comment.**
  - `Grassmannian.representable` (line 225–228): body is `sorry`. Comment at lines 218–224: "iter-177+: the body follows Nitsure §1... **For the iter-176 file-skeleton the body is a typed `sorry`.**" — same pattern. **Excuse-comment.**

  **Mitigating context (recorded, does not change severity):** No downstream code within the file depends on these 4 declarations. The types are mathematically correct. The comments are accurate descriptions of the skeleton status, not misleading. These are intended project goals, not stand-in wrong implementations. The sorry-bodies are present precisely because the full proofs are multi-iteration work. Nevertheless, under the auditor's strict rules, these are excuse-comments on substantive claims.

**4 new infra decls in `SliceGeometricPresentation` (lines 1037–1121):**
  - `isIso_unitToPushforwardObjUnit_of_isIso'` (private, lines 1037–1055): genuine proof. Uses `NatTrans.isIso_iff_isIso_app`, `isIso_iff_of_reflects_iso`, and component-level isomorphism from `ψ`. Non-vacuous. No sorry.
  - `overRestrictUnitIso` (lines 1069–1079): genuine proof. Uses `asIso` + `isIso_unitToPushforwardObjUnit_of_isIso'` + `inferInstanceAs (IsIso (𝟙 _))`. Non-vacuous. No sorry.
  - `overRestrictPresentation` (lines 1095–1098): genuine one-liner composing `Presentation.ofIsIso` with `Presentation.map`. Non-vacuous. No sorry.
  - `presentationPullbackιOfQuasicoherentData` (lines 1100–1121): body is `overRestrictPresentation (q.X i) M (q.presentation i)`. Heartbeat options `set_option maxHeartbeats 2000000 / synthInstance.maxHeartbeats 800000 / backward.isDefEq.respectTransparency false` carry the explanatory comment at lines 1114–1116: "The heartbeat headroom tames the slice-site `IsRightAdjoint`/`HasSheafify` synthesis blow-up that `Presentation.map` triggers across the equivalence functor (the same `backward.isDefEq.respectTransparency false` incantation Mathlib's own `QuasicoherentData.bind` uses)." **ACCEPTABLE.** Non-vacuous. No sorry.

**OverSiteSheafEquivalence declarations (lines 786–880):**
  - All 6 declarations (`overEquivalence_functor_isCocontinuous`, `overEquivalence_inverse_isCocontinuous`, `overEquivalence_inverse_isDenseSubsite`, `overEquivalence_functor_isContinuous`, `overEquivalence_inverse_isContinuous`, `overEquivalence_sheafCongr`): genuine proofs filling the Mathlib `Topology/Sheaves/Over.lean` TODO. No sorries. No heartbeat overrides. Proofs reference real Mathlib lemmas (`GrothendieckTopology.mem_over_iff`, `Sieve.overEquiv_iff`, `Equivalence.isDenseSubsite_inverse_of_isCocontinuous`, `Equivalence.toAdjunction.isContinuous_of_isCocontinuous`, etc.).

**OverRestrictBridge declarations (lines 916–993):**
  - `overRestrictEquiv`, `overRestrictFunctorIso`, `overRestrictIso`, `overRestrictPullbackIso`: genuine; no sorries.
  - `overRestrictEquiv` uses `SheafOfModules.pushforwardPushforwardEquivalence` with two ring-sheaf comparisons built via `Sheaf.Hom.mk` + explicit `simp`/`erw` steps. The proof is elaborate and appears genuine.

**annihilator_isLocalizedModule_eq_map** (lines 362–422): 61-line proof; genuine. Uses `IsLocalization.mk'_surjective`, `IsLocalizedModule.mk'_smul_mk'`, `IsLocalizedModule.eq_zero_iff`, `Finset.dvd_prod_of_mem`, etc. Non-trivial and non-vacuous.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/QuotScheme.lean:122` — Comment "For the iter-176 file-skeleton the body is a typed `sorry`." on `hilbertPolynomial`, with forward-plan "iter-177+: the body unfolds to..." This is an excuse-comment ("placeholder until iter-177+") on a substantive blueprint declaration. Why must-fix: the comment pattern "typed sorry for now, will be real later" is the canonical excuse-comment form; the declaration's body is `:= sorry`.
- `AlgebraicJacobian/Picard/QuotScheme.lean:160` — Same pattern on `QuotFunctor`. Why must-fix: same.
- `AlgebraicJacobian/Picard/QuotScheme.lean:197` — Same pattern on `Grassmannian`. Why must-fix: same.
- `AlgebraicJacobian/Picard/QuotScheme.lean:224` — Same pattern on `Grassmannian.representable`. Why must-fix: same.

**Auditor note on severity:** These 4 sorry declarations are the explicitly-declared PROJECT GOALS of QuotScheme.lean. The types are mathematically correct; no downstream code within the file depends on them; the comments honestly describe the skeleton status. The must-fix classification follows strictly from the auditor rulebook ("excuse-comments on any declaration, no exceptions"). The plan agent should record these as known planned-work sorries rather than hidden defects; the remediation is filling the proofs in future iterations, not removing the declarations.

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean:43` — API name `isCompact_iff_finite_and_eq_biUnion_affineOpens` used in `Scheme.exists_finite_affineCover_inter_isQuasiCompact`. Not independently verifiable without a build; if this lemma does not exist with this exact name and signature, the file will not compile. **Build verification required.**
- `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean:46` — API name `quasiSeparatedSpace_iff_forall_affineOpens` used in same theorem. Same concern. **Build verification required.**
- `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean:67` — `M.presheaf` and `M.isSheaf` on `M : X.Modules` in `Modules.gammaIsLimitSheafConditionFork`. `X.Modules = SheafOfModules X.ringCatSheaf`; in current Mathlib the presheaf is not necessarily accessible via `.presheaf` directly on `SheafOfModules` objects. **Build verification required.**

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:845` — Historical STATUS comment ("STATUS (iter-011, route (a) executed): the def is **fully proved, no `sorry`**") attached to `base_change_mate_regroupEquiv`. The declaration IS fully proved. Comment is accurate but stale iteration-narrative prose embedded in source code. Harmless staleness.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:224` — Long "UPDATE (resolved)" comment about a previously-worried route. Accurate but is iteration-narrative. Harmless staleness.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1844` — "LANDED SCAFFOLD (iter-022, recipe step 1 COMPLETE — verified compiling)" inside `base_change_mate_gstar_transpose`. The sorry at line 1867 is step 2–3; this comment remains accurate for step 1. Minor confusing iteration-narrative.

---

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/QuotScheme.lean:119–122`: "iter-177+: the body unfolds to the graded-Euler-characteristic construction once `χ` of a coherent sheaf on a noetherian scheme + Snapper's polynomial-eventually-property are in scope. For the iter-176 file-skeleton the body is a typed `sorry`." (attached to `hilbertPolynomial`). Severity: **must-fix-this-iter** (project-skeleton placeholder that documents planned rather than present content).
- `AlgebraicJacobian/Picard/QuotScheme.lean:156–160`: Same pattern on `QuotFunctor`. Severity: **must-fix-this-iter**.
- `AlgebraicJacobian/Picard/QuotScheme.lean:193–197`: Same pattern on `Grassmannian`. Severity: **must-fix-this-iter**.
- `AlgebraicJacobian/Picard/QuotScheme.lean:218–224`: "iter-177+: the body follows Nitsure §1 ... For the iter-176 file-skeleton the body is a typed `sorry`." (attached to `Grassmannian.representable`). Severity: **must-fix-this-iter**.

---

## Severity summary

- **must-fix-this-iter**: 4 — QuotScheme.lean skeleton sorry declarations with excuse-comments (see plan note: these are known project goals, not hidden defects; remediation is iterative proof work).
- **major**: 3 — API names in FlatBaseChangeGlobal.lean requiring build verification.
- **minor**: 3 — Stale iteration-narrative comments in FlatBaseChange.lean.
- **excuse-comments**: 4 (counted above under must-fix-this-iter).

Overall verdict: The four audited files are structurally sound. FlatBaseChange.lean's four sorries are genuine, accurately described, and properly disclosed (including transitive sorry-backing). GrassmannianCells.lean is entirely sorry-free with all new declarations genuine. FlatBaseChangeGlobal.lean's three new declarations are non-vacuous but use several Mathlib API names requiring build confirmation. QuotScheme.lean's four blueprint-pinnned sorry declarations carry excuse-comments that technically meet the must-fix bar, though the plan agent should record these as known iterative-development placeholders rather than quality failures.
