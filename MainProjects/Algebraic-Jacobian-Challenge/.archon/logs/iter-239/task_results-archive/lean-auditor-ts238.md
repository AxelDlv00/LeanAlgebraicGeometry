# Lean Audit Report

## Slug
ts238

## Iteration
238

## Scope
- files audited: 1 (primary per directive)
- files skipped (per directive): 0 — directive narrowed scope to `TensorObjSubstrate.lean`

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 4 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 2 flagged (deprecated API, long lines)
- **excuse-comments**: 0 flagged
- **notes**:

#### §5 new declarations (lines 730–862) — FOCUS AREA

  - **`tensorObj_assoc_iso_invertible`** (line 742–745): Body is literally `tensorObj_assoc_iso`; the three hypothesis parameters `_hM`, `_hN`, `_hP` are intentionally unused (underscore-prefixed, documented as "match the blueprint statement"). This is not a bug — the function is a restriction of the unconditional `tensorObj_assoc_iso` to the invertible subcategory for blueprint-pin purposes. Axiom check: `{propext, Classical.choice, Quot.sound}` — clean.

  - **`tensorObj_middleFour`** (line 751–759): `private noncomputable def`. Traces as correct: chains `tensorObj_assoc_iso` ≪≫ `tensorObjIsoOfIso (refl A) inner` ≪≫ `assoc_iso.symm` to yield `(A⊗B)⊗(C⊗D) ≅ (A⊗C)⊗(B⊗D)` via a B-C braiding inside. Axiom-clean.

  - **`IsInvertible.tensorObj`** (line 764–770): If `M⊗N≅𝒪` and `M'⊗N'≅𝒪`, then `(M⊗M')⊗(N⊗N') ≅ (M⊗N)⊗(M'⊗N') ≅ 𝒪⊗𝒪 ≅ 𝒪` via `tensorObj_middleFour ≪≫ tensorObjIsoOfIso e e' ≪≫ tensorObj_unit_iso`. Mathematically correct. Axiom check: clean.

  - **`isInvertible_unit`** (line 774–776): `IsInvertible 𝒪_X` via witness `𝒪_X` and iso `tensorObj_unit_iso : 𝒪_X ⊗ 𝒪_X ≅ 𝒪_X`. Correct; the tensor unit is its own inverse. Axiom-clean.

  - **`IsInvertible.inverse_unique`** (line 781–789): If `M⊗N ≅ 𝒪` and `M⊗N' ≅ 𝒪`, proves `N ≅ N'` via the chain `N ≅ N⊗𝒪 ≅ N⊗(M⊗N') ≅ (N⊗M)⊗N' ≅ 𝒪⊗N' ≅ N'` (right-unitor, tensorObjIsoOfIso, assoc.symm, braiding+e, left-unitor). Mathematically correct. Axiom-clean.

  - **`picSetoid`** (line 793–796): Standard isomorphism setoid on `{M : X.Modules // IsInvertible M}`. Reflexivity/symmetry/transitivity by `Iso.refl`, `.symm`, `≪≫`. No issues.

  - **`PicGroup`** (line 800): `Quotient (picSetoid X)`. Clean.

  - **`picMul`** (line 805–810): `Quotient.lift₂` with well-definedness via `tensorObjIsoOfIso ea eb`. `Classical.choose`/`Classical.choice` not used here. Clean.

  - **`picInv`** (line 814–827): Uses `Classical.choose a.2` to extract inverse witness from `IsInvertible M`. `Classical.choose_spec a.2 : Nonempty (M ⊗ N ≅ 𝒪)` then `.some` gives the iso. The inverse class packages `N` as invertible with witness `M` via `tensorObj_braiding N M ≪≫ spec.some`. Well-definedness: uses `IsInvertible.inverse_unique` correctly. The `Classical.choose` usage is authorized — `IsInvertible` is an existential by definition. Axiom-clean.

  - **`picCommGroup`** (line 834–861): All five group axioms:
    - `mul_assoc`: `Quotient.sound ⟨tensorObj_assoc_iso⟩` ✓
    - `one_mul`: `Quotient.sound ⟨tensorObj_left_unitor a.1⟩` ✓
    - `mul_one`: `Quotient.sound ⟨tensorObj_right_unitor a.1⟩` ✓
    - `inv_mul_cancel`: `Quotient.sound ⟨tensorObj_braiding N M ≪≫ spec.some⟩` ✓
    - `mul_comm`: `Quotient.sound ⟨tensorObj_braiding a.1 b.1⟩` ✓
    - All correct. Axiom check confirms: `{propext, Classical.choice, Quot.sound}` — no `sorryAx`. The group law is genuinely axiom-clean.

#### `tensorObj_assoc_iso` unconditional change (line 341) — FOCUS AREA

  - **Route change confirmed**: The body (lines 358–382) uses `PresheafOfModules.W_whiskerRight_of_W` and `PresheafOfModules.W_whiskerLeft_of_W`, NOT the `_of_flat` variants. The whiskered morphisms are in `W` because `η = toSheafify` is in `W` unconditionally (`W_toSheafify`). The removed hypotheses (`IsInvertible M/N/P`) are genuinely not used.
  - **Axiom check**: `{propext, Classical.choice, Quot.sound}` — no `sorryAx`. The declaration is axiom-clean, not sorry-transitive.
  - **Stale docstring** (FLAGGED — see Major issues): the docstring block lines 302–340 still describes the OLD flatness-based argument that has been superseded by route (d).

