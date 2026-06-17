# Lean ↔ Blueprint Check Report

## Slug

avr-iter166

## Iteration

166

## Files audited

- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_lemma}` (chapter: `thm:rigidity_lemma`, L91)

- **Lean target exists**: yes — L765.
- **Signature matches**: yes — instance set `[IsAlgClosed kbar] [IsProper X.hom] [GeometricallyIrreducible (X⊗Y).hom] [LocallyOfFiniteType (X⊗Y).hom] [IsReduced (X⊗Y).left] [IsSeparated Z.hom]`, collapse hypothesis `_hf` and existential `∃ g, f = snd ≫ g` match prose verbatim.
- **Proof follows sketch**: yes — categorical reduction via `rigidity_snd_lift` + geometric core via `rigidity_core`. No sorry.
- **notes**: unchanged in iter-166; carried forward from iter-162.

### `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` (chapter: `lem:rigidity_eqOn_dense_open`, L238)

- **Lean target exists**: yes — L507.
- **Signature matches**: yes — collapse hypothesis `_hf` threaded, existential of dense open with agreement.
- **Proof follows sketch**: yes — Mumford's `U = X × V` construction; `_hf` consumed in `hy₀ : y₀ ∉ Gset` step.
- **notes**: unchanged in iter-166.

### `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` (chapter: `lem:rigidity_eqOn_saturated_open_to_affine`, L385)

- **Lean target exists**: yes — L431. Sorry-free body.
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `JacobsonSpace U` discharged inline, Steps 1+2 wired.
- **notes**: unchanged in iter-166.

### `\lean{AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints}` (chapter: `lem:morphism_eq_of_eqAt_closedPoints`, L472)

- **Lean target exists**: yes — L115. Axiom-clean.
- **Signature matches**: yes.
- **Proof follows sketch**: yes — dominant coproduct probe + `ext_of_isDominant`.

### `\lean{AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral}` (chapter: `lem:eq_comp_of_isAffine_of_properIntegral`, L515)

- **Lean target exists**: yes — L156. Axiom-clean.
- **Signature matches**: yes.
- **Proof follows sketch**: yes.

### `\lean{AlgebraicGeometry.isIntegral_of_retract}` (chapter: `lem:isIntegral_of_retract_of_integral`, L561)

- **Lean target exists**: yes — L203. Axiom-clean.
- **Signature matches**: yes — more general than prose (any retract, not just `X` of `X×Y`).
- **Proof follows sketch**: partial — Lean proves reducedness PER-STALK (via `pr.stalkMap` injectivity + `isReduced_of_isReduced_stalk`); the prose describes a global-sections split-injection route. Both routes are mathematically sound; cosmetic divergence already flagged in chapter NOTE iter-162.

### `\lean{AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine}` (chapter: `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`, L599)

- **Lean target exists**: yes — L262. Axiom-clean.
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `pointOfClosedPoint`, slice section `sec`, `IsIntegral X.left` via `isIntegral_of_retract`, `eq_comp_of_isAffine_of_properIntegral` applied to corestricted `g`.

### `\lean{AlgebraicGeometry.hom_additive_decomp_of_rigidity}` (chapter: `lem:hom_additivity_over_product`, L696)

- **Lean target exists**: yes — L814. Axiom-clean.
- **Signature matches**: yes — chapter NOTEs at L698-711 already document that the Lean signature is strictly more general than the prose (only `V` complete required, target needs only `[GrpObj A] [IsProper A.hom]`).
- **Proof follows sketch**: yes — group difference `φ = h / ((p≫f)·(q≫g))`, Rigidity then `g' = 1` via section.

### `\lean{AlgebraicGeometry.av_regularMap_isHom_of_zero}` (chapter: `lem:av_regular_map_is_hom`, L768)

- **Lean target exists**: yes — L884. Axiom-clean.
- **Signature matches**: yes — chapter NOTEs at L770-784 document Lean specialisation to pointed case.
- **Proof follows sketch**: yes — via Cor 1.5 applied to `μ[A] ≫ α`.

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (chapter: `prop:morphism_P1_to_AV_constant`, L1202) **[iter-166 refactor target]**

