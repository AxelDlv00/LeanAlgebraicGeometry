# Blueprint-writer directive (PASS 2) — realign the 02KG residual from route A to route B

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context (why this revision)
Pass 1 (this iter) fixed `lem:affine_cech_vanishing_qcoh` to the change-of-base-to-`R_f` argument and
added a residual chain. But it framed the residual `lem:affine_cech_vanishing_tilde_subcover` via
**route A (change-of-SPACE / sheaf)**: it added `lem:tilde_section_changeOfBase` (per-σ sheaf section iso)
and `lem:section_cech_changeOfBase_iso` (cochain iso through `Spec R_f`). A mathlib-analogist adjudication
(`analogies/02kg-residual-changeofbase.md`, verdict **ALIGN_WITH_MATHLIB on route B**) determined route A
is the WRONG (expensive) implementation: it needs a tilde base-change sheaf iso `~_R M|_{D(f)} ≅ ~_{R_f}M_f`
that Mathlib LACKS and the project has only at presentation level (~350–450 LOC of 01I8-style sheaf
plumbing). Route B is ~120–200 LOC, 0 refactor. **Realign the blueprint to route B.**

## Task 1 — REPLACE the route-A infra with the route-B realization
- **DELETE** the two route-A infra blocks added in pass 1: `lem:tilde_section_changeOfBase` and
  `lem:section_cech_changeOfBase_iso` (they are not used in route B). Also remove their labels from any
  `\uses{}` lists (in `lem:affine_cech_vanishing_tilde_subcover` and anywhere else).
- **REWRITE the proof of `lem:affine_cech_vanishing_tilde_subcover`** (the residual: for an `R`-module `M`,
  `f`, family `g` with `D(f) = ⨆ D(gᵢ)` and `p>0`, `Ȟᵖ({D(gᵢ)}, ~M) = 0`) to the **change-of-RING**
  argument. Update its `\lean{}` to pin the actual Lean theorem the prover will build,
  `AlgebraicGeometry.sectionCech_homology_exact_of_localizationAway` (built directly in `CechAcyclic.lean`,
  NOT in `AffineSerreVanishing.lean`, so the `private SectionCechModule`/`SectionCechTilde` core is in
  scope). The informal proof (from `analogies/02kg-residual-changeofbase.md`, Recommendation):

  > The abstract section-Čech module complex `SectionCechModule` is `{R}[CommRing R]`-polymorphic.
  > Instantiate it over `R_f = Localization.Away f` with the family `g/1`, whose `R_f`-span is `⊤`
  > (`affine_cover_span_localizationAway`); then `SectionCechModule.dDiff_exact (g/1) M_f hspan` gives
  > positive-degree exactness of the `R_f`-side complex. Transport this back to the `R`-side section Čech
  > complex of `~_R M` through a degreewise AddEquiv `M_{gσ} ≅ (M_f)_{gσ}` — built from the public
  > `AwayComparison` toolkit (`comparison` + `comparison_isLocalizedModule`; `f` is invertible in `M_{gσ}`
  > because `gσ ∈ √(f)`, giving the `Inverts` witness) — assembled into a ladder
  > `Function.Exact.of_ladder_addEquiv_of_exact` exactly as `sectionCechAbExact` does, with the naturality
  > square modelled on `cechCoface_dToCech`. Wrap positive-degree exactness as `IsZero` of the homology
  > exactly as `sectionCech_homology_exact` does.

  `\uses{}` for the residual proof: `lem:cech_acyclic_affine` (or the underlying spanning-`⊤` section
  vanishing node it cites), `lem:affine_cover_span_localizationAway`, and the new `AwayComparison` anchor
  (Task 2). Carry over the `% SOURCE QUOTE PROOF` ("Write U = Spec(A) … the Čech complex … is identified
  with ∏ M_{f_{i₀}} → …") — it is the same Stacks `lemma-cech-cohomology-quasi-coherent-trivial` step and
  applies verbatim to route B.

## Task 2 — Mathlib/project dependency anchor for the AwayComparison toolkit
Add (or reuse if present) a short anchor block naming the project's public change-of-localization-base API
that route B leans on, so the residual's `\uses` resolves and the reliance is visible:
- `lem:away_comparison_isLocalizedModule` → `\lean{AlgebraicGeometry.AwayComparison.comparison_isLocalizedModule}`
  (PROJECT, already proved/axiom-clean — do NOT mark `\mathlibok`; it is project-owned). One-line statement:
  the transitivity comparison `M_a → M_{ab}` exhibits `M_{ab}` as the localization of `M_a`, the engine for
  the `M_{gσ} ≅ (M_f)_{gσ}` degreewise iso. If a suitable block/label already exists for the `AwayComparison`
  namespace, just cite it instead of adding a duplicate.

## Task 3 — keep `lem:affine_cech_vanishing_qcoh` consistent
Its proof Step 2 should now cite `lem:affine_cech_vanishing_tilde_subcover` (unchanged) as the residual; just
ensure its `\uses{}` no longer references the deleted route-A infra labels. No other change.

## Out of scope
- Do NOT touch `lem:cech_augmented_resolution` / P5a blocks, the cover-system defs, or the protected decl.
- Do NOT add `\leanok`.
- Keep `lem:affine_cover_span_localizationAway` and `lem:cechCohomology_isZero_of_iso` blocks (still used).
