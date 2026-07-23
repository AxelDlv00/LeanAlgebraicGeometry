---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.module_finite_sections_of_quasicoherentData
docstring: '**Affine sections of a finitely presented module sheaf are finitely generated**

  (Stacks 01PC, finite-type half; chart-level form). If `F` is quasi-coherent, `q`
  is

  a quasi-coherence datum with finite presentations, and `V ≤ q.X i` is an affine

  open, then `Γ(F, V)` is a finite `Γ(X, V)`-module. The generating sections of the

  slice `F.over (q.X i)` geometrize, pull back to `Spec Γ(X, V)` along the

  factorization of `hV.fromSpec` through the cover member, land on `tilde Γ(F, V)`

  by the 01I8 identification, and force finite generation via

  `module_finite_of_tilde_genSections`. Project-local.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.module_finite_sections_of_quasicoherentData
type: lean
updated: '2026-07-16T21:14:27'
---
theorem module_finite_sections_of_quasicoherentData {X : Scheme.{u}} (F : X.Modules)
    [F.IsQuasicoherent] (q : SheafOfModules.QuasicoherentData.{u, u, u, u} F)
    [q.IsFinitePresentation] (i : q.I) {V : X.Opens} (hV : IsAffineOpen V)
    (hle : V ≤ q.X i) :
    Module.Finite Γ(X, V) Γ(F, V) := by
  -- slice generators of the cover member, with their finiteness
  haveI hσ₀ : (q.presentation i).generators.IsFiniteType := inferInstance
  -- the open-immersion factorization `k` of `fromSpec` through the cover member
  have hrange : Set.range hV.fromSpec.base ⊆ Set.range (Scheme.Opens.ι (q.X i)).base := by
    rw [hV.range_fromSpec, Scheme.Opens.range_ι]
    exact hle
  haveI hklift : IsOpenImmersion
      (IsOpenImmersion.lift (Scheme.Opens.ι (q.X i)) hV.fromSpec hrange ≫
        Scheme.Opens.ι (q.X i)) := by
    rw [IsOpenImmersion.lift_fac]
    infer_instance
  haveI hk : IsOpenImmersion
      (IsOpenImmersion.lift (Scheme.Opens.ι (q.X i)) hV.fromSpec hrange) :=
    IsOpenImmersion.of_comp _ (Scheme.Opens.ι (q.X i))
  haveI : PreservesColimitsOfSize.{u, u, u, u, u + 1, u + 1}
      (Scheme.Modules.pullback
        (IsOpenImmersion.lift (Scheme.Opens.ι (q.X i)) hV.fromSpec hrange)) :=
    (Scheme.Modules.pullbackPushforwardAdjunction _).leftAdjoint_preservesColimits
  -- pseudofunctoriality: composite pullback = pullback of `fromSpec`
  let e₄ : (Scheme.Modules.pullback
      (IsOpenImmersion.lift (Scheme.Opens.ι (q.X i)) hV.fromSpec hrange)).obj
        ((Scheme.Modules.pullback (Scheme.Opens.ι (q.X i))).obj F) ≅
      (Scheme.Modules.pullback hV.fromSpec).obj F :=
    (Scheme.Modules.pullbackComp
        (IsOpenImmersion.lift (Scheme.Opens.ι (q.X i)) hV.fromSpec hrange)
        (Scheme.Opens.ι (q.X i))).app F ≪≫
      (Scheme.Modules.pullbackCongr (IsOpenImmersion.lift_fac _ _ hrange)).app F
  -- the 01I8 tilde identification of the pullback along `fromSpec`
  obtain ⟨⟨e₅, -⟩⟩ := tildeIso_of_isQuasicoherent_isAffineOpen F hV
  -- transport the generators all the way onto the tilde
  let σ₆ : (tilde (ModuleCat.of Γ(X, V) Γ(F, V))).GeneratingSections :=
    (((((q.presentation i).generators.map
        (overRestrictEquiv (q.X i)).functor (overRestrictUnitIso (q.X i))).ofEpi
          (overRestrictPullbackIso (q.X i) F).hom).map
        (Scheme.Modules.pullback
          (IsOpenImmersion.lift (Scheme.Opens.ι (q.X i)) hV.fromSpec hrange))
        (pullbackOpenImmersionUnitIso
          (IsOpenImmersion.lift (Scheme.Opens.ι (q.X i)) hV.fromSpec hrange)).symm).ofEpi
      e₄.hom).ofEpi e₅.hom
  haveI : σ₆.IsFiniteType := inferInstanceAs
    ((((((q.presentation i).generators.map _ _).ofEpi _).map _ _).ofEpi _).ofEpi
      e₅.hom).IsFiniteType
  exact module_finite_of_tilde_genSections (ModuleCat.of Γ(X, V) Γ(F, V)) σ₆