- **Lean target exists**: yes — L1089.
- **Signature matches**: yes — the abstract `P1` parameter was dropped iter-166; signature now reads `(f : ProjectiveLineBar kbar ⟶ A)`, exactly matching the chapter's "$f : \mathbb P^1_{\bar k} \to A$". Conclusion shape `∃ a₀ : 𝟙_ ⟶ A, f = toUnit ℙ¹ ≫ a₀` matches "$f(\mathbb P^1) = $ single point".
- **Proof follows sketch**: yes — outer body does the chapter's "Reduction to a base point" step (translate via `f / (toUnit ≫ zeroPt ≫ f)`); delegates the basepoint case to private helper `morphism_P1_to_grpScheme_const_aux`; un-translates via `div_eq_one`. Helper aux body implements the 𝔾ₘ-scaling shortcut exactly as the chapter sketches it (W-axis collapse via `gmScalingP1_collapse_at_zero`, Cor 1.5 reduces to `key : σ ≫ f = fst ≫ fV`, dominance of `iotaGm` + `ext_of_isDominant_of_isSeparated'` finishes).
- **notes**: helper `morphism_P1_to_grpScheme_const_aux` (L931, `private`) has no `\lean{}` hook in the chapter — see "Blueprint adequacy" below.

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (chapter: `prop:genusZero_curve_iso_P1`, L1288) **[iter-166 refactor target]**

- **Lean target exists**: yes — L1131.
- **Signature matches**: yes — iter-166 refactored target to concrete `ProjectiveLineBar kbar`; signature `Nonempty (C ≅ ProjectiveLineBar kbar)` matches chapter "$C \cong \mathbb P^1_{\bar k}$".
- **Proof follows sketch**: N/A — body is `sorry` (L1137). Acknowledged as RR sub-build in chapter (Remark `rmk:genusZero_iso_subbuild`, L1327-1337) and in Lean docstring ("body remains `sorry` (RR bridge — iter-167+)").

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (chapter: `thm:rigidity_genus0_curve_to_AV`, L1347) **[iter-166 refactor target]**

- **Lean target exists**: yes — L1156.
- **Signature matches**: yes — `[IsAlgClosed kbar]`, `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`, `(_hgenus : genus C = 0)`, abelian-variety instance set on `A`, pointed hypothesis `(_hf : p ≫ f = η[A])`, conclusion `f = toUnit C ≫ η[A]` — pinned verbatim to `rigidity_over_kbar` minus `[CharZero]` as the chapter promises.
- **Proof follows sketch**: yes — `obtain ⟨φ⟩ := genusZero_curve_iso_P1`; set `g := φ.inv ≫ f`; `obtain ⟨a₀, hga₀⟩ := morphism_P1_to_grpScheme_const g`; pin `a₀ = η[A]` via the pointed hypothesis (`hpoint : (p ≫ φ.hom) ≫ g = η[A]` then `toUnit_unique` collapse); back-transport via `φ.hom_inv_id`. Matches chapter L1370-1383 step by step.

## Red flags

(No must-fix-this-iter findings. The placeholders below are explicitly authorised by the iter-166 directive as honest scaffold residuals.)

### Placeholder / suspect bodies — authorised scaffold sorries

Six total `sorry`s, all authorised by the chapter / Lean docstrings as iter-166 scaffold residuals:

- `morphism_P1_to_grpScheme_const_aux` L944: `GeometricallyIrreducible ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom` — product-of-factors instance; flagged TODO at L943.
- `morphism_P1_to_grpScheme_const_aux` L949: `LocallyOfFiniteType ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom` — flagged TODO at L946-948.
- `morphism_P1_to_grpScheme_const_aux` L953: `IsReduced ((ProjectiveLineBar kbar) ⊗ Gm kbar).left` — flagged TODO at L952.
- `morphism_P1_to_grpScheme_const_aux` L1029: `IsReduced (ProjectiveLineBar kbar).left` — flagged TODO at L1028.
- `morphism_P1_to_grpScheme_const_aux` L1037: `IsDominant iotaGm.left` (the canonical `Gm → ℙ¹` map is dense) — flagged TODO at L1034-1036.
- `genusZero_curve_iso_P1` L1137: bare `sorry` — the RR-bridge body, acknowledged in chapter Remark `rmk:genusZero_iso_subbuild`.

Severity: all six are **explicitly scoped scaffold sorries** flagged in the Lean docstrings and (for the last) in the chapter prose. Not red flags by the must-fix-this-iter rubric — they are genuine "infrastructure not yet built" placeholders, not placeholders standing in for substantive proofs the blueprint claims are done.

### Excuse-comments

None of the iter-157 / "TODO: replace with real def" type. All TODO comments in the file flag concrete next-step infrastructure goals (product instances, dominance of `iotaGm`), consistent with the scaffold sorries they accompany.

### Axioms / Classical.choice on non-trivial claims

No `axiom` declarations in the file (verified via grep). The user's independently reported axiom set `{propext, sorryAx, Classical.choice, Quot.sound}` is the standard Lean kernel set; `Classical.choice` is not used as a stand-in proof anywhere — its appearance is the routine mathlib-wide propagation.

### Laundering check (iter-157-style)

**No laundering detected.** Specifically:

- Top-level `morphism_P1_to_grpScheme_const` is `sorry`-free; its body is honest bookkeeping (translate via the `f / (toUnit ≫ zeroPt ≫ f)` construction, delegate to the helper, un-translate via `div_eq_one`). It does **not** drop a hypothesis or claim a stronger statement than its helper supplies.
- Private helper `morphism_P1_to_grpScheme_const_aux` carries five honest sorries (product instances, `ProjectiveLineBar.left` reducedness, `IsDominant iotaGm.left`). These are **structural Mathlib/Genus0BaseObjects gaps**, not load-bearing hypotheses being dropped. The basepoint hypothesis `hf0 : zeroPt ≫ f = η[A]` is **genuinely consumed** in the proof body (L975: `rw [← Category.assoc, hcollapse]; exact hf0`), feeding the Cor 1.5 basepoint requirement.
- Top-level `rigidity_genus0_curve_to_grpScheme` is `sorry`-free; its body honestly consumes `genusZero_curve_iso_P1` (whose `sorry` is acknowledged) and `morphism_P1_to_grpScheme_const` (whose helper's sorries propagate as `sorryAx`). No hypothesis is laundered.

## Unreferenced declarations (informational)

15 declarations in the Lean file:

- 13 have direct `\lean{...}` blueprint hooks (the 12 chapter blocks listed in "Per-declaration" above, plus the public `morphism_P1_to_grpScheme_const`).
- `rigidity_snd_lift` (L74) — categorical-skeleton helper for `rigidity_lemma`, mentioned in chapter Remark `rmk:rigidity_lemma_decomposition` (L188-198) as a sub-step but not blueprinted; acceptable helper.
- `snd_left_isClosedMap` (L93) — bridge-1 helper, named in chapter prose (L201, L330-336) but not blueprinted; acceptable helper.
- `rigidity_core` (L679) — gluing-step helper, named in chapter prose (L188-194) but not blueprinted; acceptable helper.
- `morphism_P1_to_grpScheme_const_aux` (L931, `private`) — iter-166-introduced private helper carrying the 𝔾ₘ-scaling shortcut body proper. Not blueprinted. **The blueprint's proof block for `prop:morphism_P1_to_AV_constant` (L1224-1279) inlines the entire shortcut as a single proof; the Lean has factored it into outer reduction + private helper.** This is a Lean-side decomposition refactor; whether the blueprint should mirror the split is a structural preference, not an error.

## Blueprint adequacy for this file

A bidirectional check: does the blueprint chapter give a prover enough detail to formalize this file correctly?

- **Coverage**: 12/15 substantive declarations referenced via `\lean{...}` (or `\mathlibok`-style mention); 3 helpers explicitly described in chapter prose remarks but not `\lean{...}`-pinned (`rigidity_snd_lift`, `snd_left_isClosedMap`, `rigidity_core`); 1 iter-166-new private helper (`morphism_P1_to_grpScheme_const_aux`) unreferenced.

- **Proof-sketch depth**: adequate for the closed iter-162 chain; **mildly under-specified** for the iter-166-new helper machinery. Specifically:
  - The five named scaffold sorries in `morphism_P1_to_grpScheme_const_aux` (three `(ℙ¹ ⊗ Gm)` product instances, `IsReduced ProjectiveLineBar.left`, `IsDominant iotaGm.left`) are NOT individually called out in the chapter as subordinate lemmas. They are either implicit "obvious" steps (the product instances; the chapter's `lem:hom_additivity_over_product` NOTE at L699-705 does mention that "Mathlib does not auto-derive the product instances from the factors" but doesn't carve them out as named obligations) or generically described ("$\mathbb G_m$ is dense in $\mathbb P^1$ and $A$ is separated" — abstracts away the concrete `iotaGm` dominance step).
  - The chapter's proof block for `prop:morphism_P1_to_AV_constant` describes the scaling shortcut at a single granularity; the Lean has split outer reduction (`morphism_P1_to_grpScheme_const`) from the basepoint helper (`morphism_P1_to_grpScheme_const_aux`). A blueprint-writer might want to mirror this split.

- **Hint precision**: precise for the iter-166-refactored declarations (`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme` all match their chapter blocks). The iter-166 refactor that dropped the abstract `P1` parameter in favor of `ProjectiveLineBar kbar` aligns the Lean signature with the chapter's "$\mathbb P^1_{\bar k}$" language exactly — strict improvement over pre-refactor.

- **Generality**: matches need (and on three lemmas, the Lean is strictly more general than the prose, with the chapter NOTEs documenting the over-generality — see iter-163/iter-164 review notes carried in `lem:hom_additivity_over_product` and `lem:av_regular_map_is_hom`).

- **Cross-chapter `\lean{...}` references to non-existent declarations (informational, not a must-fix)**:
  - `lem:rational_map_to_av_extends` (L821) references `AlgebraicGeometry.rationalMap_to_av_extends` — not in this Lean file. Chapter prose at L834-838 explicitly marks this as "Route-A-only (iter-164), not on the genus-0 critical path"; it is a deferred Route-A obligation, not a current Lean target.
  - `lem:hom_Ga_to_av_trivial` (L994) references `AlgebraicGeometry.hom_Ga_to_av_trivial` — not in this Lean file. Chapter prose at L1004-1009 marks this as "off the genus-0 critical path, superseded by the 𝔾ₘ-scaling shortcut".
  - `lem:hom_from_Ga_trivial` (L1124) references `AlgebraicGeometry.morphism_Ga_to_av_const` — not in this Lean file. Chapter prose at L1130-1136 marks this as "off the genus-0 critical path, retained alternative route".
  - These three are intentional documentation placeholders for the demoted/Route-A routes; the chapter is clear about their off-path status. They are minor cross-chapter coverage gaps, not errors.

- **Recommended chapter-side actions**:
  - (minor) Either (a) add a `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const_aux}` block describing the basepoint helper, or (b) explicitly state in the proof block of `prop:morphism_P1_to_AV_constant` that the Lean factors into outer translation reduction + private basepoint helper.
  - (minor) Either name the five scaffold sorries (three product instances + `ProjectiveLineBar.left` reducedness + `iotaGm.left` dominance) as named blueprint obligations / TODO blocks, so future iters have a clear roadmap of what to discharge; or add a single chapter remark cataloguing them as "iter-166 scaffold residuals: structural Mathlib bridges to discharge in iter-167+".
  - (informational only) Consider whether `lem:rational_map_to_av_extends`, `lem:hom_Ga_to_av_trivial`, `lem:hom_from_Ga_trivial` should keep their `\lean{...}` hints, given the three Lean declarations don't (and per iter-164's strategy decision, won't on the genus-0 path) exist. Possibly remove the `\lean{...}` hints from these three "off-path" blocks until/unless the declarations land for Route-A.

## Severity summary

No must-fix-this-iter findings. Three minor / informational observations on the blueprint adequacy side (helper `\lean{}` hook, named scaffold-sorry obligations, off-path `\lean{}` hints).

Overall verdict: iter-166's Lane-1 refactor (drop abstract `P1`, use concrete `ProjectiveLineBar kbar`; new private basepoint helper; sorry-free outer bodies for `morphism_P1_to_grpScheme_const` and `rigidity_genus0_curve_to_grpScheme`) is faithfully matched by the blueprint chapter, the proof bodies follow the chapter sketches, no iter-157-style laundering is present, and the axiom hygiene claim (`sorryAx` propagating cleanly through the five honest helper sorries + the `genusZero_curve_iso_P1` sorry) is corroborated by the file inspection.
