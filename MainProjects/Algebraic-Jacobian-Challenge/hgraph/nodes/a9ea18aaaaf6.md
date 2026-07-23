---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.mapHC_augment_iso
docstring: 'Applying an additive functor `Φ` degreewise to a cochain complex commutes
  with

  augmenting: `Φ(C.augment f) ≅ (Φ C).augment (Φ f)`, with identity components.  This
  peels

  the augmentation node off the evaluated complex `D` so the remaining identification
  is between

  the *non-augmented* complexes.'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mapHC_augment_iso
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def mapHC_augment_iso {V₁ V₂ : Type*} [Category V₁] [Category V₂]
    [Preadditive V₁] [Preadditive V₂] (Φ : V₁ ⥤ V₂) (hΦ : Φ.Additive)
    (C : CochainComplex V₁ ℕ) {Y : V₁} (f : Y ⟶ C.X 0) (w : f ≫ C.d 0 1 = 0) :
    (Φ.mapHomologicalComplex (ComplexShape.up ℕ)).obj (C.augment f w) ≅
      CochainComplex.augment ((Φ.mapHomologicalComplex (ComplexShape.up ℕ)).obj C) (Φ.map f)
        (by
          haveI := hΦ
          change Φ.map f ≫ Φ.map (C.d 0 1) = 0
          rw [← Functor.map_comp, w, Φ.map_zero]) := by
  haveI := hΦ
  refine HomologicalComplex.Hom.isoOfComponents
    (fun i => match i with | 0 => Iso.refl _ | _ + 1 => Iso.refl _) ?_
  intro i j hij
  obtain rfl : i + 1 = j := hij
  match i with
  | 0 =>
    -- both components are `Iso.refl`; strip identities, then both `d 0 1`s reduce to `Φ.map f`
    -- (RHS augment directly, LHS `Φ.map` of `augment_d_zero_one`).
    simp only [Iso.refl_hom, Functor.mapHomologicalComplex_obj_d,
      Category.id_comp, Category.comp_id]
    rw [CochainComplex.augment_d_zero_one, CochainComplex.augment_d_zero_one]
  | n + 1 =>
    -- both `d (n+1) (n+2)`s reduce to `Φ.map (C.d n (n+1))` via `augment_d_succ_succ`.
    simp only [Iso.refl_hom, Functor.mapHomologicalComplex_obj_d,
      CochainComplex.augment_d_succ_succ, Category.id_comp, Category.comp_id]