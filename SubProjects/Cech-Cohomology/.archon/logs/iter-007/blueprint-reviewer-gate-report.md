# Blueprint Review Report

## Slug
gate

## Iteration
007

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` / P5a–P5b: five project declarations have `\lean{}` hints but no matching Lean implementations yet — `lem:affine_serre_vanishing`, `lem:cech_to_cohomology_on_basis`, `lem:cech_augmented_resolution`, `lem:higher_direct_image_presheaf`, `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`. Known-deferred build dependencies.
- `Cohomology_CechHigherDirectImage.tex` / P3: `lem:cech_acyclic_affine` blueprint proves the standard-cover case; Lean signature (`CechAcyclic.affine`) takes a general `X.OpenCover`. Known-deferred statement gap.
- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis` proof explicitly self-flags as a to-build dependency: "The general basis-comparison criterion for sheaves of modules on a scheme is not yet available in Mathlib."

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp` proof: invokes the "relative Leray spectral sequence" (citing `lemma-relative-Leray` from Stacks Cohomology Tag 01XJ context) for the degeneration argument — this spectral sequence is absent from Mathlib. The proof sketch is sufficient as informal blueprint text but cannot be directly formalized against the current Mathlib state. Known-deferred (P5a/P5b).
- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis` proof: reduction via a "Čech-to-derived-functor spectral sequence" (generic sheaf-theory argument). Not yet in Mathlib. Same deferral status.

### Multi-route coverage

- **Route A (acyclic-resolution comparison, CHOSEN)**: PASS — `Cohomology_AcyclicResolution.tex` covers the abstract P4 lemma in full; `Cohomology_CechHigherDirectImage.tex` covers the geometric P3/P5 inputs and the assembly. Cross-chapter dependency `lem:acyclic_resolution_computes_derived` (referenced by `lem:cech_computes_cohomology`) is correctly wired.
- **Route B (spectral sequences, REJECTED)**: PASS — no blueprint coverage expected or present per directive.

### Citation discipline

All new P4 focus-area blocks pass:
- `lem:cosyzygy_ses`, `lem:acyclic_one_iso_coker`, `lem:applied_cosyzygy_cycles`, `lem:cohomology_of_applied_resolution`, `lem:acyclic_resolution_computes_derived`: each has a `% SOURCE:` with `(read from references/homological-acyclic-derived.tex)` (file exists on disk), `% SOURCE QUOTE PROOF:` with verbatim Stacks text (English, matching Stacks notation), and a `\textit{Source:}` prose line. For blocks where the statement is Archon-synthesized from a Stacks proof (no directly quotable named statement), the absence of `% SOURCE QUOTE:` for the statement is correct — only `% SOURCE QUOTE PROOF:` is attached.
- `lem:quasiIso_tau2`, `lem:right_derived_shift_split_resolution`: project-bespoke supplements, no source block — correct per directive.

### Dependency & isolation findings

