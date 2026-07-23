---
author: sync
content_type: theorem
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.affine_tildeVanishing
docstring: '**The standard-cover {\v C}ech vanishing residual `htilde`, discharged
  unconditionally.**  For a

  quasi-coherent `𝒪_{Spec R}`-module `F` with global module `M = Γ(Spec R, F)`, the
  positive-degree

  section {\v C}ech cohomology of the tilde sheaf `~M` over any standard cover `i
  ↦ D(gᵢ)` of a

  distinguished open `D(f)` vanishes. This is exactly the hypothesis fed to the `_of_tildeVanishing`

  forms, now proved by the change-of-base-to-`R_f` theorem

  `sectionCech_homology_exact_of_localizationAway` (with `ι := ULift (Fin n)`, `s
  := g ∘ down`).

  Project-local: bundles the residual leaf in the precise shape both 02KG tops consume.'
file: AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.affine_tildeVanishing
type: lean
updated: '2026-07-16T21:14:25'
---
private theorem affine_tildeVanishing {R : CommRingCat.{u}} (F : (Spec R).Modules)
    (n : ℕ) (g : Fin n → R) (f : R)
    (hcov : (PrimeSpectrum.basicOpen f : (Spec R).Opens)
      = ⨆ i : ULift.{u} (Fin n), PrimeSpectrum.basicOpen (g i.down))
    (p : ℕ) (hp : 0 < p) :
    IsZero (cechCohomology
      (fun i : ULift.{u} (Fin n) => PrimeSpectrum.basicOpen (g i.down))
      ((Scheme.Modules.toPresheafOfModules (Spec R)).obj
        (tilde (moduleSpecΓFunctor.obj F))) p) :=
  sectionCech_homology_exact_of_localizationAway (moduleSpecΓFunctor.obj F)
    (fun i : ULift.{u} (Fin n) => g i.down) f hcov p hp