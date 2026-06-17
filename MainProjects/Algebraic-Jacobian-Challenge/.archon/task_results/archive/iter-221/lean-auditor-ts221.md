# Lean Audit Report

## Slug
ts221

## Iteration
221

## Scope
- files audited: 1 (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, 1898 lines)
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 2 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 1 flagged (transitive `sorryAx` in `tensorObj_assoc_iso`)
- **bad practices**: 1 flagged (blanket `import Mathlib`; deprecated API)
- **excuse-comments**: 0 flagged
- **notes**:
  - **Sorry inventory (3 sites, all pre-existing):**
    - **Line 602/634** — `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W`: direct `sorry`, confirmed via diagnostics (warning: "declaration uses sorry" at line 602). The body comment gives a detailed, honest decomposition of the two remaining Mathlib-absent ingredients (d.1-bridge + d.2 stalk-⊗ commutation). This is the whiskering-residual sorry the directive expects.
    - **Line 1839/1848** — `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse`: direct `sorry`, confirmed. Honest docstring: "BLOCKED at step 1". Pre-existing.
    - **Line 1889/1892** — `AlgebraicGeometry.Scheme.Modules.PicSharp.addCommGroup_via_tensorObj`: direct `sorry`, confirmed. Consumer sorry; honest docstring.
  - **Focus declarations — all axiom-clean (lean_verify confirmed):**
    - `PresheafOfModules.dual`: `{propext, Classical.choice, Quot.sound}` only. Body is `InternalHom.internalHom M (𝟙_)` — not vacuous, not placeholder.
    - `PresheafOfModules.InternalHom.termRingMap_terminal` (line 1321): proved `simp only [...]; rfl`. Axiom-clean. Statement is non-trivial (identity endomorphism of terminal ring recovers identity).
    - `PresheafOfModules.evalLin` (line 1357): noncomputable def extracting the linear map from a dual section. Axiom-clean. Statement correct.
    - `PresheafOfModules.evalLin_add` (line 1367): proved `LinearMap.ext fun _ => rfl`. Axiom-clean. Proof is definitionally correct (addition in `Hom` is pointwise).
    - `PresheafOfModules.evalLin_smul` (line 1375): proved `LinearMap.ext ... rw [termRingMap_terminal]; rfl`. Axiom-clean. Uses `termRingMap_terminal` to identify the over-category scalar with the base ring scalar.
    - `PresheafOfModules.internalHomEvalApp` (line 1398): noncomputable def via `TensorProduct.lift` + `LinearMap.mk₂`. No sorry. Axiom-clean. Statement is the bilinear contraction `M(X) ⊗ Hom(M|_X, R|_X) → R(X)`, which is mathematically correct.
  - **`@[implicit_reducible]` on `internalHomObjModule`**: Present at line 1125, correctly placed before `noncomputable def internalHomObjModule`. ✓
  - **`tensorObj_assoc_iso` has transitive `sorryAx`**: lean_verify returns `["propext","sorryAx","Classical.choice","Quot.sound"]`. The proof body has no direct `sorry` — it calls `W_whiskerLeft_of_W` / `W_whiskerRight_of_W` which call `isLocallyInjective_whiskerLeft_of_W` (sorry). The proof is non-trivial (ROUTE (d) three-step composite, 40+ lines), not a placeholder; the transitive sorry is the expected one. However, this is not fully disclosed in the declaration's own docstring.
  - **Deprecated API — 14 occurrences of `CategoryTheory.Sheaf.val`**: compiler warning "has been deprecated: Use ObjectProperty.obj" at lines 1441, 1457, 1502, 1519, 1521, 1531, 1533, 1541, 1543, 1551, 1609, 1612, 1617, 1636, 1638. These affect `tensorObj`, `tensorObj_functoriality`, `tensorObjIsoOfIso`, `tensorObj_unit_iso`, `tensorObj_{left,right}_unitor`, `tensorObj_braiding`, `tensorObj_assoc_iso`.
  - **Stale docstring on `tensorObjOnProduct`** (line 1853): says "iter-202 Lane TS scaffold: typed `sorry`" — but the body is fully proved (`⟨tensorObj …, tensorObj_isLocallyTrivial …⟩`) with no sorry; lean_verify confirms axiom-clean. This misreports the sorry status.
  - **Stale docstring on `tensorObj_assoc_iso`** (lines 1562–1598): the lengthy embedded status block describes "genuine residual is now the flatness feeding steps 1 and 3", referencing the flatness route that was superseded by ROUTE (d). The actual proof at lines 1603–1642 uses ROUTE (d) (`W_whiskerLeft/Right_of_W`), which avoids flatness entirely and instead depends on `isLocallyInjective_whiskerLeft_of_W`. The comment does not update to say "ROUTE (d) chosen; residual is `isLocallyInjective_whiskerLeft_of_W`". A reader of the docstring in isolation gets an outdated picture.
  - **Unused hypotheses in `tensorObj_assoc_iso`**: linter warns at lines 1600–1601 that `hM`, `hN`, `hP` (`IsLocallyTrivial` hypotheses) are unused. The in-proof comment at line 1603 explicitly acknowledges this ("locally-trivial hypotheses are not even consumed… but are retained to match the blueprint pin"). Not a bug, but a signature broader than the proof needs.
  - **`ext` pattern warning** at line 311 (`ext r` where `r` is not consumed). Minor linter issue.
  - **Long lines** at lines 1764, 1765, 1766 (exceeding 100 character limit). Style linter warnings.
  - **`set_option backward.isDefEq.respectTransparency false`** appears at lines 302, 318, 335, 903 — a workaround for instance-diamond/typeclass elaboration issues. Not problematic in itself but signals brittleness in instance resolution.
  - **`import Mathlib`** (line 6) — blanket import. Project-wide pattern; minor.
  - **No errors** in the diagnostic output (zero compilation errors).
  - **No excuse-comments**. All sorry sites have honest, detailed decompositions of the missing Mathlib ingredients.

