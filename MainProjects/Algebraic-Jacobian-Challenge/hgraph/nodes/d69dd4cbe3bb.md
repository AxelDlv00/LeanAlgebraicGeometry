---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushforwardSliceAdjunctionH1
docstring: '**Counit compatibility square `H₁`** for the slice adjunction (blueprint

  `lem:pushforward_slice_adjunction_h1`).  The reverse ring map `φ''''` and the forward
  slice ring map

  `ψ_r` satisfy the counit-naturality square required by `pushforwardPushforwardAdj`,
  absorbing the

  `Over.map (unitIso.inv)` correction of the inverse functor (reduces to a proof-irrelevant

  equality-transport identity along `φ.hom⁻¹ᵁ (φ.inv⁻¹ᵁ Uᵢ) = Uᵢ`).'
file: AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushforwardSliceAdjunctionH1
type: lean
updated: '2026-07-16T21:14:26'
---
lemma pushforwardSliceAdjunctionH1 :
    Functor.whiskerRight (NatTrans.op (sliceOversEquiv φ Ui).symm.toAdjunction.counit)
        (Sheaf.over X.ringCatSheaf Ui).obj =
      (sliceStructureSheafHom φ Ui).hom ≫
        (sliceOversEquiv φ Ui).symm.inverse.op.whiskerLeft (sliceReverseRingMap φ Ui).hom := by
  ext U x
  simp only [sliceReverseRingMap, sliceStructureSheafHom]
  simp [Scheme.Hom.toRingCatSheafHom]
  -- The two structure-sheaf comparisons `φ.inv.c` and `φ.hom.c` compose to the restriction of
  -- `𝒪_X` along the open identity `φ.hom⁻¹ᵁ φ.inv⁻¹ᵁ W = W` (`comp_app` + `congr_app φ.hom_inv_id`).
  have key : φ.inv.c.app (op ((unop U).left)) ≫
      φ.hom.c.app (op (((sliceOversEquiv φ Ui).functor.obj (unop U)).left))
      = X.sheaf.obj.map (Over.Hom.left ((sliceOversEquiv φ Ui).unitInv.app (unop U))).op := by
    show φ.inv.app ((unop U).left) ≫ φ.hom.app _ = _
    rw [← Scheme.Hom.comp_app, Scheme.Hom.congr_app φ.hom_inv_id]
    simp only [Scheme.Hom.id_app]
    congr 1
  have key2 : (forget₂ CommRingCat RingCat).map (φ.inv.c.app (op ((unop U).left))) ≫
      (forget₂ CommRingCat RingCat).map
        (φ.hom.c.app (op (((sliceOversEquiv φ Ui).functor.obj (unop U)).left)))
      = (forget₂ CommRingCat RingCat).map
        (X.sheaf.obj.map (Over.Hom.left ((sliceOversEquiv φ Ui).unitInv.app (unop U))).op) := by
    rw [← (forget₂ CommRingCat RingCat).map_comp]
    exact congrArg _ key
  exact DFunLike.congr_fun (congrArg RingCat.Hom.hom key2.symm) x