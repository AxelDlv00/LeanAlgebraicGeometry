# Lean ↔ Blueprint Check Report

## Slug
qcohtilde-iter030

## Iteration
030

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant blocks: `lem:qcoh_iso_tilde_sections` ~L3517, `lem:qcoh_iso_tilde_sections_of_presentation` ~L3572, `lem:isIso_fromTildeGamma_of_presentation` ~L3610, `rem:o1i8_decomposition` ~L3621)

---

## Per-declaration

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections}` (chapter: `lem:qcoh_iso_tilde_sections`)
- **Lean target exists**: yes
- **Signature matches**: partial — prose says "F quasi-coherent", Lean has `[IsIso F.fromTildeΓ]` as the hypothesis. The conclusion `F ≅ tilde (moduleSpecΓFunctor.obj F)` is correct. The weakened hypothesis is the known 01I8 gap.
- **Proof follows sketch**: yes — one-liner `(asIso F.fromTildeΓ).symm`, matching the blueprint's "concretely, the inverse of the counit" description.
- **notes**: The `% NOTE` at L3525–3529 accurately and explicitly discloses the conditional form. The blueprint does NOT overclaim: the note says "The formalized declaration is the conditional form requiring IsIso F.fromTildeΓ … not the unconditional quasi-coherent statement." Axiom check: `{propext, Classical.choice, Quot.sound}` — clean.

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_hom}` (chapter: `lem:qcoh_iso_tilde_sections`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(qcoh_iso_tilde_sections F).hom = inv F.fromTildeΓ`; the blueprint prose does not give a separate formal statement but the `\lean{...}` pin includes it.
- **Proof follows sketch**: N/A — `:= rfl` (definitional equality, appropriate for this simp lemma).
- **notes**: Axiom check clean. `:= rfl` is not suspect here: `.hom` of `(asIso …).symm` is definitionally `inv (…)`.

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_inv}` (chapter: `lem:qcoh_iso_tilde_sections`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(qcoh_iso_tilde_sections F).inv = F.fromTildeΓ`.
- **Proof follows sketch**: N/A — `:= rfl` (definitional equality, appropriate).
- **notes**: Axiom check clean. Same reasoning as `_hom`: `.inv` of `(asIso e).symm` is definitionally `e`.

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}` (chapter: `lem:qcoh_iso_tilde_sections_of_presentation`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(F : (Spec R).Modules) (P : F.Presentation) : F ≅ tilde (moduleSpecΓFunctor.obj F)`. The blueprint says "an O_X-module F that admits a global presentation (F.Presentation) is isomorphic to the sheaf associated with its module of global sections." Perfect match.
- **Proof follows sketch**: yes — `haveI := isIso_fromTildeΓ_of_presentation F P; (asIso F.fromTildeΓ).symm`. Blueprint proof sketch (L3599–3607): "A global presentation makes the counit an isomorphism by `isIso_fromTildeΓ_of_presentation`; then `lem:qcoh_iso_tilde_sections` gives the iso as the inverse of the counit." Matches exactly.
- **notes**: `\leanok` present on both statement (L3574) and proof block (L3598). Axiom check: `{propext, Classical.choice, Quot.sound}` — clean.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_presentation}` (chapter: `lem:isIso_fromTildeGamma_of_presentation`)
- **Lean target exists**: yes — provided by Mathlib (`\mathlibok`), re-imported here; not defined in QcohTildeSections.lean itself.
- **Signature matches**: yes — Mathlib lemma, `\mathlibok` marker is correct.
- **Proof follows sketch**: N/A (Mathlib-backed).
- **notes**: Not a declaration in the project file; used as a dependency.

---

## Red flags

*(none)*

No `:= sorry` bodies. No `axiom` declarations. No suspect bodies (`rfl` on non-trivial claims: both uses of `:= rfl` are on simp lemmas that hold by definitional unfolding of `asIso`-symm; they are legitimate). No excuse-comments in the Lean file; only properly-structured module docstrings and doccomments documenting the known 01I8 gap. All four verified declarations have only `{propext, Classical.choice, Quot.sound}` — no non-standard axioms.

---

## Unreferenced declarations (informational)

The following 3 declarations in the Lean file have NO `\lean{...}` block in the blueprint. All are iter-030 additions:

| Declaration | Kind | Summary |
|---|---|---|
| `AlgebraicGeometry.free_isQuasicoherent` | `instance` | Free O_{Spec R}-module (i.e., `SheafOfModules.free ι`) is quasi-coherent, proved via `prop_of_iso` with `tildeFinsupp`. |
| `AlgebraicGeometry.isIso_fromTildeΓ_of_genSections` | `lemma` | Steps (2)–(3) of 01I8: two `GeneratingSections` → bundle into `F.Presentation` → call Mathlib's `isIso_fromTildeΓ_of_presentation`. Substantive content. |
| `AlgebraicGeometry.qcoh_iso_tilde_sections_of_genSections` | `noncomputable def` | Structure theorem directly from two generating families; wraps `isIso_fromTildeΓ_of_genSections` + conditional iso. Substantive content. |

**Faithfulness check**: all three are genuine formalized content (not placeholders):
- `free_isQuasicoherent`: one-line instance via the `prop_of_iso` closure property; mathematically correct (free modules are tilde-sheaves).
- `isIso_fromTildeΓ_of_genSections`: two-line proof by packaging the generating families into `F.Presentation`; correct and non-trivial packaging.
- `qcoh_iso_tilde_sections_of_genSections`: noncomputable def wrapping the above; correct packaging of the full theorem.

The `rem:o1i8_decomposition` (L3621–3668) describes steps (2)–(3) informally and notes they "are now formalised as `isIso_fromTildeΓ_of_genSections` and `qcoh_iso_tilde_sections_of_genSections`" (visible in the Lean `## Handoff` section), but the **blueprint chapter** contains no such prose and no `\lean{...}` pins for these declarations.

**Severity: major** — two of the three (`isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`) are substantive enough to warrant blueprint blocks with `\lean{...}` pins. `free_isQuasicoherent` could be treated as a helper.

---

## Blueprint adequacy for this file

- **Coverage**: 4/7 Lean declarations have a corresponding `\lean{...}` block. Unreferenced: 1 helper-style instance (`free_isQuasicoherent`) + 2 substantive declarations (`isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`) — flagged above.
- **Proof-sketch depth**: **adequate** for the 4 blueprinted declarations. The blueprint's proof sketch for `lem:qcoh_iso_tilde_sections_of_presentation` maps directly to the 2-line Lean proof. The sketch for `lem:qcoh_iso_tilde_sections` correctly describes the conditional one-liner.
- **Hint precision**: **precise** — `\lean{...}` tags name the correct fully-qualified Lean identifiers for all 4 blueprinted declarations.
- **Generality**: **matches need** for the blueprinted scope. The 3 new declarations extend beyond the blueprinted scope into the 01I8 two-generating-families route, which the remark `rem:o1i8_decomposition` describes informally but does not pin with `\lean{...}`.
- **Disclosure of conditional form**: **adequate** — the `% NOTE` at L3525–3529 accurately discloses that `qcoh_iso_tilde_sections` is the conditional form (`[IsIso F.fromTildeΓ]`), not the unconditional quasi-coherent statement. Blueprint does not overclaim.

### Recommended chapter-side actions

1. Add a `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_genSections}` block (new lemma, steps 2–3 packaged) to `rem:o1i8_decomposition` or as a standalone lemma. Statement: `(F : (Spec R).Modules) (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections) : IsIso F.fromTildeΓ`.
2. Add a `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_genSections}` block (structure theorem from two generating families). Statement: `(F : (Spec R).Modules) (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections) : F ≅ tilde (moduleSpecΓFunctor.obj F)`.
3. Optionally add `\lean{AlgebraicGeometry.free_isQuasicoherent}` if the helper is considered project-API-level.

---

## Severity summary

| Finding | Severity |
|---|---|
| `qcoh_iso_tilde_sections` has `[IsIso F.fromTildeΓ]` where prose says "quasi-coherent F" | **major** — partial signature mismatch; accurately disclosed by `% NOTE`; known 01I8 gap |
| `isIso_fromTildeΓ_of_genSections` has no `\lean{...}` blueprint block | **major** — substantive decl, blueprint coverage gap |
| `qcoh_iso_tilde_sections_of_genSections` has no `\lean{...}` blueprint block | **major** — substantive decl, blueprint coverage gap |
| `free_isQuasicoherent` has no `\lean{...}` blueprint block | **minor** — helper-style instance; the `rem:o1i8_decomposition` provides informal cover |

**Overall verdict**: The Lean file is axiom-clean with genuine, non-placeholder content for all 7 declarations; the blueprint accurately discloses the one known signature gap (conditional form) and is adequate for the 4 blueprinted declarations; the 3 iter-030 additions (`free_isQuasicoherent`, `isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`) are faithful Lean but create a blueprint coverage gap that should be addressed in the next blueprint-writing pass.
