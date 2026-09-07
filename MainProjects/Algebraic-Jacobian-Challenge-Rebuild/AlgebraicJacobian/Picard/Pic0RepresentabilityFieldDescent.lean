/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0SepClosedRepresentable
import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0FaithfullyFlatInjective
import Mathlib.AlgebraicGeometry.Sites.Fpqc

/-!
# Descent of Picard representability along a field extension

A universal class whose scalar extension agrees with the separably closed universal class
represents the Picard functor on every test scheme. Morphisms descend by the effective
epimorphism property of the field-extension cover.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

noncomputable section

variable (k Omega : Type u) [Field k] [Field Omega] [Algebra k Omega]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-- Restriction along a field extension is injective on every test scheme. -/
theorem pic0Map_fieldExtension_injective (T : Over (Spec (.of k))) :
    Function.Injective (pic0Map C
      ((Over.mapPullbackAdj
        (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).counit.app T)) := by
  haveI : Surjective (Spec.map (CommRingCat.ofHom (algebraMap k Omega))) := inferInstance
  haveI : Surjective
      ((Over.mapPullbackAdj
        (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).counit.app T).left := by
    change Surjective (pullback.fst T.hom _)
    infer_instance
  haveI : Flat
      ((Over.mapPullbackAdj
        (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).counit.app T).left := by
    change Flat (pullback.fst T.hom _)
    infer_instance
  haveI : IsAffineHom
      ((Over.mapPullbackAdj
        (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).counit.app T).left := by
    change IsAffineHom (pullback.fst T.hom _)
    exact MorphismProperty.pullback_fst _ _ inferInstance
  apply pic0Map_affine_faithfullyFlat_injective

/-- Scalar extension of both curve and test is injective on degree-zero Picard classes. -/
theorem pic0CrossBaseMap_injective (T : Over (Spec (.of k))) :
    Function.Injective (fun x : pic0Subgroup C T =>
      (pic0CrossBaseEquiv k Omega C
        ((Over.pullback (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).obj T)).symm
        (pic0Map C
          ((Over.mapPullbackAdj (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).counit.app T)
          x)) :=
  (pic0CrossBaseEquiv k Omega C _).symm.injective.comp
    (pic0Map_fieldExtension_injective k Omega C T)

private lemma pic0Map_comp_apply {X Y Z : Over (Spec (.of k))}
    (f : X ⟶ Y) (g : Y ⟶ Z) (x : pic0Subgroup C Z) :
    pic0Map C (f ≫ g) x = pic0Map C f (pic0Map C g x) := by
  apply Subtype.ext
  exact picEtMap_comp C g f x.1

variable [IsSepClosed Omega] (J : Over (Spec (.of k))) (u : pic0Subgroup C J)
variable (beta :
    (Over.pullback (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).obj J ≅
      (pic0_sepClosed_representableBy (C := (baseChange k Omega).obj C)).1)
variable (hu :
    (pic0ThetaType k Omega C).hom.app
        (op ((Over.pullback (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).obj J))
        ((pic0_sepClosed_representableBy (C := (baseChange k Omega).obj C)).2.homEquiv
          beta.hom) =
      pic0Map C
        ((Over.mapPullbackAdj (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).counit.app J) u)

include beta hu in
private theorem pic0_eval_restricted_bijective (S : Over (Spec (.of Omega))) :
    Function.Bijective (fun f :
      (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k Omega)))).obj S ⟶ J =>
        pic0Map C f u) := by
  let q := Spec.map (CommRingCat.ofHom (algebraMap k Omega))
  let adj := Over.mapPullbackAdj q
  let rep := ((pic0_sepClosed_representableBy
    (C := (baseChange k Omega).obj C)).2.ofIsoObj beta).ofIso (pic0ThetaType k Omega C)
  let e := (adj.homEquiv S J).trans rep.homEquiv
  have hr : rep.homEquiv (𝟙 _) = pic0Map C (adj.counit.app J) u := by
    simpa [rep, adj, q, Functor.RepresentableBy.ofIso,
      Functor.RepresentableBy.ofIsoObj] using hu
  have he (f : (Over.map q).obj S ⟶ J) : e f = pic0Map C f u := by
    change rep.homEquiv (adj.homEquiv S J f) = _
    rw [rep.homEquiv_eq, hr]
    change pic0Map C ((Over.map q).map (adj.homEquiv S J f))
      (pic0Map C (adj.counit.app J) u) = _
    calc
      _ = pic0Map C
          ((Over.map q).map (adj.homEquiv S J f) ≫ adj.counit.app J) u :=
        (pic0Map_comp_apply k C _ _ u).symm
      _ = pic0Map C f u := congrArg (fun g => pic0Map C g u)
        ((adj.homEquiv S J).symm_apply_apply f)
  exact (show (fun f => pic0Map C f u) = e from funext fun f => (he f).symm) ▸ e.bijective

include beta hu in
private theorem pic0_eval_bijective_of_fieldExtension (T : Over (Spec (.of k))) :
    Function.Bijective (fun f : T ⟶ J => pic0Map C f u) := by
  let q := Spec.map (CommRingCat.ofHom (algebraMap k Omega))
  let Tb := (Over.pullback q).obj T
  let Tk := (Over.map q).obj Tb
  let p : Tk ⟶ T := (Over.mapPullbackAdj q).counit.app T
  haveI : Surjective q := inferInstance
  haveI : Surjective p.left := by
    change Surjective (pullback.fst T.hom q)
    infer_instance
  haveI : Flat p.left := by
    change Flat (pullback.fst T.hom q)
    infer_instance
  haveI : IsAffineHom p.left := by
    change IsAffineHom (pullback.fst T.hom q)
    exact MorphismProperty.pullback_fst _ _ inferInstance
  have hOmega := pic0_eval_restricted_bijective k Omega C J u beta hu
  constructor
  · intro f g hfg
    have h : p ≫ f = p ≫ g := (hOmega Tb).1 (by
      exact (pic0Map_comp_apply k C p f u).trans
        ((congrArg (pic0Map C p) hfg).trans (pic0Map_comp_apply k C p g u).symm))
    apply Over.OverMorphism.ext
    apply (cancel_epi p.left).mp
    exact congrArg Over.Hom.left h
  · intro x
    obtain ⟨m, hm⟩ := (hOmega Tb).2 (pic0Map C p x)
    have hdesc : ∀ {Z : Scheme.{u}} (a b : Z ⟶ Tk.left),
        a ≫ p.left = b ≫ p.left → a ≫ m.left = b ≫ m.left := by
      intro Z a b hab
      let A : Over (Spec (.of Omega)) := Over.mk (a ≫ Tb.hom)
      let aa : (Over.map q).obj A ⟶ Tk := Over.homMk a (by
        change a ≫ (Tb.hom ≫ q) = (a ≫ Tb.hom) ≫ q
        exact (Category.assoc _ _ _).symm)
      let bb : (Over.map q).obj A ⟶ Tk := Over.homMk b (by
        change b ≫ Tk.hom = (a ≫ Tb.hom) ≫ q
        calc
          b ≫ Tk.hom = (b ≫ p.left) ≫ T.hom := by rw [Category.assoc, p.w]
          _ = (a ≫ p.left) ≫ T.hom := congrArg (fun v => v ≫ T.hom) hab.symm
          _ = a ≫ Tk.hom := by rw [Category.assoc, p.w]
          _ = (a ≫ Tb.hom) ≫ q := (Category.assoc _ _ _).symm)
      have hab' : aa ≫ p = bb ≫ p := Over.OverMorphism.ext hab
      have h : aa ≫ m = bb ≫ m := (hOmega A).1 (by
        calc
          pic0Map C (aa ≫ m) u = pic0Map C aa (pic0Map C m u) :=
            pic0Map_comp_apply k C aa m u
          _ = pic0Map C aa (pic0Map C p x) := congrArg (pic0Map C aa) hm
          _ = pic0Map C (aa ≫ p) x := (pic0Map_comp_apply k C aa p x).symm
          _ = pic0Map C (bb ≫ p) x := congrArg (fun v => pic0Map C v x) hab'
          _ = pic0Map C bb (pic0Map C p x) := pic0Map_comp_apply k C bb p x
          _ = pic0Map C bb (pic0Map C m u) := congrArg (pic0Map C bb) hm.symm
          _ = pic0Map C (bb ≫ m) u := (pic0Map_comp_apply k C bb m u).symm)
      exact congrArg Over.Hom.left h
    let d : T.left ⟶ J.left := EffectiveEpi.desc p.left m.left hdesc
    have hd : p.left ≫ d = m.left := EffectiveEpi.fac p.left m.left hdesc
    have hdOver : d ≫ J.hom = T.hom := by
      apply (cancel_epi p.left).mp
      calc
        p.left ≫ (d ≫ J.hom) = m.left ≫ J.hom := by rw [← Category.assoc, hd]
        _ = Tk.hom := m.w
        _ = p.left ≫ T.hom := p.w.symm
    let f : T ⟶ J := Over.homMk d hdOver
    have hpf : p ≫ f = m := Over.OverMorphism.ext hd
    refine ⟨f, pic0Map_fieldExtension_injective k Omega C T ?_⟩
    change pic0Map C p (pic0Map C f u) = pic0Map C p x
    calc
      _ = pic0Map C (p ≫ f) u := (pic0Map_comp_apply k C p f u).symm
      _ = pic0Map C m u := congrArg (fun g => pic0Map C g u) hpf
      _ = pic0Map C p x := hm

/-- A class with the correct separably closed comparison represents `Pic^0` on every test.
The carrier and class are supplied explicitly; this does not construct their descent data. -/
def pic0RepresentableBy_of_fieldExtension : (pic0TypeFunctor C).RepresentableBy J where
  homEquiv {T} := Equiv.ofBijective (fun f : T ⟶ J => pic0Map C f u)
    (pic0_eval_bijective_of_fieldExtension k Omega C J u beta hu T)
  homEquiv_comp f g := pic0Map_comp_apply k C f g u

/-- The descended representation evaluates by pullback of the supplied universal class. -/
@[simp]
theorem pic0RepresentableBy_of_fieldExtension_homEquiv
    {T : Over (Spec (.of k))} (f : T ⟶ J) :
    (pic0RepresentableBy_of_fieldExtension k Omega C J u beta hu).homEquiv f =
      pic0Map C f u := rfl

end

end AlgebraicGeometry
