# Lean Audit Report

## Slug
iter040

## Iteration
040

## Scope
- files audited: 1 (directive narrowed scope to one file)
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 5 flagged (pre-existing `Sheaf.val` deprecation; 1 `show`-should-be-`change` linter warning; `synthInstance.maxHeartbeats` comment placement)
- **excuse-comments**: none
- **notes**:
  - **L127 / L243 — `set_option backward.isDefEq.respectTransparency false`:** Used on both `presentationOverBasicOpen` and `overBasicOpenIsoRestrict`. This option affects only the *elaborator* (the unifier's transparency during tactic elaboration), **not the kernel**. Lean 4's kernel runs an independent check at full reduction regardless of any elaborator options; it would reject any term with a genuine kernel-level type mismatch. The file has no errors, confirming kernel acceptance. This is a legitimate technique for category-theory code where semireducible transparency prevents the unifier from recognising definitional equalities that are valid at full reduction. **Not a soundness risk.**
  - **L259–262 — `ext U : 3; simp [...]; rfl` in `overBasicOpenIsoRestrict`:** The goal before `rfl` (confirmed by LSP) is:
    ```
    ⊢ (forget₂ CommRingCat RingCat).map
          ((Spec R).sheaf.obj.map (𝟙 ((overEquivalence.inverse.obj U).left).op)) =
        (forget₂ CommRingCat RingCat).map (𝟙 Γ(Spec R, ι ''ᵁ U))
    ```
    Both sides apply `forget₂.map` to an identity morphism on the same open: `(overEquivalence.inverse.obj U).left` is definitionally `ι ''ᵁ U` (by the construction of `overEquivalence.inverse`), and `Functor.map_id` is definitional for sheaf presheaves. This `rfl` closes a genuinely definitional equality — it is **not** the spurious thin-category-coherence rfl trap. The kernel verifies it by full reduction.
  - **L266–275 — `pullbackObjUnitToUnit_isIso_basicOpen`:** Proof establishes `IsIso (base)` and `Final (Opens.map base)` via chained `haveI`s, then closes with `infer_instance`. All intermediate goals confirmed by LSP (no unsatisfied goals, no sorry). The `asIso` call inside the `IsEquivalence` branch is safe: `IsIso (base)` is already in context at that point.
  - **L282–288 — `restrictBasicOpenUnitIso`:** The `@asIso _ _ _ _ _ (pullbackObjUnitToUnit_isIso_basicOpen g)` call is correct. The six explicit arguments to `@asIso` are `(C, inst, X, Y, f, IsIso_instance)` — five wildcards inferred, one explicit. The instance supplied is the correct `IsIso` proof for `pullbackObjUnitToUnit`.
  - **L298–314 — `presentationModulesRestrictBasicOpen`:** The explicit `hpc : Limits.PreservesColimitsOfSize.{u, u, u, u, u+1, u+1}` correctly matches the expected universe parameters of `Presentation.map` in the specific context where `C = C' = Opens (Spec R)` with `u₁ = u₂ = u`, `v₁ = v₂ = u`, giving `max u u₁ = u` and `max (max (u+1) u₁) v₁ = u+1`. The `inferInstance` for `hpc` is typed explicitly so instance search does not miss the universe parameters. LSP confirms the `exact @Presentation.map ...` closes the remaining goal with no goals remaining.
  - **L292 — `set_option synthInstance.maxHeartbeats 400000`:** Linter flags that the explanatory comment should appear *after* (not before) the `set_option` line. The comment explaining the need is present at L289–291 but placed above the option. Minor style issue only.
  - **L196, 214, 233, 240, 241 — `Sheaf.val` deprecation:** Five uses of the deprecated `CategoryTheory.Sheaf.val` accessor; Mathlib now expects `ObjectProperty.obj`. All are in pre-existing declarations (`overBasicOpenRingHom`, `overBasicOpenRingInvHom`, `modulesOverBasicOpenEquivalence`), not in the four new declarations.
  - **L47 — `show` should be `change`:** Pre-existing linter warning in `Opens.overEquivalence_functor_coverPreserving`. The `show` tactic is being used to *change* the goal, not merely annotate it for readability.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `QcohRestrictBasicOpen.lean:196,214,233,240,241` — Five uses of deprecated `Sheaf.val`; migrate to `ObjectProperty.obj`. Pre-existing, not introduced this iter.
- `QcohRestrictBasicOpen.lean:292` — `set_option synthInstance.maxHeartbeats 400000` linter warning: explanatory comment is present but placed *before* the `set_option` line rather than after it. Move the comment to follow the `set_option` line to satisfy the linter.
- `QcohRestrictBasicOpen.lean:47` — `show` tactic changes the goal; linter recommends `change`. Pre-existing.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3 (all pre-existing; none in the four new declarations)
- **excuse-comments**: 0

Overall verdict: The four new declarations (`overBasicOpenIsoRestrict`, `pullbackObjUnitToUnit_isIso_basicOpen`, `restrictBasicOpenUnitIso`, `presentationModulesRestrictBasicOpen`) are sound — the `backward.isDefEq.respectTransparency false` option does not mask kernel-level unsoundness, the `ext/simp/rfl` closure in `pushforwardCongr` is genuinely definitional, and the explicit `@`-applied instance arguments (`hpc`, `@asIso`, `@Presentation.map`) are correctly typed; no must-fix findings.
