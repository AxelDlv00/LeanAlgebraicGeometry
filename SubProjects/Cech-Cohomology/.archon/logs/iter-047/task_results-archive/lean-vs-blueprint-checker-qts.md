# Lean ↔ Blueprint Check Report

## Slug
qts

## Iteration
046

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` (1214 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (relevant region: lines 4340–4924)

---

## Per-declaration

### `\lean{AlgebraicGeometry.tile_section_localization}` (chapter: `\lem:tile_section_localization`)

- **Lean target exists**: yes — `lemma tile_section_localization` at line 1079 in `AlgebraicGeometry` namespace
- **Signature matches**: yes
  - Blueprint (line 4845–4851): "the section-restriction map `Γ(D(g), F) → Γ(D(gf), F)` exhibits its target as the localisation of its source at the powers of `f`"
  - Lean: `IsLocalizedModule (Submonoid.powers f) ((modulesSpecToSheaf.obj F).presheaf.map (homOfLE (specBasicOpen (g*f) ≤ specBasicOpen g)).op).hom`
  - The Lean statement takes `(P : (F.over U).Presentation)` and `(hg : specBasicOpen g ≤ U)` directly, rather than the blueprint's more narrative description of "cover element or overlap product." This is a correct and sound generalization: the blueprint's formulation describes where the hypothesis arises, not a constraint on it. The mathematical claim — `IsLocalizedModule (powers f)` of the indicated section-restriction map — matches exactly.
- **Proof follows sketch**: yes (with one minor drift — see notes)
  - Step 1: `presentationModulesRestrictBasicOpen F U P g hg` ✓
  - Step 2: `section_isLocalizedModule_of_presentation` on tile + `algebraMap R R_g f` ✓
  - Step 3: `tile_image_opens_identities g f` ✓
  - Step 4 (restriction-of-scalars reconciliation): implemented via `tileReconcileEquiv` at both source and target opens (both using `tile_scalar_compat'`) — the blueprint describes the source open (V=⊤) via `tile_scalar_compat` and the target (V=D(f̄)) via `tile_scalar_compat_genV` as separate steps, but Lean uniformly uses the general-V lemma (`tile_scalar_compat'`) via the `tileReconcileEquiv` bundled equivalence. Mathematically identical.
  - Step 5: `isLocalizedModule_powers_restrictScalars_of_algebraMap` ✓
- **notes**:
  - The `\lean{}` pin at blueprint line 4839 is correct.
  - `\leanok` on statement + proof block reflects iter-046 sync verdict (axiom-clean: `#print axioms` = {propext, Classical.choice, Quot.sound}; blueprint NOTE at line 4824–4826 confirms).
  - The proof `\uses{}` list includes `lem:tile_scalar_compat` (the V=⊤ case), but the Lean proof does NOT call `tile_scalar_compat` directly — it only calls `tile_scalar_compat'` (the general-V case) via `tileReconcileEquiv`. Stale edge; see **Blueprint → Lean** section.
  - The statement-block `\uses{}` includes `lem:qcoh_finite_presentation_cover`; the Lean statement takes a presentation directly and never invokes qcoh_finite_presentation_cover. Misleading edge; see **Blueprint → Lean** section.

---

### Supporting decls `\lean{}`-tagged in the blueprint (spot-checked)

The following declarations have existing blueprint blocks and were used in `tile_section_localization`'s proof; their statements were confirmed against the blueprint:

| Declaration | Blueprint ref | Match |
|---|---|---|
| `isLocalizedModule_powers_restrictScalars_of_algebraMap` | `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap` (line 4349) | yes — converse of `of_restrictScalars`; all three `IsLocalizedModule` clauses; matches Lean signature |
| `tile_image_opens_identities` | `lem:tile_image_opens_identities` (line 4377) | yes — Lean returns a conjunction `And (ι ''ᵁ (iso.inv ''ᵁ ⊤) = D(g)) (ι ''ᵁ (iso.inv ''ᵁ D(f̄)) = D(gf))`; blueprint states both equalities; `\lean{}` pin correct |
| `modulesSpecToSheaf_smul_eq` | `lem:modulesSpecToSheaf_smul_eq` (line 4410) | yes — rfl identity; signature matches |
| `modulesRestrictBasicOpen_smul_eq` | `lem:modulesRestrictBasicOpen_smul_eq` (line 4438) | yes — rfl identity for V=⊤; signature matches |
| `modulesRestrictBasicOpen_smul_eq'` | `lem:modulesRestrictBasicOpen_smul_eq_genV` (line 4473) | yes — general V version; signature matches |
| `tile_scalar_compat` | `lem:tile_scalar_compat` (line 4653) | yes — `r • x = (algebraMap R R_g r) • x` at V=⊤; matches |
| `tile_scalar_compat'` | `lem:tile_scalar_compat_genV` (line 4690) | yes — general V version; `\lean{}` pin is `AlgebraicGeometry.tile_scalar_compat'`; matches |
| `section_isLocalizedModule_of_presentation` | `lem:section_isLocalizedModule_of_presentation` (line 4072) | yes — matches |

