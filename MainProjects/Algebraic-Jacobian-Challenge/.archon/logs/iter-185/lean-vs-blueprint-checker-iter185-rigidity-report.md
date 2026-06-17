# Lean ↔ Blueprint Check Report

## Slug
iter185-rigidity

## Iteration
185

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

---

## Scope note

The chapter carries the directive `% archon:covers` spanning seven Lean files
(`AbelianVarietyRigidity.lean`, `Genus0BaseObjects.lean` and its sub-files, `RigidityLemma.lean`).
This report audits **only** the declarations that live in `AbelianVarietyRigidity.lean`.
Declarations pinned in the chapter but residing in other files are out of scope here (per
subagent charter: one file pair per dispatch).

---

## Per-declaration

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (chapter: `prop:morphism_P1_to_AV_constant`)

- **Lean target exists**: yes — `theorem morphism_P1_to_grpScheme_const` at line 668.
- **Signature matches**: yes.
  - Lean (LSP-verified): `{kbar : Type u} [Field kbar] [IsAlgClosed kbar] {A : Over (Spec (CommRingCat.of kbar))} [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom] (f : ProjectiveLineBar kbar ⟶ A) : ∃ a₀, f = toUnit (ProjectiveLineBar kbar) ≫ a₀`
  - Blueprint: [IsAlgClosed k̄], [GrpObj A], [IsProper A.hom], [Smooth A.hom], [GeometricallyIrreducible A.hom], f : ℙ¹ → A, conclusion ∃ a₀, f = toUnit ℙ¹ ≫ a₀ — perfect match.
  - The blueprint NOTEs (iter-163/164) about previously-carried product-level instances ([GeometricallyIrreducible (V⊗W).hom] etc.) are now resolved by `infer_instance` for the concrete `ProjectiveLineBar kbar ⊗ Gm kbar` type; they correctly no longer appear in the public signature.
- **Proof follows sketch**: yes (structural). The Lean proof reduces to the basepoint case via translation then calls `morphism_P1_to_grpScheme_const_aux` (the Gm-scaling shortcut body). The chapter proof sketch ("Reduction to a base point" + "The scaling shortcut" + "Constancy via density") matches this two-layer structure exactly.
- **`\leanok` status**: statement block marked `\leanok` — correct (body present). Proof block does NOT carry `\leanok` — correct (propagated sorry from `iotaGm_isDominant` → `iotaGm_chart1_composition_isOpenImmersion`, whose iter-185 partial status leaves sorry count at 1 in this chain).
- **notes**: Consistent with directive's "sorry count 2 → 2 unchanged". The public proof body itself contains no inline sorry; the sorry taint is purely from the private helper chain.

---

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (chapter: `prop:rigidity_genus0_curve_to_AV`)

- **Lean target exists**: yes — `theorem rigidity_genus0_curve_to_grpScheme` at line 735.
- **Signature matches**: yes.
  - Lean (LSP-verified): `{kbar : Type u} [Field kbar] [IsAlgClosed kbar] {C : Over ...} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] (_hgenus : genus C = 0) {A : Over ...} [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom] (f : C ⟶ A) (p : 𝟙_ ⟶ C) (_hf : p ≫ f = η) : f = toUnit C ≫ η`
  - Blueprint: same typeclasses, same signature shape — `[CharZero kbar]` correctly absent.
