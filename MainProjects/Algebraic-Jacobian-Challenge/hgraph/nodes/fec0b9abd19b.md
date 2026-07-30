---
author: sync
content_type: theorem
created: '2026-07-31T02:29:39'
decl: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.openSectionsEquiv_algebraMap
docstring: The section-ring equivalence respects the structural `k`-algebra map.
file: AlgebraicJacobian/Picard/FiniteMapProjectiveImmersion.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.openSectionsEquiv_algebraMap
type: lean
updated: '2026-07-31T02:29:39'
---
theorem openSectionsEquiv_algebraMap (U : C.left.Opens) (c : k) :
    openSectionsEquiv U (algebraMap k Γ(C.left, U) c) =
      (U.ι ≫ C.hom).appTop.hom
        ((Scheme.ΓSpecIso (.of k)).inv.hom c) := by
  change (U.ι.appLE U ⊤ U.ι_preimage_self.ge).hom
      (algebraMap k Γ(C.left, U) c) = _
  have hL : algebraMap k Γ(C.left, U) c =
      (C.left.presheaf.map (homOfLE (le_top : U ≤ ⊤)).op).hom
        (C.hom.appTop.hom ((Scheme.ΓSpecIso (.of k)).inv.hom c)) := rfl
  rw [hL]
  change (C.left.presheaf.map (homOfLE (le_top : U ≤ ⊤)).op ≫
      U.ι.appLE U ⊤ U.ι_preimage_self.ge).hom
        (C.hom.appTop.hom ((Scheme.ΓSpecIso (.of k)).inv.hom c)) = _
  rw [Scheme.Hom.map_appLE, Scheme.Hom.comp_appTop]
  simp only [Scheme.Hom.appLE, Scheme.Hom.preimage_top, homOfLE_refl,
    op_id, CommRingCat.comp_apply]
  have hid := congrArg
    (fun q : Γ(U.toScheme, ⊤) ⟶ Γ(U.toScheme, ⊤) ↦ q.hom
      (U.ι.appTop.hom (C.hom.appTop.hom
        ((Scheme.ΓSpecIso (.of k)).inv.hom c))))
    (U.toScheme.presheaf.map_id (Opposite.op (⊤ : U.toScheme.Opens)))
  simpa using hid