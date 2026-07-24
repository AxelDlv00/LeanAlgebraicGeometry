---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isCompact
docstring: '**qcqs section localization** (the quasi-compact generalization of the
  gap2 keystone;

  Stacks 01P0 / `lemma-invert-f-sections` beyond the affine case). For a quasi-coherent
  sheaf

  of modules `M` on a scheme `X` and a *quasi-compact, quasi-separated* open `W ⊆
  X`, the

  section restriction `Γ(M, W) → Γ(M, D(g))` at any `g : Γ(X, W)` exhibits the target
  as the

  localization `Γ(M, W)[1/g]` over `Γ(X, W)`. `map_units` holds because `g` restricts
  to a

  unit of `Γ(X, D(g))` (`RingedSpace.isUnit_res_basicOpen`); `surj`/`exists_of_eq`
  are the

  Mayer–Vietoris induction engines `exists_res_eq_pow_smul_of_isCompact` /

  `exists_pow_smul_res_eq_zero_of_isCompact` instantiated at `U := W`. Project-local:

  Mathlib has no qcqs section-localization at the pinned commit.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isCompact
type: lean
updated: '2026-07-25T06:32:31'
---
theorem isLocalizedModule_basicOpen_of_isCompact
    (M : X.Modules) [M.IsQuasicoherent] {W : X.Opens}
    (hW : IsCompact (W : Set X)) (hsep : IsQuasiSeparated (W : Set X))
    (g : Γ(X, W))
    [Module Γ(X, W) Γ(M, X.basicOpen g)]
    [IsScalarTower Γ(X, W) Γ(X, X.basicOpen g) Γ(M, X.basicOpen g)] :
    IsLocalizedModule (Submonoid.powers g) (restrictBasicOpenₗ M g) where
  map_units s := by
    obtain ⟨k, hk⟩ := s.2
    have hu : IsUnit (algebraMap Γ(X, W) Γ(X, X.basicOpen g) (s : Γ(X, W))) := by
      rw [← hk, map_pow]
      exact (X.toLocallyRingedSpace.toRingedSpace.isUnit_res_basicOpen g).pow k
    exact isUnit_algebraMap_end_of_isUnit_algebraMap hu
  surj y := by
    have hDW : X.basicOpen g ≤ W ⊓ X.basicOpen g := le_inf (X.basicOpen_le g) le_rfl
    obtain ⟨x, k, hx⟩ := exists_res_eq_pow_smul_of_isCompact M g hsep W hW le_rfl
      (M.presheaf.map (homOfLE (inf_le_right : W ⊓ X.basicOpen g ≤ X.basicOpen g)).op y)
    refine ⟨⟨x, ⟨g ^ k, k, rfl⟩⟩, ?_⟩
    have e1 : (g ^ k : Γ(X, W)) • y
        = X.presheaf.map (homOfLE (X.basicOpen_le g)).op g ^ k • y := by
      rw [← algebraMap_smul Γ(X, X.basicOpen g) (g ^ k) y, map_pow]
      rfl
    have e2 := congrArg (M.presheaf.map (homOfLE hDW).op) hx
    rw [res_res M (inf_le_left : W ⊓ X.basicOpen g ≤ W) hDW (X.basicOpen_le g) x,
      map_smul, map_pow,
      resRing_res ((inf_le_left : W ⊓ X.basicOpen g ≤ W).trans le_rfl) hDW
        (X.basicOpen_le g) g,
      res_res M (inf_le_right : W ⊓ X.basicOpen g ≤ X.basicOpen g) hDW le_rfl y,
      res_self M y] at e2
    change (g ^ k : Γ(X, W)) • y = M.presheaf.map (homOfLE (X.basicOpen_le g)).op x
    rw [e1, e2]
  exists_of_eq {x₁ x₂} h := by
    have h' := congrArg
      (M.presheaf.map (homOfLE (inf_le_right : W ⊓ X.basicOpen g ≤ X.basicOpen g)).op) h
    rw [show restrictBasicOpenₗ M g x₁
        = M.presheaf.map (homOfLE (X.basicOpen_le g)).op x₁ from rfl,
      show restrictBasicOpenₗ M g x₂
        = M.presheaf.map (homOfLE (X.basicOpen_le g)).op x₂ from rfl,
      res_res M (X.basicOpen_le g) (inf_le_right : W ⊓ X.basicOpen g ≤ X.basicOpen g)
        (inf_le_left : W ⊓ X.basicOpen g ≤ W) x₁,
      res_res M (X.basicOpen_le g) (inf_le_right : W ⊓ X.basicOpen g ≤ X.basicOpen g)
        (inf_le_left : W ⊓ X.basicOpen g ≤ W) x₂] at h'
    have h0 : M.presheaf.map (homOfLE (inf_le_left : W ⊓ X.basicOpen g ≤ W)).op
        (x₁ - x₂) = 0 := by
      rw [map_sub, h', sub_self]
    obtain ⟨k, hk⟩ := exists_pow_smul_res_eq_zero_of_isCompact M g W hW le_rfl (x₁ - x₂) h0
    rw [resRing_self g, smul_sub] at hk
    exact ⟨⟨g ^ k, k, rfl⟩, sub_eq_zero.mp hk⟩