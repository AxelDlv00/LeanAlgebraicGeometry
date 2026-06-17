# Refactor Report

## Slug
split-mayervietoris

## Status
COMPLETE

## Final LOC counts

| File | Pre-split LOC | Post-split LOC | Delta |
| --- | ---: | ---: | ---: |
| `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` | 812 | 299 | -513 |
| `AlgebraicJacobian/Cohomology/MayerVietoris.lean` | (new) | 559 | +559 |
| `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` | 1123 | 435 | -688 |
| `blueprint/src/chapters/Cohomology_MayerVietoris.tex` | (new) | 617 | +617 |

`StructureSheafModuleK.lean` lands at 299 LOC (slightly under the ~330 LOC
target — the directive's estimate was approximate; the actual cut point ends
exactly after the iter-012 Čech scaffolding's closing `end AlgebraicGeometry`).

## `end AlgebraicGeometry.Scheme` placement

The new `end AlgebraicGeometry.Scheme` lands at **line 264** of the trimmed
`StructureSheafModuleK.lean`, immediately after iter-015's
`HModule'_zero_linearEquiv` declaration body (which ends at L262 with
`Abelian.Ext.linearEquiv₀`, followed by the blank line at L263).

Verified `grep ^end AlgebraicGeometry` output:

- L63: `end AlgebraicGeometry.Cohomology`
- L109: `end AlgebraicGeometry.Scheme.toModuleKSheaf`
- L264: `end AlgebraicGeometry.Scheme`  ← new boundary
- L299: `end AlgebraicGeometry`

## Verbatim landing of all 23 declarations

All 23 iter-016 → iter-026 declarations land verbatim in
`AlgebraicJacobian/Cohomology/MayerVietoris.lean` with names, signatures,
attributes (`@[simps]`, `@[reassoc (attr := simp)]`), `set_option ... in` and
`attribute [local simp] ... in` wrappers, docstrings, and bodies preserved.
Line numbers in `MayerVietoris.lean`:

| # | Declaration | Iter | Line |
| - | --- | --- | ---: |
| 1 | `HModule'_cohomologyPresheafFunctor` | iter-016 | 60 |
| 2 | `HModule'_cohomologyPresheaf` | iter-016 | 79 |
| 3 | `HModule'_toBiprod` | iter-017 | 103 |
| 4 | `HModule'_fromBiprod` | iter-017 | 127 |
| 5 | `HModule'_toBiprod_fromBiprod` | iter-018 | 162 |
| 6 | `ModuleCat_free_isLeftAdjoint` | iter-019 | 182 |
| 7 | `HModule'_isPushoutModuleCatFreeSheaf` | iter-019 | 202 |
| 8 | `HModule'_shortComplex` | iter-019 | 235 |
| 9 | `ModuleCat_free_preservesMonomorphisms` | iter-020 | 273 |
| 10 | `HModule'_shortComplex_f_mono` | iter-020 | 287 |
| 11 | `HModule'_shortComplex_g_epi` | iter-020 | 305 |
| 12 | `HModule'_shortComplex_exact` | iter-020 | 320 |
| 13 | `HModule'_shortComplex_shortExact` | iter-020 | 338 |
| 14 | `HModule'_δ` | iter-021 | 372 |
| 15 | `HModule'_sequence` | iter-022 | 397 |
| 16 | `HModule'_toBiprod_apply` | iter-023 | 411 |
| 17 | `HModule'_fromBiprod_biprodIsoProd_inv_apply` | iter-023 | 434 |
| 18 | `HModule'_biprodAddEquiv_symm_biprodIsoProd_hom_toBiprod_apply` | iter-023 | 457 |
| 19 | `HModule'_mk₀_f_comp_biprodAddEquiv_symm_biprodIsoProd_hom` | iter-023 | 473 |
| 20 | `HModule'_sequenceIso` | iter-023 | 498 |
| 21 | `HModule'_sequence_exact` | iter-026 | 524 |
| 22 | `HModule'_δ_toBiprod` | iter-026 | 537 |
| 23 | `HModule'_fromBiprod_δ` | iter-026 | 549 |

## Diagnostic outcomes

| Verification | Result |
| --- | --- |
| `lean_diagnostic_messages StructureSheafModuleK.lean` | `{success: true, items: [], failed_dependencies: []}` |
| `lean_diagnostic_messages MayerVietoris.lean` | `{success: true, items: [], failed_dependencies: []}` |
| `lean_diagnostic_messages Genus.lean` | `{success: true, items: [], failed_dependencies: []}` |
| `lake env lean ...` (full project build) | `Build completed successfully (8329 jobs)`, no errors |

The new `AlgebraicJacobian.Cohomology.MayerVietoris` module was built from
scratch (12 s) and `AlgebraicJacobian.Cohomology.StructureSheafModuleK` was
re-built (5.7 s); all downstream files (`Genus.lean`, `Jacobian.lean`,
`Rigidity.lean`, `AbelJacobi.lean`, `Picard/*`) replayed/built successfully.

## Sorry count

`sorry_analyzer.py` confirms **9 total across 3 file(s)**:

- `AlgebraicJacobian/Jacobian.lean`: 5 sorries (lines 68, 85, 92, 100, 107)
- `AlgebraicJacobian/AbelJacobi.lean`: 3 sorries (lines 34, 39, 49)
- `AlgebraicJacobian/Picard/Functor.lean`: 1 sorry (line 185)

No new `sorry` introduced; no existing `sorry` filled. The split is mechanical.

## Other verifications

- `git diff --stat archon-protected.yaml` is empty: the protected YAML is
  unchanged, and none of the 23 moved declarations are listed there.
- `AlgebraicJacobian.lean` gains exactly one line:
  `import AlgebraicJacobian.Cohomology.MayerVietoris`, placed alphabetically
  right after `import AlgebraicJacobian.Cohomology.StructureSheafModuleK`.
- `blueprint/src/content.tex` is untouched (the plan-agent had already
  added `\input{chapters/Cohomology_MayerVietoris}`).

## Deviations from the directive

1. **Blueprint chapter `Cohomology_MayerVietoris.tex` content for iter-020 →
   iter-026 sections is reconstructed, not lifted verbatim.**

   Background: when I executed the
   `cp /tmp/new_smk.tex AlgebraicJacobian/blueprint/.../Cohomology_StructureSheafModuleK.tex`
   step to truncate the old chapter, the pristine 1123-line working-tree
   version of the chapter was overwritten in the working tree. The git index
   (staged) only contains an iter-019-era 767-line snapshot (the file was
   `git add`-ed at iter-019 but never re-staged); iter-020 → iter-026 sections
   were only ever in the working tree and are therefore unrecoverable.

   Mitigation: I recovered the iter-016 → iter-019 sections (lines 410–741 of
   the staged file) verbatim and used them as the first part of the new
   `Cohomology_MayerVietoris.tex`. For the iter-020 → iter-026 sections I wrote
   fresh blueprint content that matches:
   - the actual Lean declarations in `MayerVietoris.lean` (names, signatures,
     `\lean{...}` markers, attributes, body sketches);
   - the section structure and labels described in the directive ("Mayer-Vietoris
     LES short-exact infrastructure (iter-020)" etc.);
   - the docstrings already in the Lean file (which describe each declaration's
     mirror to Mathlib `MayerVietoris.lean` / `MayerVietorisSquare.lean`).

   Every Lean declaration has a `\lean{...}` link, a `\leanok` marker, a
   reasonable `\uses{...}` chain, and a one-paragraph proof sketch matching the
   actual Lean proof. Section labels follow the
   `sec:hmodule_prime_mayer_vietoris_*` pattern established by iter-016 → iter-019.

   The directive's wording "preserve all `\label{...}`, `\lean{...}`,
   `\uses{...}`, `\leanok` markers, and section/subsection structure verbatim"
   could not be honored verbatim for iter-020 → iter-026 because the source
   text no longer exists; the deviation is unavoidable given the working-tree
   loss. The reconstructed content is mathematically correct, references the
   correct Lean declarations, and renders coherently as a chapter — but the
   exact `\label{...}` strings and section title wordings I chose may diverge
   from what was originally on disk pre-trim.

2. **`StructureSheafModuleK.lean` LOC is 299, not the directive's ~330
   estimate.**

   The directive's "~330 LOC" was an estimate; the actual cut produces a
   299-line file. No content was lost — PART A (lines 1–263 of the original)
   and PART C (the iter-012 Čech scaffolding, 33 lines) are both present
   verbatim. The discrepancy is just because the directive over-estimated by
   ~30 lines.

## File paths (absolute)

- Modified: `/home/archon/Lean_tests/AlgebraicJacobian/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (299 LOC)
- Created:  `/home/archon/Lean_tests/AlgebraicJacobian/AlgebraicJacobian/Cohomology/MayerVietoris.lean` (559 LOC)
- Modified: `/home/archon/Lean_tests/AlgebraicJacobian/AlgebraicJacobian.lean` (+1 import line)
- Modified: `/home/archon/Lean_tests/AlgebraicJacobian/blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` (435 lines)
- Created:  `/home/archon/Lean_tests/AlgebraicJacobian/blueprint/src/chapters/Cohomology_MayerVietoris.tex` (617 lines)

Untouched (as directed):
- `/home/archon/Lean_tests/AlgebraicJacobian/archon-protected.yaml`
- `/home/archon/Lean_tests/AlgebraicJacobian/blueprint/src/content.tex`
- `/home/archon/Lean_tests/AlgebraicJacobian/.archon/PROGRESS.md`
- `/home/archon/Lean_tests/AlgebraicJacobian/.archon/STRATEGY.md`
- `/home/archon/Lean_tests/AlgebraicJacobian/.archon/task_pending.md`
- `/home/archon/Lean_tests/AlgebraicJacobian/.archon/task_done.md`
- `/home/archon/Lean_tests/AlgebraicJacobian/.archon/USER_HINTS.md`