#### Existing acknowledged sorries

  - `exists_tensorObj_inverse` (line 715): explicit `sorry`, body comment documents the two remaining bridges. No new concern.
  - `addCommGroup_via_tensorObj` (line 893–894): explicit `sorry`. No new concern.

#### Deprecated API

  - `CategoryTheory.Sheaf.val` appears in **16 places** (lines 139, 155, 195, 207, 242, 259, 261, 271, 273, 281, 283, 291, 349, 352, 357, 376, 378 — per LSP diagnostics). Deprecated: should use `ObjectProperty.obj`.

#### Long lines

  - Lines 504–506 exceed the 100-character style limit.

#### False-positive from verify scanner

  - `lean_verify` flagged line 488 for the string `opaque` — this word appears inside a proof comment (`-- opaque and block the...`), not as actual code. Not a real issue.

---

## Must-fix-this-iter

None. No must-fix conditions are met:
- No excuse-comments.
- No weakened-wrong definitions.
- No parallel Mathlib APIs.
- No non-standard axioms on substantive claims.
- The two `sorry` bodies are pre-existing, explicitly acknowledged, and flagged by the project.

---

## Major

- `TensorObjSubstrate.lean:302–303` — **Stale sorry-transitivity claim**. The docstring of `tensorObj_assoc_iso` states *"it is `sorry`-transitive only through the route-(e) residual `isLocallyInjective_whiskerLeft_of_W`."* This was true for the old flatness-based route. The new route-(d) body does NOT depend on `isLocallyInjective_whiskerLeft_of_W`. Axiom check confirms no `sorryAx` — the declaration is genuinely axiom-clean. The comment actively misinforms readers about the sorry-debt status of a load-bearing declaration.

- `TensorObjSubstrate.lean:308–340` — **Stale flatness-based proof description**. The 30-line block in `tensorObj_assoc_iso`'s docstring describes the OLD argument: "steps 1/3 need... `W_whiskerLeft/Right_of_flat` supply ONLY from the SECTIONWISE flatness instance... invertible ⇒ projective ⇒ flat conflates...". None of this describes the actual body, which uses `W_whiskerRight_of_W`/`W_whiskerLeft_of_W` and no flatness. The block is large and would mislead any reader of the code about WHY `tensorObj_assoc_iso` is unconditional.

- `TensorObjSubstrate.lean:43–45` — **Status section lists wrong residuals**. Module header says "The remaining typed-`sorry` residuals are... `isLocallyInjective_whiskerLeft_of_W`" as if the assoc-iso still depends on it. As noted above, the new `tensorObj_assoc_iso` body does not use this lemma at all. The header also omits the newly-landed §5 (`picCommGroup` and supporting declarations). This is a significant documentation inaccuracy — any agent reading the status block will form an incorrect picture of the file's sorry-debt.

- `TensorObjSubstrate.lean:730 vs 865` — **Section numbering disorder** (minor-major). §5 (line 730) appears in the file BEFORE §4 (line 865). The sequence reads §1 → §2 → §3 → §5 → §4. The §4 "Consumer" section was apparently written before §5 was added this iter, and §5 was inserted above it. Confusing for readers and for automated section-matching tools.

---

## Minor

- `TensorObjSubstrate.lean:742–745` — `tensorObj_assoc_iso_invertible` takes three unused invertibility hypotheses `_hM, _hN, _hP` while forwarding to the now-unconditional `tensorObj_assoc_iso`. Intent is documented ("match the blueprint statement"), but this wrapper is now a pure restriction with no proof content. Benign, but a reader might wonder why the hypotheses exist.

- `TensorObjSubstrate.lean:57–87` — "3 blueprint-pinned declarations" section does not mention `picCommGroup` or the §5 declarations that were added this iter. Stale count, mildly misleading.

- `TensorObjSubstrate.lean:98–112` — Sub-module layout comment lists the file as containing only items through `addCommGroup_via_tensorObj`; the newly-added §5 group law is not reflected.

- `TensorObjSubstrate.lean:139,155,195,207,…` (16 sites) — `CategoryTheory.Sheaf.val` deprecated in favour of `ObjectProperty.obj`. Low urgency but will accumulate if a Mathlib bump removes the deprecation shim.

- `TensorObjSubstrate.lean:504–506` — Three lines exceeding the 100-char style limit.

---

## Excuse-comments (always called out separately)

None found. No declaration carries a comment admitting the code is temporarily wrong or a placeholder.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 4 (stale sorry-transitivity claim on a load-bearing declaration; stale flatness-proof description; wrong residuals in status header; section ordering disorder)
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: The new §5 declarations are genuinely correct and axiom-clean — the `picCommGroup` group law is a real construction with no vacuity, circular steps, or hidden sorries. The primary audit concern is documentation rot: four major stale-comment findings, the most important being that `tensorObj_assoc_iso`'s docstring incorrectly claims sorry-transitivity through `isLocallyInjective_whiskerLeft_of_W` when the axiom check proves the declaration is clean.
