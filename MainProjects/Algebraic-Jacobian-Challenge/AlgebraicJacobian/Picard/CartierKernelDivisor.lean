/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.CartierKernelLocalEquation
import AlgebraicJacobian.Picard.DivisorModules
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.ModulesFunctor
import AlgebraicJacobian.RiemannRoch.Ledger.ChiCurve

/-!
# Cartier kernels and principal Weil divisors on a smooth curve

A trivialized invertible ideal has a regular equation. Its generic germ
defines a principal Weil divisor, and multiplication by that germ identifies
the kernel with the corresponding divisor module. The section-value formula
identifies this comparison with the original ideal inclusion.

This is the local smooth-curve interpretation of Kleiman, *The Picard
scheme*, section 3, `sb:ediv`, where `O(-D)` is the Cartier ideal.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry.Scheme.CartierKernel

set_option backward.isDefEq.respectTransparency false in
/-- An equation of an invertible ideal on an integral scheme is nonzero. -/
theorem localEquation_ne_zero {X : Scheme.{u}} [IsIntegral X] {E F : X.Modules}
    (q : E ⟶ F) (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : kernel q ≅ SheafOfModules.unit X.ringCatSheaf) :
    localEquation q eO eI ≠ 0 := by
  intro ha
  have h : (1 : Γ(X, ⊤)) = 0 :=
    localEquation_mul_injective q eO eI ⊤ (by simp [ha])
  exact one_ne_zero h

/-- The nonzero generic germ of a Cartier equation, as a function-field unit. -/
noncomputable def localEquationUnit {X : Scheme.{u}} [IsIntegral X] {E F : X.Modules}
    (q : E ⟶ F) (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : kernel q ≅ SheafOfModules.unit X.ringCatSheaf) : X.functionFieldˣ :=
  Units.mk0 ((X.presheaf.germ ⊤ (genericPoint X) trivial).hom (localEquation q eO eI))
    (by
      intro h
      apply localEquation_ne_zero q eO eI
      apply germ_injective_of_isIntegral X (U := ⊤) (genericPoint X) trivial
      exact h.trans (map_zero _).symm)

variable (K : Type u) [Field K] {X : Scheme.{u}}
  [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
  [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))]

variable {E F : X.Modules}

/-- The principal Weil divisor of a local equation of the Cartier ideal. -/
noncomputable def localDivisor (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : kernel q ≅ SheafOfModules.unit X.ringCatSheaf) : X.CurveDivisor :=
  divOf (X ↘ Spec (CommRingCat.of K)) (localEquationUnit q eO eI)