- `leandag build --json`: `unknown_uses: []` — zero broken `\uses{}` references. ✓
- `unmatched_lean`: 20 entries. 10 are `\mathlibok` nodes (scanned against project Lean files only; these are Mathlib declarations, expected unmatched). 10 are project declarations not yet formalized — 5 are P4 staircase targets for this iter's prover, 5 are P5a/P5b deferred targets. All expected.
- `isolated`: 22 nodes, **all `lean_aux` type, 0 blueprint nodes isolated**. These are uncovered Lean helper declarations (internal to the proof machinery); not removal candidates. **keep-informational** for all 22 — no blueprint entry is missing for any blueprint goal, and all are proven (`effort 0 ✓`).

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:acyclic_resolution_computes_derived`: `\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}` is not yet a project Lean declaration — confirmed absent from `AcyclicResolution.lean`, this iter's build target. Expected per directive.
  - `lem:quasiIso_tau2` (`HomologicalComplex.HomologySequence.quasiIso_τ₂`): confirmed present in `AcyclicResolution.lean` line 89 in namespace `HomologicalComplex.HomologySequence`. Coverage-debt block wired correctly; `\uses{lem:homology_long_exact_sequence}` is accurate.
  - `lem:right_derived_shift_split_resolution` (`CategoryTheory.Functor.rightDerivedShiftIsoOfSplitResolutionSES`): confirmed present at line 224 inside `namespace CategoryTheory`. Coverage-debt block wired correctly; `\uses{}` accurate.
  - New staircase blocks (`lem:cosyzygy_ses`, `lem:acyclic_one_iso_coker`, `lem:applied_cosyzygy_cycles`, `lem:cohomology_of_applied_resolution`): all have complete statement + detailed proof sketch sufficient for direct formalization. `\uses{}` edges consistent with proof dependency structure. No missing edges detected.
  - Assembly theorem `lem:acyclic_resolution_computes_derived`: staircase argument correctly decomposes into (1) `lem:cosyzygy_ses` cosyzygy SES with acyclic middle, (2) `lem:acyclic_dimension_shift` iterated `n−1` times collapsing `(R^n G)(A)` to `(R^1 G)(Z^{n−1})`, (3) `lem:acyclic_one_iso_coker` converting to a cokernel, (4) `lem:cohomology_of_applied_resolution` identifying that cokernel with `H^n(G(J•))`. Degree-0 case handled separately via `lem:cohomology_of_applied_resolution`. Logic complete and sound.
  - Mathlib `\mathlibok` anchors spot-checked: `CategoryTheory.Injective.instBiprod` (biproduct of injectives is injective) and `CategoryTheory.ShortComplex.Splitting.ofHasBinaryBiproduct` (canonical biproduct splitting) both verified to exist in Mathlib with expected signatures via `lake env lean`. `Functor.isZero_rightDerived_obj_injective_succ` and `InjectiveResolution.isoRightDerivedObj` are both used directly in `AcyclicResolution.lean` (lines 162, 185), confirming their presence. Other `\mathlibok` names (`rightDerivedZeroIsoSelf`, `ShortComplex.ShortExact.homology_exact₁/₂/₃, δ`) marked "verified present" in directive.
  - **HARD GATE for P4 prover lane (`AcyclicResolution.lean`) CLEARS.**

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - P3 statement gap (known-deferred): `lem:cech_acyclic_affine` blueprint proves the standard-cover case with a prime-local contracting homotopy; the Lean declaration `AlgebraicGeometry.CechAcyclic.affine` has a general `X.OpenCover` signature. Narrowing the Lean signature to standard covers (downstream-safe via the P5a basis lemma) is the known fix.
  - P5a vanishing inputs (known-deferred): `lem:affine_serre_vanishing` (`AlgebraicGeometry.affine_serre_vanishing`), `lem:cech_to_cohomology_on_basis` (`AlgebraicGeometry.cech_eq_cohomology_of_basis`), `lem:cech_augmented_resolution` (`AlgebraicGeometry.cechAugmented_exact`), `lem:higher_direct_image_presheaf` (`AlgebraicGeometry.higherDirectImage_isSheafify_presheafCohomology`), `lem:open_immersion_pushforward_comp` (`AlgebraicGeometry.higherDirectImage_openImmersion_comp`), `lem:cech_term_pushforward_acyclic` (`AlgebraicGeometry.cechTerm_pushforward_acyclic`) all have `\lean{}` hints pointing at absent project declarations.
  - Proof of `lem:cech_to_cohomology_on_basis` invokes a Čech-to-derived spectral sequence absent from Mathlib; self-flagged in text as "to-build dependency." Proof of `lem:open_immersion_pushforward_comp` invokes the relative Leray spectral sequence (`lemma-relative-Leray`), also absent from Mathlib. Both are P5a/P5b known-deferred.
  - Push-pull functor declarations (`def:push_pull_functor`, `def:cech_nerve_cosimplicial`) lack `\leanok` — awaiting next `sync_leanok` run or prover completion.
  - Assembly `lem:cech_computes_cohomology` correctly wires `lem:cech_augmented_resolution` and `lem:cech_term_pushforward_acyclic` as the two hypotheses for `lem:acyclic_resolution_computes_derived`. Once the P5a inputs are proven, the assembly logic is complete.
  - **This chapter's partial status is known-deferred per directive.** Plan agent should record an explicit one-line deferral rationale in `iter/iter-007/plan.md` (P5a/P5b blocked on absent Mathlib facts; P3 statement gap being narrowed via basis-lemma route). This partial does NOT gate the P4 prover dispatch to `AcyclicResolution.lean`.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

## Severity summary

**Must-fix-this-iter:**
- `Cohomology_CechHigherDirectImage.tex` is `partial/partial` — plan agent must record an explicit deferral rationale in `iter/iter-007/plan.md` (not writer-fixable this iter: P3/P5a/P5b blocked on absent Mathlib facts). No new blueprint-writer dispatch required; the chapter text is mathematically sound up to the known Mathlib gaps.

**Informational:**
- 22 isolated `lean_aux` nodes in `AcyclicResolution.lean` — uncovered Lean helper declarations proven inline; no blueprint entry is required for any of them. Disposition: **keep** for all.

**Overall verdict:** HARD GATE CLEARS for `AcyclicResolution.lean` P4 prover dispatch — `Cohomology_AcyclicResolution.tex` is complete and correct with all new staircase blocks properly sourced and detailed; plan agent must record a deferral for `Cohomology_CechHigherDirectImage.tex`'s known-deferred P3/P5 partial status. 3 chapters audited, 1 must-fix (deferral-only), 0 unstarted-phase proposals.
