# Lean Audit Report

## Slug
iter006

## Iteration
006

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 1 flagged
- **excuse-comments**: 0
- **notes**:
  - **Lines 184–246 (section doc-block):** 63-line historical development narrative embedded in a `/-! ## Project-local Mathlib supplement ... -/` header — "STATUS (iter-234):", "UPDATE (iter-236):", "route (a) confirmed DEAD", "route (b) executed and axiom-clean." All this concerns work already completed; the declarations it describes (`gammaPushforwardIso`, `pushforward_spec_tilde_iso`, etc.) are present and proved with no sorry. The narrative belongs in the project log / task_results, not in source code. Classifying as **major** (stale documentation that overstates the historical record and will confuse a reader who sees `iter-234`/`236` in a codebase at iter-006).
  - **Lines 850–851 (docstring of `base_change_mate_regroupEquiv`):** The NOTE says "an alternative one-line proof `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)` typechecks once `base_change_regroup_linearEquiv` is in a *separate compiled module*." `RegroupHelper.lean` IS now that separate compiled module (imported at line 7). But the in-proof comment at lines 910–916 explicitly contradicts this: "the helper's source `(A ⊗[R] R') ⊗[A] M` uses the CANONICAL `Algebra A (A ⊗[R] R')` (leftAlgebra) action, whereas the object carrier tensors over the `restrictScalars includeLeftRingHom` A-action; the two `⊗[A]` carriers are genuinely DIFFERENT types… not defeq to the object `≃ₗ` even across the import boundary." The docstring NOTE is now factually wrong and actively misleads future editors about the path to closing this sorry. Classifying as **major**.
  - **Lines 939 (sorry in `base_change_mate_regroupEquiv`):** The sorry is the `map_smul'` obligation for `LinearEquiv.toModuleIso`. The additive part `g` is fully constructed (line 898–907); only `R'`-linearity on generators is missing. Honest scaffolding on a correct type.
  - **Lines 872–878 (`eT` construction):** The identity `A`-linear bridge from the `extendScalars includeLeftRingHom` A-action to the canonical `leftAlgebra` A-action. `map_smul'` closes by `rw [Algebra.smul_def]; rfl` — the two A-actions agree definitionally after `smul_def`. Mathematically faithful, not vacuous.
  - **Lines 898–907 (`g` construction):** The composite `comm ≫ (congr refl eT) ≫ cancelBaseChange ≫ comm`. The `eT` bridge makes the middle step the identity at the carrier level, so `g` is effectively `comm ≫ cancelBaseChange ≫ comm`. Mathematically faithful and consistent with `base_change_regroup_linearEquiv`.
  - **Lines 967–985 (`base_change_mate_generator_trace_eq`):** `ext x` at line 971 correctly reduces the morphism equality to a per-generator check (standard `LinearMap.ext`). Mathematically faithful. The remaining sorry (line 985) is the genuine blueprint crux (3-step adjoint-mate trace). Honest.
  - **Lines 909–936 (in-proof comment block in `base_change_mate_regroupEquiv`):** 28-line blocker explanation. Acceptable scaffolding but detailed enough to belong in task_results. Classifying as **minor**.
  - **Lines 967–984 (in-proof comment block in `base_change_mate_generator_trace_eq`):** 18-line assembly-route description embedded in proof. Same observation. **Minor**.
  - **Lines 1095–1115 (in-proof comment in `affineBaseChange_pushforward_iso`):** Multi-paragraph description of the affine reduction strategy. **Minor**.
  - **Lines 882–895 (`letI instLHS`/`instRHS`):** These `letI` calls inject the `Module R'` instances needed for `LinearEquiv.toModuleIso`, but the implementation comment (lines 928–932) reports they compile to opaque aux-defs that then block smul rewrites in the `map_smul'` goal. The `letI` pattern is the indirect cause of the sorry-blocking instance opacity. Not a code error — the authors are aware and document it — but it is a Lean 4 anti-pattern (prefer transparent `have h : ... := ...; exact_mod_cast h` or a `show` to expose the instance) worth noting. **Minor**.
  - **Lines 985, 1116, 1138 (sorries in `base_change_mate_generator_trace_eq`, `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`):** All honest, all on correct type signatures. The sorry-chain `generator_trace_eq → generator_trace → cancelBaseChange → affineBaseChange` is correct scaffolding: each depends exactly on the predecessor.
  - **`base_change_mate_generator_trace` (lines 997–1010):** Uses `rw [base_change_mate_generator_trace_eq]; infer_instance`. Since `base_change_mate_generator_trace_eq` is sorry'd, this proof is transitively sorry'd but correctly structured.