- **Proof follows sketch**: yes. Lean proof: (1) obtain C ≅ ℙ¹ via `genusZero_curve_iso_P1`; (2) transport f to g : ℙ¹ → A; (3) apply `morphism_P1_to_grpScheme_const` to get ∃ a₀; (4) pin a₀ = η via pointed hypothesis; (5) back-transport. Blueprint proof sketch (lines 1816–1826) describes this iso-transport chain verbatim.
- **`\leanok` status**: statement block marked `\leanok` — correct (body present). Proof block does NOT carry `\leanok` — correct (carries propagated sorry from `genusZero_curve_iso_P1` [RR bridge] and `morphism_P1_to_grpScheme_const`'s helper residuals).
- **notes**: No laundering. The pointed hypothesis `_hf` is genuinely consumed at line 755 (`≫ φ.hom_inv_id`). The signature mirrors `rigidity_over_kbar` from `RigidityKbar` with `[CharZero kbar]` dropped, as stated.

---

## Unreferenced declarations (informational)

The following declarations in `AbelianVarietyRigidity.lean` have no direct `\lean{...}` blueprint pin (all are `private`). They are helpers consumed by the two public theorems above, and are documented in blueprint proof-notes and the analogies directory:

| Declaration | Line | Role |
|---|---|---|
| `iotaGm_onePt_chart1_factor` | 106 | Sub-task (b): chart-1 factorisation of onePt.left — axiom-clean iter-184 |
| `iotaGm_inner_lift_compat` | 169 | Compatibility condition for inner pullback.lift — axiom-clean |
| `iotaGm_chart1_section` | 181 | Chart-1 section s : Gm.left → (cover).X 1 — axiom-clean |
| `iotaGm_chart1_composition_isOpenImmersion` | 252 | Sub-task (f): s ≫ chart 1 is an open immersion — **HAS SORRY** at L396 |
| `iotaGm_isOpenImmersion` | 424 | The open immersion (lift toUnit⋯ ≫ gmScalingP1).left — axiom-clean in body |
| `iotaGm_range_isOpen` | 473 | Open-range helper — axiom-clean in body |
| `iotaGm_isDominant` | 492 | Dominance of canonical Gm ↪ ℙ¹ — axiom-clean in body |
| `morphism_P1_to_grpScheme_const_aux` | 533 | Pointed case: f(0)=η ⟹ f=1 — axiom-clean in body |

None of these names suggest they should be promoted to blueprint `\lean{...}` blocks; they are appropriately infrastructure-level. The four "axiom-clean in body" lemmas carry propagated sorry from `iotaGm_chart1_composition_isOpenImmersion`.

---

## Red flags

### Placeholder / suspect bodies

- **`iotaGm_chart1_composition_isOpenImmersion`** at line 252: carries a `sorry` at L396 (Stage 8: the `appTop` ring-map equality after the `change` + iso-chain reconstruction trick). This is a **private helper**, NOT chapter-pinned. The directive explicitly acknowledges this as the iter-185 partial advance ("sorry at L382 area was pushed substantially deeper ... iter-186+ closure target"). Not a must-fix finding.

- **`genusZero_curve_iso_P1`** at line 710: body is `:= sorry` (the Riemann–Roch bridge). This is the standing deferral per iter-167+. The declaration is pinned in `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex` (not in this chapter), and the blueprint correctly marks its statement block without `\leanok`. Not a must-fix finding.

**Diagnostic confirmation**: LSP `lean_diagnostic_messages` returns exactly 2 "declaration uses sorry" warnings:
- Line 252 col 15: `iotaGm_chart1_composition_isOpenImmersion` (private)
- Line 710 col 9: `genusZero_curve_iso_P1`

This is consistent with the directive's "sorry count 2 → 2 unchanged".

### Excuse-comments

None found. The comments in the Lean file are factual status notes (iteration numbers, proof stages, mathematical content explanations), not excuses for wrong or placeholder code. The `sorry` in `iotaGm_chart1_composition_isOpenImmersion` is accompanied by a detailed Stage 8 explanation of *what remains*, not a claim that incorrect code is acceptable.

### Axioms / Classical.choice on non-trivial claims

No `axiom` declarations. No `Classical.choice _` on substantive claims. The axiom set for clean declarations is `{propext, Classical.choice, Quot.sound}` (standard Lean 4 kernel axioms), which the blueprint notes authorize throughout.

---

## Blueprint adequacy for this file

- **Coverage**: 2/2 chapter-pinned declarations in `AbelianVarietyRigidity.lean` have `\lean{...}` blocks (`morphism_P1_to_grpScheme_const`, `rigidity_genus0_curve_to_grpScheme`). The 8 private helpers are not chapter-pinned but are documented in blueprint proof notes; this is appropriate given their private status.
- **Proof-sketch depth**: **adequate**. The blueprint for `prop:morphism_P1_to_AV_constant` (proof block, lines 1696–1790) contains a detailed Gm-scaling shortcut sketch that directly corresponds to the Lean proof structure (reduction to basepoint → scaling shortcut → density argument). The blueprint for `prop:rigidity_genus0_curve_to_AV` (lines 1816–1828) gives the correct iso-transport recipe.
- **Hint precision**: **precise**. The `\lean{...}` names are exact and match the Lean declarations.
- **Generality**: **matches need**. The blueprint's iter-163/164 notes correctly document that the Lean signature is *strictly more general* than the prose for `lem:hom_additivity_over_product` (requiring only first factor complete, not needing A to be an abelian variety per se), and this downstream benefit flows to `morphism_P1_to_grpScheme_const`.
- **Minor staleness (non-blocking)**:
  1. The blueprint notes for `lem:gmscaling_chart_PLB_eq` (lines 1398–1406) describe the iter-174→175 status of Step (C), with no mention of the iter-185 advance to `iotaGm_chart1_composition_isOpenImmersion`. Since `iotaGm_chart1_composition_isOpenImmersion` is private and not chapter-pinned, this blueprint staleness is **minor** — it does not mislead a prover about any chapter-pinned obligation.
  2. The proof block of `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` (line 590) still contains the prose "This per-slice statement is the chain's single genuinely-deep residual sorry", which was marked STALE in an inline NOTE at line 582 (iter-162 review). However this declaration is in `RigidityLemma.lean`, not in scope for this report.
- **Recommended chapter-side actions**:
  - A blueprint-writer dispatch could add an iter-185 NOTE inside the `prop:morphism_P1_to_AV_constant` proof block, updating the helper status from "one named bridge sorry (`iotaGm_isDominant`)" to "iter-185 partial: `iotaGm_chart1_composition_isOpenImmersion` advanced to Stage 8 (appTop ring-map equation), iter-186 target for closure." This is **informational only** — no blueprint reader is misdirected by the current text.

---

## Severity summary

- **must-fix-this-iter**: None.
- **major**: None.
- **minor**:
  1. Blueprint notes for the `iotaGm_chart1_composition_isOpenImmersion` private helper chain are stale at iter-174/175; a minor blueprint-writer NOTE would reflect the iter-185 Stage 8 advance. (Non-blocking — private helper, not chapter-pinned.)

**Overall verdict**: Both chapter-pinned declarations in `AbelianVarietyRigidity.lean` exist with signatures precisely matching the blueprint prose; the 2 sorries are properly-acknowledged known deferrals; the iter-185 structural advance to `iotaGm_chart1_composition_isOpenImmersion` is accurately described in the Lean docstring and is consistent with the blueprint's picture of the proof chain — 2 declarations checked, 0 must-fix red flags.
