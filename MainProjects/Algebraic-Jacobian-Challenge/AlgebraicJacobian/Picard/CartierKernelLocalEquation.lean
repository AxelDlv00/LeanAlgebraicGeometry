/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.GrassmannianQuot

/-!
# Local equations of invertible kernels

Kleiman, "The Picard scheme", Section 3, `sb:ediv`, describes effective Cartier divisors
by invertible ideal inclusions and their corresponding regular sections. Here trivializations
of a morphism's source and kernel identify the kernel inclusion with multiplication by a
section. That section is regular on every open, and its multiples are exactly the sections
annihilated by the morphism. These assertions use preservation of kernels by evaluation;
they do not require the morphism to be an epimorphism or assert surjectivity on sections.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry.Scheme.CartierKernel

variable {X : Scheme.{u}} {E F : X.Modules}

/-- The equation determined by trivializations of a quotient source and kernel. -/
noncomputable def localEquation (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : Limits.kernel q ≅ SheafOfModules.unit X.ringCatSheaf) : Γ(X, ⊤) :=
  (eI.inv ≫ Limits.kernel.ι q ≫ eO.hom).val.app (op ⊤)
    (1 : X.ringCatSheaf.obj.obj (op ⊤))

lemma localEquation_scalar (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : Limits.kernel q ≅ SheafOfModules.unit X.ringCatSheaf) :
    Grassmannian.scalarEnd (localEquation q eO eI) =
      eI.inv ≫ Limits.kernel.ι q ≫ eO.hom := by
  let j := eI.inv ≫ Limits.kernel.ι q ≫ eO.hom
  apply (SheafOfModules.unit X.ringCatSheaf).unitHomEquiv.injective
  rw [Grassmannian.unitHomEquiv_scalarEnd]
  refine PresheafOfModules.sections_ext _ _ (fun V => ?_)
  change _ = j.val.app V (1 : X.ringCatSheaf.obj.obj V)
  change X.ringCatSheaf.obj.map (homOfLE le_top).op
      (j.val.app (op ⊤) (1 : X.ringCatSheaf.obj.obj (op ⊤))) =
    j.val.app V (1 : X.ringCatSheaf.obj.obj V)
  have hnat := PresheafOfModules.naturality_apply j.val
    (homOfLE (le_top : V.unop ≤ ⊤)).op
    (1 : X.ringCatSheaf.obj.obj (op ⊤))
  exact hnat.symm.trans (congrArg (fun z => j.val.app V z)
    (PresheafOfModules.unit_map_one X.ringCatSheaf.obj
      (homOfLE (le_top : V.unop ≤ ⊤)).op))

lemma localEquation_apply_of_scalar (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : Limits.kernel q ≅ SheafOfModules.unit X.ringCatSheaf)
    (hscalar : Grassmannian.scalarEnd (localEquation q eO eI) =
      eI.inv ≫ Limits.kernel.ι q ≫ eO.hom)
    (U : X.Opens) (s : X.ringCatSheaf.obj.obj (op U)) :
    ((eI.inv ≫ Limits.kernel.ι q ≫ eO.hom).val.app (op U)) s =
      s * X.ringCatSheaf.obj.map (homOfLE (show U ≤ ⊤ from le_top)).op
      (localEquation q eO eI) := by
  let j := eI.inv ≫ Limits.kernel.ι q ≫ eO.hom
  change j.val.app (op U) s = _
  dsimp [j] at hscalar ⊢
  rw [← hscalar]
  exact Grassmannian.scalarEnd_val_app _ _ _

/-- On every open, the kernel inclusion in the chosen trivializations is multiplication
by the restriction of the local equation. -/
lemma localEquation_apply (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : Limits.kernel q ≅ SheafOfModules.unit X.ringCatSheaf)
    (U : X.Opens) (s : X.ringCatSheaf.obj.obj (op U)) :
    ((eI.inv ≫ Limits.kernel.ι q ≫ eO.hom).val.app (op U)) s =
      s * X.ringCatSheaf.obj.map (homOfLE (show U ≤ ⊤ from le_top)).op
        (localEquation q eO eI) :=
  localEquation_apply_of_scalar q eO eI (localEquation_scalar q eO eI) U s

