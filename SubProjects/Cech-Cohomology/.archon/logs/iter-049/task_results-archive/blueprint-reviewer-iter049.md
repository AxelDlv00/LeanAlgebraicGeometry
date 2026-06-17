# Blueprint Review Report

## Slug
iter049

## Iteration
049

---

## Top-level summaries

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_augmented_resolution`: proof sketch takes the "section-over-affines" approach — "over a refinement on which the cover restricts to a standard cover U = ∪D(fᵢ)" — but does not name the lemma giving this refinement or bridge the section-vs-sheaf gap.  The Stacks source quote (also present in the block) uses the stalk-at-prime criterion instead, which is cleaner and avoids the issue.  The sketch gives correct mathematical intuition but a prover who follows the blueprint path literally will hit an undocumented step; the Stacks quote is the reliable fallback.  **Severity: soon** (prover can use Stacks; not a dispatch blocker).

### Dependency & isolation findings

- `lean_aux` isolated node (1 node, lean_aux type, no impact=0): uncovered Lean helper with no blueprint block.  **Disposition: keep** — `lean_aux` nodes are Lean helpers with no blueprint obligation; not a correctness signal.
- `leandag show gaps` reports 4 nodes without a matched `\lean{}` declaration in the project scan; spot-check confirms these are either multi-name `\lean{}` entries whose primary name is unmatched (expected during in-progress phases) or truncation artefacts.  Not a correctness finding — all cited `\lean{}` targets are coherent with the Lean files described in STRATEGY.md.

### Lean difficulty quality

*(nothing to flag — all `\lean{}` targets in the three active dispatch lanes are well-formulated and match confirmed or in-progress Lean declarations)*

---

## Focus area verdicts — the three iter-049 dispatch targets

### 1. `lem:affine_cech_vanishing_qcoh` (line 6045, `AlgebraicGeometry.affine_cech_vanishing_qcoh`)

**Blueprint ready: YES — GATE CLEARS.**

- **Statement**: faithful to Stacks 02KG condition (3): "for every standard cover 𝒰 and every p > 0, Ȟᵖ(𝒰, ℱ) = 0."  Source quote present (`references/stacks-coherent.tex`, L172–173).  Visible `\textit{Source:}` line present and consistent with `% SOURCE:` pointer.
- **Proof sketch**: adequate for formalization — (i) use `lem:qcoh_iso_tilde_sections` to identify ℱ ≅ ~M; (ii) apply `lem:cech_acyclic_affine` to ~M (standard-cover vanishing for tilde sheaves, P3 complete); (iii) transport along the isomorphism.  Three-step path, each step a named lemma.
- **`\uses{}`**: `{lem:cech_acyclic_affine, lem:qcoh_iso_tilde_sections, lem:qcoh_isIso_fromTildeGamma, def:affine_cover_system, def:has_vanishing_higher_cech}` — all five deps have blueprint blocks; `lem:qcoh_isIso_fromTildeGamma` is `\leanok` (iter-048); `def:affine_cover_system` and `def:has_vanishing_higher_cech` are `\leanok`; `lem:cech_acyclic_affine` (`sectionCech_affine_vanishing`) and `lem:qcoh_iso_tilde_sections` are not yet `\leanok` in the blueprint but both Lean declarations exist (P3 complete per STRATEGY.md "Completed", iter-022) — this is a `sync_leanok` lag, not a mathematical gap.
- **Note on unconditional use of `lem:qcoh_iso_tilde_sections`**: the declaration is the conditional form (requires `[IsIso F.fromTildeΓ]`); `lem:qcoh_isIso_fromTildeGamma` (now `\leanok`) provides the instance for quasi-coherent F.  The consumer correctly lists both in `\uses{}`; the dependency graph is accurate.
- **Citation discipline**: complete — `% SOURCE:` with parenthetical naming `references/stacks-coherent.tex`, `% SOURCE QUOTE:`, `\textit{Source:}` all present.

### 2. `lem:affine_serre_vanishing` (line 3206, `AlgebraicGeometry.affine_serre_vanishing`)

**Blueprint ready: YES — GATE CLEARS (dispatch sequentially after target 1).**

- **Statement**: faithful to Stacks 02KG main lemma: `Hᵖ(U, ℱ) = 0` for all p > 0, U affine, ℱ quasi-coherent.  Source quote present.  Visible `\textit{Source:}` line consistent.
- **Proof sketch**: adequate — instantiate `lem:cech_to_cohomology_on_basis` at the affine cover system; condition (3) of that lemma is discharged by `lem:affine_cech_vanishing_qcoh` (target 1).  Explicit reference to the three sub-fields discharged by `lem:affine_faces_mem`, `lem:affine_surj_of_vanishing`, `lem:affine_injective_acyclic`.
- **`\uses{}`**: `{def:affine_cover_system, lem:affine_cech_vanishing_qcoh, lem:cech_to_cohomology_on_basis, def:absolute_cohomology}` — all present; `def:affine_cover_system` and `lem:cech_to_cohomology_on_basis` are `\leanok`; `lem:affine_cech_vanishing_qcoh` is the direct prerequisite (target 1, built first).
- **Dispatch order**: `lem:affine_serre_vanishing` must be dispatched AFTER `lem:affine_cech_vanishing_qcoh` closes; the `\uses{}` encodes this correctly.
- **Citation discipline**: complete.

### 3. `lem:cech_augmented_resolution` (line 6785, `AlgebraicGeometry.cechAugmented_exact`)

**Blueprint ready: YES — GATE CLEARS with one soon-severity proof-sketch note.**

- **Statement**: faithful to the source — the augmented Čech complex `0 → ℱ → 𝒞⁰ → 𝒞¹ → ⋯` is exact in QCoh(X) for ℱ quasi-coherent and 𝒰 a finite affine cover with affine intersections.  Source quote from `references/stacks-coherent.tex` L68–82 present.  Visible `\textit{Source:}` consistent.
- **`\uses{}`**: `{def:cech_nerve, lem:cech_acyclic_affine, lem:qcoh_iso_tilde_sections}` — all deps have blueprint blocks; `def:cech_nerve` is `\leanok`.
- **Proof sketch gap (soon)**: the sketch uses "restrict to affine U = Spec(A), identify ℱ|_U = ~M via `lem:qcoh_iso_tilde_sections`, and over a *refinement on which the cover restricts to a standard cover* apply `lem:cech_acyclic_affine`."  The "refinement" step is not justified by a named lemma: `lem:cech_acyclic_affine` (`sectionCech_affine_vanishing`) works for standard covers (covers by D(f)'s), but the cover elements U_i ∩ U need not be basic opens of U = Spec(A).  The Stacks source quote (same block) gives the correct path: "it suffices to show exactness after localizing at a prime p" — i.e., a stalk-local criterion.  A prover who follows the Stacks quote will formalize correctly; the blueprint proof path has an undocumented step.  **Recommendation**: in a writer pass, align the proof sketch with the stalk-at-prime approach; OR name the lemma providing the cover-refinement-to-standard-covers step (if such a lemma exists in the project).  Not a dispatch blocker — prover has the source.
- **Citation discipline**: complete.

---

## iter-048 `\uses` imprecision on `lem:qcoh_isIso_fromTildeGamma` — verdict

The iter-048 lean-vs-blueprint check reported that the Lean proof of `isIso_fromTildeΓ_of_quasicoherent` uses `SpecModulesToSheafFullyFaithful` + `Functor.IsCoverDense.iso_of_restrict_iso` rather than the blueprint's cited `lem:forget_reflectsIso_mathlib` (`SheafOfModules.fullyFaithfulForget`) and `lem:isIso_fromTildeGamma_iff_mathlib` (`isIso_fromTildeΓ_iff`).

Assessment: **cosmetic — no must-fix, soon severity**.

- `lem:forget_reflectsIso_mathlib`: the mathematical content IS used (the basis-check argument and forgetful-reflects-isos logic), but the Lean declaration name on the `\mathlibok` anchor (`SheafOfModules.fullyFaithfulForget`) differs from the actual Lean proof path (`SpecModulesToSheafFullyFaithful` + `IsCoverDense.iso_of_restrict_iso`).  The `\uses{}` edge is mathematically correct; only the `\lean{}` name on the anchor is slightly off.  **Writer fix**: update the `\lean{}` hint to include `SpecModulesToSheafFullyFaithful, Functor.IsCoverDense.iso_of_restrict_iso`.
- `lem:isIso_fromTildeGamma_iff_mathlib`: mentioned in the proof text only as "equivalently, this exhibits ℱ in the essential image of ~(−)" (parenthetical remark, line 5261–5262), not as a direct proof step.  The Lean proof does not invoke this criterion as a gate.  **Writer fix**: demote the `\uses{}` edge to a NOTE comment or remove it; it's a loose end, not a dependency.

Both fixes are cosmetic and do NOT block dispatch of any current prover target.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single declaration `def:higher_direct_image` with `\leanok`; `% SOURCE:` and source quote present; one `NOTE` annotation about the `[HasInjectiveResolutions]` hypothesis (accurate and appropriate).

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 60 blueprint declarations carry no `\leanok` marker (leandag "Needs \leanok: 60") — confirmed `sync_leanok` lag, not a blueprint gap.  All 60 Lean declarations exist per STRATEGY.md Completed phases and PROGRESS.md.
  - `lem:cech_augmented_resolution` proof sketch: minor misalignment with Stacks source (uses section-over-affines approach instead of stalk-at-prime; see Focus area verdict 3).  **Severity: soon**.
  - `lem:qcoh_isIso_fromTildeGamma` `\uses{}` has 2 cosmetic imprecisions (iter-048 finding confirmed above).  **Severity: soon**.
  - `rem:o1i8_decomposition` (remark block): only non-`\lean{}`/non-`\mathlibok` block in the chapter — appropriate (remarks have no Lean obligation).

---

## Severity summary

- **must-fix-this-iter**: NONE — the hard gate CLEARS for all three dispatch targets.
- **soon**:
  1. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_augmented_resolution`: proof sketch should be aligned with stalk-at-prime approach (or name the refinement lemma).  Dispatch proceeds; fix in a writer pass.
  2. `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_isIso_fromTildeGamma` `\uses{}`: update `\lean{}` name in `lem:forget_reflectsIso_mathlib` anchor; demote or remove `lem:isIso_fromTildeGamma_iff_mathlib` from `\uses{}`.
- **informational**:
  - 60 declarations need `\leanok` sync (no action needed from plan agent — `sync_leanok` handles this).
  - 1 `lean_aux` isolated node: keep (uncovered Lean helper, not a blueprint obligation).

**Overall verdict**: All three iter-049 prover targets (`lem:affine_cech_vanishing_qcoh`, `lem:affine_serre_vanishing`, `lem:cech_augmented_resolution`) have complete, correct, source-anchored blueprint blocks; the hard gate clears for all three; 0 unstarted phases; 2 soon-severity items for a future writer pass.
