# Lean Audit Report

## Slug
ts236

## Iteration
236

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - **Line 21–24 (module header)**: The `-!` docstring says "This iteration builds the forward additive comparison map `stalkTensorDesc` and its germ characterisation … The full isomorphism `PresheafOfModules.stalkTensorIso` … additionally requires … see the handoff in `task_results`." The file now contains the full `stalkTensorIso` (line 505), `stalkTensorRev` (line 459), `revBihom_balanced` (line 427), `germ_tensorObj_map_tmul` (line 484), and all auxiliary machinery. The "handoff in `task_results`" remark is stale. **Major** (misleads a reader into believing the iso is absent from this file).
  - **Lines 425–426 (`revBihom_balanced` docstring)**: References "the single section identity `revBihom_balanced_section` over `W ⊓ W`". No such declaration exists. The actual private helper is `revBihom_balanced_germ` (line 403). **Major** (wrong name in load-bearing docstring).
  - **Lines 114–116 (`stalkTensorDescU_smul` comment)**: The comment mentions "`smul_tmul'`/`smul_add`/`smul_zero`" but the proof uses `smul_tmul'` and `smul_add`; there is no `smul_zero` call in the proof body. **Minor** inaccuracy.
  - **Line 6 (`import Mathlib`)**: Blanket import; standard for this project type but may cause slow compilation. **Minor**.
  - **Non-vacuity check on `stalkTensorIso` (lines 505–541)**:
    - `toFun` = `stalkTensorLinearMap`: sends `germ(a ⊗ b)` to `germ_A(a) ⊗_{R_x} germ_B(b)` (via `stalkTensorLinearMap_germ_tmul`). Genuinely non-trivial.
    - `invFun` = `stalkTensorRev`: built by `TensorProduct.liftAddHom` from `revBihom` using the verified balancing condition `revBihom_balanced`. Sends `germ_A(a) ⊗ germ_B(b)` to `germ_{U⊓V}((a|_{U⊓V}) ⊗ (b|_{U⊓V}))`. Genuinely non-trivial.
    - `left_inv` (lines 512–523): For a simple tensor `germ(a ⊗ b)` over `U` the chain is `stalkTensorLinearMap_germ_tmul` → `stalkTensorRev_germ_tmul` (with `V = U`, giving `germ_{U⊓U}(...)`) → `germ_tensorObj_map_tmul` with `j = homOfLE inf_le_left : U⊓U ⟶ U` to fold back to `germ_U(a ⊗ b)`. Each step is a genuinely distinct lemma; the proof is **not** closed by a degenerate `rfl` or carrier coincidence.
    - `right_inv` (lines 524–540): For `germ_A(a) ⊗ germ_B(b)` the chain is `stalkTensorRev_germ_tmul` → `stalkTensorLinearMap_germ_tmul` at `U⊓V` → two `germ_res_apply` calls (one for `A`, one for `B`) restoring the original germs. Again genuinely non-trivial.
    - **Verdict: NON-VACUOUS.** The iso is a real mathematical construction; inversion is proved on germ generators by distinct lemmas.
  - **`erw` usage**: All `erw` uses are explained by the documented `CommRingCat`/`RingCat` carrier-duality issues (the underlying `AddMonoidHom` vs `LinearMap` boundary). No `erw` appears to silently exploit a wrong-carrier coincidence; the carrier types match by design (the `germ_smul`/`smul_tmul'` pair keeps scalar paths within the same ring).
  - **Axiom check**: `PresheafOfModules.stalkTensorIso` uses only `propext`, `Classical.choice`, `Quot.sound` (standard Mathlib). No rogue axioms.
  - **Compilation**: No errors.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: 2 sorry sites (honestly scoped — see notes)
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - **Lines 181–244 (STATUS/UPDATE history block)**: The section comment "Project-local Mathlib supplement — affine tilde dictionary (global sections)" embeds a long process-narrative with "STATUS (iter-234)" and "UPDATE (iter-236)" labels. It documents the abandoned route-(a) `LinearEquiv.toModuleIso`/`respectTransparency` approach in detail (lines 183–219), then describes route-(b) as executed (lines 220–230), and lists what remains for `pushforward_spec_tilde_iso` (lines 231–244). The current code state is accurately described by the route-(b) paragraph, but:
    1. The iter-specific labels ("iter-234", "iter-236") are process artifacts that will become stale as iterations advance.
    2. The abandoned route-(a) documentation (~35 lines) has no ongoing code value and belongs in the proof journal.
    3. This mixes proof-strategy history into a space readers expect to contain current API documentation.
    **Major** (maintainability hazard; stale iteration labels will mislead future readers). Not an excuse-comment in the strict sense.
  - **Line 348 (`affineBaseChange_pushforward_iso`, `sorry`)**: The sorry is preceded by two completed steps (`rw [Modules.isIso_iff_isIso_app_affineOpens]` and `intro U`), establishing that the locality reduction is done. The comment above the sorry (lines 333–347) accurately identifies the missing ingredient (affine tilde dictionary: translating `Scheme.Modules.pushforward`/`pullback` of tilde-modules into restriction of scalars). **Honestly scoped.** Not a must-fix.
  - **Line 370 (`flatBaseChange_pushforward_isIso`, `sorry`)**: The comment (lines 361–369) describes the Čech-complex proof strategy and names the missing infrastructure (`SheafOfModules`-level Čech cohomology). The sorry correctly reflects that `affineBaseChange_pushforward_iso` (which it would reduce to) is also incomplete. **Honestly scoped.** Not a must-fix.
  - **Non-vacuity check on new declarations**:
    - **`globalSectionsIso_hom_comp_specMap_appTop` (lines 265–271)**: Claims `(ΓSpecIso R).inv ≫ (Spec.map φ).appTop = φ ≫ (ΓSpecIso R').inv`. Proved by identifying `globalSectionsIso = ΓSpecIso.inv` (two `rfl` rewrites) and then applying `Scheme.ΓSpecIso_inv_naturality φ`. **Genuine.** ✓
    - **`gammaPushforwardIso` (lines 285–302)**: The iso is built as a three-step chain: `.symm` of `restrictScalarsComp'App gsRhom pushTop _ rfl` ≫ `eqToIso (congrArg ... hcomp)` ≫ `restrictScalarsComp'App φ.hom gsR'hom _ rfl`. The `eqToIso` uses `hcomp : pushTop ∘ gsRhom = gsR'hom ∘ φ.hom`, which is established via `globalSectionsIso_hom_comp_specMap_appTop` (a non-trivial ring equation). The outer `restrictScalarsComp'App` isos are genuine associativity-of-restriction isos (the `rfl` arguments are just the trivially-named composition equalities, not the main content). **Not `eqToIso rfl`. Genuine.** ✓
    - **`gammaPushforwardTildeIso` (lines 310–316)**: Composes `gammaPushforwardIso φ (tilde M)` with `(restrictScalars φ.hom).mapIso (tilde.toTildeΓNatIso.app M).symm` to specialize to `N = tilde M` using the tilde-Γ unit iso. **Genuine.** ✓
  - **Axiom check**: `AlgebraicGeometry.gammaPushforwardIso` uses only `propext`, `Classical.choice`, `Quot.sound`. No rogue axioms.
  - **Line 6 (`import Mathlib`)**: Blanket import. **Minor**.
  - **Compilation**: No errors.

