# Lean ↔ Blueprint Check Report

## Slug
csi

## Iteration
061

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant blocks: lines 8006–8409)

---

## Per-declaration

### `\lean{AlgebraicGeometry.isIso_modules_of_toPresheaf}` (chapter: `lem:isIso_modules_of_toPresheaf`)
- **Lean target exists**: yes (line 615)
- **Signature matches**: yes — "if `(Scheme.Modules.toPresheaf X).map φ` is an iso then `φ` is an iso"; Lean encodes the hypothesis as `[IsIso ...]` typeclass exactly as the prose describes.
- **Proof follows sketch**: yes — `isIso_of_reflects_iso φ (Scheme.Modules.toPresheaf X)` is the one-liner the blueprint's proof describes (the forgetful functor reflects isos by full-faithfulness).
- **notes**: Proof is closed (no sorry). Blueprint statement block has `\leanok` ✓. Blueprint **proof block** lacks `\leanok` — sync_leanok gap, minor.

### `\lean{AlgebraicGeometry.pushPull_binary_coprod_prod}` (chapter: `lem:pushPull_binary_coprod_prod`)
- **Lean target exists**: **no** — no declaration named `pushPull_binary_coprod_prod` in the Lean file.
- **Signature matches**: N/A (does not exist yet)
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly has no statement `\leanok` for this label. The Lean file contains two partial preparatory pieces: (1) `coprodDecompMap` (private, line 639) — the comparison map `M ⟶ inl_*(M|inl) ⨯ inr_*(M|inr)`, axiom-clean; (2) `isIso_prodLift_of_isLimit` (private, line 622) — categorical helper that `prod.lift α β` is iso when `BinaryFan.mk α β` is a limit. A handoff note (lines 647–680) records two concrete Lean-level blockers discovered this iter (see **Blueprint adequacy** below). State is expected: neither the blueprint nor the Lean file claims this is formalized.

### `\lean{AlgebraicGeometry.pushPull_coprod_prod}` (chapter: `lem:pushPull_coprod_prod`)
- **Lean target exists**: **no** — no declaration with this name exists in the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly has no statement `\leanok`. This declaration depends on `pushPull_binary_coprod_prod` (via induction on `ι`). Absence is expected and consistent.

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`)
- **Lean target exists**: yes (line 724)
- **Signature matches**: yes — `pushPullObj F Y_p ≅ ∏ᶜ fun σ : Fin (p+1) → 𝒰.I₀ => pushPullObj F (Over.mk j_σ)` matches the blueprint iso exactly.
- **Proof follows sketch**: N/A — `:= sorry`.
- **notes**: Blueprint statement `\leanok` ✓ (declaration exists), no proof `\leanok` ✓ (sorry not closed). Correct state.

### `\lean{AlgebraicGeometry.pushPull_leg_sections}` (chapter: `lem:pushPull_leg_sections`)
- **Lean target exists**: yes (line 762)
- **Signature matches**: yes — `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ⊓ V, F)` as `Ab` objects; the Lean type precisely matches the blueprint's `Γ(U_σ ∩ V, F)` statement. The `⊓` renders as `∩` in prose — correct.
- **Proof follows sketch**: yes — chained `toPresheaf.mapIso (restrictFunctorIsoPullback).symm` + `eqToIso` from the image-preimage equality. Matches the blueprint's three-step chain (pushforward sections = preimage sections; pullback ≅ restriction; restriction sections = image-open sections).
- **notes**: Proof is closed (no sorry). Blueprint statement `\leanok` ✓. Blueprint **proof block** lacks `\leanok` — sync_leanok gap, minor.

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`)
- **Lean target exists**: yes (line 811)
- **Signature matches**: yes — `Γ(V, pushPullObj F Y_p) ≅ ∏ᶜ fun σ => Γ(coverInterOpen 𝒰 σ ⊓ V, F)` matches the blueprint exactly.
- **Proof follows sketch**: N/A — `:= sorry`.
- **notes**: Blueprint statement `\leanok` ✓, no proof `\leanok` ✓. Correct state (Stub 4).

### `\lean{AlgebraicGeometry.sectionCechComplexV}` (referenced in `lem:cechSection_complex_iso`)
- **Lean target exists**: yes (line 827)
- **Signature matches**: yes — `abbrev sectionCechComplexV 𝒰 F V := sectionCechComplex (fun i => coverOpen 𝒰 i ⊓ V) ((SheafOfModules.forget X.ringCatSheaf).obj F)`. This is the concrete non-augmented section Čech complex used as the base for Stubs 5/6; matches the blueprint description exactly.
- **Proof follows sketch**: N/A (abbrev, no proof body)
- **notes**: No blueprint issues.

