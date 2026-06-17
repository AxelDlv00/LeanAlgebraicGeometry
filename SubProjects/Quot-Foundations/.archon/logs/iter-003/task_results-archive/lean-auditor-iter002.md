# Lean Audit Report

## Slug
iter002

## Iteration
002

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged
- **excuse-comments**: none
- **notes**:
  - **L181–244 (section docstring, "Status/Update" block)**: The paragraph starting "What remains for the full object iso `pushforward_spec_tilde_iso`" (lines ~233–244) describes a pending QC obligation as "the sole remaining obligation" and lists three candidate routes. However, the code at line 535 (`pushforward_spec_tilde_iso`, `pushforward_spec_tilde_iso_of_isLocalizedModule`) implements the third route ("direct `Modules.isIso_of_isIso_app_of_isBasis` construction … via `IsLocalizedModule`") and `lean_verify` confirms it axiom-clean. The comment fails to record its own resolution and will mislead readers into thinking `pushforward_spec_tilde_iso` is blocked.
  - **L181,206,213 and L541,566**: Comments contain "iter-234", "iter-236", "iter-240", "iter-241" — iteration numbers from the source project (Algebraic-Jacobian-Challenge). This project is Quot-Foundations and is at iter-002. These references are orphaned stale context; no reader of this project's history can trace them.
  - **L291,330,333,337,367,381,383,431,482,509,512,520,569,574,576,577,580,581,583,602,612**: 22 uses of `CategoryTheory.Sheaf.val`, which the Lean 4 / Mathlib compiler reports as deprecated ("Use ObjectProperty.obj"). These do not cause errors now but will break when the deprecated shim is removed.
  - **L754–758 (`base_change_map_affine_local`)**: The theorem carries two phantom typeclass hypotheses `[IsAffineHom f]` and `[F.IsQuasicoherent]` that are completely unused in the proof body. The proof is `(Modules.isIso_iff_isIso_app_affineOpens _).mpr H`, which requires neither. `lean_verify` confirms the theorem uses only {propext, Classical.choice, Quot.sound} — no instance synthesis touches the two phantom hypotheses. They are unnecessary in this theorem's signature (though the caller `affineBaseChange_pushforward_iso` needs them for a different reason).
  - **L291,580,738**: Lines exceed the 100-character style limit (linter warning).
  - **L717 (`pushforward_base_change_mate_cancelBaseChange`)**: sorry — genuine, see analysis below.
  - **L766 (`affineBaseChange_pushforward_iso`)**: sorry — genuine; proof correctly reduces via `base_change_map_affine_local` before sorry'ing the affine-restriction-compatibility step.
  - **L806 (`flatBaseChange_pushforward_isIso`)**: sorry — genuine; Čech/affine-cover infrastructure absent.
  - All completed declarations (lines 76–693) are axiom-clean: `lean_verify` returns {propext, Classical.choice, Quot.sound} for every completed theorem and def checked (`pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`, `base_change_map_affine_local`, `fromTildeΓ_app_isIso_of_isLocalizedModule`, `Modules.isIso_of_isIso_app_of_isBasis`, `Modules.isIso_iff_isIso_stalkFunctor_map`).

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L218 (docstring of `genericFlatness`)**: "iter-177+:" iteration reference — stale from source project.
  - **L188–197 (`genericFlatnessAlgebraic`, `by_cases Module.Finite A M`)**: the split is honest. Primary branch (`haveI := hAM; exact GenericFreeness.exists_free_localizationAway_of_finite A M`) is genuinely closed: all hypotheses are available, `lean_verify` on `GenericFreeness.exists_free_localizationAway_of_finite` returns {propext, Classical.choice, Quot.sound}. Secondary branch (`sorry`) is a real sorry for the Nitsure §4 dévissage (prime filtration + Noether normalisation + polynomial-ring core). No hidden cheat.
  - **L181 (`genericFlatnessAlgebraic`)**: sorry in the secondary branch only — honest.
  - **L229 (`genericFlatness`)**: sorry after two genuine compilable steps (`IsIntegral.nonempty`, `exists_isAffineOpen_mem_and_subset` both confirmed present in Mathlib). The remaining obligation is accurately described. No inflated progress claim.
  - **`GenericFreeness` namespace** (lines 94–146): all three declarations (`exists_free_localizationAway_of_finite`, `exists_flat_localizationAway_of_finite`, `exists_free_localizationAway_of_moduleFinite`) are axiom-clean — {propext, Classical.choice, Quot.sound} only.

---

## Focus-area analysis (per directive)

### `pushforward_base_change_mate_cancelBaseChange` — is `IsIso (Γ(α))` genuine or vacuous?

**Genuine, non-trivial content.** Diagnosis:

