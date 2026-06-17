# Refactor Report

## Slug
avr-split

## Status
COMPLETE

## Directive

### Problem
`AlgebraicJacobian/AbelianVarietyRigidity.lean` was 1198 LOC and conflated two logically independent layers:

1. The Mumford Form-I Rigidity Lemma chain + Milne §I.1 corollaries (L62–L909) — fully PROVEN axiom-clean, G0BO-free.
2. The genus-0 final assembly (L910–L1198) — consumes `Genus0BaseObjects.lean`; carries the file's 2 remaining sorries.

The directive asked to split at L909/L910 into `RigidityLemma.lean` (new) and a reduced `AbelianVarietyRigidity.lean`, plus a one-line `% archon:covers` update.

### Changes Requested
- Create `AlgebraicJacobian/RigidityLemma.lean` with the L62–L909 block + a fresh docstring focused only on the Rigidity-Lemma chain + Cor 1.5/1.2.
- Reduce `AlgebraicJacobian/AbelianVarietyRigidity.lean` to the L910-end block + a fresh docstring focused on the genus-0 final assembly; add `import AlgebraicJacobian.RigidityLemma`.
- Add `import AlgebraicJacobian.RigidityLemma` to the umbrella `AlgebraicJacobian.lean`.
- Update `% archon:covers` in `blueprint/src/chapters/AbelianVarietyRigidity.tex` to list all three Lean files.
- Verify no protected decls are moved; `archon-protected.yaml` is unchanged.

## Changes Made

### File: `AlgebraicJacobian/RigidityLemma.lean` (NEW, 902 LOC)
- **What:** New file. Header = fresh module docstring (description of the Rigidity-Lemma chain + Cor 1.5/1.2 contents), `import AlgebraicJacobian.Genus`, `set_option autoImplicit false`, `universe u`, `open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj`, `namespace AlgebraicGeometry`, `variable {kbar : Type u} [Field kbar]`. Body = the original AVR L66–L908 verbatim, terminated by `end AlgebraicGeometry`. Declarations moved (all axiom-clean):
  - `rigidity_snd_lift`
  - `snd_left_isClosedMap`
  - `morphism_eq_of_eqAt_closedPoints`
  - `eq_comp_of_isAffine_of_properIntegral`
  - `isIntegral_of_retract`
  - `rigidity_eqAt_closedPoint_of_proper_into_affine`
  - `rigidity_eqOn_saturated_open_to_affine`
  - `rigidity_eqOn_dense_open`
  - `rigidity_core`
  - `rigidity_lemma`
  - `hom_additive_decomp_of_rigidity` (Cor 1.5)
  - `av_regularMap_isHom_of_zero` (Cor 1.2)
- **Why:** Decouples the abstract Mumford rigidity machinery from the concrete genus-`0` application so that future Route A.4 (Albanese UP) consumers can import the proven core without pulling in `Genus0BaseObjects` and the 2 gated genus-0 sorries.
- **Cascading:** none — the file imports only `AlgebraicJacobian.Genus` and builds standalone.

### File: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (REDUCED, 353 LOC)
- **What:** Header replaced with a fresh module docstring describing only the genus-0 final assembly and citing `AlgebraicJacobian.RigidityLemma` as the upstream axiom-clean foundation. Imports = `AlgebraicJacobian.Genus`, `AlgebraicJacobian.Genus0BaseObjects`, `AlgebraicJacobian.RigidityLemma`. Body = the original L910–L1197 verbatim (the iter-167 dominance bridge section + `iotaGm_isDominant` + `morphism_P1_to_grpScheme_const_aux` + `morphism_P1_to_grpScheme_const` + `genusZero_curve_iso_P1` + `rigidity_genus0_curve_to_grpScheme`), terminated by `end AlgebraicGeometry`.
- **Why:** Matches the split directive. The reduced file is now the genus-0-specific consumer.
- **Cascading:** none.

### File: `AlgebraicJacobian.lean` (root re-export)
- **What:** Added `import AlgebraicJacobian.RigidityLemma` above the existing `import AlgebraicJacobian.AbelianVarietyRigidity`.
- **Why:** Make the new module available via the umbrella module so downstream consumers picking up `AlgebraicJacobian` get the rigidity foundation.

### File: `blueprint/src/chapters/AbelianVarietyRigidity.tex`
- **What:** Updated the `% archon:covers` line to list all three Lean files: `AlgebraicJacobian/AbelianVarietyRigidity.lean AlgebraicJacobian/Genus0BaseObjects.lean AlgebraicJacobian/RigidityLemma.lean`. No other edit to the chapter; the prose blueprints both the Mumford chain and the genus-0 final.
- **Why:** Keep the HARD GATE consistent — one chapter blueprints all three files.

### File: `archon-protected.yaml`
- **What:** Read-only check. The protected list names only declarations in `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`. No moved declaration is protected. No edit needed (and none made).

## New Sorries Introduced
None. The 2 pre-existing sorries in AVR migrated with the L910–L1197 body and relocated to:
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:86` — `iotaGm_isDominant` (was L934).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:290` — `genusZero_curve_iso_P1` (was L1141).

Total project sorry count unchanged at 13.

## Compilation Status
- `AlgebraicJacobian/RigidityLemma.lean` — compiles, no warnings, sorry-free.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — compiles, only the 2 pre-existing sorry warnings (L86, L290).
- `AlgebraicJacobian.lean` — compiles, umbrella build green.
- `lake build AlgebraicJacobian` exit 0 (8334 jobs, all green).

### Axiom hygiene (verified via `lean_verify`)
All three keystone declarations in `RigidityLemma.lean` are axiom-clean:
- `AlgebraicGeometry.rigidity_lemma` → `{propext, Classical.choice, Quot.sound}`
- `AlgebraicGeometry.hom_additive_decomp_of_rigidity` → `{propext, Classical.choice, Quot.sound}`
- `AlgebraicGeometry.av_regularMap_isHom_of_zero` → `{propext, Classical.choice, Quot.sound}`

## Notes for Plan Agent

1. **The split is clean.** No cascading breakage anywhere. The only file outside the directive's affected list that imports the headline (`rigidity_genus0_curve_to_grpScheme`) is `AlgebraicJacobian/Jacobian.lean`, which sees it via the umbrella re-export and continues to build.

2. **Reduced AVR is 353 LOC, slightly over the directive's ~330 estimate** — explained by my rewritten module docstring (53 LOC of fresh prose vs. the directive's expectation of a shorter trim). The actual proof code below the header matches the original L910–L1197 verbatim. If you want a tighter docstring I can re-trim, but the current prose is clear about what the file does and what it imports.

3. **Reduced AVR's 2 sorries are unchanged in content** — only the line numbers shifted (L934→L86, L1141→L290). `iotaGm_isDominant` is still gated on Lane A's `gmScalingP1` body; `genusZero_curve_iso_P1` is still the RR bridge.

4. **One unrelated longline warning landed in my first draft of AVR L47** (the new docstring) and was immediately fixed in a follow-up edit. The pre-existing longline warnings in `Jacobian.lean:355` and `AbelJacobi.lean:22` are unchanged (not in scope for this directive).

5. **Future Route A.4 consumers** can now import `AlgebraicJacobian.RigidityLemma` directly without dragging in `Genus0BaseObjects` or the gated genus-0 sorries — exactly the intended decoupling.

6. **No follow-up refactor suggested for this iter.** The split landed cleanly.
