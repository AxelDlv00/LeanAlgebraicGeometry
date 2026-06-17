# Blueprint Review Report

## Slug
avr-recheck2

## Iteration
160

## Scope note
Sanctioned same-iter fast-path re-review (HARD GATE fast path) of
`blueprint/src/chapters/AbelianVarietyRigidity.tex` after the `avr-uses-fix` writer round.
The single prior must-fix (backward `\uses` 2-cycle + laundered headline) is the object of
verification. The rest of the blueprint was cleared by the prior `avr-recheck` review and is
unchanged this round; a compact all-clear is recorded for it below.

## Must-fix verification (the prior finding)

**CLOSED.** All three checkpoints from the directive pass:

1. **Edge set matches the table exactly — forward chain, no backward edge, no 2-cycle.**
   Confirmed against source:
   - `thm:rigidity_lemma`: statement has NO `\uses`; proof (line 87) `\uses{lem:rigidity_eqOn_dense_open}`.
   - `lem:rigidity_eqOn_dense_open`: statement has NO `\uses`; proof (line 239) `\uses{lem:rigidity_eqOn_saturated_open_to_affine}`.
   - `lem:rigidity_eqOn_saturated_open_to_affine`: statement and proof (lines 336–370) carry NO `\uses` — true leaf.
   The earlier `dense_open ⟷ saturated_open` 2-cycle is gone; edges run forward along the true
   Lean dependency order. (The only other occurrence of `dense_open` in a `\uses` context, line 106,
   is inside a `%`-comment NOTE, not a live edge.)

2. **Headline de-laundered.** `thm:rigidity_lemma`'s PROOF block now carries
   `\uses{lem:rigidity_eqOn_dense_open}` (line 87), and that lemma's proof in turn `\uses` the
   `saturated_open` leaf. The not-proven status of the lone leaf `sorry`
   (`rigidity_eqOn_saturated_open_to_affine`) therefore propagates transitively up to both
   `thm:rigidity_lemma` and `lem:rigidity_eqOn_dense_open` — neither renders fully-proven.

3. **Previously-confirmed-good content intact.**
   - `lem:rigidity_eqOn_saturated_open_to_affine` has `\label` (line 310) + `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` (line 311).
   - **Signature matches the Lean declaration** (`AlgebraicJacobian/AbelianVarietyRigidity.lean:124`):
     `[IsAlgClosed kbar]`, `X` proper, `(X ⊗ Y)` geom-irred + reduced, `Z` separated, `f`, `x₀`,
     the saturated open `U` with `_hUV` (`U = snd⁻¹ Vset`), affine `U₀` with `_hfU` (`f(U) ⊆ U₀`),
     concluding `U.ι ≫ f.left = U.ι ≫ (retract ≫ f).left` — all present in the blueprint statement.
   - Route-B proof prose intact: Step 1 (per-closed-slice constancy via `isField_of_universallyClosed`
     + `finite_appTop_of_universallyClosed` + alg-closedness, `ext_of_isAffine`) and Step 2
     (globalisation over dense closed points via `closure_closedPoints` +
     `ext_of_isDominant_of_isSeparated'`), lines 345–369.
   - Stein factorisation / `f_*𝒪 = 𝒪` recorded as a deliberately-avoided Mathlib gap (lines 340–342).
   - `rmk:rigidity_lemma_decomposition` refreshed with the iter-159 status (bridge 1 built, fibre fact
     closed, bridge 2 = the lone leaf).
   - Citations clean: `% SOURCE:` (line 312) with `(read from references/mumford-abelian-varieties.pdf …)`
     — file exists on disk; `% SOURCE QUOTE PROOF:` (line 313) verbatim Mumford; visible
     `\textit{Source: Mumford …}` (line 317) matches the `% SOURCE:` pointer.

4. **No NEW must-fix introduced this round.**

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\uses` chain `rigidity_lemma → dense_open → saturated_open` now forward, acyclic, headline
    de-laundered; lone residual `sorry` is the leaf `lem:rigidity_eqOn_saturated_open_to_affine`.
  - All `\lean{...}` hints resolve to real declarations in `AbelianVarietyRigidity.lean`
    (`rigidity_lemma`, `rigidity_eqOn_dense_open`, `rigidity_eqOn_saturated_open_to_affine`,
    `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`);
    `saturated_open` signature audited and matches.
  - `thm:theorem_of_the_cube` correctly recorded as a deferred deep input with no `\lean{}` target
    (no obligation laundered); `prop:morphism_P1_to_AV_constant` honestly flags its dependence on it.
  - All `\uses` targets resolve to real labels (`def:genus` confirmed in `Genus.tex`).

### Remaining chapters — all-clear
The other eleven chapters (`AbelJacobi`, `AlgebraicJacobian_Cotangent_GrpObj`,
`Cohomology_MayerVietoris`, `Cohomology_SheafCompose`, `Cohomology_StructureSheafAb`,
`Cohomology_StructureSheafModuleK`, `Differentials`, `Genus`, `Jacobian`, `Rigidity`,
`RigidityKbar`) were cleared `complete: true / correct: true` by the prior `avr-recheck` review
and are unchanged this round (the `avr-uses-fix` writer touched only `AbelianVarietyRigidity.tex`).
Spot-checked `Rigidity.tex` and `Jacobian.tex` (the chain's downstream consumers) — no regression,
`\uses`/`\lean` references intact. One-line all-clear: **no findings outside the target chapter.**

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

Overall verdict: `AbelianVarietyRigidity.tex` reads `complete: true` AND `correct: true` with NO
must-fix-this-iter finding — the prior 2-cycle/laundering must-fix is fully closed, the `\uses` chain
is forward and acyclic, the headline is de-laundered, and the `saturated_open` block's content and
signature are intact — so the `rigidity_eqOn_saturated_open_to_affine` prover lane on
`AlgebraicJacobian/AbelianVarietyRigidity.lean` is cleared to run this iter.
