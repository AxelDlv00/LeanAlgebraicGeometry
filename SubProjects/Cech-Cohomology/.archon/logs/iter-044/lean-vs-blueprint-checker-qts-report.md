# Lean ↔ Blueprint Check Report

## Slug
qts

## Iteration
044

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration (iter-044 additions)

The five declarations added this iteration are:

### `AlgebraicGeometry.appTop_appIso_inv_eq_res` (no blueprint block)
- **Lean target exists**: yes (line ~801)
- **Signature**: `theorem appTop_appIso_inv_eq_res {X Y : Scheme} (f : X ⟶ Y) [IsOpenImmersion f] : Scheme.Hom.appTop f ≫ (Scheme.Hom.appIso f ⊤).inv = Y.presheaf.map (homOfLE le_top).op`
- **Blueprint block**: none — no `\lean{}` tag anywhere in the chapter
- **Axioms**: clean (`propext`, `Classical.choice`, `Quot.sound` only)
- **Proof follows sketch**: N/A — no blueprint sketch

### `AlgebraicGeometry.key_morph` (no blueprint block)
- **Lean target exists**: yes (line ~815)
- **Signature**: `theorem key_morph (g : R) : (Scheme.ΓSpecIso R).inv ≫ (Spec R).presheaf.map (homOfLE ...).op = CommRingCat.ofHom (algebraMap R (Localization.Away g)) ≫ (Scheme.ΓSpecIso ...).inv ≫ ((specAwayToSpec g).appIso ⊤).inv`
- **Blueprint block**: none
- **Axioms**: clean
- **Notes**: This is the explicit formalization of route (A)'s "ΓSpec naturality of `specAwayToSpec g`", which the blueprint's proof of `lem:tile_section_comparison` describes but does not pin. The most substantive new helper.

### `AlgebraicGeometry.tile_appIso_comp` (no blueprint block)
- **Lean target exists**: yes (line ~831)
- **Signature**: `theorem tile_appIso_comp (g : R) : (Scheme.Hom.appIso (basicOpenIsoSpecAway g).inv ⊤).inv ≫ (Scheme.Hom.appIso (specBasicOpen g).ι ...).inv = ((specAwayToSpec g).appIso ⊤).inv ≫ (Spec R).presheaf.map (eqToHom ...).op`
- **Blueprint block**: none
- **Axioms**: clean
- **Notes**: `comp_appIso` bookkeeping folding two open-immersion section isos into one. Pure categorical helper.

### `AlgebraicGeometry.tile_section_ring_identity` (no blueprint block)
- **Lean target exists**: yes (line ~847)
- **Signature**: `theorem tile_section_ring_identity (g : R) : (Scheme.ΓSpecIso R).inv ≫ (Spec R).presheaf.map (homOfLE ...).op = CommRingCat.ofHom (algebraMap R (Localization.Away g)) ≫ (Scheme.ΓSpecIso ...).inv ≫ (Spec ...).presheaf.map (homOfLE ...).op ≫ ((basicOpenIsoSpecAway g).inv.appIso ⊤).inv ≫ ((specBasicOpen g).ι.appIso ...).inv`
- **Blueprint block**: none
- **Axioms**: clean
- **Notes**: The morphism-level encoding of the single structure-sheaf ring identity stated in the `lem:tile_section_comparison` proof (that ρ^{D(g)}(θ_R(r)) = β_g^{-1}(θ_{R_g}(r̄))). This is the central lemma consumed elementwise by `tile_scalar_compat`. Substantive but not directly pinned.

### `AlgebraicGeometry.tile_scalar_compat` (no blueprint block)
- **Lean target exists**: yes (line ~876)
- **Signature**: `lemma tile_scalar_compat (F : (Spec R).Modules) (g r : R) (x : (modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj (Opposite.op ⊤)) : r • (show (modulesSpecToSheaf.obj F).presheaf.obj ... from x) = (algebraMap R (Localization.Away g) r) • x`
- **Blueprint block**: none (the prover recommends pinning it to `lem:tile_section_comparison` — see Q1 below)
- **Axioms**: clean (verified; `set_option maxHeartbeats 1000000` required, noted below)
- **Proof follows sketch**: N/A — no blueprint block
- **Notes**: Scalar compatibility equation at V=⊤ only. Not an isomorphism. NOT equivalent to `lem:tile_section_comparison`.

