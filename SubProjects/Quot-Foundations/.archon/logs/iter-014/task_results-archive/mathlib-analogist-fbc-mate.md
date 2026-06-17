# Mathlib Analogist Report

## Mode
api-alignment

## Slug
fbc-mate

## Iteration
014

## Question
What Mathlib idiom expresses "the conjugate (mate) of an adjunction's unit, under a pair of comparison
isomorphisms, is the other adjunction's unit", so that `comparison(geometric unit) = algebraic unit`
(Seam 1, `AlgebraicGeometry.base_change_mate_unit_value`) is a one-step adjunction-calculus identity
rather than the failed element/`ext` chase through `conjugateIsoEquiv`?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Lemma that transports the UNIT across the conjugate | ALIGN_WITH_MATHLIB | critical |
| Split the composite units `adjL`/`adjR` | ALIGN_WITH_MATHLIB | critical |
| Q2: are `homEquiv_unit` / `leftAdjointUniq` the right tools? | PROCEED (answer: NO) | informational |
| Q3: pre-built unit-across-mate lemma to consume? | ALIGN_WITH_MATHLIB | critical |

## Direct answers to the three directive questions

**Q1 — yes.** Mathlib provides the unit-coherence lemmas directly, in
`Mathlib/CategoryTheory/Adjunction/Mates.lean` (`namespace CategoryTheory`, `open Adjunction`):

- `CategoryTheory.unit_conjugateEquiv (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) (α : L₂ ⟶ L₁) (c : C)` :
  `adj₁.unit.app c ≫ (conjugateEquiv adj₁ adj₂ α).app (L₁.obj c) = adj₂.unit.app c ≫ R₂.map (α.app c)`
- `CategoryTheory.unit_conjugateEquiv_symm (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) (α : R₁ ⟶ R₂) (c : C)` :
  `adj₁.unit.app c ≫ α.app (L₁.obj c) = adj₂.unit.app c ≫ R₂.map (((conjugateEquiv adj₁ adj₂).symm α).app c)`
- General versions (vertical functors not `𝟭`): `CategoryTheory.unit_mateEquiv` /
  `CategoryTheory.unit_mateEquiv_symm` (same file). Counit analogues for Seam 3 already in use:
  `CategoryTheory.conjugateEquiv_counit` / `conjugateEquiv_counit_symm`.
- Naming note: `Adjunction.transferNatTrans` was **renamed to `CategoryTheory.mateEquiv`**;
  `transferNatTransSelf` ≈ `conjugateEquiv`. `Adjunction.natIsoOfRightAdjointNatIso` (cited in the
  `pullback_spec_tilde_iso` docstring) is **deprecated in favor of `conjugateIsoEquiv`**
  (`Mathlib/CategoryTheory/Adjunction/Opposites.lean:88`) — the project code already uses the
  non-deprecated `conjugateIsoEquiv`, so only the docstring lags.

**Q2 — no.** `Adjunction.homEquiv_unit`/`homEquiv_counit` are the hom-set formula for a *single*
adjunction; they do not relate two adjunctions across a comparison and cannot rewrite
`pullback_spec_tilde_iso ∘ (geometric unit)`. `Adjunction.leftAdjointUniq` compares two left adjoints
of the **same** right adjoint; here the right adjoints differ (related by `gammaPushforwardNatIso`,
not equal), which is exactly why `conjugateIsoEquiv` was used. Use the conjugate unit-coherence lemmas
above, not these.

**Q3 — yes.** `unit_conjugateEquiv_symm` is precisely the "unit transported across a
`conjugateIsoEquiv`" lemma. Consume it; do not reprove element-wise. (`conjugateIsoEquiv` is `@[simps]`,
so `CategoryTheory.conjugateIsoEquiv_symm_apply_hom`/`_inv` connect the iso's `hom`/`inv` to the
underlying `conjugateEquiv.symm` map.)

## Must-fix-this-iter

The element-level `ext`/generator route for `base_change_mate_unit_value` (the open `sorry` at
`FlatBaseChange.lean:1010`) must be abandoned for the abstract conjugate calculus. Concrete recipe
(no step touches elements):

