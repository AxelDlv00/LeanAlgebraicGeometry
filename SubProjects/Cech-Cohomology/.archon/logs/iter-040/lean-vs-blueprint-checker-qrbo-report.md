# Lean ↔ Blueprint Check Report

## Slug
qrbo

## Iteration
040

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.overBasicOpenIsoRestrict}` (chapter: `lem:restrict_over_compat`)

- **Lean target exists**: yes
- **Signature matches**: **partial / no** — see notes
- **Proof follows sketch**: yes (B3a/b/c structure followed faithfully)
- **notes**:
  - Blueprint prose (lines 4181–4188) claims the iso is between
    `F.over D(g)` (type: `SheafOfModules((Spec R).ringCatSheaf.over D(g))`) and
    `modulesRestrictBasicOpen g F` (type: `(Spec R_g).Modules`).
    These live in **different categories**; the prose implies the *full* B3c bridge assembling
    both the engine inverse and the affine identification transport along `basicOpenIsoSpecAway g`.
  - The Lean declaration instead gives an iso in `D(g).toScheme.Modules`:
    `(modulesOverBasicOpenEquivalence g).inverse.obj (M.over (specBasicOpen g)) ≅ M.restrict (specBasicOpen g).ι`
    This is the **B3b intermediate iso** (engine inverse maps over-restriction to subscheme restriction),
    not the full B3c iso of the blueprint. The affine identification transport (`basicOpenIsoSpecAway`)
    is handled in `presentationModulesRestrictBasicOpen`, not here.
  - Mathematically the Lean statement is sound and it is what B4 actually consumes. However it
    disagrees with what the `lem:restrict_over_compat` prose says it formalizes.
  - `\leanok` is present on both the statement block (line 4169) and the proof block (line 4194). ✓
  - Blueprint proof sketch (B3a/b/c) is detailed and corresponds to the actual proof steps. ✓
  - No `sorry`, no placeholder body. ✓

### `\lean{AlgebraicGeometry.presentationModulesRestrictBasicOpen}` (chapter: `lem:presentation_modulesRestrictBasicOpen`)

- **Lean target exists**: yes
- **Signature matches**: yes, exactly
- **Proof follows sketch**: yes
- **notes**:
  - Blueprint statement: "M : (Spec R).Modules, U an open, P a presentation of M.over U,
    g : R, D(g) ⊆ U → (modulesRestrictBasicOpen g M).Presentation". Lean signature matches verbatim.
  - Proof follows the three-step blueprint sketch: B2 (`presentationOverBasicOpen`) → bridge iso
    (`overBasicOpenIsoRestrict`) + `Presentation.ofIsIso` → affine restriction transport
    (`restrictFunctor (basicOpenIsoSpecAway g).inv` with `restrictBasicOpenUnitIso`).
  - The proof block `\uses{}` (lines 4262–4263) omits `def:modules_over_basicOpen_equivalence`;
    the engine equivalence (`modulesOverBasicOpenEquivalence g`) is used internally at `P3`.
    It is covered transitively via `lem:restrict_over_compat → def:modules_over_basicOpen_equivalence`
    but the direct dependency is undeclared.
  - `\leanok` present on statement (line 4248) and proof (line 4264). ✓
  - No `sorry`, no placeholder body. ✓

### `\lean{AlgebraicGeometry.modulesOverBasicOpenEquivalence,...}` (chapter: `def:modules_over_basicOpen_equivalence`)

- **Lean target exists**: yes
- **Signature matches**: yes (engine prior iter, not new this iter)
- **Proof follows sketch**: yes
- **notes**: Previously verified; no new issues this iter. The six helper names pinned in
  the `\lean{}` list all exist in the file. ✓

---

## Red flags

### Placeholder / suspect bodies
None. No `:= sorry`, no `:= True`, no `axiom` declarations, no `Classical.choice _` on substantive claims.

### Excuse-comments
One `## TODO` in the module-level docstring comment (line 29 of Lean file): "as recorded in its source `## TODO`, does not yet prove that the two functors are continuous". This is a factual comment documenting a known upstream Mathlib gap that the file is working around — it is not an excuse for wrong code in this file. Not a red flag.