---

## Red flags

### Excuse-comments / in-progress commentary
- `QcohTildeSections.lean:894–934`: Extended handoff comment begins "`tile_scalar_compat` / `tile_section_comparison` / `tile_section_localization` — PARTIAL this iter." This comment records the current state of progress accurately and functions as a development note, not as a "wrong but we'll fix it" excuse. It is adjacent to complete proofs (not guarding a sorry body), so it does not meet the threshold for a red-flag excuse-comment. **Informational only.**

### Performance annotation
- `QcohTildeSections.lean:867`: `set_option maxHeartbeats 1000000 in` guards `tile_scalar_compat`. This is 10× the default. Acceptable — the docstring explains the cause (a `convert … using 2` defeq check on tile section carriers). Not a red flag by itself, but should be noted for the blueprint sketch: the ring identity sub-proof is not as "focused" as the blueprint implies.

### Axioms / Classical.choice
- None of the 5 new declarations introduce `axiom` keywords or `Classical.choice` beyond the standard kernel. All clean.

---

## Unreferenced declarations (informational)

Declarations in this file with no `\lean{...}` reference anywhere in the blueprint chapter (beyond the 5 new ones above), ordered by substantiveness:

**Substantive (should have blueprint coverage):**
- `isLocalizedModule_of_span_cover` — theorem-level declaration described as "Stacks 01I8, P1b"; the blueprint chapter has no dedicated block for it (though `lem:isLocalizedModule_of_span_cover` might be implied — it is NOT tagged)
- `isIso_fromTildeΓ_of_genSections` — substantive theorem (01I8 steps 2–3 packaged); no tag
- `qcoh_iso_tilde_sections_of_genSections` — substantive noncomputable def; no tag
- `exists_finite_basicOpen_subcover` — lemma about finite basicOpen refinement; used by `qcoh_finite_presentation_cover` but not directly tagged

**Helpers (acceptable without coverage):**
- `qcoh_iso_tilde_sections_hom`, `qcoh_iso_tilde_sections_inv` — `@[simp]` lemmas characterising the iso (these are actually tagged in `lem:qcoh_iso_tilde_sections` at line 3725–3727, so they do have coverage)
- `free_isQuasicoherent` — instance; helper
- Private lemmas in `SpanCoverLocalization` and `FinitePresentationCover` sections
- `coversTop_iSup_eq_top` — tagged at line 4096 alongside `qcoh_finite_presentation_cover`

Pre-existing coverage debt (`isLocalizedModule_of_span_cover`, `isIso_fromTildeΓ_of_genSections`, `exists_finite_basicOpen_subcover`) is outside the scope of iter-044 but should be addressed in an upcoming blueprint-writing pass.

---

## Specific-question findings

### Q1 — Pin appropriateness: `tile_scalar_compat` → `lem:tile_section_comparison`

**Finding: INAPPROPRIATE. Do NOT apply the prover's recommended pin. Severity: major.**

The prover recommends adding `\lean{AlgebraicGeometry.tile_scalar_compat}` to the `lem:tile_section_comparison` block. This would be an over-claim. The two statements are categorically different:

| | `tile_scalar_compat` | `lem:tile_section_comparison` |
|---|---|---|
| Type | `Prop` (propositional equality of sections) | existence of a natural R_g-linear isomorphism |
| Scope | V = ⊤ only | all V ⊆ Spec R_g |
| Naturality | none | full naturality in V, intertwining restriction maps |
| Output | `r • x = (algebraMap r) • x` | `Γ_{R_g}(V, F_{(g)}) ≅ Γ_R(ι(V), F)` as R_g-modules |

`tile_scalar_compat` is a necessary *ingredient* for constructing `lem:tile_section_comparison`, not a formalization of it. The blueprint block asserts a natural isomorphism for all V; the Lean lemma proves a scalar equality at V=⊤. A `\lean{}` pin on a lemma block signals "this Lean declaration IS the formalization of this statement" — applying it here would misrepresent the state of formalization.

**Correct action**: write a new dedicated blueprint block for `tile_scalar_compat` (see Recommended chapter-side actions below), and leave `lem:tile_section_comparison` without a `\lean{}` pin until the full natural isomorphism is constructed.

---

