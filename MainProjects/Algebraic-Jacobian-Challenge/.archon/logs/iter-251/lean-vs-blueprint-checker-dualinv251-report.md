# Lean ↔ Blueprint Check Report

## Slug
dualinv251

## Iteration
251

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`, L5380)
- **Lean target exists**: yes — `noncomputable def dual_restrict_iso` at L228.
- **Signature matches**: yes.
  - Blueprint: "For an open immersion f : Y → X and M ∈ Scheme.Modules X, a canonical isomorphism `(dual M)|_f ≅ dual(M|_f)`, natural in M."
  - Lean: `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) : (dual M).restrict f ≅ dual (M.restrict f)`. Perfect match.
- **Proof follows sketch**: partial.
  - Blueprint proof describes three ingredients (a) per-V slice equivalence, (b) codomain agreement, (c) ring-iso transport via `restrictScalarsRingIsoDualEquiv`, corresponding to Steps 1–4. Steps 1–3 (H1/H2 route) land axiom-clean in Lean; Step 4 (the presheaf residual `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`) is `sorry` at L254. This matches the blueprint prose at the high level; the `sorry` is expected at this stage.
- **`\leanok` status**: Blueprint has `\leanok` in the STATEMENT BLOCK (L5377, before `\label`) = "formalized, sorry present". This is correct. The PROOF BLOCK at L5409 has **no** `\leanok`, correctly indicating the proof is not sorry-free.
- **notes**: No overclaiming. The sorry is honest.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`, L5480)
- **Lean target exists**: yes — `lemma dual_isLocallyTrivial` at L330.
- **Signature matches**: yes.
  - Blueprint: "If LineBundle.IsLocallyTrivial L then LineBundle.IsLocallyTrivial (dual L)."
  - Lean: `(hL : LineBundle.IsLocallyTrivial L) : LineBundle.IsLocallyTrivial (dual L)`. Perfect match.
- **Proof follows sketch**: yes (the body is the three-step chain; blueprint proof §5.4 describes exactly this chain).
  - Blueprint Step 1 → `dual_restrict_iso U.ι L` ✓
  - Blueprint Step 2 → `(dualIsoOfIso eL).symm` ✓
  - Blueprint Step 3 → `dual_unit_iso` ✓
  - Lean body at L339: `dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso`. Exact match.