set_option backward.isDefEq.respectTransparency false in
/-- The equation of an invertible kernel is a non-zero-divisor on every open. -/
lemma localEquation_mul_injective (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : Limits.kernel q ≅ SheafOfModules.unit X.ringCatSheaf) (U : X.Opens) :
    Function.Injective (fun s : X.ringCatSheaf.obj.obj (op U) =>
      s * X.ringCatSheaf.obj.map (homOfLE (show U ≤ ⊤ from le_top)).op
        (localEquation q eO eI)) := by
  let j := eI.inv ≫ Limits.kernel.ι q ≫ eO.hom
  let ev := SheafOfModules.evaluation X.ringCatSheaf (op U)
  have hinj : Function.Injective (ev.map j) :=
    (ModuleCat.mono_iff_injective _).mp inferInstance
  intro s t h
  apply hinj
  change j.val.app (op U) s = j.val.app (op U) t
  simpa only [j, localEquation_apply] using h

set_option backward.isDefEq.respectTransparency false in
/-- Taking sections on any open preserves the exactness defining a sheaf kernel. -/
lemma quotient_app_eq_zero_iff (q : E ⟶ F) (U : X.Opens)
    (s : E.val.obj (op U)) :
    q.val.app (op U) s = 0 ↔
      ∃ t : (Limits.kernel q).val.obj (op U), (Limits.kernel.ι q).val.app (op U) t = s := by
  let ev := SheafOfModules.evaluation X.ringCatSheaf (op U)
  letI : ev.PreservesZeroMorphisms := by
    dsimp [ev, SheafOfModules.evaluation]
    infer_instance
  let S := ShortComplex.mk (ev.map (Limits.kernel.ι q)) (ev.map q)
    (by rw [← ev.map_comp, Limits.kernel.condition, ev.map_zero])
  have hS : S.Exact := S.exact_of_f_is_kernel
    (isLimitOfHasKernelOfPreservesLimit ev q)
  exact ((ShortComplex.ShortExact.moduleCat_exact_iff_function_exact S).mp hS) s

set_option backward.isDefEq.respectTransparency false in
/-- A section vanishes in the quotient exactly when it is divisible by the local equation. -/
lemma quotient_eq_zero_iff_dvd_localEquation (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : Limits.kernel q ≅ SheafOfModules.unit X.ringCatSheaf)
    (U : X.Opens) (s : X.ringCatSheaf.obj.obj (op U)) :
    (eO.inv ≫ q).val.app (op U) s = 0 ↔
      X.ringCatSheaf.obj.map (homOfLE (show U ≤ ⊤ from le_top)).op
        (localEquation q eO eI) ∣ s := by
  constructor
  · intro hs
    obtain ⟨t, ht⟩ := (quotient_app_eq_zero_iff q U (eO.inv.val.app (op U) s)).mp hs
    refine ⟨eI.hom.val.app (op U) t, ?_⟩
    have h := congrArg (fun z => eO.hom.val.app (op U) z) ht
    have hi : (eI.inv ≫ Limits.kernel.ι q ≫ eO.hom).val.app (op U)
        (eI.hom.val.app (op U) t) = s := by
      change (eI.hom ≫ eI.inv ≫ Limits.kernel.ι q ≫ eO.hom).val.app (op U) t = s
      simp only [Iso.hom_inv_id_assoc]
      refine h.trans ?_
      change (eO.inv ≫ eO.hom).val.app (op U) s = s
      rw [Iso.inv_hom_id]
      rfl
    rw [localEquation_apply] at hi
    exact hi.symm.trans (mul_comm (G := Γ(X, U)) _ _)
  · rintro ⟨t, rfl⟩
    refine (congrArg ((eO.inv ≫ q).val.app (op U))
      ((mul_comm (G := Γ(X, U)) _ _).trans (localEquation_apply q eO eI U t).symm)).trans ?_
    change ((eI.inv ≫ Limits.kernel.ι q ≫ eO.hom) ≫ (eO.inv ≫ q)).val.app (op U) t = 0
    simp only [Category.assoc, Iso.hom_inv_id_assoc, Limits.kernel.condition, comp_zero]
    rfl

end AlgebraicGeometry.Scheme.CartierKernel
