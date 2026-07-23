---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.epi_pullbackKernelComparison
docstring: '**The kernel–pullback comparison is an epimorphism whenever `q` is an

  epimorphism.**  This is the categorical (right-exact) half of the isomorphism

  claim in `Scheme.Modules.pullback_kernel_isLocallyTrivial`: the module pullback

  `g''^*` is a left adjoint

  (`Scheme.Modules.pullbackPushforwardAdjunction`), hence preserves cokernels, so

  applied to the short exact sequence `0 → ker q → E → F → 0` (`q` epi, so `F` is

  the cokernel of `ker q ↪ E`) it stays right exact: `g''^*(ker q) → g''^*E →

  g''^*F → 0` is exact.  Exactness at `g''^*E` says precisely that the kernel lift

  `g''^*(ker q) → ker (g''^* q)` — which is `pullbackKernelComparison g'' q` — is
  an

  epimorphism.  (The remaining monomorphism half is the genuine flat-base-change

  content, requiring `F` flat over the base, and is handled in

  `pullback_kernel_isLocallyTrivial`.)'
file: AlgebraicJacobian/Picard/FlatKernelBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.epi_pullbackKernelComparison
type: lean
updated: '2026-07-24T03:02:10'
---
lemma Modules.epi_pullbackKernelComparison
    {X' X : Scheme.{u}} (g' : X' ⟶ X) {E F : X.Modules} (q : E ⟶ F) [Epi q] :
    Epi (Modules.pullbackKernelComparison g' q) := by
  haveI : PreservesColimitsOfSize.{0, 0} (Scheme.Modules.pullback g') :=
    (Scheme.Modules.pullbackPushforwardAdjunction g').leftAdjoint_preservesColimits
  have hSG := (CategoryTheory.ShortComplex.exact_kernel q).map_of_epi_of_preservesCokernel
    (Scheme.Modules.pullback g') ‹Epi q› inferInstance
  exact hSG.epi_kernelLift