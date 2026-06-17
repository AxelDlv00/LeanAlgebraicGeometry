# Lean ↔ Blueprint Check Report

## Slug
lvb-di262

## Iteration
262

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` (chapter: `lem:slice_dual_transport`, L5675)
- **Lean target exists**: yes
- **Signature matches**: yes — the declaration provides the O_Y(V)-linear `ModuleIso` between the two pushforward-dual values, exactly as the blueprint's lemma states
- **Proof follows sketch**: partial — 6 typed sorries remain (naturality, map_add', map_smul', invFun, left_inv, right_inv). Blueprint `\leanok` appears on the statement block only (correct: "at least a sorry present" semantics). The `codomainMap` hole is now filled inline by `dualUnitRingSwap` (iter-262 work).
- **notes**: The `refine LinearEquiv.toModuleIso ?_` skeleton with leg-A categorical `.map` built and `dualUnitRingSwap` supplying `codomainMap` is coherent with the blueprint's leg-(A)∘(B) description. Sorries on the packaging fields are the remaining open work.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`, L5755)
- **Lean target exists**: yes
- **Signature matches**: yes — `(dual M).restrict f ≅ dual (M.restrict f)` exactly
- **Proof follows sketch**: partial — 1 sorry at line 487 (the `PresheafOfModules.isoMk` naturality square, blocked on `sliceDualTransport`'s body not yet being concrete). All other steps (Steps 1–3, H1 rewrite) compile. Blueprint `\leanok` on statement block only (consistent).
- **notes**: Clean except the assembly residual, which unblocks automatically once `sliceDualTransport` closes.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `lem:dual_unit_iso`, L5940)
- **Lean target exists**: yes
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`
- **Proof follows sketch**: yes — builds via `presheafDualUnitIso` (evaluation-at-1, blueprint description) composed with the sheafification counit. Axiom-clean.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`, L5975)
- **Lean target exists**: yes
- **Signature matches**: yes — `LineBundle.IsLocallyTrivial L → LineBundle.IsLocallyTrivial (dual L)`
- **Proof follows sketch**: yes — three-step chain `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` matches the blueprint's enumerated steps exactly. Axiom-clean modulo inherited sorry from `dual_restrict_iso`.
- **notes**: Clean assembly; the `(dualIsoOfIso eL).symm` direction correctly implements the blueprint's step 2 (contravariance of dual).

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `lem:scheme_modules_hom_local_section`, L6098)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — `eqToHom`-conjugation + `Subsingleton.elim` naturality matches blueprint description. Axiom-clean.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`, L6152)
- **Lean target exists**: yes
- **Signature matches**: yes — sectionwise `hf` form (iter-254 re-sign). Blueprint's `lem:sheafofmodules_hom_of_local_compat` describes the overlap-agreement hypothesis as sectionwise, which the Lean signature implements.
- **Proof follows sketch**: yes — axiom-clean (closed iter-256).
- **notes**: Clean.

### `\lean{PresheafOfModules.dualUnitIsoGen}` (in-prose tag at L5735)
- **Lean target exists**: yes (line 124 of the Lean file)
- **Signature matches**: yes — `PresheafOfModules.dual 𝟙_ ≅ 𝟙_` at the presheaf level, matches the blueprint's in-prose description ("dual-of-unit isomorphism `dualUnitIsoGen`")
- **Proof follows sketch**: yes — sectionwise from `unitDualSectionEquiv` (evaluation-at-1), matching blueprint description. Axiom-clean.
- **notes**: The `\lean{}` tag is inline in the proof prose of `lem:slice_dual_transport` rather than in a formal `\begin{lemma}...\lean{...}` block. The tag pinning is adequate though architecturally weak.

---

## Red flags

### Placeholder / suspect bodies
No pure `:= sorry` declarations. All sorries are typed holes in a `refine`/`exact` skeleton. No weakened-wrong definitions.

### Axioms / Classical.choice
None introduced this iteration. `isIso_ε_restrictScalars_appIso` and `dualUnitRingSwap` are axiom-clean (they reduce to `restrictScalars_isIso_ε_of_bijective` + `ConcreteCategory.bijective_of_isIso`, both Mathlib-backed).

### Excuse-comments
None. The sorry-block comments are accurate progress annotations ("CLOSED iter-262", "REMAINING (typed sorries)", "ROUTE-(1) STRUCTURAL INSUFFICIENCY") — they document the proof state faithfully, not excuse wrong code.

---

## Unreferenced declarations (informational)

These declarations in the Lean file have no `\lean{...}` block in the blueprint chapter:

| Declaration | Nature | Blueprint status |
|---|---|---|
| `PresheafOfModules.unitDualSectionEquiv` | Helper feeding `dualUnitIsoGen`; section-level eval-at-1 equiv | Blueprint prose describes it implicitly (evaluation-at-1 + global-scalar inverse); no `\lean{}` tag. Minor. |
| `Scheme.Modules.isIso_ε_restrictScalars_appIso` | **NEW iter-262.** Lemma: `IsIso(ε(restrictScalars (f.appIso W').inv.hom))` | Blueprint describes this in prose at L5731-5733 (`restrictScalars_isIso_ε_of_bijective` applied to the appIso). No `\lean{}` tag. Minor. |
| `Scheme.Modules.dualUnitRingSwap` | **NEW iter-262.** The `codomainMap := inv(ε(restrictScalars g))` morph | Blueprint describes the formula at L5726-5728 exactly but names only the formula, not a standalone decl. No `\lean{}` tag. Minor. |
| `Scheme.Modules.presheafDualUnitIso` | Thin wrapper around `dualUnitIsoGen` specialized to `Y.presheaf` | Pure instantiation; subsumed by `\lean{PresheafOfModules.dualUnitIsoGen}`. Minor. |
| `Scheme.Modules.topSectionToHom` | Helper for `homOfLocalCompat`: converts a top-section of `presheafHom` to a morphism | Blueprint describes the step in prose for `homOfLocalCompat`; no dedicated `\lean{}`. Minor. |
| `Scheme.Modules.topSectionToHom_app` | Sectionwise value lemma for `topSectionToHom` | Helper lemma; no blueprint block needed. Minor. |
| `Scheme.Modules.image_preimage_of_le` | `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V` for `V ≤ W` | Used in `homLocalSection`; mentioned in blueprint proof text. Minor. |

No unreferenced declaration appears to require a dedicated blueprint block; all are either sub-helpers or instantiations of named blueprint decls.

---

## Blueprint adequacy for this file

### (a) Do new Lean decls `isIso_ε_restrictScalars_appIso` and `dualUnitRingSwap` match leg-B?

**Yes — both are faithful implementations of the blueprint's leg-B description.**

The blueprint at L5721-5735 describes leg (B) as:
> "the inverse of the lax-monoidal unit comparison `ε(restrictScalars g)`, `g := (f.appIso W).inv.hom` at the CommRingCat level; `ε` is invertible because `g` is a ring isomorphism (`restrictScalars_isIso_ε_of_bijective`)."

- `isIso_ε_restrictScalars_appIso` is the scheme-level specialization proving `IsIso(ε(restrictScalars (f.appIso W').inv.hom))`, exactly the stated `ε`-invertibility claim. Its body `restrictScalars_isIso_ε_of_bijective _ (ConcreteCategory.bijective_of_isIso _)` matches the blueprint's recipe verbatim.
- `dualUnitRingSwap` is the decl providing `codomainMap := inv(ε(restrictScalars (f.appIso W').inv.hom))` at the `CommRingCat` carrier, matching L5726-5730. The `CommRingCat`-level carrier annotation in the blueprint ("taken at the CommRingCat level") is correctly reflected in the Lean signature.

Neither has an explicit `\lean{...}` tag (they are helpers described in prose), but their mathematical content is a perfect match.

### (b) Does the chapter adequately specify remaining `sliceDualTransport` fields?

**Mixed: most fields are adequately guided at a high level, but the linearity fields (map_add'/map_smul') are under-specified.**

| Field | Blueprint guidance | Assessment |
|---|---|---|
| naturality | "Subsingleton.elim, Opens Y thin poset" (L5744-5745) | Adequate — matches the Lean comment exactly |
| invFun | "mirror with `(f.appIso W').hom` and inverse down-set bijection `image_preimage_of_le`" (L5738-5741) | Adequate at high level — enough to construct |
| left_inv / right_inv | "round-trip identities by iso axioms of `f.appIso` + down-set bijection" (L5741) | Adequate — the Lean comments confirm this route |
| **map_add' / map_smul'** | "post-composition compatibility of the structure scalar, intertwined by the ring iso — the presheaf-level shadow of `restrictScalarsRingIsoDualEquiv`" (L5741-5743) | **UNDER-SPECIFIED** — see below |

**Gap for map_add'/map_smul':** The Lean file (lines 337-346) identifies the actual blocker: the `+` on the LHS of `map_add'` is the `internalHomObjModule` module add on the dual section object `((pushforward β).obj M.val.dual).obj V`, which is NOT syntactically the `PresheafOfModules.Hom` add. Consequently `Functor.map_add` and `PresheafOfModules.add_app` do not fire on `rw`. A bridge lemma unfolding `internalHomObjModule.add` is required before `Functor.map_add` applies. The blueprint's description — "post-composition compatibility... presheaf-level shadow of `restrictScalarsRingIsoDualEquiv`" — is mathematically correct but gives no hint of this syntactic/instance subtlety. A prover following only the blueprint would hit the same wall with no guidance on the fix.

**Coverage**: 7/14 Lean declarations have a `\lean{...}` reference (counting the inline `dualUnitIsoGen` tag). The remaining 7 are helpers (acceptable).

**Proof-sketch depth**: **under-specified** for map_add'/map_smul' in `lem:slice_dual_transport`; adequate for all other blocks.

**Hint precision**: precise for the `\lean{...}`-tagged declarations. The two new decls (`isIso_ε_restrictScalars_appIso`, `dualUnitRingSwap`) lack `\lean{}` tags but their content is correctly identified in prose.

**Generality**: matches need.

**Recommended chapter-side actions:**
1. Add a note in the `lem:slice_dual_transport` proof (the linearity paragraph, L5741-5743) that `map_add'`/`map_smul'` require an `internalHomObjModule`-add ↦ `PresheafOfModules.Hom`-add bridge lemma: `internalHomObjModule.add` (the `+` on `(pushforward β).obj M.val.dual).obj V`) is not syntactically `PresheafOfModules.add`, so a `change` or `show` unfolding `internalHomObjModule.add` is required before `Functor.map_add` can fire.
2. (Optional) Add inline `\lean{}` tags for `isIso_ε_restrictScalars_appIso` and `dualUnitRingSwap` in the leg-(B) prose, or add a brief `\begin{lemma}` block for each, since they are named in the Lean file and feed `sliceDualTransport` directly.

---

## Severity summary

- **major**: Blueprint proof sketch for `lem:slice_dual_transport` (map_add'/map_smul' paragraph) is too thin — misses the `internalHomObjModule`-add ↦ Hom-add bridge subtlety that is the actual Lean blocker. The blueprint is not *so* under-specified that no formalization is possible (the Lean prover reached and named the obstacle), but it does not guide the fix. A blueprint-writing pass should add the bridge note.
- **minor**: Missing `\lean{}` tags for `isIso_ε_restrictScalars_appIso` and `dualUnitRingSwap` (both are correctly described in blueprint prose but not pinned by name); `dualUnitIsoGen` tag is inline rather than in a formal lemma block.
- No must-fix-this-iter findings.

**Overall verdict**: New Lean decls `isIso_ε_restrictScalars_appIso` and `dualUnitRingSwap` faithfully implement the blueprint's leg-B description; all `\lean{...}`-tagged declarations exist with correct signatures; the chapter is adequate for all `sliceDualTransport` fields except map_add'/map_smul', where a blueprint note about the `internalHomObjModule`-add bridge is missing — 7 declarations checked (tagged), 2 new helper decls (untagged but content-correct), 0 must-fix, 1 major adequacy gap, 2 minor tag gaps.
