/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.ModulesFunctor
import AlgebraicJacobian.Cohomology.AffineSerreVanishing
import AlgebraicJacobian.RiemannRoch.Ledger.ChiSlice

/-!
# Lifting module sections using cohomology over the ground ring

Restriction from structure-sheaf modules to sheaves of ground-ring modules
preserves kernels and epimorphisms. Consequently, vanishing of the kernel's
`Sheaf.HModule` in degree one lifts global sections through a module epimorphism.
This uses the same cohomology as the divisor-sheaf vanishing theorems.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry.Scheme

variable {k : Type u} [CommRing k] (C : Over (Spec (CommRingCat.of k)))

instance : (toModuleKSheafOfModulesFunctor C).Additive where
  map_add := by intros; ext U x; rfl

instance : PreservesFiniteLimits (toModuleKSheafOfModulesFunctor C) := by
  let J := Opens.grothendieckTopology C.left.toTopCat
  let U := sheafCompose J (forget₂ (ModuleCat.{u} k) AddCommGrpCat.{u})
  letI : PreservesFiniteLimits (U ⋙ sheafToPresheaf J AddCommGrpCat.{u}) :=
    inferInstanceAs (PreservesFiniteLimits (sheafToPresheaf J (ModuleCat.{u} k) ⋙
      (Functor.whiskeringRight _ _ _).obj (forget₂ (ModuleCat.{u} k) AddCommGrpCat.{u})))
  letI : PreservesFiniteLimits U :=
    preservesFiniteLimits_of_reflects_of_preserves U (sheafToPresheaf J AddCommGrpCat.{u})
  letI : ReflectsFiniteLimits U := reflectsFiniteLimits_of_reflectsIsomorphisms U
  letI : PreservesFiniteLimits (toModuleKSheafOfModulesFunctor C ⋙ U) :=
    inferInstanceAs (PreservesFiniteLimits (SheafOfModules.toSheaf C.left.ringCatSheaf))
  exact preservesFiniteLimits_of_reflects_of_preserves _ U

instance : (toModuleKSheafOfModulesFunctor C).PreservesEpimorphisms where
  preserves {M N} f := by
    intro hf
    let U := sheafCompose (Opens.grothendieckTopology C.left.toTopCat)
      (forget₂ (ModuleCat.{u} k) AddCommGrpCat.{u})
    apply U.epi_of_epi_map
    change Epi ((SheafOfModules.toSheaf C.left.ringCatSheaf).map f)
    exact @Functor.map_epi _ _ _ _ (SheafOfModules.toSheaf C.left.ringCatSheaf)
      (toSheaf_preservesEpimorphisms C.left.ringCatSheaf) _ _ f hf

/-- Vanishing of ground-ring cohomology of the kernel lifts global sections
through an epimorphism of structure-sheaf modules. -/
theorem sections_surjective_of_kernel_hModule_one_subsingleton
    {M N : C.left.Modules} (q : M ⟶ N) [Epi q]
    [Subsingleton ((toModuleKSheafOfModules C (kernel q)).HModule 1)] :
    Function.Surjective (q.app ⊤).hom := by
  let F := toModuleKSheafOfModulesFunctor C
  let S := ShortComplex.mk (F.map (kernel.ι q)) (F.map q)
    (by rw [← F.map_comp, kernel.condition, F.map_zero])
  have hS : S.ShortExact :=
    { exact := S.exact_of_f_is_kernel
        (isLimitForkMapOfIsLimit' F (kernel.condition q) (kernelIsKernel q)) }
  letI : Subsingleton (S.X₁.HModule 1) :=
    inferInstanceAs (Subsingleton ((toModuleKSheafOfModules C (kernel q)).HModule 1))
  intro y
  let e₂ := Sheaf.HModule.linearEquiv₀ _ isTerminalTop S.X₂
  let e₃ := Sheaf.HModule.linearEquiv₀ _ isTerminalTop S.X₃
  obtain ⟨z, hz⟩ := (Sheaf.HModule.exact_map_g_delta hS (show 0 + 1 = 1 from rfl)
    (e₃.symm y)).mp (Subsingleton.elim _ 0)
  refine ⟨e₂ z, ?_⟩
  change (S.g.hom.app (Opposite.op ⊤)).hom (e₂ z) = y
  rw [Sheaf.HModule.linearEquiv₀_naturality]
  change e₃ (Sheaf.HModule.map S.g 0 z) = y
  rw [hz, e₃.apply_symm_apply]

end AlgebraicGeometry.Scheme
