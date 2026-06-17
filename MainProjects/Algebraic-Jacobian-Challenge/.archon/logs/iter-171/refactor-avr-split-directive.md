# Refactor Directive

## Slug
avr-split

## Problem

`AlgebraicJacobian/AbelianVarietyRigidity.lean` is **1198 LOC** and contains TWO logically independent layers conflated in one file:

1. **The Mumford Form-I Rigidity Lemma chain + corollaries** (L62–L909) — fully PROVEN axiom-clean (Mumford chain `rigidity_lemma` + Cor 1.5 `hom_additive_decomp_of_rigidity` + Cor 1.2 `av_regularMap_isHom_of_zero` + supporting lemmas). G0BO-FREE: depends only on `AlgebraicJacobian.Genus` + Mathlib.

2. **The genus-0 final assembly** (L910–L1198) — the iter-167 dominance bridge + `morphism_P1_to_grpScheme_const` + `genusZero_curve_iso_P1` (RR-bridge sorry, gated on iter-171 sub-build) + `rigidity_genus0_curve_to_grpScheme`. CONSUMES `Genus0BaseObjects.lean` (`ProjectiveLineBar`, `Gm`, `gmScalingP1`, `projGm_*` instances). Carries the file's 2 remaining sorries.

This conflation creates the following pain:
- The user (iter-171 hint) explicitly named AVR + G0BO as candidates for split-refactor to enable parallel work.
- The 1198-LOC monolith is the largest single file in `AlgebraicJacobian/`. Future Route A.4 (Albanese UP) will need to consume Cor 1.5/Cor 1.2 directly — it should be able to import the proven core without pulling in the G0BO-dependent genus-0 final.
- Any future prover lane on AVR's remaining sorries (currently both gated, but once iter-171's Lane A lands the body, `iotaGm_isDominant` becomes a trivial `infer_instance`) loads 909 LOC of already-proven code for context.

## Mathematical Justification

The split point at **L909/L910** is mathematically clean:

- **Above L909**: the Rigidity Lemma is a categorical / properness / closed-map statement about morphisms `V × W → A` to group objects, with no specialization to `ℙ¹` or `𝔾_m`. Cor 1.5 (additivity) and Cor 1.2 (pointed AV map is hom) are direct consequences valid for any group object `A`. All proven axiom-clean. The Mumford proof is in `references/mumford-abelian-varieties.pdf` §4 / Milne `references/abelian-varieties.pdf` §I.1.

- **Below L910**: the genus-0 final assembly uses the proven Cor 1.5 + the SPECIFIC scaling action `gmScalingP1 : ProjectiveLineBar × Gm → ProjectiveLineBar` to derive `morphism_P1_to_grpScheme_const`. This is where `ProjectiveLineBar`, `Gm`, etc. enter — i.e. where the import of `Genus0BaseObjects.lean` is genuinely needed.

The split decouples the abstract rigidity machinery (reusable by Route A.4 + any future Picard-functor work) from the concrete genus-0 application (committed to Route C closure).

## Changes Requested

### File: `AlgebraicJacobian/RigidityLemma.lean` (NEW)

Create this file with:

- Module docstring extracted from the AVR L8-L60 docstring, edited to describe ONLY the Mumford rigidity chain + Cor 1.5 + Cor 1.2 (drop references to ℙ¹ / Gm / genus-0 final assembly).
- Imports: `import AlgebraicJacobian.Genus` (the original AVR import; do NOT import `Genus0BaseObjects` here — the contents below do not need it).
- Move the entire L62–L909 block (after the `namespace AlgebraicGeometry` opener) verbatim:
  - `rigidity_snd_lift` (L74)
  - `snd_left_isClosedMap` (L93)
  - `morphism_eq_of_eqAt_closedPoints` (L115)
  - `eq_comp_of_isAffine_of_properIntegral` (L156)
  - `isIntegral_of_retract` (L203)
  - `rigidity_eqAt_closedPoint_of_proper_into_affine` (L262)
  - `rigidity_eqOn_saturated_open_to_affine` (L431)
  - `rigidity_eqOn_dense_open` (L507)
  - `rigidity_core` (L679)
  - `rigidity_lemma` (L765)
  - `hom_additive_decomp_of_rigidity` / Cor 1.5 (L814)
  - `av_regularMap_isHom_of_zero` / Cor 1.2 (L884)
  - Section delimiters, `open`s, namespace `AlgebraicGeometry`, `end AlgebraicGeometry`.
