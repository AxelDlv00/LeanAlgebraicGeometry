---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.qcoh_section_kernel_comparison
docstring: '**Kernel comparison (Stacks 01HV(4)/01I8), packaged form.**  For a quasi-coherent
  `F` on

  `Spec R` and `f ∈ R`, the canonical `R`-linear localisation lift `Γ(X, F)_f → Γ(D(f),
  F)` of the

  section-restriction `ρ_f` is an isomorphism: explicitly, `LocalizedModule (powers
  f) Γ(X, F)` is

  linearly equivalent to `Γ(D(f), F)`.  This is the `IsLocalizedModule.iso` repackaging
  of the

  keystone `qcoh_section_isLocalizedModule`; it is the form the blueprint kernel-comparison
  node

  names and that the `D(f)`-component of `fromTildeΓ` consumes.  Project-local.'
file: AlgebraicJacobian/Cohomology/QcohTildeSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.qcoh_section_kernel_comparison
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def qcoh_section_kernel_comparison (F : (Spec R).Modules) [F.IsQuasicoherent]
    (f : R) :
    LocalizedModule (Submonoid.powers f)
        ((modulesSpecToSheaf.obj F).presheaf.obj (Opposite.op (⊤ : (Spec R).Opens)))
      ≃ₗ[R] (modulesSpecToSheaf.obj F).presheaf.obj (Opposite.op (PrimeSpectrum.basicOpen f)) :=
  @IsLocalizedModule.iso _ _ (Submonoid.powers f) _ _ _ _ _ _ _
    (qcoh_section_isLocalizedModule F f)

end KernelComparisonAssembly

/-! ## Project-local Mathlib supplement — Route B assembly: the tilde–Γ counit is an iso (01I8)

`isIso_fromTildeΓ_of_quasicoherent` is the LAST step of Stacks 01I8: for a quasi-coherent `F` on
`Spec R` the tilde–Γ counit `fromTildeΓ : tilde(Γ F) ⟶ F` is an isomorphism.  It is checked on the
basis of distinguished opens `{D(r)}`: the `D(r)`-component of the underlying sheaf morphism is the
localization lift of the section-restriction `ρ_r` along `tilde.toOpen` (Mathlib's
`toOpen_fromTildeΓ_app`), and since both `tilde.toOpen` (Mathlib instance) and `ρ_r` (the keystone
`qcoh_section_isLocalizedModule`) are localizations of `Γ(X,F)` at the powers of `r`, that lift is an
iso (`IsLocalizedModule.linearEquiv_of_isLocalizedModule_comp`).  Registered as an `instance`, so the
conditional `qcoh_iso_tilde_sections F` becomes available unconditionally for quasi-coherent `F`. -/

section IsoFromTildeGammaAssembly

open PrimeSpectrum