### Axioms / Classical.choice
None.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint:

| Declaration | Kind | Notes |
|---|---|---|
| `Opens.overEquivalence_functor_coverPreserving` | `theorem` | Mathlib supplement; subsumed by `lem:overEquivalence_isContinuous` |
| `Opens.overEquivalence_inverse_coverPreserving` | `theorem` | Same as above |
| `Opens.overEquivalence_functor_isContinuous` | `instance` | Continuity instance; subsumed by `lem:overEquivalence_isContinuous` |
| `Opens.overEquivalence_inverse_isContinuous` | `instance` | Same |
| `specBasicOpen` | `abbrev` | Pinned indirectly as `def:spec_basic_open` in the chapter |
| `specAwayToSpec` | `abbrev` | Helper for `modulesRestrictBasicOpen`; not a blueprint-level decl |
| `modulesRestrictBasicOpen` | `def` | Pinned at `lem:modules_restrict_basicOpen` |
| `modulesRestrictBasicOpenIso` | `def` | Helper; not a blueprint-level decl |
| `specAwayToSpec_eq` | `theorem` | Helper; not a blueprint-level decl |
| `presentationOverBasicOpen` | `def` | Pinned at `lem:presentation_over_basicOpen` ✓ |
| `specBasicOpen_ι_image_overEquivalence_functor` | `private lemma` | Private; pinned in `def:modules_over_basicOpen_equivalence` |
| `overEquivalence_functor_isContinuous_toScheme` | `instance` | Helper adaptor; not blueprint-level |
| `overEquivalence_inverse_isContinuous_toScheme` | `instance` | Helper adaptor; not blueprint-level |
| `overForgetIso` | `def` | Pinned in `def:modules_over_basicOpen_equivalence` ✓ |
| `overBasicOpenRingHom` | `def` | Pinned in `def:modules_over_basicOpen_equivalence` ✓ |
| `overForgetInvIso` | `def` | Pinned in `def:modules_over_basicOpen_equivalence` ✓ |
| `overBasicOpenRingInvHom` | `def` | Pinned in `def:modules_over_basicOpen_equivalence` ✓ |
| `modulesOverBasicOpenEquivalence` | `def` | Pinned in `def:modules_over_basicOpen_equivalence` ✓ |
| `overBasicOpenIsoRestrict` | `def` | Pinned at `lem:restrict_over_compat` ✓ |
| **`pullbackObjUnitToUnit_isIso_basicOpen`** | `instance` | **DAG-unmatched** — helper for `presentationModulesRestrictBasicOpen`; not in any `\lean{}` or `\uses{}` |
| **`restrictBasicOpenUnitIso`** | `noncomputable def` | **DAG-unmatched** — substantive unit-iso helper for B4; not in any `\lean{}` or `\uses{}` |
| `presentationModulesRestrictBasicOpen` | `def` | Pinned at `lem:presentation_modulesRestrictBasicOpen` ✓ |

The two bolded entries (`pullbackObjUnitToUnit_isIso_basicOpen`, `restrictBasicOpenUnitIso`) are the DAG-unmatched declarations flagged in the directive. See Blueprint adequacy section below.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 primary blueprint-pinned declarations have corresponding `\lean{...}` blocks;
  `presentationModulesRestrictBasicOpen` and `overBasicOpenIsoRestrict` are the new declarations
  this iter, both pinned. 2 helper declarations (`restrictBasicOpenUnitIso`,
  `pullbackObjUnitToUnit_isIso_basicOpen`) are DAG-unmatched.

