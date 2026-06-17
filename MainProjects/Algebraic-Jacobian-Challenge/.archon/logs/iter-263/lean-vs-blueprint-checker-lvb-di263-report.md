# Lean ↔ Blueprint Check Report

## Slug
lvb-di263

## Iteration
263

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` (chapter: `lem:slice_dual_transport`, lines 5670–5777)

- **Lean target exists**: yes (L217–393 of `DualInverse.lean`)
- **Signature matches**: yes — `f : Y ⟶ X`, `[IsOpenImmersion f]`, `M : X.Modules`, `V : (Opens Y)ᵒᵖ` → module iso between `(pushforward β).obj (dual M.val))(V)` and `(dual ((pushforward β).obj M.val))(V)`. Matches blueprint statement exactly.
- **Proof follows sketch**: partial.
  - `map_add'` (field 2): **CLOSED** iter-263 via `PresheafOfModules.hom_ext` + `Functor.map_add` + `Preadditive.add_comp`. Matches blueprint step (ii).
  - `naturality` (field 1): **sorry**. See red flags below.
  - `map_smul'` (field 3): **sorry** (detailed crux exposed, see red flags).
  - `invFun` (field 4): **sorry** — not yet constructed.
  - `left_inv`, `right_inv` (fields 5–6): **sorry** — blocked on `invFun`.
