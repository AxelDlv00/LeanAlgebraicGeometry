# Lean Audit Report

## Slug
quot-iter042

## Iteration
042

## Scope
- files audited: 1 (directive-scoped to `AlgebraicJacobian/Picard/QuotScheme.lean`)
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/QuotScheme.lean`

- **outdated comments**: 1 flagged (line 650, "not yet formalized" is now stale)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Line 2251 — `restrictₗ`**: Axiom-clean (`propext`/`Classical.choice`/`Quot.sound` only). Signature is honest: the `letI : Module Γ(X, U) Γ(M, V) := Module.compHom _ (X.presheaf.map i.op).hom` in both the return type and body establishes the scalar-restriction structure along the presheaf restriction map, which is the correct and intended structure. The `map_smul'` field delegates to `Scheme.Modules.map_smul`. No issues.
  - **Line 2267 — `restrictBasicOpenₗ`**: Axiom-clean. Signature is honest: takes caller-supplied `[Module Γ(X, U) Γ(M, X.basicOpen f)]` and `[IsScalarTower ...]`, which is flexible but not weaker — it lets gap2 supply the exact instances it needs. The `map_smul'` proof uses `algebraMap_smul` correctly. **Currently unused anywhere in this file or the project** (grep confirms definition-site only). Forward declaration for the gap2 statement.
  - **Line 2288 — `fromSpec_image_top_section_coherence`**: Axiom-clean. Signature is honest: proves the ring-map equality `X.presheaf.map (eqToHom eT.symm).op = (hU.fromSpec.appIso ⊤).hom ≫ (ΓSpecIso Γ(X,U)).hom` which is the coherence transport between the two section-ring maps along `fromSpec ''ᵁ ⊤ = U`. `Subsingleton.elim` applied to hom-sets in a preorder (Opens) is valid. **Currently unused anywhere in this file or the project**. Forward declaration for gap2.
  - **Line 2321 — `section_localization_hfr_aux_general`**: Axiom-clean. The `letI`/`show … from` idiom is consistent: the `letI` in the return type installs `Module.compHom _ (X.presheaf.map (j.opensFunctor.map (homOfLE le_top)).op).hom` as the `Γ(X, j ''ᵁ ⊤)`-module structure on `Γ(M, j ''ᵁ D(f'))`, which matches the `letI` inside `restrictₗ`'s return type verbatim. The `letI iAN₂` inside the proof body establishes the same structure, so `h` and `restrictₗ M ii` are definitionally equal; `exact RESULT` closes. No weakening or defeq abuse. The hypothesis chain (`hf'` with `σ f' = f`, `key : (powers f').map σ = powers f`) correctly routes the localization conclusion back to `powers f`. **Currently unused anywhere in this file or the project**. Forward gap2-core helper.
  - **Line 2433 — `isLocalizedModule_basicOpen_of_isQuasicoherent`**: Axiom-clean. Statement is honest (non-trivial `IsLocalizedModule` claim for quasi-coherent `M` on `Spec R`). The proof `haveI := isIso_fromTildeΓ_of_isQuasicoherent M; isLocalizedModule_restrict_of_isIso_fromTildeΓ M f` is correct. **However, this declaration has exactly the same statement as the pre-existing `isLocalizedModule_basicOpen_descent` (line 2396)**, differing only in the named vs anonymous typeclass instance binder. The proof of `isLocalizedModule_basicOpen_of_isQuasicoherent` proceeds through `isIso_fromTildeΓ_of_isQuasicoherent`, which itself calls `isLocalizedModule_basicOpen_descent` — so the new theorem proves the same fact via a round-trip through the old one. Neither theorem is used as a proof term by anything else in the project at this point.
  - **Line 650 (pre-existing docstring) — stale "not yet formalized"**: The docstring of `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` reads: `("isLocalizedModule_basicOpen_of_isQuasicoherent", "lem:qcoh_affine_section_localization", not yet formalized)`. `isLocalizedModule_basicOpen_of_isQuasicoherent` is now formalized at line 2433; the parenthetical is stale.
  - The 4 protected sorry stubs at lines 126/165/201/228 are out of scope (iter-176 scaffold) — not flagged.
  - The `% NOTE`/`opaque` word at line 2025 is prose — not flagged.

---

## Must-fix-this-iter

None.

All 5 new declarations are:
- Axiom-clean (only `propext`, `Classical.choice`, `Quot.sound`).
- No `sorry` in proof bodies.
- No vacuous statements, no `:= True`, no `:= Classical.choice _`.
- No weaker-than-intended types or mismatched `letI`/`show` ascriptions.

The `letI : Module … := Module.compHom …` + `show … from restrictₗ M i` idiom in `section_localization_hfr_aux_general` is sound: the outer `letI`, the `restrictₗ` internal `letI`, and the proof-body `letI iAN₂` all install the same `Module.compHom` expression, and the final `exact RESULT` closes by definitional equality of `h` and `restrictₗ M ii`.

---

## Major

- `QuotScheme.lean:2433` — `isLocalizedModule_basicOpen_of_isQuasicoherent` is a statement-duplicate of the pre-existing `isLocalizedModule_basicOpen_descent` (line 2396). Both state `IsLocalizedModule (Submonoid.powers f) ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE le_top).op).hom` for `[M.IsQuasicoherent]` on `Spec R`. The new theorem's proof routes through `isIso_fromTildeΓ_of_isQuasicoherent`, which internally calls `isLocalizedModule_basicOpen_descent` — making the proof a logical tautology (proves `X` via `X → Y → X`). With two non-private names in the same namespace for the same mathematical fact, there is no unambiguous canonical form for downstream callers. Recommend either (a) removing `isLocalizedModule_basicOpen_of_isQuasicoherent` and renaming `isLocalizedModule_basicOpen_descent` as the canonical G1-core export, or (b) making `isLocalizedModule_basicOpen_descent` private and keeping `isLocalizedModule_basicOpen_of_isQuasicoherent` as the sole export.

---

## Minor

- `QuotScheme.lean:650` — Stale "not yet formalized" annotation in the docstring of `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`. The referenced declaration `isLocalizedModule_basicOpen_of_isQuasicoherent` is now formalized at line 2433; the parenthetical should be removed or updated.
- `QuotScheme.lean:2267` — `restrictBasicOpenₗ` is unused in this file and the entire project (definition-site only, confirmed by grep). It is a forward declaration for the gap2 keystone. No semantic issue, but it adds a dead export to the public API.
- `QuotScheme.lean:2288` — `fromSpec_image_top_section_coherence` is unused in this file and the entire project. Same status as `restrictBasicOpenₗ`.
- `QuotScheme.lean:2321` — `section_localization_hfr_aux_general` is unused in this file and the entire project. The gap2 keystone it is intended to serve (`isLocalizedModule_basicOpen`) is not yet present in the file. This is the most significant orphan because it is the substantive engine; its absence from gap2 means gap2 is still open.
- `QuotScheme.lean:2433` — `isLocalizedModule_basicOpen_of_isQuasicoherent` is itself unused as a proof term anywhere in the project at this point (the name appears only in docstring references at lines 599, 697, and the now-stale line 650 comment).

---

## Excuse-comments (always called out separately)

None found. The docstrings contain forward-looking prose ("Project-local", "iter-177+", "gap2") but no excuse-comments admitting wrong or placeholder code.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: All 5 new declarations are axiom-clean and logically honest; the `letI`/`show`-from idiom in `section_localization_hfr_aux_general` is consistent and uses the intended module structure — but `isLocalizedModule_basicOpen_of_isQuasicoherent` silently duplicates the pre-existing `isLocalizedModule_basicOpen_descent`, and three of the four gap2 forward helpers (`restrictBasicOpenₗ`, `fromSpec_image_top_section_coherence`, `section_localization_hfr_aux_general`) are currently dead code with no consumer in the project.
