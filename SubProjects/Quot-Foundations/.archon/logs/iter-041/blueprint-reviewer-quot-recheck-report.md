# Blueprint Review Report

## Slug
quot-recheck

## Iteration
041

## Top-level summaries

### Dependency & isolation findings

- `Picard_QuotScheme.tex` / `lem:annihilator_localization_eq_map`: isolated (no `\uses{}` out, nothing uses
  it). Pre-existing; the NOTE comment in the chapter explicitly records that the downstream consumer (the
  reverse-inclusion / equality characterisation of the annihilator ideal on affine opens) is a future
  blueprint block not yet written. **keep** — forward-provision for a known future block; not caused by
  this iter's structural edit and not a gap-1 producer dependency.

- `Picard_GrassmannianCells.tex` / `lem:gr_det_one_updateCol`: isolated, already proved. **keep** —
  proved private auxiliary; no blueprint consumer was ever planned.

### Proofs lacking detail

- `Picard_QuotScheme.tex` / `lem:section_localization_hfr_basicOpen` proof body (informational): the text
  says "both [e₁ and e₂] are σ-semilinear … by `lem:gamma_image_iso_semilinear_top`", but `lem:gamma_image_iso_semilinear_top`
  specifically upgrades the D(f')-level transport (e₂) from σ_{D(f')} to σ_⊤ via naturality. e₁'s ⊤-semilinearity
  follows more directly from `lem:gamma_pullback_image_iso_hom_semilinear` at V=⊤. The `\uses{}` covers
  both routes correctly (both lemmas are listed), so no edge is missing; this is a prose-precision issue
  only. **informational** — the prover has all the tools; the attribution "both by `lem:gamma_image_iso_semilinear_top`"
  is an overstatement for e₁ but does not block formalization.

## Per-chapter

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Block split verified sound. `lem:composite_immersion_range_basicOpen` is now range-only (`j.opensRange = D(s)`),
    `\leanok`, pinned to `compositeBasicOpenImmersion_opensRange` which EXISTS in the Lean file (line 2002
    of QuotScheme.lean) and is axiom-clean. Pin is correct.
  - NEW `lem:composite_immersion_flocus_basicOpen` pinned to `compositeBasicOpenImmersion_flocus_image`
    (to-be-created per directive). Not yet in the Lean file — expected; it is the first build target for
    the prover. The statement (σ(f') = algebraMap R Rₛ f, j ''ᵁ D(f') = D(f) ⊓ D(s)) and proof sketch
    (definitional from σ = σ⁻¹(algebraMap R Rₛ f) + range lemma) are adequate.
  - Downstream `\uses` rewiring correct: `lem:gamma_image_iso_semilinear_top` (line 4361),
    `lem:flocus_section_scalar_tower` (line 4385), and `lem:section_localization_hfr_basicOpen` (line 4408)
    all cite `lem:composite_immersion_flocus_basicOpen`. No orphaned edges from the split.
  - Coverage blocks for aux helpers: `def:composite_basic_open_immersion` → `compositeBasicOpenImmersion`
    EXISTS (line 1950 of QuotScheme.lean) ✓; `lem:composite_basic_open_immersion_isOpenImmersion` →
    `compositeBasicOpenImmersion_isOpenImmersion` EXISTS (line 1991) ✓; `lem:isIso_unitToPushforwardObjUnit_of_isIso`
    → `isIso_unitToPushforwardObjUnit_of_isIso'` (private) EXISTS (line 1037) and is matched by leandag
    (not in unmatched_lean list) ✓.
  - Scalar-base reconciliation paragraph in `lem:section_localization_hfr_basicOpen` proof: mathematically
    sound. The tilde functor definitionally rebases the structure-sheaf action along ΓSpecIso, so the
    chosen σ = (ΓSpec-iso)⁻¹ ∘ gammaImageRingEquiv j ⊤ requires no explicit scalar transport. Aligned
    with analogies/quot-sigma-rebasing.md. Prover-actionable.
  - **Soon**: `lem:flocus_section_scalar_tower` proof `\uses{}` lists `lem:composite_immersion_range_basicOpen`
    but the proof TEXT ends "The identification of the locus j ''ᵁ D(f') = D(f) ⊓ D(s) is
    `\cref{lem:composite_immersion_flocus_basicOpen}`" — the proof block `\uses{}` should also include
    `lem:composite_immersion_flocus_basicOpen`. The STATEMENT's `\uses{}` already lists it (line 4385),
    so the dependency edge is present in the leandag and no prover-dispatch ordering hazard results. Not
    blocking; writer fix welcome next iter.
  - leandag `unknown_uses: []`, `isolated`: 2 (pre-existing, neither in gap1 producer lane).
  - blueprint-doctor: `broken_refs: []`, `malformed_refs: []`, `orphan_chapters: []`.
  - Unmatched `\lean{}` refs for the 4 to-be-proved targets (`compositeBasicOpenImmersion_flocus_image`,
    `gamma_image_iso_semilinear_top`, `flocus_section_scalar_tower`, `section_localization_hfr_basicOpen`)
    are expected — these are the prover's build targets.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_RegroupHelper.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_GrassmannianCells.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

## Severity summary

- **must-fix-this-iter**: none.
- **soon**: `Picard_QuotScheme.tex` / `lem:flocus_section_scalar_tower` proof `\uses{}` missing `lem:composite_immersion_flocus_basicOpen` (edge exists at statement level; not a dispatch-ordering hazard).
- **informational**: `Picard_QuotScheme.tex` / `lem:section_localization_hfr_basicOpen` proof text overattributes e₁ semilinearity to `lem:gamma_image_iso_semilinear_top`; `\uses{}` covers both routes.

**HARD GATE CLEARS** — `Picard_QuotScheme.tex` complete + correct for the gap1 producer keystone lane; no must-fix findings; prover dispatch at `AlgebraicJacobian/Picard/QuotScheme.lean` is unblocked.

Overall verdict: `Picard_QuotScheme.tex` is complete + correct for the gap1 section-transport producer lane; block split is sound, all downstream `\uses` correctly rewired, lean pins resolve for existing decls, no broken edges — HARD GATE CLEARS for the iter-041 prover dispatch.
