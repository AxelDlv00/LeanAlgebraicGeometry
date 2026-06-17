# Refactor Report

## Slug

alt-sum-pi-smul-aux-sum-comp

## Status

COMPLETE

## Directive

### Problem

`AlgebraicJacobian/Cohomology/BasicOpenCech.lean` carries a trailing
`sorry` at **L657** inside `cechCofaceMap_pi_smul`. Iter-097 landed
Step 1 (filled `alternating_sum_pi_smul_aux` at L478–L494) but failed
Step 2 (closing L657). Root cause: the existing structural lemma's `F`
slot is a single morphism family `ι' → ((∏ᶜ Z₁) ⟶ (∏ᶜ Z₂))`, but the
L657 goal's alternating sum is `(∑ i, G_lit i) ≫ eqToHom`, where the
family lands in an intermediate Pi product. Instantiating `F :=
fun i ↦ G_lit i ≫ eqToHom` re-triggers `Fin ((ComplexShape.up ℕ).prev
n + 1) → ↑s₀` vs `Fin (n + 1) → ↑s₀` unification outside tactic
state.

### Changes Requested

Add a new top-level theorem `alternating_sum_pi_smul_aux_sum_comp`
immediately after `alternating_sum_pi_smul_aux`, splitting the
morphism `F` slot into a family `G` plus a single `E`. Body is
`sorry` (iter-099 prover fills). Do NOT modify
`alternating_sum_pi_smul_aux`. Do NOT touch `cechCofaceMap_pi_smul`.
Do NOT introduce `Module R (∀ k, Z_int k)` instance. Universe
hygiene: `ι_int : Type u`.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

- **What:** Inserted new top-level theorem
  `alternating_sum_pi_smul_aux_sum_comp` between the end of
  `alternating_sum_pi_smul_aux` (former L494) and the
  `set_option maxHeartbeats 1600000 in` block preceding
  `cechCofaceMap_pi_smul` (former L496). The new theorem has the
  exact signature specified in the directive (parameters
  `{k}{R}{ι₁}{ι_int}{ι₂}` then `Z₁ Z_int Z₂` then
  `[_mZ1][_mZ2]` then `{ι'} s G E e₁ e₂ hG`, conclusion as in
  directive). Body is a single `sorry`. Docstring preserved verbatim
  from directive.
- **Why:** Provides a HOU-friendly structural hook for iter-099 to
  close the trailing L657 sorry in `cechCofaceMap_pi_smul`. The
  split `(G, E)` allows the call site's `eqToHom` to land in an
  independent elaboration slot rather than inside the morphism family
  (where it would re-trigger the `prev n + 1` vs `n + 1` index-type
  unification problem).
- **Cascading:** None. The insertion is purely additive (no existing
  declaration was modified, renamed, or removed). No downstream
  consumers exist yet — the iter-099 prover will create the first
  consumer (`cechCofaceMap_pi_smul` L657 closure).

## New Sorries Introduced

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:532` — body of the
  newly inserted `alternating_sum_pi_smul_aux_sum_comp`. To be filled
  by iter-099 prover with `intro r y; rw [Preadditive.sum_comp];
  exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂
  hG r y` (~3 lines).

## Compilation Status

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: compiles
  (severity=error diagnostics: `[]`). Total sorry tactic sites in
  the file post-refactor: 7 (L532, L695, L787, L1111, L1139, L1329,
  L1358) — matches the directive's expected outcome (was 6 pre-iter-098,
  now 7). The line shift from iter-097's listed sorry positions
  (L657, L749, L1073, L1101, L1291, L1320) to the post-insertion
  positions (L695, L787, L1111, L1139, L1329, L1358) reflects the
  ~38-line addition between L494 and L496 (docstring + signature +
  `sorry` body).
- `alternating_sum_pi_smul_aux` (L462–L494): unchanged, still has the
  iter-097-filled body. Confirmed via Read of L490–L494.
- `cechCofaceMap_pi_smul` (now L534-onward, was L496): unchanged
  body. L657 trailing sorry (now at L695) preserved.

## Notes for Plan Agent

- The new lemma compiles cleanly with one `sorry` warning (as
  expected). No new axioms; no protected-declaration touches; no
  blueprint changes.
- The mathematical justification in the directive was sufficient.
  The signature was given verbatim, so no judgment calls were
  required on parameter ordering, universe annotations, or instance
  brackets.
- Suggested iter-099 prover plan (mirrors the directive's "Expected
  Outcome" Step 2):
  1. Close L532 (`alternating_sum_pi_smul_aux_sum_comp` body) with
     the 3-line proof above. This is the structural prerequisite.
  2. Close L695 (former L657) inside `cechCofaceMap_pi_smul` by
     `refine alternating_sum_pi_smul_aux_sum_comp Z₁ ?Z_int Z₂
     Finset.univ ?G ?E e₁ e₂ ?hG r y` (or `exact` with explicit
     instantiation), with `?E := eqToHom`. The iter-097 B1 bridge
     `simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply]` at L656
     may need reversal; the iter-099 prover should diagnose on the
     post-bridge goal first and only revert if the goal shape
     prevents the new lemma's application.
- The post-iter-098 sorry analyzer should report 7 sorries in
  `BasicOpenCech.lean`. Line numbers for the iter-099 directive:
  use `sorry_analyzer.py` or `lean_goal` to confirm L532 and L695
  positions before assigning the prover.
