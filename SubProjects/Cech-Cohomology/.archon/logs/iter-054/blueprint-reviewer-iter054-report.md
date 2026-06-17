# Blueprint Review Report

## Slug
iter054

## Iteration
054

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp`: proof uses `f_* ∘ j_* = (f∘j)_*`; the `\mathlibok` node `lem:pushforwardPushforwardEquivalence_mathlib` is the natural anchor for this fact but is absent from the block's `\uses{}`. **wire-up** — add `\uses{lem:pushforwardPushforwardEquivalence_mathlib}` to statement and proof `\uses{}`. Severity: **soon** (node is `\mathlibok`; no dispatch ordering risk since nothing waits to be proved).

- `Isolated lean_aux node` (`lean:Alg…`): a `lean_aux` node with no blueprint entry and no uses. **keep** — not a blueprint node; infrastructure-side isolated declaration.

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Focus gate — `CechAugmentedResolution.lean` (`lem:cech_augmented_resolution`).** Prior gap (Step-3 mechanism under-specified) is closed. Proof now has substeps (a)–(e):
    - (a) Residual obligation precisely stated (homology of section complex over `V ⊆ U_{i_fix}` is zero).
    - (b) Abstract-to-concrete identification of the evaluated complex named via `lem:cech_free_eval_sectionwise` / `lem:cech_free_eval_engine_iso`.
    - (c) Contracting homotopy built from `combHomotopy i_fix` / `combHomotopy_spec` (Lean names spelled out; references `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec`).
    - (d) Homotopy → IsZero mechanism described conceptually and correctly. **Mild informational gap**: the specific Lean API names `Homotopy.homologyMap_eq`, `homologyMap_id`, `homologyMap_zero`, `IsZero.iff_id_eq_zero` are not spelled out in the text (the mechanism is described in prose: "by homotopy-invariance … the identity equals the zero map … criterion for zero object"). A prover can find these via Mathlib search; the mechanism is unambiguous.
    - (e) ExtraDegeneracy dead-end documented (wrong variance — simplicial vs. cosimplicial). Prevents wasted prover effort.
    - New helpers `lem:isZero_of_faithful_preservesZeroMorphisms` and `lem:isZero_presheafToSheaf_of_locally_isZero` are present in both blueprint and Lean (confirmed: declarations exist in `CechAugmentedResolution.lean`). `\uses{}` edges are correct.
  - **Focus gate — `OpenImmersionPushforward.lean` (`lem:open_immersion_pushforward_comp`).** Prior gap (bridges under-specified) is closed. Proof now has three labeled bridges:
    - **Bridge (1)**: Names `lem:ext_homcomplex_mathlib` anchor for the Ext ↔ Hom-complex cohomology chain (`extAddEquivCohomologyClass` + `homologyAddEquiv` + `cochainComplexXIso`). Corepresentability step described as `jShriekOU ⊣ Γ(U,−)` functionally (no Lean name by literal string in the bridge text, but `jShriekOU_homEquiv` was verified present earlier in the chapter at lines 2923, 3137).
    - **Bridge (2)**: Affine-preimage transport described (canonical iso `j⁻¹(V) ≅ Spec Γ(j⁻¹(V), O)`) correctly; `isoSpec` not named by Lean name — findable.
    - **Bridge (3)**: `PresheafOfModules.sheafificationCompToSheaf` square named; references `lem:sheafify_kills_locally_zero` and `lem:isZero_presheafToSheaf_of_locally_isZero`.
  - **`lem:ext_homcomplex_mathlib` `\mathlibok` anchor.** New optional anchor. All three Lean declarations verified to exist in Mathlib via `lean_run_code`:
    - `CategoryTheory.InjectiveResolution.extAddEquivCohomologyClass` ✓ (`Ext X Y n ≃+ CohomologyClass ((singleFunctor C 0).obj X) R.cochainComplex n`)
    - `CochainComplex.HomComplex.homologyAddEquiv` ✓ (`homology (K.HomComplex L) n ≃+ CohomologyClass K L n`)
    - `CategoryTheory.InjectiveResolution.cochainComplexXIso` ✓ (`R.cochainComplex.X n ≅ R.cocomplex.X k` for `k = n`, matching N↔Z indexing)
    - The stated form matches the anchor description exactly. `\uses{lem:right_derived_injective_resolution}` is appropriate.
  - **`leandag` audit.** `unknown_uses: []` — no broken `\uses{}` edges. All 52 `unmatched_lean` entries are either `\mathlibok` nodes (Mathlib-only declarations, expected) or project stubs not yet written (e.g., `cechTerm_pushforward_acyclic` — a future proof obligation not in the current iteration's targets). Zero isolated blueprint nodes.
  - **Blueprint-doctor.** `malformed_refs: []`, `broken_refs: []`, `covers_problems: []`, `axiom_decls: []` — fully clean.
  - **Soon finding.** `lem:open_immersion_pushforward_comp` proof uses `f_* ∘ j_* = (f∘j)_*`; `lem:pushforwardPushforwardEquivalence_mathlib` (a `\mathlibok` block at line 3965) is the natural `\uses{}` target for this step but is absent from the statement and proof `\uses{}`. Wire-up: add `\uses{lem:pushforwardPushforwardEquivalence_mathlib}` to both `\uses{}` entries of `lem:open_immersion_pushforward_comp`. No dispatch ordering risk (node is `\mathlibok`; no proof obligation to wait on).

## Severity summary

Severity summary: **HARD GATE CLEARS** — 0 must-fix-this-iter findings.

**soon (1)**:
- `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp`: missing `\uses{lem:pushforwardPushforwardEquivalence_mathlib}` for the `f_* ∘ j_* = (f∘j)_*` step. Wire-up after current prover round; no dispatch ordering risk.

**informational (1)**:
- `lem:cech_augmented_resolution` step (d): the Lean API names `Homotopy.homologyMap_eq`, `homologyMap_id`, `homologyMap_zero`, `IsZero.iff_id_eq_zero` are described conceptually but not spelled out by Lean identifier. Mechanism is mathematically unambiguous and findable; does not impede formalization.

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is complete and correct; the iter-053 gaps (Step-3 homotopy mechanism for `lem:cech_augmented_resolution`, and open-immersion bridges for `lem:open_immersion_pushforward_comp`) are now closed to formalization-grade detail; the new `\mathlibok` anchor `lem:ext_homcomplex_mathlib` is faithful (all three Mathlib declarations verified present); HARD GATE CLEARS for both `CechAugmentedResolution.lean` and `OpenImmersionPushforward.lean`. All three strategy phases have adequate blueprint coverage; no unstarted-phase proposals required.
