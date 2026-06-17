# Lean ↔ Blueprint Check Report

## Slug
di264

## Iteration
264

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (consolidated chapter; `% archon:covers` DualInverse.lean among others)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` (chapter: `lem:slice_dual_transport`)
- **Lean target exists**: yes (L219–415)
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) (V : (Opens Y)ᵒᵖ) : (pushforward β).obj (dual M.val)).obj V ≅ (dual ((pushforward β).obj M.val)).obj V` matches blueprint's sectionwise iso statement.
- **Proof follows sketch**: partial — `toFun`, `map_add'`, `map_smul'` are filled (map_smul' closed this iter); `naturality`, `invFun`, `left_inv`, `right_inv` remain as typed sorries.  Blueprint §5723–5848 covers all four remaining obligations.  See adequacy section for detail on what's missing for `naturality`.
- **notes**: `\leanok` on the statement block is correct (body exists, typed sorries present).  Blueprint's statement correctly caveats both parts of the naturality obligation (thin-poset + ε-naturality).

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap}` (inline in `lem:slice_dual_transport` proof, §5753)
- **Lean target exists**: yes (L193–200)
- **Signature matches**: yes — blueprint spells out `inv(ε(restrictScalars (f.appIso W').inv.hom))` at the `CommRingCat` carrier; Lean body matches.
- **Proof follows sketch**: yes, axiom-clean.
- **notes**: No standalone block; inline reference is sufficient.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso}` (inline §5756)
- **Lean target exists**: yes (L179–184)
- **Signature matches**: yes — `IsIso (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (f.appIso W').inv.hom))`.
- **Proof follows sketch**: yes, axiom-clean.
- **notes**: —

### `\lean{PresheafOfModules.dualUnitIsoGen}` (inline §5759)
- **Lean target exists**: yes (L126–161)
- **Signature matches**: yes — `dual 𝟙_ ≅ 𝟙_` for a general `R₀`.
- **Proof follows sketch**: yes, axiom-clean.
- **notes**: The blueprint also references this via the scheme-level alias `presheafDualUnitIso` (defined at L553–557), but `presheafDualUnitIso` has no separate `\lean{...}` tag.  Minor gap (see unreferenced section).

### `\lean{AlgebraicGeometry.Scheme.Modules.image_preimage_of_le}` (inline §5768, §6230)
- **Lean target exists**: yes (L726–730)
- **Signature matches**: yes — `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V` for `V ≤ W`.
- **Proof follows sketch**: yes, axiom-clean.
- **notes**: —

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`)
- **Lean target exists**: yes (L514–546)
- **Signature matches**: yes — `(dual M).restrict f ≅ dual (M.restrict f)`.
- **Proof follows sketch**: partial — Steps 1–3 + H1 are closed; one sorry remains at the outer `isoMk` naturality (L546), blocked on `sliceDualTransport.naturality`.
- **notes**: `\leanok` on statement block only; proof block lacks `\leanok` — correct.  Blueprint L5987–5991 says outer naturality is "thin-poset-trivial" (Subsingleton.elim once `sliceDualTransport.hom` is concrete), consistent with the Lean comment.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `lem:dual_unit_iso`)
- **Lean target exists**: yes (L564–569)
- **Signature matches**: yes — `dual (unit Y.ringCatSheaf) ≅ unit Y.ringCatSheaf`.
- **Proof follows sketch**: yes, axiom-clean.
- **notes**: `\leanok` on both statement and proof block — correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`)
- **Lean target exists**: yes (L622–631)
- **Signature matches**: yes — `IsLocallyTrivial L → IsLocallyTrivial (dual L)`.
- **Proof follows sketch**: partial — three-step chain is assembled and compiles; inherits the `dual_restrict_iso` sorry axiomatically.
- **notes**: `\leanok` on statement block, no `\leanok` on proof — correct.  The chain `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` is exactly blueprint §6103–6129.

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `lem:scheme_modules_hom_local_section`)
- **Lean target exists**: yes (L645–694)
- **Signature matches**: yes.
- **Proof follows sketch**: yes, axiom-clean; naturality via `Subsingleton.elim` matches blueprint §6233–6245.
- **notes**: `\leanok` on statement and proof — correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`)
- **Lean target exists**: yes (L803–972)
- **Signature matches**: yes — sectionwise compatibility form (iter-254 re-sign); blueprint §6322–6332 explicitly endorses this sectionwise form as the only practically-usable one.
- **Proof follows sketch**: yes, axiom-clean; step (c) via `hbridge`/`hfl_native`/`Scheme.Modules.map_smul` matches blueprint.
- **notes**: `\leanok` on statement and proof — correct.

---

## Red flags

### Placeholder / suspect bodies
- `sliceDualTransport` L337 (naturality), L410 (invFun), L413 (left_inv), L415 (right_inv): typed `sorry`s within a partial `LinearEquiv` body.  The blueprint acknowledges these four obligations; the declaration compiles and has genuine partial content.  **Expected partial state — not a red flag in context.**
- `dual_restrict_iso` L546: `sorry` for outer `isoMk` naturality.  Blocked on `sliceDualTransport.naturality`.  **Expected partial state.**

None of the sorrys are fake/placeholder statements in the red-flag sense: the declarations have real bodies with substantive progress, and the sorrys are typed (they close specific goals with documented obstacles).  The module-doc comments are detailed strategy notes, not "excuse comments."

### Axioms / Classical.choice
None.

---

## Unreferenced declarations (informational)

| Declaration | Type | Assessment |
|---|---|---|
| `PresheafOfModules.unitDualSectionEquiv` | `≃ₗ` building block for `dualUnitIsoGen` | Helper; no blueprint tag needed |
| `AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso` | Thin alias `dualUnitIsoGen (R₀ := Y.presheaf)` | Minor: should have `\lean{...}` tag in blueprint (feeds `dual_unit_iso`) |
| `AlgebraicGeometry.Scheme.Modules.topSectionToHom` | step-(b) helper for `homOfLocalCompat` | Implementation helper; blueprint names only `presheafHomSectionsEquiv` |
| `AlgebraicGeometry.Scheme.Modules.topSectionToHom_app` | Companion simp lemma for the above | Implementation helper |

---

## Blueprint adequacy for this file

### Coverage
10 / 10 substantive Lean declarations have a corresponding `\lean{...}` block (or are inline-referenced within a proof-level block).  Unreferenced declarations: 4 helpers (acceptable for the first two; `topSectionToHom`/`topSectionToHom_app` are implementation details).

### Proof-sketch depth: **adequate for invFun and round-trips; major gap for naturality (sliceDualTransport)**

**What is adequate:**

- **`invFun` recipe (L5761–5781):** The blueprint gives a complete, actionable recipe: (1) use `(f.appIso W'').hom` in place of `.inv`; (2) use `ε(restrictScalars β_{W''})` itself (not `inv ε`) for the codomain swap; (3) reindex by the inverse bijection `W'' ↦ f⁻¹W''` via `image_preimage_of_le`; (4) round-trips close by `Iso.inv_hom_id`/`hom_inv_id` of `f.appIso` plus the bijection cancellation.  This is precise enough to guide the prover through the build.

- **`left_inv`/`right_inv` (L5777–5781):** Blueprint names both closing lemmas (`Iso.inv_hom_id`, `Iso.hom_inv_id`) and the down-set cancellation.  Adequate.

- **Outer `dual_restrict_iso` isoMk naturality (L5987–5991):** Blueprint correctly says "outer naturality square thin-poset-trivial" (`Subsingleton.elim` at the `Opens Y` level once `sliceDualTransport.hom` is concrete).  This will close trivially after `sliceDualTransport.naturality` is proved.  Minor note: the blueprint does not state the sequencing dependency explicitly (i.e., it does not say "this step requires `sliceDualTransport.naturality` to be closed first"); the Lean comment fills this gap.

**What is under-specified (major gap):**

- **`sliceDualTransport.naturality` step (b) — missing Lean lemma name for ε-naturality.**

  The blueprint (L5832–5848) correctly identifies two distinct parts of the naturality obligation:
  - (a) Base-morphism uniqueness: `Subsingleton.elim` (clear, named).
  - (b) Module-map equation: *"the ε-naturality square of `restrictScalars` — the naturality of the lax-monoidal unit ε with respect to the restriction maps of both the source and the target presheaf, along the structure-ring isomorphism β_W"*.

  The mathematical description of (b) is correct and precise.  **However**, the blueprint does NOT name the specific Lean/Mathlib lemma the prover needs.  The project has a candidate — `PresheafOfModules.restrictScalarsLaxε` (L290 of `PresheafInternalHom.lean`), a `NatTrans` whose components are `Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (α.app X).hom)` — whose naturality axiom expresses exactly the required ε-commutativity with presheaf restriction maps.  The blueprint mentions `restrictScalarsLaxε` only in a `% NOTE:` comment (at `lem:restrictscalars_laxmonoidal`, L492), not in the `sliceDualTransport` proof sketch.

  There is no project-local `ε_naturality` lemma, and the prover must either (i) find the relevant Mathlib `Functor.LaxMonoidal.ε_naturality` API or (ii) use `PresheafOfModules.restrictScalarsLaxε`'s NatTrans.naturality field.  Neither path is named.

  **Recommended fix:** Add a sentence to the `sliceDualTransport` proof (or a `% NOTE:` annotation) naming `PresheafOfModules.restrictScalarsLaxε` and noting that its `NatTrans.naturality` field delivers exactly the ε-commutativity square needed for step (b) of the naturality obligation.

### Hint precision: **precise for invFun; loose for naturality**

All `\lean{...}` names are correct (no name drift detected).  The precision gap is in the prose of the `sliceDualTransport` naturality proof sketch (b) above.

### Generality: **matches need**

No parallel API had to be written to cover gaps.

### Recommended chapter-side actions

1. **(Major — should be dispatched this iter or next)** Add to the `lem:slice_dual_transport` proof sketch: a named reference to `PresheafOfModules.restrictScalarsLaxε` and a note that its NatTrans naturality axiom closes step (b) of the `sliceDualTransport.naturality` obligation.  Without this, the prover must independently locate this project-local helper.
2. **(Minor)** Add `\lean{AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso}` inline in the `lem:dual_unit_iso` proof or `lem:slice_dual_transport` proof, since the scheme-level alias is consumed by `dual_unit_iso`.
3. **(Minor)** In the `lem:dual_restrict_iso` proof, add a brief note that the outer `PresheafOfModules.isoMk` naturality (thin-poset-trivial) is sequenced *after* `sliceDualTransport.naturality` is closed, to make the dependency chain explicit.

---

## Severity summary

- **must-fix-this-iter**: None.
- **major**: 1 — `sliceDualTransport.naturality` step (b) needs `PresheafOfModules.restrictScalarsLaxε` named in the blueprint proof sketch; the mathematical obligation is correctly described but the specific Lean helper is missing, creating search burden for the prover closing `naturality`.
- **minor**: 3 — (a) `presheafDualUnitIso` unreferenced; (b) outer `isoMk` dependency sequencing not stated; (c) `topSectionToHom`/`topSectionToHom_app` unreferenced (implementation helpers, acceptable).

**Overall verdict:** The chapter is well-specified for `invFun` and the round-trips (`left_inv`/`right_inv`), with an actionable recipe that matches the Lean comments verbatim; the primary adequacy gap is the missing Lean lemma name for the ε-naturality sub-obligation of `sliceDualTransport.naturality`, which the blueprint correctly identifies mathematically but leaves un-pinned — 10 declarations checked, 0 hard red flags, 1 major adequacy gap.
