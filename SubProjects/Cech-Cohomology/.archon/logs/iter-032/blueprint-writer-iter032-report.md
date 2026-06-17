# Blueprint Writer Report

## Slug
iter032

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### JOB 1 — decompose `lem:qcoh_localized_sections` into P1a + P1b

- **Added lemma (P1a)** `\lemma`/`\label{lem:isQuasicoherent_restrict_basicOpen}`/`\lean{AlgebraicGeometry.isQuasicoherent_restrict_basicOpen}`
  - `\uses{lem:exists_finite_basicOpen_subcover, lem:qcoh_iso_tilde_sections_of_presentation}` (on both block and proof).
  - Statement: for `[IsQuasicoherent F]` on `Spec R` and `f ∈ R`, transporting along `D(f) ≅ Spec R_f` the restriction `F|_{D(f)}` is a quasi-coherent `O_{Spec R_f}`-module admitting a Presentation, so `F|_{D(f)} ≅ ~M` for `M = Γ(D(f),F)`.
  - Proof sketch added: Y — refine the QuasicoherentData cover to finite standard opens (P0), restrict each presentation along the open immersion `D(g_j) ↪ U_{φ(j)}`, identify each piece with `~M_j` via the presentation lemma, restrict to `D(f)` via `lemma-widetilde-pullback`, assemble.
  - `% NOTE:` flags that SheafOfModules-restriction-to-basic-open ≅ Spec-of-localization machinery is ABSENT from Mathlib and project-to-build (harder geometry lane). Citation: Stacks Schemes `lemma-widetilde-pullback` + `lemma-quasi-coherent-affine` (Tag 01I8), two verbatim quotes from `references/stacks-schemes.tex` (L1271–1276, L1298–1303).

- **Added lemma (P1b)** `\lemma`/`\label{lem:isLocalizedModule_of_span_cover}`/`\lean{AlgebraicGeometry.isLocalizedModule_of_span_cover}`
  - No `\uses{}` (pure-algebra leaf; incoming edge from `lem:qcoh_localized_sections`). Project-bespoke — no source lines.
  - Statement (PINNED, see flag below): `R` comm ring, `M N : R`-modules, `g : M →ₗ[R] N`, `f : R`, `s : Fin n → R` with `span(range s) = ⊤`; hypothesis: for each `j` the localised map `g_{s_j} : M_{s_j} → N_{s_j}` (localisations at `powers s_j`) satisfies `IsLocalizedModule (powers f) g_{s_j}`; conclusion: `IsLocalizedModule (powers f) g`.
  - Proof sketch added: Y — full verification of the three `IsLocalizedModule.mk` fields (`map_units`, `surj'`, `exists_of_eq`) by descent along the spanning cover, using the partition of unity `Σ rⱼ sⱼ^{Nⱼ} = 1` and the locality-of-zero / locality-of-bijectivity principle for a span cover.

- **Revised** `lem:qcoh_localized_sections` — `\uses` changed from `{lem:exists_finite_basicOpen_subcover, lem:qcoh_iso_tilde_sections_of_presentation}` to `{lem:exists_finite_basicOpen_subcover, lem:isQuasicoherent_restrict_basicOpen, lem:isLocalizedModule_of_span_cover}` (block + proof). Rewrote the proof to: pick the finite basic-open cover `Spec R = ⋃ D(sⱼ)` (P0), trivialise `F` on each `D(sⱼ)` via P1a, read off per-`sⱼ` localisation of sections at `f` from `lemma-widetilde-pullback`, then patch via P1b. Updated the `% NOTE` to record that the decomposition now exists as two separate blocks (dropped the stale "Planner action: dispatch blueprint-writer" note).

### JOB 2 — informal proof for `lem:tilde_preserves_kernels`

