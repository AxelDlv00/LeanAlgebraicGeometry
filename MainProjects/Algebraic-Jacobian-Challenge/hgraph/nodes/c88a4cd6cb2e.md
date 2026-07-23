---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.pullback_isLocallyFreeOfRank
docstring: '**Pullback preserves rank-`d` local freeness.** If `M` is locally free
  of rank `d` on

  `T`, then `φ^* M` is locally free of rank `d` on `T''`, for any scheme morphism
  `φ`. The

  chart cover `{U i}` of `T` trivialising `M` pulls back to the cover `{φ⁻¹ U i}`
  of `T''`;

  on each member the restriction of `φ^* M` is identified with the pulled-back chart-free

  sheaf via the pseudofunctor comparison `pullbackComp`, the factorisation

  `φ ∘ (φ⁻¹ U i).ι = (φ ∣_ U i) ≫ (U i).ι` (`morphismRestrict_ι`), and `pullbackFreeIso`.

  Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullback_isLocallyFreeOfRank
type: lean
updated: '2026-07-16T21:14:27'
---
lemma pullback_isLocallyFreeOfRank {T' T : Scheme.{u}} (φ : T' ⟶ T) {M : T.Modules}
    {d : ℕ} (h : SheafOfModules.IsLocallyFreeOfRank M d) :
    SheafOfModules.IsLocallyFreeOfRank ((Scheme.Modules.pullback φ).obj M) d := by
  obtain ⟨ι, U, hcover, hloc⟩ := h
  refine ⟨ι, fun i => φ ⁻¹ᵁ (U i), Scheme.Hom.iSup_preimage_eq_top φ hcover, ?_⟩
  intro i
  obtain ⟨e⟩ := hloc i
  exact ⟨(Scheme.Modules.pullbackComp (φ ⁻¹ᵁ (U i)).ι φ).app M ≪≫
    (Scheme.Modules.pullbackCongr (morphismRestrict_ι φ (U i)).symm).app M ≪≫
    ((Scheme.Modules.pullbackComp (φ ∣_ (U i)) (U i).ι).app M).symm ≪≫
    (Scheme.Modules.pullback (φ ∣_ (U i))).mapIso e ≪≫
    pullbackFreeIso (φ ∣_ (U i)) (ULift.{u} (Fin d))⟩