---

## Red flags

### Placeholder / suspect bodies
None. No `sorry`, no `:= True`, no `:= Classical.choice _`. All proofs are closed.

### Excuse-comments
None in Lean code. The `% NOTE:` annotations at blueprint lines 4824–4833 are review-phase annotations written by the review agent using the correct marker vocabulary, not excuse-comments in Lean.

### Axioms / Classical.choice on substantive claims
None. Only standard axioms (propext, Classical.choice, Quot.sound) as confirmed by the iter-046 NOTE at blueprint line 4825–4826.

---

## Unreferenced declarations (informational)

The following **public** declarations in the Lean file have no `\lean{}` reference in any blueprint block:

### `isScalarTower_restrictScalars_obj` (line 1008) — **major** coverage debt
```lean
instance isScalarTower_restrictScalars_obj {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (M : ModuleCat.{u} S) :
    IsScalarTower R S ((ModuleCat.restrictScalars (algebraMap R S)).obj M)
```
This is a public `instance` used as a structural prerequisite in `tile_section_localization` (needed so `isLocalizedModule_powers_restrictScalars_of_algebraMap` can find its `IsScalarTower` argument on the bundled `restrictScalars` carrier without hoisting a noncomputable auxiliary def). The blueprint NOTE at line 4830 acknowledges it as "coverage debt." The instance is non-obvious (it requires `IsScalarTower.of_algebraMap_smul` applied to the restricted-scalars smul definition), so it warrants a `\lean{}` block.

### `tileReconcileEquiv` (line 1024) — **major** coverage debt
```lean
noncomputable def tileReconcileEquiv (F : (Spec R).Modules) (g : R)
    (V : (Spec (CommRingCat.of (Localization.Away g))).Opens) :
    (ModuleCat.restrictScalars (algebraMap R (Localization.Away g))).obj
        ((modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj (Opposite.op V))
      ≃ₗ[R]
      (modulesSpecToSheaf.obj F).presheaf.obj (Opposite.op
        ((specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ V)))
```
This is the key structural component of Step 4 in the blueprint proof: the `R`-linear equivalence between the tile's `R`-module (obtained by restriction of scalars from `R_g`) and `F`'s section module over the image open, identity on elements with `R`-linearity given by `tile_scalar_compat'`. It is a public `noncomputable def` central to the proof route. The blueprint's Step 4 description mentions the restriction-of-scalars reconciliation but does not give this construct a name or a dedicated block. Blueprint NOTE at line 4831 acknowledges as "coverage debt."

### Private helpers (no coverage needed)
- `tileReconcileEquiv_apply` (line 1038): `@[simp] private` — correct to omit from blueprint.
- `tileReconcileEquiv_symm_apply` (line 1044): `@[simp] private` — correct to omit.
- `tile_restrict_map_apply` (line 1056): `private` — correct to omit; blueprint NOTE mentions it for completeness.

---

## Blueprint adequacy for this file

- **Coverage**: Of the ~15 substantive public declarations in this file, 13 have `\lean{}` blocks in the chapter. The 2 unreferenced public declarations (`tileReconcileEquiv`, `isScalarTower_restrictScalars_obj`) are the coverage debt items acknowledged in the blueprint NOTE.
- **Proof-sketch depth**: **under-specified** for Step 4. The blueprint describes "restriction of scalars along `R → R_g`" as the reconciliation mechanism at a conceptual level, but does not describe the `ModuleCat.restrictScalars`-carrier routing that was required in Lean to avoid the W1/W2 walls (noncomputable hoist and missing SMul instance). The Lean proof needed the `tileReconcileEquiv` bundled equivalence and the `isScalarTower_restrictScalars_obj` Prop instance — neither appears in the blueprint's Step 4 description. This was the root cause of the iter-045 failure. The blueprint NOTE at line 4829–4833 retrospectively documents the solution but the main proof text was not updated.
- **Hint precision**: **loose** for Step 4. The blueprint says "restriction of scalars" without specifying whether to use a bundled `≃ₗ[R]` equivalence or an inline `haveI`-style construction. The Lean ended up needing the bundled form (`tileReconcileEquiv`).
- **Generality**: **matches need** — the blueprint describes the more general form (any presentation, any U, any g with `D(g) ≤ U`), which the Lean statement correctly realizes.