- **Added proof** for `lem:tilde_preserves_kernels` (`\lean{AlgebraicGeometry.tildePreservesFiniteLimits}`). Previously statement-only (leandag ∞-source). Proof: kernels of sheaves of modules are computed objectwise+sheafified and isos are checked stalkwise; stalk of `~M` at `p` is `M_p` (Stacks `lemma-spec-sheaves` item (7)); localisation `R → R_p` is flat hence exact and preserves kernels; the comparison `~(Ker φ) → Ker(~φ)` is a stalkwise iso, hence an iso; same argument over a finite diagram gives preservation of finite limits.
  - Added `% NOTE:` that the Lean `PreservesFiniteLimits`/`PreservesKernels` instance for `~` is ABSENT from Mathlib and project-to-build (Route-P P3 sub-gap).
  - Added two `% SOURCE QUOTE PROOF:` comments (verbatim, from `references/stacks-schemes.tex` L616–630 stalk computation and L721–728 exactness-from-stalks) + a visible `\textit{Source: ...lemma-spec-sheaves...}` line in the proof body. (The block's existing `% SOURCE:`/`% SOURCE QUOTE:` for `lemma-kernel-cokernel-quasi-coherent` were left intact.)

### JOB 3 — coverage debt for 9 CechBridge `…Fam` helpers

- **Revised `\lean{}` list of `lem:cech_complex_hom_identification`** — added 7 helpers:
  `cechComplex_hom_identificationFam`, `homCechCosimplicialFam`, `homCechComplexFam`,
  `homCechSectionIsoAppFam`, `homCechSectionIsoApp_hom_πFam`, `homCechCosimplicial_δFam`,
  `homCechSectionCosimplicialIsoFam`. No `\uses` change (mechanical mirrors).
- **Revised `\lean{}` list of `lem:cech_complex_op_identification`** — added 2 helpers:
  `homCechComplexMapOpIsoFam`, `homCechComplex_d_eqFam`. No `\uses` change.
  - **Deviation from directive (see flag below):** the directive recommended bundling these two into `lem:section_cech_complex_mapop_iso`, but the non-`Fam` originals `homCechComplexMapOpIso` and `homCechComplex_d_eq` live in `lem:cech_complex_op_identification`. To mirror the existing bundling pattern exactly ("each `Fam` helper alongside its non-`Fam` original"), I placed them there. `sectionCechComplexMapOpIsoFam` (the named target) is already pinned in `lem:section_cech_complex_mapop_iso` — verified present, not duplicated.
- Verified `injective_cech_acyclicFam` is already pinned in `lem:injective_cech_acyclic` — not duplicated.

## Cross-references introduced
- `\uses{lem:isQuasicoherent_restrict_basicOpen}` and `\uses{lem:isLocalizedModule_of_span_cover}` added in `lem:qcoh_localized_sections` (both targets now exist in this same chapter — verified via leandag, no `unknown_uses`).
- `lem:isQuasicoherent_restrict_basicOpen` `\uses{lem:exists_finite_basicOpen_subcover, lem:qcoh_iso_tilde_sections_of_presentation}` — both exist in this chapter.

## leandag verification
- `leandag build --json`: `unknown_uses: []` (no broken `\uses`). None of the new/edited labels are isolated.
- The 9 `…Fam` helpers no longer appear as unmatched (Lean↔blueprint coverage debt cleared).
- `unmatched_lean` still lists `isQuasicoherent_restrict_basicOpen`, `isLocalizedModule_of_span_cover`, `tildePreservesFiniteLimits` — EXPECTED: these are to-be-built Lean declarations that do not yet exist in the `.lean` sources (project-to-build, flagged via `% NOTE:`). No `\leanok` added anywhere.
- LaTeX begin/end balance verified (189/189; lemma 77/77; proof 63/63).

## References consulted
- `references/stacks-schemes.tex` —
  - L616–630 (stalk computation `~M_x = M_p`) and L711–713, L721–728 (`lemma-spec-sheaves` item (7) + exactness-from-stalks proof): verbatim `% SOURCE QUOTE PROOF:` for `lem:tilde_preserves_kernels`.
  - L1271–1276 (`lemma-widetilde-pullback` restriction remark) and L1298–1303 (`lemma-quasi-coherent-affine` standard-open refinement): verbatim `% SOURCE QUOTE:` for `lem:isQuasicoherent_restrict_basicOpen`.

## Macros needed (if any)
- None. All commands used (`\operatorname`, `\widetilde`, `\Gamma`, `\mathcal`, `\cong`, etc.) are already in use throughout the chapter.

## Notes for Plan Agent
- **P1b is dispatch-ready pure commutative algebra** as flagged in the directive; it has no cohomology dependency and no `\uses` edges out, so a prover can take it immediately.
- **P1a is the harder geometry lane** and is blueprint-only this iter (machinery absent from Mathlib, flagged with `% NOTE:`). Do not dispatch it as a prover target until the SheafOfModules-restriction-to-basic-open transport infra exists.
- The `lem:tilde_preserves_kernels` `\lean{}` target `AlgebraicGeometry.tildePreservesFiniteLimits` does not yet exist in Lean (it was statement-only before and is still to-be-built). The block now has a complete informal proof so it leaves the ∞-source list, but a scaffolder still needs to create the Lean instance.

## Strategy-modifying findings
None. The decomposition is purely structural; the global-generation route and its consequences are unchanged.

## Flags for the planner to validate before dispatch

1. **P1b exact statement (`lem:isLocalizedModule_of_span_cover`).** I formalized the per-`j` hypothesis as "the localised map `g_{s_j} : M_{s_j} → N_{s_j}` (localisation at `powers s_j`) is `IsLocalizedModule (powers f) g_{s_j}`", with conclusion `IsLocalizedModule (powers f) g`. This is the form the partition-of-unity proof (3 `.mk` fields) needs and matches how P1's per-`sⱼ` data is produced. **Possible alternative the planner may prefer:** stating the hypothesis over the localised ring `R_{s_j}` (using `IsLocalizedModule` for the image-submonoid `powers (algebraMap R R_{s_j} f)`) rather than over `R`. The two are interchangeable for the math but the Lean signature differs; I chose the over-`R` form to avoid threading `R_{s_j}`-algebra instances. Please confirm the submonoid/base-ring choice before dispatching the prover.

2. **P1a Lean name.** I used `AlgebraicGeometry.isQuasicoherent_restrict_basicOpen` (the directive offered this or `qcoh_localized_sections_restriction`). The rewritten `lem:qcoh_localized_sections` proof and `\uses` reference `lem:isQuasicoherent_restrict_basicOpen` consistently. Rename at scaffolding time if the planner prefers the other.

3. **JOB 3 placement deviation** (see Changes/JOB 3): the two op-transport `Fam` helpers were bundled into `lem:cech_complex_op_identification` (where their non-`Fam` originals live), not into `lem:section_cech_complex_mapop_iso` as the directive's recommended assignment named. This preserves the "Fam-alongside-original" mirroring invariant. Flag if the planner intended otherwise.
