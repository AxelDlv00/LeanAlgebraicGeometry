/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioCanonicalBridge
import HartshorneLib.Chapter4LocalRatioHyperplane

/-!
# Projective-chart functions in the range of stalk maps

Functions on a standard affine projective chart pull back to germs of the
regularized coordinates. In particular, every regularized linear form is in
the range of the projective chart map on stalks.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

private theorem open_germ_stalkMap {Z : Scheme.{u}} (U : Z.Opens) (p : U) :
    Z.presheaf.germ U p.1 p.2 ≫ U.ι.stalkMap p =
      U.topIso.inv ≫ U.toScheme.presheaf.germ ⊤ p trivial := by
  apply (cancel_mono (U.stalkIso p).hom).mp
  simp only [Category.assoc, ← Scheme.Opens.stalkIso_inv, Iso.inv_hom_id,
    Category.comp_id, Scheme.Opens.germ_stalkIso_hom]
  rw [Scheme.Opens.topIso_inv]
  exact (Z.presheaf.germ_res (eqToHom U.ι_image_top) p.1 ⟨p, trivial, rfl⟩).symm

/-- Pullbacks of affine-chart functions lie in the stalk range after any open
immersion of the target chart. -/
theorem germ_mem_range_stalkMap_of_affine_factorization
    {Z Y : Scheme.{u}} (U : Z.Opens) (A : CommRingCat.{u})
    (h : A ⟶ Γ(Z, U)) (j : Spec A ⟶ Y) [IsOpenImmersion j]
    (p : U) (z : A) :
    (U.ι.stalkMap p).hom ((Z.presheaf.germ U p.1 p.2).hom (h.hom z)) ∈
      Set.range ((U.toSpecΓ ≫ Spec.map h ≫ j).stalkMap p).hom := by
  let f : U.toScheme ⟶ Spec A := U.toSpecΓ ≫ Spec.map h
  have happ : (Scheme.ΓSpecIso A).inv ≫ f.appTop = h ≫ U.topIso.inv := by
    dsimp only [f]
    rw [Scheme.Hom.comp_appTop, Scheme.Opens.toSpecΓ_appTop]
    simp only [← Category.assoc, Scheme.ΓSpecIso_naturality,
      Iso.inv_hom_id, Category.id_comp]
  let q := (Spec A).presheaf.germ ⊤ (f p) trivial ((Scheme.ΓSpecIso A).inv z)
  obtain ⟨w, hw⟩ := (ConcreteCategory.bijective_of_isIso (j.stalkMap (f p))).2 q
  refine ⟨w, ?_⟩
  change ((f ≫ j).stalkMap p).hom w = _
  rw [Scheme.Hom.stalkMap_comp]
  change (f.stalkMap p).hom ((j.stalkMap (f p)).hom w) = _
  rw [hw]
  change (f.stalkMap p).hom
    ((Spec A).presheaf.germ ⊤ (f p) trivial ((Scheme.ΓSpecIso A).inv z)) = _
  rw [Scheme.Hom.germ_stalkMap_apply]
  have heq := congrArg (fun g : A ⟶ U.toScheme.presheaf.stalk p => g.hom z)
    (show (Scheme.ΓSpecIso A).inv ≫ f.appTop ≫
        U.toScheme.presheaf.germ ⊤ p trivial =
      h ≫ Z.presheaf.germ U p.1 p.2 ≫ U.ι.stalkMap p by
      rw [open_germ_stalkMap, ← Category.assoc, happ]
      simp only [Category.assoc])
  exact heq