---

### AlgebraicJacobian/Cohomology/RegroupHelper.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is clean and complete. `base_change_regroup_linearEquiv` (lines 59–98) has a full proof: the `AddEquiv` is assembled from `TensorProduct.comm ≫ cancelBaseChange ≫ TensorProduct.comm`; `map_smul'` is proved by `TensorProduct.induction_on` reducing to generators, then `rw [smul_eq_mul]` at the leaf. No sorry, no axiom, no bad practices.
  - The `rightAlgebra` action on `A ⊗[R] R'` is correctly used and the `hsmul` computation at lines 83–88 matches the blueprint's generator-trace description.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - **Lines 105–114 (`exists_free_localizationAway_of_finite`):** Proved. Uses `Module.FinitePresentation.exists_free_localizedModule_powers` via `nonZeroDivisors`. Correct.
  - **Lines 120–127 (`exists_flat_localizationAway_of_finite`):** Proved. Delegates to free case + `Module.Flat.of_free`. Correct.
  - **Lines 135–144 (`exists_free_localizationAway_of_moduleFinite`):** Proved via `Module.Finite.trans`. Correct.
  - **Lines 168–207 (`exists_free_localizationAway_of_torsion`, L1):** Proved. The product-of-annihilators argument is correct: `f = ∏ r(xᵢ)` over generators, non-zero in the domain, annihilates all of M via `Submodule.span_induction`. Genuine closed branch.
  - **Lines 220–237 (`exact_localizedModule_powers_of_shortExact`, L3a):** Proved. Clean delegation to `LocalizedModule.map_injective`/`map_surjective`/`map_exact`.
  - **Lines 248–325 (`free_localizationAway_of_free_of_eq_mul`, L3b):** Proved. The `IsBaseChange` chain for `φ : N_{f'} → N_{f'f''}` is well-structured. Correct.
  - **Lines 336–347 (`free_of_shortExact_of_free_free`, L3c):** Proved. Lifting property + `splitSurjectiveEquiv`. Correct.
  - **Lines 360–394 (`exists_free_localizationAway_of_shortExact`, L3):** Proved. Takes `f := f' * f''` and chains L3a + L3b + L3c. Correct.
  - **Lines 415–445 (`exists_localizationAway_finite_mvPolynomial`, L4):** Has sorry at line 445. Steps 1 (Noether normalization over K via `exists_finite_inj_algHom_of_fg`) is present; Step 2 (denominator clearing, Mathlib-absent) is the sorry. Honest.
  - **Lines 460–513 (`exists_free_localizationAway_polynomial`, L5, the induction):** The `induction d using Nat.strong_induction_on generalizing N` skeleton is structurally correct.
    - **Base case `d = 0` (lines 481–488):** Genuinely closed. `Module.Finite.equiv` with `(MvPolynomial.isEmptyAlgEquiv A (Fin 0)).symm.toLinearEquiv` establishes `Module.Finite A (MvPolynomial (Fin 0) A)` (using `Module.Finite A A` as root), then `Module.Finite.trans` gives `Module.Finite A N`, and `exists_free_localizationAway_of_finite` closes it. Correct.
    - **Torsion sub-case (lines 490–494):** Genuinely closed. `exists_free_localizationAway_of_torsion A (MvPolynomial (Fin d) A) N htors` matches all required typeclasses (`B = MvPolynomial (Fin d) A`, all instances from the theorem signature). Correct.
    - **Non-torsion inductive step (lines 495–513):** Has sorry at line 513. The IH is correctly scoped (the `generalizing N` reverts all five d-dependent instances). The sorry is the generic-rank SES construction + Noether-normalisation reindex of T — both Mathlib-absent. Honest.
  - **Lines 507–512 (in-proof comment "The IH is now genuinely in scope (the structural fix of this iter)"):** Iter-specific progress narrative embedded in proof. This belongs in task_results, not in source code. **Minor**.
  - **Lines 550–579 (`genericFlatnessAlgebraic`):** Sorry at line 580 for the finite-type residue. Primary route (module-finite over A) is genuinely closed (line 559–560). Comment at line 562–563 says "the dévissage chain is now scaffolded in the `GenericFreeness` namespace above" — accurate in the sense that the L1/L3/L4/L5 structure names exist, but L4 and L5 both have sorries; "scaffolded" should not be read as "proved." Slightly optimistic phrasing. **Minor**.
  - **Lines 604–647 (in-proof comment in `genericFlatness`):** Long geometric assembly description embedded in proof. Scaffolding documentation appropriate for task_results. **Minor**.
  - **Line 648 sorry (`genericFlatness`):** The statement is fully quantified and non-degenerate (`∃ V : S.Opens, (V : Set S).Nonempty ∧ ∀ {U W} ...`). The proof opens with a genuine `obtain` of a non-empty affine open (lines 626–628). Honest sorry.

