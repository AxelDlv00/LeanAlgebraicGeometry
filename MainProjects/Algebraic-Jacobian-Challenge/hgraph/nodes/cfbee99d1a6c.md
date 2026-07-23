---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.coherentSheafFlat_id_of_charts
docstring: '**Flatness over the identity from an affine cover of flat sections**:

  if the sections of `G` over each member of an affine open cover of `T` are

  flat over the respective section rings, then `G` is flat over `T` via

  `𝟙 T`.'
file: AlgebraicJacobian/Picard/FlatteningStratificationUniversal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.coherentSheafFlat_id_of_charts
type: lean
updated: '2026-07-24T03:02:10'
---
theorem coherentSheafFlat_id_of_charts (G : T.Modules) [G.IsQuasicoherent]
    {ι : Type u} (Wc : ι → T.Opens) (hWc : ∀ j, IsAffineOpen (Wc j))
    (hcover : ∀ y : T, ∃ j, y ∈ Wc j)
    (hflat : ∀ j, Module.Flat Γ(T, Wc j) Γ(G, Wc j)) :
    Scheme.CoherentSheafFlat (𝟙 T) G := by
  intro U hU V hV eV
  exact flat_section_of_affine_cover (𝟙 T) G Wc hWc Wc hWc
    (fun j => le_refl _) hcover
    (fun j => (flat_compHom_congr
      ((𝟙 T : T ⟶ T).appLE (Wc j) (Wc j) (le_refl _)).hom
      (id_appLE_apply _)).mpr (hflat j)) hU hV eV

end FlatBridge

/-! ## §2 The rank dictionary -/

section RankDictionary

variable {T : Scheme.{u}} (G : T.Modules) [G.IsQuasicoherent]