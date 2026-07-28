import Mathlib
import AlgebraicJacobian.Albanese.SymPowAffineCarrier

set_option autoImplicit false
universe u
open CategoryTheory Limits TensorProduct PiTensorProduct MonoidalCategory
  CartesianMonoidalCategory AlgebraicGeometry

namespace Probe

variable (k : CommRingCat.{0}) (A : Type) [CommRing A] [Algebra k A] (n : ℕ)

noncomputable local instance : CartesianMonoidalCategory (Under k)ᵒᵖ := ofHasFiniteProducts

noncomputable abbrev D : SingleObj (Equiv.Perm (Fin n)) ⥤ (Under k)ᵒᵖ :=
  letI := permMulSemiringAction (k : Type) (ι := Fin n) A
  letI := permSMulCommClass (k : Type) (ι := Fin n) A
  (Groupoid.invEquivalence (SingleObj (Equiv.Perm (Fin n)))).functor
    ⋙ (actionDiagramUnder k (Equiv.Perm (Fin n)) (⨂[(k : Type)] _ : Fin n, A)).op

theorem D_map (σ : Equiv.Perm (Fin n)) :
    (D k A n).map (SingleObj.toEnd (Equiv.Perm (Fin n)) σ)
      = ((permAlgHom (k : Type) A σ).toUnder).op := by
  apply Quiver.Hom.unop_inj
  apply (Under.forget k).map_injective
  apply CommRingCat.hom_ext
  ext x
  rfl

/-- THE DIAGRAM ISO. On the single object it is `tensorPowerOpIsoPiObj`; naturality is
`permAut_eq_op_permAlgHom` after `D_map` and `permAut_eq_map`. -/
noncomputable def diagIso :
    D k A n ≅ permDiagram (Opposite.op (CommRingCat.mkUnder k A)) n :=
  NatIso.ofComponents (fun _ => tensorPowerOpIsoPiObj k A n) (by
    intro X Y f
    obtain rfl : X = SingleObj.star _ := Subsingleton.elim _ _
    obtain rfl : Y = SingleObj.star _ := Subsingleton.elim _ _
    -- `f : Perm (Fin n)`; both maps are determined by it
    have h1 : (D k A n).map f = ((permAlgHom (k : Type) A (f : Equiv.Perm (Fin n))).toUnder).op :=
      D_map k A n _
    have h2 : (permDiagram (Opposite.op (CommRingCat.mkUnder k A)) n).map f
        = MonObj.permAut (Opposite.op (CommRingCat.mkUnder k A)) (f : Equiv.Perm (Fin n))⁻¹ :=
      rfl
    rw [h1, h2]
    -- goal: op(permAlgHom f) ≫ iso.hom = iso.hom ≫ permAut f⁻¹
    have h3 := permAut_eq_op_permAlgHom k A n (f : Equiv.Perm (Fin n))⁻¹
    rw [inv_inv] at h3
    exact h3.symm)

theorem hasColimit_permDiagram_op_mkUnder :
    HasColimit (permDiagram (Opposite.op (CommRingCat.mkUnder k A)) n) := by
  letI := permMulSemiringAction (k : Type) (ι := Fin n) A
  letI := permSMulCommClass (k : Type) (ι := Fin n) A
  haveI : HasColimit (D k A n) := by
    haveI := hasColimit_actionDiagramUnder_op k (Equiv.Perm (Fin n))
      (⨂[(k : Type)] _ : Fin n, A)
    infer_instance
  exact hasColimitOfIso (diagIso k A n).symm

end Probe