---

## Must-fix-this-iter

None.

No wrong definitions, no excuse-comments on named declarations, no rogue axioms, no sorry on load-bearing claims that is not properly scoped.

---

## Major

- `StalkTensor.lean:21–24` — Module header claims the full iso is deferred to `task_results`; the full `stalkTensorIso` and all supporting machinery are in this file. A reader relying on the header to locate the iso will be misdirected.
- `StalkTensor.lean:425–426` — `revBihom_balanced` docstring names `revBihom_balanced_section`, a nonexistent declaration; the actual helper is `revBihom_balanced_germ` (line 403).
- `FlatBaseChange.lean:181–244` — Long STATUS/UPDATE history block with iter-numbered labels embedded in source code; documents abandoned route (a) at length and will grow stale. Belongs in the proof journal, not in the file's section header.

---

## Minor

- `StalkTensor.lean:114–116` — `stalkTensorDescU_smul` comment lists "`smul_tmul'`/`smul_add`/`smul_zero`" but `smul_zero` is not used in the proof body.
- `StalkTensor.lean:6` and `FlatBaseChange.lean:6` — `import Mathlib` blanket imports; standard for the project but may contribute to slow build times.

---

## Excuse-comments (always called out separately)

None. No declaration in either file carries a comment admitting the code is wrong or temporary.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Both files compile cleanly with only standard axioms; the new declarations (`revBihom_balanced`, `stalkTensorRev`, `stalkTensorRev_germ_tmul`, `germ_tensorObj_map_tmul`, `stalkTensorIso`, `globalSectionsIso_hom_comp_specMap_appTop`, `gammaPushforwardIso`, `gammaPushforwardTildeIso`) are mathematically genuine, the iso `stalkTensorIso` is non-vacuous, and the two `sorry` sites are honestly scoped; three major comment-quality issues (stale module header, wrong declaration name in docstring, iter-history narrative in source) should be cleaned up but do not block downstream work.