omit [IsIntegral X] in
set_option backward.isDefEq.respectTransparency false in
/-- Two trivializations of the same kernel give equations dividing one another. -/
theorem localEquation_dvd (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI eI' : kernel q ≅ SheafOfModules.unit X.ringCatSheaf) :
    localEquation q eO eI ∣ localEquation q eO eI' := by
  have hz : (eO.inv ≫ q).val.app (op ⊤) (localEquation q eO eI') = 0 :=
    (quotient_eq_zero_iff_dvd_localEquation q eO eI' ⊤ _).mpr (by simp)
  simpa using (quotient_eq_zero_iff_dvd_localEquation q eO eI ⊤ _).mp hz

set_option backward.isDefEq.respectTransparency false in
/-- Changing the generator of an invertible ideal does not change its Weil divisor. -/
theorem localDivisor_eq (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI eI' : kernel q ≅ SheafOfModules.unit X.ringCatSheaf) :
    localDivisor K q eO eI = localDivisor K q eO eI' := by
  apply Finsupp.ext
  intro z
  have hbound (s : Γ(X, ⊤)) :
      ord (X ↘ Spec (CommRingCat.of K)) z.2
        ((X.presheaf.germ ⊤ (genericPoint X) trivial).hom s) ≤ 1 := by
    rw [germ_generic_eq_algebraMap_germ (X := X) (U := ⊤) trivial
      (show z.1 ∈ (⊤ : X.Opens) from trivial)]
    exact ord_algebraMap_stalk_le_one K z.2 _
  have hle (eJ eJ' : kernel q ≅ SheafOfModules.unit X.ringCatSheaf) :
      ord (X ↘ Spec (CommRingCat.of K)) z.2 (localEquationUnit q eO eJ') ≤
        ord (X ↘ Spec (CommRingCat.of K)) z.2 (localEquationUnit q eO eJ) := by
    obtain ⟨r, hr⟩ := localEquation_dvd q eO eJ eJ'
    change ord (X ↘ Spec (CommRingCat.of K)) z.2
        ((X.presheaf.germ ⊤ (genericPoint X) trivial).hom (localEquation q eO eJ')) ≤ _
    rw [hr, map_mul, map_mul]
    exact (mul_le_mul_right (hbound r) _).trans_eq (mul_one _)
  have hv := le_antisymm (hle eI eI') (hle eI' eI)
  have hb : divisorBound (-localDivisor K q eO eI') z.2 =
      divisorBound (-localDivisor K q eO eI) z.2 := by
    rw [localDivisor, localDivisor, ← ord_val_eq, ← ord_val_eq]
    exact hv
  apply neg_injective
  exact congrArg Multiplicative.toAdd (WithZero.coe_inj.mp hb.symm)

/-- The kernel is the divisor module of the negative principal divisor of its equation. -/
noncomputable def kernelDivisorIso (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : kernel q ≅ SheafOfModules.unit X.ringCatSheaf) :
    kernel q ≅ divisorModules K (0 - localDivisor K q eO eI) :=
  eI ≪≫ (divisorModulesZeroIso K).symm ≪≫
    mulEquivDivisorModules K (localEquationUnit q eO eI) 0

set_option backward.isDefEq.respectTransparency false in
/-- The kernel comparison preserves its actual inclusion into rational functions. -/
theorem kernelDivisorIso_hom_value (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : kernel q ≅ SheafOfModules.unit X.ringCatSheaf)
    {U : X.Opens} (hU : (U : Set X).Nonempty) (s : (kernel q).val.obj (op U)) :
    divisorVal K ((kernelDivisorIso K q eO eI).hom.val.app (op U) s) =
      (X.presheaf.germ U (genericPoint X) (genericPoint_mem_of_nonempty hU)).hom
        ((kernel.ι q ≫ eO.hom).val.app (op U) s) := by
  change divisorVal K ((mulEquivDivisorModules K (localEquationUnit q eO eI) 0).hom.app U
    ((divisorModulesZeroIso K).inv.app U (eI.hom.val.app (op U) s))) = _
  rw [divisorVal_mulEquivDivisorModules K _ _ hU,
    divisorVal_divisorModulesZeroIso_inv K hU]
  have hinc : (eI.inv ≫ kernel.ι q ≫ eO.hom).val.app (op U)
      (eI.hom.val.app (op U) s) = (kernel.ι q ≫ eO.hom).val.app (op U) s := by
    change (eI.hom ≫ eI.inv ≫ kernel.ι q ≫ eO.hom).val.app (op U) s = _
    rw [Iso.hom_inv_id_assoc]
  rw [localEquation_apply] at hinc
  have h := congrArg
    ((X.presheaf.germ U (genericPoint X) (genericPoint_mem_of_nonempty hU)).hom) hinc
  rw [map_mul] at h
  change (X.presheaf.germ U (genericPoint X) (genericPoint_mem_of_nonempty hU)).hom
      (eI.hom.val.app (op U) s) *
    (X.presheaf.germ U (genericPoint X) (genericPoint_mem_of_nonempty hU)).hom
      (X.presheaf.map (homOfLE (le_top : U ≤ ⊤)).op (localEquation q eO eI)) = _ at h
  rw [X.presheaf.germ_res_apply] at h
  exact (mul_comm _ _).trans h

end AlgebraicGeometry.Scheme.CartierKernel

namespace AlgebraicGeometry.Scheme.CartierKernel

noncomputable section

variable (K : Type u) [Field K] {C : Over (Spec (CommRingCat.of K))}
  [SmoothOfRelativeDimension 1 C.hom] [IsIntegral C.left]
  [LocallyOfFiniteType C.hom] [QuasiCompact C.hom]

local instance : C.left.Over (Spec (CommRingCat.of K)) := .ofHom C.hom
local instance : SmoothOfRelativeDimension 1
    (C.left ↘ Spec (CommRingCat.of K)) := inferInstanceAs
      (SmoothOfRelativeDimension 1 C.hom)
local instance : LocallyOfFiniteType
    (C.left ↘ Spec (CommRingCat.of K)) := inferInstanceAs
      (LocallyOfFiniteType C.hom)
local instance : QuasiCompact
    (C.left ↘ Spec (CommRingCat.of K)) := inferInstanceAs
      (QuasiCompact C.hom)

/-- Degree-one vanishing for a Cartier kernel follows from the corresponding
vanishing bound for its divisor module.  The kernel is the actual input to the
Grassmannian lifting map; `kernelDivisorIso` identifies it with
`divisorModules (0 - localDivisor ...)`, and the bound is then transported
through the induced field-sheaf isomorphism. -/
theorem subsingleton_hModule_one_kernel_of_divisor_bound
    {E F : C.left.Modules} (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit C.left.ringCatSheaf)
    (eI : kernel q ≅ SheafOfModules.unit C.left.ringCatSheaf)
    {b : ℤ}
    (hb : ∀ D : C.left.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule
        (toModuleKSheafOfModules C (divisorModules K D)) 1))
    (hdeg : b ≤ CurveDivisor.deg K
      (0 - localDivisor K q eO eI)) :
    Subsingleton (Sheaf.HModule (toModuleKSheafOfModules C (kernel q)) 1) := by
  let e := (toModuleKSheafOfModulesFunctor C).mapIso
    (kernelDivisorIso K q eO eI)
  exact (Equiv.subsingleton_congr (Sheaf.HModule.mapEquiv e 1).toEquiv).mpr
    (hb (0 - localDivisor K q eO eI) hdeg)

/-- The Cartier equation has degree zero on a proper geometrically integral curve,
by the general-field principal-divisor ledger. -/
theorem localDivisor_deg_zero
    [IsProper C.hom] [GeometricallyIrreducible C.hom]
    {E F : C.left.Modules} (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit C.left.ringCatSheaf)
    (eI : kernel q ≅ SheafOfModules.unit C.left.ringCatSheaf) :
    CurveDivisor.deg K (localDivisor K q eO eI) = 0 := by
  exact AlgebraicGeometry.deg_divOf K (localEquationUnit q eO eI)

/-- A nonpositive uniform divisor-module bound applies to every principal Cartier
kernel, after using the degree-zero calculation above. -/
theorem subsingleton_hModule_one_kernel_of_nonpositive_divisor_bound
    [IsProper C.hom] [GeometricallyIrreducible C.hom]
    {E F : C.left.Modules} (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit C.left.ringCatSheaf)
    (eI : kernel q ≅ SheafOfModules.unit C.left.ringCatSheaf)
    {b : ℤ} (hb0 : b ≤ 0)
    (hb : ∀ D : C.left.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule
        (toModuleKSheafOfModules C (divisorModules K D)) 1)) :
    Subsingleton (Sheaf.HModule (toModuleKSheafOfModules C (kernel q)) 1) := by
  apply subsingleton_hModule_one_kernel_of_divisor_bound K q eO eI hb
  apply hb0.trans_eq
  rw [sub_eq_add_neg, CurveDivisor.deg_add, CurveDivisor.deg_zero,
    CurveDivisor.deg_neg, localDivisor_deg_zero K q eO eI]
  simp

end

end AlgebraicGeometry.Scheme.CartierKernel
