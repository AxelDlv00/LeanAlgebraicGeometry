# Lean ↔ Blueprint Check Report

## Slug
quot

## Iteration
028

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration

Only declarations in `QuotScheme.lean` are audited here; the chapter also covers
`GradedHilbertSerre.lean` (header `% archon:covers`) but that file is outside this
directive's scope.

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`)
- **Lean target exists**: yes (line 123)
- **Signature matches**: yes — `S X : Scheme`, `[IsLocallyNoetherian S]`, `(_π : X ⟶ S)`, `[LocallyOfFiniteType _π]`, `(_L _F : X.Modules)`, `(_s : S) : Polynomial ℚ`
- **Proof follows sketch**: N/A — body is `sorry`; blueprint authorizes this ("iter-177+: the body unfolds to … For the iter-176 file-skeleton the body is a typed `sorry`"). `\leanok` marker is present; this is correct for a sorry-carrying skeleton.
- **Notes**: authorized skeleton; no red flag.

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u`; inputs `_π`, `_L`, `_E`, `_Φ` match blueprint
- **Proof follows sketch**: N/A — authorized `sorry` skeleton
- **Notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`)
- **Lean target exists**: yes (line 198)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u`; `_V : S.Modules`, `_d : ℕ`
- **Proof follows sketch**: N/A — authorized `sorry` skeleton
- **Notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`)
- **Lean target exists**: yes (line 225); statement is `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`
- **Signature matches**: yes — matches blueprint "existence of a representing Y : Over S together with a `Functor.RepresentableBy Y` witness"
- **Proof follows sketch**: N/A — authorized `sorry`
- **Notes**: clean.

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (chapter: `def:is_locally_free_of_rank`)
- **Lean target exists**: yes (line 253); `def IsLocallyFreeOfRank {X : Scheme.{u}} (M : X.Modules) (d : ℕ) : Prop`
- **Signature matches**: yes — open cover + isomorphism to free sheaf of rank `d`; matches blueprint prose
- **Proof follows sketch**: N/A — it is a definition
- **Notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (chapter: `def:modules_annihilator`)
- **Lean target exists**: yes (line 298)
- **Signature matches**: yes — `ofIdeals fun U => Module.annihilator Γ(X, U.1) Γ(F, U.1)`; blueprint says "assembles with `IdealSheafData.ofIdeals`"
- **Proof follows sketch**: N/A — noncomputable definition
- **Notes**: the blueprint's `\uses{lem:annihilator_localization_eq_map, lem:qcoh_section_localization_basicOpen}` is fine: the definition itself is axiom-clean; the downstream well-definedness of the full ideal sheaf remains gated on `qcoh_section_localization_basicOpen` (unformalized G1-core), consistently noted in both sources.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` (chapter: `lem:modules_annihilator_ideal_le`)
- **Lean target exists**: yes (line 305); `lemma annihilator_ideal_le`
- **Signature matches**: yes — `(annihilator F).ideal U ≤ Module.annihilator Γ(X, U.1) Γ(F, U.1)`
- **Proof follows sketch**: yes — one-liner `IdealSheafData.ideal_ofIdeals_le`; blueprint says "Proved directly in Lean"
- **Notes**: `\leanok` present; clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (chapter: `def:schematic_support`)
- **Lean target exists**: yes (line 312)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — definition

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` (chapter: `def:schematic_support_immersion`)
- **Lean target exists**: yes (line 320)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — definition

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (chapter: `def:has_proper_support`)
- **Lean target exists**: yes (line 328); `def HasProperSupport {S : Scheme.{u}} (f : X ⟶ S) (F : X.Modules) : Prop := IsProper (schematicSupportι F ≫ f)`
- **Signature matches**: yes
- **Proof follows sketch**: N/A — definition

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (chapter: `lem:annihilator_localization_eq_map`)
- **Lean target exists**: yes (line 362); full theorem with IsLocalization, IsLocalizedModule, Module.Finite hypotheses
- **Signature matches**: yes — `Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)`; matches blueprint
- **Proof follows sketch**: yes — proof by `le_antisymm`, finset-common-denominator argument for `≤`, and `Ideal.map_le_iff_le_comap` for `≥`; matches blueprint's algebraic proof sketch
- **Notes**: `\leanok` confirmed by in-file proof (no sorry). Clean.

### `\lean{AlgebraicGeometry.isLocalizedModule_tilde_restrict}` (chapter: `lem:isLocalizedModule_tilde_restrict`)
- **Lean target exists**: yes (line 467)
- **Signature matches**: yes — restriction map of `tilde N` from `⊤` to `D(f)` is `IsLocalizedModule (Submonoid.powers f)`
- **Proof follows sketch**: yes — uses `tilde.toOpen_res` + `tilde.isoTop` + `IsLocalizedModule.of_linearEquiv_right`; blueprint says "precomposing the localization map with the inverse isomorphism transfers the property"
- **Notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ}` (chapter: `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`)
- **Lean target exists**: yes (line 510)
- **Signature matches**: yes — `[IsIso M.fromTildeΓ]` hypothesis; conclusion is `IsLocalizedModule (powers f)` on the restriction of M
- **Proof follows sketch**: yes — naturality square of ψ + transport via `of_linearEquiv` and `of_linearEquiv_right`; matches blueprint description
- **Notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen}` (chapter: `lem:isIso_sheaf_of_isIso_app_basicOpen`)
- **Lean target exists**: yes (line 554), but declared `private`
- **Signature matches**: yes
- **Proof follows sketch**: yes — basis → stalk injectivity → stalkwise iso → sheaf iso; matches blueprint
- **Notes**: `\leanok`. **Minor issue**: the declaration is `private`, meaning the Lean name is mangled and the blueprint's `\lean{AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen}` will not resolve by `sync_leanok` or external tools. The `\leanok` marker is correct (the proof is sorry-free) but the pin is unresolvable.

### `\lean{AlgebraicGeometry.bijective_comp_of_localizations}` (chapter: `lem:bijective_comp_of_localizations`)
- **Lean target exists**: yes (line 579), but declared `private`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: same `private` issue as above. Minor.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_isLocalizedModule_restrict}` (chapter: `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict`)
- **Lean target exists**: yes (line 614)
- **Signature matches**: yes — hypothesis `∀ f, IsLocalizedModule (powers f)(restriction)`, conclusion `IsIso M.fromTildeΓ`
- **Proof follows sketch**: yes — per-basic-open isomorphism (from `bijective_comp_of_localizations`) → sheaf iso (from `isIso_sheaf_of_isIso_app_basicOpen`) → reflect via `SpecModulesToSheafFullyFaithful`; matches blueprint
- **Notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict}` (chapter: `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`)
- **Lean target exists**: yes (line 653)
- **Signature matches**: yes — biconditional: `IsIso M.fromTildeΓ ↔ ∀ f, IsLocalizedModule (powers f)(restriction)`
- **Proof follows sketch**: yes — two directions wired to the two engines
- **Notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent}` (chapter: `lem:qcoh_affine_section_localization` = G1-core)
- **Lean target exists**: **NO** — declaration does not appear in `QuotScheme.lean` or any project `.lean` file found
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint comment correctly records "the Lean decl does NOT yet exist." This is the acknowledged Mathlib-absent gap; not a red flag per the project workflow.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}` (chapter: `lem:qcoh_affine_isIso_fromTildeΓ` = gap1)
- **Lean target exists**: **NO** — same status
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint comment correctly records "the Lean decl does NOT yet exist." Not a red flag.

---

## Red flags

### Excuse-comments (none)

No "TODO replace with real def", "temporary", "placeholder" or similar comments appear on any formalized declaration. The `-- iter-177+: ...` comments in docstrings are forward-looking notes, not apologies for wrong code.

### Placeholder / suspect bodies

The four skeleton declarations (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`) each have `:= sorry` bodies. All four are explicitly authorized by the blueprint prose ("For the iter-176 file-skeleton the body is a typed `sorry`"). They are expected placeholders, not covert sorries.