/-- Surjectivity on stalks of a map through an affine chart expresses every
source germ as a fraction of pullbacks of affine functions. -/
theorem exists_stalk_fraction_of_affine_factorization
    {Z Y : Scheme.{u}} (U : Z.Opens) (A : CommRingCat.{u})
    (h : A ⟶ Γ(Z, U)) (j : Spec A ⟶ Y) (p : U)
    (hsurj : Function.Surjective
      ((U.toSpecΓ ≫ Spec.map h ≫ j).stalkMap p).hom)
    (z : Z.presheaf.stalk p.1) :
    ∃ a b : A,
      IsUnit ((Z.presheaf.germ U p.1 p.2).hom (h.hom b)) ∧
        z * (Z.presheaf.germ U p.1 p.2).hom (h.hom b) =
          (Z.presheaf.germ U p.1 p.2).hom (h.hom a) := by
  let f : U.toScheme ⟶ Spec A := U.toSpecΓ ≫ Spec.map h
  let e := U.ι.stalkMap p
  letI : Algebra A ((Spec A).presheaf.stalk (f p)) :=
    StructureSheaf.stalkAlgebra A (f p)
  letI : IsLocalization.AtPrime ((Spec A).presheaf.stalk (f p)) (f p).asIdeal :=
    StructureSheaf.IsLocalization.to_stalk A (f p)
  have happ : (Scheme.ΓSpecIso A).inv ≫ f.appTop = h ≫ U.topIso.inv := by
    dsimp only [f]
    rw [Scheme.Hom.comp_appTop, Scheme.Opens.toSpecΓ_appTop]
    simp only [← Category.assoc, Scheme.ΓSpecIso_naturality,
      Iso.inv_hom_id, Category.id_comp]
  have hcomm (a : A) :
      (f.stalkMap p).hom (algebraMap A ((Spec A).presheaf.stalk (f p)) a) =
        e.hom ((Z.presheaf.germ U p.1 p.2).hom (h.hom a)) := by
    change (f.stalkMap p).hom
      ((Spec A).presheaf.germ ⊤ (f p) trivial ((Scheme.ΓSpecIso A).inv a)) = _
    rw [Scheme.Hom.germ_stalkMap_apply]
    exact congrArg (fun g : A ⟶ U.toScheme.presheaf.stalk p => g.hom a)
      (show (Scheme.ΓSpecIso A).inv ≫ f.appTop ≫
          U.toScheme.presheaf.germ ⊤ p trivial =
        h ≫ Z.presheaf.germ U p.1 p.2 ≫ e by
        rw [show e = U.ι.stalkMap p from rfl, open_germ_stalkMap,
          ← Category.assoc, happ]
        simp only [Category.assoc])
  obtain ⟨t, ht⟩ := hsurj (e.hom z)
  let s := (j.stalkMap (f p)).hom t
  have hs : (f.stalkMap p).hom s = e.hom z := by
    change ((f ≫ j).stalkMap p).hom t = _ at ht
    rw [Scheme.Hom.stalkMap_comp] at ht
    exact ht
  obtain ⟨⟨a, b⟩, hab⟩ := IsLocalization.surj (f p).asIdeal.primeCompl s
  refine ⟨a, b, ?_, ?_⟩
  · have hu := (IsLocalization.map_units ((Spec A).presheaf.stalk (f p)) b).map
      (f.stalkMap p).hom
    rw [hcomm] at hu
    exact (isUnit_map_iff e.hom _).mp hu
  · apply (ConcreteCategory.bijective_of_isIso e).1
    have heq := congrArg (f.stalkMap p).hom hab
    exact (e.hom.map_mul z _).trans (by
      simpa only [map_mul, hs, hcomm] using heq)

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

attribute [local instance] MvPolynomial.gradedAlgebra

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

/-- Every regularized linear form is the pullback of a germ on projective
space. The germ on the source is transported along the chart inclusion. -/
theorem germ_regularizedLinearForm_mem_range_stalkMap
    (r : LocalRatioRegularization a) (p : a.chart.U) (c : Fin (n + 1) → k) :
    (a.chart.U.ι.stalkMap p).hom
        ((X.left.presheaf.germ a.chart.U p.1 p.2).hom (r.regularizedLinearForm c)) ∈
      Set.range (r.chartMap.stalkMap p).hom := by
  letI : Algebra k Γ(X.left, a.chart.U) :=
    (X.left.overAlgebraMap k a.chart.U).toAlgebra
  let A := HomogeneousLocalization.Away
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
    (MvPolynomial.X a.denominator_index)
  let h : A →+* Γ(X.left, a.chart.U) :=
    ProjectiveCoordinates.chartHom (k := k) a.denominator_index r.regularized
      r.regularized_denominator_eq_one
  let z : A := HomogeneousLocalization.Away.mk
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
    (ProjectiveCoordinates.X_mem_deg_one a.denominator_index) 1
    (ProjectiveCoordinates.linearForm c)
    (by simpa using ProjectiveCoordinates.linearForm_mem_homogeneousSubmodule c)
  have hz : h z = r.regularizedLinearForm c := by
    dsimp only [h, z]
    rw [ProjectiveCoordinates.chartHom_mk]
    simp [ProjectiveCoordinates.eval, ProjectiveCoordinates.linearForm,
      regularizedLinearForm]
    rfl
  have hrange := germ_mem_range_stalkMap_of_affine_factorization a.chart.U
    (CommRingCat.of A) (CommRingCat.ofHom h)
    (Proj.awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (MvPolynomial.X a.denominator_index)
      (ProjectiveCoordinates.X_mem_deg_one a.denominator_index) Nat.zero_lt_one)
    p z
  change (CommRingCat.ofHom h).hom z = r.regularizedLinearForm c at hz
  rw [hz] at hrange
  rw [r.chartMap_eq_fromOpen]
  exact hrange

