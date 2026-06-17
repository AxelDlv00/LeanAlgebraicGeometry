# Lean ↔ Blueprint Check Report

## Slug
avr-iter161

## Iteration
161

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Build / axiom state (verified, read-only)
- `lean_diagnostic_messages` (severity=error): **no errors**. File compiles.
- `eq_comp_of_isAffine_of_properIntegral`: axioms `{propext, Classical.choice, Quot.sound}` — **axiom-clean (no `sorryAx`)**. Confirms "PROVEN".
- `morphism_eq_of_eqAt_closedPoints`: axioms `{propext, Classical.choice, Quot.sound}` — **axiom-clean**. Confirms "PROVEN".
- `rigidity_eqOn_saturated_open_to_affine`: axioms include **`sorryAx`** — correctly carries the residual.
- `rigidity_lemma`: axioms include **`sorryAx`** — correctly carries the residual.
- `sorry` bodies in the file: line **263** (`rigidity_eqAt_closedPoint_of_proper_into_affine`, the chain's lone residual) + lines **672 / 696 / 725** (the three iter-157 scaffold declarations 2–4). All other "sorry" hits are in docstrings/comments.

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_lemma}` (thm:rigidity_lemma)
- **Lean target exists**: yes (L628).
- **Signature matches**: yes. Blueprint's "for some y₀ ∈ Y, f(X×{y₀}) is a single point z₀" is encoded as explicit points `x₀,y₀,z₀` + the collapse hypothesis `_hf` (the Lean is universally-quantified over a given collapse; faithful). Conclusion `∃ g, f = snd X Y ≫ g` matches `f = g ∘ p₂`.
- **Proof follows sketch**: yes. `rigidity_snd_lift` reduction + `rigidity_core`, matching rmk:rigidity_lemma_decomposition.
- **notes**: `[LocallyOfFiniteType (X⊗Y).hom]` present (iter-161 threading); matches the remark's stated hypothesis set.

### `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` (lem:rigidity_eqOn_dense_open)
- **Lean target exists**: yes (L370).
- **Signature matches**: yes. Collapse hypothesis `_hf` present and load-bearing (used for `y₀ ∉ G`); instances match.
- **Proof follows sketch**: yes. Mumford `U = X×V`, `G = p₂(f⁻¹(Z−U₀))` closed via `snd_left_isClosedMap`; `hfib` fibre fact; delegates bridge 2 to the saturated-open helper. `sorry`-free in own body (consistent with prose).

### `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` (lem:rigidity_eqOn_saturated_open_to_affine)
- **Lean target exists**: yes (L294).
- **Signature matches**: yes. `[IsAlgClosed] + [LocallyOfFiniteType (X⊗Y).hom]` both present; `_hUV` (saturation `U = snd⁻¹ Vset`), `_hU₀ : IsAffineOpen U₀`, `_hfU` (affine containment); conclusion `U.ι ≫ f.left = U.ι ≫ (retract ≫ f).left`. Matches the itemized blueprint statement.
- **Proof follows sketch**: yes. Body is real assembly: `JacobsonSpace U` discharged (`LocallyOfFiniteType.jacobsonSpace` + `JacobsonSpace.of_isOpenEmbedding`), then `morphism_eq_of_eqAt_closedPoints` over per-closed-point Step 1. No `sorry` in own body.

### `\lean{AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints}` (lem:morphism_eq_of_eqAt_closedPoints)
- **Lean target exists**: yes (L112).
- **Signature matches**: yes. `[IsReduced W] [JacobsonSpace W] [Z.IsSeparated]`, hypothesis = agreement at every `x ∈ closedPoints W` after `fromSpecResidueField`, conclusion `g₁ = g₂`. Exactly the blueprint statement.
- **Proof follows sketch**: yes. Coproduct `∐ Spec κ(x)` probe → `IsDominant` via `closure_closedPoints` + `range_fromSpecResidueField` → `Sigma.hom_ext` + `ext_of_isDominant`. Verified axiom-clean.

### `\lean{AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine}` (lem:rigidity_eqAt_closedPoint_of_proper_into_affine)
- **Lean target exists**: yes (L204).
- **Signature matches**: yes. Full hypothesis set of the saturated-open lemma + `(x : U.toScheme)`, `(_hx : x ∈ closedPoints U.toScheme)`; conclusion is the residue-field-probe equation, matching the displayed equation in the blueprint statement.
- **Proof follows sketch**: partial (intended). Body reduces to the `k̄`-point statement (`pointOfClosedPoint`), discharges the algebraic heart via `eq_comp_of_isAffine_of_properIntegral`, and leaves ONE documented `sorry` (L263) for the geometric slice/section assembly. This is the chain's single residual — correctly carried (`sorryAx` propagates up). Statement-block `\leanok` (declaration formalized) is correct; proof block correctly has NO `\leanok`.

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (prop:morphism_P1_to_AV_constant)
- **Lean target exists**: yes (L663). **Signature matches**: yes (SCAFFOLD; ℙ¹ via genus-0 proxy). **Proof**: `sorry` (scaffold, documented; `\uses{thm:rigidity_lemma, thm:theorem_of_the_cube}`).

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (prop:genusZero_curve_iso_P1)
- **Lean target exists**: yes (L687). **Signature matches**: yes. **Proof**: `sorry` (scaffold, RR sub-build, documented).

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (thm:rigidity_genus0_curve_to_AV)
- **Lean target exists**: yes (L712). **Signature matches**: yes; `[CharZero]`-free as advertised, pointed hypothesis `_hf : p ≫ f = η[A]`, conclusion `f = toUnit C ≫ η[A]`. **Proof**: `sorry` (scaffold, documented).

## Red flags

### Axioms / suspect bodies
- None. The four `sorry` bodies (L263 chain residual; L672/696/725 scaffolds) are all explicitly documented in docstrings AND in the blueprint (residual flagged in Step-1 lemma + remarks; scaffolds carry no proof `\leanok`). No `axiom` declarations, no `:= True`, no excuse-comments masquerading as real definitions.

## Unreferenced declarations (informational)

Four Lean declarations have no `\lean{...}` block:
- `rigidity_snd_lift` (L71) — helper; **named in prose** (`\texttt{rigidity\_snd\_lift}`, rmk:rigidity_lemma_decomposition). Acceptable.
- `snd_left_isClosedMap` (L90) — helper; **named in prose** (Bridge 1, rmk + lem proof). Acceptable.
- `rigidity_core` (L542) — helper; **named in prose** (rmk:rigidity_lemma_decomposition). Acceptable.
- `eq_comp_of_isAffine_of_properIntegral` (L153) — **NOT mentioned anywhere in the chapter** (grep for `eq_comp`/`properIntegral` in the `.tex`: no matches). See major finding below.

## Blueprint adequacy for this file

- **Coverage**: 8/12 Lean declarations have a `\lean{...}` block; 4 unreferenced = 3 prose-named helpers (acceptable) + **1 substantive proven helper with no node** (`eq_comp_of_isAffine_of_properIntegral`).
- **Proof-sketch depth**: adequate. The Step-1 lemma proof prose (lines 489–506) explicitly names the exact Mathlib stack that became the helper — `isField_of_universallyClosed`, `finite_appTop_of_universallyClosed`, `ext_of_isAffine` — so the chapter *did* preview the helper's mathematical content; it simply didn't promote it to its own node.
- **Hint precision**: precise. Every `\lean{...}` resolves to the right declaration with a matching signature, including the iter-161 `[LocallyOfFiniteType (X⊗Y).hom]` threading reflected in both the statement prose and the remarks.
- **Generality**: matches need.
- **`\uses` graph honesty**: CLEAN. Forward chain `thm:rigidity_lemma → lem:rigidity_eqOn_dense_open → lem:rigidity_eqOn_saturated_open_to_affine → {lem:morphism_eq_of_eqAt_closedPoints (proven), lem:rigidity_eqAt_closedPoint_of_proper_into_affine (sorry leaf)}`. No backward edge; the not-proven status routes up. Confirmed at the kernel level: `rigidity_lemma` and `rigidity_eqOn_saturated_open_to_affine` carry `sorryAx`, while `morphism_eq_of_eqAt_closedPoints` does not. **No headline laundering.**
- **Stale prose**: none. The iter-160 signature-gap NOTE (L345–355) is rewritten to "RESOLVED"; the iter-160/161 forward-edge and instance-threading notes are accurate. The retired "[IsAlgClosed] is the only added instance" claim is explicitly retired in three places.
- **Recommended chapter-side actions**:
  - Add a `\lean{AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral}` block (a short `\begin{lemma}\leanok` "proper integral k̄-scheme into affine is constant on k̄-points") and wire `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`'s proof `\uses{...}` to it. This records the newly-proven reusable node and removes the only invisible-to-blueprint substantive declaration.

## Note for `sync_leanok` (informational, not actionable by me)
- `lem:morphism_eq_of_eqAt_closedPoints`'s **proof block** (L440–464) currently has no `\leanok`, yet the proof is complete and axiom-clean. The deterministic `sync_leanok` pass (runs between prover and review) should add it. Flagged only so the next reader doesn't mistake the missing proof-`\leanok` for an open obligation. (Marker edits are not in my write domain.)

## Severity summary

- **must-fix-this-iter**: none. No placeholder on a blueprint-substantive declaration (every `sorry` is documented and de-laundered at the kernel level), no signature mismatch, no unauthorized axiom, no blueprint-adequacy failure that would have prevented faithful formalization.
- **major (1)**: `eq_comp_of_isAffine_of_properIntegral` — newly-proven, reusable, substantive declaration with **no `\lean{...}` node and no `\uses` edge** anywhere in the chapter. Per the checker rule "missing `\lean{...}` references to declarations the blueprint should reference." NB: this is *not* an active laundering vector — the declaration is proven axiom-clean and the chain's only `sorry` lives in `rigidity_eqAt_closedPoint_of_proper_into_affine`, which *does* have a node and correctly propagates `sorryAx` upward. The risk is documentary (a reusable proven step is invisible to the dependency graph), not headline-status falsification.
- **minor**: none beyond the `sync_leanok` informational note.

Overall verdict: The Lean file faithfully formalizes the chapter — all 8 `\lean{...}`-tagged signatures match, the two new "PROVEN" lemmas are verified axiom-clean, the lone chain `sorry` is honestly carried with a forward-acyclic `\uses` graph and no headline laundering; the single gap is the missing blueprint node for the proven helper `eq_comp_of_isAffine_of_properIntegral` (major, documentary).
