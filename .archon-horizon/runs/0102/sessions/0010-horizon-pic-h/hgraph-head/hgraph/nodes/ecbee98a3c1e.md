---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.exists_eq_comp_of_isIso_appTop_of_range_subset
docstring: '**Constancy of morphisms into affines.** A morphism `q : V ⟶ W` of schemes,
  where all global

  sections of `V` come from a base ring `R` (`IsIso sV.appTop` for a structure morphism

  `sV : V ⟶ Spec R`; e.g. `V` proper and geometrically integral over a field `R`)
  and the

  set-theoretic image of `q` is contained in an affine open `U` of `W`, is *constant*:
  it factors

  through the base as `q = sV ≫ z` for a point `z : Spec R ⟶ W`.'
file: AlgebraicJacobian/AbelianVariety/Rigidity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_eq_comp_of_isIso_appTop_of_range_subset
type: lean
updated: '2026-08-01T09:44:08'
---
theorem exists_eq_comp_of_isIso_appTop_of_range_subset {V W : Scheme.{u}} {R : CommRingCat.{u}}
    (sV : V ⟶ Spec R) [IsIso sV.appTop] (q : V ⟶ W) {U : W.Opens} (hU : IsAffineOpen U)
    (hq : Set.range ⇑q ⊆ (U : Set W)) :
    ∃ z : Spec R ⟶ W, q = sV ≫ z := by
  have : IsAffine U.toScheme := hU
  -- factor `q` through the open subscheme `U`
  have hfac : IsOpenImmersion.lift U.ι q (by rwa [Scheme.Opens.range_ι]) ≫ U.ι = q :=
    IsOpenImmersion.lift_fac _ _ _
  set q' : V ⟶ U.toScheme := IsOpenImmersion.lift U.ι q (by rwa [Scheme.Opens.range_ι])
  refine ⟨(Spec R).toSpecΓ ≫ inv (Spec.map sV.appTop) ≫ Spec.map q'.appTop ≫
    U.toScheme.isoSpec.inv ≫ U.ι, ?_⟩
  have h1 : sV ≫ (Spec R).toSpecΓ ≫ inv (Spec.map sV.appTop) = V.toSpecΓ := by
    rw [← Category.assoc, Scheme.toSpecΓ_naturality, Category.assoc, IsIso.hom_inv_id,
      Category.comp_id]
  have h2 : V.toSpecΓ ≫ Spec.map q'.appTop ≫ U.toScheme.isoSpec.inv = q' := by
    rw [← Category.assoc, ← Scheme.toSpecΓ_naturality, Category.assoc,
      Scheme.toSpecΓ_isoSpec_inv, Category.comp_id]
  rw [reassoc_of% h1, reassoc_of% h2, hfac]

set_option backward.isDefEq.respectTransparency false in