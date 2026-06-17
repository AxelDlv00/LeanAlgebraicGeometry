# Blueprint Review Report

## Slug
iter002-rereview

## Iteration
002

## Top-level summaries

### Citation discipline

- `Cohomology_CechHigherDirectImage.tex` / `lem:higher_direct_image_presheaf`: missing `% SOURCE QUOTE PROOF:`. The proof at lines 793–805 closely parallels the Stacks source proof at `references/stacks-cohomology.tex` L605–616 (same "choose injective resolution → cohomology sheaf is sheafification of presheaf" argument). Not feeding the P1 active prover route.

### Dependency & isolation findings

All 4 isolated nodes in `leandag show isolated` are `lean_aux` nodes (not blueprint nodes); no isolated blueprint nodes. `leandag build --json` reports 0 `unknown_uses` (no broken `\uses{}`). 15 `unmatched_lean` entries are expected per directive (AcyclicResolution.lean does not exist yet; CechHigherDirectImage.lean provers in progress). No `leandag` findings require action.

### Lean difficulty quality

- `Cohomology_AcyclicResolution.tex` / `lem:homology_long_exact_sequence`: `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₃}` is marked `\mathlibok`, but the declared form ("assembles into a long exact sequence for every degree n") is **stronger** than what `homology_exact₃` alone provides. `homology_exact₃` asserts exactness at only **one position** of the LES: the ShortComplex `H^n(X₂) → H^n(X₃) →^δ H^{n+1}(X₁)` is exact. The full LES requires all three Mathlib lemmas: `homology_exact₁` (exactness at H^n(X₁) after the connecting map), `homology_exact₂` (exactness at H^n(X₂)), and `homology_exact₃`. All three exist in Mathlib at `Mathlib.Algebra.Homology.HomologySequence`. The stated form is stronger than the single named declaration → **unfaithful `\mathlibok` anchor** → must-fix per rules.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Patch 1 (`lem:cech_to_cohomology_on_basis`) — VERIFIED CLEAN.** `% SOURCE QUOTE:` from Stacks Tag 01EO `lemma-cech-vanish-basis` (stacks-cohomology.tex L1695–1714) is now present and verified verbatim against the reference. `% SOURCE:` names `references/stacks-cohomology.tex` (file exists). `\textit{Source:}` line present. `% SOURCE QUOTE PROOF:` inside statement block documents the application-context proof (stacks-coherent.tex L157–173, verified). Citation is complete.
  - **Patch 2 (`lem:cech_term_pushforward_acyclic`) — VERIFIED CLEAN.** Two new declarations added and wired into `\uses{}`:
    - `lem:higher_direct_image_presheaf` (Tag 01XJ, stacks-cohomology.tex L591–603): `% SOURCE QUOTE:` matches reference verbatim. `\textit{Source:}` present. `\uses{def:higher_direct_image}` ✓. **Missing `% SOURCE QUOTE PROOF:`** (proof parallels source; soon severity — not on P1 route).
    - `lem:open_immersion_pushforward_comp` (stacks-coherent.tex L180–199 + stacks-cohomology.tex L2295–2306): two `% SOURCE QUOTE:` blocks present, both verified verbatim. `\textit{Source:}` present. Proof is an Archon-original synthesis; `% SOURCE QUOTE PROOF:` not required. `\uses{lem:affine_serre_vanishing, lem:higher_direct_image_presheaf}` ✓.
    - `lem:cech_term_pushforward_acyclic` statement and proof `\uses{}` both list `{lem:affine_serre_vanishing, def:cech_nerve, lem:higher_direct_image_presheaf, lem:open_immersion_pushforward_comp}` ✓. `% SOURCE QUOTE PROOF:` present (stacks-coherent.tex relative-affine-vanishing argument). Dependency wiring complete.
  - **Push–pull sub-graph (`lem:push_pull_comp` and predecessors) — CLEAN AND UNTOUCHED.** `lem:push_pull_comp` `\uses{def:push_pull_obj, def:push_pull_map, lem:push_pull_unit_mate, lem:push_pull_transport_cancel}`. All four labels exist and have `\lean{}` hints. Proof sketch references `conjugateEquiv_comp`, `pseudofunctor_associativity`, and the two supporting lemmas as expected. No `unknown_uses`. Sub-graph is complete and clean.
  - **P1 HARD GATE: CLEARS.** `Cohomology_CechHigherDirectImage.tex` is `complete: true` AND `correct: true`. No must-fix finding touches any node on the P1 prover route. The sole finding (missing `% SOURCE QUOTE PROOF:` on `lem:higher_direct_image_presheaf`) is soon-severity and does not feed P1.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **`lem:homology_long_exact_sequence` — unfaithful `\mathlibok` anchor (must-fix).** The block is marked `\mathlibok` with `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₃}` and describes "a long exact sequence of homology objects for every degree n". `homology_exact₃` EXISTS in Mathlib (`Mathlib.Algebra.Homology.HomologySequence`, confirmed by grep in `.lake/packages/mathlib/`), but it asserts only ONE of the three exactness positions: `(ShortComplex.mk _ _ (comp_δ hS i j hij)).Exact`, i.e. exactness at H^n(X₃) in the triple `H^n(X₂) → H^n(X₃) →^δ H^{n+1}(X₁)`. The full LES requires also `homology_exact₁` (exactness at H^j(X₁)) and `homology_exact₂` (exactness at H^i(X₂)), both of which exist in the same Mathlib module. The stated form (full LES for all n) is strictly stronger than what `homology_exact₃` alone provides. Per hard rule: unfaithful `\mathlibok` anchor where stated form is stronger than the named Mathlib declaration → **must-fix**. Recommended fix: replace the single `\lean{}` name with a note that the full LES is assembled from `homology_exact₁`, `homology_exact₂`, and `homology_exact₃` (three separate `\mathlibok` sub-blocks, or one block with all three names listed in `\lean{}` / annotated in prose). P4 is NOT active this iter so this does not block current prover work, but it must be resolved before iter-003 can scaffold `AcyclicResolution.lean`.
  - **Other `\mathlibok` anchors — ALL VERIFIED.** `lem:right_derived_injective_resolution` → `CategoryTheory.InjectiveResolution.isoRightDerivedObj` (confirmed by leansearch). `lem:right_derived_vanishes_injective` → `CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ` (confirmed). `lem:right_derived_zero_iso_self` → `CategoryTheory.Functor.rightDerivedZeroIsoSelf` (confirmed; Mathlib form requires `PreservesFiniteLimits F`, blueprint says "left exact (preserves finite limits)" — consistent). All three forms match.
  - **`lem:injective_resolution_of_ses` (to-build) — sound.** `\lean{CategoryTheory.InjectiveResolution.ofShortExact}` is NOT in Mathlib (grep confirmed empty); no `\mathlibok` marker. Correctly treated as to-build. Horseshoe proof sketch is detailed and mathematically sound. Unmatched_lean status is expected per directive.
  - **SOURCE QUOTEs verified.** `def:right_acyclic` quotes from homological-acyclic-derived.tex L5264–5269 and L5594–5617 — verbatim match. `lem:acyclic_dimension_shift` from L5619–5637 — verbatim match. `lem:acyclic_resolution_computes_derived` from L5693–5704 and L5791–5810 — verbatim match (footnote correctly omitted). All `references/homological-acyclic-derived.tex` parentheticals name a file that exists on disk.
  - **`correct: partial` — iter-003 cannot scaffold `AcyclicResolution.lean` until the `homology_long_exact_sequence` anchor is corrected.**

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