1. `moduleSpecΓFunctor (R := R')` is the global-sections functor `(Spec R').Modules ⥤ ModuleCat R'`. It does NOT map every morphism to an isomorphism; it is faithful but not full or iso-reflecting in general.
2. `pushforwardBaseChangeMap` is constructed via a non-trivial adjoint-mate composition (adjoint transpose of a unit-pushforward-pushforwardComp-pushforwardCongr chain) and is not definitionally trivial.
3. The claim `IsIso (Γ(α))` is equivalent (by the blueprint's 4-step generator trace) to identifying `Γ(α)` with `(TensorProduct.AlgebraTensorModule.cancelBaseChange R A R' M M)⁻¹`, which is a Mathlib `LinearEquiv` — hence an isomorphism without flatness. This is genuine content.
4. The sorry is deferred because the mate-unwinding coherence — specifically, identifying `Limits.pullback.fst` / `.snd` over `pullback (Spec.map φ) (Spec.map ψ)` with the `Spec`-of-tensor inclusions via `AlgebraicGeometry.pullbackSpecIso`, then tracing the mate — is a multi-step verification that Mathlib does not package. The comment accurately identifies this as the outstanding obligation.
5. **No tautology** and **no hidden dodge** detected.

### `genericFlatnessAlgebraic` — honest `by_cases`?

**Yes, honest.** The primary branch (`Module.Finite A M`) is fully closed — every required instance (`[AddCommGroup M]`, `[Module A M]`, `[Module.Finite A M]` via `haveI`) is present and `GenericFreeness.exists_free_localizationAway_of_finite` is axiom-clean. The secondary branch (`¬ Module.Finite A M`) is a real sorry: the Nitsure §4 argument for a finite-type-but-not-module-finite `M` requires a polynomial-ring-core generic-freeness lemma that Mathlib does not yet contain. The comment's description of the gap is accurate.

### Comment accuracy

- **FlatBaseChange.lean**: The "What remains for `pushforward_spec_tilde_iso`" paragraph (L233–244) is stale — it describes a blocking obstacle that was resolved in the same file. Everything else is accurate (sorry descriptions, step plans, "genuine crux still carrying a `sorry`" language).
- **FlatteningStratification.lean**: All inline comments accurately describe the state of the code. No overclaiming of progress.

---

## Must-fix-this-iter

None. No finding meets the strict must-fix criteria (no excuse-comments, no weakened-wrong definitions, no parallel API copies, no suspect bodies, no unauthorized axioms).

---

## Major

- `FlatBaseChange.lean:233–244` — Section docstring paragraph "What remains for the full object iso `pushforward_spec_tilde_iso`" describes a pending QC obligation as "the sole remaining obligation", but `pushforward_spec_tilde_iso` (L535) is already complete and axiom-clean. The comment is a stale historical narrative that gives a false picture of what is open. Should be updated to record the resolution (basic-open localization route via `pushforward_spec_tilde_iso_of_isLocalizedModule`).
- `FlatBaseChange.lean:291,330,333,337,367,381,383,431,482,509,512,520,569,574,576,577,580,581,583,602,612` — 22 uses of deprecated `CategoryTheory.Sheaf.val`. The compiler reports "Use ObjectProperty.obj". This is a pervasive API-staleness issue that will break when the shim is removed.
- `FlatBaseChange.lean:754` — `base_change_map_affine_local` carries phantom hypotheses `[IsAffineHom f]` and `[F.IsQuasicoherent]` that the proof body does not use. The proof is purely `Modules.isIso_iff_isIso_app_affineOpens`, a general statement requiring neither. The phantom hypotheses belong in `affineBaseChange_pushforward_iso` (where they ARE needed for the affine-chart reduction), not in this intermediate lemma.

---

## Minor

- `FlatBaseChange.lean:181,206,213,541,566` — "iter-234", "iter-236", "iter-240", "iter-241" in status narrative comments. These iteration numbers are from the source project (Algebraic-Jacobian-Challenge); they are untraceable in this project and should be removed or replaced with prose descriptions.
- `FlatteningStratification.lean:218` — "iter-177+" stale iteration reference, same source-project provenance issue.
- `FlatBaseChange.lean:291,580,738` — Lines exceed 100-character style limit (linter warning, low priority).

---

## Excuse-comments (always called out separately)

None. No excuse-comments of the form "TODO: replace with real def", "placeholder", "temporary", "wrong but works", or "will fix later" were found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3 (stale resolved-obstacle description; 22× deprecated API; phantom hypotheses in `base_change_map_affine_local`)
- **minor**: 3 (stale iter-number references ×2 files; long lines)
- **excuse-comments**: 0

**Overall verdict**: Both files are mathematically honest — all sorry'd declarations carry genuine proof obligations with accurate descriptions, completed proofs are axiom-clean, the `by_cases` split in `genericFlatnessAlgebraic` is an honest case split with the primary branch genuinely closed, and `IsIso (Γ(α))` in `pushforward_base_change_mate_cancelBaseChange` is genuine content (not a tautological dodge). The main maintenance debt is a pervasive deprecated-API pattern (`Sheaf.val`, 22 sites) and a stale section-docstring paragraph that misrepresents `pushforward_spec_tilde_iso` as blocked.