### `\lean{AlgebraicGeometry.cechSection_complex_iso}` (chapter: `lem:cechSection_complex_iso`)
- **Lean target exists**: yes (line 875)
- **Signature matches**: yes — `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`. This is the **AUGMENTED** form. Blueprint (lines 8230–8269) specifies the iso to `D'_aug = (ČC(U',F)).augment ε hε`, confirmed by the `% NOTE:` annotation. **Iter-056 concern resolved** — the non-augmented form Stubs 5/6 is NOT what the Lean declares; both correctly target the augmented complex.
- **Proof follows sketch**: N/A — `:= sorry`.
- **notes**: Blueprint statement block (line 8227) has **NO `\leanok`** — but the Lean file has the declaration (with sorry). sync_leanok gap: statement `\leanok` should have been added. Minor.

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`)
- **Lean target exists**: yes (line 942)
- **Signature matches**: yes — `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0`. **AUGMENTED** target confirmed. Blueprint `% NOTE:` (line 8308–8312) explicitly documents "the contractible complex is the AUGMENTED section complex ... NOT the bare section complex D'". **Iter-056 concern resolved** for Stub 6.
- **Proof follows sketch**: N/A — `:= sorry`.
- **notes**: Blueprint statement `\leanok` ✓, no proof `\leanok` ✓. Correct state (Stub 6).

---

## Red flags

### Placeholder / suspect bodies
- `pushPull_sigma_iso` (line 729): `:= sorry`. Expected placeholder — blueprint has no proof `\leanok`. Type is correct; this is a legitimate open stub (Stub 2 / new-infra leaf, blocked on `pushPull_binary_coprod_prod`).
- `pushPull_eval_prod_iso` (line 820): `:= sorry`. Expected placeholder — Stub 4, depends on Stub 2. Type is correct.
- `cechSection_complex_iso` (line 890): `:= sorry`. Expected placeholder — Stub 5, depends on Stubs 2/4. Type is correct (AUGMENTED form ✓).
- `cechSection_contractible` (line 949): `:= sorry`. Expected placeholder — Stub 6. Type is correct (AUGMENTED form ✓).

None of the above are must-fix-this-iter: blueprint correctly marks all four as unformalized (no proof `\leanok`), and the types faithfully represent the blueprint statements.

### Excuse-comments
None found. The handoff block (lines 647–680, /-  **Handoff (iter-061): ...-/) is a legitimate prover-to-prover work handoff documenting (a) what is axiom-clean, (b) the two concrete blockers discovered, and (c) the corrected route. It does not say the code is wrong, temporary, or a placeholder. The comparison map `coprodDecompMap` it introduces is correctly stated and axiom-clean. This style matches the other "Planner strategy" block comments throughout the file.

### Axioms / Classical.choice
No `axiom` declarations introduced in this file. No `Classical.choice _` on non-trivial claims.

---

## Unreferenced declarations (informational)

**Private helpers — expected, no blueprint coverage needed:**
- `isIso_prodLift_of_isLimit` (line 622, private): "if `BinaryFan.mk α β` is a limit then `prod.lift α β` is iso." Categorical helper toward the `isProductOfDisjoint` leg of `pushPull_binary_coprod_prod`. Correct helper, private.
- `coprodDecompMap` (line 639, private): "the comparison map `M ⟶ inl_*(M|inl) ⨯ inr_*(M|inr)`." Preparatory step for `pushPull_binary_coprod_prod`. Axiom-clean, correctly typed.
- `sectionCechComplexV` (line 827, abbrev): Referenced in blueprint `\lean{..., AlgebraicGeometry.sectionCechComplexV}` for `lem:cechSection_complex_iso`. Coverage exists ✓.

**Abstract CategoryTheory namespace helpers** (lines 54–388 — `widePullback_overX_isLimit`, `widePullback_overX_eq_prod`, `overSigmaDescCofan/IsColimit/Iso`, `FinitaryPreExtensive.prodFinSuccIso`, `prod_coproduct_distrib`, etc.): These are the Stub-1 geometric-backbone infrastructure from prior iters and carry blueprint coverage through `lem:widePullback_overX_eq_prod`, `lem:prod_coproduct_distrib`, `lem:overProd_coproduct_distrib`, `lem:coproduct_distrib_fibrePower`, `lem:coproduct_fibrePower_reindex`, and `lem:coproduct_distrib_fibrePower_zero`. Out of scope for this iter's directed check.

**AlgebraicGeometry geometric helpers** (lines 413–607 — `widePullback_openImm_inter`, `coverArrowOverCofan/IsColimit/SigmaIso`, `widePullbackBaseCongr`, `cechBackbone_obj_widePullback`, `coverInterProdIso`, `cechBackbone_left_sigma`): Stub-1 assembly from prior iters; all covered by their blueprint labels. Out of scope here.

---

## Blueprint adequacy for this file

- **Coverage**: Of the 7 declarations with blueprint `\lean{...}` blocks in scope for this check, 5 exist in Lean (4 with sorry, 1 proof-closed), 2 do not exist yet (`pushPull_binary_coprod_prod`, `pushPull_coprod_prod`). The 2 missing are correctly unmarked in the blueprint (no `\leanok`). Coverage is consistent with the project state.

- **Proof-sketch depth**: **Partially under-specified** for `lem:pushPull_binary_coprod_prod`. The mathematical route described (isProductOfDisjoint + evaluation preserves products → check iso on presheaves) is correct. However, the blueprint sketch omits two Lean-level formalization blockers that caused the prover to be blocked this iter:
  1. **Instance-inference failure**: `G := toPresheaf (A⨿B) ⋙ (evaluation _ Ab).obj V` does NOT inherit `PreservesLimitsOfShape` because the middle category `TopCat.Presheaf Ab` is a `def`, not a type alias. The fix is to use `SheafOfModules.evaluation V` (landing in `ModuleCat`) and reduce via `Scheme.Modules.Hom.isIso_iff_isIso_app` instead of `NatIso.isIso_of_isIso_app` on `toPresheaf`.
  2. **Ab→ModuleCat bridge for `isProductOfDisjoint`**: The `isProductOfDisjoint` limit is obtained in `Ab`; to use `isIso_prodLift_of_isLimit` in `ModuleCat` it must be reflected through `forget₂ (ModuleCat R) Ab` via `isLimitOfReflects`. Approx. 60–100 LOC of cone-matching (`M.presheaf` as a `TopCat.Sheaf Ab`, the `⊥`/sup open identities, leg identification).
  
  The prover's handoff note (lines 647–680) already documents the corrected route with concrete Lean names. A `% NOTE:` annotation in the blueprint chapter for `lem:pushPull_binary_coprod_prod` would close this gap.

- **Hint precision**: **Adequate for all formalized declarations.** `\lean{...}` names match exactly: `isIso_modules_of_toPresheaf`, `pushPull_sigma_iso`, `pushPull_leg_sections`, `pushPull_eval_prod_iso`, `cechSection_complex_iso`, `sectionCechComplexV`, `cechSection_contractible`. No wrong-predicate issues.

- **Augmented-vs-non-augmented targeting**: Stubs 5 and 6 correctly target the AUGMENTED form in both the blueprint (`% NOTE:` annotations at lines 8233 and 8308) and the Lean declarations. The iter-056 finding is resolved and consistent on both sides.

- **`\leanok` sync gaps** (minor, infrastructure):
  - `lem:cechSection_complex_iso`: blueprint statement block missing `\leanok` despite the declaration existing in Lean (with sorry). sync_leanok should add it next run.
  - `lem:isIso_modules_of_toPresheaf`: blueprint proof block missing `\leanok` despite the proof being closed. sync_leanok should add it.
  - `lem:pushPull_leg_sections`: blueprint proof block missing `\leanok` despite the proof being closed. sync_leanok should add it.

- **Recommended chapter-side actions**:
  - Add a `% NOTE:` comment inside `\begin{proof}...\end{proof}` of `lem:pushPull_binary_coprod_prod` documenting: (a) use `SheafOfModules.evaluation V` rather than `toPresheaf ⋙ evaluation`, reduce via `Scheme.Modules.Hom.isIso_iff_isIso_app`; (b) obtain the `isProductOfDisjoint` limit in `ModuleCat` via `isLimitOfReflects (forget₂ (ModuleCat R) Ab)`. This converts the prover's handoff note into durable blueprint guidance for the next formalization attempt.

- **Generality**: Adequate. The chain `pushPull_binary_coprod_prod → pushPull_coprod_prod → pushPull_sigma_iso` correctly factors through the abstract induction; the Lean file's use of the abstract `CategoryTheory` namespace helpers for the Stub-1 backbone is consistent with the blueprint's level of generality.

---

## Severity summary

| Finding | Severity |
|---|---|
| Stubs 2/4/5/6 all have correct types matching blueprint; Stubs 5/6 AUGMENTED form confirmed | none (correct) |
| `pushPull_binary_coprod_prod`, `pushPull_coprod_prod` absent in Lean; correctly absent in blueprint | none (expected) |
| `isIso_modules_of_toPresheaf` + `pushPull_leg_sections` proof-block `\leanok` missing in blueprint | minor (sync_leanok) |
| `cechSection_complex_iso` statement-block `\leanok` missing in blueprint | minor (sync_leanok) |
| Blueprint proof sketch for `lem:pushPull_binary_coprod_prod` omits two Lean-specific blockers (instance trap, Ab→ModuleCat bridge); prover blocked | **major** |

**Overall verdict**: CechSectionIdentification.lean faithfully follows the blueprint — all sorry stubs have correct types (including the iter-056 AUGMENTED fix for Stubs 5/6) and the one completed declaration (`isIso_modules_of_toPresheaf`) matches its blueprint statement and proof sketch exactly; the sole issue is a **major** blueprint adequacy gap for `lem:pushPull_binary_coprod_prod` (proof sketch under-specified: missing instance-inference fix and Ab→ModuleCat bridge, which the prover's handoff note already documents). 4 sorry stubs checked, 1 declaration fully proved, 3 red flags (all minor/infrastructure).