1. **Expose `adjL.unit`.** `simp only [Adjunction.comp_unit_app]` (and `tilde.adjunction`'s
   definitional `unit := toTildeΓNatIso.hom`, `Tilde.lean:280`) rewrites the seam's first two factors
   — `(tilde.toTildeΓNatIso.app M).hom ≫ Γ_A.map((pullbackPushforwardAdjunction (Spec inclA)).unit.app (tilde M))`
   — into `adjL.unit.app M`, where
   `adjL := tilde.adjunction.comp (pullbackPushforwardAdjunction (Spec inclA))`.

2. **Apply the unit coherence.** With `β := gammaPushforwardNatIso inclA : R₁ ≅ R₂` and
   `adjR := (extendRestrictScalarsAdj inclA.hom).comp (tilde.adjunction (R := A⊗R'))`, the lemma
   `unit_conjugateEquiv_symm adjL adjR β.hom M` gives
   ```
   adjL.unit.app M ≫ β.hom.app (L₁.obj M)
       = adjR.unit.app M ≫ R₂.map (((conjugateEquiv adjL adjR).symm β.hom).app M)
   ```
   and `((conjugateEquiv adjL adjR).symm β.hom).app M = (pullback_spec_tilde_iso inclA M).inv` via
   `conjugateIsoEquiv_symm_apply_hom` + the outer `Iso.symm` in the definition of
   `pullback_spec_tilde_iso` (`FlatBaseChange.lean:696`).

3. **Split `adjR.unit`.** `Adjunction.comp_unit_app` again peels off the RHS
   `(extendRestrictScalarsAdj inclA.hom).unit.app M` from the residual
   `(restrictScalars inclA.hom).map((tilde.adjunction (R := A⊗R')).unit.app ((extendScalars inclA.hom).obj M))`.

4. **Dictionary bridge (the only residue).** What remains is purely the identification of the seam's
   second bracket — assembled from `pushforward_spec_tilde_iso`, `tilde.toTildeΓNatIso`, and
   `Γ_A.map(pushforward.mapIso (pullback_spec_tilde_iso))` — with the `β.hom`/`R₂.map(pullback_iso.inv)`
   side from steps 2–3, after which the non-algebraic factors cancel (the trailing
   `(tilde.toTildeΓNatIso …).symm` cancels the residual tilde-Γ factor from step 3). This is a
   comparison of two **isos sharing the `gammaPushforwardIso` core** (`gammaPushforwardNatIso` vs
   `gammaPushforwardTildeIso`/`pushforward_spec_tilde_iso`), dischargeable by unfolding those
   project-local definitions — NOT an element chase.

Net effect: steps 1–3 are three named one-line rewrites; the irreducible work collapses to the single
structural iso identity in step 4 at the `gammaPushforwardIso` level.

## Informational

- All cited Mathlib names verified present at the project's pinned Mathlib via LSP/loogle:
  `CategoryTheory.unit_conjugateEquiv`, `unit_conjugateEquiv_symm`, `conjugateIsoEquiv`,
  `conjugateIsoEquiv_symm_apply_hom`, `CategoryTheory.Adjunction.comp_unit_app`,
  `AlgebraicGeometry.tilde.adjunction` (unit field `= toTildeΓNatIso.hom`),
  `Adjunction.natIsoOfRightAdjointNatIso` (deprecated → `conjugateIsoEquiv`).
- The seam's RHS being only `extendRestrictScalarsAdj.unit` (not the full `adjR.unit`) is *expected*:
  the seam's trailing inverse tilde-Γ unit is exactly the cancellation partner of `adjR.unit`'s second
  (`tilde.adjunction (R := A⊗R')`) factor — consistent with the `comp_unit_app` split in step 3.

## Persistent file
- `analogies/fbc-mate.md` — full design rationale + four-step recipe captured for future iters.

Overall verdict: ALIGN_WITH_MATHLIB — Seam 1 is a textbook conjugate-unit coherence; consume
`unit_conjugateEquiv_symm` (+ `Adjunction.comp_unit_app`), reducing the open `sorry` to one
project-local `gammaPushforwardIso`-level iso identity, with no element chase anywhere.