### Q2 — Blueprint accuracy for `lem:tile_section_comparison` given route (A)

**Finding: Partially misleading. Severity: major.**

Route (A) was correctly identified and landed. The blueprint's route (A) description ("ΓSpec naturality of the localization morphism Spec R_g → Spec R") correctly anticipates what was formalized as `key_morph` and `tile_section_ring_identity`. This part of the sketch is accurate.

**What is misleading:**

1. **Understated proof complexity.** The blueprint says "the residual is a single focused structure-sheaf sub-proof; the carrier and scalar bookkeeping above is definitional." In reality the ring identity required three reusable helper lemmas (`appTop_appIso_inv_eq_res`, `key_morph`, `tile_appIso_comp`) before `tile_section_ring_identity` could be assembled, and the final `tile_scalar_compat` proof needed `set_option maxHeartbeats 1000000`. A prover reading the sketch would not anticipate this infrastructure. This is the type of under-specification the blueprint-adequacy test is designed to catch.

2. **Carrier definitional equality claim vs. `modulesSpecToSheaf` non-commutativity.** The proof sketch says "the carriers coincide definitionally by the restriction-of-objects identity of Lemma `lem:restrict_obj_mathlib`". The `% NOTE:` in the adjacent `lem:tile_section_localization` proof says `restrict_obj` is rfl only for the local-ring functor `Γ(M,-)`, whereas `modulesSpecToSheaf.obj` does NOT commute with restriction definitionally. These two claims are in tension. Clarification: the carrier equality at the underlying TYPE level does hold (evidenced by the `show ... from x` coercion working in `tile_scalar_compat`), but the MODULE STRUCTURE is non-trivial to transport. The blueprint currently conflates "same underlying type" with "definitional equality of module structures". This confusion directly impacts the prover drafting `tile_section_comparison`.

3. **No mention of the `IsScalarTower` instance need.** The `tile_scalar_compat` proof and prover handoff both indicate that constructing the full isomorphism (beyond the scalar equality at ⊤) requires threading `Module R_g` instances and `IsScalarTower R R_g` through the section modules. The blueprint proof sketch does not mention this instance work.

**Earlier iter flag**: Prior iters flagged the sketch as "imprecise (overstating residual size)". That concern is confirmed: the ring identity sub-proof required 4 helper lemmas and 1M heartbeats — not a "single focused" computation.

---

### Q3 — Coverage debt for the 4 helpers

**Finding: 2 major, 2 minor gaps. None of the 4 have any `\lean{}` tag in the chapter.**

| Declaration | Substantiveness | What a block would say | Severity |
|---|---|---|---|
| `appTop_appIso_inv_eq_res` | Technical helper | "For open immersion f: X→Y, `f.appTop ≫ (f.appIso ⊤).inv = Y.presheaf.map (homOfLE le_top).op`" — the section-restriction reading of the open-immersion appIso | **minor** |
| `key_morph` | Substantive — formalizes route (A) ΓSpec naturality | "ΓSpecIso⁻¹ ≫ restriction to specAwayToSpec g ''ᵁ ⊤ = algebraMap ≫ ΓSpecIso(R_g)⁻¹ ≫ (specAwayToSpec g).appIso⁻¹" — the morphism-level content of Γ-Spec naturality for the localization map | **major** |
| `tile_appIso_comp` | Technical helper | "comp_appIso bookkeeping: the two tile section isos compose into one, up to eqToHom" | **minor** |
| `tile_section_ring_identity` | Substantive — the morphism-level ring identity | "ΓSpecIso⁻¹ ≫ presheaf.map(D(g) ≤ ⊤) = algebraMap ≫ ΓSpecIso(R_g)⁻¹ ≫ id ≫ (basicOpenIsoSpecAway g).inv.appIso⁻¹ ≫ (specBasicOpen g).ι.appIso⁻¹" — this is the displayed ring identity of `lem:tile_section_comparison`'s proof, now formalized | **major** |

`key_morph` and `tile_section_ring_identity` implement the central proof steps of `lem:tile_section_comparison` (specifically, the route (A) ring identity that the proof reduces everything to). They should at minimum appear in the `lem:tile_section_comparison` proof block as `% NOTE (Lean): proved as AlgebraicGeometry.key_morph / tile_section_ring_identity` annotations, and ideally as dedicated `\begin{lemma}...\lean{...}\end{lemma}` blocks so future provers can locate and reuse them.

