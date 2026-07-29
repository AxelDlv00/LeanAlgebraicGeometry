---
author: sync
content_type: theorem
created: '2026-07-30T05:41:29'
decl: AlgebraicGeometry.Scheme.exists_moduleFinite_subalgebra_factorization
docstring: '**The finite level, as a chart-independent statement**: for a scheme `X`
  locally of finite

  type over `k` and an **algebraic** extension `Ks/k`, every `Ks`-point of `X` over
  `k` factors

  through `Spec` of a `k`-subalgebra `A ⊆ Ks` that is a **finite** `k`-module.


  The conclusion names the point: `p` is *equal* to the composite through `Spec A`,
  so this cannot

  be satisfied by an arbitrary small `A` — the vacuity trap of `HasDivFunctor`, which
  this

  statement was rewritten to avoid after a first draft asserted only that some finite
  subalgebra

  exists (true of `⊥` on any input).


  Everything is used: `LocallyOfFiniteType` for the chart''s section ring, algebraicity
  of `Ks` for

  integrality, and `hp` (that `p` lies over `Spec k`) for the compatibility triangle
  without which

  the range would be a subalgebra of `Ks` over nothing.'
file: AlgebraicJacobian/Curve/FiniteLevelRationalPoint.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.exists_moduleFinite_subalgebra_factorization
type: lean
updated: '2026-07-30T05:41:29'
---
theorem exists_moduleFinite_subalgebra_factorization {k Ks : Type u} [Field k] [Field Ks]
    [Algebra k Ks] [Algebra.IsAlgebraic k Ks] {X : Scheme.{u}}
    (f : X ⟶ Spec (CommRingCat.of k)) [LocallyOfFiniteType f]
    (p : Spec (CommRingCat.of Ks) ⟶ X)
    (hp : p ≫ f = Spec.map (CommRingCat.ofHom (algebraMap k Ks))) :
    ∃ (A : Subalgebra k Ks) (_ : Module.Finite k A) (q : Spec (CommRingCat.of A) ⟶ X),
      Spec.map (CommRingCat.ofHom (A.val.toRingHom)) ≫ q = p := by
  classical
  obtain ⟨V, hxV⟩ := exists_affineOpens_mem (p.base (IsLocalRing.closedPoint Ks))
  have hV : IsAffineOpen V.1 := V.2
  have hrange := range_subset_range_ι_of_mem p V.1 hxV
  set p' := IsOpenImmersion.lift ((V.1).ι) p hrange with hp'
  have hfac : p' ≫ (V.1).ι = p := IsOpenImmersion.lift_fac _ _ _
  set pS : Spec (CommRingCat.of Ks) ⟶ Spec Γ(X, V.1) := p' ≫ hV.isoSpec.hom with hpSdef
  have hpS : pS ≫ hV.fromSpec = p := by
    rw [hpSdef, ← hV.isoSpec_inv_ι, Category.assoc, Iso.hom_inv_id_assoc, hfac]
  set psi : Γ(X, V.1) ⟶ CommRingCat.of Ks := (Spec.fullyFaithful.preimage pS).unop with hpsidef
  have hpsi : pS = Spec.map psi := by
    -- `simpa` is required here: the linter's suggested `simp` hits `maxRecDepth` on the
    -- `Spec (CommRingCat.of ↑Γ(X, V))` vs `Spec Γ(X, V)` coercion, measured both ways.
    set_option linter.unnecessarySimpa false in
    simpa [hpsidef] using (Spec.fullyFaithful.map_preimage pS).symm
  set fV : CommRingCat.of k ⟶ Γ(X, V.1) :=
    (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ f.appLE ⊤ V.1 (by simp) with hfVdef
  have hft : (fV.hom).FiniteType := by
    rw [hfVdef, CommRingCat.hom_comp]
    exact (finiteType_appLE_of_locallyOfFiniteType f V).comp
      (RingHom.FiniteType.of_surjective _
        (ConcreteCategory.bijective_of_isIso (Scheme.ΓSpecIso (CommRingCat.of k)).inv).2)
  have hSpecfV : Spec.map fV = hV.fromSpec ≫ f := by
    rw [hfVdef, Spec.map_comp,
      ← IsAffineOpen.SpecMap_appLE_fromSpec f (isAffineOpen_top _) hV (by simp)]
    congr 1
    simp [IsAffineOpen.fromSpec_top]
  have hcomm : (psi.hom).comp (fV.hom) = algebraMap k Ks := by
    have h2 : Spec.map (fV ≫ psi) = Spec.map (CommRingCat.ofHom (algebraMap k Ks)) := by
      rw [Spec.map_comp, ← hpsi, hSpecfV, ← Category.assoc, hpS, hp]
    simpa using congrArg CommRingCat.Hom.hom (Spec.map_injective h2)
  refine ⟨Algebra.adjoin k (Set.range psi.hom),
    moduleFinite_adjoin_range_of_finiteType fV.hom psi.hom hft hcomm,
    Spec.map (CommRingCat.ofHom ((psi.hom).codRestrict _
      (fun b => Algebra.subset_adjoin ⟨b, rfl⟩))) ≫ hV.fromSpec, ?_⟩
  have hcomp : CommRingCat.ofHom ((psi.hom).codRestrict
      (Algebra.adjoin k (Set.range psi.hom))
      (fun b => Algebra.subset_adjoin ⟨b, rfl⟩)) ≫
      CommRingCat.ofHom ((Algebra.adjoin k (Set.range psi.hom)).val.toRingHom) = psi := by
    ext b
    rfl
  rw [← Category.assoc, ← Spec.map_comp, hcomp, ← hpsi, hpS]