### Axiom declarations

None found in the file. No unauthorized `axiom` declarations.

### Private declarations with `\lean{...}` blueprint pins (minor)

- `private theorem isIso_sheaf_of_isIso_app_basicOpen` (line 554): blueprint pins to `AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen`. Lean 4 mangles `private` names; the pin is non-resolvable for automated tooling (`sync_leanok`, `lean_verify`).
- `private theorem bijective_comp_of_localizations` (line 579): same issue.

Both are sorry-free (the `\leanok` status is correct), but the automated sync pipeline cannot verify them by the blueprint's declared name.

---

## Unreferenced declarations (informational)

The following declarations in `QuotScheme.lean` have **no** `\lean{...}` blueprint reference:

### `AlgebraicGeometry.isLocalizedModule_basicOpen_of_presentation` (line 686) — **MAJOR: should be in blueprint**

**What it does:** Given a global `SheafOfModules.Presentation` for `M : (Spec R).Modules`, the restriction to `D(f)` is `IsLocalizedModule (powers f)`. Two-line proof: Mathlib's `isIso_fromTildeΓ_of_presentation` → `isLocalizedModule_restrict_of_isIso_fromTildeΓ`.

**Why it matters:** This is the Route-F endpoint for the globally-presented sub-case of G1-core. It is the only currently closed (axiom-free, non-sorry) case of `lem:qcoh_affine_section_localization` for an explicit tilde-identification. A missing blueprint block means the dependency graph does not include it and the `\leanok` sync cannot verify it.

