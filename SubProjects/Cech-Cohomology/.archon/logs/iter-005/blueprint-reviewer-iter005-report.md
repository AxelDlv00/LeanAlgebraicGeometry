# Blueprint Review Report

## Slug
iter005

## Iteration
005

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis`: proof block explicitly declares "The general basis-comparison criterion for sheaves of modules on a scheme is not yet available in Mathlib and is recorded here as a to-build dependency." No proof sketch exists beyond this admission — the block is incomplete. This is the documented P3 standard-cover-vs-general-cover blocker.
- `Cohomology_CechHigherDirectImage.tex` / `lem:affine_serre_vanishing`: blocked by `lem:cech_to_cohomology_on_basis` (direct `\uses{}` dependency; cannot formalize until the basis-comparison gap is closed).

### Proofs lacking detail

- `Cohomology_AcyclicResolution.tex` / `lem:horseshoe_twist` proof block: the citation "\(d_A^{n+1} \circ d_A^n \circ \tau^{n-1} = 0\) (exactness of \(I_C\) at degree \(n\), Lemma~\ref{lem:right_derived_injective_resolution})" is doubly imprecise. (a) The computation uses \(d_A^2 = 0\) (i.e.\ \(I_A\) is a cochain complex), not "exactness of \(I_C\)". (b) Even granting that I_C exactness is intended, `lem:right_derived_injective_resolution` (`isoRightDerivedObj`) does not state it — the Lean fact needed is `InjectiveResolution.exact` (exactness is part of the `InjectiveResolution` API). A prover following the citation to `isoRightDerivedObj` will look in the wrong place. The mathematical content of the proof is correct; this is a reference-precision issue.

### Dependency & isolation findings

- 14 lean_aux isolated nodes (no blueprint coverage, no edges). These are already-proved helper declarations:
  - `CategoryTheory.Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic`
  - `CategoryTheory.Functor.rightDerivedShiftIsoOfSplitResolutionSES`
  - `CategoryTheory.shortExact_map_mapHomologicalComplex_of_degreewise_splitting`
  - `CategoryTheory.shortExact_of_degreewise_splitting`
  - Plus 10 `AlgebraicGeometry.*` push-pull helpers (`pushPullMap_eq_raw`, `pushPull_pentagon`, `rawPushPullMap*`, etc.)
  - All 14 are type `lean_aux` (zero blueprint nodes isolated). Disposition: **keep** for the four iter-004 decls (already-proven substantive helpers; planner is deferring their coverage to next iter per directive); **keep** for the push-pull helpers (unconditional building blocks with coverage deferred). No wire-up or remove action warranted this iter.

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Known artifact (will auto-resolve).** `lem:injective_resolution_of_ses` carries `\leanok` on both statement and proof blocks. Per directive this is a `sync_leanok` false-positive caused by a backtick code-fence in the `.lean` strategy comment (now reformatted by the iter-005 `refactor`). `CategoryTheory.InjectiveResolution.ofShortExact` does not exist as a Lean declaration (`lean_verify`: unknown). The `% NOTE (iter-004 review)` comment in the chapter documents this. The next `sync_leanok` run will strip both false markers automatically. **Do not count as a live content must-fix.**
  - **\mathlibok anchor verified — FAITHFUL.** `lem:horseshoe_biprod_injective` / `CategoryTheory.Injective.instBiprod`: confirmed in `Mathlib.CategoryTheory.Preadditive.Injective.Basic`. Type: `[Injective P] → [Injective Q] → Injective (P ⊞ Q)`. Matches the blueprint statement exactly.
  - **\mathlibok anchor verified — FAITHFUL.** `lem:horseshoe_degree_split` / `CategoryTheory.ShortComplex.Splitting.ofHasBinaryBiproduct`: confirmed in `Mathlib.Algebra.Homology.ShortComplex.Exact` (Loogle result). Type: produces a `Splitting` on the short complex `X₁ → X₁ ⊞ X₂ → X₂` with `f = biprod.inl` and `g = biprod.snd`. Blueprint writes "coprojection `ιₚ`" and "projection `πQ`" which map exactly to `biprod.inl` and `biprod.snd`. Faithful.
  - **Concern 1 answer: 3-way re-break NOT required.** `lem:horseshoe_twist`'s proof sketch is detailed enough to formalize without further decomposition. The augmentation construction is explicit; the inductive step's key computation (showing `-d_A^{n+1} ∘ τ^n` annihilates `ker(d_C^n)` via the previous-stage cocycle identity plus `d^2 = 0`, followed by injectivity-based factorization) is fully worked out. A prover can follow it directly. However, see the "proofs lacking detail" finding above regarding the wrong citation for one sub-step.
  - **[soon] Imprecise citation in `lem:horseshoe_twist` proof.** The `\uses{lem:right_derived_injective_resolution}` in the proof block is the wrong anchor for the "exactness" step; see "Proofs lacking detail" above. The proof logic is sound; the misdirection affects only which Lean API call the prover reaches for.
  - **[informational] Spurious `\uses` edge on `lem:horseshoe_stage_mono`.** Both the statement and proof blocks carry `\uses{lem:horseshoe_biprod_injective}`. The stage-mono lemma takes P injective as an explicit hypothesis — the biproduct-injective result is not logically required by the lemma or its proof. Since `lem:horseshoe_biprod_injective` is a Mathlib anchor (no project dispatch), there is zero out-of-order dispatch risk. Informational only.
  - **[informational] Carry-forward coverage debt.** Four iter-004 proved decls in `AcyclicResolution.lean` remain `lean_aux` isolated nodes: `isZero_homology_mapHomologicalComplex_of_isRightAcyclic`, `shortExact_of_degreewise_splitting`, `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`, `rightDerivedShiftIsoOfSplitResolutionSES`. None gate the horseshoe prover (already proved). Planner deferred their blueprint coverage per directive.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **P3 blocker (pre-existing, documented).** `lem:cech_to_cohomology_on_basis` proof ends with "The general basis-comparison criterion for sheaves of modules on a scheme is not yet available in Mathlib and is recorded here as a to-build dependency." This is the standard-cover-vs-general-cover gap the directive names as the P3 blocker. The chapter correctly documents the gap; no blueprint-writer action can resolve it until a Mathlib lane delivers the basis-comparison criterion. Plan agent should record an explicit deferral in `iter/iter-005/plan.md` rather than dispatching a writer.
  - **`lem:affine_serre_vanishing` blocked.** Direct `\uses{lem:cech_to_cohomology_on_basis}` dependency; cannot be formalized until the basis-comparison gap is closed.
  - **[informational] Leray spectral sequence in `lem:open_immersion_pushforward_comp`.** The proof of part (2) invokes the "relative Leray spectral sequence" for the composition `g = f ∘ j`. No `\lean{}` pointer to a Mathlib spectral-sequence lemma is given. This is part of the wider P3 formalization challenge; the blueprint prose is faithful to the Stacks argument.
  - All other blocks (`def:cech_nerve`, `def:cech_complex`, `def:cover_arrow`, `def:cover_cech_nerve`, `def:push_pull_obj`, `def:push_pull_map`, `def:push_pull_functor`, `def:cech_nerve_cosimplicial`, `def:relative_cech_complex_of_nerve`, `lem:push_pull_id`, `lem:push_pull_comp`, `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`, `lem:cech_augmented_resolution`, `lem:cech_term_pushforward_acyclic`, `lem:higher_direct_image_presheaf`, `lem:cech_computes_cohomology`) are mathematically correct and have adequate proof sketches for their formalization roles.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

## Severity summary

- **must-fix-this-iter**:
  - `Cohomology_CechHigherDirectImage.tex` is `complete: partial` due to the documented P3 blocker. Per the HARD GATE rule every chapter with partial completeness is must-fix. **Recommended plan-agent action:** record an explicit one-line deferral in `iter/iter-005/plan.md` (e.g., "P3 prover deferred: `lem:cech_to_cohomology_on_basis` awaits Mathlib basis-comparison criterion; no writer action can resolve this") rather than dispatching a blueprint-writer. The chapter is otherwise correct; no content rewrite is needed.

- **soon**:
  - `Cohomology_AcyclicResolution.tex` / `lem:horseshoe_twist` proof: citation to `lem:right_derived_injective_resolution` for I_A/I_C exactness is imprecise. Prover should use `InjectiveResolution.exact` (or analogous `HomologicalComplex.exact_at`) in Lean, not `isoRightDerivedObj`. Recommend a one-line `% NOTE:` annotation on the proof block to redirect the prover.

- **informational**:
  - `Cohomology_AcyclicResolution.tex` / `lem:horseshoe_stage_mono`: spurious `\uses{lem:horseshoe_biprod_injective}` in statement + proof; no dispatch ordering risk.
  - 14 `lean_aux` isolated nodes (carry-forward coverage debt for already-proved helpers). Plan agent has explicitly deferred their blueprint coverage.
  - `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp`: Leray spectral sequence invoked without a Lean pointer; part of P3 challenge, not a new gap.

**Overall verdict:** `Cohomology_AcyclicResolution.tex` passes the HARD GATE (`complete: true`, `correct: true`, both `\mathlibok` anchors faithful, all 7 horseshoe sub-lemmas mathematically correct and proof-sketch adequate) — P4 prover may be dispatched. `Cohomology_CechHigherDirectImage.tex` is `complete: partial` per the pre-existing documented P3 blocker; plan agent should record an explicit deferral rather than dispatching a writer. No unstarted phases — all three remaining phases (P4, P3, P5) have blueprint coverage.
