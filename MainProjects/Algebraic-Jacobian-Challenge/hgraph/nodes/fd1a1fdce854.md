---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.SmoothOfRelativeDimension.exists_isDedekindDomain_section
docstring: 'Every point of an integral scheme smooth of relative dimension `1` over
  a field lies in

  an affine open whose section ring is a Dedekind domain: a standard smooth chart
  of relative

  dimension `1`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/StalksDVR.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.SmoothOfRelativeDimension.exists_isDedekindDomain_section
type: lean
updated: '2026-07-28T18:12:20'
---
theorem SmoothOfRelativeDimension.exists_isDedekindDomain_section
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] (x : X) :
    ∃ V : X.Opens, IsAffineOpen V ∧ x ∈ V ∧ IsDedekindDomain Γ(X, V) := by
  obtain ⟨U, hU, V, hV, hxV, e, hsm⟩ :=
    SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension (n := 1) (f := f) x
  -- The base affine open is nonempty, hence is all of the one-point space `Spec K`.
  have hUtop : U = ⊤ := by
    have hsub : Subsingleton (Spec (CommRingCat.of K)) :=
      inferInstanceAs (Subsingleton (PrimeSpectrum K))
    refine TopologicalSpace.Opens.ext (Set.eq_univ_of_forall fun y => ?_)
    exact Subsingleton.elim (f.base x) y ▸ e hxV
  subst hUtop
  letI : Field Γ(Spec (CommRingCat.of K), ⊤) :=
    ((Scheme.ΓSpecIso (CommRingCat.of K)).commRingCatIsoToRingEquiv.toMulEquiv.isField
      (Field.toIsField K)).toField
  haveI : Nonempty V := ⟨⟨x, hxV⟩⟩
  algebraize [(f.appLE ⊤ V e).hom]
  exact ⟨V, hV, hxV, Algebra.IsStandardSmoothOfRelativeDimension.isDedekindDomain
    Γ(Spec (CommRingCat.of K), ⊤) Γ(X, V)⟩