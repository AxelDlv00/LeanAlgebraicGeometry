/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.ProjectiveMorphismBasic
import Mathlib.AlgebraicGeometry.AffineSpace
import Mathlib.AlgebraicGeometry.ZariskisMainTheorem

/-!
# Finite-morphism embeddings

This file supplies two pieces of the standard proof that finite morphisms are
projective. Over an affine target, a finite morphism is a closed subscheme of
finite-dimensional affine space. At the other end of the compactification
argument, a proper immersion into projective space is already closed.

The remaining geometric step is to place the affine embedding in a projective
chart and globalize it over the target. These results isolate both sides of
that step without adding a projectivity hypothesis.
-/

open CategoryTheory Limits MvPolynomial

noncomputable section

universe u

namespace AlgebraicGeometry

namespace Scheme.Hom.IsProjective

variable {X S : Scheme.{u}} {pi : X ⟶ S}

/-- A proper morphism that factors through projective space by an immersion is
projective. Properness makes the immersion closed. -/
theorem of_isProper_of_immersion (hpi : IsProper pi) {n : Type u} [Finite n]
    (i : X ⟶ ℙ(n; S)) (hi : IsImmersion i)
    (hcomp : i ≫ (ℙ(n; S) ↘ S) = pi) : pi.IsProjective := by
  letI : IsImmersion i := hi
  haveI : IsProper (i ≫ (ℙ(n; S) ↘ S)) := hcomp ▸ hpi
  haveI : IsProper i := IsProper.of_comp i (ℙ(n; S) ↘ S)
  haveI : IsClosedImmersion i :=
    (IsClosedImmersion.iff_isProper_and_mono (f := i)).mpr
      ⟨inferInstance, inferInstance⟩
  exact ⟨n, inferInstance, i, inferInstance, hcomp⟩

end Scheme.Hom.IsProjective

namespace IsFinite

/-- A finite morphism over an affine target is a closed subscheme of a
finite-dimensional affine space over that target. -/
theorem exists_closedImmersion_affineSpace {X Y : Scheme.{u}} (f : X ⟶ Y)
    [IsFinite f] [IsAffine Y] :
    ∃ (n : Type u) (_ : Finite n) (i : X ⟶ 𝔸(n; Y)),
      IsClosedImmersion i ∧ i ≫ (𝔸(n; Y) ↘ Y) = f := by
  letI : IsAffine X := isAffine_of_isAffineHom f
  letI : Algebra Γ(Y, ⊤) Γ(X, ⊤) := RingHom.toAlgebra f.appTop.hom
  haveI : Module.Finite Γ(Y, ⊤) Γ(X, ⊤) := f.finite_appTop
  obtain ⟨n, hn, q, hq⟩ :=
    Algebra.FiniteType.iff_quotient_mvPolynomial'.mp
      (inferInstance : Algebra.FiniteType Γ(Y, ⊤) Γ(X, ⊤))
  letI : Fintype n := hn
  let i : X ⟶ 𝔸(n; Y) :=
    AffineSpace.homOfVector f fun j => q (MvPolynomial.X j)
  refine ⟨n, inferInstance, i, ?_, AffineSpace.homOfVector_over _ _⟩
  apply IsClosedImmersion.of_surjective_of_isAffine
  intro x
  obtain ⟨p, rfl⟩ := hq x
  refine ⟨(AffineSpace.isoOfIsAffine n Y).hom.appTop
    ((Scheme.ΓSpecIso (.of (MvPolynomial n Γ(Y, ⊤)))).inv p), ?_⟩
  rw [AffineSpace.isoOfIsAffine_hom_appTop]
  simp only [CommRingCat.comp_apply, Iso.inv_hom_id_apply]
  change (i.appTop.hom.comp
    (eval₂Hom (𝔸(n; Y) ↘ Y).appTop.hom (AffineSpace.coord Y))) p = q.toRingHom p
  apply DFunLike.congr_fun ?_ p
  apply MvPolynomial.ringHom_ext
  · intro r
    simp only [RingHom.comp_apply, eval₂Hom_C]
    rw [show q.toRingHom (C r) = f.appTop.hom r by
      change q (C r) = f.appTop.hom r
      exact q.commutes r]
    have h := congrArg Scheme.Hom.appTop (AffineSpace.homOfVector_over f
      (fun j => q (MvPolynomial.X j)))
    rw [Scheme.Hom.comp_appTop] at h
    exact congrArg (fun e : Γ(Y, ⊤) ⟶ Γ(X, ⊤) => e.hom r) h
  · intro j
    simp [i]

end IsFinite

end AlgebraicGeometry