- **Notes**: Route-2 (direct sectionwise build, leg-A ∘ leg-B) is correctly implemented for the `toFun` skeleton: leg-A via `(restrictScalars β_W).map (φ.app ...)` and leg-B via `dualUnitRingSwap f W.unop.left`, exactly as specified in the blueprint (lines 5706–5719, 5721–5736). The `set β` + `letI lhsMod/rhsMod` + `refine LinearEquiv.toModuleIso (m₁ := …) (m₂ := …)` structure is correctly in place.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap}` (inline `\lean{}` in `lem:slice_dual_transport` proof, line 5730)

- **Lean target exists**: yes (L191–198)
- **Signature matches**: yes — `inv(ε(restrictScalars (f.appIso W').inv.hom))` at the `CommRingCat`-carrier level. Matches blueprint line 5726–5729.
- **Proof follows sketch**: closed, axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso}` (inline `\lean{}` in `lem:slice_dual_transport` proof, line 5733)

- **Lean target exists**: yes (L177–182)
- **Signature matches**: yes — `IsIso (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (f.appIso f W').inv.hom))`. Matches blueprint prose.
- **Proof follows sketch**: closed, axiom-clean.

---

### `\lean{PresheafOfModules.dualUnitIsoGen}` (inline `\lean{}` in `lem:slice_dual_transport` proof, line 5736)

- **Lean target exists**: yes (L124–158)
- **Signature matches**: yes — `dual 𝟙_ ≅ 𝟙_` at the presheaf level.
- **Proof follows sketch**: closed, axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`, lines 5779–5966)

- **Lean target exists**: yes (L492–524)
- **Signature matches**: yes — `(dual M).restrict f ≅ dual (M.restrict f)` for `f : Y ⟶ X` open immersion. Matches blueprint exactly.
- **Proof follows sketch**: partial. Steps 1–4 with H1 (`pushforwardPushforwardAdj` + `leftAdjointUniq`) are fully in place and match blueprint stages H1/H2. The residual `isoMk` naturality assembly at L522–524 has one `sorry` pending completion of `sliceDualTransport`.
- **Notes**: The blueprint `\leanok` on the statement block (L5783) is correct (declaration exists). The proof block does not carry `\leanok` (correct, since the sorry propagates from `sliceDualTransport`).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `lem:dual_unit_iso`, lines 5968–5997)

- **Lean target exists**: yes (L542–547)
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`.
- **Proof follows sketch**: yes — sheafification of `presheafDualUnitIso` (= `dualUnitIsoGen`) composed with the sheafification counit, exactly as described in the blueprint (lines 5984–5996). Closed, axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`, lines 5999–6057)

- **Lean target exists**: yes (L600–609)
- **Signature matches**: yes — `IsLocallyTrivial L → IsLocallyTrivial (dual L)`.
- **Proof follows sketch**: yes — three-step chain `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` (L609) matches blueprint steps 1–3 exactly (lines 6039–6053). Transitively inherits the `dual_restrict_iso` sorry.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `lem:scheme_modules_hom_local_section`, L6126–6178)

- **Lean target exists**: yes (L623–672)
- **Signature matches**: yes — local section of `presheafHom F G` over `op (U i)` from `f : ∀ i, M.restrict (U i).ι ⟶ N.restrict (U i).ι`.
- **Proof follows sketch**: closed, axiom-clean. The naturality field uses `Subsingleton.elim` on the thin poset `Opens X`, matching the blueprint.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`, L6180–6373)

- **Lean target exists**: yes (L781–950)
- **Signature matches**: yes — sectionwise `hf` form (re-signed iter-254). Note: blueprint statement block does not record the re-signing explicitly, but the Lean file's doc-comment explains the re-sign rationale in detail. No mismatch in mathematical content.
- **Proof follows sketch**: closed, axiom-clean. All sub-steps (i) ab-gluing, (ii) promotion via `homMk`, (iii) sectionwise linearity) match blueprint §C description.

---

## Red flags

### Placeholder / suspect bodies

- **`sliceDualTransport` at L335, L383, L388, L392, L393**: five typed `sorry` fields in the `LinearEquiv` record — `naturality`, `map_smul'`, `invFun`, `left_inv`, `right_inv`. These are substantive obligations (not stubs), but they are **typed sorries** (well-typed goals exposed) rather than blank `sorry`s; the declaration compiles. The blueprint claims all five are provable from the described ingredients — see blueprint adequacy section below for where the sketch falls short.

### Excuse-comments

None found. The in-body comments accurately document the current state and the known obstacles without falsely claiming completion.

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations introduced.

---

## Unreferenced declarations (informational)

The following declarations in `DualInverse.lean` have no `\lean{...}` block in the blueprint (acceptable as helpers):

- `PresheafOfModules.unitDualSectionEquiv` (L82–119) — sectionwise component of `dualUnitIsoGen`; name suggests sub-step.
- `Scheme.Modules.presheafDualUnitIso` (L531–535) — trivial alias of `dualUnitIsoGen`; feeds `dual_unit_iso`.
- `Scheme.Modules.topSectionToHom` (L680–688) — helper for `homOfLocalCompat` step (b).
- `Scheme.Modules.topSectionToHom_app` (L693–698) — sectionwise value lemma for `topSectionToHom`.
- `Scheme.Modules.image_preimage_of_le` (L704–707) — the down-set identity `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V` for `V ≤ W`. **Borderline**: this is a named helper that the blueprint's `homLocalSection` sketch explicitly invokes in prose (line 6215: "open-set equality `ι_i(ι_i⁻¹(V)) = V`"), but no `\lean{}` tag points to it. Worth tagging for completeness.

---

## Blueprint adequacy for this file

### Coverage
9/9 substantive Lean declarations have a corresponding `\lean{...}` block (or inline `\lean{}` reference) in the chapter. Five unreferenced helpers — all acceptable helper-only declarations. One borderline (`image_preimage_of_le`) that the prose invokes but does not tag.

### Proof-sketch depth: **under-specified** on three points

**Point 1 (must-fix) — naturality field incorrectly described:**
The blueprint proof for `lem:slice_dual_transport` (line 5775) states: "Naturality of the whole family in `W` holds by `Subsingleton.elim`, `Opens Y` being a thin poset."

This is **wrong in its scope**. `Subsingleton.elim` applies to the base morphisms in `(Over V.unop)ᵒᵖ` (there is at most one inclusion morphism between any two objects), but the naturality condition is an equation between `𝒪_Y(V)`-module maps, not between base morphisms. The Lean file's typed sorry (L335) with comment identifies the actual obstacle: after `apply PresheafOfModules.hom_ext`, the base hom-sets do agree by `Subsingleton.elim`, but the MODULE MAPS must still be shown to commute, and this requires that `dualUnitRingSwap` (which involves the lax-monoidal unit ε of `restrictScalars`) is natural with respect to the restriction maps of the target presheaf — i.e., an ε-naturality of `restrictScalars` along the structure ring iso. The blueprint gives no hint this step is needed. A prover following the blueprint sketch on naturality would immediately get stuck on the module-map equation that `Subsingleton.elim` does not discharge.

**Point 2 (major) — invFun too thin:**
The blueprint (lines 5738–5742): "The inverse equivalence is the same construction with the reverse reindexing and `(f.appIso W).hom` in place of its inverse, using that every `W'' ≤ fV` is `f.opensFunctor(f⁻¹W'')` since `fV ⊆ range f`; the round-trip identities hold by the iso axioms of `f.appIso` together with the down-set bijection."

What's missing:
- No Lean lemma is named for "every `W'' ≤ fV` is `f.opensFunctor(f⁻¹W'')`" — this is the non-trivial statement that the open-image down-set is covered by the functor image of the preimage, which requires a Mathlib `IsOpenImmersion` lemma (likely `IsOpenImmersion.range_eq_...` or a surjectivity-on-opens fact). A prover cannot find the right lemma from the blueprint alone.
- The full `PresheafOfModules.Hom` build for `invFun` (component-wise: `f.appIso W'.hom` applied to `ψ.app (op (Over.mk ...))`, the naturality field via `Subsingleton.elim` on the X-slice thin poset) is not described.
- How `left_inv`/`right_inv` use `Iso.inv_hom_id`/`Iso.hom_inv_id` of `f.appIso` component-wise to close the round-trips is not specified.

**Point 3 (major) — map_smul' missing the β-naturality step:**
The blueprint steps (i)+(ii) (lines 5756–5772) correctly identify that the internal-hom module structure's scalar action is identified with the pointwise morphism-level action (step i) and that `restrictScalars β_W` is `𝒪_Y(V)`-linear (step ii). However, the blueprint does not identify:
- The β-naturality ring identity: `s = (β.app W').hom c` (where `s` is the pushforward-restricted scalar and `c` is the `𝒪_Y(V)` scalar), obtained via `InternalHom.termRingMap_naturality` + `β.naturality` on the thin poset. Without this identity, step (ii) cannot connect the LHS scalar to the RHS scalar.
- The `ModuleCat.restrictScalars.smul_def'` lemma needed to fire the restrictScalars smul unfolding.
- The `conv`/`change` to handle the syntactic mismatch between `(toFun-section).hom z` (a projection from the struct literal) and `d.hom u` after the simp.

The Lean code at L354–383 exposes exactly this gap: the `sorry` at L383 is left precisely because these technical steps are not yet chained.

### Hint precision: **precise**
All `\lean{...}` tags correctly identify the Lean declarations they reference. No wrong or loose hints.

### Generality: **matches need**
The blueprint's `lem:slice_dual_transport` is stated at the right level of generality (arbitrary `f : Y ⟶ X` open immersion, arbitrary `M`), matching the Lean declaration.

---

## Recommended chapter-side actions (for blueprint-writing subagent)

1. **[must-fix]** Correct the naturality claim for `lem:slice_dual_transport`. Replace "Naturality of the whole family in `W` holds by `Subsingleton.elim`" with a correct description: the base morphisms in `(Over V.unop)ᵒᵖ` are unique by `Subsingleton.elim` (thin poset), but the module-map equation requires additionally that `dualUnitRingSwap` (= `inv ε(restrictScalars β_W)`) is natural with respect to the restriction maps of both the source and target presheaf. Specifically, the ε-naturality of `restrictScalars` along `β_W` (i.e., that the lax-monoidal unit `ε` is natural in the ring map) must be invoked here. The proof is a paste of the ε-naturality square post-composed with the `dualUnitRingSwap` definition.

2. **[major]** Expand the invFun description. Add:
   - The Lean lemma encoding "every `W'' ≤ fV` is in the image of `f.opensFunctor`" (likely via `IsOpenImmersion.opensFunctor_map_preimage` or the range-coverage lemma for the open-image functor).
   - The full component formula: `(f.appIso W''.hom) ≫ ψ.app (op (Over.mk (f.opensFunctor.map ...)))` as a `ModuleCat` hom over the X-slice.
   - How `left_inv`/`right_inv` use `Iso.inv_hom_id`/`hom_inv_id` of `f.appIso` at each component, together with the image-preimage down-set identity.

3. **[major]** Expand the map_smul' sketch. Add the β-naturality ring identity step explicitly: to connect the pushforward-restricted scalar to the base scalar via `InternalHom.termRingMap_naturality` + `β.naturality`. Mention `ModuleCat.restrictScalars.smul_def'` as the lemma that fires the restrictScalars smul unfolding.

4. **[minor]** Tag `image_preimage_of_le` with a `\lean{AlgebraicGeometry.Scheme.Modules.image_preimage_of_le}` inline reference in the `lem:scheme_modules_hom_local_section` proof where the "open-set equality" is invoked (line 6215).

---

## Severity summary

- **must-fix-this-iter** (1): Blueprint proof sketch for `lem:slice_dual_transport` naturality field is wrong — it claims `Subsingleton.elim` suffices, but the Lean file's typed sorry has identified a genuine additional obstacle (ε-naturality of `restrictScalars`). A prover following the blueprint would be misled on this field.
- **major** (2): `invFun` description too thin (no Lean lemma for the down-set coverage, no HOM build detail, no round-trip recipe); `map_smul'` description missing the β-naturality ring identity step and the `restrictScalars.smul_def'` lemma.
- **minor** (1): `image_preimage_of_le` (L704–707) invoked in blueprint prose but not `\lean{}`-tagged; worth tagging for cross-reference. Five helpers (`unitDualSectionEquiv`, `presheafDualUnitIso`, `topSectionToHom`, `topSectionToHom_app`, `image_preimage_of_le`) are unreferenced — all acceptable as helpers except the last, which is borderline.

**Overall verdict**: `DualInverse.lean` faithfully implements the blueprint's mathematical route, with `map_add'` newly closed in iter-263 and route-2 infrastructure (leg-A/B skeleton, `dualUnitRingSwap`, `isIso_ε`) axiom-clean; 5 remaining `≃ₗ`-field sorries (`naturality`, `map_smul'`, `invFun`, `left_inv`, `right_inv`) are substantive and blocked by a blueprint adequacy failure on naturality (must-fix) plus two under-specified sections (major) — 9 declarations checked, 1 must-fix + 2 major + 1 minor blueprint-side issue flagged.
