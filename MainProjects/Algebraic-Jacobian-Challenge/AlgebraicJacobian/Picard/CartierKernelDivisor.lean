/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.CartierKernelLocalEquation
import AlgebraicJacobian.Picard.DivisorModules

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