**Suggested blueprint label:** `lem:isLocalizedModule_basicOpen_of_presentation`

**Suggested blueprint placement:** In the G1-core section (`\S` on G1-assemble or immediately before `lem:qcoh_affine_section_localization`), as a corollary combining `lem:isIso_fromTildeΓ_of_presentation_mathlib` with `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`.

### `AlgebraicGeometry.map_units_restrict_basicOpen` (line 705) — **MAJOR: should be in blueprint**

**What it does:** For an arbitrary `M : (Spec R).Modules` (no quasi-coherence required), every element of `Submonoid.powers f` acts invertibly on `Γ(M, D(f))`. Uses `tilde.isUnit_algebraMap_end_basicOpen`.

**Why it matters:** This is the `map_units` field of G1-core lifted out unconditionally. It demonstrates that map_units holds for ALL module sheaves on `Spec R`, not just quasi-coherent ones — which means map_units is not part of the genuine gap. The residual gap in G1-core is only the `surj` / `exists_of_eq` fields (or equivalently, `IsIso M.fromTildeΓ`). Having this declared and axiom-clean narrows the scope of the open problem.

**Suggested blueprint label:** `lem:map_units_restrict_basicOpen`

**Suggested placement:** Near `lem:isLocalizedModule_constructor_mathlib` or as a preliminary before the G1-core proof sketch.

---

## Blueprint adequacy for this file

### Coverage
17 declarations in `QuotScheme.lean` have corresponding `\lean{...}` blocks (including the 4 authorized sorry-skeletons and 2 private declarations). 2 substantive declarations added in iter-028 (`isLocalizedModule_basicOpen_of_presentation`, `map_units_restrict_basicOpen`) have no blueprint block.

- Declarations with `\lean{...}`: 17 / 19 non-helper declarations (89%)
- Unreferenced declarations: 2 substantive (flagged above)

### Proof-sketch depth: **under-specified for G1-core**

The blueprint proof sketch of `lem:qcoh_affine_section_localization` (G1-core, lines 2705–2754) describes a **direct 3-field construction** via compact-open induction: map_units from `lem:isUnit_res_basicOpen_mathlib`, surj and exists_of_eq by inducting over `D(f)` with the affine tilde localization at the base case.

**This sketch is now over-stated.** The Lean file's infrastructure shows a different and simpler reduction:

1. `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` establishes that **G1-core ↔ gap1**: proving `IsLocalizedModule(powers f)` for all `f` on a quasi-coherent `M` is **equivalent** to proving `IsIso M.fromTildeΓ` for quasi-coherent `M`.
2. `isLocalizedModule_restrict_of_isIso_fromTildeΓ` shows that once `IsIso M.fromTildeΓ` is known, **all three fields** of `IsLocalizedModule` (including surj and exists_of_eq) are delivered at once — no separate compact-open induction per field is needed.
3. `map_units_restrict_basicOpen` shows that map_units holds for **any** `M`, requiring no quasi-coherence hypothesis at all — so it contributes nothing to the gap.

**Consequence:** The actual irreducible gap is ONE declaration: `isIso_fromTildeΓ_of_isQuasicoherent`. The chapter's Route-F proof sketch (3-field + compact-open induction) is a valid alternative route but does not reflect the path the Lean infrastructure has laid out. A prover following the blueprint sketch would implement something different from what the Lean file expects.

Affected blueprint items:
- `lem:qcoh_affine_section_localization` proof: should be updated to say "equivalent to `lem:qcoh_affine_isIso_fromTildeΓ`; once that holds, apply `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`"
- The `surj` and `exists_of_eq` paragraphs (lines 2739–2752) overstate the remaining obligation; they can be replaced by a reference to `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`
- `lem:qcoh_affine_isIso_fromTildeΓ` (gap1) should be elevated as the primary gap, not a downstream consequence of G1-core

### `\mathlibok` anchor consistency: **partial mismatch**

| Blueprint anchor | Blueprint `\lean{...}` | Lean actual usage |
|---|---|---|
| `lem:isIso_fromTildeΓ_of_presentation_mathlib` | `AlgebraicGeometry.isIso_fromTildeΓ_of_presentation` | Used correctly at line 691 of `isLocalizedModule_basicOpen_of_presentation` ✓ |
| `lem:isUnit_res_basicOpen_mathlib` | `AlgebraicGeometry.RingedSpace.isUnit_res_basicOpen` | **NOT used** in the Lean file. `map_units_restrict_basicOpen` uses `tilde.isUnit_algebraMap_end_basicOpen` instead ✗ |
| `lem:isLocalizedModule_constructor_mathlib` | `IsLocalizedModule` | Used in blueprint prose description; the 3-field constructor is implicit in `isLocalizedModule_restrict_of_isIso_fromTildeΓ` ✓ |