---

### Q4 — Soundness of `lem:tile_section_localization` sketch for the next target

**Finding: Mathematically sound but implementationally misleading on Step 4. Severity: major.**

The five-step structure is mathematically correct:
- Step 1 (global presentation via `presentationModulesRestrictBasicOpen`) ✓
- Step 2 (IsLocalizedModule over R_g via `section_isLocalizedModule_of_presentation`) ✓
- Step 3 (opens identities via `tile_image_opens_identities`) ✓
- Step 5 (base-ring descent via `isLocalizedModule_powers_restrictScalars_of_algebraMap`) ✓

**Step 4 is the problem.** The blueprint says:

> "By Lemma `lem:tile_section_comparison` there is an R_g-linear isomorphism, natural in V and intertwining restriction maps, Γ_{R_g}(V, F_{(g)}) ≅ Γ_R(ι(V), F). This is a genuine natural-isomorphism construction, not a definitional identification."

But `lem:tile_section_comparison` has **no `\lean{}` pin and no `\leanok`** — it is unformalized. The prover cannot invoke it. The prover's own handoff note (lines 914–934 of the Lean file) lays out the actual implementation plan for Step 4:

1. Use the carrier `restrict_obj`-defeq (underlying type equality)
2. Use `eqToHom` for the opens transport (propositional, not definitional)
3. Use `tile_scalar_compat` to establish `R_g`-action compatibility (= threading `IsScalarTower R R_g` on the section modules via the `module R_g` instance transport)

This is substantively different from "invoke a pre-built natural isomorphism": instead it is direct instance plumbing to thread `Module R_g` and `IsScalarTower R R_g` structures onto what are currently `Module R`-valued section objects, then apply `IsLocalizedModule.of_linearEquiv` or similar. The `% NOTE:` already in the blueprint's `tile_section_localization` proof warns that `restrict_obj rfl` is unsound for the global-ring functor — but the blueprint has NOT been updated to say "Step 4 will use `tile_scalar_compat` for scalar compatibility and `eqToHom` for the opens transport, not a standalone natural isomorphism."

**The prover handoff note (lines 914–934) is more accurate than the blueprint Step 4.** The blueprint Step 4 will lead a prover to look for `lem:tile_section_comparison` in the Lean environment and fail. The step needs to be rewritten to: (a) acknowledge `lem:tile_section_comparison` is an assembly target not yet formalized, (b) describe how `tile_scalar_compat` supplies the scalar compatibility needed for the `IsScalarTower` instance, and (c) note the `eqToHom` opens transport as the main engineering overhead.

**Additional concern**: The blueprint Step 4 claims the section comparison isomorphism is "natural in V". The current `tile_scalar_compat` only establishes scalar compatibility at V=⊤. For `tile_section_localization`, the localization being proved is Γ_R(D(g), F) → Γ_R(D(gf), F), which corresponds to V=Spec R_g and V=D(f̄) on the tile. V=⊤ (Spec R_g) is covered by `tile_scalar_compat` as the source. The restriction-to-D(f̄) piece will require the scalar compatibility at V=D(f̄) as well, which is NOT the case V=⊤ currently handled by `tile_scalar_compat`. The prover will need either a generalized scalar compatibility (for arbitrary V, not just ⊤) or a direct argument for the D(f̄) case. This gap is not acknowledged in either the Lean handoff or the blueprint sketch.

---

## Blueprint adequacy for this file

