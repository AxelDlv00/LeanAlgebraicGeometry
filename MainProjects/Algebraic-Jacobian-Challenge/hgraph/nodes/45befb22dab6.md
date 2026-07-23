---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.tilde_section_isLocalizedModule
docstring: '**Route B local model (pure `tilde` case).**  For an `R`-module `M`, the
  section-restriction map

  `Γ(Spec R, M^~) → Γ(D(f), M^~)` of the associated sheaf exhibits its target as the
  localization of

  its source at the powers of `f`: `IsLocalizedModule (powers f)` of that restriction.  This
  is the

  section-restriction form of Mathlib''s `tilde.toOpen` localization instance (which
  localizes `M`

  itself, not the global sections `Γ(⊤, M^~)`), obtained by transporting along the
  global-sections

  isomorphism `tilde.isoTop`.  Project-local; the load-bearing local model of the
  keystone

  `qcoh_section_isLocalizedModule`.'
file: AlgebraicJacobian/Cohomology/QcohTildeSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.tilde_section_isLocalizedModule
type: lean
updated: '2026-07-16T21:14:26'
---
lemma tilde_section_isLocalizedModule (M : ModuleCat.{u} R) (f : R) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj (tilde M)).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := by
  have key := tilde.toOpen_res M ⊤ (PrimeSpectrum.basicOpen f) (homOfLE le_top)
  -- `toOpen M ⊤` is an isomorphism; view it as a linear equivalence `eTop : M ≃ₗ Γ(⊤, M^~)`
  set eTop : M ≃ₗ[R] _ := (asIso (tilde.toOpen M ⊤)).toLinearEquiv with heTop
  -- the section-restriction equals `toOpen (D f) ∘ eTop⁻¹` as linear maps
  have hmap : ((modulesSpecToSheaf.obj (tilde M)).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom
      = (tilde.toOpen M (PrimeSpectrum.basicOpen f)).hom ∘ₗ eTop.symm.toLinearMap := by
    apply LinearMap.ext
    intro x
    have hk := congrArg (fun (m : M ⟶ _) => m.hom (eTop.symm x)) key
    simp only [ModuleCat.hom_comp, LinearMap.comp_apply] at hk
    have heq : ⇑eTop = ⇑(tilde.toOpen M ⊤).hom := by rw [heTop]; ext y; simp
    have htop : (tilde.toOpen M ⊤).hom (eTop.symm x) = x := by
      rw [← heq]; exact eTop.apply_symm_apply x
    conv_lhs => rw [← htop]
    exact hk
  rw [hmap]
  exact IsLocalizedModule.of_linearEquiv_right (Submonoid.powers f)
    (tilde.toOpen M (PrimeSpectrum.basicOpen f)).hom eTop.symm