**Specific issue:** `tilde.isUnit_algebraMap_end_basicOpen` (Mathlib) is used by `map_units_restrict_basicOpen` (Lean line 710) but has no `\mathlibok` anchor in the blueprint. The blueprint's corresponding anchor `lem:isUnit_res_basicOpen_mathlib` (`RingedSpace.isUnit_res_basicOpen`) is a different API that is not used in the Lean file. Both establish that `f` is a unit on `D(f)`, but via different routes (one via the ringed-space structure sheaf restriction, the other via the tilde-module End-algebra action). The chapter should add a `\mathlibok` block for `AlgebraicGeometry.tilde.isUnit_algebraMap_end_basicOpen` and update the G1-core proof notes to reflect which Mathlib lemma the Lean actually uses.

### Generality: matches need

No narrowness or overgeneralization issues found. The type signatures in the Lean file match what the chapter describes.

### Recommended chapter-side actions

1. **Add blueprint block for `isLocalizedModule_basicOpen_of_presentation`** — label `lem:isLocalizedModule_basicOpen_of_presentation`, `\leanok`, `\uses{lem:isIso_fromTildeΓ_of_presentation_mathlib, lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ}`. This makes the presented sub-case traceable and closes the dependency edge from the Mathlib anchor to the in-file helper.

2. **Add blueprint block for `map_units_restrict_basicOpen`** — label `lem:map_units_restrict_basicOpen`, `\leanok`, `\uses{}` (or a new `\mathlibok` block for `tilde.isUnit_algebraMap_end_basicOpen`). Note that it holds for any `M`, unconditionally.

3. **Add `\mathlibok` block for `AlgebraicGeometry.tilde.isUnit_algebraMap_end_basicOpen`** — to replace the blueprint's use of `lem:isUnit_res_basicOpen_mathlib` in the G1-core map_units paragraph.

4. **Update the G1-core proof sketch** (`lem:qcoh_affine_section_localization`, lines 2705–2754): replace the 3-field Route-F compact-open induction with the Lean-derived reduction: "equivalent to gap1 (`lem:qcoh_affine_isIso_fromTildeΓ`) via `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`; once `IsIso M.fromTildeΓ` holds, all three fields are delivered by `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`." The surj and exists_of_eq paragraphs via compact-open induction are no longer the planned proof path.

5. **Consider elevating gap1** (`lem:qcoh_affine_isIso_fromTildeΓ`) as the primary stated gap rather than a corollary of G1-core, since `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` makes them equivalent.

6. **Expose `isIso_sheaf_of_isIso_app_basicOpen` and `bijective_comp_of_localizations`** — remove `private` modifier (or ensure the blueprint's `\lean{...}` pins match the mangled names) so that `sync_leanok` can verify these against the blueprint.

---

## Severity summary

| Finding | Severity |
|---|---|
| `isLocalizedModule_basicOpen_of_presentation` (iter-028 helper) has no blueprint block; dependency graph cannot trace it | **major** |
| `map_units_restrict_basicOpen` (iter-028 helper) has no blueprint block; unconditional map_units fact not documented | **major** |
| G1-core proof sketch still describes 3-field compact-open induction, over-stating the obligation: Lean infrastructure shows G1-core ↔ gap1 and all 3 fields collapse to `isIso_fromTildeΓ_of_isQuasicoherent` | **major** |
| `tilde.isUnit_algebraMap_end_basicOpen` used in Lean but has no `\mathlibok` anchor; blueprint points to a different API (`RingedSpace.isUnit_res_basicOpen`) | **minor** |
| `isIso_sheaf_of_isIso_app_basicOpen` and `bijective_comp_of_localizations` are `private` but blueprint `\lean{...}` pins use the public form of the name — automated sync cannot resolve | **minor** |
| G1-core and gap1 target declarations absent from Lean file — blueprint correctly documents this; no new finding | (known / not flagged) |
| Authorized sorry-skeleton declarations (4 items) — not red flags | (expected) |

**Overall verdict:** The QuotScheme.lean file is axiom-clean and its formalized declarations are faithful to the blueprint; the two iter-028 helpers are correct and useful, but missing blueprint blocks make them invisible to the dependency graph and leanok sync. The chapter's G1-core proof sketch requires a substantive update to reflect that the Lean architecture has reduced G1-core to a single ingredient (gap1 / `isIso_fromTildeΓ_of_isQuasicoherent`), not a 3-field direct construction. No must-fix-this-iter findings; 3 major adequacy issues require blueprint-side action before the next prover targets G1-core.