---

## Severity summary

**must-fix-this-iter:**

1. `Cohomology_AcyclicResolution.tex` / `lem:homology_long_exact_sequence`: unfaithful `\mathlibok` anchor — `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₃}` captures only one-third of the stated LES. Fix by expanding to all three Mathlib lemmas (`homology_exact₁`, `homology_exact₂`, `homology_exact₃`) or annotating the form accurately. **Does not block any active prover this iter (P4 deferred).**

**soon:**

1. `Cohomology_CechHigherDirectImage.tex` / `lem:higher_direct_image_presheaf`: missing `% SOURCE QUOTE PROOF:`. Proof closely follows stacks-cohomology.tex L605–616. Add a verbatim proof quote before the `\begin{proof}` block. Not on the P1 active prover route.

Overall verdict: The P1 HARD GATE CLEARS — `Cohomology_CechHigherDirectImage.tex` is `complete: true` and `correct: true` with no must-fix finding on any P1-route node; both patched nodes are now citation-complete and dependency-complete. `Cohomology_AcyclicResolution.tex` remains `correct: partial` due to an unfaithful `\mathlibok` anchor (`homology_long_exact_sequence` states a full LES but names only `homology_exact₃`); iter-003 cannot scaffold `AcyclicResolution.lean` until this is patched. 3 chapters audited, 2 findings, 0 unstarted-phase proposals.
