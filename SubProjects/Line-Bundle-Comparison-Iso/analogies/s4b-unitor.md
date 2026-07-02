# Analogy: shape of the S4b unit-restriction coherence (unit analogue of Bridge B1)

## Mode
api-alignment

## Slug
s4b-unitor

## Iteration
055

## Question
We are about to add a new project-bespoke coherence lemma to the blueprint (the unit analogue of
Bridge B1). Does Mathlib already provide the idiom, and what is the aligned shape?

## Project artifact(s)
- `TensorObjSubstrate.lean:310` — `tensorObj_unit_iso = sheafification.mapIso (λ_ 𝟙_) ≪≫ counit.app 𝒪`.
- `TensorObjSubstrate.lean:323/333` — `tensorObj_left_unitor`/`tensorObj_right_unitor` (same shape, general `M`).
- `TensorObjInverse.lean:1129` — `tensorObj_unit_iso_restrict_compat` (S4b stub, `sorry`).
- `TensorObjInverse.lean:1027` — S2 `tensorObj_restrict_iso_restrict_compat` (PROVEN, Bridge-B1 route).
- `TensorObjInverse.lean:1146` — S4c `trivialisation_uIota_restrict_compat` (PROVEN; `pullbackUnitIso` η-leg).
- `DualInverse.lean:350` — `dual_unit_iso` (identical `sheafification.mapIso(presheaf-iso) ≪≫ counit` shape);
  its naturality core `presheafDualUnitIso_naturality` was closed as a BESPOKE square (memory).

## Decisions identified

### Decision 1: is there a Mathlib monoidal-functor left-unitor coherence lemma to instantiate?
- **Mathlib idiom**: YES, full API in `Mathlib.CategoryTheory.Monoidal.Functor`:
  - `CategoryTheory.Functor.OplaxMonoidal.left_unitality_hom` [verified] —
    `δ F (𝟙_C) X ≫ (η F ▷ F.obj X) ≫ (λ_ (F.obj X)).hom = F.map (λ_ X).hom`.
  - `CategoryTheory.Functor.Monoidal.map_leftUnitor` [verified] — same identity for a strong-monoidal `F`.
  - `CategoryTheory.Functor.LaxMonoidal.left_unitality_inv` /
    `CategoryTheory.Functor.LaxMonoidal.tensorUnit_whiskerLeft_comp_leftUnitor_hom` [verified] (lax dual).
  These require `F.OplaxMonoidal` / `F.Monoidal` as an instance on the functor whose `map (λ_)` you rewrite.
- **Project's path**: would need the **restriction functor** (= change-of-rings presheaf `pullback φ` then
  `sheafification`, the carrier of `restrictFunctor j`) to be a registered `Functor.Monoidal`/`OplaxMonoidal`.
- **Gap**: divergent-with-cost — the instance does not exist (see Decision 2). The lemma is the right *template*
  for the bespoke square's SHAPE, but cannot be applied directly.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL (for the instance route).

### Decision 2: does Mathlib make the restriction/pullback/sheafification functor monoidal?
- **Mathlib idiom for sheafification monoidality**: `CategoryTheory.Sheaf.instMonoidalFunctorOppositePresheafToSheaf`
  / `CategoryTheory.Sheaf.monoidalCategory` (`Mathlib.CategoryTheory.Sites.Monoidal`) [verified] — but ONLY for
  `presheafToSheaf J A` over a **fixed** monoidal `A`, needing `[J.W.IsMonoidal]`. The `ModuleCat R` instance
  (`LightCondensed…presheafToSheaf` ) is also fixed-ring.