- **Proof-sketch depth**: **adequate** for B4 (`presentationModulesRestrictBasicOpen`).
  The B3 proof sketch (B3a/b/c) is detailed and matches the Lean proof structure well.
  The B4 sketch correctly identifies B2 + bridge iso + `presentation_ofIsIso` as the chain.

- **Hint precision**: **loose on B3** — the `\lean{}` pin for `lem:restrict_over_compat`
  names `AlgebraicGeometry.overBasicOpenIsoRestrict`, but the prose describes an iso
  `F.over D(g) ≅ modulesRestrictBasicOpen g F` that is *not* what the Lean declaration
  actually states. The Lean states the B3b intermediate iso (engine inverse applied, landing
  in `D(g).toScheme.Modules`, RHS is `F.restrict ι`). The blueprint should align the prose
  with the actual Lean signature, or promote the full B3c composition (the `overBasicOpenIsoRestrict
  + restrictFunctor` composite) to a named declaration that matches the prose.

- **Generality**: matches need — no parallel API, no missing generality.

- **Stale `% NOTE:` comment**: lines 4175–4180 say "NOT YET built" for `overBasicOpenIsoRestrict`
  and describe a recipe; this is now stale since `\leanok` is present on the block. Should be pruned.

- **Recommended chapter-side actions**:
  1. **Update `lem:restrict_over_compat` prose** to accurately describe the Lean statement:
     the iso is `(engine.inverse).obj (F.over D(g)) ≅ F.restrict ι` in `D(g).toScheme.Modules`,
     not the full B3c iso `F.over D(g) ≅ modulesRestrictBasicOpen g F`. Either:
     (a) revise the prose to match, or (b) introduce a named declaration for the composite
     (engine inverse + affine-identification transport) that does match the prose.
  2. **Prune stale `% NOTE:`** at lines 4175–4180 (now superseded by `\leanok`).
  3. **Fold `restrictBasicOpenUnitIso` into the `\lean{}` list** for
     `lem:presentation_modulesRestrictBasicOpen` (or add a `\uses{}` pointer), so the DAG
     covers this substantive helper.
  4. **Add `def:modules_over_basicOpen_equivalence` to `\uses{}`** for the proof block of
     `lem:presentation_modulesRestrictBasicOpen` (lines 4262–4263), since
     `modulesOverBasicOpenEquivalence g` is used directly at `P3`.

---

## Severity summary

| Finding | Target | Severity |
|---|---|---|
| `overBasicOpenIsoRestrict` Lean signature describes B3b intermediate iso, not the B3c iso that the blueprint prose claims | `lem:restrict_over_compat` prose | **major** |
| Blueprint prose says the iso is `F.over D(g) ≅ modulesRestrictBasicOpen g F`; actual Lean type is `(engine.inverse.obj F.over D(g)) ≅ F.restrict ι` | `lem:restrict_over_compat` `\lean{}` hint | **major** |
| Stale `% NOTE:` saying "NOT YET built" for a now-`\leanok` declaration | lines 4175–4180 | **minor** |
| `restrictBasicOpenUnitIso` is DAG-unmatched (no `\lean{}` or `\uses{}` reference) | blueprint B4 block | **minor** |
| `pullbackObjUnitToUnit_isIso_basicOpen` is DAG-unmatched | blueprint B4 block | **minor** |
| `def:modules_over_basicOpen_equivalence` missing from `\uses{}` in B4 proof block | `lem:presentation_modulesRestrictBasicOpen` proof `\uses{}` | **minor** |

**Overall verdict**: `presentationModulesRestrictBasicOpen` (B4) is clean and correct; the main issue is a blueprint prose/signature mismatch on `lem:restrict_over_compat` — the declared Lean iso is the B3b intermediate (well-typed and sound), but the blueprint prose describes the full B3c composite, creating a misleading `\lean{}` pin. Two substantive helper declarations are DAG-unmatched. No `sorry`, no axioms, no placeholder bodies.
