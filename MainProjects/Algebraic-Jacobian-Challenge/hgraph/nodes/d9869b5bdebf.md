---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.section_localization_hfr_basicOpen
docstring: '**(producer, TOP) Basic-open `Hfr` from the per-element P1 transport.**  For
  a quasi-coherent

  `M` on `Spec R`, a basic open `D(s) ≤ q.X i`, and `f : R`, the section restriction

  `Γ(M, D(s)) → Γ(M, D(f) ⊓ D(s))` is `IsLocalizedModule (powers f)` over `R`.  This
  is the gated

  basic-open `Hfr` datum consumed by `isLocalizedModule_basicOpen_descent_of_basicOpen_cover`.


  Thin wrapper around `section_localization_hfr_aux`: it instantiates the abstract
  open immersion at

  the concrete composite immersion `j = compositeBasicOpenImmersion`, supplies the
  P1 datum

  `pullback_composite_immersion_isIso_fromTildeΓ`, picks `f'' = σ⁻¹(algebraMap R A
  f)` (so `hf''` is

  `σ.apply_symm_apply`), and identifies the `j ''''ᵁ`-form opens with `D(s)` (`opensRange`)
  and

  `D(f) ⊓ D(s)` (`image_basicOpen_eq_inf`).  Project-local: the geometric producer
  of the gap1

  keystone `Hfr`.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.section_localization_hfr_basicOpen
type: lean
updated: '2026-07-16T21:14:27'
---
theorem section_localization_hfr_basicOpen {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (q : M.QuasicoherentData) (f s : R) (i : q.I)
    (hs : (PrimeSpectrum.basicOpen s : (Spec R).Opens) ≤ q.X i) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen s
          ≤ PrimeSpectrum.basicOpen s)).op).hom := by
  set S := Γ(↑(q.X i), (Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen s)) with hS
  set j := compositeBasicOpenImmersion M q s i hs with hj
  set A := Γ(Spec R, j ''ᵁ (⊤ : (Spec S).Opens)) with hA
  let algRA : (R : Type _) →+* (A : Type _) :=
    ((Spec R).presheaf.map (homOfLE (le_top : (j ''ᵁ ⊤) ≤ ⊤)).op).hom.comp
      (Scheme.ΓSpecIso R).inv.hom
  letI instAlg : Algebra (R : Type _) (A : Type _) := RingHom.toAlgebra algRA
  let σ : (S : Type _) ≃+* (A : Type _) :=
    (Scheme.ΓSpecIso S).symm.commRingCatIsoToRingEquiv.trans (gammaImageRingEquiv j ⊤)
  let f' : (S : Type _) := σ.symm (algebraMap (R : Type _) (A : Type _) f)
  have hf' : (j.appIso ⊤).inv ((Scheme.ΓSpecIso S).inv f')
      = (Spec R).presheaf.map (homOfLE (le_top : (j ''ᵁ ⊤) ≤ ⊤)).op
          ((Scheme.ΓSpecIso R).inv f) := σ.apply_symm_apply _
  have eT : (j ''ᵁ (⊤ : (Spec S).Opens)) = PrimeSpectrum.basicOpen s :=
    (Scheme.Hom.image_top_eq_opensRange j).trans
      (compositeBasicOpenImmersion_opensRange M q s i hs)
  have eB : (j ''ᵁ (PrimeSpectrum.basicOpen f'))
      = PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen s := by
    rw [image_basicOpen_eq_inf j f' ((Scheme.ΓSpecIso R).inv f) hf', eT, basicOpen_eq_of_affine]
    exact inf_comm _ _
  exact section_localization_hfr_aux M j
    (pullback_composite_immersion_isIso_fromTildeΓ M q s i hs) f f'
    (PrimeSpectrum.basicOpen s) (PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen s)
    inf_le_right eT eB hf'

/-! ## Project-local Mathlib supplement — gap2 single-chart transport

The general-scheme keystone `lem:qcoh_section_localization_basicOpen`
(`isLocalizedModule_basicOpen`): for a quasi-coherent sheaf of modules `M` on an *arbitrary* scheme
`X`, an affine open `U`, and `f : Γ(X, U)`, the section restriction `Γ(M, U) → Γ(M, D(f))` is
`IsLocalizedModule (powers f)` over `Γ(X, U)`.

It is the single-chart affine transport on top of G1-core: pull `M` back along the affine immersion
`hU.fromSpec : Spec Γ(X, U) ⟶ X` (range `U`), so the pullback `M'` is quasi-coherent on
`Spec Γ(X, U)`, where gap1 gives `IsIso M'.fromTildeΓ`; the engine
`isLocalizedModule_restrict_of_isIso_fromTildeΓ` localizes the slice restriction over `Γ(X, U)`, and
the `σ`-semilinear section comparison `gammaPullbackImageIso` (bridge (I)
`isLocalizedModule_of_ringEquiv_semilinear`) transports it to the `M`-side restriction. No
cover-and-glue: `U` is already affine, so there is a single chart. -/