---

## Must-fix-this-iter

None.

All sorry-bearing declarations carry honest type signatures and are genuine Mathlib-absent gaps or residual instance-opacity issues. No weakened definitions, no tautological proofs, no excuse-comments in the spec sense, no unauthorized axioms.

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:184–246` — 63-line "STATUS (iter-234)" / "UPDATE (iter-236)" / "route (a) DEAD" narrative in the `/-! ## Project-local Mathlib supplement — affine tilde dictionary -/` section header. All the work it describes is already present and proved in the same file (or is absent by design). This is legacy workflow documentation from the parent project that should live in project logs, not source. Readers encountering `iter-234`/`236` references in an `iter-006` file will be confused.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:850–851` — Outdated NOTE in the docstring of `base_change_mate_regroupEquiv`: "alternative one-line proof … typechecks once … in a *separate compiled module*." `RegroupHelper.lean` IS now that separate module, yet the sorry persists. The implementation comment at lines 910–916 explicitly contradicts the NOTE by explaining the carriers are genuinely different types even across the import boundary. The docstring NOTE is factually wrong and misleads future editors about the path to closing the sorry.

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:909–936` — 28-line in-proof blocker description in `base_change_mate_regroupEquiv`. Useful information but should live in task_results.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:967–984` — 18-line in-proof assembly-route comment in `base_change_mate_generator_trace_eq`. Same observation.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1095–1115` — Multi-paragraph in-proof description of affine reduction strategy in `affineBaseChange_pushforward_iso`.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:882–895` — `letI instLHS`/`instRHS` inject `Module R'` instances as opaque aux-defs, which then block smul rewrites in the `map_smul'` sorry. Not an error (authors are aware), but a pattern worth flagging: `letI` in tactic mode produces opaque definitions; transparent `show` or a named `have` would avoid the opacity wall.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:507–512` — Iter-specific progress narrative ("structural fix of this iter") embedded in proof body.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:562–563` — "the dévissage chain is now scaffolded" overstates completion since L4 and L5 both carry sorries.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:604–647` — Long geometric assembly description in proof body of `genericFlatness`.

---

## Excuse-comments (always called out separately)

None found. No declaration carries a comment admitting the code is wrong, temporary, placeholder, or "will fix later."

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 — both in `FlatBaseChange.lean`: stale historical narrative (lines 184–246) and a contradicted docstring claim about closing a sorry (lines 850–851)
- **minor**: 7 — verbose in-proof comment blocks and one mild overstatement of scaffolding completeness
- **excuse-comments**: 0

Overall verdict: All eight sorries in scope are honest scaffolding on correct, non-weakened type signatures; the two major findings are documentation quality issues — one stale history block and one misleading docstring claim — neither of which affects the mathematical correctness of the code.
