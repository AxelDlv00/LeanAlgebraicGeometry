---
author: sync
content_type: theorem
created: '2026-07-18T03:38:56'
decl: TwoLatticePair.Hom.moduleFinite_aeval_kernelPair_t
docstring: 'Over a Noetherian ring, the chart-1 kernel lattice of a map out of a finite
  pair is

  again finite over `R[X]`.'
file: AlgebraicJacobian/Cohomology/RigidEngineLatticeCoherence.lean
generated: lean
lean_status: lean_ok
title: TwoLatticePair.Hom.moduleFinite_aeval_kernelPair_t
type: lean
updated: '2026-07-22T09:14:47'
---
theorem moduleFinite_aeval_kernelPair_t₁ [IsNoetherianRing R]
    [Module.Finite R[X] (Module.AEval' P.t₁)] (f : P.Hom P') :
    Module.Finite R[X] (Module.AEval' (kernelPair f).t₁) := by
  let g : Module.AEval' (kernelPair f).t₁ →ₗ[R[X]] Module.AEval' P.t₁ :=
    LinearMap.ofAEval (kernelPair f).t₁
      ((Module.AEval'.of P.t₁).toLinearMap ∘ₗ (LinearMap.ker f.hom₁).subtype)
      fun z => (Module.AEval'.X_smul_of P.t₁ (z : M₁)).symm
  have hg : Function.Injective g := fun z w h =>
    (Module.AEval'.of (kernelPair f).t₁).symm.injective
      (Subtype.ext ((Module.AEval'.of P.t₁).injective h))
  haveI : IsNoetherian R[X] (Module.AEval' P.t₁) :=
    isNoetherian_of_isNoetherianRing_of_finite R[X] _
  haveI : IsNoetherian R[X] (Module.AEval' (kernelPair f).t₁) :=
    isNoetherian_of_injective g hg
  infer_instance

end Hom

/-! ### The coherence theorems -/

variable (P) in