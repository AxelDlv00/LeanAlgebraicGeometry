# Blueprint Writer Report

## Slug
bw-tos260

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### PRIMARY — Sq2b must-fix (empirically disproven prose), proof of `lem:pullback_tensor_map_basechange`
- **Deleted** the `% NOTE (iter-259)` scaffolding comment block (former lines ~4000–4010).
- **Replaced** the false sentence ("… a concrete, sectionwise identity, exactly as the unit
  twin `unitToPushforwardObjUnit_comp` holds definitionally. The only new bookkeeping … is the
  two-argument `tensorHom`/δ_natural shuffle, which follows the same template as Mathlib's
  `isMonoidal_comp`") with an honest two-paragraph statement:
  - The mate-calculus reduction reduces Sq2b to **one genuine residual**, isolated as
    `pushforwardComp_lax_μ` — the **right-adjoint twin** of the δ-coherence, i.e. the
    "`pushforwardComp` is monoidal" identity for the lax tensorators μ.
  - **"First" paragraph** (KEPT correct content): the transpose-and-inject opening, the
    `δ = homEquiv⁻¹((η⊗η);μ)` pivot, the `conjugateEquiv_pullbackComp_inv` transport (with
    `unit_conjugateEquiv` / `Adjunction.comp_unit_app`), and the two-argument
    `tensorHom`/δ_natural bookkeeping (modelled on `CategoryTheory.Adjunction.isMonoidal_comp`)
    are all **carried out** and discharge every part of Sq2b *except* the residual. This
    reduction is the δ-mirror of `\cref{lem:pullbackObjUnitToUnit_comp}`.
  - **"Second" paragraph** (the correction): the residual is **NOT definitional**. The unit
    twin is `rfl` only because η touches ε alone; the μ-version is the full tensorator
    interchange. Sectionwise it exposes the base-change associativity coherence for the
    composite ring map vs the two-step composite, and its proof is a `ModuleCat`
    change-of-rings calculation built from **`ModuleCat.restrictScalarsComp`**,
    **`ModuleCat.extendScalarsComp`**, **`ModuleCat.homEquiv_extendScalarsComp`** — the
    genuine "`pushforwardComp` is monoidal" theorem.
  - The retained `isMonoidal_comp` reference is now correctly scoped to the *two-argument
    shuffle only* (which is genuine and correct), not to the final μ-coherence.

### SECONDARY — `sliceDualTransport` / `dual_restrict_iso` route-(1) consumer framing
- **Rewrote** the "The leg-(A) atom `sliceDualTransport`" paragraph to recast the atom as a
  **consumer of the now-green shared root** `Scheme.Modules.overEquivalence`
  (`\cref{def:sheafofmodules_over_equivalence}`) rather than a from-scratch
  `FullyFaithful.homEquiv` build. Added all directive-requested framing:
  - `sliceDualTransport` = the **per-open localization to `V`** of `overEquivalence U`,
    whose functor is `pushforward (phiOver U)`; displayed the reduced 𝒪_Y(V)-linear
    equivalence `(restr fV' M ⟶ restr fV' 𝟙_X) ≃ (restr V (pushforward β) M ⟶ restr V 𝟙_Y)`.
  - The close **consumes `restrictOverIso` (`\cref{lem:sheafofmodules_restrict_over_iso}`)
    and `unitOverIso` (`\cref{lem:sheafofmodules_unit_over_iso}`) localized to `V`**, plus the
    bridge from the open immersion `f` to `U := f.opensRange` (the iso `f ≅ U.ι`).
  - Added a `% NOTE:` recording that the LHS `Module 𝒪_Y(V)` structure is supplied via
    `Module.compHom (β.app V)` (not auto-synthesized).
  - Kept the thin-poset / `eqToHom`-conjugation / `image_preimage_of_le` /
    `Subsingleton.elim` rationale as the reason the localization is *light*.
- **Disambiguated** the shared root from the fixed-value-category equivalence
  `overSliceSheafEquiv` (`lem:open_immersion_slice_sheaf_equiv`): explicitly noted the
  module-level shared root is the one leg (A) requires. This keeps the existing caution
  paragraph (lines ~5813) consistent — it correctly excludes the *fixed-ring* equivalence,
  not the module-level shared root now cited.

## Cross-references introduced
- `\cref{def:sheafofmodules_over_equivalence}` — exists in `Picard_SheafOverEquivalence.tex` (verified).
- `\cref{lem:sheafofmodules_restrict_over_iso}` — exists in `Picard_SheafOverEquivalence.tex` (verified).
- `\cref{lem:sheafofmodules_unit_over_iso}` — exists in `Picard_SheafOverEquivalence.tex` (verified).
- `\cref{lem:pullbackObjUnitToUnit_comp}` (primary edit) — exists in this chapter, line 3194 (verified).
- `\cref{lem:open_immersion_slice_sheaf_equiv}` (retained, now used only as the contrast/exclusion) — exists, line 5583 (verified).

## References consulted
None this session — both edits are corrections to existing Archon-original proof prose
(no external `% SOURCE QUOTE` blocks added or altered). The corrected Sq2b math is grounded
in the iter-259 prover/`lean-vs-blueprint-checker` findings supplied verbatim in the directive;
the `ModuleCat` change-of-rings primitives are named, not quoted.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **`\uses` left untouched per directive.** The proof of `lem:dual_restrict_iso` now
  genuinely depends on the shared root (`def:sheafofmodules_over_equivalence`,
  `lem:sheafofmodules_restrict_over_iso`, `lem:sheafofmodules_unit_over_iso`). Its `\uses`
  lists (lemma block + proof block) currently only carry
  `{lem:internal_hom_isSheaf, lem:restrictscalars_ringiso_dualequiv}`. Consider adding the
  three shared-root labels to both `\uses` lists so the dependency graph reflects the
  route-(1) consumer — I did not add them because the directive scoped `\uses` edits to
  "broken targets only".
- The caution paragraph (~line 5813) distinguishing the fixed-value-category
  `overSliceSheafEquiv` from leg (A) remains valid and is now reinforced by an inline
  disambiguation in the `sliceDualTransport` paragraph; no contradiction introduced.

## Strategy-modifying findings
None.
