# Blueprint re-review (fast-path) — focus: Picard_QuotScheme.tex

This is a same-iter fast-path re-review to re-clear the HARD GATE for ONE chapter after a structural
edit. Read the whole blueprint as usual, but the verdict that matters this iter is whether
`blueprint/src/chapters/Picard_QuotScheme.tex` is **complete + correct** enough to dispatch a prover at
`AlgebraicJacobian/Picard/QuotScheme.lean` for the gap1 section-transport producer keystone.

## Changes made to Picard_QuotScheme.tex this iter (verify each is sound)

1. **Split the producer-(b) block** (was `lem:composite_immersion_range_basicOpen`, which bundled three
   claims with a broken `\lean{}` pin to a non-existent `composite_immersion_range_basicOpen`):
   - `lem:composite_immersion_range_basicOpen` is now **range-only** (`j.opensRange = D(s)`), pin
     corrected to the existing axiom-clean decl
     `AlgebraicGeometry.Scheme.Modules.compositeBasicOpenImmersion_opensRange`.
   - NEW `lem:composite_immersion_flocus_basicOpen` holds the still-open f-locus/σ claims
     (`σ(f') = algebraMap R Rₛ f`, `j ''ᵁ D(f') = D(f) ⊓ D(s)`), pinned at the to-be-created
     `compositeBasicOpenImmersion_flocus_image`.
   - Downstream `\uses` rewired: `lem:gamma_image_iso_semilinear_top`, `lem:flocus_section_scalar_tower`,
     and `lem:section_localization_hfr_basicOpen` now cite the flocus block for σ/f-locus content.

2. **Added coverage blocks** for already-proven `lean_aux` helpers (clearing leandag isolated nodes):
   `def:composite_basic_open_immersion` (`compositeBasicOpenImmersion`),
   `lem:composite_basic_open_immersion_isOpenImmersion`, and
   `lem:isIso_unitToPushforwardObjUnit_of_isIso` (pins the existing private helper
   `AlgebraicGeometry.isIso_unitToPushforwardObjUnit_of_isIso'`).

3. **Enriched the TOP producer proof** (`lem:section_localization_hfr_basicOpen`) with a
   "scalar-base reconciliation (no transport needed)" paragraph: the `ModuleCat Rₛ` action on
   `Γ(M',⊤)` coincides definitionally with the structure-sheaf `Γ(Spec Rₛ,⊤)` action restricted along
   `ΓSpecIso`, so the composite σ needs no explicit scalar transport (per a mathlib-analogist
   api-alignment finding, `analogies/quot-sigma-rebasing.md`). Also noted the e₂ leg's semilinearity is
   obtained via the restriction-square naturality `lem:gamma_pullback_image_iso_hom_naturality`.

## What I need back
- Is `Picard_QuotScheme.tex` **complete + correct** for the gap1 producer keystone lane? (yes/no per axis)
- Any must-fix-this-iter finding (broken `\uses`/`\label`/`\lean` pin, a sub-lemma the prover needs whose
  statement is wrong or too thin to formalize).
- Confirm the block split did not orphan any dependency edge.
