# Blueprint Review Report

## Slug
eqon-bridges-recheck

## Iteration
159

## HARD GATE verdict (the gating question this dispatch)

**`AbelianVarietyRigidity.tex` CLEARS the HARD GATE: `complete: true`, `correct: true`, no must-fix-this-iter finding.**

A prover may be dispatched at `AlgebraicJacobian/AbelianVarietyRigidity.lean` this iter.

Specific directive checks:
- **New formalization notes coherent + verbatim quotes unaltered.** The `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks for `thm:rigidity_lemma`, `lem:rigidity_eqOn_dense_open`, `thm:theorem_of_the_cube`, `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1` are verbatim English copies of English-language sources (Mumford / Milne / Hartshorne) — original language and notation preserved. The added "Formalization notes" addendum (bridge 1 BUILT as `snd_left_isClosedMap`; fibre fact via the coarse `image_preimage_eq_of_isPullback` rejecting the `Triplet`/residue-field layer; bridge 2 via global-sections + per-closed-point, explicitly avoiding relative Stein / `f_*O=O`) is consistent with the Mumford prose proof and does not alter the quoted text. The three referenced PDFs (`mumford-abelian-varieties.pdf`, `abelian-varieties.pdf`, `hartshorne-algebraic-geometry.pdf`) all exist on disk under `references/`.
- **`[IsAlgClosed]` note consistent with consumers + statement.** Mathematically sound (bridge 2 needs `κ(y) = k̄`, i.e. alg-closed residue fields). The three downstream consumers `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme` already carry `[IsAlgClosed kbar]` (Lean lines 358/382/407), so propagating the instance up the chain costs nothing downstream, as the note claims. See the one informational note below on the prescriptive-vs-current-signature gap.
- **No improper `\leanok`/`\mathlibok`.** Statement-level `\leanok` sits on the five formalized declarations (all five `\lean{}` targets exist in the Lean file: `rigidity_lemma`, `rigidity_eqOn_dense_open`, `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`); statement `\leanok` = "declaration formalized, ≥ sorry present" is correct for all five (file has 12 sorries). `thm:theorem_of_the_cube` correctly carries **no** `\leanok` and **no** `\lean{}` — honest deferral. No `\mathlibok` anywhere. (`\leanok` is sync-managed; nothing visibly hand-edited improperly.)
- **Deferred blocks un-regressed.** `thm:theorem_of_the_cube` (verbatim Mumford statement, explicitly "no formal proof in this project yet"), `prop:morphism_P1_to_AV_constant` (depends on the cube; honestly documented in `rmk:cube_is_load_bearing`), and `prop:genusZero_curve_iso_P1` (Riemann–Roch sub-build flagged in `rmk:genusZero_iso_subbuild`) are all intact and honestly characterized. No regression.
- **Cross-references resolve.** All `\uses{}` inside the chapter point at real labels (internal: `thm:rigidity_lemma`, `thm:theorem_of_the_cube`, `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`, `lem:rigidity_eqOn_dense_open`; external: `def:genus` in `Genus.tex`). The two RigidityKbar labels the chapter's narrative leans on (`thm:rigidity_over_kbar`, `sec:RigidityKbar_shared_pile`) both exist.

## Top-level summaries

### Lean difficulty quality
- `AbelianVarietyRigidity.tex` / `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}`: **good, with a signature caveat (informational).** The blueprint's formalization note states the formalization "carries `[IsAlgClosed kbar]` on this lemma … and propagates the same instance to `thm:rigidity_lemma` and its core helper `rigidity_core`." In the current Lean file the instance is present **only** on the three downstream consumers (lines 358/382/407); the three chain lemmas `rigidity_eqOn_dense_open`@111, `rigidity_core`@243, `rigidity_lemma`@324 do **not** yet carry it. This is the prescriptive target state the bridge-2 proof requires (κ(y)=k̄), not a contradiction — but the prover directive should explicitly instruct adding `[IsAlgClosed kbar]` to those three chain lemmas so the prover does not stall against a signature that lacks the instance bridge-2 needs. Not blocking; the blueprint already documents the need.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - HARD GATE CLEARS (see verdict above). Active prover target `rigidity_eqOn_dense_open` has a concrete char-free Mathlib route for both residual pieces (fibre fact + bridge 2); deferred deep inputs honestly flagged.
  - Informational: blueprint prescribes `[IsAlgClosed kbar]` on the three chain lemmas; current Lean signatures carry it only on the three consumers. Thread "add the instance to `rigidity_lemma`/`rigidity_core`/`rigidity_eqOn_dense_open`" into the prover directive.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.
### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Off-critical-path fallback-(a) artifact (still carries `[CharZero]`). Not edited this iter. Structural recheck only this fast-path dispatch (2621 lines, 35 `\lean{}` hints, no FIXME/BROKEN markers); `thm:rigidity_over_kbar`, `sec:RigidityKbar_shared_pile`, and the three `lem:GrpObj_*` labels cross-referenced from `AlgebraicJacobian_Cotangent_GrpObj.tex` all resolve. Not exhaustively re-read line-by-line.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.
### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.
### blueprint/src/chapters/Genus.tex — complete + correct, no notes.
### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.
### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

## Severity summary

- **must-fix-this-iter**: none.
- **soon**: none.
- **informational**:
  - `AbelianVarietyRigidity.tex`: blueprint's `[IsAlgClosed]` formalization note is prescriptive — the three chain lemmas (`rigidity_lemma`/`rigidity_core`/`rigidity_eqOn_dense_open`) do not yet carry the instance the note says they should. Have the prover directive add it. (Blueprint is correct; this is guidance for the dispatch, not a blueprint defect.)

Overall verdict: `AbelianVarietyRigidity.tex` clears the HARD GATE (`complete: true`, `correct: true`, no must-fix); the prover at `AlgebraicJacobian/AbelianVarietyRigidity.lean` may proceed, ideally with a directive line to thread `[IsAlgClosed kbar]` onto the three chain lemmas.