- **Project's functor is different**: `PresheafOfModules.sheafification α : PresheafOfModules R₀ → SheafOfModules R`
  (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`) [verified] is the **change-of-rings** sheafification
  (project uses `α = 𝟙`), and `restrictFunctor j` also threads `PresheafOfModules.pullback φ`
  (`…Presheaf.Pullback`) which **changes the base ring** along the immersion. Mathlib gives `pullback` only the
  structural isos `pullbackComp`/`pullbackId`/`pullback_assoc` (pseudofunctor data), NOT a `Functor.Monoidal` /
  `OplaxMonoidal` instance.
- **Verified absent**: loogle `PresheafOfModules.pullback, MonoidalCategory` → no results;
  `PresheafOfModules.sheafification, Functor.OplaxMonoidal` → no results.
- **Cost of building it**: change-of-rings pullback `S ⊗_R −` IS strong monoidal mathematically; the project has
  ALREADY hand-built its components — `pullbackTensorMap` is the (co)tensorator δ, `pullbackUnitIso`/
  `pullbackObjUnitToUnit` is the unit map η. Registering `Functor.Monoidal (pullback φ)` from these + sheafification
  would make S2/S4a/S4b/S3 all follow from Mathlib coherence — a real win but a LARGE refactor, out of S4b scope.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL.

### Decision 3: aligned shape for the S4b ingredient — monoidal instance vs bespoke `Iso.ext` square?
- **Aligned shape = bespoke naturality `Iso.ext` square**, matching the established project idiom (S2 Bridge-B1,
  S4c `pullbackUnitIso`, and the dual-side `presheafDualUnitIso_naturality` were all bespoke squares).
- The square's SHAPE is dictated by the Mathlib template `Monoidal.map_leftUnitor`
  (`F(λ_) = δ ≫ (η ▷ FX) ≫ λ_`) instantiated by hand at the project's own δ/η:
  - **presheaf `λ_`**: `PresheafOfModules.monoidalCategoryStruct.leftUnitor` /
    `MonoidalCategory.leftUnitor` on `PresheafOfModules (X.presheaf ⋙ forget₂ …)` [verified].
  - **η-leg (unit preservation)**: `unitRestrictIso j` = `(RFIP j).app 𝒪 ≪≫ pullbackUnitIso j`
    (project; `pullbackObjUnitToUnit`), the SAME map S4c proved coherent.
  - **δ-leg (tensor on the unit pair)**: reuse S2 `tensorObj_restrict_iso j 𝒪 𝒪` / `pullbackTensorMap` —
    already in the S4b RHS telescope.
  - **outer sheafification + counit**: `sheafificationAdjunction.counit` is a `NatTrans` (naturality free);
    `Functor.mapIso` naturality + `CategoryTheory.toSheafify_naturality` [verified] cross the sheafify seam.
- **Verdict**: PROCEED (bespoke square) — with the Mathlib unitor lemma as the proof-shape oracle.

## Recommendation
Do NOT try to instantiate Mathlib's `Functor.OplaxMonoidal.left_unitality_hom` directly: the restriction
functor (change-of-rings presheaf `pullback` ⋙ `sheafification`) carries no `Functor.Monoidal` instance in
Mathlib, and Mathlib's monoidal sheafification (`Sheaf.monoidalCategory`, `presheafToSheaf.Monoidal`) is
fixed-ring only — instantiating it would require first building the missing monoidal-functor instance from the
project's `pullbackTensorMap` (δ) and `pullbackUnitIso` (η). For S4b alone, state the new ingredient as a
**bespoke naturality `Iso.ext` square** in the project's existing idiom (the same one that closed S2 and S4c and
the dual-side `presheafDualUnitIso_naturality`): peel `tensorObj_unit_iso = sheafification.mapIso(λ_ 𝟙_) ≪≫ counit`,
push the presheaf left unitor `λ_ 𝟙_` past the pullback using the `Monoidal.map_leftUnitor` *shape*
(δ = `pullbackTensorMap`/S2, η = `pullbackUnitIso`/`unitRestrictIso`/S4c), then close the sheafify+counit seam by
`Functor.mapIso`/`toSheafify` naturality and `sheafificationAdjunction.counit` naturality. Record the larger
opportunity — register `Functor.Monoidal (PresheafOfModules.pullback φ)` from the already-built δ/η to collapse
S2/S3/S4a/S4b into Mathlib coherence — as a future refactor, not an S4b obligation.

Useful extra: since the unit-self case is `λ_ (𝟙_)`, `CategoryTheory.MonoidalCategory.unitors_equal`
(`λ_ (𝟙_ C) = ρ_ (𝟙_ C)`) lets the prover share machinery between `tensorObj_unit_iso` (S4b) and the
right-unitor flank if convenient.
