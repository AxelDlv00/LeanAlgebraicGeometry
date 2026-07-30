import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry
universe u

-- X = Spec R ⨿ Spec R.  V = opensRange coprod.inl.  Retraction: coprod.desc (iso) (iso).
variable (R : CommRingCat.{u})

-- step 1: the open V and its identification with Spec R
noncomputable abbrev X2 : Scheme.{u} := (Spec R) ⨿ (Spec R)
noncomputable abbrev V2 : (X2 R).Opens := (coprod.inl : Spec R ⟶ X2 R).opensRange

-- V2.ι is, up to the canonical iso, coprod.inl
example : (V2 R).ι = ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange).inv ≫ (V2 R).ι := by
  simp

-- The retraction candidate
noncomputable def r2 : X2 R ⟶ (V2 R : Scheme.{u}) :=
  coprod.desc ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange.hom)
              ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange.hom)

theorem retract2 : (V2 R).ι ≫ r2 R = 𝟙 _ := by
  rw [← cancel_epi ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange).hom]
  simp [r2, Scheme.Hom.isoOpensRange_hom_ι_assoc]

end AlgebraicGeometry
