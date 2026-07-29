---
author: sync
content_type: theorem
created: '2026-07-17T16:57:11'
decl: AlgebraicGeometry.Scheme.RationalMap.exists_germ_stalkPullback_notMem_range_of_notMem_domain
docstring: '**The pole-existence corollary (substep 3 + landed 4a).** Let `F : Y ⤏
  Z`

  be a rational map over an affine base with `Y` integral, locally Noetherian

  and with regular stalks, `Z` locally of finite type over the base, and `V` an

  affine open of `Z` containing the generic image. If `F` is **not** defined at

  `P`, then some section `s ∈ Γ(Z, V)` has generic germ pullback `Λ s ∈ K(Y)`

  that is non-regular at a coheight-one point `w ⤳ P`.'
file: AlgebraicJacobian/Albanese/Milne33Pullback.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.RationalMap.exists_germ_stalkPullback_notMem_range_of_notMem_domain
type: lean
updated: '2026-07-29T15:26:26'
---
theorem Scheme.RationalMap.exists_germ_stalkPullback_notMem_range_of_notMem_domain
    {Y Z S : Scheme.{u}} [IsIntegral Y] [IsAffine S] [IsLocallyNoetherian Y]
    (hreg : ∀ y : ↥Y, IsRegularLocalRing (Y.presheaf.stalk y))
    (qY : Y ⟶ S) (qZ : Z ⟶ S) [LocallyOfFiniteType qZ] (F : Y.RationalMap Z)
    (hFover : F.fromFunctionField ≫ qZ
      = Y.fromSpecStalk (genericPoint ↥Y) ≫ qY)
    {V : Z.Opens} (hV : IsAffineOpen V)
    (hγV : F.fromFunctionField (closedPoint Y.functionField) ∈ V)
    (P : ↥Y) (hP : P ∉ F.domain) :
    ∃ s : Γ(Z, V), ∃ w : ↥Y, w ⤳ P ∧ Order.coheight w = 1 ∧
      (Z.presheaf.germ V (F.fromFunctionField (closedPoint Y.functionField)) hγV
          ≫ F.stalkPullback) s
        ∉ (algebraMap (Y.presheaf.stalk w) Y.functionField).range := by
  have hne : ¬ ∀ s : Γ(Z, V),
      (Z.presheaf.germ V (F.fromFunctionField (closedPoint Y.functionField)) hγV
          ≫ F.stalkPullback) s
        ∈ (algebraMap (Y.presheaf.stalk P) Y.functionField).range := fun H =>
    hP (Scheme.RationalMap.mem_domain_of_forall_germ_mem_range qY qZ F hFover
      hV hγV P H)
  push Not at hne
  obtain ⟨s, hs⟩ := hne
  obtain ⟨w, hwP, hcw, hw⟩ :=
    Scheme.exists_specializes_coheight_eq_one_of_notMem_stalk_range Y hreg P _ hs
  exact ⟨s, w, hwP, hcw, hw⟩