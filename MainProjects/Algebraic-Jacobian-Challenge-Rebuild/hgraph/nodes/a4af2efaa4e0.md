---
author: sync
content_type: theorem
created: '2026-07-22T01:02:01'
decl: AlgebraicGeometry.ker_rTensor_le_range_subtype_of_flat_range_quotient
docstring: 'Flatness of the target cokernel forces the fibre kernel to be generated
  by

  the base-changed global kernel.  Indeed, the injectivization

  `M ⧸ ker δ → N` has cokernel `N ⧸ range δ`; flatness of that cokernel makes the

  injectivization universally injective.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowSyzygy.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ker_rTensor_le_range_subtype_of_flat_range_quotient
type: lean
updated: '2026-07-31T20:14:48'
---
theorem ker_rTensor_le_range_subtype_of_flat_range_quotient
    (δ : M →ₗ[R] N)
    [Module.Flat R (N ⧸ LinearMap.range δ)]
    (A : Type u) [AddCommGroup A] [Module R A] :
    LinearMap.ker (δ.rTensor A) ≤
      LinearMap.range ((LinearMap.ker δ).subtype.rTensor A) := by
  apply (ker_rTensor_le_range_subtype_iff_liftQ_rTensor_injective δ A).mpr
  set fbar := (LinearMap.ker δ).liftQ δ le_rfl with hfbar
  have hfbar_inj : Function.Injective fbar := by
    rw [← LinearMap.ker_eq_bot, hfbar]
    exact Submodule.ker_liftQ_eq_bot' _ δ rfl
  have hexact : Function.Exact fbar (LinearMap.range δ).mkQ := by
    rw [LinearMap.exact_iff, Submodule.ker_mkQ, hfbar, Submodule.range_liftQ]
  have hleft : Function.Injective (fbar.lTensor A) :=
    LinearMap.lTensor_injective_of_exact_of_flat
      (LinearMap.range δ).mkQ (Submodule.mkQ_surjective _)
      fbar hfbar_inj hexact A
  exact (LinearMap.lTensor_inj_iff_rTensor_inj (M := A) (f := fbar)).mp hleft

end KernelSpan

/-! ## Specialization to the recursive high-window map -/

section HighWindowSyzygy

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi] [IsDominant pi]

noncomputable local instance instOverCleftHighWindowSyzygy :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))]
  [QuasiCompact (C.left ↘ Spec (.of k))]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g r1 r2 : Nat)
variable (b1 : Module.Basis (Fin r1) k
  ↥(Scheme.divisorSections k (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
variable (b2 : Module.Basis (Fin r2) k
  ↥(Scheme.divisorSections k ((windowS_choice pi hpi g • fiberWeilDivisor pi) +
    (windowM_choice pi hpi g • fiberWeilDivisor pi)) ⊤))
variable (i : (glueData k g r1).J) (j : (glueData k g r2).J)

local notation "RZ" => DivCarveChartRing k
  (windowS_choice pi hpi g • fiberWeilDivisor pi)
  (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1 b2 i j

set_option maxHeartbeats 1600000 in
-- The dependent high-window multiplication kernel exceeds the default elaboration budget.
set_option synthInstance.maxHeartbeats 400000 in
-- Its carve-ring module instances require deeper synthesis than the global default.