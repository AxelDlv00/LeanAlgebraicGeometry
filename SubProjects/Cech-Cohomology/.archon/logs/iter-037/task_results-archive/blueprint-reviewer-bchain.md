# Blueprint Review Report

## Slug
bchain

## Iteration
037

## Top-level summaries

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:restrict_over_compat` (B3): proof sketch names `pushforwardPushforwardEquivalence_mathlib` as the mechanism but does not specify how to construct the required ring maps `φ : S ⟶ (eqv.functor.sheafPushforwardContinuous...)...obj R` and `ψ : R ⟶ ...` or their two compatibility diagram equalities, which the actual Mathlib API (`SheafOfModules.pushforwardPushforwardEquivalence`) requires as explicit arguments beyond the bare categorical equivalence `eqv`. The omission does not break the statement or make formalization impossible — the data is standard for the over-site identification `(Opens Spec R).over D(g) ≃ Opens(Spec R_g)` — but a prover will need to search for how to package these conditions.

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_section_isLocalizedModule` (keystone): the proof prose at the "Crucial non-circularity point" paragraph (line 4202) directly cites `lem:restrict_obj_mathlib` ("the definitional equality... of the restriction (Lemma~\ref{lem:restrict_obj_mathlib})") but `lem:restrict_obj_mathlib` does not appear in the proof block's `\uses{}`. Since `lem:restrict_obj_mathlib` is `\mathlibok` (already satisfied, no dispatch), there is zero out-of-order risk. **wire-up** — add `lem:restrict_obj_mathlib` to the keystone proof block's `\uses{}`. **Soon severity.**

- Isolated nodes: all 8 isolated nodes reported by leandag are `lean_aux` type (uncovered Lean helpers without blueprint entries). None are blueprint-isolated declarations. **keep** — no action.

### Lean difficulty quality

