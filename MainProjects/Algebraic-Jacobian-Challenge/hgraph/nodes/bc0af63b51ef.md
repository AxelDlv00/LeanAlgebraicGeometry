---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: CategoryTheory.InjectiveResolution.mono_horseshoe
docstring: 'The augmentation `β : B ⟶ I_A^0 ⊞ I_C^0` is a monomorphism (the base stage
  of the horseshoe

  recursion: `mono_biprod_lift_factorThru_of_exact` applied to the original short
  exact sequence).'
file: AlgebraicJacobian/Cohomology/AcyclicResolution.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.InjectiveResolution.mono_horseshoe
type: lean
updated: '2026-07-24T03:02:09'
---
lemma mono_horseshoeβ : Mono (horseshoeβ hses I_A I_C) := by
  haveI := hses.mono_f
  haveI : Injective (I_A.cocomplex.X 0) := I_A.injective 0
  -- The domain of `I_A.ι.f 0` is `((single₀).obj ses.X₁).X 0`, not syntactically `ses.X₁`; we
  -- ascribe the clean domain so the `Mono` instance matches the lemma's `α : S.X₁ ⟶ P`.
  haveI : Mono (show ses.X₁ ⟶ I_A.cocomplex.X 0 from I_A.ι.f 0) :=
    mono_of_isLimit_fork I_A.isLimitKernelFork
  haveI : Mono (show ses.X₃ ⟶ I_C.cocomplex.X 0 from I_C.ι.f 0) :=
    mono_of_isLimit_fork I_C.isLimitKernelFork
  exact mono_biprod_lift_factorThru_of_exact hses.exact
    (show ses.X₁ ⟶ I_A.cocomplex.X 0 from I_A.ι.f 0)
    (show ses.X₃ ⟶ I_C.cocomplex.X 0 from I_C.ι.f 0)