- **Coverage**: 13 of the ~30 substantive non-private declarations in this file have a corresponding `\lean{...}` block in the chapter. Unreferenced declarations: ~8 helpers (acceptable) + 4 substantive (flagged: `isLocalizedModule_of_span_cover`, `isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`, `exists_finite_basicOpen_subcover`) + 5 new iter-044 declarations (flagged above). Coverage of iter-044 additions: 0/5 (0 have `\lean{}` tags).
- **Proof-sketch depth**: **under-specified** for `lem:tile_section_comparison` and `lem:tile_section_localization`. The tile_section_comparison sketch does not call out the `key_morph` / `tile_appIso_comp` / `tile_section_ring_identity` helper chain; `tile_section_localization` Step 4 references an unformalized lemma and does not describe the actual implementation path.
- **Hint precision**: **loose** — `lem:tile_section_comparison` has no `\lean{}` hint at all (appropriate since it's unformalized), but the route (A) proof steps that WERE formalized this iter (`key_morph`, `tile_section_ring_identity`) have no hint either, making them invisible to future readers.
- **Generality**: matches need for the formalized pieces.

**Recommended chapter-side actions**:

1. **Write a new dedicated block** for `tile_scalar_compat`: a `\begin{lemma}[Sub-lemma B scalar compatibility]...\lean{AlgebraicGeometry.tile_scalar_compat}...\end{lemma}` block within the `TileSectionLocalization` section. State it as: "for r ∈ R and a section x of F over ι(⊤), r·x (as an R-module section) equals (algebraMap R R_g r)·x (as an R_g-module section of the tile)". Crucially, do NOT describe this as `lem:tile_section_comparison`.

2. **Write new dedicated blocks** (or at minimum `% NOTE (Lean): proved as ...` annotations in the `lem:tile_section_comparison` proof) for `key_morph` (the ΓSpec naturality morphism identity) and `tile_section_ring_identity` (the assembled ring identity at morphism level). These formalize the route (A) steps explicitly described in the blueprint proof but currently invisible in the chapter.

3. **Revise `lem:tile_section_comparison`'s proof** to: (a) clarify that "carrier equality" means equality of the underlying type of sections, NOT equality of the full bundled module structure (the `show ... from x` coercion works; the module structure transport does not); (b) expand the route (A) sub-proof to name `key_morph` and `tile_section_ring_identity`; (c) remove the claim that this is "definitional" without qualification.

4. **Revise `lem:tile_section_localization` Step 4** to: (a) not reference `lem:tile_section_comparison` as an available Lean declaration — instead describe it as an intermediate assembly target; (b) state explicitly that Step 4 is implemented via `tile_scalar_compat` (scalar compatibility at ⊤) + `IsScalarTower R R_g` instance threading + `eqToHom` for the opens transport; (c) note that scalar compatibility at V=D(f̄) (not just V=⊤) may require a separate argument.

5. **Write `\lean{...}` hints** for `isLocalizedModule_of_span_cover`, `isIso_fromTildeΓ_of_genSections`, and `exists_finite_basicOpen_subcover` (pre-existing coverage debt, lower priority).

---

## Severity summary

| Finding | Location | Severity |
|---|---|---|
| Proposed pin `tile_scalar_compat` → `lem:tile_section_comparison` is an over-claim (scalar equality ≠ natural iso) | Q1 | **major** (would be must-fix if applied) |
| `lem:tile_section_comparison` proof sketch understates complexity (4 helpers, 1M heartbeats, no mention of instance plumbing) | Q2 | **major** |
| `lem:tile_section_comparison` conflates type-level carrier equality with module-structure definitional equality | Q2 | **major** |
| `key_morph` — substantive theorem (route A ΓSpec naturality), no `\lean{}` tag | Q3 | **major** |
| `tile_section_ring_identity` — substantive theorem (morphism-level ring identity), no `\lean{}` tag | Q3 | **major** |
| `tile_scalar_compat` — scalar compatibility lemma, no dedicated blueprint block | Q3 | **major** |
| `appTop_appIso_inv_eq_res`, `tile_appIso_comp` — technical helpers, no `\lean{}` tags | Q3 | **minor** |
| `lem:tile_section_localization` Step 4 references unformalized `lem:tile_section_comparison`; actual implementation path differs | Q4 | **major** |
| `lem:tile_section_localization` does not acknowledge that scalar compatibility at V=D(f̄) may differ from V=⊤ | Q4 | **major** |

**Overall verdict**: The 5 new declarations are all axiom-clean and technically correct; no sorry, no fake bodies, no excuse-comments on proof-carrying declarations. The Lean side is sound. The blueprint side has 5 major and 2 minor gaps — the proposed pin is inappropriate, the proof sketch is under-specified for the helper chain, Step 4 of `tile_section_localization` references an unformalized lemma as if it were available, and there is a potentially unsound claim about V=D(f̄) scalar compatibility in the next target. No must-fix-this-iter finding (the pins have not yet been applied and no sorry is present), but the 5 majors should be addressed before the prover attempts `tile_section_localization`.