- The `morphism_P1_to_grpScheme_const` block at L1093 STAYS in AVR (genus-0 specific); the dominance-bridge intro doc at L910 STAYS in AVR.

After the move, the new `RigidityLemma.lean` should be the slim ~900 LOC (after stripping the docstring extras) file with only the abstract rigidity content. It must compile with `lake build AlgebraicJacobian.RigidityLemma` exit 0, axiom-clean (verify with `lean_verify AlgebraicGeometry.rigidity_lemma` axioms = `{propext, Classical.choice, Quot.sound}`).

### File: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (REDUCED)

After the move, this file:

- Module docstring: rewrite L8-L60 to describe ONLY the genus-0 final assembly. Reference `AlgebraicJacobian.RigidityLemma` as the upstream axiom-clean foundation; cite the moved declarations by name with `\lean{...}` form in the prose.
- Imports: `import AlgebraicJacobian.Genus`, `import AlgebraicJacobian.Genus0BaseObjects`, `import AlgebraicJacobian.RigidityLemma` (NEW import).
- Body: keep the L910-end content verbatim. The remaining file should be ~330 LOC with 2 sorries (`iotaGm_isDominant` L934 and `genusZero_curve_iso_P1` L1141 — line numbers will shift slightly).

### File: `AlgebraicJacobian.lean` (root re-export)

Already imports `AlgebraicJacobian.AbelianVarietyRigidity` at L13. ADD a new import line above it: `import AlgebraicJacobian.RigidityLemma`. This makes the new module available to any future consumer that imports `AlgebraicJacobian` as the umbrella module.

### File: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (covers update)

The `% archon:covers ...` line currently reads (verify the exact form by reading L3):
```
% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean AlgebraicJacobian/Genus0BaseObjects.lean
```

Update to:
```
% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean AlgebraicJacobian/Genus0BaseObjects.lean AlgebraicJacobian/RigidityLemma.lean
```

(One-line edit on the chapter cover declaration. The chapter content stays the same — the chapter already blueprints the entire Mumford chain and the genus-0 final.)

**NOTE**: this is the ONLY blueprint edit. The chapter prose covers both files; updating `% archon:covers` keeps the HARD GATE consistent (one chapter blueprints all three files).

### File: `archon-protected.yaml`

Verify (read-only): no decl moved is in the protected list. (Read `archon-protected.yaml` — confirmed: only `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` declarations are protected; none from AVR.)

If the verification confirms no protected decls are moved, NO edit to `archon-protected.yaml` is needed.

## Affected Files

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — substantive reduction (1198 → ~330 LOC).
- `AlgebraicJacobian/RigidityLemma.lean` — NEW file (~900 LOC).
- `AlgebraicJacobian.lean` — add one import line.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` — one-line `% archon:covers` edit.

**No downstream Lean file is expected to break.** Verification: `grep -rn "import AlgebraicJacobian.AbelianVarietyRigidity"` returns only `AlgebraicJacobian.lean:13`. `Jacobian.lean` consumes the headline `rigidity_genus0_curve_to_grpScheme` only via the umbrella import (`import AlgebraicJacobian.Jacobian` re-exports through). Verify with `lake build AlgebraicJacobian` after the refactor.

## Expected Outcome

- `AlgebraicJacobian.lean` builds green; `lake build AlgebraicJacobian` exit 0.
- `RigidityLemma.lean` axiom-clean: `lean_verify AlgebraicGeometry.rigidity_lemma`, `lean_verify AlgebraicGeometry.hom_additive_decomp_of_rigidity`, `lean_verify AlgebraicGeometry.av_regularMap_isHom_of_zero` each return `{propext, Classical.choice, Quot.sound}`.
- `AbelianVarietyRigidity.lean` (reduced) preserves the 2 gated sorries at their relocated line numbers; build green (sorry warnings only); `iotaGm_isDominant` + `genusZero_curve_iso_P1` still resolve at their new positions.
- Blueprint chapter `AbelianVarietyRigidity.tex` covers all three files; blueprint-doctor passes (no orphan chapter, no broken `% archon:covers`).
- Total project sorry count UNCHANGED at 13 (refactor moves declarations; does not introduce or close sorries).

If any unexpected compilation breakage emerges (e.g. a Mathlib-side simp lemma exposed by the rearranged file boundaries), insert `sorry` at the broken site as the refactor agent's standard fallback, document in your report's "New Sorries Introduced" section, and proceed.