- `Cohomology_CechHigherDirectImage.tex` / `lem:pushforwardPushforwardEquivalence_mathlib`: the blueprint describes the Mathlib lemma as "Let e: C ≃ D be an equivalence of sites... Then e induces an equivalence of categories of sheaves of modules." The actual Mathlib signature requires, beyond the categorical equivalence, explicit ring-sheaf maps `φ` and `ψ` plus two commutative diagram equalities. The blueprint description is a correct high-level summary but understates the API surface. **Informational** — the prover needs to be aware of the full signature when using this anchor in B3.

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:

  **Hard gate check (specific to B1–B4 and the two prover files):**

  **(a) B-block-by-block audit:**

  - **B1 `lem:qcoh_finite_presentation_cover`** (`AlgebraicGeometry.qcoh_finite_presentation_cover`, target file `QcohTildeSections.lean`): Statement is faithful — given quasi-coherent F on Spec R, produces a finite family g_j spanning R with each D(g_j) ⊆ U_{φ(j)} carrying a presentation of F.over U_{φ(j)}. `\lean{}` pin present (unmatched, i.e. to-build, as expected). Proof: quasi-coherence datum supplies the cover, `exists_finite_basicOpen_subcover` refines it — clear finite-effort path. `\uses{lem:exists_finite_basicOpen_subcover, lem:quasicoherentData_mathlib}` — both exist and are correct anchors (the latter verified: `SheafOfModules.QuasicoherentData` exists in Mathlib with the stated datum structure). **PASS.**

  - **B2 `lem:presentation_over_basicOpen`** (`AlgebraicGeometry.presentationOverBasicOpen`, target file `QcohRestrictBasicOpen.lean`): Statement is faithful — given M.over U with a presentation and D(g) ⊆ U, the over-restriction M.over D(g) admits a presentation. `\lean{}` pin present (unmatched, to-build). Proof: further over-restriction from U to D(g) is a left adjoint (preserves colimits), carries unit object to unit object; apply `Presentation.map`. The actual Mathlib API requires an explicit `F.obj (SheafOfModules.unit R) ≅ SheafOfModules.unit S` proof, which is standard for over-restriction but not spelled out — minor underspecification, finite-effort. `\uses{lem:presentation_map_mathlib}` — verified to exist with the correct signature. **PASS.**

  - **B3 `lem:restrict_over_compat`** (`AlgebraicGeometry.overBasicOpenIsoRestrict`, target file `QcohRestrictBasicOpen.lean`): Statement is faithful — F.over D(g) ≅ F_{(g)} = modulesRestrictBasicOpen g F as sheaves of modules over the identification D(g) ≅ Spec R_g. `\lean{}` pin present (unmatched, to-build). Proof route is mathematically correct: the site equivalence `(Opens Spec R).over D(g) ≃ Opens(Spec R_g)` exists (standard open-subscheme identification), `pushforwardPushforwardEquivalence` with this equivalence produces the module-category equivalence, and `restrict_obj` gives the section-level definitional equality. The proof sketch does not specify how to construct φ, ψ, and the compatibility conditions — see "Proofs lacking detail" above. Statement correct; proof sketch thin but route is valid. `\uses{lem:modules_restrict_basicOpen, lem:pushforwardPushforwardEquivalence_mathlib, lem:restrict_obj_mathlib}` — all three verified to exist with faithful statements. **PASS** (with soon-severity proof-sketch note).

  - **B4 `lem:presentation_modulesRestrictBasicOpen`** (`AlgebraicGeometry.presentationModulesRestrictBasicOpen`, target file `QcohRestrictBasicOpen.lean`): Statement is faithful — given U carrying a presentation of F.over U and D(g) ⊆ U, the affine restriction F_{(g)} admits a global presentation. `\lean{}` pin present (unmatched, to-build). Proof: B2 → presentation of F.over D(g); B3 → bridge isomorphism F.over D(g) ≅ F_{(g)}; `Presentation.ofIsIso` transports — clear finite-effort chain. `\uses{lem:presentation_over_basicOpen, lem:restrict_over_compat, lem:presentation_ofIsIso_mathlib, lem:modules_restrict_basicOpen}` — all four accurate (Mathlib anchors verified: `Presentation.ofIsIso` signature `(f: M⟶N)[IsIso f] → M.Presentation → N.Presentation` matches blueprint description exactly). **PASS.**

  **(b) Keystone `\uses{}` and dropping of `lem:cech_acyclic_affine`/`lem:free_isQuasicoherent`:**

  The keystone `lem:qcoh_section_isLocalizedModule` has `\uses{lem:isLocalizedModule_of_span_cover, lem:exists_finite_basicOpen_subcover, lem:qcoh_finite_presentation_cover, lem:presentation_modulesRestrictBasicOpen, lem:section_isLocalizedModule_of_presentation}`. Neither `lem:cech_acyclic_affine` nor `lem:free_isQuasicoherent` appears in the keystone's statement or proof block `\uses{}`. Examining the proof (lines 4172–4211): the proof uses B1 → B4 chain → `section_isLocalizedModule_of_presentation` (which goes through Mathlib's `isIso_fromTildeΓ_of_presentation`) → `isLocalizedModule_of_span_cover`. At no point is Čech acyclicity or free quasi-coherence invoked. The dropping is **correct**.

  Note: the remark `rem:o1i8_decomposition` (lines 4265–4340) has a stale prose description at lines 4300–4306 saying the keystone is proved "using that the section-restriction of free O-modules is the structure-sheaf localization together with the standard-cover Čech acyclicity (Lemma~\ref{lem:cech_acyclic_affine})." This describes the OLD Route-B approach, not the current B1–B4 chain. The remark's `\uses{}` (which includes `lem:cech_acyclic_affine`) is internally consistent with its own (stale) prose, but inconsistent with the actual keystone proof. **Soon severity** — the remark is documentation, not a prover target; no dispatch risk.

  **(c) Three brick block `\lean{}` pins resolve:**

  - `lem:tilde_section_isLocalizedModule` → `AlgebraicGeometry.tilde_section_isLocalizedModule`: **resolves** (not in leandag's `unmatched_lean` list; declaration exists in QcohTildeSections.lean).
  - `lem:section_isLocalizedModule_of_isIso_fromTildeGamma` → `AlgebraicGeometry.section_isLocalizedModule_of_isIso_fromTildeΓ`: **resolves**.
  - `lem:section_isLocalizedModule_of_presentation` → `AlgebraicGeometry.section_isLocalizedModule_of_presentation`: **resolves**.
  All three are axiom-clean per memory (iter-036). The absence of `\leanok` markers is a sync gap (QcohTildeSections.lean not yet imported by root barrel per the iter-035 note on `lem:modules_restrict_basicOpen`).

  **(d) No broken `\uses{}`/`\ref`:**

  leandag reports `"unknown_uses": []` — no broken `\uses{}` cross-references in the blueprint. blueprint-doctor reports `"broken_refs": []`, `"malformed_refs": []` — the rendered blueprint is structurally clean.

  **Six `\mathlibok` anchors (Route B):**
  All six verified via `lean_run_code`:
  - `lem:tilde_toOpen_isLocalizedModule_mathlib` → `AlgebraicGeometry.tilde.toOpen`: exists, `IsLocalizedModule (powers f)` instance. ✓
  - `lem:presentation_map_mathlib` → `SheafOfModules.Presentation.map`: exists, colimit-preserving functor + unit comparison → transports Presentation. ✓
  - `lem:presentation_ofIsIso_mathlib` → `SheafOfModules.Presentation.ofIsIso`: exists, `[IsIso f] → M.Presentation → N.Presentation`. ✓
  - `lem:pushforwardPushforwardEquivalence_mathlib` → `SheafOfModules.pushforwardPushforwardEquivalence`: exists (see Lean difficulty note above on API surface). ✓
  - `lem:quasicoherentData_mathlib` → `SheafOfModules.QuasicoherentData`: exists, `Type`-valued datum structure. ✓
  - `lem:restrict_obj_mathlib` → `AlgebraicGeometry.Scheme.Modules.restrict_obj`: exists, definitional equality `(M.restrict f).presheaf.obj (op U) = M.presheaf.obj (op (opensFunctor f).obj U)` — exactly matches blueprint claim of "definitional equality, not merely isomorphism". ✓

## Severity summary

- **soon**:
  - `Cohomology_CechHigherDirectImage.tex` / `lem:restrict_over_compat` (B3): proof sketch doesn't specify ring-map construction for `pushforwardPushforwardEquivalence`.
  - `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_section_isLocalizedModule`: proof block `\uses{}` missing `lem:restrict_obj_mathlib` (wire-up; `\mathlibok` target, zero dispatch risk).
  - `Cohomology_CechHigherDirectImage.tex` / `rem:o1i8_decomposition`: prose description of keystone proof in item 1 is stale (describes old Čech-acyclicity-based approach, not current B1–B4 chain). Remark is documentation, not a prover target.

- **informational**:
  - `Cohomology_CechHigherDirectImage.tex` / `lem:pushforwardPushforwardEquivalence_mathlib`: blueprint description simplifies the full Mathlib API (ring maps φ, ψ and compatibility conditions are implicit in the description but required by the actual signature).

**HARD GATE for `QcohTildeSections.lean` (B1) and `QcohRestrictBasicOpen.lean` (B2, B3, B4): CLEARS — `Cohomology_CechHigherDirectImage.tex` is `complete: true` and `correct: true` with zero must-fix-this-iter findings.**

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is complete and correct for the B-chain iteration; hard gate clears for both `QcohTildeSections.lean` (B1) and `QcohRestrictBasicOpen.lean` (B2–B4), with one soon-severity proof-sketch note on B3's ring-map construction and one stale remark to clean up next iter. All three phases have adequate blueprint coverage; no unstarted-phase proposals needed.