- **`\leanok` status**: Blueprint has `\leanok` in the STATEMENT BLOCK (L5477) = "formalized, sorry present". Correct. The PROOF BLOCK at L5500 has **no** `\leanok`. Correct — the proof transitively carries `sorryAx` through `dual_restrict_iso`.
- **Dependency flagging**: Blueprint explicitly lists `\uses{lem:dual_restrict_iso, ...}` in both the statement block and proof block. The blueprint does NOT claim `dual_isLocallyTrivial` is fully proved without flagging `dual_restrict_iso`. No false completeness claim.
- **notes**: Clean. The blueprint is correctly transparent about the sorry dependency chain.

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`, L5602)
- **Lean target exists**: yes — `noncomputable def homOfLocalCompat` at L411.
- **Signature matches**: yes (informal prose agrees with the formalization).
  - Blueprint: "Given f_i : M|_{U_i} → N|_{U_i} with restrictions agreeing on U_i ∩ U_j, there is a unique global morphism M → N."
  - Lean has the HEq compatibility condition, which the Lean docstring correctly explains is forced by propositional-but-not-definitional equality of the double-restriction sources. The blueprint prose (L5606) correctly anticipates this: "the restrictions of f_i and f_j to U_i ∩ U_j agree."
  - The HEq formalization is the expected concretization of the prose; no mismatch.
- **Proof follows sketch**: N/A — body is `:= sorry` at L420.
- **`\leanok` status**: Blueprint has `\leanok` in the STATEMENT BLOCK (L5599) = "formalized, sorry present". Correct.
- **notes**: Scaffold is in place; no proof content yet to compare. The `sorry` is expected.

---

## Red flags

### Placeholder / suspect bodies
- `dual_restrict_iso` at L254: `:= sorry` at the Step-4 presheaf residual. Blueprint's statement block correctly marks this as formalized (sorry present); proof block has no `\leanok`. The sorry is **expected** and honestly documented. **Not a flag against blueprint consistency** — but records the open work.
- `homOfLocalCompat` at L420: body is `:= sorry`. Again honestly documented by `\leanok` in statement block, no `\leanok` in proof block. Expected.

### Excuse-comments
None. The docstrings describe the state as "PARTIAL" and "OPEN" accurately, without claiming anything incorrect.

### Axioms / Classical.choice
None introduced. The four new infra declarations are all `noncomputable def` with real bodies.

---

## Unreferenced declarations (informational)

The following declarations exist in the Lean file but have no `\lean{...}` reference in the blueprint:

| Declaration | Namespace | Status | Assessment |
|---|---|---|---|
| `PresheafOfModules.unitDualSectionEquiv` | `PresheafOfModules` | axiom-clean | Pure implementation helper for `dualUnitIsoGen`; acceptable as unreferenced. |
| `PresheafOfModules.dualUnitIsoGen` | `PresheafOfModules` | axiom-clean | Builds `PresheafOfModules.dual 𝟙_ ≅ 𝟙_` in full generality; feeds `presheafDualUnitIso`. Substantive lemma; could warrant a blueprint block. |
| `AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso` | `Scheme.Modules` | axiom-clean | Specialization of `dualUnitIsoGen` to a scheme's presheaf; thin wrapper. Acceptable as unreferenced. |
| `AlgebraicGeometry.Scheme.Modules.dual_unit_iso` | `Scheme.Modules` | axiom-clean | **Named in the blueprint proof of `lem:dual_isLocallyTrivial`** at L5525 ("The third isomorphism trivialises the dual of the unit, dual O_U ≅ O_U (dual_unit_iso)"). This is a substantive lemma referenced by name in the blueprint's proof sketch, but it has no `\lean{...}` block in the blueprint and therefore carries no `\leanok` tracking. Should have a blueprint block. |

The most notable gap is `dual_unit_iso`: named in the blueprint proof of `lem:dual_isLocallyTrivial` as the third isomorphism, but no `\lean{...}` hint exists for it, so the blueprint cannot track whether it is formalized.

---

## Blueprint adequacy for this file

- **Coverage**: 3/3 declared `\lean{...}`-targeted declarations (`dual_restrict_iso`, `dual_isLocallyTrivial`, `homOfLocalCompat`) have a corresponding `\lean{...}` block in the blueprint. Unreferenced declarations: 3 acceptable helpers (`unitDualSectionEquiv`, `dualUnitIsoGen`, `presheafDualUnitIso`) + 1 substantive (`dual_unit_iso`, named in proof text but lacking a formal block).

- **Proof-sketch depth**: **adequate for Steps 1–3**; **under-specified for Step 4** (the sorry residual).
  - The blueprint proof of `lem:dual_restrict_iso` describes the three ingredients (a), (b), (c) at a correct high level, and correctly names `restrictScalarsRingIsoDualEquiv` as the H2′ tool.
  - However, the blueprint does NOT contain the critical implementation warning — present only in the Lean docstring — that `overSliceSheafEquiv` (a Sheaf-category equivalence with fixed value category `A`) is NOT applicable to the Step-4 presheaf residual, because the dual's per-V value uses a VARYING ring `O_Y(V)`. A prover reading only the blueprint might attempt `overSliceSheafEquiv` and waste iterations discovering it cannot handle the varying-module-structure. This warning lives exclusively in the Lean docstring (the "WARM-CONTEXT WARNING" block).
  - The blueprint proof of `lem:sheafofmodules_hom_of_local_compat` is thorough and detailed (two pages of proof sketch at L5611–5692), well above adequate.

- **Hint precision**: **precise for `dual_restrict_iso` and `dual_isLocallyTrivial`**; **imprecise for `dual_unit_iso`** (named in proof text only).
  - `lem:dual_restrict_iso` and `lem:dual_isLocallyTrivial` have precise `\lean{...}` hints that match the actual Lean signatures exactly.
  - `dual_unit_iso` is named informally in the proof body of `lem:dual_isLocallyTrivial` (Step 3) without a `\lean{...}` hint, so there is no leanok tracking for it. Since the three-step chain assembly depends on `dual_unit_iso`, the blueprint's treatment of `lem:dual_isLocallyTrivial` is incomplete without a formal reference.

- **Generality**: **matches need**. The blueprint's statement blocks and proof sketches are written at the right level for the Lean to consume. No parallel API needed.

- **Recommended chapter-side actions**:
  1. Add a `\begin{lemma}...\end{lemma}` block for `dual_unit_iso` with `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` and statement "The sheaf-level dual of the structure sheaf is the structure sheaf, `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`, via evaluation at 1." This is currently Step 3 in the `lem:dual_isLocallyTrivial` proof and should be promoted to a named blueprint block.
  2. Optionally add a note to the `lem:dual_restrict_iso` proof block warning that `overSliceSheafEquiv` is inapplicable to the Step-4 residual (the per-V ring varies; `overSliceSheafEquiv` has a fixed value category). Currently this warning lives only in the Lean docstring.
  3. Optionally add a blueprint block for `dualUnitIsoGen` (or reference it as a helper of `dual_unit_iso`) to enable `\leanok` tracking on the presheaf-level dual-unit iso.

---

## Severity summary

- **must-fix-this-iter**: none.
- **major** (1 finding):
  - `dual_unit_iso` is explicitly named in the blueprint's proof of `lem:dual_isLocallyTrivial` as a named isomorphism ("the third isomorphism … dual_unit_iso"), but has no `\lean{...}` block in the blueprint. This means it cannot be `\leanok`-tracked, and it is axiom-clean (a fully closed declaration). The blueprint-writing subagent should add a formal block.
- **minor** (1 finding):
  - The blueprint's proof sketch for `lem:dual_restrict_iso` (Step 4 / the presheaf residual) does not contain the `overSliceSheafEquiv`-inapplicability warning present in the Lean docstring. A fresh prover reading only the blueprint might attempt that route. Low risk since the Lean docstring supplies the warning in-file.

**Overall verdict**: The three `\lean{...}`-referenced declarations have matching signatures and correctly-placed `\leanok` markers; the blueprint does not claim `dual_isLocallyTrivial` is fully proved without flagging its `dual_restrict_iso` dependency. The single actionable gap is the missing formal blueprint block for `dual_unit_iso`, which is named in the proof text but lacks a tracked declaration.