### `\uses{}` inaccuracy (statement block, line 4840–4844)
The statement-block `\uses{}` for `lem:tile_section_localization` includes `lem:qcoh_finite_presentation_cover`. The Lean **statement** takes a presentation `P` directly (no quasi-coherence hypothesis, no invocation of `qcoh_finite_presentation_cover`). This edge belongs on `lem:qcoh_section_isLocalizedModule` (which calls `tile_section_localization` within a context built by `qcoh_finite_presentation_cover`), not on `tile_section_localization` itself.

### `\uses{}` inaccuracy (proof block, line 4854–4857)
The proof-block `\uses{}` for `lem:tile_section_localization` includes `lem:tile_scalar_compat` (the V=⊤ case). The Lean proof does NOT call `tile_scalar_compat` — it calls `tile_scalar_compat'` (the general-V case) exclusively, via `tileReconcileEquiv`. The `lem:tile_scalar_compat` edge is stale.

The `lem:restrict_obj_mathlib` edge in the proof `\uses{}` is now very indirect (the rfl identity is called via `tile_restrict_map_apply`); while not strictly wrong, it could be replaced with `lem:tile_restrict_map_apply` once that gets a blueprint block.

### Recommended chapter-side actions
- **Add a `\begin{lemma}` block for `tileReconcileEquiv`** with `\lean{AlgebraicGeometry.tileReconcileEquiv}`: describe it as "the `R`-linear equivalence between tile sections (viewed over `R` by restriction of scalars along `R → R_g`) and `F`-sections over the image open, with identity underlying map and `R`-linearity given by `tile_scalar_compat'`." Mark statement `\leanok` post-sync. This closes the major coverage debt.
- **Add a `\begin{lemma}` block for `isScalarTower_restrictScalars_obj`** with `\lean{AlgebraicGeometry.isScalarTower_restrictScalars_obj}`: describe it as "scalar-tower instance for the bundled `(ModuleCat.restrictScalars (algebraMap R S)).obj M` object." This closes the minor coverage debt.
- **Remove `lem:qcoh_finite_presentation_cover` from the statement-block `\uses{}` of `lem:tile_section_localization`**.
- **Remove `lem:tile_scalar_compat` from the proof-block `\uses{}` of `lem:tile_section_localization`** (replace with `lem:tile_scalar_compat_genV` as the only scalar-compat dependency the proof actually uses).
- **Expand the Step 4 prose** in the `lem:tile_section_localization` proof to name `tileReconcileEquiv` explicitly: note that the restriction-of-scalars reconciliation is packaged as a bundled `≃ₗ[R]` equivalence (not an inline `haveI` or a carrier-level `rfl`) to ensure the scalar-tower instance is found structurally on the `ModuleCat.restrictScalars` object.

---

## Severity summary

| Finding | Severity |
|---|---|
| `tileReconcileEquiv` (public def, no blueprint block) | **major** |
| `isScalarTower_restrictScalars_obj` (public instance, no blueprint block) | **major** |
| `\uses{}` edge `lem:qcoh_finite_presentation_cover` on statement block — stale | **minor** |
| `\uses{}` edge `lem:tile_scalar_compat` on proof block — stale (Lean uses `tile_scalar_compat'` only) | **minor** |
| Blueprint Step 4 prose under-specified (doesn't mention bundled `tileReconcileEquiv` recipe) | **minor** (retrospectively: the NOTE at 4829–4833 documents the solution; no proof correction needed) |

No must-fix-this-iter findings: no sorries, no fake statements, no wrong signatures, no excuse-comments in Lean.

**Overall verdict**: `tile_section_localization` is axiom-clean and its Lean statement matches the blueprint claim precisely; the `\lean{}` pin is correct. Two public scaffolding declarations (`tileReconcileEquiv`, `isScalarTower_restrictScalars_obj`) are missing blueprint coverage (major), and two `\uses{}` edges in the `tile_section_localization` blocks are stale (minor). No must-fix-this-iter gate triggers.
