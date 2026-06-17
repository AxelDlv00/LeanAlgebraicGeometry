# Lean Audit Report

## Slug
iter004

## Iteration
005 (auditing iter004 prover output)

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged
- **excuse-comments**: none
- **notes**:
  - **Lines 234–246** (inside the `/-! affine tilde dictionary -/` docstring block) — The comment says "What remains for the full object iso `pushforward_spec_tilde_iso` … That QC fact is the sole remaining obligation". But `pushforward_spec_tilde_iso` is **proved** at lines 537–652 (no sorry; full term-mode proof via `pushforward_spec_tilde_iso_of_isLocalizedModule`, `tildeRestriction_isLocalizedModule`, and `IsLocalizedModule.powers_restrictScalars`). This is a stale UPDATE comment — it was accurate after iter-236 of the parent project but was never updated once the QC obligation was discharged. A reader of this file would incorrectly believe `pushforward_spec_tilde_iso` is unproved with an outstanding quasi-coherence gap.
  - **Lines 183, 209, 223, 565, 632** — Iteration-number references "iter-234", "iter-236", "iter-240", "iter-241" inherited from the parent project *Algebraic-Jacobian-Challenge*. These iteration numbers have no meaning in the *Quot-Foundations* project (currently at iter-005). The mathematical content they describe is accurate, but the labels are impossible to look up in this project's history.
  - **Lines 291, 293, 332, 335, 339, 369, 383, 385, 433, 484, 511, 514, 522, 571, 576, 578, 579, 582, 583, 585, 604, 614** — Approximately 22 uses of `.val.obj` and `.val.map` on objects of type `TopCat.Sheaf` and `SheafOfModules` (via `modulesSpecToSheaf`, `SheafOfModules.forgetToSheafModuleCat`, etc.). The iter003 auditor confirmed these are active deprecation warnings for `CategoryTheory.Sheaf.val` (replacement: `ObjectProperty.obj`). All sites are in proved, axiom-clean declarations. Will become build-breaking when Mathlib removes the deprecated field.
  - **Line 1** — Missing `set_option autoImplicit false` at file top. All other source files set this option. Low-risk (all declarations carry explicit type annotations), but inconsistent. Carry-over from iter003.
  - **Lines 848–887** (`base_change_regroup_linearEquiv`) — Axiom-clean proof of the pure-tensor-algebra core. The docstring accurately claims "Axiom-clean (`propext`, `Quot.sound`)". No concern.
  - **Lines 918–978** (`base_change_mate_regroupEquiv`) — `sorry` in `map_smul'`. Docstring gives detailed STATUS describing the carrier-instance wall preventing `TensorProduct.induction_on` from seeing the `restrictScalars` wrapper. The NOTE claiming "an alternative one-line proof typechecks once `base_change_regroup_linearEquiv` is in a *separate compiled module*" is a specific Lean elaboration claim that cannot be verified by code reading alone; it is not wrong, but it frames the sorry as trivially fixable by file-layout change. If this claim is inaccurate the sorry would be harder than presented. Classified as minor.
  - **Lines 996–1010** (`base_change_mate_generator_trace_eq`) — `sorry` body. Docstring labels it "the genuine outstanding crux" and describes the three-step adjoint-mate trace required. Honest deferral.
  - **Lines 1110–1141** (`affineBaseChange_pushforward_iso`) — `sorry` in per-affine-open step. Proof correctly applies `base_change_map_affine_local` first; the sorry is in the affine-reduction step ("obligation 1"). Honest, detailed comment.
  - **Lines 1150–1163** (`flatBaseChange_pushforward_isIso`) — `sorry` body. Honest; names the missing Čech-cohomology infrastructure.
  - **Lines 1022–1035** (`base_change_mate_generator_trace`) — proof via `rw [base_change_mate_generator_trace_eq]; infer_instance`. This closes by depending on a sorry (`base_change_mate_generator_trace_eq`), then inferring `IsIso` of an inverse of a `ModuleCat` isomorphism. Structurally legitimate given the sorry chain is disclosed; not fake content.
  - **Lines 1059–1084** (`pushforward_base_change_mate_cancelBaseChange`) — closes via `base_change_mate_generator_trace` + iso-cancellation. Structurally sound; depends on sorry chain.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`exists_localizationAway_finite_mvPolynomial` signature (lines 415–426)** — The directive asked whether the re-signed L4 signature is honest. Assessment: **yes**. The hypothesis `hBK : Nontrivial (TensorProduct A (FractionRing A) B)` is exactly what Noether normalisation (`exists_finite_inj_algHom_of_fg`) needs for the nontrivial generic fiber. The existential includes exactly one anonymous instance `∃ (_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))`, needed to type `φ` as an AlgHom. The `Module.Finite` conclusion uses `letI := φ.toAlgebra` (scoped let-binding), which is cleaner than the prior version's 3 anonymous instance quantifiers (reported in iter003). The sorry at line 445 ("denominator-clearing construction … genuine remaining content of L4") is honest.
  - **`exists_free_localizationAway_polynomial` (lines 460–495), `by_cases htors` split** — The directive asked whether this is genuine content or a vacuous dodge. Assessment: **genuine content**. The base case `d = 0` is fully proved via `Module.Finite.trans` + `exists_free_localizationAway_of_finite`. The torsion sub-case `d > 0, N_K = 0` is fully proved by `exists_free_localizationAway_of_torsion A (MvPolynomial (Fin d) A) N htors` — all required typeclass instances (`[Module (MvPolynomial (Fin d) A) N]`, `[IsScalarTower A (MvPolynomial (Fin d) A) N]`) come from the theorem's own hypotheses. The sorry is confined to `d > 0, N_K ≠ 0`, which is the genuine hard case (generic-rank dévissage). The split is real mathematical progress.
  - **Lines 460–495, non-torsion sorry structural issue** — The sorry's comment says the eventual proof needs "strong induction on `d`" and "the inductive hypothesis on `T`". But the current proof skeleton uses `rcases Nat.eq_zero_or_pos d` (a case-split, not induction), so there is no IH in scope. Filling the sorry will therefore require either (a) proving the inductive step inline without IH (extremely verbose) or (b) restructuring the entire skeleton to use strong induction, which would change the theorem's proof structure. The comment is honest about this (it says "after the IH is set up"), but the implication — that the current skeleton must be refactored — is understated.
  - **L3 lemmas (`exact_localizedModule_powers_of_shortExact`, `free_localizationAway_of_free_of_eq_mul`, `free_of_shortExact_of_free_free`, `exists_free_localizationAway_of_shortExact`)** — All four proved this iter; no sorry. Bodies look correct. `free_localizationAway_of_free_of_eq_mul` (lines 248–325) is the most complex: the proof correctly uses `IsLocalization.Away.awayToAwayLeft`, scalar-tower plumbing, and `hbcA'.of_comp hbcAf`. Structurally sound.
  - **Stale iter-number references** — Comments reference "iter-177+" and other predecessor-project iteration numbers (same provenance as FlatBaseChange.lean).
  - **`genericFlatnessAlgebraic` (lines 532–562)** — `sorry` in non-module-finite case. Comment gives complete assembly route (prime-filtration induction principle + L3/L4/L5 chain). Honest deferral.
  - **`genericFlatness` (lines 594–629)** — `sorry` body after a genuine non-trivial start (opens a non-empty affine chart via `exists_isAffineOpen_mem_and_subset`). Comment outlines the full geometric assembly. Honest deferral.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All four declarations (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`) have `sorry` bodies with honest "iter-177+:" comments describing the planned proof routes. Types are substantive and non-tautological (correct return types: `Polynomial ℚ`, `(Over S)ᵒᵖ ⥤ Type u`, representability witness). No misrepresentation.
  - **"iter-176", "iter-177"** references in docstrings — predecessor-project iteration numbers (same issue as other files).

---

### AlgebraicJacobian/Picard/RelativeSpec.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none (but see naming note on `UniversalProperty`)
- **dead-end proofs**: none
- **bad practices**: 1 flagged (naming drift)
- **excuse-comments**: none
- **notes**:
  - **Lines 22–48** (module docstring) — References "iter-173" through "iter-179" from the predecessor project. The history is useful but the iteration numbers are meaningless in *Quot-Foundations*.
  - **`RelativeSpec` (line 184)** — Body `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`. Correct Mathlib-aligned value; no sorry.
  - **`RelativeSpec.structureMorphism` (line 200)** — Body `.toBase`. Correct; no sorry.
  - **`UniversalProperty` (lines 233–258)** — Naming drift: the declaration is named `UniversalProperty` but its type is `IsAffineHom (RelativeSpec.structureMorphism 𝒜)` — a single structural consequence of representability, not the full universal property (which would be a `RepresentableBy` / Yoneda-bijection statement). The docstring acknowledges this ("iter-174+: refine the type signature…") and explains the current type is non-tautological. Nevertheless, a reader encountering `UniversalProperty` in an import will expect the full representability statement, not just affineness of the structure morphism. This is a misleading name for the API.
  - **`affine_base_iff` (lines 280–287)** — The name implies a biconditional, but the statement is `IsAffine ((Spec R).RelativeSpec 𝒜)` (one direction). The `affine_base_iff` name is misleading.
  - **`UniversalProperty` proof body** — Uses `isAffineHom_of_forall_exists_isAffineOpen`, `Cover.RelativeGluingData.toBase_preimage_eq_opensRange_ι`, and `isAffineOpen_opensRange`. No sorry. Proof appears structurally sound for the stated type.

---

## Must-fix-this-iter

None. No finding meets the must-fix criteria (no excuse-comments, no weakened-wrong definitions, no parallel Mathlib API copies, no suspect bodies, no unauthorised axioms).

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:234–246` — **Stale "What remains" comment misrepresents proof status of `pushforward_spec_tilde_iso`.** The comment (in the `/-! affine tilde dictionary -/` module docstring) says the QC fact for `pushforward (Spec φ)_* (tilde M)` is "the sole remaining obligation" for `pushforward_spec_tilde_iso`. But `pushforward_spec_tilde_iso` is **proved** at line 537 — the QC obligation was discharged via `tildeRestriction_isLocalizedModule` + `IsLocalizedModule.powers_restrictScalars`. A reader of this file would incorrectly infer the declaration is unproved. The comment was accurate at an intermediate parent-project iteration but was never updated after the proof landed. Should be removed or replaced with a note that the declaration is closed.

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:~22 sites` — **Deprecated `CategoryTheory.Sheaf.val` / `.val.obj` / `.val.map`** (approximately 22 sites in proved declarations: `gammaPushforwardIso`, `gammaPushforwardIsoAt`, `fromTildeΓ_app_isIso_of_isLocalizedModule`, `tildeRestriction_isLocalizedModule`, `pushforward_spec_tilde_iso`). Replacement is `ObjectProperty.obj`. LSP-confirmed active deprecation warnings (reported in iter003; still present). All sites are in axiom-clean proved code. Will become a build-breaking change when Mathlib removes the deprecated accessor. Carry-over from iter003.

- `AlgebraicJacobian/Picard/RelativeSpec.lean:233` — **`UniversalProperty` naming drift.** The declaration typed `IsAffineHom (RelativeSpec.structureMorphism 𝒜)` is named `UniversalProperty`. The name leads consumers to expect the full Yoneda-bijection / `RepresentableBy` witness; they get only the affineness of the structure morphism. The docstring acknowledges the gap ("iter-174+: refine to the full statement") but the misleading name persists in the public API.

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:183,209,223,565,632` — Stale parent-project iteration references ("iter-234", "iter-236", "iter-240", "iter-241") from *Algebraic-Jacobian-Challenge*. Meaningless in *Quot-Foundations* history; not wrong about mathematical content, but confusing for project navigation.

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1` — Missing `set_option autoImplicit false` (all other source files set this). Carry-over from iter003.

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:915–917` (`base_change_mate_regroupEquiv` NOTE) — Claims "an alternative one-line proof typechecks once `base_change_regroup_linearEquiv` is in a *separate compiled module*". This is a specific Lean elaboration claim that cannot be verified from source. If inaccurate, it understates the difficulty of the remaining `sorry`. Not an excuse-comment, but a forward-looking claim that should be verified when the sorry is addressed.

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:460–495` — `exists_free_localizationAway_polynomial` non-torsion `sorry` requires **proof restructuring**: the comment says filling it needs "strong induction on `d`" and an IH, but the current skeleton uses a cases-split with no IH in scope. The comment is honest about this ("after the IH is set up"), but the practical implication — that the skeleton will need to be refactored to use `Nat.strong_induction_on` or `Nat.rec` with a universally-quantified motive — is understated.

- `AlgebraicJacobian/Picard/RelativeSpec.lean:280` — `affine_base_iff` name implies a biconditional (`↔`), but the type asserts only one direction (`IsAffine …`). Naming drift.

- All files — Stale parent-project iteration-number references throughout docstrings and comments (`iter-173` through `iter-241` from *Algebraic-Jacobian-Challenge*). Harmless to mathematical correctness but confusing for project navigation. Consolidating all per-file instances here as a single minor observation.

---

## Excuse-comments (always called out separately)

None found. Every sorry-bearing declaration has surrounding comments that explicitly name the specific missing ingredient, the Mathlib infrastructure gap, or the blocking crux (e.g., "denominator-clearing construction is not yet available from Mathlib", "genuine outstanding crux", "the restriction-compatibility of `pushforwardBaseChangeMap` is itself Mathlib-absent"). No comment uses language equivalent to "temporary", "placeholder", "wrong but works", or "will fix later".

---

## Positive observations (informational, not findings)

- **`exists_localizationAway_finite_mvPolynomial` signature improved.** The iter003 Major finding was 3 anonymous instance existentials in the return type. The re-signed version in iter004 reduces this to 1 anonymous `∃ (_ : Algebra …)` (needed to type `φ`) plus a clean `letI := φ.toAlgebra` scope in the conclusion. The fragility reported in iter003 is substantially reduced; the remaining single anonymous instance is structurally necessary.

- **L3 sub-lemmas (4 declarations) are axiom-clean and structurally sound.** `exact_localizedModule_powers_of_shortExact`, `free_localizationAway_of_free_of_eq_mul`, `free_of_shortExact_of_free_free`, and `exists_free_localizationAway_of_shortExact` are all genuine proofs with no sorry. The `free_localizationAway_of_free_of_eq_mul` body is especially careful about the scalar-tower construction and `IsBaseChange` plumbing.

- **`base_change_regroup_linearEquiv` is axiom-clean.** The new L4-a helper is a complete proof via the `comm ≪≫ cancelBaseChange ≪≫ comm` route, with no sorry, and correctly uses `TensorProduct.induction_on` on generators.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3 (stale "What remains" comment misrepresenting `pushforward_spec_tilde_iso`; 22-site deprecated `.val` cluster; `UniversalProperty` naming drift)
- **minor**: 6
- **excuse-comments**: 0

Overall verdict: The project is in sound mathematical shape — all sorries are honest scaffold deferrals, proved code is genuine, and the new L4-a helper `base_change_regroup_linearEquiv` and the four L3 lemmas are axiom-clean. The principal actionable concerns are: (1) the stale "What remains" comment that actively misrepresents `pushforward_spec_tilde_iso` as unproved, and (2) the ongoing 22-site deprecated `.val` cluster that will break the build on the next Mathlib pin bump.
