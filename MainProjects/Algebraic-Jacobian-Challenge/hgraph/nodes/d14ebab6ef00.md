---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Grassmannian.freeCompare_naturality_core
docstring: '**Free-pullback coherence for the quotient re-presentation** — the

  naturality core of `freeCompare`: pulling back along `ψ : T'' ⟶ T` in `Over S`

  commutes with the re-presentation of the source through

  `Scheme.Modules.pullbackFreeIso`.  Assembled from the congruence absorptions

  and the free coherence `pullbackFreeIso_comp` of `GlueDescent.lean`.'
file: AlgebraicJacobian/Picard/GrassmannianRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Grassmannian.freeCompare_naturality_core
type: lean
updated: '2026-07-16T21:14:27'
---
lemma freeCompare_naturality_core {r : ℕ} {T T' : Over S} (ψ : T' ⟶ T) :
    (Scheme.Modules.pullbackFreeIso T'.hom (Fin r)).inv ≫
      (pullbackTriangleIso (Over.w ψ)
        (SheafOfModules.free (R := S.ringCatSheaf) (Fin r))).inv
    = (Scheme.Modules.pullbackFreeIso ψ.left (Fin r)).inv ≫
      (Scheme.Modules.pullback ψ.left).map
        (Scheme.Modules.pullbackFreeIso T.hom (Fin r)).inv := by
  -- Step A: absorb the `pullbackCongr` cast into the free-pullback comparison.
  have hA : (Scheme.Modules.pullbackFreeIso T'.hom (Fin r)).inv ≫
      (Scheme.Modules.pullbackCongr (Over.w ψ)).inv.app
        (SheafOfModules.free (R := S.ringCatSheaf) (Fin r))
      = (Scheme.Modules.pullbackFreeIso (ψ.left ≫ T.hom) (Fin r)).inv := by
    rw [Scheme.Modules.pullbackCongr_inv_app (Over.w ψ)]
    rw [← Scheme.Modules.pullbackCongr_hom_app (Over.w ψ).symm]
    exact Scheme.Modules.pullbackFreeIso_inv_congr (Over.w ψ).symm (Fin r)
  -- Step B: invert the free coherence `pullbackFreeIso_comp`.
  have hB : (Scheme.Modules.pullbackFreeIso (ψ.left ≫ T.hom) (Fin r)).inv ≫
      (Scheme.Modules.pullbackComp ψ.left T.hom).inv.app
        (SheafOfModules.free (R := S.ringCatSheaf) (Fin r))
      = (Scheme.Modules.pullbackFreeIso ψ.left (Fin r)).inv ≫
        (Scheme.Modules.pullback ψ.left).map
          (Scheme.Modules.pullbackFreeIso T.hom (Fin r)).inv := by
    rw [← cancel_mono ((Scheme.Modules.pullback ψ.left).map
      (Scheme.Modules.pullbackFreeIso T.hom (Fin r)).hom)]
    rw [Category.assoc, Category.assoc, ← Functor.map_comp, Iso.inv_hom_id,
      CategoryTheory.Functor.map_id, Category.comp_id]
    rw [Scheme.Modules.pullbackComp_inv_app_free_map ψ.left T.hom (Fin r)]
    exact Iso.inv_hom_id_assoc _ _
  simp only [pullbackTriangleIso, Iso.trans_inv, Iso.app_inv]
  rw [← Category.assoc, hA]
  exact hB

set_option backward.isDefEq.respectTransparency false in