---

## Must-fix-this-iter

None. No violations of the must-fix criteria:
- No excuse-comments (e.g. "TODO replace", "placeholder", "temporary wrong def").
- No weakened or wrong definitions: `dual`, `evalLin`, `internalHomEvalApp` carry their correct mathematical content.
- No parallel APIs of existing Mathlib (these are genuine supplements for absent Mathlib infrastructure).
- No vacuous or structurally-wrong bodies: all six focus declarations are substantive.
- No unauthorized axioms: all six focus declarations are `{propext, Classical.choice, Quot.sound}`.

---

## Major

- `TensorObjSubstrate.lean:1853` — **Stale status comment on `tensorObjOnProduct`**: docstring says "iter-202 Lane TS scaffold: typed `sorry`" but the declaration is fully proved (body `⟨tensorObj …, tensorObj_isLocallyTrivial …⟩`, no sorry, lean_verify axiom-clean). This misreports the sorry status of a declaration.
- `TensorObjSubstrate.lean:1562` — **Stale status block on `tensorObj_assoc_iso`**: describes "genuine residual is now the flatness feeding steps 1 and 3" but the proof uses ROUTE (d) which avoids flatness; actual residual is `isLocallyInjective_whiskerLeft_of_W`. Gives an outdated picture to readers of the declaration in isolation.
- `TensorObjSubstrate.lean:1441,1457,1502,…` — **14 uses of deprecated `CategoryTheory.Sheaf.val`**: compiler deprecation warnings at 14 call sites. Should be updated to `ObjectProperty.obj` before Mathlib removes the old accessor.

---

## Minor

- `TensorObjSubstrate.lean:602` — **Transitive `sorryAx` in `tensorObj_assoc_iso` not disclosed in its own docstring**: the declaration's docstring doesn't say explicitly that the proof depends on the sorry in `isLocallyInjective_whiskerLeft_of_W`. The file header status block (lines 37–47) correctly lists the 3 sorry residuals, so it is indirectly acknowledged.
- `TensorObjSubstrate.lean:1600` — **Unused hypotheses `hM`, `hN`, `hP`** in `tensorObj_assoc_iso`. Acknowledged in inline comment. Proof works for arbitrary modules; hypotheses kept for blueprint conformance only.
- `TensorObjSubstrate.lean:311` — **`ext r` does not consume pattern `r`** (linter: unusedRCasesPattern). Harmless but noisy.
- `TensorObjSubstrate.lean:1764–1766` — **Three lines exceed the 100-character style limit**. Linter warnings.
- `TensorObjSubstrate.lean:302,318,335,903` — **`set_option backward.isDefEq.respectTransparency false`** at 4 locations. Known workaround for typeclass/universe issues; not incorrect, but signals resolution fragility.
- `TensorObjSubstrate.lean:6` — **`import Mathlib`** blanket import. Project-wide pattern.

---

## Excuse-comments (always called out separately)

None found. All sorry sites carry honest, technically detailed explanations of the specific Mathlib-absent infrastructure they are waiting on. No declaration apologizes for being wrong while pretending to be correct.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3 (2 stale docstrings misreporting proof status; 1 deprecated API cluster)
- **minor**: 6
- **excuse-comments**: 0

Overall verdict: The six focus declarations (`dual`, `termRingMap_terminal`, `evalLin`, `evalLin_add`, `evalLin_smul`, `internalHomEvalApp`) are all genuinely proved and axiom-clean; the three expected pre-existing sorries are present at lines 602/634, 1839/1848, 1889/1892 and no new sorries were introduced; the primary actionable issues are two stale status docstrings that misreport proof status (`tensorObjOnProduct` and `tensorObj_assoc_iso`) and a cluster of 14 deprecated-API warnings from `Sheaf.val`.