/-- If a local-ratio chart is surjective on stalks, its coordinate germs
express every source germ as a fraction of polynomial expressions. -/
theorem exists_polynomial_stalk_fraction_of_surjective
    (r : LocalRatioRegularization a) (p : a.chart.U)
    (hsurj : Function.Surjective (r.chartMap.stalkMap p).hom)
    (z : X.left.presheaf.stalk p.1) :
    let g := (X.left.presheaf.germ a.chart.U p.1 p.2).hom
    let ψ := MvPolynomial.eval₂Hom (g.comp (X.left.overAlgebraMap k a.chart.U))
      (fun j => g (r.regularized j))
    ∃ P Q : MvPolynomial (Fin (n + 1)) k,
      IsUnit (ψ Q) ∧ z * ψ Q = ψ P := by
  letI : Algebra k Γ(X.left, a.chart.U) :=
    (X.left.overAlgebraMap k a.chart.U).toAlgebra
  let A := HomogeneousLocalization.Away
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
    (MvPolynomial.X a.denominator_index)
  let h : A →+* Γ(X.left, a.chart.U) :=
    ProjectiveCoordinates.chartHom (k := k) a.denominator_index r.regularized
      r.regularized_denominator_eq_one
  let g := (X.left.presheaf.germ a.chart.U p.1 p.2).hom
  let ψ := MvPolynomial.eval₂Hom (g.comp (X.left.overAlgebraMap k a.chart.U))
    (fun j => g (r.regularized j))
  have heval (P : MvPolynomial (Fin (n + 1)) k) :
      g (ProjectiveCoordinates.eval (k := k) r.regularized P) = ψ P := by
    induction P using MvPolynomial.induction_on with
    | C c =>
        simp only [ProjectiveCoordinates.eval, ψ, MvPolynomial.eval₂Hom_C,
          RingHom.comp_apply]
        rfl
    | add P Q hP hQ => simp only [map_add, hP, hQ]
    | mul_X P j hP =>
        simp only [map_mul, ProjectiveCoordinates.eval_X, hP]
        simp only [ψ, MvPolynomial.eval₂Hom_X']
  have hrepresent (w : A) : ∃ P : MvPolynomial (Fin (n + 1)) k, g (h w) = ψ P := by
    obtain ⟨m, P, hP, rfl⟩ := HomogeneousLocalization.Away.mk_surjective
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (ProjectiveCoordinates.X_mem_deg_one a.denominator_index) w
    refine ⟨P, ?_⟩
    rw [show h = ProjectiveCoordinates.chartHom (k := k) a.denominator_index
      r.regularized r.regularized_denominator_eq_one from rfl,
      ProjectiveCoordinates.chartHom_mk]
    exact heval P
  obtain ⟨v, w, hw, hv⟩ := exists_stalk_fraction_of_affine_factorization a.chart.U
    (CommRingCat.of A) (CommRingCat.ofHom h)
    (Proj.awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (MvPolynomial.X a.denominator_index)
      (ProjectiveCoordinates.X_mem_deg_one a.denominator_index) Nat.zero_lt_one)
    p (by rw [r.chartMap_eq_fromOpen] at hsurj; exact hsurj) z
  obtain ⟨P, hP⟩ := hrepresent v
  obtain ⟨Q, hQ⟩ := hrepresent w
  refine ⟨P, Q, ?_, ?_⟩
  · exact hQ ▸ hw
  · change z * ψ Q = ψ P
    rw [← hQ, ← hP]
    exact hv

end LocalRatioRegularization

end
end Hartshorne
